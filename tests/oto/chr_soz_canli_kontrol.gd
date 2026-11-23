## Gerçek kapıdan köye uçtan uca kabul. Bu sabit kuyruk yalnız bu sahnede var.
extends Node

const ZIYARETCILER: Array[StringName] = [&"chr_002", &"chr_003"]


class TestOturum extends Oturum:
	func _init(kat: Katalog) -> void:
		super(kat, 76)
		gun = 3

	func gece_kuyrugu() -> Array[Gelen]:
		return [_adli_gelen(&"chr_002"), _adli_gelen(&"chr_003")]


class TestAna extends Ana:
	func _ready() -> void:
		GuvenliMetin.kur()
		TranslationServer.set_locale("tr")
		ayarlar = Ayarlar.new()
		katalog = Katalog.new()
		katalog.yukle()
		oturum = TestOturum.new(katalog)
		theme = Tema.olustur(ayarlar)
		kayit = GuvenliKayit.new("user://chr_soz_canli_test.json")


var _ana: TestAna
var _kopru: OyunKoprusu
var _hatalar: Array[String] = []
var _yer_tutucular: Array[String] = []


func _ready() -> void:
	get_tree().create_timer(100.0).timeout.connect(func() -> void:
		push_error("CHR Söz canlı denetimi zaman aşımına uğradı.")
		get_tree().quit(1)
	)
	_ana = TestAna.new()
	add_child(_ana)
	_kopru = OyunKoprusu.new()
	_kopru.ana = _ana
	_ana.add_child(_kopru)
	await _ana._kapiya_git()
	for i in ZIYARETCILER.size():
		if not await _ziyaret(ZIYARETCILER[i], "kabul" if i == 0 else "ret"):
			break
	var koy_acildi := await _bekle(func() -> bool: return _ana._ekran is KoyEkrani, 20.0)
	_dene(koy_acildi, "Kapı nöbeti bitince gerçek köy ekranı açıldı.")
	_dene(_ana.oturum.kapi_soz_izleri.size() == 2, "Söz motoruna tam iki ziyaret yazıldı.")
	_dene(_yer_tutucular.is_empty(), "Görünür repliklerde ve düğmelerde eksik anahtar ya da yer tutucu yok.")
	_dene(GuvenliMetin.eksikler.is_empty(), "Metin çözümleyicisi eksik anahtar bildirmedi.")
	var ozet := {"ziyaretler": _ana.oturum.kapi_soz_izleri.size(), "hatalar": _hatalar,
		"yer_tutucu_metinler": _yer_tutucular, "koy_acildi": koy_acildi}
	print("CHR_SOZ_OZET ", JSON.stringify(ozet))
	get_tree().quit(0 if _hatalar.is_empty() else 1)


