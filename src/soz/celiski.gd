## DYL-01: Çelişki ve yüzleşme — oyuncu defterden iki kaydı kendisi eşleştirir.
## `CeliskiYuzlesme`, `SozMotoru`, `BeyanDefteri` ve `ChrSorgusu` arasında tek merkezdir.
class_name Celiski
extends RefCounted

const AZAMI_YANLIS := 3
const YARDIM_GUN_SINIRI := 3
const VARSAYILAN_TEPKI := "Ne alakası var bunun?"

var kayitlar: Array[Dictionary] = []
var celiskiler: Array[Dictionary] = []
var yanlis_denemeler: Dictionary = {}
var cozulen_celiskiler: Dictionary = {}
var yanlis_sayisi: int = 0
var tansiyon: int = 0
var goster_kapali: bool = false
var tepki_satiri: String = VARSAYILAN_TEPKI


static func yardim_acik_mi(oturum: Object = null, ayarlar: Object = null) -> bool:
	if ayarlar != null:
		var degerler: Variant = ayarlar.get("degerler")
		if degerler is Dictionary and (degerler as Dictionary).has(&"celiski_yardimi"):
			return bool((degerler as Dictionary)[&"celiski_yardimi"])
	if oturum == null:
		return true
	var gun_val: Variant = oturum.get("gun")
	if gun_val == null:
		return true
	return int(gun_val) <= YARDIM_GUN_SINIRI


static func anahtar(id_1: String, id_2: String) -> String:
	var a := id_1.strip_edges()
	var b := id_2.strip_edges()
	if a <= b:
		return "%s|%s" % [a, b]
	return "%s|%s" % [b, a]


func sifirla() -> void:
	kayitlar.clear()
	celiskiler.clear()
	yanlis_denemeler.clear()
	cozulen_celiskiler.clear()
	yanlis_sayisi = 0
	tansiyon = 0
	goster_kapali = false
	tepki_satiri = VARSAYILAN_TEPKI


func kayit_ekle(kayit: Dictionary) -> bool:
	var kim := String(kayit.get("id", kayit.get("ipucu_id", ""))).strip_edges()
	if kim.is_empty():
		return false
	for mevcut in kayitlar:
		if String(mevcut.get("id", "")) == kim:
			return false
	var kopya := kayit.duplicate(true)
	kopya["id"] = kim
	if String(kopya.get("tur", "")).is_empty():
		kopya["tur"] = "ipucu" if kim.begins_with("Clue_") or kim.begins_with("clue_") else "beyan"
	if String(kopya.get("kaynak", "")).is_empty():
		kopya["kaynak"] = "Gözlem / İnceleme" if String(kopya["tur"]) == "ipucu" else "Sorgu"
	if String(kopya.get("metin", "")).is_empty():
		kopya["metin"] = kim
	kayitlar.append(kopya)
	return true


func celiski_ekle(a: String, b: String, dal: String = "yuzlesme", guc: String = "guclu") -> void:
	var id_a := a.strip_edges()
	var id_b := b.strip_edges()
	if id_a.is_empty() or id_b.is_empty() or id_a == id_b:
		return
	var k := anahtar(id_a, id_b)
	for c in celiskiler:
		if anahtar(String(c.get("a", "")), String(c.get("b", ""))) == k and String(c.get("dal", "")) == dal:
			return
	celiskiler.append({
		"a": id_a,
		"b": id_b,
		"dal": dal if not dal.is_empty() else "yuzlesme",
		"guc": guc if not guc.is_empty() else "guclu",
	})


func kayitlari_al(motor: SozMotoru = null, defter: BeyanDefteri = null, sorgu: RefCounted = null) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	var goruldu: Dictionary = {}
	for k in kayitlar:
		var kid := String(k.get("id", ""))
		if not kid.is_empty() and not goruldu.has(kid):
			goruldu[kid] = true
			sonuc.append(_kayit_durumuyla(k))
	if motor != null:
		for b in motor.beyan_defteri:
			var bid := String(b.get("id", ""))
			if not bid.is_empty() and not goruldu.has(bid):
				goruldu[bid] = true
				var kopya := (b as Dictionary).duplicate(true)
				kopya["tur"] = String(kopya.get("tur", "beyan"))
				if String(kopya.get("kaynak", "")).is_empty():
					kopya["kaynak"] = "Düğüm: %s" % String(kopya.get("dugum", "giris"))
				sonuc.append(_kayit_durumuyla(kopya))
	if defter != null:
		for b in defter.tum_beyanlar():
			var bid := String(b.get("id", ""))
			if not bid.is_empty() and not goruldu.has(bid):
				goruldu[bid] = true
				var kopya := (b as Dictionary).duplicate(true)
				kopya["tur"] = "beyan"
				if String(kopya.get("kaynak", "")).is_empty():
					kopya["kaynak"] = "Beyan defteri"
				sonuc.append(_kayit_durumuyla(kopya))
	if sorgu != null:
		for ip in sorgu.ipuclari.keys():
			var iid := String(ip)
			if not iid.is_empty() and not goruldu.has(iid):
				goruldu[iid] = true
				sonuc.append(_kayit_durumuyla({
					"id": iid,
					"ipucu_id": iid,
					"tur": "ipucu",
					"metin": _ipucu_basligi(sorgu, iid),
					"kaynak": "İnceleme / Bakış",
				}))
	return sonuc


