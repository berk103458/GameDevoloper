## YAP-03: ustalar kapıdan gelir — KAP-16 çekiciliği ve DNY olaylarıyla ağırlıklandırılır.
## İkinci bir gelen zarı açılmaz; kabulde ücret kamu kasasından düşer, muhafız kesesine dokunulmaz.
class_name UstaGelisi
extends RefCounted

const VERI_YOLU := "res://data/ustalar.json"
const META := &"yap03_ustalar"
const USTA_META := &"yap03_usta"
const GUN_META := &"yap03_gun"
const ILK_GUN := 6
const RET_BEKLEME := 5
const Barinak := preload("res://src/kapi/barinak_uyarisi.gd")
const YapiBilgisi := preload("res://src/koy/yapi_bilgisi.gd")
const SozSemasi := preload("res://src/soz/soz_semasi.gd")
const SozMotoru := preload("res://src/soz/soz_motoru.gd")

static var _ham_onbellek: Dictionary = {}


static func veri_oku(yol: String = VERI_YOLU) -> Dictionary:
	if yol == VERI_YOLU and not _ham_onbellek.is_empty():
		return _ham_onbellek
	if not FileAccess.file_exists(yol):
		return {}
	var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
	if not (veri is Dictionary):
		return {}
	if yol == VERI_YOLU:
		_ham_onbellek = veri
	return veri


## Tek bir usta kaydındaki şema/kural ihlallerini döndürür; `kalp` alanı 1 hata verir.
static func kayit_hatalari(kayit: Variant) -> Array[String]:
	var hatalar: Array[String] = []
	if not (kayit is Dictionary):
		hatalar.append("Usta kaydi Dictionary olmali.")
		return hatalar
	var d := kayit as Dictionary
	var cid := String(d.get("id", "")).strip_edges()
	if d.has("kalp"):
		hatalar.append("Usta kaydinda yasak kalp alani olamaz: %s" % cid)
	if cid.is_empty():
		hatalar.append("Usta kimligi bos olamaz.")
	if String(d.get("ad", "")).strip_edges().is_empty():
		hatalar.append("Usta adi bos olamaz: %s" % cid)
	if int(d.get("kademe", 0)) < 1:
		hatalar.append("Usta kademesi en az 1 olmali: %s" % cid)
	if String(d.get("soz_dosyasi", "")).strip_edges().is_empty():
		hatalar.append("Usta soz_dosyasi bos olamaz: %s" % cid)
	var pazarlik: Variant = d.get("pazarlik", {})
	if not (pazarlik is Dictionary) or int((pazarlik as Dictionary).get("ucret_koy_akce", 0)) <= 0:
		hatalar.append("Usta pazarlik ucret_koy_akce pozitif olmali: %s" % cid)
	elif (pazarlik as Dictionary).has("muhafiz_akce"):
		hatalar.append("Usta pazarlik muhafiz_akce iceremez: %s" % cid)
	if d.has("muhafiz_akce"):
		hatalar.append("Usta kaydi muhafiz_akce iceremez: %s" % cid)
	if not (d.get("yapi_bilgisi", null) is Array):
		hatalar.append("Usta yapi_bilgisi dizi olmali: %s" % cid)
	return hatalar


static func dogrula(veri: Variant = null) -> Array[String]:
	var d: Variant = veri_oku() if veri == null else veri
	var hatalar: Array[String] = []
	if not (d is Dictionary) or not ((d as Dictionary).get("ustalar", null) is Array):
		hatalar.append("ustalar dizisi gerekli.")
		return hatalar
	for u in ((d as Dictionary)["ustalar"] as Array):
		hatalar.append_array(kayit_hatalari(u))
	return hatalar


static func ustalar() -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	var ham: Variant = veri_oku().get("ustalar", [])
	if not (ham is Array):
		return sonuc
	for u in (ham as Array):
		if kayit_hatalari(u).is_empty():
			sonuc.append((u as Dictionary).duplicate(true))
	return sonuc


static func _varsayilan_durum() -> Dictionary:
	return {
		"ziyaret_sayisi": {},
		"bilgi_acilan": {},
		"ret_gunu": {},
		"son_gelis_gunu": -1,
		"son_karar_gunu": -1,
		"kuyruk_gunu": -1,
	}


