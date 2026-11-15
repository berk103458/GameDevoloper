## KAP-16: Perde 1 değişken gelen sayısı, boş gün ve canlı bar spawn değerlendirmesi.
## Sayı ve oranlar data/gelen_akisi.json içindedir; Perde 2 perde2_gece_basina_gelen'i korur.
class_name GelenAkisi
extends RefCounted

const VERI_YOLU := "res://data/gelen_akisi.json"
const CIKIS_META := &"kap_bu_gece_cikanlar"

static var _ayar_onbellek: Dictionary = {}
static var _chr_onbellek: Dictionary = {}
static var _bar_rx: RegEx = null


static func ayar() -> Dictionary:
	if not _ayar_onbellek.is_empty():
		return _ayar_onbellek
	if FileAccess.file_exists(VERI_YOLU):
		var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(VERI_YOLU))
		if veri is Dictionary:
			_ayar_onbellek = veri
			return _ayar_onbellek
	return {}


static func tavan() -> int:
	return maxi(0, int(ayar().get("tavan", 3)))


static func serbest_akis_mi(o: Oturum) -> bool:
	return o != null and o.perde == 1 and o.ayarlar != null and o.ayarlar.gece_basina_gelen <= 0


static func _deterministik_sans(tohum: int, gun: int, tuz: int = 0) -> RandomNumberGenerator:
	var rng := RandomNumberGenerator.new()
	var h := hash([tohum, gun, tuz, "gelen_akisi"])
	rng.seed = int(h) if h != 0 else 1
	return rng


static func bos_gun_mu(o: Oturum) -> bool:
	if not serbest_akis_mi(o) or o.yonetim == null or o.yonetim.son != &"":
		return false
	var g := o.gun
	if g < 0:
		return false
	var cfg: Dictionary = ayar().get("bos_gun", {})
	var yasak: Array = cfg.get("yasak_gunler", [])
	for y_gun in yasak:
		if int(y_gun) == g:
			return false
	var hafta_gunu := maxi(1, int(cfg.get("hafta_gunu", 7)))
	var hafta := g / hafta_gunu
	var gun_ici := g % hafta_gunu
	var ilk_izinli: Array = cfg.get("ilk_hafta_izinli_gunler", [])
	if hafta == 0 and not ilk_izinli.is_empty():
		var secilen := int(ilk_izinli[_deterministik_sans(o.tohum, hafta, 11).randi_range(0, ilk_izinli.size() - 1)])
		if g == secilen:
			return true
		var izinli_mi := false
		for d in ilk_izinli:
			if int(d) == g:
				izinli_mi = true
				break
		if not izinli_mi:
			return false
	else:
		var garanti := int(cfg.get("haftalik_garanti", 1))
		if garanti > 0:
			var secilen_gun := _deterministik_sans(o.tohum, hafta, 11).randi_range(0, hafta_gunu - 1)
			if hafta == 0 and secilen_gun == 0:
				secilen_gun = 1
			if gun_ici == secilen_gun:
				return true
	var p := float(cfg.get("olasilik", 0.0))
	var mevsim_bilgi := MevsimYoneticisi.durum(o.yonetim)
	if int(mevsim_bilgi.get("mevsim", 0)) == MevsimYoneticisi.MEVSIM_SAYISI - 1:
		p += float(cfg.get("kis_ek_olasilik", 0.0))
	if Omurga.donem(o.yonetim) == Omurga.DONEM_OTURMA:
		p += float(Omurga.bos_gun_olasiliklari().get("perde1_oturma", 0.0))
	return p > 0.0 and _deterministik_sans(o.tohum, g, 29).randf() < p


static func mevsim_carpani(y: KoyYonetimi) -> float:
	var carpanlar: Array = ayar().get("mevsim_carpani", [])
	if y == null or carpanlar.is_empty():
		return 1.0
	var d := MevsimYoneticisi.durum(y)
	var idx := clampi(int(d.get("mevsim", 0)), 0, carpanlar.size() - 1)
	return float(carpanlar[idx])


static func dunya_olayi_carpani(o: Oturum) -> float:
	if o == null or o.yonetim == null or o.yonetim.son != &"":
		return 1.0
	var isaretler := DunyaZamani.isaretler(o)
	var etkiler: Dictionary = DunyaEtkisi.temiz_etkiler(o.dunya_zamani.get("etkiler", {}))
	var carpan := DunyaEtkisi.o_carpani(o, "gelen_akisi")
	for olay in DunyaZamani.gecerli_olaylar():
		var oid := String(olay.get("id", "")).strip_edges()
		if etkiler.has(oid) or not ("%s.etki" % oid in isaretler):
			continue
		var evreler: Variant = olay.get("evreler", {})
		if not (evreler is Dictionary):
			continue
		var etki: Variant = (evreler as Dictionary).get("etki", {})
		if etki is Dictionary and String((etki as Dictionary).get("hedef_kapi", "")) == "gelen_akisi":
			carpan *= float((etki as Dictionary).get("carpan", 1.0))
	return carpan


