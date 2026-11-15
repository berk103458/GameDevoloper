## SOY-10: Kapıdaki beyan, söylenti ağındaki kayıtla çelişirse deftere tek satır düşer.
## Ağ SoylentiKoprusu.ag üzerinden okunur; ikinci defter, ikinci kayıt ve ikinci çelişki yoktur.
class_name SoylentiDogrulama
extends RefCounted

const IFADE_ANAHTARI := "kapi.soylenti.koyde_baska"
const YANILMA_ANAHTARI := "kapi.soylenti.yanilma"
const TUR := "soylenti"


static func gelen_kimligi(sorgu: RefCounted) -> String:
	if sorgu == null:
		return ""
	var karakter := sorgu.get("karakter") as KarakterVerisi
	if karakter == null:
		return ""
	var kim := String(karakter.id).strip_edges()
	if kim.is_empty():
		kim = String(karakter.entity_id).strip_edges()
	return kim


static func kayit_kimligi(olay_id: String) -> String:
	var s := "soylenti_"
	for c in olay_id:
		var harf := c >= "a" and c <= "z"
		var buyuk := c >= "A" and c <= "Z"
		var rakam := c >= "0" and c <= "9"
		s += c if harf or buyuk or rakam or c == "_" else "_"
	return s


## Defterde duran beyana uyan canlı ağ kayıtları. Ağ yoksa boş dizi; oturuma yazılmaz.
static func defter_kayitlari(oturum: Object, beyanlar: Array, gelen_id: String) -> Array[Dictionary]:
	var bos: Array[Dictionary] = []
	if oturum == null or not oturum.has_meta(SoylentiKoprusu.META):
		return bos
	var kume := _beyan_kumesu(beyanlar, gelen_id)
	if kume.is_empty():
		return bos
	var ag := SoylentiKoprusu.ag(oturum) as SoylentiAgi
	if ag == null:
		return bos
	var ifade := GuvenliMetin.metin(IFADE_ANAHTARI)
	var sonuc: Array[Dictionary] = []
	for ham in ag.ag_kayitlari.keys():
		var olay_id := String(ham)
		var kayit: Dictionary = ag.ag_kayitlari[ham]
		if bool(kayit.get("susturuldu", false)) or bool(kayit.get("hukme_baglandi", false)):
			continue
		if not _celisir(olay_id, kayit, kume, gelen_id):
			continue
		var cumle := SoylentiKoprusu.olay_metni(ag, kayit).strip_edges()
		if cumle.is_empty():
			cumle = ifade
		sonuc.append({
			"id": kayit_kimligi(olay_id),
			"olay_id": olay_id,
			"tur": TUR,
			"dogru": bool(kayit.get("dogru", true)),
			"metin": cumle,
			"kaynak": ifade,
			"etiket": ifade,
		})
	return sonuc


## Beyan + ağ kaydı çiftiyse sonucu döner. Değilse boş sözlük; DYL-01 yolu sürer.
static func dene(
	celiski: Celiski,
	id_a: String,
	id_b: String,
	k1: Dictionary,
	k2: Dictionary,
	ctx: Dictionary
) -> Dictionary:
	var sol := k1 if String(k1.get("tur", "")) == TUR else {}
	var sag := k2 if String(k2.get("tur", "")) == TUR else {}
	if sol.is_empty() and sag.is_empty():
		return {}
	if not sol.is_empty() and not sag.is_empty():
		return {}
	var soylenti := sol if not sol.is_empty() else sag
	var beyan := k2 if not sol.is_empty() else k1
	if String(beyan.get("tur", "")) == "ipucu":
		return {}
	if bool(soylenti.get("dogru", true)):
		return _yuzlesme(celiski, id_a, id_b, beyan, soylenti, ctx)
	return _yanilma(celiski, id_a, id_b, ctx)


static func _beyan_kumesu(beyanlar: Array, gelen_id: String) -> Dictionary:
	var kume := {}
	for ham in beyanlar:
		if not ham is Dictionary:
			continue
		var kayit: Dictionary = ham
		var tur := String(kayit.get("tur", "beyan"))
		if tur == "ipucu" or tur == TUR:
			continue
		for alan in ["id", "olay_id", "celisir_ile", "kisi", "kanit_id"]:
			_ekle(kume, String(kayit.get(alan, "")))
	if not kume.is_empty():
		_ekle(kume, gelen_id)
	return kume


static func _ekle(kume: Dictionary, deger: String) -> void:
	var temiz := deger.strip_edges().to_lower()
	if not temiz.is_empty():
		kume[temiz] = true


static func _celisir(olay_id: String, kayit: Dictionary, kume: Dictionary, gelen_id: String) -> bool:
	var dusuk := olay_id.strip_edges().to_lower()
	if dusuk.is_empty():
		return false
	if kume.has(dusuk):
		return true
	var kisi := String(kayit.get("kisi", kayit.get("gelen", ""))).strip_edges().to_lower()
	if not kisi.is_empty() and kume.has(kisi):
		return true
	var gid := gelen_id.strip_edges().to_lower()
	if gid.is_empty():
		return false
	return dusuk == gid or dusuk.ends_with("_" + gid)