static func durum(o: Oturum) -> Dictionary:
	if o == null:
		return _varsayilan_durum()
	return o.get_meta(META, _varsayilan_durum()).duplicate(true)


static func yukle(o: Oturum, v: Variant) -> void:
	if o == null:
		return
	var d := _varsayilan_durum()
	if v is Dictionary:
		var m := v as Dictionary
		if m.get("ziyaret_sayisi") is Dictionary:
			for k in (m["ziyaret_sayisi"] as Dictionary):
				d["ziyaret_sayisi"][String(k)] = maxi(0, int(m["ziyaret_sayisi"][k]))
		if m.get("bilgi_acilan") is Dictionary:
			for k in (m["bilgi_acilan"] as Dictionary):
				if bool(m["bilgi_acilan"][k]):
					d["bilgi_acilan"][String(k)] = true
		if m.get("ret_gunu") is Dictionary:
			for k in (m["ret_gunu"] as Dictionary):
				d["ret_gunu"][String(k)] = int(m["ret_gunu"][k])
		for alan in ["son_gelis_gunu", "son_karar_gunu", "kuyruk_gunu"]:
			if m.has(alan):
				d[alan] = int(m[alan])
	o.set_meta(META, d)


## KAP-16 çekiciliği + DNY dünya olayı ağırlık hesabı (ikinci bir gelen zarı açılmaz).
static func agirlik(o: Oturum, usta: Dictionary) -> float:
	var taban := maxf(0.05, float(usta.get("gelis_agirligi", 1.0)))
	if o == null or o.yonetim == null:
		return taban
	var y := o.yonetim
	var taban_sayi := maxf(1.0, float(GelenAkisi.ayar().get("taban_sayi", 2.0)))
	var cekim_carpani := clampf(GelenAkisi.cekicilik_sayisi(o) / taban_sayi, 0.25, 2.0)
	var esik: Dictionary = usta.get("cekim_esigi", {})
	var refah := EkonomikRefah.oku(y)
	var guv := KervanKorumasi.guvenlik(y)
	var bos_yatak := Barinak.toplam(y) - Barinak.dolu(y)
	var esik_tuttu := (
		refah >= int(esik.get("refah", 0))
		and guv >= int(esik.get("guvenlik", 0))
		and bos_yatak >= int(esik.get("yatak", 0))
	)
	var esik_carpani := 1.25 if esik_tuttu else 0.65
	var dunya_carpani := GelenAkisi.dunya_olayi_carpani(o)
	var isaretler := DunyaZamani.isaretler(o)
	var olay_carpanlari: Variant = usta.get("dunya_olayi_carpani", {})
	if olay_carpanlari is Dictionary:
		for olay_id in (olay_carpanlari as Dictionary):
			var sid := String(olay_id)
			if sid in isaretler or ("%s.etki" % sid) in isaretler or ("%s.kesin_haber" % sid) in isaretler:
				dunya_carpani *= maxf(0.1, float((olay_carpanlari as Dictionary)[olay_id]))
	return maxf(0.05, taban * cekim_carpani * esik_carpani * dunya_carpani)


static func _koyde_yasiyor_mu(o: Oturum, usta_id: String) -> bool:
	if o == null or o.yonetim == null or usta_id.is_empty():
		return false
	var id_sn := StringName(usta_id)
	for k in o.yonetim.koylular:
		if k.saglik > 0 and (k.adli_id == id_sn or k.bayrak_var("yap03_" + usta_id)):
			return true
	return false


static func _uygun_adaylar(o: Oturum, d: Dictionary, en_az_kademe: int = 1) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	var ret_gunu: Dictionary = d.get("ret_gunu", {})
	for u in ustalar():
		if int(u.get("kademe", 0)) < en_az_kademe:
			continue
		var uid := String(u.get("id", ""))
		if _koyde_yasiyor_mu(o, uid):
			continue
		var son_ret := int(ret_gunu.get(uid, -999))
		if son_ret == o.gun or (son_ret >= 0 and o.gun - son_ret < RET_BEKLEME):
			continue
		sonuc.append(u)
	return sonuc


