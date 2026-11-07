## HAR-04: gerçek köylüleri mevcut olay kartıyla Sancak ordusuna gönderir.
class_name SancakAskerTalebi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/sancak_asker_talebi.json"))
## Optional ferman makbuzu; kayıt isyancı veya köylü üretmez.
static func oku(v: Variant) -> Dictionary:
	var d := {"son_gece":-1,"gun":-1,"bekliyor":false,"secim":-1,"gonderilen":[],"levent_gonderildi":false}
	if not v is Dictionary: return d
	for a in ["son_gece","gun","secim"]: d[a] = KurtBaskini.oku(v.get(a,-1))
	if d.secim > 2: d.secim = -1
	d.bekliyor = v.get("bekliyor") is bool and v.bekliyor and d.gun>=int(AYAR.ilk_gece) and d.secim==-1
	var ids: Variant = v.get("gonderilen")
	if ids is Array:
		for x in ids:
			var id := KurtBaskini.oku(x)
			if id>0 and not id in d.gonderilen and d.gonderilen.size()<int(AYAR.levent): d.gonderilen.append(id)
	d.levent_gonderildi = preload("res://src/sistemler/levent_gonderim_gecmisi.gd").oku(v, d, int(AYAR.levent), int(AYAR.ilk_gece))
	return d
## Aynı gerçek gece bir kez ferman; bekleyen seçim diğer olayları ezmez.
static func gece(o: Oturum, r: Dictionary) -> void:
	var d := oku(o.sancak_asker_talebi)
	var no := int(r.gun)+1
	if o.yonetim.son!="" or no<=int(d.son_gece): return
	d.son_gece = no
	o.sancak_asker_talebi = d
	if ferman_ac(o, no, -1):
		r.olaylar.append({"anahtar":String(AYAR.haber)})

## Aynı ferman hem kapı hem gece sonu çalışsa da bir kez açılır.
static func ferman_ac(o: Oturum, no: int, ofset: int = 0) -> bool:
	var d := oku(o.sancak_asker_talebi)
	var dis_hat = preload("res://src/sistemler/dis_hat_kapisi.gd")
	var ilk := int(AYAR.ilk_gece)
	if o.yonetim.son != "" or d.bekliyor or no <= int(d.gun) or no < ilk:
		return false
	if (no - ilk) % maxi(1, int(AYAR.aralik_gece)) != 0 or not dis_hat.izin(o.yonetim, dis_hat.TALEP, ofset):
		return false
	d.gun = no
	d.secim = -1
	d.bekliyor = true
	d.gonderilen = []
	o.sancak_asker_talebi = d
	return true
## Salt okunur, ID sıralı gerçek adaylar; gizli suç veya söylenti isyan sayılmaz.
static func adaylar(y: KoyYonetimi, isyanci: bool) -> Array[Koylu]:
	var a: Array[Koylu] = []
	for k in y.koylular:
		if k.adli_id!=&"" or k.yas_grubu!=&"yetiskin" or k.saglik<int(AYAR.saglik_min): continue
		if DivanHukmu.zindanda(k) or KervanKorumasi.disarida(y,k.id) or IsKazalari.uyuyor(k) or not CirakEgitimi.saglam(k): continue
		if IsMemnuniyeti.isyanci(k,y)==isyanci: a.append(k)
	a.sort_custom(func(x: Koylu,z: Koylu) -> bool: return x.id<z.id)
	return a
## Mevcut OlayVerisi yüzeyi; aynı bekleyen gun kimliği yeniden yüklemeye dayanır.
static func olay(o: Oturum) -> OlayVerisi:
	var d := oku(o.sancak_asker_talebi)
	if not d.bekliyor or o.yonetim.son!="": return null
	var e := OlayVerisi.new()
	e.id = StringName("har04_ferman_%d"%int(d.gun))
	e.baslik_anahtari = String(AYAR.baslik)
	e.metin_anahtari = String(AYAR.metin)%[int(AYAR.levent),_adlar(adaylar(o.yonetim,false)),_adlar(adaylar(o.yonetim,true))]
	e.secenek_anahtarlari = PackedStringArray(AYAR.secenekler)
	e.secenek_etkileri = [{},{},{}]
	return e
## Foreign olaylar çekirdeğin var olan seçenek yolunda kalır.
static func tanimli(e: OlayVerisi) -> bool:
	return e!=null and String(e.id).begins_with("har04_ferman_")
## Canlı kart, yeterli gerçek aday ve köyde bırakılacak nüfus önkoşulu.
static func uygun(o: Oturum,e: OlayVerisi,i: int) -> bool:
	var g := olay(o)
	if i not in [0,1,2] or not tanimli(e) or g==null or e.id!=g.id: return false
	return i==2 or (adaylar(o.yonetim,i==1).size()>=int(AYAR.levent) and o.yonetim.nufus()-int(AYAR.levent)>=int(AYAR.koyde_kalan_min))
## Atomik seçim; gerçek kişilerin ayrılması dışında para/stok/RNG ve suç kaydı yazmaz.
static func uygula(o: Oturum,e: OlayVerisi,i: int) -> Dictionary:
	var r := {"ok":false,"kirilan":-1,"rusvet_harcandi":-1,"oyun_puan":-1,"sonuc_anahtari":"Ferman güncel değil veya yeterli uygun levent yok."}
	if not uygun(o,e,i): return r
	var d := oku(o.sancak_asker_talebi)
	if i==2:
		o.yonetim.asayis_riski = mini(100,o.yonetim.asayis_riski+int(AYAR.ret_asayis))
		r.sonuc_anahtari = String(AYAR.ret_metin)%int(AYAR.ret_asayis)
	else:
		var a := adaylar(o.yonetim,i==1).slice(0,int(AYAR.levent))
		r.sonuc_anahtari = String(AYAR.sonuc)%_adlar(a)
		for k in a:
			d.gonderilen.append(k.id)
			o.yonetim.koylular.erase(k)
		d.levent_gonderildi = true
		o._koy_esitle()
	d.bekliyor = false
	d.secim = i
	o.sancak_asker_talebi = d
	r.ok = true
	return r
static func _adlar(a: Array[Koylu]) -> String:
	var adlar := PackedStringArray()
	for k in a: adlar.append(k.ad)
	return String(AYAR.bos_metin) if adlar.is_empty() else ", ".join(adlar)
