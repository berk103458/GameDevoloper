extends SceneTree
const TABAN:="user://codex-oda13-test/"
var hata:=0
func dene(v: bool,s: String) -> void:
 if not v: hata+=1; push_error(s)
func _initialize() -> void:
 DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(TABAN))
 var a:=GuvenliKayit.new(TABAN+"aktif.json")
 var b:=GuvenliKayit.new(TABAN+"diger.json")
 a.sil(); b.sil()
 var kat:=Katalog.new()
 kat.yukle()
 var o:=Oturum.new(kat,1013)
 for i in 4: o.karar_ver(Gelen.new(),&"rusvet")
 o.yonetim.kabul({"ad":"Kayıt tanığı"})
 o.yonetim.kaynaklar.ekle("gida",100)
 o.yonetim.kaynaklar.ekle("su",100)
 o.gun=5
 var temiz:=Oturum.new(kat,1014)
 temiz.muhafiz_akce=10000
 temiz.yonetim.kabul({"ad":"Meşru tanık"})
 temiz.yonetim.kaynaklar.ekle("gida",100)
 temiz.yonetim.kaynaklar.ekle("su",100)
 temiz.gun=5
 dene(a.yaz(o.kaydet()) and b.yaz(temiz.kaydet()),"İki izole gerçek save/state slotu")
 var veri:=a.oku()
 var once:=JSON.stringify(veri)
 var yedek:=SancakTeftisi.AYAR
 SancakTeftisi.AYAR=yedek.duplicate(true)
 SancakTeftisi.AYAR.bulma_olasiligi=1.0
 var yuklenen:=Oturum.kayittan(kat,veri)
 var sonuc:=yuklenen.gece_sonu()
 dene(sonuc.son==SancakTeftisi.SON_AZIL and yuklenen.sancak_teftisi.akce==o.muhafiz_akce,"Yüklenen kişisel kasa gerçek gece teftişinde bulunur")
 dene(JSON.stringify(veri)==once and JSON.stringify(a.oku())==once,"Okunan slot ve disk değiştirilmez")
 var diger:=Oturum.kayittan(kat,b.oku())
 var rr:=diger.gece_sonu()
 dene(rr.son==&"" and diger.sancak_teftisi.sonuc=="temiz","Başka slot rüşveti meşru oturuma taşınmaz")
 dene(a.yaz(yuklenen.kaydet()),"Terminal ve makbuz aynı slota yazılır")
 var geri:=Oturum.kayittan(kat,a.oku())
 var rng:=geri._rng.state
 var olaylar: Array[Dictionary]=[]
 SancakTeftisi.gece(geri,{"gun":5,"son":String(sonuc.son),"olaylar":olaylar})
 dene(geri._rng.state==rng and olaylar.is_empty(),"Terminal reload tekrar çekiliş yaratmaz")
 # Bu yol yalnız test alt dizinidir; gerçek savegame dosyası okunmaz/yazılmaz.
 var f:=FileAccess.open(a.yol,FileAccess.WRITE)
 f.store_string("kesilmiş"); f.close()
 var bak:=a.oku()
 dene(bak.get("_yedekten",false),"Kesilmiş ana dosyada mevcut güvenli yedek")
 geri=Oturum.kayittan(kat,bak)
 dene(geri.gece_sonu().son==SancakTeftisi.SON_AZIL,"Yedekten gelen aynı kasa ve suç makbuzu teftişe bağlanır")
 SancakTeftisi.AYAR=yedek
 a.sil(); b.sil()
 DirAccess.remove_absolute(ProjectSettings.globalize_path(TABAN))
 print("SANCAK KAYIT SLOTU: GEÇTİ" if hata==0 else "SANCAK KAYIT SLOTU: KALDI")
 quit(hata)