static func _yuzlesme(
	celiski: Celiski,
	id_a: String,
	id_b: String,
	beyan: Dictionary,
	soylenti: Dictionary,
	ctx: Dictionary
) -> Dictionary:
	celiski.cozulen_celiskiler[Celiski.anahtar(id_a, id_b)] = true
	var motor := ctx.get("motor") as SozMotoru
	var sorgu := ctx.get("sorgu") as RefCounted
	var dal := _dal_sec(celiski, String(beyan.get("id", "")), String(soylenti.get("id", "")), motor, sorgu)
	var acilis := _dali_ac(dal, motor, sorgu)
	return {
		"basarili": true,
		"yuzlesme_acildi": bool(acilis.get("acildi", false)),
		"dal": String(acilis.get("dal", dal)),
		"guc": "guclu",
		"zayif_zar": false,
		"kanit_degistirici": 0,
		"soylenti": true,
		"satir": String(acilis.get("satir", "")),
	}


static func _yanilma(celiski: Celiski, id_a: String, id_b: String, ctx: Dictionary) -> Dictionary:
	celiski.yanlis_denemeler[Celiski.anahtar(id_a, id_b)] = true
	celiski.tansiyon += 1
	var sorgu := ctx.get("sorgu") as ChrSorgusu
	var yeni := celiski.tansiyon
	if sorgu != null:
		sorgu.tansiyon = clampi(sorgu.tansiyon + 1, 0, 10)
		sorgu.tansiyon_degisti.emit(sorgu.tansiyon)
		yeni = sorgu.tansiyon
	return {
		"basarili": false,
		"sebep": "soylenti_yanlis",
		"yuzlesme_acildi": false,
		"zayif_zar": false,
		"kanit_degistirici": 0,
		"soylenti": true,
		"tepki": GuvenliMetin.metin(YANILMA_ANAHTARI),
		"tansiyon": yeni,
		"tansiyon_delta": 1,
		"yanlis_sayisi": celiski.yanlis_sayisi,
		"goster_kapali": celiski.goster_kapali,
	}


static func _dal_sec(
	celiski: Celiski,
	beyan_id: String,
	soylenti_id: String,
	motor: SozMotoru,
	sorgu: RefCounted
) -> String:
	var tam := Celiski.anahtar(beyan_id, soylenti_id)
	var bulunan := _dal_ara(celiski.celiskiler, tam, beyan_id)
	if bulunan.is_empty() and motor != null:
		bulunan = _dal_ara(motor.celiskiler, tam, beyan_id)
	if not bulunan.is_empty() and _dal_var(bulunan, motor, sorgu):
		return bulunan
	if _dal_var("yuzlesme", motor, sorgu):
		return "yuzlesme"
	return bulunan if not bulunan.is_empty() else "yuzlesme"


static func _dal_ara(liste: Array, tam: String, beyan_id: String) -> String:
	var yedek := ""
	for ham in liste:
		if not ham is Dictionary:
			continue
		var c: Dictionary = ham
		var dal := String(c.get("dal", "")).strip_edges()
		if dal.is_empty():
			continue
		var a := String(c.get("a", ""))
		var b := String(c.get("b", ""))
		if Celiski.anahtar(a, b) == tam:
			return dal
		if yedek.is_empty() and (a == beyan_id or b == beyan_id):
			yedek = dal
	return yedek


static func _dal_var(dal: String, motor: SozMotoru, sorgu: RefCounted) -> bool:
	if dal.is_empty():
		return false
	var chr := sorgu as ChrSorgusu
	if chr != null and chr.karakter != null and chr.karakter.diyalog_dugumleri.has(dal):
		return true
	return motor != null and motor.dugumler.has(dal)


static func _dali_ac(dal: String, motor: SozMotoru, sorgu: RefCounted) -> Dictionary:
	var chr := sorgu as ChrSorgusu
	if chr != null and chr.celiski_dalina_gec(StringName(dal), 0):
		var dugum := chr.karakter.diyalog_dugumu(chr.dugum_id)
		var satir := chr.metin(StringName(dugum.get("replik_anahtari", "")))
		return {"acildi": true, "dal": String(chr.dugum_id), "satir": satir}
	if motor == null:
		return {"acildi": false, "dal": dal, "satir": ""}
	var hedef := dal
	if not motor.dugumler.has(hedef) and motor.dugumler.has("yuzlesme"):
		hedef = "yuzlesme"
	if not motor.dugumler.has(hedef):
		return {"acildi": false, "dal": dal, "satir": ""}
	motor.aktif_dugum = motor.dugumler[hedef]
	motor._satiri_isle(motor.aktif_dugum, {})
	return {"acildi": true, "dal": hedef, "satir": motor.son_satir}
