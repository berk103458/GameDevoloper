## ISG-77: gerçek Oyun ayarları mevcut köy işlerini değiştirmez.
extends Node
const F = preload("res://tests/oto/atama_duraklat_kontrol.gd")
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _ready() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := F.TestAna.new()
	add_child(ana)
	ana.ayarlar = Ayarlar.new("user://kalfa_isg77_test.cfg")
	var y := ana.oturum.yonetim
	var b := KoyBinasi.new()
	b.id = 77
	b.tur = "odunluk"
	b.hucre = Vector2i(2, 2)
	y.binalar.append(b)
	var k := y.kabul({"ad": "Geçici işçi"})
	var bekleyen := y.kabul({"ad": "Boşta işçi"})
	dene(GeciciIsler.ata(y, k.id, "dal_toplama"), "Başlangıçta gerçek geçici iş var")
	ana._koye_git()
	await get_tree().process_frame
	var foto := y.kaydet()
	ana._ayarlari_ac(func() -> void: pass, true)
	await get_tree().process_frame
	var ayar := ana._ust as AyarlarEkrani
	dene(ayar != null, "Gerçek ayar ekranı açılır")
	var sekme: AyarSekmeleri
	for n in ayar.get_children():
		if n is AyarSekmeleri: sekme = n
	dene(sekme != null and sekme._icerik.get_meta("sekme") == &"oyun", "Oyun sekmesi açıktır")
	if sekme != null:
		var oyun := sekme._icerik.get_child(0)
		var denenen := 0
		for satir in oyun.get_children():
			if not satir.has_meta("anahtar"): continue
			var anahtar: StringName = satir.get_meta("anahtar")
			var once: Variant = ana.ayarlar.al(anahtar)
			var ileri := satir.get_child(satir.get_child_count() - 1) as Button
			ileri.pressed.emit()
			await get_tree().process_frame
			dene(ana.ayarlar.al(anahtar) != once, "Gerçek ayar düğmesi değer değiştirir: " + String(anahtar))
			dene(y.kaydet() == foto, "Oyun ayarı atama/nüfus/kasa/RNG değiştirmez: " + String(anahtar))
			denenen += 1
		dene(denenen == oyun.ANAHTARLAR.size(), "Oyun sekmesinin bütün ayar satırları sınandı")
	for n in ayar.find_children("*", "Button", true, false):
		dene(not n.has_meta("hedef") and not n.has_meta("gecici_is"), "Ayar ekranı iş atama düğmesi taşımaz")
	ayar._kapat()
	await get_tree().process_frame
	dene(y.kaydet() == foto and bekleyen.is_yeri == KoyYonetimi.BOSTA and GeciciIsler.secili(k) == "dal_toplama", "Kapanışta iş listesi korunur")
	# Yalnız bu testin açıkça adlandırdığı dosya temizlenir.
	if FileAccess.file_exists(ana.ayarlar.yol): DirAccess.remove_absolute(ana.ayarlar.yol)
	ana.queue_free()
	await get_tree().process_frame
	print("AYARLAR İŞ ATAMAZ: GEÇTİ" if hata == 0 else "AYARLAR İŞ ATAMAZ: KALDI")
	await Ses.cik(hata)