static func _gun_uygun_mu(o: Oturum, d: Dictionary, adaylar: Array[Dictionary]) -> bool:
	if o == null or o.gun < ILK_GUN or adaylar.is_empty():
		return false
	if int(d.get("kuyruk_gunu", -1)) == o.gun:
		return false
	var toplam_w := 0.0
	for u in adaylar:
		toplam_w += agirlik(o, u)
	var ort_carpani := clampf((toplam_w / float(adaylar.size())) / 1.15, 0.5, 2.5)
	var aralik := clampi(roundi(6.0 / ort_carpani), 3, 10)
	var ilk_hedef := ILK_GUN + (absi(o.tohum) % 4)
	var son_gelis := int(d.get("son_gelis_gunu", -1))
	var hedef_gun := ilk_hedef if son_gelis < 0 else (son_gelis + aralik)
	return o.gun >= hedef_gun


static func _aday_sec(o: Oturum, d: Dictionary, adaylar: Array[Dictionary]) -> Dictionary:
	if adaylar.is_empty():
		return {}
	var bilgi_acilan: Dictionary = d.get("bilgi_acilan", {})
	var oncelikliler: Array[Dictionary] = []
	for u in adaylar:
		if not bool(bilgi_acilan.get(String(u.get("id", "")), false)):
			oncelikliler.append(u)
	var havuz := oncelikliler if not oncelikliler.is_empty() else adaylar
	var en_iyi: Dictionary = {}
	var en_skor := -1.0
	for i in havuz.size():
		var u := havuz[i]
		# Küçük deterministik sıra payı aynı tohum/gün için çeşitlilik verir; ikinci zar açmaz.
		var cesit := 1.0 + 0.02 * float((absi(o.tohum) + o.gun * 13 + i * 29) % 10)
		var skor := agirlik(o, u) * cesit
		if skor > en_skor:
			en_skor = skor
			en_iyi = u
	return en_iyi


static func soz_yukle(kayit: Dictionary, locale: String = "") -> Dictionary:
	var yol := String(kayit.get("soz_dosyasi", ""))
	if yol.is_empty():
		return {}
	var etkin_dil := TranslationServer.get_locale() if locale.is_empty() else locale
	if etkin_dil.begins_with("en"):
		var en_yol := yol.replace("res://data/soz/", "res://data/soz/en/")
		if FileAccess.file_exists(en_yol):
			yol = en_yol
	if not FileAccess.file_exists(yol):
		return {}
	var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
	if not (veri is Dictionary):
		return {}
	var d := veri as Dictionary
	if not SozSemasi.dogrula(d).is_empty():
		return {}
	var motor := SozMotoru.new()
	if motor.yukle(d, {"tansiyon": 0}).is_empty():
		return {}
	return d


static func kisi_sayisi(g: Gelen) -> int:
	if not ilgilenir(g):
		return 1
	var u: Dictionary = g.get_meta(USTA_META, {})
	var p: Variant = u.get("pazarlik", {})
	var uyeler: Array = p.get("aile_uyeleri", []) if p is Dictionary else []
	return 1 + uyeler.size()


static func ilgilenir(g: Gelen) -> bool:
	return g != null and g.has_meta(USTA_META)


static func gelen_olustur(o: Oturum, usta: Dictionary) -> Gelen:
	if not kayit_hatalari(usta).is_empty():
		return null
	var d := durum(o)
	var uid := String(usta.get("id", ""))
	var anahtarlar: Dictionary = usta.get("metin_anahtarlari", {})
	var soz_veri := soz_yukle(usta)
	var dugumler: Variant = soz_veri.get("dugumler", {})
	var g := Gelen.new()
	g.adli = false
	g.id = StringName(uid)
	g.ad_anahtari = String(anahtarlar.get("ad", usta.get("ad", "")))
	g.sinif = &"esnaf"
	g.portre = "zanaat_ustasi"
	g.stat = 8
	g.giris_anahtari = String(anahtarlar.get("gecmis", ""))
	var giris_soz := ""
	if dugumler is Dictionary and (dugumler as Dictionary).get("giris") is Dictionary:
		giris_soz = String(((dugumler as Dictionary)["giris"] as Dictionary).get("satir", ""))
	if bool((d.get("bilgi_acilan", {}) as Dictionary).get(uid, false)):
		var ikinci_satir := TranslationServer.translate(String(anahtarlar.get("ikinci_gelis", "")))
		g.acilis = ("%s\n%s" % [ikinci_satir, giris_soz]).strip_edges()
	else:
		g.acilis = giris_soz
	var ev_cevap := TranslationServer.translate(String(anahtarlar.get("pazarlik_ev", "")))
	if o != null and o.yonetim != null and not Barinak.yeter_mi(o.yonetim, 1 + (usta.get("pazarlik", {}) as Dictionary).get("aile_uyeleri", []).size()):
		ev_cevap = "%s\n%s" % [ev_cevap, Barinak.metin(o.yonetim, 1 + (usta.get("pazarlik", {}) as Dictionary).get("aile_uyeleri", []).size())]
	g.sorular = [
		PackedStringArray(["diyalog.kapi.usta.ucret", String(anahtarlar.get("pazarlik_ucret", ""))]),
		PackedStringArray(["diyalog.kapi.usta.ev", ev_cevap]),
		PackedStringArray(["diyalog.kapi.usta.aile", String(anahtarlar.get("pazarlik_aile", ""))]),
	]
	g.soru_ust = PackedInt32Array([-1, -1, -1])
	g.secenekler = PackedStringArray(["kabul", "ret"])
	g.esikler = PackedInt32Array()
	g.set_meta(USTA_META, usta.duplicate(true))
	g.set_meta(GUN_META, o.gun if o != null else 0)
	return g