## SOY-10: oturum verilirse ağa düşen kayıt deftere tek satır olarak eklenir.
func kayitlari_al_oturumla(
	motor: SozMotoru = null,
	defter: BeyanDefteri = null,
	sorgu: RefCounted = null,
	oturum: Object = null,
	gelen_id: String = ""
) -> Array[Dictionary]:
	var sonuc := _kayit_govdesi(motor, defter, sorgu)
	var goruldu := {}
	for k in sonuc:
		goruldu[String(k.get("id", ""))] = true
	var yedek: String = _soylenti_betik().gelen_kimligi(sorgu)
	var gid: String = gelen_id if not gelen_id.is_empty() else yedek
	return _soylenti_ekle(sonuc, goruldu, oturum, gid)


func goster_acik(
	motor: SozMotoru = null,
	defter: BeyanDefteri = null,
	sorgu: RefCounted = null,
	oturum: Object = null,
	gelen_id: String = ""
) -> bool:
	if goster_kapali or yanlis_sayisi >= AZAMI_YANLIS:
		return false
	return kayitlari_al_oturumla(motor, defter, sorgu, oturum, gelen_id).size() >= 2


func cozuldu_mu(id_1: String, id_2: String = "") -> bool:
	if not id_2.is_empty():
		return cozulen_celiskiler.has(anahtar(id_1, id_2))
	if celiskiler.is_empty():
		return false
	var eslesen := 0
	var cozulen := 0
	for c in celiskiler:
		var a := String(c.get("a", ""))
		var b := String(c.get("b", ""))
		if a == id_1 or b == id_1:
			eslesen += 1
			if cozulen_celiskiler.has(anahtar(a, b)):
				cozulen += 1
	return eslesen > 0 and eslesen == cozulen


func denendi_mi(id_1: String, id_2: String) -> bool:
	return yanlis_denemeler.has(anahtar(id_1, id_2))


