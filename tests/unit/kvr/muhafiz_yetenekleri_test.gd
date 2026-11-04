extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func kur(y: KoyYonetimi,tur: String) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h:=Vector2i(cx,cy)
   if y.yerlesim(tur,h).olur:
    var b:=y.bina(y.bina_kur(tur,h).id)
    b.insa_kalan=0
    return b
 return null
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,97)
 dene(not MuhafizYetenekleri.al(o,"goz_yumma") and not MuhafizYetenekleri.al(o,"uydurma"),"Eksik koşul/bilinmeyen seçim red")
 for i in range(20):
  var g:=Gelen.new()
  g.id=StringName("yetenek_%d"%i)
  o.karar_ver(g,&"rusvet")
 dene(o.muhafiz_tecrubesi==20 and MuhafizTerazisi.durum(o).rusvet==20,"Gerçek kararlar tecrübe/sayaç")
 dene(not MuhafizYetenekleri.al(o,"harac_kesme"),"Dal önceki yeteneği ister")
 o.muhafiz_akce=40
 var kamu:=o.koy_akce
 var stok:=o.yonetim.kaynaklar.kaydet()
 var rng:=o.yonetim._rng.state
 dene(MuhafizYetenekleri.al(o,"goz_yumma") and o.muhafiz_akce==30,"Tek kişisel bedel")
 var secim:=JSON.stringify(o.kaydet())
 dene(not MuhafizYetenekleri.al(o,"goz_yumma") and JSON.stringify(o.kaydet())==secim,"Çift tıklama tek seçim")
 var kaynak: Dictionary={"akce":3,"esyalar":[{"kaynak":"Hediye","adet":1}]}
 dene(MuhafizYetenekleri.rusvet(o,kaynak).akce==4 and kaynak.akce==3,"Yüzde50 aşağı yuvarlama, kaynak immutable")
 var once:=o.muhafiz_akce
 o.karar_ver(o._adli_gelen(&"chr_001"),&"rusvet")
 dene(o.muhafiz_akce==once+6,"Gerçek CHR dört akçe artık altı")
 dene(o.koy_akce==kamu and o.yonetim.kaynaklar.kaydet()==stok and o.yonetim._rng.state==rng,"Kamu/stok/zar dokunulmadı")
 dene(MuhafizYetenekleri.al(o,"harac_kesme"),"İkinci dal alındı")
 var y:=o.yonetim
 y.a=y.a.duplicate(true)
 y.a.ambar_taban_kapasite=10000
 y.kaynaklar.kapasite=10000
 y.akce=500
 for t in ["odun","gida","tas","kereste","alet","tomruk","bugday","harc","kirec","demir","cevher"]: y.kaynaklar.ekle(t,100)
 var b:=kur(y,"degirmen")
 dene(b!=null,"Gerçek işyeri kuruldu")
 if b==null: quit(1); return
 var calisan:=y.kabul({"ad":"Çalışan esnaf","sinif":"esnaf"})
 dene(y.ata(calisan.id,b.id),"Gerçek iş ataması")
 var diger: Array[Koylu]=[]
 for durum in ["cocuk","zindan","disarida","olu","issiz","ciftci"]:
  var k:=y.kabul({"ad":durum,"sinif":"esnaf"})
  k.is_yeri=b.id
  match durum:
   "cocuk": k.yas_grubu=&"cocuk"
   "zindan": k.bayrak_ekle(DivanHukmu.FLAG)
   "disarida": y.kervan_koruma[str(k.id)]={"baslangic":y.gun,"donus":y.gun+2,"varis":y.gun,"tuccar":"test","alinan":0}
   "olu": k.saglik=0
   "issiz": k.is_yeri=KoyYonetimi.BOSTA
   "ciftci": k.sinif=&"ciftci"
  diger.append(k)
 var moral:=calisan.moral
 var adalet:=y.adalet
 kamu=y.akce
 stok=y.kaynaklar.kaydet()
 rng=y._rng.state
 once=o.muhafiz_akce
 var moraller: Array=[]
 for k in diger: moraller.append(k.moral)
 var r:=MuhafizYetenekleri.harac(o)
 dene(r.akce==1 and r.kisi==1 and o.muhafiz_akce==once+1 and calisan.moral==moral-3 and y.adalet==adalet-2,"Tek gerçek esnaf geliri/sosyal bedel")
 dene(y.akce==kamu and y.kaynaklar.kaydet()==stok and y._rng.state==rng,"Haraç kamu/stok/zar değiştirmedi")
 for i in range(diger.size()): dene(diger[i].moral==moraller[i],"Tahsilat dışındaki kişi korunur")
 var kayit:=JSON.stringify(o.kaydet())
 dene(MuhafizYetenekleri.harac(o).akce==0 and JSON.stringify(o.kaydet())==kayit,"Aynı gece tekrar etkisiz")
 var geri:=Oturum.kayittan(kat,JSON.parse_string(kayit))
 dene(geri.muhafiz_yetenekleri==o.muhafiz_yetenekleri and MuhafizYetenekleri.harac(geri).akce==0,"JSON tek gece makbuzunu korur")
 var sinir:=Oturum.kayittan(kat,JSON.parse_string(kayit))
 sinir.muhafiz_akce=MuhafizYetenekleri.AKCE_AZAMI-4
 sinir.karar_ver(sinir._adli_gelen(&"chr_001"),&"rusvet")
 dene(sinir.muhafiz_akce==MuhafizYetenekleri.AKCE_AZAMI,"Bonus gerçek bakiye sınırına sığar")
 sinir.yonetim.gun+=1
 var sinir_kayit:=JSON.stringify(sinir.kaydet())
 dene(MuhafizYetenekleri.harac(sinir).akce==0 and JSON.stringify(sinir.kaydet())==sinir_kayit,"Haraç taşmada atomik etkisiz")
 # Önceki doğrudan kötü durum fixture'larının makbuzsuz bayrakları yüklemede ayıklanır.
 # Gerçek gece entegrasyonu yalnız geçerli tek iş atamasıyla sınanır.
 for k in geri.yonetim.koylular:
  if k.id!=calisan.id: k.is_yeri=KoyYonetimi.BOSTA
 geri.yonetim.gun+=1
 var gece_once:=geri.muhafiz_akce
 var gece:=geri.gece_sonu()
 dene(geri.muhafiz_akce==gece_once+1 and gece.bilanco.kisisel.net==1 and gece.rapor.olaylar.any(func(e: Dictionary) -> bool: return e.has("muhafiz_harac")),"Gerçek gece/bilanço/typed rapor entegrasyonu")
 var rapor: Dictionary={"olaylar":Array([],TYPE_DICTIONARY,"",null)}
 MuhafizYetenekleri.rapora_ekle(rapor,r)
 dene(rapor.olaylar.size()==1 and IflasYoneticisi.olay_metin(rapor.olaylar[0]).contains("1 çalışan esnaf"),"Mevcut typed rapor okunur")
 y.gun+=1
 b.insa_kalan=1
 dene(MuhafizYetenekleri.harac(o).akce==0,"İnşa çalışanı gelir yaratmaz")
 y.gun+=1
 b.insa_kalan=0
 dene(MuhafizYetenekleri.harac(o).akce==2,"Ertesi gece dönen görevli de gerçek çalışan sayılır")
 y.son=&"isyan"
 y.gun+=1
 dene(MuhafizYetenekleri.harac(o).akce==0,"Oyun sonu tahsilat yok")
 dene(MuhafizYetenekleri.oku({"alinan":["harac_kesme","uydurma"],"son_harac_gece":"9","harac_toplam":-1}).alinan.is_empty(),"Bozuk/önkoşulsuz eski kayıt red")
 dene(MuhafizYetenekleri.oku(null).alinan.is_empty(),"Eski kayıtta yetenek yok")
 print("MUHAFIZ YETENEK: GEÇTİ" if hata==0 else "MUHAFIZ YETENEK: KALDI")
 quit(hata)
