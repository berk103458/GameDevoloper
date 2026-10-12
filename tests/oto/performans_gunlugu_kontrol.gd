extends Node

class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_perf.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		# Üç gece akışını rasgele kart/mini oyun süresinden bağımsız doğrula.
		katalog._olaylar.clear()
		oturum = Oturum.new(katalog, 103)
		kayit = GuvenliKayit.new("user://test_perf_flow.json")
		theme = Tema.olustur(ayarlar)

var hata := 0
var kontrol_sayisi := 0

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	ana.oturum.yonetim.kabul({"ad": "Ölçümcü", "sinif": "ciftci"})
	ana._koye_git()
	await get_tree().process_frame
	var gunluk := ana.get_node("PerformansGunlugu") as PerformansGunlugu
	var yol := gunluk.dosya_yolu
	# Ayar dosyası üzerinden kasıtlı yüksek eşik; headless FPS'e kabul bağlama.
	var ayar_yolu := "user://teknik_perf_test.json"
	var dosya := FileAccess.open(ayar_yolu, FileAccess.WRITE)
	dosya.store_string('{"performans_gunlugu":{"fps_ortanca_en_az":1000000000000,"kare_ms_azami":1000000000000}}')
	dosya.close()
	gunluk.esikler = PerformansGunlugu.esikleri_oku(ayar_yolu)
	var profil: Variant = ana.ayarlar.al(&"grafik_profili")
	for gece in range(1, 4):
		var ekran := ana._ekran as KoyEkrani
		_kontrol(ekran != null, "Gerçek köy ekranı gece %d" % gece)
		await get_tree().process_frame
		_kontrol(gunluk.olcum_sayisi > 0, "Gerçek karelerden PerformansSeridi ölçümü alınır")
		var ram_once: Variant = PerformansSeridi.oku().ram
		# Düşük profile geçmeden; önbelleğin henüz bırakılmadığını kanıtlayan işaret.
		Pbr._onbellek["perf_test"] = StandardMaterial3D.new()
		ekran._gece_dugmesi.pressed.emit()
		_kontrol(ana.oturum.yonetim.gun == gece, "Gerçek gece düğmesi Oturum.gece_sonu akışını ilerletir")
		ekran._geceye_gec()  # Çift tıklama kilidi ikinci satır üretmez.
		var satirlar := _satirlar(yol)
		_kontrol(satirlar.size() == gece, "Gece başına bir JSONL satırı")
		if satirlar.size() == gece:
			var satir: Dictionary = satirlar[-1]
			_kontrol(satir.keys().size() == 4 and satir.gece == gece, "Makine okunur gece/fps_ortanca/kare_ms_azami/bellek_mb")
			for alan in ["fps_ortanca", "kare_ms_azami"]:
				_kontrol(PerformansGunlugu._sayi(satir.get(alan)), "Headless %s sonlu ve sayısal" % alan)
			_kontrol(satir.bellek_mb == null if ram_once == null else PerformansGunlugu._sayi(satir.bellek_mb) and satir.bellek_mb > 0, "RAM ölçülmediyse null, ölçüldüyse pozitif MiB")
		_kontrol(gunluk.uyari_sayisi == 1, "Yüksek eşik üç gecede tek uyarı verir")
		_kontrol(ana.ayarlar.al(&"grafik_profili") == profil and Pbr._onbellek.has("perf_test"), "Profil değişmez; günlük memory_free çağırmaz")
		Pbr._onbellek.erase("perf_test")
		await get_tree().process_frame
		_kontrol(gunluk.olcum_sayisi == 0, "Bitmiş gece raporu sonraki geceye örnek eklemez")
		if gece < 3:
			var sabah := _dugme(ekran._ust_kart, tr("koy.rapor.sabah"))
			_kontrol(sabah != null, "Gerçek raporda sabah düğmesi var")
			if sabah != null: sabah.pressed.emit()
			var baslangic := Time.get_ticks_msec()
			while (not ana._ekran is KapiEkrani or ana._kapi_yukleniyor) and Time.get_ticks_msec() - baslangic < 10000:
				await get_tree().process_frame
			_kontrol(ana._ekran is KapiEkrani and not ana._kapi_yukleniyor, "Raporun devam sinyali gerçek kapı ekranını açar")
			if ana._ekran is KapiEkrani:
				# Nöbet kuyruğunu boşalt; gerçek gece_bitti sinyali köye döndürür.
				ana._kapi._kuyruk.clear()
				ana._kapi._gelen = null
				ana._kapi._siradaki()
				await get_tree().process_frame
			_kontrol(ana.get_node("PerformansGunlugu") == gunluk, "Ekran geçişi günlük sayacını sıfırlamaz")
	_kontrol(not gunluk.is_processing() and gunluk.satir_sayisi == 3, "Üç gece sonunda örnekleme durur, satır 3")
	gunluk.gece_yaz(4)
	_kontrol(_satirlar(yol).size() == 3, "Dördüncü gece ek satır yazmaz")
	# Kanıt JSONL dosyası user:// altında kalır; test ayarı/kayıt temizlenir.
	print("PERF_JSONL: ", ProjectSettings.globalize_path(yol))
	DirAccess.remove_absolute(ayar_yolu)
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("PERFORMANS GÜNLÜĞÜ AKIŞ: %d kontrol / %s" % [kontrol_sayisi, "GEÇTİ" if hata == 0 else "KALDI"])
	await Ses.cik(hata)

func _satirlar(yol: String) -> Array:
	var sonuc: Array = []
	var dosya := FileAccess.open(yol, FileAccess.READ)
	if dosya == null: return sonuc
	while not dosya.eof_reached():
		var metin := dosya.get_line()
		if metin.is_empty(): continue
		var satir: Variant = JSON.parse_string(metin)
		_kontrol(satir is Dictionary, "Her satır geçerli JSON nesnesidir")
		if satir is Dictionary: sonuc.append(satir)
	return sonuc

func _dugme(n: Node, metin: String) -> Button:
	if n is Button and n.text == metin: return n
	for c in n.get_children():
		var b := _dugme(c, metin)
		if b != null: return b
	return null

func _kontrol(olur: bool, metin: String) -> void:
	kontrol_sayisi += 1
	if not olur:
		hata += 1
		push_error(metin)
