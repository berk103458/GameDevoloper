## Köyde F5 ve ana menüden yükleme ayrı Godot süreçlerinde denenir.
extends Node

class KayitAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		katalog = Katalog.new()
		if katalog.yukle() != Katalog.Durum.HAZIR:
			return
		ayarlar = Ayarlar.new()
		theme = Tema.olustur(ayarlar)
		_eylemleri_kur()
		ana_menu()


var _hata := 0


func _ready() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	var kok := OS.get_environment("KM_HIZLI_KAYIT_TEST_KOK")
	var asama := OS.get_environment("KM_HIZLI_KAYIT_TEST_ASAMA")
	if kok.is_empty() or asama not in ["yaz", "yukle"]:
		push_error("Hızlı kayıt testi için yalıtılmış dizin ve aşama gerekli")
		get_tree().quit(1)
		return
	var ana := KayitAna.new()
	ana.yuvalar = KayitYuvalari.new(kok, false)
	ana.yuva_sec(2)
	add_child(ana)
	if not ana._ekran is MenuEkrani:
		push_error("Test ana menüsü kurulamadı")
		get_tree().quit(1)
		return
	if asama == "yaz":
		_yaz(ana)
	else:
		_yukle(ana)
	ana.queue_free()
	await get_tree().process_frame
	print("HIZLI KAYIT %s: %s" % [asama, "GEÇTİ" if _hata == 0 else "KALDI"])
	get_tree().quit(_hata)


func _yaz(ana: Ana) -> void:
	var birinci := GuvenliKayit.new(ana.yuvalar.yuva_yolu(1))
	_kontrol(birinci.yaz({"surum": Oturum.KAYIT_SURUMU, "isaret": "birinci yuva"}), "1. yuva oluşturuldu")
	var birinci_ozet := FileAccess.get_sha256(birinci.yol)
	ana.oturum = Oturum.new(ana.katalog, 21)
	ana.oturum.yonetim.gun = 4
	ana._koye_git()
	var koy := ana._ekran as KoyEkrani
	var once := ana.kayit.oku()
	if koy == null or once.is_empty():
		_kontrol(false, "Etkin köy yuvası yazıldı")
		return
	var eski_ozet := FileAccess.get_sha256(ana.kayit.yol)
	var kaynaklar := ana.oturum.yonetim.kaynaklar
	var eski_gida := kaynaklar.miktar("gida")
	kaynaklar.ekle("gida", 5)
	var gida := kaynaklar.miktar("gida")
	_kontrol(gida > eski_gida, "Kaydedilecek durum değişti")

	var f5 := InputEventKey.new()
	f5.physical_keycode = KEY_F5
	f5.pressed = true
	koy._kart_ac("Rapor")
	koy._unhandled_input(f5)
	_kontrol(FileAccess.get_sha256(ana.kayit.yol) == eski_ozet, "Rapor açıkken F5 dosyayı değiştirmedi")
	koy._kart_kapat()
	koy._unhandled_input(f5)
	var yeni := ana.kayit.oku()
	_kontrol(yeni.get("yuva") == 2 and yeni.get("faz") == "koy", "F5 etkin yuvaya ve köy fazına yazdı")
	_kontrol(int(yeni.get("koy_yonetimi", {}).get("kaynaklar", {}).get("stok", {}).get("gida", -1)) == gida, "F5 güncel gıdayı yazdı")
	_kontrol(FileAccess.get_sha256(ana.kayit.yol + ".bak") == eski_ozet, "Önceki 2. yuva yedeklendi")
	_kontrol(FileAccess.get_sha256(birinci.yol) == birinci_ozet, "1. yuva aynı kaldı")


func _yukle(ana: Ana) -> void:
	var kayit := ana.kayit.oku()
	var diger := GuvenliKayit.new(ana.yuvalar.yuva_yolu(1)).oku()
	_kontrol(diger.get("isaret") == "birinci yuva", "Yeni süreçte 1. yuva korundu")
	_kontrol(kayit.get("yuva") == 2 and kayit.get("faz") == "koy", "Yeni süreç 2. köy yuvasını okudu")
	ana.devam_et()
	if ana.oturum == null or not ana._ekran is KoyEkrani:
		_kontrol(false, "Devam Et köyü yeniden açtı")
		return
	_kontrol(ana.aktif_yuva == 2 and ana.oturum.gun == 4, "Etkin yuva ve oyun günü döndü")
	kayit.erase("yuva")
	var gercek: Variant = JSON.parse_string(JSON.stringify(ana.oturum.kaydet()))
	_kontrol(gercek == kayit, "Kayıtlı oturum yeni süreçte aynı durumla açıldı")


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		_hata += 1
		push_error(mesaj)
