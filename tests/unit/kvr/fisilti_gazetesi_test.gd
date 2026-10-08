extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,92)
 var y:=o.yonetim
 var k:=y.kabul({"ad":"Masum köylü","adli_id":"chr_003"})
 var stok:=y.kaynaklar.kaydet()
 var rng:=y._rng.state
 var kisi:=JSON.stringify(k.kaydet())
 var para:=y.akce
 var olaylar: Array[Dictionary]=[]
 FisiltiGazetesi.gece(y,olaylar)
 dene(olaylar.size()==1 and FisiltiGazetesi.durum(y).bekliyor and FisiltiGazetesi.durum(y).kisi==k.id,"İlk sabah tek gerçek isimli imzasız pusula")
 dene(y.kaynaklar.kaydet()==stok and y._rng.state==rng and y.akce==para and JSON.stringify(k.kaydet())==kisi and CasusGeceTakibi.acik_izler(y).is_empty() and DivanOturumu.adaylar(y).is_empty(),"Masum söylenti kanıt/fiil/hasar/zar/bayrak değildir")
 var e:=o.olay_sec()
 dene(FisiltiGazetesi.tanimli(e) and e.metin_anahtari.contains(k.ad) and e.metin_anahtari.contains("söylentidir"),"Mevcut sabah kartında iddia etiketi")
 var z:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
 dene(z.olay_sec().id==e.id and z.olay_sec().metin_anahtari==e.metin_anahtari,"JSON bekleyen kart kimliğini korur")
 FisiltiGazetesi.gece(y,olaylar)
 dene(olaylar.size()==1,"Aynı gece tekrar pusula yok")
 for i in 4:
  y.gun+=1
  FisiltiGazetesi.gece(y,olaylar)
 dene(olaylar.size()==1 and o.olay_sec().id==e.id,"Çözülmemiş pusula ezilmez")
 dene(not o.secenek_olur(e,2) and o.olay_uygula(e,0).ok and FisiltiGazetesi.durum(y).secim==0,"Arşiv seçim makbuzu")
 var once:=JSON.stringify(o.kaydet())
 dene(not o.olay_uygula(e,0).ok and JSON.stringify(o.kaydet())==once,"Çift seçim etkisiz")
 y.gun=6
 FisiltiGazetesi.gece(y,olaylar)
 e=o.olay_sec()
 dene(FisiltiGazetesi.tanimli(e) and o.olay_uygula(e,1).ok and FisiltiGazetesi.durum(y).secim==1 and DivanOturumu.adaylar(y).is_empty(),"Yeni uygun gece söylenti reddi hüküm değildir")
 dene(not FisiltiGazetesi.oku({"gun":0,"kisi":1,"metin":999,"bekliyor":true}).bekliyor and not FisiltiGazetesi.oku({"bekliyor":true}).bekliyor,"Bozuk pusula güvenli")
 # Gizli kimlik/fiil değişse de aynı isim ve gün aynı iddiayı üretir.
 var a:=Oturum.new(kat,1)
 var b:=Oturum.new(kat,2)
 var ak:=a.yonetim.kabul({"ad":"Aynı isim"})
 var bk:=b.yonetim.kabul({"ad":"Aynı isim","adli_id":"chr_009","gizli_bayraklar":["haydut"]})
 CasusGeceTakibi.kaydet(b.yonetim,bk,"kuyu",-1,"zehirleme","saglik",4,false)
 FisiltiGazetesi.gece(a.yonetim,[])
 FisiltiGazetesi.gece(b.yonetim,[])
 dene(FisiltiGazetesi.olay(a).metin_anahtari==FisiltiGazetesi.olay(b).metin_anahtari,"Gizli kaynak oyuncuya sızmaz")
 a.yonetim.set_meta(CasusDevriyesi.META,{"son_gece":0,"kisi":ak.id,"gun":0,"bekliyor":true,"secim":-1})
 dene(CasusDevriyesi.tanimli(a.olay_sec()),"Gerçek suçüstü kartı söylentiden önce")
 var bos:=Oturum.new(kat,1)
 FisiltiGazetesi.gece(bos.yonetim,[])
 dene(FisiltiGazetesi.olay(bos)==null,"Nüfus yoksa uydurma kişi yok")
 var gercek:=Oturum.new(kat,5)
 gercek.yonetim.kabul({"ad":"Sabah komşusu"})
 var rapor:=gercek.gece_sonu()
 dene(FisiltiGazetesi.tanimli(rapor.olay) and FisiltiGazetesi.durum(gercek.yonetim).gun==0,"Gerçek gece sonu aynı sabah olay kartına bağlanır")
 y.son="terk"
 dene(FisiltiGazetesi.olay(o)==null,"Terminal kart yok")
 print("FISILTI GAZETESİ: GEÇTİ" if hata==0 else "FISILTI GAZETESİ: KALDI")
 quit(hata)