static func cekicilik_sayisi(o: Oturum) -> float:
	var c: Dictionary = ayar().get("cekicilik", {})
	var taban := float(ayar().get("taban_sayi", 2.0))
	if o == null or o.yonetim == null:
		return taban
	var y := o.yonetim
	var refah := float(clampi(EkonomikRefah.oku(y), 0, 100))
	var guvenlik := float(clampi(KervanKorumasi.guvenlik(y), 0, 100))
	var refah_olcek := maxf(1.0, float(c.get("refah_olcek", 50.0)))
	var guv_olcek := maxf(1.0, float(c.get("guvenlik_olcek", 30.0)))
	var refah_katki := ((refah - float(c.get("refah_referans", 50.0))) / refah_olcek) * float(c.get("refah_agirlik", 0.45))
	var guv_katki := ((guvenlik - float(c.get("guvenlik_referans", 70.0))) / guv_olcek) * float(c.get("guvenlik_agirlik", 0.45))
	var bos_yatak := y.yatak_kapasitesi() - y.nufus()
	var yatak_katki := 0.0
	if bos_yatak > 0:
		yatak_katki = minf(float(c.get("yatak_tavan_bonus", 0.75)), float(bos_yatak) * float(c.get("bos_yatak_basina", 0.15)))
	elif bos_yatak < 0:
		yatak_katki = float(c.get("acikta_cezasi", -0.45))
	return clampf(taban + refah_katki + guv_katki + yatak_katki, float(c.get("alt_sinir", 0.4)), float(c.get("ust_sinir", 3.0)))


static func gunluk_sayi(o: Oturum) -> int:
	if o == null:
		return 0
	if o.perde != 1:
		return maxi(0, o.ayarlar.perde2_gece_basina_gelen)
	if o.ayarlar.gece_basina_gelen > 0:
		return o.ayarlar.gece_basina_gelen
	if bos_gun_mu(o):
		return 0
	var ham := cekicilik_sayisi(o) * mevsim_carpani(o.yonetim) * dunya_olayi_carpani(o)
	return clampi(roundi(ham), maxi(0, int(ayar().get("min_gelen", 0))), tavan())


static func _ortalama_saglik(y: KoyYonetimi) -> int:
	if y == null or y.koylular.is_empty():
		return 100
	var toplam := 0
	var sayi := 0
	for k in y.koylular:
		if k.saglik > 0:
			toplam += k.saglik
			sayi += 1
	return 0 if sayi == 0 else toplam / sayi


static func canli_barlar(o: Oturum) -> Dictionary:
	if o == null or o.yonetim == null:
		return {"Moral": 10.0, "Guvenlik": 10.0, "Refah": 10.0, "Saglik": 10.0, "Erzak": 10.0}
	var y := o.yonetim
	var olcek := maxf(1.0, float(ayar().get("bar_araligi", 10.0)))
	var erzak_tavan := maxf(1.0, float(ayar().get("erzak_tavan_gun", 10.0)))
	return {
		"Moral": float(clampi(y.huzur(), 0, 100)) / olcek,
		"Guvenlik": float(clampi(KervanKorumasi.guvenlik(y), 0, 100)) / olcek,
		"Refah": float(clampi(EkonomikRefah.oku(y), 0, 100)) / olcek,
		"Saglik": float(clampi(_ortalama_saglik(y), 0, 100)) / olcek,
		"Erzak": clampf(y.gida_gunu(), 0.0, erzak_tavan),
	}


static func _bar_anahtari(ad: String) -> String:
	match ad:
		"Güvenlik", "Guvenlik": return "Guvenlik"
		"Sağlık", "Saglik": return "Saglik"
		"Moral": return "Moral"
		"Refah": return "Refah"
		"Erzak": return "Erzak"
	return ""


static func bar_kosulu_uygun(o: Oturum, kosul: String) -> bool:
	var metin := kosul.strip_edges()
	if metin.is_empty():
		return true
	if _bar_rx == null:
		_bar_rx = RegEx.new()
		_bar_rx.compile("^(Refah|Erzak|Güvenlik|Guvenlik|Moral|Sağlık|Saglik)\\s*(<=|>=|==|<|>)\\s*(\\d+)$")
	var barlar := canli_barlar(o)
	for ham_parca in metin.split(" ve ", false):
		var parca := ham_parca.strip_edges()
		if parca.is_empty() or parca.begins_with("Tur"):
			continue
		var m := _bar_rx.search(parca)
		if m == null:
			continue
		var anahtar := _bar_anahtari(m.get_string(1))
		if anahtar.is_empty() or not barlar.has(anahtar):
			continue
		var canli := float(barlar[anahtar])
		var esik := float(m.get_string(3).to_int())
		match m.get_string(2):
			"<":
				if not (canli < esik): return false
			"<=":
				if not (canli <= esik): return false
			">":
				if not (canli > esik): return false
			">=":
				if not (canli >= esik): return false
			"==":
				if not is_equal_approx(canli, esik): return false
	return true


