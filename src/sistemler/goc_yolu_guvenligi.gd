## HAR-05: mevcut husumeti gerçek muhafızlarla azaltır; aynı kuyruğa ek göç ziyareti.
class_name GocYoluGuvenligi
extends RefCounted
const TICARET_AKISI = preload("res://src/koy/ticaret/pusu_ticaret_akisi.gd")
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/goc_yolu_guvenligi.json"))
## Optional görev/ziyaret makbuzu; kayıt ikinci nüfus veya tehdit üretmez.
static func oku(v: Variant) -> Dictionary:
	var d := {"son_gun":-1,"son_ziyaret":-1,"bekleyen":0,"basari":0,"sonuc":""}
	if not v is Dictionary: return d
	for a in ["son_gun","son_ziyaret"]: d[a]=KurtBaskini.oku(v.get(a,-1))
	d.bekleyen = _tam(v.get("bekleyen"),int(AYAR.goc_ziyareti))
	d.basari = _tam(v.get("basari"),1000000)
	if v.get("sonuc") in ["basari","basarisiz"]: d.sonuc=v.sonuc
	return d
## Gerçek etkin yetişkin nöbetçiler; en güçlü önce, eşit güçte ID sırası.
static func adaylar(y: KoyYonetimi) -> Array[Koylu]:
	var a: Array[Koylu]=[]
	for k in y.koylular:
		if k.yas_grubu!=&"yetiskin" or k.saglik<int(AYAR.saglik_min) or not MuhafizMaasi.aday(k,y): continue
		if MuhafizMaasi.borclu(k,y) or DivanHukmu.zindanda(k) or KervanKorumasi.disarida(y,k.id) or IsKazalari.uyuyor(k) or not CirakEgitimi.saglam(k) or IsMemnuniyeti.isyanci(k,y): continue
		a.append(k)
	a.sort_custom(func(x: Koylu,z: Koylu) -> bool: return x.stat>z.stat if x.stat!=z.stat else x.id<z.id)
	return a
## Var olan sızma eşiğinde gerçek husumet, iki nöbetçi ve gün başına tek görev.
static func uygun(o: Oturum) -> bool:
	return o.yonetim.son=="" and o.yonetim.husumet.puan>=o.yonetim.a.sizma_esigi and int(oku(o.goc_yolu_guvenligi).son_gun)<o.gun and adaylar(o.yonetim).size()>=int(AYAR.mufreze_adet)
## Aynı gün soyut yol temizliği; gücü gerçek statlar, bedeli gerçek sağlık, ayrı RNG/savaş yok.
static func temizle(o: Oturum) -> Dictionary:
	var r := {"ok":false,"basari":false,"metin":"Yeterli etkin muhafız veya gerçek eşkıya tehdidi yok; aynı gün görev tekrarlanamaz."}
	if not uygun(o): return r
	var d := oku(o.goc_yolu_guvenligi)
	var a := adaylar(o.yonetim).slice(0,int(AYAR.mufreze_adet))
	var guc := 0
	for k in a:
		guc+=k.stat
		k.saglik=maxi(1,k.saglik-int(AYAR.gorev_saglik))
	r.ok=true
	r.basari=guc>=int(AYAR.guc_esik)
	d.son_gun=o.gun
	d.sonuc="basari" if r.basari else "basarisiz"
	if r.basari:
		o.yonetim.husumet.puan=maxi(0,o.yonetim.husumet.puan-int(AYAR.husumet_azalt))
		o.yonetim.asayis_riski=maxi(0,o.yonetim.asayis_riski-int(AYAR.basari_asayis_azalt))
		d.bekleyen=int(AYAR.goc_ziyareti)
		d.basari=mini(1000000,int(d.basari)+1)
		r.metin=String(AYAR.basari_metin)
	else:
		o.yonetim.asayis_riski=mini(100,o.yonetim.asayis_riski+int(AYAR.basarisiz_asayis_artir))
		r.metin=String(AYAR.basarisiz_metin)
	o.goc_yolu_guvenligi=d
	if r.basari: TICARET_AKISI.basari(o)
	return r
## Başarı makbuzuyla her gerçek gün bir normal Gelen; kabul/ret ve heybe eski kuyruğa bırakılır.
static func ziyaret(o: Oturum,kuyruk: Array[Gelen]) -> void:
	var d := oku(o.goc_yolu_guvenligi)
	if o.yonetim.son!="" or int(d.bekleyen)<=0 or int(d.son_ziyaret)>=o.gun: return
	var g := o._figur_gelen()
	g.set_meta("har05_goc",true)
	g.acilis=String(AYAR.kafile_acilis)
	kuyruk.append(g)
	d.bekleyen=int(d.bekleyen)-1
	d.son_ziyaret=o.gun
	o.goc_yolu_guvenligi=d
## Mevcut pazar ve harita için saf güncel durum; görev veya RNG başlatmaz.
static func tip(o: Oturum) -> String:
	var d := oku(o.goc_yolu_guvenligi)
	var a := adaylar(o.yonetim)
	var guc := 0
	for k in a.slice(0,int(AYAR.mufreze_adet)): guc+=k.stat
	var s := String(AYAR.tip)%[o.yonetim.husumet.puan,a.size(),int(d.bekleyen),int(AYAR.gorev_saglik),guc,int(AYAR.guc_esik)]
	if d.sonuc!="": s+="\n"+String(AYAR.basari_metin if d.sonuc=="basari" else AYAR.basarisiz_metin)
	var ticaret := TICARET_AKISI.tip(o)
	if not ticaret.is_empty(): s+="\n"+ticaret
	return s
static func _tam(v: Variant,ust: int) -> int:
	if (v is int or v is float) and is_finite(float(v)) and floor(float(v))==float(v) and float(v)>=0 and float(v)<=ust: return int(v)
	return 0
