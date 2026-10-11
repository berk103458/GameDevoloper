extends SceneTree
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 # Kaynak ipucu/zehir testi; alışma kapısı ayrı tehdit_takvimi_test içindedir.
 preload("res://src/sistemler/tehdit_takvimi.gd").AYAR.tehdit_baslangic_gunu = 0
 var kat:=Katalog.new()
 kat.yukle()
 for adli in [&"chr_002",&"chr_009"]:
  for mod in ["gizli","ipucu","Flag_Yol_Sirri_Acik","Flag_Sir_Tamamen_Cozuldu","Flag_Kimlik_Cozuldu"]:
   var o:=Oturum.new(kat,8)
   var g:=o._adli_gelen(adli)
   var s: ChrSorgusu=g.chr_sorgusu()
   var kaynak:=var_to_str(s.karakter)
   if mod=="ipucu": s.obje_incele(2)
   elif mod.begins_with("Flag_"): s.bayraklar[mod]=true
   var b:=s.bayraklar.duplicate(true)
   var rr:=o.karar_ver(g,&"kabul")
   var y:=o.yonetim
   var k:=y.koylu(rr.koylu_id)
   var x: Dictionary=KuyuZehirleme.durum(y).kisiler[str(k.id)]
   dene(x.bayraklar==SabotajClueSozlesmesi.bayrak_oku(b) and s.bayraklar==b and var_to_str(s.karakter)==kaynak,"Dört kaynak Flag birebir readonly: "+mod)
   dene(SabotajClueSozlesmesi.kaynak_uygun(k,KuyuZehirleme.AYAR.clue_sozlesmesi),"Nişan/yük/görsel Clue kaynakta birebir")
   dene(SabotajClueSozlesmesi.bulunan_yuk(k,KuyuZehirleme.AYAR.clue_sozlesmesi)==(mod=="ipucu"),"Keşfedilmemiş Clue malzeme var diye bulunmuş sayılmaz")
   dene(KuyuZehirleme.tip(y).contains("keşfedilmiş")== (mod=="ipucu"),"Su kartında yalnız gerçek bulunan yük")
   var z:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
   dene(KuyuZehirleme.durum(z.yonetim).kisiler[str(k.id)].bayraklar==x.bayraklar,"JSON Flag snapshotu")
   y.gun=2
   var olaylar: Array[Dictionary]=[]
   var rng:=y._rng.state
   KuyuZehirleme.gece(y,{"taze":10},olaylar)
   var korundu: bool=mod in ["Flag_Yol_Sirri_Acik","Flag_Sir_Tamamen_Cozuldu"]
   dene(olaylar.is_empty()==korundu and k.saglik==(100 if korundu else 96),"Clue tek başına engel değil; tam/yol Flag zehri kapatır: "+mod)
   dene(CasusGeceTakibi.acik_izler(y).is_empty() and y._rng.state==rng,"Malzeme/belirti fail gözlemi ve yeni zar değildir")
 dene(not SabotajClueSozlesmesi.guvene_alindi({"cozuldu":false,"bayraklar":{"Flag_Sir_Tamamen_Cozuldu":"true"}}),"String true gerçek Flag değildir")
 dene(SabotajClueSozlesmesi.guvene_alindi({"cozuldu":true}) and SabotajClueSozlesmesi.guvene_alindi({"cozuldu":false,"bayraklar":{"Flag_Sir_Tamamen_Cozuldu":true}}),"Eski çözüm ve gerçek rawFlag korunur")
 var o:=Oturum.new(kat,1)
 var k:=o.yonetim.kabul({"ad":"Kaynak","adli_id":"chr_002"})
 var once: Dictionary=KuyuZehirleme.AYAR.clue_sozlesmesi.duplicate(true)
 KuyuZehirleme.AYAR.clue_sozlesmesi.chr_002.yuk="Clue_yanlis"
 o.yonetim.gun=2
 var olaylar: Array[Dictionary]=[]
 KuyuZehirleme.gece(o.yonetim,{"taze":10},olaylar)
 dene(olaylar.is_empty() and k.saglik==100,"Kaynak Clue uyumsuzluğunda zehir fiili güvenli reddedilir")
 KuyuZehirleme.AYAR.clue_sozlesmesi=once
 print("ZEHİR CLUE SÖZLEŞMESİ: GEÇTİ" if hata==0 else "ZEHİR CLUE SÖZLEŞMESİ: KALDI")
 quit(hata)
