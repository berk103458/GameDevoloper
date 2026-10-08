extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := hazir(kat, 7, 1)
 var y := o.yonetim
 var once := JSON.stringify(o.kaydet())
 var ids := DonmaYoneticisi.risk(y)
 dene(ids.size() == 3 and ids[0] < ids[1] and ids[1] < ids[2] and JSON.stringify(o.kaydet()) == once, "Üç en zayıf kişi, kararlı id ve salt okunur önizleme")
 var geri := Oturum.kayittan(kat, JSON.parse_string(once))
 var rapor := y.gece()
 dene(rapor.olenler.size() == 3 and y.nufus() == 4 and rapor.tuketim.odun == 0 and rapor.tuketim.gida == 7, "Tek gece hesabında en çok üç soğuk ölümü; tüketim bir kez")
 dene(geri.yonetim.gece() == rapor, "Kayıt dönüşünde aynı risk ve gece")
 for k in y.koylular: dene(k.saglik >= 1, "Kalan zayıf köylü soğuk sınırı")
 o = hazir(kat, 1, 1)
 dene(o.yonetim.gece().olenler.size() == 1, "Tek savunmasız kişinin donma riski")
 o = hazir(kat, 7, 100)
 dene(DonmaYoneticisi.risk(o.yonetim).is_empty(), "Sağlıklı köylü anında öldürülmez")
 rapor = o.yonetim.gece()
 dene(rapor.olenler.is_empty() and o.yonetim.koylular[0].saglik == 100 - o.yonetim.a.soguk_saglik, "EKO-09 mevcut soğuk sağlık kaybı korunur")
 o = hazir(kat, 7, 1)
 o.yonetim.kaynaklar.ekle("odun", 7)
 dene(DonmaYoneticisi.risk(o.yonetim).is_empty(), "Tam yakacak riski kapatır")
 rapor = o.yonetim.gece()
 dene(rapor.olenler.is_empty() and rapor.tuketim.odun == 7, "Tam yakacak yalnız bir kez tüketilir")
 o = hazir(kat, 3, 1)
 IklimDeneyi.degistir(o, 0, "normal")
 dene(DonmaYoneticisi.risk(o.yonetim).is_empty() and o.yonetim.gece().olenler.is_empty(), "İlkbahar yakacak yokken donma yaratmaz")
 o = hazir(kat, 0, 100)
 dene(DonmaYoneticisi.risk(o.yonetim).is_empty() and o.yonetim.gece().olenler.is_empty(), "Boş köy risk/odun yaratmaz")
 print("DONMA YÖNETİCİSİ: GEÇTİ" if hata == 0 else "DONMA YÖNETİCİSİ: KALDI")
 quit(hata)
func hazir(kat: Katalog, n: int, saglik: int) -> Oturum:
 var o := Oturum.new(kat, 76)
 o.yonetim.gun = 21
 o.yonetim.kaynaklar.azalt("odun", 1000)
 o.yonetim.kaynaklar.ekle("gida", 50)
 for i in n:
  var k := o.yonetim.kabul({"ad": "Soğuk köylüsü %d" % i, "stat": 5})
  k.saglik = saglik
  k.moral = 50
 return o
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
