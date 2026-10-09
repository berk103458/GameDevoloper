extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1;push_error(s)
func _initialize() -> void:
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,1901)
 var y:=o.yonetim
 y.a=y.a.duplicate(true);y.a.muhafiz_azami=10
 var kisiler: Array[Koylu]=[]
 for i in 7:
  var k:=y.kabul({"sinif":"asker","stat":5})
  k.moral=100;k.saglik=100
  dene(y.muhafiz_ata(k.id),"Gerçek muhafız")
  kisiler.append(k)
 var k:=kisiler[0]
 var once:=JSON.stringify(o.kaydet())
 dene(not SavunmaKonuslanmasi.ata(y,k.id,"kapi") and JSON.stringify(o.kaydet())==once,"İlk perde atomik ret")
 y.agalik=true
 dene(SavunmaKonuslanmasi.ata(y,k.id,"kapi"),"Kapı mızraklı gerçek atama")
 dene(not SavunmaKonuslanmasi.ata(y,k.id,"sur"),"Sur yokken okçu olmaz")
 y.sur_seviye=1
 dene(SavunmaKonuslanmasi.ata(y,k.id,"sur"),"Okçu atama")
 for i in range(1,4): dene(SavunmaKonuslanmasi.ata(y,kisiler[i].id,"sur"),"Dört kule slotu")
 once=JSON.stringify(o.kaydet())
 dene(not SavunmaKonuslanmasi.ata(y,kisiler[4].id,"sur") and JSON.stringify(o.kaydet())==once,"Dolu sur atomik ret")
 dene(SavunmaKonuslanmasi.ata(y,kisiler[4].id,"kapi") and SavunmaKonuslanmasi.ata(y,kisiler[5].id,"kapi") and not SavunmaKonuslanmasi.ata(y,kisiler[6].id,"kapi"),"İki kapı slotu")
 var rng:=y._rng.state
 var para:=y.akce
 var savunma:=y.savunma_gucu()
 var rota:=KoyRotasi.new()
 y.izgara.engeller.clear();rota.kur(y.izgara,2.5)
 var bas:=rota.yakin(y.a.meydan.position)
 var d:=MuhafizDevriyesi.hedef(y,rota,bas,0,k.id)
 dene(not d.is_empty() and d.ad=="Sur okçusu" and not rota.yol(bas,d.son).is_empty(),"Aynı gerçek A* sur hedefi")
 dene(MuhafizDevriyesi.hedef(y,rota,bas,12,k.id).son==d.son,"Konuşlanan aynı durakta kalır")
 dene(MuhafizDevriyesi.hedef(y,rota,bas,0).ad=="Kapıda nöbet","Eski API korunur")
 once=JSON.stringify(o.kaydet())
 SavunmaKonuslanmasi.durum(y);SavunmaKonuslanmasi.etkin(y,k.id)
 dene(JSON.stringify(o.kaydet())==once and rng==y._rng.state and para==y.akce and savunma==y.savunma_gucu(),"Okuma/kasa/RNG ve HAR15 formülü değişmez")
 for alan in ["saglik","yas_grubu","is_yeri"]:
  var eski: Variant=k.get(alan)
  k.set(alan,10 if alan=="saglik" else (&"cocuk" if alan=="yas_grubu" else KoyYonetimi.BOSTA))
  dene(SavunmaKonuslanmasi.etkin(y,k.id).is_empty(),"Etkin değil: "+alan)
  k.set(alan,eski)
 k.bayraklar.append("zindanda")
 dene(SavunmaKonuslanmasi.etkin(y,k.id)=="","Zindan hariç")
 k.bayraklar.erase("zindanda")
 k.bayraklar.append("hasta")
 dene(SavunmaKonuslanmasi.etkin(y,k.id)=="","Hasta hariç")
 k.bayraklar.erase("hasta")
 k.is_kazasi={"tur":"uyuklama","kalan":1,"bayrak_eklendi":false}
 dene(SavunmaKonuslanmasi.etkin(y,k.id)=="","Uyuklayan hariç")
 k.is_kazasi={}
 y.maas_durumu[str(k.id)]={"borc":1}
 dene(SavunmaKonuslanmasi.etkin(y,k.id)=="","Borçlu hariç")
 y.maas_durumu.clear()
 y.kervan_koruma[str(k.id)]={"baslangic":y.gun,"donus":y.gun+2}
 dene(SavunmaKonuslanmasi.etkin(y,k.id)=="","Dış görev hariç")
 y.kervan_koruma.clear()
 var zanaat:=k.zanaat_turu
 k.moral=0;k.zanaat_turu=ZanaatTuru.Tur.CIFTCI
 dene(IsMemnuniyeti.isyanci(k,y) and SavunmaKonuslanmasi.etkin(y,k.id)=="","İsyancı hariç")
 k.moral=100;k.zanaat_turu=zanaat
 y.sur_hasar=100
 dene(SavunmaKonuslanmasi.etkin(y,k.id)=="" and SavunmaKonuslanmasi.etkin(y,kisiler[4].id)=="kapi","Hasarlı sur okçu dışı; kapı sürer")
 y.sur_hasar=0
 var yuk:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
 dene(SavunmaKonuslanmasi.etkin(yuk.yonetim,k.id)=="sur","JSON gerçek atama korunur")
 dene(SavunmaKonuslanmasi.oku({"01":"sur","x":"sur","0":"kapi","1":"bilinmeyen",2:"sur"}).is_empty(),"Bozuk ID/rol ret")
 var defter:=SavunmaKonuslanmasi.durum(y)
 defter["999999"]="kapi"
 y.set_meta(SavunmaKonuslanmasi.META,defter)
 dene(not SavunmaKonuslanmasi.durum(y).has("999999") and not y.kaydet().savunma_konuslanmasi.has("999999"),"Ayrılan kişi slot/kayıt tüketmez; ghost NPC yok")
 var legacy:=y.kaydet();legacy.erase("savunma_konuslanmasi")
 dene(SavunmaKonuslanmasi.durum(KoyYonetimi.kayittan(y.a,y.katalog,legacy)).is_empty(),"Legacy boş")
 y.son=&"yenilgi"
 dene(SavunmaKonuslanmasi.etkin(y,k.id)=="" and not SavunmaKonuslanmasi.ata(y,k.id,"kapi"),"Terminal ret")
 dene(SavunmaKonuslanmasi.ata(y,k.id,"") and not SavunmaKonuslanmasi.durum(y).has(str(k.id)),"Pasif/terminal atama temizlenebilir")
 print("SAVUNMA KONUSLANMASI: GEÇTİ" if hata==0 else "SAVUNMA KONUSLANMASI: KALDI")
 quit(hata)
