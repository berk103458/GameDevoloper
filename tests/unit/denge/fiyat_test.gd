extends SceneTree
## Bölüm 32.7 ölçümü — fiyat eğrisi. Ölçülen sistemler yeniden kurulmaz; TUC-09,
## TUC-10, TUC-11 ve EKO-15 mevcut davranışı okunur. Kod sabiti yok.
var hata := 0
var kat: Katalog

func _initialize() -> void:
 kat = Katalog.new()
 kat.yukle()
 _den50()
 _den51()
 _den52()
 _den55()
 _den56()
 print("FİYAT ÖLÇÜMÜ: GEÇTİ" if hata == 0 else "FİYAT ÖLÇÜMÜ: KALDI")
 quit(hata)

func _kontrol(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)

func _oturum(tohum: int = 76) -> Oturum:
 return Oturum.new(kat, tohum)

## DEN-50: Kış odunu yaz odunundan pahalıdır; kış fiyatı = yaz fiyatı × çarpan.
func _den50() -> void:
 var y := _oturum().yonetim
 y.gun = 7
 var yaz := TicaretFiyatlari.sat_birim(y, "odun")
 var yaz_al := TicaretFiyatlari.al_birim(y, "odun")
 var yaz_carpan := TicaretFiyatlari.carpan(y, "odun")
 y.gun = 23
 var kis := TicaretFiyatlari.sat_birim(y, "odun")
 var kis_al := TicaretFiyatlari.al_birim(y, "odun")
 var kis_carpan := TicaretFiyatlari.carpan(y, "odun")
 _kontrol(kis > yaz, "DEN-50 kış odunu yaz odunundan pahalı")
 var oran := kis_carpan / yaz_carpan
 _kontrol(kis == yaz * oran, "DEN-50 kış fiyatı = yaz fiyatı çarpı çarpan")
 _kontrol(kis / yaz == oran, "DEN-50 ölçülen oran TUC-09 çarpanına uyar; sapma yüzde 0")
 _kontrol(kis_al > yaz_al and kis_al / yaz_al == oran, "DEN-50 alış fiyatı aynı tek çarpanı izler")

## DEN-51: Erzak bitince fiyat tavandadır; tavan TUC-09 tablosundadır, üstü yok.
func _den51() -> void:
 var y := _oturum().yonetim
 var tavan := 0.0
 for c in TicaretFiyatlari.AYAR.mevsim_carpani:
  tavan = maxf(tavan, float(c))
 _kontrol(tavan == float(TicaretFiyatlari.AYAR.mevsim_carpani[3]), "DEN-51 tavan tek kaynak: TUC-09 kış çarpanı")
 y.kaynaklar.stok["gida"] = 0
 y.gun = 23
 _kontrol(TicaretFiyatlari.carpan(y, "gida") == tavan, "DEN-51 erzak 0, fiyat tavanda")
 _kontrol(TicaretFiyatlari.al_birim(y, "gida") == 0.5 * tavan, "DEN-51 tavan fiyatı taban çarpı tavan")
 y.kaynaklar.stok["gida"] = 200
 _kontrol(TicaretFiyatlari.al_birim(y, "gida") == 0.5 * tavan, "DEN-51 stok fiyatı tavanın üstüne çıkarmaz")
 var asildi := false
 for gun in [0, 7, 14, 23]:
  y.gun = gun
  for tur in TicaretFiyatlari.AYAR.urunler:
   if TicaretFiyatlari.carpan(y, tur) > tavan:
    asildi = true
 _kontrol(not asildi, "DEN-51 hiçbir mevsim/ürün tavanın üstünde değil")

## DEN-52: Oyuncu satışı iki kasaya ayrı yazılır; on satışta karışma 0.
func _den52() -> void:
 var o := _oturum()
 var y := o.yonetim
 o.koy_akce = 200
 o.muhafiz_akce = 20
 y.kaynaklar.kapasite = 1000
 y.kaynaklar.stok["odun"] = 500
 var kamu := 0
 var kisisel := 0
 var karisma := 0
 for gun in [3, 4, 7, 8, 11]:
  y.gun = gun
  var kamu_once := o.koy_akce
  var kisisel_once := o.muhafiz_akce
  var r := PazarSatisi.uygula(o, "odun", 10, true, false)
  if r.akce > 0:
   kamu += 1
   if o.koy_akce != kamu_once + int(r.akce) or o.muhafiz_akce != kisisel_once:
    karisma += 1
  kamu_once = o.koy_akce
  kisisel_once = o.muhafiz_akce
  var rk := PazarSatisi.uygula(o, "odun", 10, true, true)
  if rk.akce > 0:
   kisisel += 1
   if o.koy_akce != kamu_once or o.muhafiz_akce != kisisel_once + int(rk.akce):
    karisma += 1
 _kontrol(kamu == 5 and kisisel == 5, "DEN-52 on satış iki kanalda koştu")
 _kontrol(karisma == 0, "DEN-52 karışma 0: resmi satış köy akçesine, kişisel satış muhafız akçesine")

## DEN-55: Fiyat gece raporunda kaynağıyla durur; kış gecesinde satır var, yazda yok.
func _den55() -> void:
 var kis_o := _oturum()
 kis_o.yonetim.gun = 23
 kis_o.yonetim.kabul({"sinif": "ciftci", "stat": 5})
 var kb: Dictionary = kis_o.gece_sonu().bilanco
 var satir: Dictionary = kb.get("kis_carpani", {})
 _kontrol(kb.has("kis_carpani"), "DEN-55 kış gecesinde bilançoda fiyat satırı var")
 _kontrol(float(satir.get("carpan", 0.0)) == float(TicaretFiyatlari.AYAR.mevsim_carpani[3]), "DEN-55 satır TUC-09 kış çarpanını taşır")
 _kontrol(String(satir.get("kaynak", "")) == "mevsim_carpani", "DEN-55 satır kaynağı yazar")
 var yaz_o := _oturum(77)
 yaz_o.yonetim.gun = 7
 _kontrol(not yaz_o.gece_sonu().bilanco.has("kis_carpani"), "DEN-55 yaz gecesinde satır yok")

## DEN-56: Karaborsa fiyatı kişisel kasadadır; bir alış, iki kasa.
func _den56() -> void:
 var o := _oturum()
 var y := o.yonetim
 y.gun = 15
 y.akce = 1000
 o.muhafiz_akce = 100
 var fiyat := int(KaraborsaAdaptoru.AYAR["yasak_muhur"].fiyat)
 _kontrol(KaraborsaAdaptoru.al(o, "yasak_muhur"), "DEN-56 karaborsa alışı gerçekleşti")
 _kontrol(o.muhafiz_akce == 100 - fiyat, "DEN-56 alış kişisel kasadan düşer")
 _kontrol(y.akce == 1000, "DEN-56 köy akçesi düşmez")