static func kapi_cikisi_kaydet(o: Oturum, g: Gelen) -> void:
	if o == null or g == null or g.id == &"":
		return
	var kayit: Dictionary = o.get_meta(CIKIS_META, {})
	if int(kayit.get("gun", -1)) != o.gun:
		kayit = {"gun": o.gun, "idler": []}
	var idler: Array = kayit.get("idler", [])
	var sid := String(g.id)
	if not (sid in idler):
		idler.append(sid)
	kayit["idler"] = idler
	o.set_meta(CIKIS_META, kayit)


static func kapi_cikisi_yapildi_mi(o: Oturum, id: StringName) -> bool:
	if o == null or id == &"":
		return false
	var kayit: Variant = o.get_meta(CIKIS_META, {})
	if not (kayit is Dictionary) or int((kayit as Dictionary).get("gun", -1)) != o.gun:
		return false
	return String(id) in ((kayit as Dictionary).get("idler", []) as Array)


static func _ayrilmis_veya_olu(o: Oturum, id: StringName) -> bool:
	if o == null or id == &"":
		return false
	if o.kadro != null and o.kadro.durumlar.has(id):
		var d: StringName = o.kadro.durumlar[id].get("durum", &"gelmedi")
		if d == &"kalici_ayrildi" or d == &"koyde":
			return true
	if o.yonetim != null:
		for k in o.yonetim.koylular:
			if k.adli_id == id and k.saglik <= 0:
				return true
	return false


static func _chr_runtime_kosul(o: Oturum, id: StringName) -> String:
	var anahtar := String(id).to_upper()
	if not _chr_onbellek.has(anahtar):
		var yol := "res://data/chr_runtime/%s.tres" % anahtar
		var kosul := ""
		if ResourceLoader.exists(yol):
			var kv := ResourceLoader.load(yol) as KarakterVerisi
			if kv != null:
				kosul = kv.spawn_kosulu
		_chr_onbellek[anahtar] = kosul
	var sonuc := String(_chr_onbellek[anahtar])
	if not sonuc.is_empty():
		return sonuc
	var kat_kv := o.katalog.karakter(id) if o != null and o.katalog != null else null
	return kat_kv.spawn_kosulu if kat_kv != null else ""


static func uygun_adaylar(o: Oturum, gun: int) -> Array[StringName]:
	if o == null or o.kadro == null:
		return []
	var ham := TehditTakvimi.adaylar(gun, o.kadro.uygunlar(gun))
	var sonuc: Array[StringName] = []
	for id in ham:
		if kapi_cikisi_yapildi_mi(o, id) or _ayrilmis_veya_olu(o, id):
			continue
		var kosul := _chr_runtime_kosul(o, id)
		if not bar_kosulu_uygun(o, kosul):
			continue
		sonuc.append(id)
	return sonuc


static func _ozel_ziyaret_mi(g: Gelen) -> bool:
	if g == null:
		return false
	return g.get_meta("har05_goc", false) \
		or TuccarKapiGecisi.ilgilenir(g) \
		or YetimBakimi.ilgilenir(g) \
		or preload("res://src/kapi/aile_kafilesi.gd").ilgilenir(g) \
		or preload("res://src/sistemler/aydogdu_ziyareti.gd").ilgilenir(g) \
		or preload("res://src/sistemler/sancak_ulagi.gd").ilgilenir(g) \
		or preload("res://src/kapi/usta_gelisi.gd").ilgilenir(g)


static func kuyrugu_temizle_ve_sinirla(o: Oturum, sonuc: Array[Gelen]) -> Array[Gelen]:
	var temiz: Array[Gelen] = []
	var gorulen_idler := {}
	for g in sonuc:
		if g == null or HaneEsi.gelen_es_mi(g, o):
			continue
		if g.id != &"":
			if gorulen_idler.has(g.id) or kapi_cikisi_yapildi_mi(o, g.id) or _ayrilmis_veya_olu(o, g.id):
				continue
			gorulen_idler[g.id] = true
		temiz.append(g)
	if not serbest_akis_mi(o):
		return temiz
	var heyetler: Array[Gelen] = []
	var normaller: Array[Gelen] = []
	for g in temiz:
		if DiplomatikHeyet.ilgilenir(g):
			heyetler.append(g)
		else:
			normaller.append(g)
	var sinir := tavan()
	while normaller.size() > sinir:
		var cikar_idx := -1
		for idx in range(normaller.size() - 1, -1, -1):
			if not _ozel_ziyaret_mi(normaller[idx]):
				cikar_idx = idx
				break
		if cikar_idx < 0:
			cikar_idx = normaller.size() - 1
		var dusen: Gelen = normaller.pop_at(cikar_idx)
		if dusen.adli and dusen.id != &"" and o.kadro != null and o.kadro.durumlar.has(dusen.id):
			o.kadro.durumlar[dusen.id]["istendi"] = false
	var birlesik: Array[Gelen] = []
	birlesik.append_array(heyetler)
	birlesik.append_array(normaller)
	return birlesik