static func ekle(o: Oturum, kuyruk: Array[Gelen]) -> void:
	if o == null or o.yonetim == null or o.yonetim.son != &"" or kuyruk.is_empty():
		return
	var d := durum(o)
	var adaylar := _uygun_adaylar(o, d, 1)
	if not _gun_uygun_mu(o, d, adaylar):
		return
	var usta := _aday_sec(o, d, adaylar)
	if usta.is_empty():
		return
	var g := gelen_olustur(o, usta)
	if g == null:
		return
	if GelenAkisi.serbest_akis_mi(o) and kuyruk.size() >= GelenAkisi.tavan():
		var degisti := false
		for i in range(kuyruk.size() - 1, -1, -1):
			var aday := kuyruk[i]
			if not aday.adli and aday.id == &"" and not GelenAkisi._ozel_ziyaret_mi(aday):
				kuyruk[i] = g
				degisti = true
				break
		if not degisti:
			kuyruk.append(g)
	else:
		kuyruk.append(g)
	d["kuyruk_gunu"] = o.gun
	d["son_gelis_gunu"] = o.gun
	o.set_meta(META, d)


static func karar_alt_yazi(o: Oturum, g: Gelen, anahtar: String) -> String:
	if not ilgilenir(g) or o == null or o.yonetim == null:
		return ""
	var u: Dictionary = g.get_meta(USTA_META, {})
	var p: Dictionary = u.get("pazarlik", {})
	var anahtarlar: Dictionary = u.get("metin_anahtarlari", {})
	if anahtar == "kabul":
		var ucret := int(p.get("ucret_koy_akce", 0))
		var kisi := kisi_sayisi(g)
		var yazi := "%d akçe (kamu kasası) · %d kişi" % [ucret, kisi]
		if not Barinak.yeter_mi(o.yonetim, kisi):
			yazi += "\n" + TranslationServer.translate(Barinak.UYARI)
		return yazi
	if anahtar == "ret":
		return TranslationServer.translate(String(anahtarlar.get("ret", "")))
	return ""


static func _bilinen_yapi_seti(y: KoyYonetimi) -> Dictionary:
	var seti := {}
	if y == null:
		return seti
	for k in y.koylular:
		if k.saglik <= 0:
			continue
		for tur in k.yapi_bilgisi:
			seti[String(tur)] = true
	return seti


