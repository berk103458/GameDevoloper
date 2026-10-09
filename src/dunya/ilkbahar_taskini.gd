class_name IlkbaharTaskini
extends RefCounted
const META := &"ilkbahar_taskini"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ilkbahar_taskini.json"))
## Optional kayıt yalnız bounded yıl/gün ve bent kırılması alanlarını kabul eder.
static func oku(v: Variant) -> Dictionary:
 var r := {"yil":0,"hasar":false,"son_gece":-1,"secim_gunu":-1}
 if not v is Dictionary: return r
 for alan in ["yil", "son_gece", "secim_gunu"]:
  var n: Variant = v.get(alan)
  if (n is int or n is float) and is_finite(float(n)) and float(n) == floor(float(n)) and float(n) >= (0 if alan == "yil" else -1) and float(n) <= 1000000000: r[alan] = int(n)
 if v.get("hasar") is bool and int(r.yil) >= 2: r.hasar = v.hasar
 return r
## Canlı modele kopya verilmez; kayıt/önizleme yalnız durumu okur.
static func durum(y: KoyYonetimi) -> Dictionary:
 return oku(y.get_meta(META, {}))
## Eski/bozuk yükleme aynı güvenli sözleşmeden geçer.
static func yukle(y: KoyYonetimi, v: Variant) -> void:
 y.set_meta(META, oku(v))
## İlk gerçek bahar gecesinde kar erimesi bendi kırar; kirli su mevcut sağlık fazından önce etki eder.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
 var r := durum(y)
 if r.son_gece == y.gun: return
 r.son_gece = y.gun
 var takvim := MevsimYoneticisi.durum(y)
 if y.gun > 0 and y.mevsim() == 0 and takvim.yil_gunu == 1 and takvim.yil > int(r.yil) and y.nufus() > 0:
  r.yil = takvim.yil
  r.hasar = true
  olaylar.append({"anahtar":"Kar erimesi su bendini kırdı; kuyu suyu kirlendi. Taş ve kireçle onarım gerekli.","deger":[]})
 if r.hasar:
  KuyuKirliligi.kirlet(y) # Kırık bent yeni kirlenmeyi besler; onarım ayrı kalır.
  for k in y.koylular: k.saglik = maxi(0, k.saglik - int(AYAR.kirli_su_saglik))
  olaylar.append({"anahtar":"Kırık bent/kirli kuyu: kişi başına −%d sağlık.","deger":[int(AYAR.kirli_su_saglik)]})
 y.set_meta(META, r)
## Mevcut gece olay kartında onarım/erteleme; yeni kuyruk veya HUD yok.
static func olay(o: Oturum) -> OlayVerisi:
 var r := durum(o.yonetim)
 if not r.hasar or r.secim_gunu == o.yonetim.gun or o.yonetim.son != "": return null
 var e := OlayVerisi.new()
 e.id = StringName("mev06_bent_%d_%d" % [r.yil, o.yonetim.gun])
 e.baslik_anahtari = "İlkbahar taşkını · kırık su bendi"
 e.metin_anahtari = "Kar erimesi su bendini kırdı. Kuyu suyunu temizlemek için %d taş ve %d kireç harca; geciktirirsen kirli su sağlık kaybı sürer." % [int(AYAR.onarim.tas), int(AYAR.onarim.kirec)]
 e.secenek_anahtarlari = PackedStringArray(["Bendi onar ve kuyuyu kireçle temizle", "Bu gece ertele · moral −%d" % int(AYAR.ertele_moral)])
 e.secenek_etkileri = [{}, {}]
 return e
## Yalnız mevcut bekleyen olayın gün/yıl kimliği tanınır.
static func tanimli(e: OlayVerisi) -> bool:
 return e != null and String(e.id).begins_with("mev06_bent_")
## İkinci tıklama/eskimiş kart/eksik kaynak hiçbir etki yapmaz.
static func uygun(o: Oturum, e: OlayVerisi, i: int) -> bool:
 if not tanimli(e) or i < 0 or i > 1 or o.yonetim.son != "": return false
 var r := durum(o.yonetim)
 if not r.hasar or r.secim_gunu == o.yonetim.gun or e.id != StringName("mev06_bent_%d_%d" % [r.yil, o.yonetim.gun]): return false
 return i == 1 or o.yonetim.kaynaklar.yeterli(AYAR.onarim)
## Onarım aynı ortak ambardan atomik harcanır; para/RNG/normal olay etkileri tekrarlanmaz.
static func uygula(o: Oturum, e: OlayVerisi, i: int) -> Dictionary:
 var sonuc := {"ok":false,"kirilan":-1,"rusvet_harcandi":-1,"sonuc_anahtari":"Bent seçimi güncel değil veya onarım kaynağı eksik.","oyun_puan":-1}
 if not uygun(o, e, i): return sonuc
 var r := durum(o.yonetim)
 if i == 0:
  if not o.yonetim.kaynaklar.harca(AYAR.onarim): return sonuc
  r.hasar = false
  KuyuKirliligi.temizle(o.yonetim) # Onarım bedelindeki kireç ikinci kez harcanmaz.
  sonuc.sonuc_anahtari = "Su bendi onarıldı; kuyu kireçle temizlendi. Kirli su sağlık kaybı durdu."
 else:
  for k in o.yonetim.koylular: k.moral = maxi(0, k.moral - int(AYAR.ertele_moral))
  sonuc.sonuc_anahtari = "Bent onarımı ertelendi. Kirli su sağlık kaybı sürer; sonraki gece onarım tekrar sunulur."
 r.secim_gunu = o.yonetim.gun
 o.yonetim.set_meta(META, r)
 sonuc.ok = true
 return sonuc
