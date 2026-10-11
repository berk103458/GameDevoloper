extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1;push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,1911)
 o.yonetim.gun=15 # HAR-11 ağırlıklarını alışma süresi bittikten sonra denetle.
 var ids: Array[StringName]=[&"chr_001",&"chr_003",&"chr_021"]
 for guvenlik in [3,4,7,8]:
  o.yonetim.asayis_riski=100-guvenlik*10
  var once:=JSON.stringify(o.kaydet())
  var w:=GuvenlikKafileDengesi.adli_agirliklar(o,ids)
  var sw:=GuvenlikKafileDengesi.sinif_agirliklar(o)
  dene(w[0]==(3.0 if guvenlik<4 else 1.0),"Casus/çete eşiği3/4")
  dene(w[1]==(2.0 if guvenlik>7 else 1.0),"Esnaf eşiği7/8")
  dene(sw[1]==(2.0 if guvenlik>7 else 1.0),"Gerçek esnaf sınıfı ağırlığı")
  dene(JSON.stringify(o.kaydet())==once,"Ağırlık okuması saf; gizli bayrak/kadro/RNG yazılmaz")
 o.yonetim.asayis_riski=40
 var rng:=RandomNumberGenerator.new();rng.state=o._rng.state
 for i in 50:
  dene(GuvenlikKafileDengesi.adli_indeks(o,ids)==rng.randi_range(0,2) and o._rng.state==rng.state,"Orta güvenlik eski RNG tam eşit")
  dene(GuvenlikKafileDengesi.sinif_sec(o)==Katalog.SINIFLAR[rng.randi_range(0,2)] and o._rng.state==rng.state,"Orta sınıf RNG tam eşit")
 var risk: Array[float]=[3.0,1.0,1.0]
 dene(GuvenlikKafileDengesi.aralik(risk,0.59)==0 and GuvenlikKafileDengesi.aralik(risk,0.6)==1 and GuvenlikKafileDengesi.aralik(risk,0.99)==2,"Risk3/5 olasılık sınırları")
 var ticaret: Array[float]=[1.0,2.0,1.0]
 dene(GuvenlikKafileDengesi.aralik(ticaret,0.25)==1 and GuvenlikKafileDengesi.aralik(ticaret,0.749)==1 and GuvenlikKafileDengesi.aralik(ticaret,0.75)==2,"Esnaf1/2 olasılık sınırları")
 # Uygunlar: kadro kendi en erken/dönüş/istendi sözleşmesinden geçmeyeni alamaz.
 o.yonetim.asayis_riski=100;o.ayarlar=o.ayarlar.duplicate(true);o.ayarlar.adli_olasiligi=1.0
 var uygun:=o.kadro.uygunlar(o.gun)
 var kuyruk:=o.gece_kuyrugu()
 var gorulen: Array[StringName]=[]
 for g in kuyruk:
  if g.id==&"": continue
  dene(g.id in uygun and g.id not in gorulen,"Yalnız gerçek uygun; mükerrer adlı yok")
  gorulen.append(g.id)
 dene(not gorulen.is_empty(),"Gerçek düşük güvenlik kuyruğu")
 var kayit: Variant=JSON.parse_string(JSON.stringify(o.kaydet()))
 var a:=Oturum.kayittan(kat,kayit)
 var b:=Oturum.kayittan(kat,kayit)
 for i in 50: dene(GuvenlikKafileDengesi.adli_indeks(a,ids)==GuvenlikKafileDengesi.adli_indeks(b,ids) and a._rng.state==b._rng.state,"JSON deterministik devam")
 # Kervan geçici güvenlik kaybı aynı göstergenin parçasıdır.
 o.yonetim.asayis_riski=20
 var k:=o.yonetim.kabul({"sinif":"asker","stat":5})
 o.yonetim.kervan_koruma[str(k.id)]={"baslangic":o.gun,"donus":o.gun+2}
 dene(GuvenlikKafileDengesi.sinif_agirliklar(o)[1]==1.0,"Kervan dış görev Güvenlik8'i eşik altına indirir")
 print("GUVENLIK KAFILE: GEÇTİ" if hata==0 else "GUVENLIK KAFILE: KALDI")
 quit(hata)
