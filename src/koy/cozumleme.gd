## YAP-05: tek çözümleme işi; mevcut atama, gece ve kayıt akışına adaptör.
extends RefCounted
const DEFTERLER = preload("res://src/koy/usta_defterleri.gd")
static func dogrula(veri: Variant = null) -> PackedStringArray:
	var d: Variant = DEFTERLER.AYAR if veri == null else veri
	var hatalar := DEFTERLER.dogrula(d)
	if not hatalar.is_empty(): return hatalar
	var ayar: Variant = d.get("cozumleme")
	if not ayar is Dictionary or ayar.get("oda_turu") != "cozumleme_odasi" or ayar.get("mevsim_carpani") != "insa_carpani" or not DEFTERLER.tam(ayar.get("kamu_bedel")):
		hatalar.append("Çözümleme odası/tek bedel/mevsim kaynağı bozuk")
	for id in d.defterler:
		var arastirma: Variant = d.defterler[id].get("arastirma")
		if not arastirma is Dictionary or not DEFTERLER.tam(arastirma.get("sure_gun")) or int(arastirma.get("sure_gun",0)) <= 0:
			hatalar.append("Pozitif tam çözümleme süresi gerekli: " + String(id))
			continue
		var sonuc: Variant = arastirma.get("sonuc")
		if not sonuc is Dictionary or sonuc.size() != 2 or sonuc.get("hedef_sistem") != "hizarhane_uretimi":
			hatalar.append("Tek mevcut hedef gerekli: " + String(id))
			continue
		var carpan: Variant = sonuc.get("carpan")
		if not (carpan is int or carpan is float) or not is_finite(float(carpan)) or float(carpan) <= 0:
			hatalar.append("Pozitif sonlu sonuç çarpanı gerekli: " + String(id))
	return hatalar

static func oda(y: KoyYonetimi, id: int) -> bool:
	var b := y.bina(id)
	return b != null and b.hazir() and b.tur == String(DEFTERLER.AYAR.cozumleme.oda_turu)

const META := &"yap05_cozumleme"
const BOSTA = preload("res://src/koy/bosta_kalma.gd")
static func bos() -> Dictionary:
	return {"surum":1,"aktif":{},"kuyruk":[],"tamamlanan":[],"son_baslatma":-1,"son_gece":-1}
static func _tam(v: Variant, alt: int = 0) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and float(v) >= alt and float(v) <= 1000000000
static func _gorev_oku(v: Variant, etkin: bool) -> Dictionary:
	if not v is Dictionary or not v.get("defter") is String or not DEFTERLER.AYAR.defterler.has(v.defter): return {}
	if not _tam(v.get("oda"),1) or not _tam(v.get("isci"),1): return {}
	var d := {"defter":String(v.defter),"oda":int(v.oda),"isci":int(v.isci)}
	if etkin:
		var ilerleme: Variant = v.get("ilerleme")
		if not (ilerleme is int or ilerleme is float) or not is_finite(float(ilerleme)) or float(ilerleme) < 0 or float(ilerleme) >= float(DEFTERLER.AYAR.defterler[v.defter].arastirma.sure_gun) or not _tam(v.get("baslangic")): return {}
		d.ilerleme = float(ilerleme)
		d.baslangic = int(v.baslangic)
	return d
static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary or not _tam(v.get("surum"),1) or int(v.surum) != 1: return bos()
	if not v.get("aktif") is Dictionary or not v.get("kuyruk") is Array or not v.get("tamamlanan") is Array or v.kuyruk.size() > 128: return bos()
	if not _tam(v.get("son_baslatma"),-1) or not _tam(v.get("son_gece"),-1): return bos()
	var s := bos()
	s.son_baslatma = int(v.son_baslatma)
	s.son_gece = int(v.son_gece)
	var ids := {}
	for id in v.tamamlanan:
		if not id is String or not DEFTERLER.AYAR.defterler.has(id) or ids.has(id): return bos()
		s.tamamlanan.append(id)
		ids[id] = true
	if not v.aktif.is_empty():
		s.aktif = _gorev_oku(v.aktif,true)
		if s.aktif.is_empty() or ids.has(s.aktif.defter) or int(s.aktif.baslangic) != int(s.son_baslatma): return bos()
		ids[s.aktif.defter] = true
	for ham in v.kuyruk:
		var d := _gorev_oku(ham,false)
		if d.is_empty() or ids.has(d.defter): return bos()
		ids[d.defter] = true
		s.kuyruk.append(d)
	return s
