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
 for adli in [&"chr_001",&"chr_006"]:
  for mod in ["gizli","ipucu","Flag_Yol_Sirri_Acik","Flag_Sir_Tamamen_Cozuldu","Flag_Kimlik_Cozuldu","yanlis_clue"]:
   var o:=Oturum.new(kat,8)
   var y:=o.yonetim
   y.a=y.a.duplicate(true)
   y.a.ambar_taban_kapasite=10000
   y.kaynaklar.kapasite=10000
   y.akce=100
   for t in ["odun","gida","tas","kereste","alet","tomruk","bugday"]: y.kaynaklar.ekle(t,100)
   var b:=kur(y,"ambar" if adli==&"chr_001" else "degirmen")
   dene(b!=null,"Kaynak bina hazır")
   var g:=o._adli_gelen(adli)
   var s: ChrSorgusu=g.chr_sorgusu()
   var kaynak:=var_to_str(s.karakter)
   if mod=="ipucu": s.obje_incele(2)
   elif mod.begins_with("Flag_"): s.bayraklar[mod]=true
   var bayrak:=s.bayraklar.duplicate(true)
   var rr:=o.karar_ver(g,&"kabul")
   var k:=y.koylu(rr.koylu_id)
   var x: Dictionary=AmbarKundaklamasi.durum(y).kisiler[str(k.id)]
   dene(x.bayraklar==SabotajClueSozlesmesi.bayrak_oku(bayrak) and s.bayraklar==bayrak and var_to_str(s.karakter)==kaynak,"DörtFlag readonly snapshot: "+mod)
   dene(SabotajClueSozlesmesi.kaynak_uygun(k,AmbarKundaklamasi.AYAR.clue_sozlesmesi) and SabotajClueSozlesmesi.bulunan_yuk(k,AmbarKundaklamasi.AYAR.clue_sozlesmesi)==(mod=="ipucu"),"Kaynak üçClue birebir, keşif ayrı")
   var z:=Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
   dene(AmbarKundaklamasi.durum(z.yonetim).kisiler[str(k.id)].bayraklar==x.bayraklar,"Tam JSON Flag snapshotu")
   y.gun=int(AmbarKundaklamasi.kaynak(k,"kabul").tur_offset)-1
   y.kaynaklar.ekle("su",10)
   var olaylar: Array[Dictionary]=[]
   var rng:=y._rng.state
   var korundu: bool=mod in ["Flag_Yol_Sirri_Acik","Flag_Sir_Tamamen_Cozuldu","yanlis_clue"]
   var tablo: Dictionary=AmbarKundaklamasi.AYAR.clue_sozlesmesi.duplicate(true)
   if mod=="yanlis_clue": AmbarKundaklamasi.AYAR.clue_sozlesmesi[String(adli)].yuk="Clue_yanlis"
   var su:=AmbarKundaklamasi.gece(y,olaylar)
   AmbarKundaklamasi.AYAR.clue_sozlesmesi=tablo
   dene(su==(0 if korundu else 10) and y.bina(b.id)!=null and olaylar.is_empty()==korundu,"Tam/yol önler; bulunan Clue tek başına yangını önlemez: "+mod)
   dene(CasusGeceTakibi.acik_izler(y).is_empty() and y._rng.state==rng,"Malzeme/yangın fail gözlemi ve yeni zar değildir")
   var once:=JSON.stringify(y.kaydet())
   dene(AmbarKundaklamasi.gece(y,olaylar)==0 and JSON.stringify(y.kaydet())==once,"Tek su/fiil makbuzu")
 print("KUNDAK CLUE SÖZLEŞMESİ: GEÇTİ" if hata==0 else "KUNDAK CLUE SÖZLEŞMESİ: KALDI")
 quit(hata)
