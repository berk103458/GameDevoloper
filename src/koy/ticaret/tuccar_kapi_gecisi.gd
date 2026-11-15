## TUC-12: mevcut uzman takvimi, tek kapı makbuzu ve mevcut çift kasa.
class_name TuccarKapiGecisi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/tuccar_kapi_gecisi.json"))
## Yalnız bu adaptörün takvim ziyaretçisini işaretler; CHR kişileri değişmez.
static func ilgilenir(g: Gelen) -> bool:
 return g.has_meta(&"gezgin_kapi_varis") and g.has_meta(&"gezgin_kapi_id")
## Ziyaretin kapı sorumluluğu oluşunca bekleyen/ret karar ticareti engeller.
static func engel(y: KoyYonetimi) -> bool:
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 return d.aktif and int(y.tuccar_girisi.get("varis", -1)) == d.gelis_gunu and y.tuccar_girisi.get("karar", "") in ["bekliyor", "ret"]
## Mevcut kuyruğun önüne uzman ekler; normal/CHR ziyaretçiler silinmez.
static func ekle(o: Oturum, liste: Array[Gelen]) -> void:
 var y := o.yonetim
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 if not d.aktif or y.son != "" or SiparisIhlali.terk(y, d.tuccar.id): return
 if int(y.tuccar_girisi.get("varis", -1)) == d.gelis_gunu and y.tuccar_girisi.get("karar") != "bekliyor": return
 for mevcut in liste:
  if ilgilenir(mevcut) and mevcut.get_meta(&"gezgin_kapi_varis") == d.gelis_gunu: return
 y.tuccar_girisi = {"varis": int(d.gelis_gunu), "uzman": String(d.tuccar.id), "karar": "bekliyor", "alinan": 0}
 var g := Gelen.new()
 g.ad_anahtari = d.tuccar.ad
 g.sinif = StringName(AYAR.sinif)
 g.portre = String({"celep_hamdullah": "celep", "nalbur": "nalbur", "kumasci_aktar": "kumasci", "silah_tuccari": "silah_tuccari"}.get(String(d.tuccar.id), AYAR.portre))
 g.giris_anahtari = "Gezgin tüccar pazar konaklaması için kapıya geldi."
 g.acilis = "Resmi geçiş bacını ödeyebilirim; hızlı giriş istersen kesene ayrıca akçe bırakırım."
 g.secenekler = PackedStringArray(["harc", "rusvet", "ret"])
 g.set_meta(&"gezgin_kapi_varis", int(d.gelis_gunu))
 g.set_meta(&"gezgin_kapi_id", String(d.tuccar.id))
 liste.push_front(g)
## Tek başarılı tahsilat: resmi bac kamu, rüşvet şahsi; nüfus veya gün yaratmaz.
static func karar(o: Oturum, g: Gelen, secim: StringName) -> Dictionary:
 var y := o.yonetim
 var makbuz := y.tuccar_girisi
 var sonuc := {"engellendi": true, "kaldi": false, "kirilan": -1, "koylu_id": -1, "tuccar": true}
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 if not ilgilenir(g) or not d.aktif or y.son != "" or secim not in [&"harc", &"rusvet", &"ret"]: return sonuc
 if makbuz.get("karar") != "bekliyor" or makbuz.get("varis") != g.get_meta(&"gezgin_kapi_varis") or makbuz.get("uzman") != g.get_meta(&"gezgin_kapi_id") or makbuz.varis != d.gelis_gunu or SiparisIhlali.terk(y, makbuz.uzman): return sonuc
 var bedel := int(AYAR.bac) if secim == &"harc" else (int(AYAR.rusvet) if secim == &"rusvet" else 0)
 if secim == &"rusvet" and o.muhafiz_akce > 9223372036854775807 - bedel: return sonuc
 if secim == &"harc" and o.koy_akce > 9223372036854775807 - bedel: return sonuc
 makbuz.karar = String(secim)
 makbuz.alinan = bedel
 if secim == &"harc": o.koy_akce += bedel
 if secim == &"rusvet":
  o.muhafiz_akce += bedel
  y.adalet = clampi(y.adalet + int(AYAR.rusvet_adalet), 0, 100)
  y.asayis_riski = clampi(y.asayis_riski + int(AYAR.rusvet_asayis), 0, 100)
  o.bayraklar[&"rusvet_sayisi"] = int(o.bayraklar.get(&"rusvet_sayisi", 0)) + 1
 o.muhafiz_tecrubesi += 1
 o.koy.degisti.emit()
 sonuc.engellendi = false
 sonuc.kaldi = secim != &"ret"
 sonuc.alinan_akce = bedel
 if sonuc.kaldi: preload("res://src/koy/usta_defterleri.gd").ganimet(o,"tuccar",str(makbuz.varis) + ":" + String(makbuz.uzman))
 return sonuc
## Eski kayıt boş: tarihi takvim erişimi korunur; yalnız geçerli makbuz yüklenir.
static func oku(v: Variant) -> Dictionary:
 if not v is Dictionary or v.get("karar") not in ["bekliyor", "harc", "rusvet", "ret"]: return {}
 var uzman := false
 for u in GezginTuccarTakvimi.AYAR.uzmanlar:
  if u.id == v.get("uzman"): uzman = true
 if not uzman: return {}
 for alan in ["varis", "alinan"]:
  var n: Variant = v.get(alan)
  if not (n is int or n is float) or not is_finite(float(n)) or float(n) < 0 or float(n) > 1000000000 or floor(float(n)) != float(n): return {}
 return {"varis": int(v.varis), "uzman": String(v.uzman), "karar": String(v.karar), "alinan": int(v.alinan)}