static func durum(y: KoyYonetimi) -> Dictionary:
	return y.get_meta(META,bos()).duplicate(true)
static func yukle(y: KoyYonetimi, v: Variant) -> void:
	var s := oku(v)
	if maxi(int(s.son_baslatma),int(s.son_gece)) > y.gun: s = bos()
	y.set_meta(META,s)
static func _yaz(y: KoyYonetimi, s: Dictionary) -> void:
	y.set_meta(META,s)
static func _defter(o: Oturum, id: String) -> Dictionary:
	for e in o.muhafiz_esyalari:
		if e.get("id") == id and int(e.get("adet",0)) > 0: return e
	return {}
static func _neden(o: Oturum, d: Dictionary) -> String:
	var y := o.yonetim
	if not y.son.is_empty(): return "oyun_bitti"
	if not DEFTERLER.AYAR.defterler.has(d.defter) or _defter(o,d.defter).is_empty(): return "defter_yok"
	if not oda(y,int(d.oda)): return "oda_yok"
	var k := y.koylu(int(d.isci))
	if k == null or not BOSTA.isgucunde(y,k) or not CirakEgitimi.saglam(k) or not k.is_kazasi.is_empty() or ZanaatKazalari.durur(k) or IsMemnuniyeti.isyanci(k,y): return "isci_uygun_degil"
	if k.is_yeri != int(d.oda) or not GeciciIsler.secili(k).is_empty(): return "isci_atanmamis"
	return ""
static func _baslat(o: Oturum, s: Dictionary, d: Dictionary) -> bool:
	var bedel := int(DEFTERLER.AYAR.cozumleme.kamu_bedel)
	if not _neden(o,d).is_empty() or o.yonetim.akce < bedel or int(s.son_baslatma) == o.gun: return false
	s.aktif = d.duplicate(true)
	s.aktif.ilerleme = 0.0
	s.aktif.baslangic = o.gun
	s.son_baslatma = o.gun
	o.yonetim.akce -= bedel
	return true
static func baslat(o: Oturum, id: String, oda_id: int, isci_id: int) -> Dictionary:
	var r := {"ok":false,"kuyrukta":false,"neden":""}
	if not dogrula().is_empty():
		r.neden = "bozuk_veri"
		return r
	var d := {"defter":id,"oda":oda_id,"isci":isci_id}
	r.neden = _neden(o,d)
	if not String(r.neden).is_empty(): return r
	var s := durum(o.yonetim)
	if id in s.tamamlanan or (not s.aktif.is_empty() and s.aktif.defter == id):
		r.neden = "zaten_listede"
		return r
	for eski in s.kuyruk:
		if eski.defter == id:
			r.neden = "zaten_listede"
			return r
	if not s.aktif.is_empty() or int(s.son_baslatma) == o.gun or not s.kuyruk.is_empty():
		if s.kuyruk.size() >= 128:
			r.neden = "kuyruk_dolu"
			return r
		s.kuyruk.append(d)
		r.kuyrukta = true
		r.neden = "kuyrukta"
	elif not _baslat(o,s,d):
		r.neden = "bedel"
		return r
	else: r.ok = true
	_yaz(o.yonetim,s)
	return r