static func karar(o: Oturum, g: Gelen, secim: StringName, _is_yeri: StringName = &"") -> Dictionary:
	var engel := {"engellendi": true, "kaldi": false, "kirilan": -1, "koylu_id": -1}
	if o == null or o.yonetim == null or not ilgilenir(g):
		return engel
	if secim not in [&"kabul", &"ret"]:
		return engel
	var u: Dictionary = g.get_meta(USTA_META, {})
	var uid := String(u.get("id", ""))
	if uid.is_empty():
		return engel
	var d := durum(o)
	var anahtarlar: Dictionary = u.get("metin_anahtarlari", {})
	var pazarlik: Dictionary = u.get("pazarlik", {})
	if secim == &"ret":
		(d["ret_gunu"] as Dictionary)[uid] = o.gun
		(d["ziyaret_sayisi"] as Dictionary)[uid] = int((d["ziyaret_sayisi"] as Dictionary).get(uid, 0)) + 1
		d["son_karar_gunu"] = o.gun
		o.set_meta(META, d)
		o.yonetim.ret(o.tr_gelen(g), true, String(u.get("zanaat_turu", "")))
		return {
			"engellendi": false,
			"kaldi": false,
			"kirilan": -1,
			"koylu_id": -1,
			"usta": true,
			"usta_id": uid,
			"bilgi_deltasi": 0,
			"sonuc_metin": TranslationServer.translate(String(anahtarlar.get("ret", ""))),
		}

	var ucret := maxi(0, int(pazarlik.get("ucret_koy_akce", 0)))
	o.koy_akce -= ucret
	var bilgi_zaten_acik := bool((d.get("bilgi_acilan", {}) as Dictionary).get(uid, false))
	var onceki_bilgi := _bilinen_yapi_seti(o.yonetim)
	var zanaat_adi := String(u.get("zanaat_turu", "ESNAF")).to_upper()
	var zanaat_kodu := ZanaatTuru.oku(zanaat_adi, ZanaatTuru.Tur.ESNAF)
	var usta_yapi := [] if bilgi_zaten_acik else Array(u.get("yapi_bilgisi", []))
	var k_usta := o.yonetim.kabul({
		"ad": o.tr_gelen(g),
		"adli_id": StringName(uid),
		"sinif": &"esnaf",
		"zanaat_turu": zanaat_kodu,
		"portre": "zanaat_ustasi",
		"stat": 8,
		"yapi_bilgisi": usta_yapi,
		"bayraklar": ["yap03_usta", "yap03_" + uid],
	})
	k_usta.hane_id = k_usta.id
	if not bilgi_zaten_acik:
		YapiBilgisi.ekle(k_usta, YapiKilidi.bilgi_oku(u.get("yapi_bilgisi", [])))
		(d["bilgi_acilan"] as Dictionary)[uid] = true
	else:
		# İkinci ziyarette usta yeni yapı bilgisi açmaz (bilgi deltası = 0).
		var korunan := PackedStringArray()
		for tur in k_usta.yapi_bilgisi:
			if onceki_bilgi.has(String(tur)):
				korunan.append(String(tur))
		k_usta.yapi_bilgisi = korunan

	var aile: Array = pazarlik.get("aile_uyeleri", [])
	var kabul_edilen := 1
	for uye_ham in aile:
		if not (uye_ham is Dictionary):
			continue
		var uye := uye_ham as Dictionary
		var yg := String(uye.get("yas_grubu", "yetiskin"))
		var bayraklar := ["yap03_usta_ailesi", "yap03_" + uid]
		if bool(uye.get("cirak_adayi", false)):
			bayraklar.append("cirak_adayi")
		var k_uye := o.yonetim.kabul({
			"ad": String(uye.get("ad", "")),
			"sinif": &"ciftci",
			"yas_grubu": YasRolleri.oku(yg, &""),
			"portre": "farmer_02" if yg == "yetiskin" else "farmer_01",
			"stat": 4,
			"bayraklar": bayraklar,
		})
		k_uye.hane_id = k_usta.id
		kabul_edilen += 1

	o.yonetim._barindir()
	o._koy_esitle()
	var sonraki_bilgi := _bilinen_yapi_seti(o.yonetim)
	var bilgi_deltasi := 0 if bilgi_zaten_acik else maxi(0, sonraki_bilgi.size() - onceki_bilgi.size())
	(d["ziyaret_sayisi"] as Dictionary)[uid] = int((d["ziyaret_sayisi"] as Dictionary).get(uid, 0)) + 1
	d["son_karar_gunu"] = o.gun
	o.set_meta(META, d)
	var sonuc_anahtari := String(anahtarlar.get("ikinci_gelis" if bilgi_zaten_acik else "kabul", ""))
	return {
		"engellendi": false,
		"kaldi": true,
		"kirilan": -1,
		"koylu_id": k_usta.id,
		"usta": true,
		"usta_id": uid,
		"kabul_edilen": kabul_edilen,
		"ucret_koy_akce": ucret,
		"bilgi_deltasi": bilgi_deltasi,
		"ikinci_ziyaret": bilgi_zaten_acik,
		"sonuc_metin": TranslationServer.translate(sonuc_anahtari),
	}