func yuzles(id_1: String, id_2: String, ctx: Dictionary = {}) -> Dictionary:
	var a := id_1.strip_edges()
	var b := id_2.strip_edges()
	if a.is_empty() or b.is_empty() or a == b:
		return {"basarili": false, "sebep": "ayni_veya_bos", "tansiyon_degismedi": true}

	var motor: SozMotoru = ctx.get("motor") as SozMotoru
	var defter: BeyanDefteri = ctx.get("defter") as BeyanDefteri
	var sorgu: RefCounted = ctx.get("sorgu")
	var oturum: Object = ctx.get("oturum")
	var gelen_id := String(ctx.get("gelen_id", ""))

	if not goster_acik(motor, defter, sorgu, oturum, gelen_id):
		var sebep := "goster_kapali" if (goster_kapali or yanlis_sayisi >= AZAMI_YANLIS) else "tek_kayit"
		return {"basarili": false, "sebep": sebep, "goster_kapali": goster_kapali}

	var cift_anahtar := anahtar(a, b)
	if cozulen_celiskiler.has(cift_anahtar):
		return {"basarili": false, "sebep": "zaten_cozuldu"}
	if yanlis_denemeler.has(cift_anahtar):
		return {"basarili": false, "sebep": "tekrar_deneme", "tepki": tepki_satiri}

	var tum := kayitlari_al_oturumla(motor, defter, sorgu, oturum, gelen_id)
	var k1 := _kayit_bul(tum, a)
	var k2 := _kayit_bul(tum, b)
	if k1.is_empty() or k2.is_empty():
		return {"basarili": false, "sebep": "kayit_bulunamadi"}

	# SOY-10: ağ kaydı doğruysa zarsız yüzleşme, yanlışsa yalnız tansiyon +1.
	var soylenti_sonuc: Dictionary = _soylenti_betik().dene(self, a, b, k1, k2, ctx)
	if not soylenti_sonuc.is_empty():
		return soylenti_sonuc

	var eslesen_celiski := _celiski_bul(a, b, motor)
	var eslesme_var := not eslesen_celiski.is_empty()
	if not eslesme_var:
		var alt := CeliskiYuzlesme.eslestir(k1, k2, null)
		eslesme_var = bool(alt.get("basarili", false))

	if eslesme_var:
		cozulen_celiskiler[cift_anahtar] = true
		var dal := String(eslesen_celiski.get("dal", "yuzlesme"))
		var guc := String(eslesen_celiski.get("guc", "guclu"))
		if dal.is_empty():
			dal = "yuzlesme"
		var satir := ""
		var yuzlesme_acildi := false
		if motor != null and motor.dugumler.has(dal):
			motor.aktif_dugum = motor.dugumler[dal]
			motor._satiri_isle(motor.aktif_dugum, {})
			satir = motor.son_satir
			yuzlesme_acildi = true
		elif motor != null and motor.dugumler.has("yuzlesme"):
			motor.aktif_dugum = motor.dugumler["yuzlesme"]
			motor._satiri_isle(motor.aktif_dugum, {})
			satir = motor.son_satir
			yuzlesme_acildi = true
		if sorgu != null and sorgu.has_method("celiski_dalina_gec"):
			var delta := int(eslesen_celiski.get("tansiyon_delta", 0))
			if bool(sorgu.call("celiski_dalina_gec", StringName(dal), delta)):
				yuzlesme_acildi = true
				var dugum: Dictionary = sorgu.karakter.diyalog_dugumu(sorgu.dugum_id)
				satir = String(sorgu.metin(StringName(dugum.get("replik_anahtari", ""))))
		return {
			"basarili": true,
			"yuzlesme_acildi": yuzlesme_acildi,
			"dal": dal,
			"guc": guc,
			"zayif_zar": guc == "zayif",
			"kanit_degistirici": -1 if guc == "zayif" else 0,
			"satir": satir,
		}

	yanlis_denemeler[cift_anahtar] = true
	yanlis_sayisi += 1
	tansiyon += 1
	if yanlis_sayisi >= AZAMI_YANLIS:
		goster_kapali = true
	var yeni_guven := -1
	var yeni_sabir := -1
	if motor != null:
		motor.guven = clampi(motor.guven - 2, 0, 10)
		motor.sabir = maxi(motor.sabir - 1, 0)
		yeni_guven = motor.guven
		yeni_sabir = motor.sabir
	var yeni_tansiyon := tansiyon
	if sorgu != null:
		if sorgu.has_method("tansiyon_artir"):
			sorgu.tansiyon_artir(1)
		else:
			sorgu.tansiyon = clampi(int(sorgu.tansiyon) + 1, 0, 10)
			sorgu.tansiyon_degisti.emit(sorgu.tansiyon)
		yeni_tansiyon = sorgu.tansiyon
	return {
		"basarili": false,
		"sebep": "celiski_yok",
		"tepki": tepki_satiri,
		"yanlis_sayisi": yanlis_sayisi,
		"goster_kapali": goster_kapali,
		"guven": yeni_guven,
		"sabir": yeni_sabir,
		"tansiyon": yeni_tansiyon,
		"gozdagi_artis": 1 if goster_kapali else 0,
	}


func _kayit_durumuyla(k: Dictionary) -> Dictionary:
	var kopya := k.duplicate(true)
	kopya["cozuldu"] = cozuldu_mu(String(kopya.get("id", "")))
	return kopya


func _kayit_bul(tum: Array[Dictionary], kim: String) -> Dictionary:
	for k in tum:
		if String(k.get("id", "")) == kim:
			return k
	return {}


func _celiski_bul(a: String, b: String, motor: SozMotoru = null) -> Dictionary:
	var hedef_anahtar := anahtar(a, b)
	for c in celiskiler:
		if anahtar(String(c.get("a", "")), String(c.get("b", ""))) == hedef_anahtar:
			return c
	if motor != null:
		for c in motor.celiskiler:
			if c is Dictionary and anahtar(String(c.get("a", "")), String(c.get("b", ""))) == hedef_anahtar:
				return c
	return {}


func _kayit_govdesi(motor: SozMotoru, defter: BeyanDefteri, sorgu: RefCounted) -> Array[Dictionary]:
	return kayitlari_al(motor, defter, sorgu)


func _soylenti_ekle(sonuc: Array[Dictionary], goruldu: Dictionary, oturum: Object, gelen_id: String) -> Array[Dictionary]:
	if oturum == null:
		return sonuc
	var ekler: Array = _soylenti_betik().defter_kayitlari(oturum, sonuc, gelen_id)
	for ham in ekler:
		if not ham is Dictionary:
			continue
		var ek: Dictionary = ham
		var eid := String(ek.get("id", ""))
		if eid.is_empty() or goruldu.has(eid):
			continue
		goruldu[eid] = true
		sonuc.append(_kayit_durumuyla(ek))
	return sonuc


func _soylenti_betik() -> GDScript:
	return load("res://src/kapi/soylenti_dogrulama.gd") as GDScript


func _ipucu_basligi(sorgu: RefCounted, iid: String) -> String:
	if sorgu == null or sorgu.get("karakter") == null:
		return iid
	var baslik_anahtar := iid.to_upper().replace("GÖRSEL", "GORSEL") + "_BASLIK"
	var m: Variant = sorgu.karakter.get("metinler")
	if m is Dictionary and (m as Dictionary).has(baslik_anahtar):
		return String((m as Dictionary)[baslik_anahtar])
	return iid