static func isci_degistir(o: Oturum, id: String, oda_id: int, isci_id: int) -> bool:
	var d := {"defter":id,"oda":oda_id,"isci":isci_id}
	if not _neden(o,d).is_empty(): return false
	var s := durum(o.yonetim)
	if not s.aktif.is_empty() and s.aktif.defter == id:
		s.aktif.oda = oda_id
		s.aktif.isci = isci_id
		_yaz(o.yonetim,s)
		return true
	for siradaki in s.kuyruk:
		if siradaki.defter == id:
			siradaki.oda = oda_id
			siradaki.isci = isci_id
			_yaz(o.yonetim,s)
			return true
	return false

## Önceki iş bitince sıradaki mevcut gecenin başında tek kez ücretlendirilir.
static func gece_baslat(o: Oturum) -> void:
	if not dogrula().is_empty(): return
	var s := durum(o.yonetim)
	if not s.aktif.is_empty() or s.kuyruk.is_empty(): return
	var sonraki: Dictionary = s.kuyruk[0]
	if _baslat(o,s,sonraki):
		s.kuyruk.pop_front()
		_yaz(o.yonetim,s)

## Fiili çalışma izni gece başında alınır; gece sonu iyileşmesi geriye çalışma yazmaz.
static func gece_fotografi(o: Oturum) -> Dictionary:
	var s := durum(o.yonetim)
	if s.aktif.is_empty(): return {}
	return {"gun":o.gun,"defter":s.aktif.defter,"oda":s.aktif.oda,"isci":s.aktif.isci,"uygun":_neden(o,s.aktif).is_empty()}

## Aynı gerçek gece ikinci ilerleme/bitiş yok; mevsim kaydı gece başında alınır.
static func gece(o: Oturum, rapor: Dictionary, mevsim: Dictionary, calisma: Dictionary = {}) -> void:
	var s := durum(o.yonetim)
	if s.aktif.is_empty() or not o.yonetim.son.is_empty() or int(s.son_gece) >= o.gun: return
	s.son_gece = o.gun
	if calisma.get("uygun",false) == true and calisma.get("gun",-2) == o.gun - 1 and calisma.get("defter") == s.aktif.defter and calisma.get("oda") == s.aktif.oda and calisma.get("isci") == s.aktif.isci and _neden(o,s.aktif).is_empty():
		var alan := String(DEFTERLER.AYAR.cozumleme.mevsim_carpani)
		var carpan: Variant = mevsim.get(alan)
		if (carpan is int or carpan is float) and is_finite(float(carpan)) and float(carpan) > 0:
			var id := String(s.aktif.defter)
			var veri: Dictionary = DEFTERLER.AYAR.defterler[id]
			var sure := float(veri.arastirma.sure_gun)
			s.aktif.ilerleme = minf(sure,float(s.aktif.ilerleme) + float(carpan))
			if float(s.aktif.ilerleme) >= sure:
				var kitap := _defter(o,id)
				kitap["cozuldu"] = true
				s.tamamlanan.append(id)
				var bilen := o.yonetim.koylu(int(s.aktif.isci))
				for k in o.yonetim.koylular:
					if k.bayrak_var("acl01_muhafiz") and k.saglik > 0:
						bilen = k
						break
				preload("res://src/koy/yapi_bilgisi.gd").ekle(bilen,PackedStringArray([String(veri.yapi)]))
				rapor["olaylar"].append({"anahtar":"koy.cozumleme.bitti","deger":[String(veri.ad)]})
				s.aktif = {}
	_yaz(o.yonetim,s)

## Tek mevcut üretim hesabına çarpan; bina seviyesi veya ikinci üretim motoru yok.
static func uretim_carpani(y: KoyYonetimi, tur: String) -> float:
	if tur != "hizarhane": return 1.0
	var carpan := 1.0
	for id in durum(y).tamamlanan:
		var sonuc: Dictionary = DEFTERLER.AYAR.defterler[id].arastirma.sonuc
		if sonuc.hedef_sistem == "hizarhane_uretimi": carpan *= float(sonuc.carpan)
	return carpan
