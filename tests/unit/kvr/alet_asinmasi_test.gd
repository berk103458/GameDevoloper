extends SceneTree
var hata := 0
func kontrol(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 for tur in ["tarla", "tas_ocagi", "demir_madeni"]:
  var kat := Katalog.new()
  kat.yukle()
  var o := Oturum.new(kat, 40)
  var y := o.yonetim
  y.a = y.a.duplicate(true)
  y.a.ambar_taban_kapasite = 10000
  y.kaynaklar.kapasite = 10000
  y.akce = 1000
  for t in Kaynaklar.TURLER: y.kaynaklar.ekle(t, 100)
  var b := kur(y, tur)
  kontrol(b != null, "Gerçek bina kurulumu: " + tur)
  if b == null: continue
  var k := y.kabul({"sinif": "ciftci" if tur == "tarla" else "madenci", "stat": 5})
  k.moral = 50
  y.ata(k.id, b.id)
  y.kaynaklar.stok["alet"] = 1
  y.alet_asinma = 0.9
  var tam := AtamaOnizlemesi.brut(y, b)
  var u := {}
  y._uret(u, [])
  kontrol(y.kaynaklar.miktar("alet") == 0 and is_equal_approx(y.alet_asinma, 0.0), "Son alet gerçek çalışma sonunda aşınır: " + tur)
  for t in tam:
   kontrol(is_equal_approx(float(u.get(t, 0)) + float(y._artik.get("%d:%s" % [b.id, t], 0)), float(tam[t])), "Son aletli iş tam verim: " + tur)
  var once := y._artik.duplicate()
  u.clear()
  y._uret(u, [])
  for t in tam:
   var anahtar := "%d:%s" % [b.id, t]
   var brut: float = float(u.get(t, 0)) + float(y._artik.get(anahtar, 0)) - float(once.get(anahtar, 0))
   kontrol(is_equal_approx(brut, float(tam[t]) * float(DemirZinciri.AYAR.aletsiz_carpan)), "Sonraki aletsiz iş düşük verim: " + tur)
  kontrol(y.alet_asinma == 0.0, "Aletsiz iş aşınma borcu üretmez")
  var kayit := y.kaydet()
  var rng := y._rng.state
  kontrol(AletAsinmaBilgisi.tip(y).contains("%30"), "Oyuncu düşük verimi öğrenir")
  kontrol(y.kaydet() == kayit and y._rng.state == rng, "İpucu salt okunur")
 print("ALET AŞINMASI: GEÇTİ" if hata == 0 else "ALET AŞINMASI: KALDI")
 quit(hata)
func kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim(tur, h)["olur"]:
    var b := y.bina(y.bina_kur(tur, h)["id"])
    b.insa_kalan = 0
    return b
 return null
