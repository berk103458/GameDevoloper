extends SceneTree
var hata := 0
func kur(y: KoyYonetimi,tur: String) -> KoyBinasi:
 for cy in y.a.izgara_boyut.y:
  for cx in y.a.izgara_boyut.x:
   var h := Vector2i(cx,cy)
   if y.yerlesim(tur,h).olur:
    var b := y.bina(y.bina_kur(tur,h).id)
    b.insa_kalan = 0
    return b
 return null
func oturum(kat: Katalog,id: StringName,karar: StringName = &"kabul",cozuldu: bool = false) -> Oturum:
 var o := Oturum.new(kat,25)
 o.yonetim.a = o.yonetim.a.duplicate(true)
 o.yonetim.a.ambar_taban_kapasite = 10000
 o.yonetim.kaynaklar.kapasite = 10000
 o.yonetim.akce = 100
 for t in ["odun","gida","tas","kereste","alet","tomruk","bugday"]: o.yonetim.kaynaklar.ekle(t,100)
 var g := o._adli_gelen(id)
 g.chr_sorgusu().bayraklar["Flag_Sir_Tamamen_Cozuldu"] = cozuldu
 o.karar_ver(g,karar)
 return o
func dene(v: bool,ad: String) -> void:
 if not v:
  hata += 1
  push_error(ad)
func _initialize() -> void:
 var kat := Katalog.new()
 kat.yukle()
 for id in [&"chr_001",&"chr_006"]:
  var o := oturum(kat,id)
  var y := o.yonetim
  var b := kur(y,"ambar" if id == &"chr_001" else "degirmen")
  dene(b != null,"Kaynak hedef gerçekten kurulur")
  var e := AmbarKundaklamasi.kaynak(y.koylular[0],"kabul")
  var gece := int(e.tur_offset)-1
  var olaylar: Array[Dictionary] = []
  var rng := y._rng.state
  y.gun = gece-1
  dene(AmbarKundaklamasi.gece(y,olaylar)==0 and y.bina(b.id)!=null and olaylar.is_empty(),"Erken tur yangın yok")
  y.gun = gece
  y.kaynaklar.ekle("su",10)
  var gida := y.kaynaklar.miktar("gida")
  dene(AmbarKundaklamasi.gece(y,olaylar)==10 and y.bina(b.id)!=null and y.kaynaklar.miktar("su")==0 and y.kaynaklar.miktar("gida")==gida and y._rng.state==rng,"Aynı rezervle tek gerçek yangın söner, kaynak kaybı önlenir")
  dene(CasusGeceTakibi.durum(y).izler[0].durum=="kundaklama" and CasusGeceTakibi.acik_izler(y).is_empty(),"Gerçek fiil var, gizli fail kamuya sızmaz")
  var once := JSON.stringify(y.kaydet())
  dene(AmbarKundaklamasi.gece(y,olaylar)==0 and JSON.stringify(y.kaydet())==once,"Aynı gece tek harcama")
  var z := KoyYonetimi.kayittan(y.a,kat.binalar,JSON.parse_string(once))
  z.gun+=1
  dene(AmbarKundaklamasi.gece(z,[])==0 and z.bina(b.id)!=null,"JSON sonrası kişi yangını tekrarlamaz")
  var n := oturum(kat,id)
  var ny := n.yonetim
  var nb := kur(ny,"ambar" if id == &"chr_001" else "degirmen")
  ny.koylular[0].is_yeri=nb.id
  ny.koylular[0].ev=nb.id
  ny.koylular[0].kis_oncesi_is=nb.id
  ny.gun=gece
  ny.kaynaklar.ekle("su",9)
  gida=ny.kaynaklar.miktar("gida")
  var odun := ny.kaynaklar.miktar("odun")
  var akce := ny.akce
  dene(AmbarKundaklamasi.gece(ny,[])==0 and ny.bina(nb.id)==null and ny.kaynaklar.miktar("gida")==gida-4 and ny.kaynaklar.miktar("odun")==odun and ny.akce==akce and ny.kaynaklar.miktar("su")==9,"Eksik rezerv: iadesiz yapı kaybı, kaynak erzak−4; kasa/malzeme yaratılmaz")
  dene(ny.koylular[0].is_yeri==-1 and ny.koylular[0].ev==-1 and ny.koylular[0].kis_oncesi_is==-1 and not nb.id in ny.izgara.dolu.values(),"Çalışan/ev/ızgara mevcut çıkarma API'sinde temizlenir")
  var s := oturum(kat,id,&"kabul",true)
  var sb := kur(s.yonetim,"ambar" if id == &"chr_001" else "degirmen")
  s.yonetim.gun=gece
  dene(AmbarKundaklamasi.gece(s.yonetim,[])==0 and s.yonetim.bina(sb.id)!=null,"Kapı tam çözümü kundaklamayı önler")
 # İnşaat hedef değil; hazır olunca ilk fırsat. Kışla ve masum için fiil yok.
 var u := oturum(kat,&"chr_006")
 var ub := kur(u.yonetim,"degirmen")
 ub.insa_kalan=1
 u.yonetim.gun=2
 dene(AmbarKundaklamasi.gece(u.yonetim,[])==0 and u.yonetim.bina(ub.id)!=null,"İnşaat yangın hedefi değil")
 ub.insa_kalan=0
 u.yonetim.gun+=1
 dene(AmbarKundaklamasi.gece(u.yonetim,[])==0 and u.yonetim.bina(ub.id)==null,"Hazır hedefte gecikmiş fırsat")
 var h := oturum(kat,&"chr_001",&"kisla")
 var hb := kur(h.yonetim,"ambar")
 h.yonetim.gun=9
 dene(AmbarKundaklamasi.gece(h.yonetim,[])==0 and h.yonetim.bina(hb.id)!=null,"Kışla kararı fiil üretmez")
 var p := oturum(kat,&"chr_001",&"rusvet")
 dene(AmbarKundaklamasi.kaynak(p.yonetim.koylular[0],"rusvet").is_empty(),"Kaynak odun çürümesi yangın değildir")
 var n := oturum(kat,&"chr_006")
 var b := kur(n.yonetim,"degirmen")
 n.yonetim.gun=2
 n.yonetim.kaynaklar.ekle("su",10)
 var r := n.yonetim.gece()
 dene(n.yonetim.bina(b.id)!=null and int(r.tuketim.su)>=10 and AmbarKundaklamasi.durum(n.yonetim).kisiler[str(n.yonetim.koylular[0].id)].uygulandi==2,"Gerçek gece su bilançosuna tek söndürme girer")
 dene(AmbarKundaklamasi.oku({"kisiler":{"2":{"karar":"fake","cozuldu":false}}}).kisiler.is_empty(),"Bozuk kayıt elenir")
 print("AMBAR KUNDAKLAMASI: GEÇTİ" if hata==0 else "AMBAR KUNDAKLAMASI: KALDI")
 quit(hata)
