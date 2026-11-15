extends Node

class SessizAna extends Ana:
	func _ready() -> void:
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 4314)
		ayarlar = Ayarlar.new("user://grv14_kullanilmaz.cfg")
		theme = Tema.olustur(ayarlar)

	func _kayit_yaz() -> void:
		pass

var _hata := 0

func _ready() -> void:
	get_tree().create_timer(60).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := SessizAna.new()
	add_child(ana)
	ana.size = Vector2(1920, 1080)
	ana._koye_git()
	await get_tree().process_frame
	var ekran := ana._ekran as KoyEkrani
	var y := ekran.oturum.yonetim
	y.agalik = true
	var kisi := y.kabul({"ad": "Nöbetçi", "sinif": "asker", "stat": 6})
	for boy in [Vector2(1920, 1080), Vector2(1280, 720)]:
		ekran.size = boy
		KoyluKarti.ac(ekran, kisi.id)
		await get_tree().process_frame
		await get_tree().process_frame
		var satir := ekran._ust_kart.find_child("guvenlik_satiri", true, false) as Label
		_kontrol(satir != null, "güvenlik satırı mevcut")
		if satir != null:
			_kontrol(satir.is_visible_in_tree(), "satır tema sonrası görünür")
			_kontrol(satir.text == SavunmaGuvenligi.metin(y), "güvenlik gerçek modelden okunur")
			_kontrol(satir.get_theme_font("font") == ana.theme.default_font, "satır tema yazı tipini miras alır")
			for kaydir in ekran._ust_kart.find_children("*", "ScrollContainer", true, false):
				_kontrol(not kaydir.is_ancestor_of(satir), "güvenlik kaydırma dışında üstte kalır")
		ekran._kart_kapat()
		await get_tree().process_frame
	print("GRV-14 %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	get_tree().quit(0 if _hata == 0 else 1)

func _kontrol(durum: bool, mesaj: String) -> void:
	if not durum:
		_hata += 1
		push_error(mesaj)