func _ziyaret(id: StringName, karar: String) -> bool:
	var hazir := await _bekle(func() -> bool:
		var e := _ana._ekran as KapiEkrani
		return e != null and e._gelen != null and e._gelen.id == id and e.evre == &"sohbet"
	)
	if not _dene(hazir, "%s gerçek kapı sohbetine ulaştı." % id):
		return false
	var e := _ana._ekran as KapiEkrani
	var g := e._gelen
	var s := g.chr_sorgusu() as ChrSorgusu
	if not _dene(s != null, "%s CHR kaynağı yüklendi." % id):
		return false
	var ilk_dugum := s.dugum_id
	if not await _bas("soru_sor", "Secenek0", true):
		return false
	var takip_dugumu := s.dugum_id
	if not await _bas("soru_sor", "Secenek0", true):
		return false
	var takip_sonucu := s.dugum_id
	if not _dene(ilk_dugum == &"00" and takip_dugumu == &"1.1" and takip_sonucu == &"1.2", "%s başlangıç ve takip düğümleri yürüdü." % id):
		return false
	if not await _bas("soru_sor", "Secenek0", true):
		return false
	if not await _bas("devam", "Nişan ve yükü incele", false, "eylem"):
		return false
	if not await _bas("devam", "Nişanı / mührü incele"):
		return false
	if not await _bas("devam", "İncelemeye dön"):
		return false
	if not await _bas("devam", "Sorguya dön"):
		return false
	if not await _bas("soru_sor", "Secenek2", true):
		return false
	if not await _bas("soru_sor", "Secenek0", true):
		return false
	if not await _bas("soru_sor", "Secenek0", true):
		return false
	if not await _bas("devam", tr("arayuz.sohbet.karar_ver")):
		return false
	var karar_hazir := await _bekle(func() -> bool:
		var d: Dictionary = _kopru.get_state()
		return karar in d.get("kisi", {}).get("kararlar", [])
	)
	if not _dene(karar_hazir, "%s için %s kararı görünür ve etkin." % [id, karar]):
		return false

	var once := _koy_durumu()
	var cevap := await _kopru.run_command("kapi_karar", {"karar": karar})
	var sonra := _koy_durumu()
	var iz := g.kapi_sozu().kapi_izi
	var sonuc: Dictionary = iz.sonuc
	var koylu := _ana.oturum.yonetim.koylu(int(sonuc.get("koylu_id", -1)))
	var is_gucu := koylu != null and koylu.adli_id == id and koylu in _ana.oturum.yonetim.bostakiler()
	var ekriz := {
		"chr": String(id), "karar": karar, "takip_dugumleri": [ilk_dugum, takip_dugumu, takip_sonucu],
		"motor": iz, "koy_once": once, "koy_sonra": sonra, "is_gucune_katildi": is_gucu,
	}
	print("CHR_SOZ_ZIYARET ", JSON.stringify(ekriz))
	_dene(bool(cevap.get("ok", false)) and iz.kaynak == "chr" and iz.karar == karar, "%s kararı Söz motorunda sonuçlandı." % id)
	var prefix := String(id).to_upper()
	_dene(prefix + "_DUGUM_00_REPLIK" in iz.satirlar and prefix + "_DUGUM_1_2_REPLIK" in iz.satirlar,
		"%s ilk replik ve takip repliği motor izinde." % id)
	_dene(iz.secimler.any(func(x: Dictionary) -> bool: return x.tur == "chr_soru" and x.id == prefix + "_DUGUM_1_1_SEC_1_METIN"),
		"%s takip sorusu motor izinde." % id)
	if karar == "kabul":
		return _dene(is_gucu and sonra.nufus == once.nufus + 1 and sonra.gida == once.gida + 2,
			"%s köyün iş gücüne katıldı ve gıda stoğuna iki birim eklendi." % id)
	return _dene(koylu == null and sonra.nufus == once.nufus and sonra.ret_sayisi == once.ret_sayisi + 1,
		"%s köye alınmadı ve ret sayacı arttı." % id)


func _bas(komut: String, hedef: String, dugme_adi: bool = false, alan: String = "secenek") -> bool:
	_metinleri_denetle()
	var e := _ana._ekran as KapiEkrani
	var kok: Node = e._eylemler if alan == "eylem" else _kopru._secim_koku()
	var dugmeler := OyunKoprusu.dugmeler(kok)
	for i in dugmeler.size():
		var b := dugmeler[i]
		if (String(b.name) if dugme_adi else OyunKoprusu._dugme_metni(b)) == hedef:
			var sonuc := await _kopru.run_command(komut, {"indeks": i, "alan": alan})
			_metinleri_denetle()
			return _dene(bool(sonuc.get("ok", false)), "Düğme çalıştı: %s" % hedef)
	return _dene(false, "Görünür ve etkin düğme bulunamadı: %s" % hedef)


func _metinleri_denetle() -> void:
	var d := _kopru.get_state()
	var metinler := PackedStringArray(d.get("panel_metni", []))
	metinler.append(String(d.get("kisi", {}).get("konusma", "")))
	for alan in ["secenekler", "eylemler"]:
		for b in d.get(alan, []):
			metinler.append(String(b.metin))
	for metin in metinler:
		var kucuk := metin.to_lower()
		if "[key_not_found]" in kucuk or "yer tutucu" in kucuk or "placeholder" in kucuk:
			if metin not in _yer_tutucular:
				_yer_tutucular.append(metin)


func _koy_durumu() -> Dictionary:
	var y := _ana.oturum.yonetim
	return {"nufus": y.nufus(), "gida": y.kaynaklar.miktar("gida"), "ret_sayisi": y.ret_sayisi,
		"asayis_riski": y.asayis_riski}


func _bekle(hazir: Callable, sure: float = 25.0) -> bool:
	var bitis := Time.get_ticks_msec() + int(sure * 1000.0)
	while Time.get_ticks_msec() < bitis:
		if hazir.call():
			return true
		await get_tree().process_frame
	return false


func _dene(kosul: bool, aciklama: String) -> bool:
	if not kosul:
		_hatalar.append(aciklama)
		push_error(aciklama)
	return kosul
