extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 var o := Oturum.new(kat, 140)
 o.koy_akce = 50
 o.muhafiz_akce = 17
 o.yonetim.kaynaklar = Kaynaklar.new(150, {"gida": 100, "odun": 20})
 var k := o.yonetim.kabul({"sinif": "asker", "stat": 5})
 o.yonetim.muhafiz_ata(k.id)
 var once := o.kaydet()
 var f := GeceBilancosu.fotograf(o)
 dene(o.kaydet() == once, "Açılış fotoğrafı salt okunur")
 var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(once)))
 var sonuc := o.gece_sonu()
 var b: Dictionary = sonuc.bilanco
 dene(b.kamu.once == 50 and b.kamu.sonra == o.koy_akce and b.kamu.maas == 1, "Gerçek maaş ve kamu kapanışı")
 dene(b.kisisel.once == 17 and b.kisisel.sonra == 17 and b.kisisel.net == 0, "Kişisel kasa ayrı")
 for tur in Kaynaklar.TURLER:
  var s: Dictionary = b.stok[tur]
  dene(s.net == s.uretim - s.tuketim - s.bozulma - s.tasma_gece + s.diger_net and s.sonra == o.yonetim.kaynaklar.miktar(tur), "Stok mutabakatı: " + tur)
 dene(b.kamu.net == b.kamu.vergi - b.kamu.maas + b.kamu.diger_net, "Kamu mutabakatı")
 dene(geri.gece_sonu().bilanco == b, "Restore aynı bilançoyu üretir")
 once = o.kaydet()
 GeceBilancosu.olustur(o, f, sonuc.rapor)
 dene(o.kaydet() == once, "Bilanço hesaplama RNG/oyun değiştirmez")
 b.stok.gida.sonra = -100
 dene(o.yonetim.kaynaklar.miktar("gida") >= 0, "Rapor kopyası canlı stoğa bağlı değildir")
 var bos := Oturum.new(kat, 141)
 bos.yonetim.kaynaklar = Kaynaklar.new(150, {"gida": 100, "tas": 20})
 bos.yonetim.kaynaklar.kapasite = 80
 var r := bos.gece_sonu()
 dene(r.bilanco.stok.gida.tasma_bildirimi == 40 and r.bilanco.stok.gida.tasma_gece == 0, "Gündüz taşması gece kaybı olarak tekrar sayılmaz")
 dene(r.bilanco.stok.gida.net == -int(r.rapor.ziyan.bozulma.get("gida", 0)), "Gerçek gece yalnız bozulma kaybı")
 var faz_foto := GeceBilancosu.fotograf(bos)
 bos.yonetim.kaynaklar.kapasite = 20
 var faz_rapor := {"gun": bos.gun, "olaylar": [], "uretim": {}, "tuketim": {}, "ziyan": {}}
 var faz_b := GeceBilancosu.olustur(bos, faz_foto, faz_rapor)
 dene(faz_b.stok.gida.tasma_gece > 0 and faz_b.stok.gida.net == -faz_b.stok.gida.tasma_gece and faz_b.stok.gida.diger_net == 0, "Bakım sonrası yeni taşma oluştuğu gece kayıp sayılır")
 var sonraki := bos.gece_sonu()
 dene(sonraki.bilanco.stok.gida.tasma_gece == 0 and sonraki.bilanco.stok.gida.tasma_bildirimi > 0, "Yeni taşma ertesi gece yeniden gider yazılmaz")
 var vergi_o := Oturum.new(kat, 142)
 vergi_o.yonetim.kabul({"sinif": "ciftci", "stat": 5})
 vergi_o.gun = vergi_o.yonetim.a.mevsim_gun - 1
 var vergi_bedel := VergiPolitikasi.bedel(vergi_o.yonetim)
 var vr := vergi_o.gece_sonu()
 dene(vr.bilanco.kamu.vergi == vergi_bedel and vr.bilanco.kamu.net == vergi_bedel, "Tahsil edilmiş haftalık vergi raporda")
 var borclu := Oturum.new(kat, 143)
 var asker := borclu.yonetim.kabul({"sinif": "asker", "stat": 5})
 borclu.yonetim.muhafiz_ata(asker.id)
 borclu.koy_akce = -5
 var br := borclu.gece_sonu()
 dene(br.bilanco.kamu.maas == 0, "Ödenmeyen maaş nakit gider sayılmaz")
 borclu.koy_akce = 100
 borclu.yonetim.muhafiz_ata(asker.id)
 br = borclu.gece_sonu()
 dene(br.bilanco.kamu.maas == 2, "Eski borç ve yeni ücret gerçek ödemeye dahildir")
 _ilk_geceler(kat)
 print("GECE BİLANÇOSU: GEÇTİ" if hata == 0 else "GECE BİLANÇOSU: KALDI")
 quit(hata)

func _ilk_geceler(kat: Katalog) -> void:
 var acilis = preload("res://src/sistemler/kapi_acilis_olayi.gd")
 var o := Oturum.new(kat, 305)
 preload("res://src/sistemler/acilis_senaryosu.gd").kur(o)
 acilis.baslat(o)
 acilis.ulak_bitir(o)
 var aile: Gelen = acilis.kuyruk(o)[0]
 o.ziyaret_basladi(aile)
 dene(o.karar_ver(aile, &"kabul").get("kaldi", false), "OGR-05 gerçek kabul")
 var yuklu := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
 dene(yuklu != null, "OGR-05 gün içi ziyaret kaydı yüklenir")
 if yuklu == null: return
 var ilk: Dictionary = yuklu.gece_sonu().bilanco.kapi_ozeti
 dene(ilk.gelenler.size() == 2 and ilk.gelenler.has(o.tr_gelen(aile)), "OGR-05 ulak ve aile ilk raporda")
 dene(ilk.kalanlar == ["Ali", "Zeynep"], "OGR-05 yalnız gerçek kabul edilenler kalır")
 for gun in [1, 2, 3]:
  var b: Dictionary = yuklu.gece_sonu().bilanco
  dene(b.gun == gun and b.has("kapi_ozeti") == (gun < 3), "OGR-05 gece sınırı: %d" % gun)
  if b.has("kapi_ozeti"):
   dene(b.kapi_ozeti.gelenler.is_empty() and b.kapi_ozeti.kalanlar.is_empty(), "OGR-05 önceki gece tekrar gösterilmez")
