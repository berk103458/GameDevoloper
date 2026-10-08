extends SceneTree
var hata := 0
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 22)
 var y := o.yonetim
 y.a = y.a.duplicate(true)
 y.a.ambar_taban_kapasite = 10000
 y.kaynaklar.kapasite = 10000
 y.akce = 1000
 for t in ["odun", "tas", "gida", "alet"]: y.kaynaklar.ekle(t, 100)
 var tarla := kur(y, "tarla")
 var bostan := kur(y, "bostan")
 for b in [tarla, bostan]:
  dene(bool(y.katalog.veri(b.tur).get("kis_durur", false)), "İki mevcut tarım türü aynı kış kuralını taşır")
  var k := y.kabul({"ad": "Çiftçi", "sinif": "ciftci", "stat": 5})
  k.moral = 50
  dene(y.ata(k.id, b.id), "Gerçek tarım görevi")
  dene(y.recete_sec(b.id, "bugday"), "Buğday tarifi korunur")
 y.gun = 21
 var once := y.kaynaklar.kaydet()
 var u := {}
 y._uret(u, [])
 dene(u.is_empty() and y.kaynaklar.kaydet() == once and tarla.bekliyor == "kis" and bostan.bekliyor == "kis", "Kış tarlası/bostanı stok/kesir üretmez")
 var geri := KoyYonetimi.kayittan(y.a, y.katalog, JSON.parse_string(JSON.stringify(y.kaydet())))
 var r := y.gece()
 dene(r.uretim.is_empty() and r.tuketim.gida == 2 and r.tuketim.odun == 2, "Gerçek kış gecesi yalnız mevcut erzak/yakacağı tüketir")
 dene(geri.gece() == r, "Kayıt dönüşü aynı kış raporu")
 for k in y.koylular: dene(k.is_yeri == KoyYonetimi.BOSTA and k.kis_oncesi_is >= 0, "Kışta çiftçi mevcut görev dönüşü kaydında")
 y.gun = 28
 r = y.gece()
 dene(int(r.uretim.get("bugday", 0)) > 0 and int(r.tuketim.get("odun", 0)) == 0, "Gerçek bahar gecesi tarım ve aynı görev yeniden çalışır")
 for k in y.koylular: dene(k.is_yeri >= 0 and k.kis_oncesi_is == -1, "Bahar eski tarım görevine döner")
 IklimDeneyi.degistir(o, 1, "kar_firtinasi")
 u = {}
 y._uret(u, [])
 dene(u.is_empty(), "Yazdaki zorlanmış kar fırtınası aynı tarım kuralını kullanır")
 print("DONMUŞ TOPRAK: GEÇTİ" if hata == 0 else "DONMUŞ TOPRAK: KALDI")
 quit(hata)
func kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx, cy)
   if y.yerlesim(tur, h).olur:
    var b := y.bina(y.bina_kur(tur, h).id)
    b.insa_kalan = 0
    return b
 return null
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
