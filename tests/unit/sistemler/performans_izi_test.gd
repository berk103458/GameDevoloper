## Hedef 3: PerformansIzi 10s aralık, sahne yükleme ve oyuncu sürümü sessizlik birim testi.
extends SceneTree

const IZ_YOL := "res://tests/oto/olcum/performans_izi.gd"

var _hata := 0
var _kontrol := 0


func _dene(ok: bool, mesaj: String) -> void:
	_kontrol += 1
	if not ok:
		_hata += 1
		push_error("PERFORMANS IZI TEST HATA: " + mesaj)


func _initialize() -> void:
	call_deferred("_test")


func _test() -> void:
	var IzSinif := load(IZ_YOL) as GDScript
	_dene(IzSinif != null, "performans_izi.gd yuklenebilmeli")
	if IzSinif == null:
		quit(1)
		return

	_dene(not IzSinif.iz_acik(PackedStringArray()), "Bayraksiz oyuncu surumunde iz kapali olmali")
	_dene(IzSinif.iz_acik(PackedStringArray(["--debug-arac"])), "--debug-arac izi acmali")
	_dene(IzSinif.iz_acik(PackedStringArray(["--perf-log"])), "--perf-log izi acmali")

	var yol_sessiz := "user://test_perf_izi_sessiz_%d.jsonl" % OS.get_process_id()
	if FileAccess.file_exists(yol_sessiz):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(yol_sessiz))

	var sessiz: Node = IzSinif.new()
	sessiz.etkin = false
	sessiz.dosya_yolu = yol_sessiz
	root.add_child(sessiz)
	_dene(not sessiz.is_processing(), "Oyuncu surumunde _process kapali olmali")
	sessiz._process(12.0)
	_dene(not sessiz.aralik_yaz({"fps": 60.0, "kare_ms": 16.0}), "Oyuncu surumunde aralik yazilmamali")
	_dene(not sessiz.sahne_degisti("MenuEkrani", 15.0), "Oyuncu surumunde sahne yazilmamali")
	_dene(sessiz.satir_sayisi == 0 and not FileAccess.file_exists(yol_sessiz), "Oyuncu surumunde dosya olusturulmamali")
	sessiz.free()

	var yol_aktif := "user://test_perf_izi_aktif_%d.jsonl" % OS.get_process_id()
	if FileAccess.file_exists(yol_aktif):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(yol_aktif))

	var aktif: Node = IzSinif.new()
	aktif.dosya_yolu = yol_aktif
	aktif.ac(true)
	root.add_child(aktif)
	_dene(aktif.is_processing(), "Etkinlestirilen iz _process calistirmali")
	aktif.olcum_ekle({"fps": 55.0, "kare_ms": 18.2, "ram": 4194304.0})
	aktif.olcum_ekle({"fps": 60.0, "kare_ms": 16.7, "ram": 4194304.0})
	aktif._process(10.0)
	_dene(aktif.satir_sayisi == 1, "10 saniye dolunca ilk aralik satiri yazilmali")
	_dene(aktif.sahne_degisti("KapiEkrani", 42.5), "Sahne degisimi yukleme suresi yazilmali")
	_dene(aktif.satir_sayisi == 2, "Sahne degisimi ikinci JSONL satirini yazmali")

	var satirlar: Array[Dictionary] = []
	var f := FileAccess.open(yol_aktif, FileAccess.READ)
	_dene(f != null, "Aktif iz JSONL dosyasi okunabilmeli")
	if f != null:
		while not f.eof_reached():
			var l := f.get_line()
			if l.is_empty():
				continue
			var parsed: Variant = JSON.parse_string(l)
			_dene(parsed is Dictionary, "Her satir gecerli JSON nesnesi olmali")
			if parsed is Dictionary:
				satirlar.append(parsed)
		f.close()

	_dene(satirlar.size() == 2, "Tam 2 JSONL satiri yazilmis olmali")
	if satirlar.size() >= 2:
		var s0 := satirlar[0]
		_dene(String(s0.get("tur", "")) == "aralik" and int(s0.get("sure_sn", 0)) == 10, "Ilk satir 10 sn aralik kaydi olmali")
		for alan in ["fps_ortanca", "kare_ms_azami", "fps", "kare_ms", "dugum_sayisi"]:
			_dene(s0.has(alan) and (s0[alan] is int or s0[alan] is float), "Aralik satirinda %s sayisal olmali" % alan)
		_dene(s0.has("bellek_mb"), "Aralik satirinda bellek_mb alani olmali")
		_dene(int(s0.get("dugum_sayisi", 0)) > 0, "Dugum sayisi pozitif olmali")

		var s1 := satirlar[1]
		_dene(String(s1.get("tur", "")) == "sahne" and String(s1.get("sahne", "")) == "KapiEkrani", "Ikinci satir sahne adini yazmali")
		_dene(is_equal_approx(float(s1.get("yukleme_ms", -1.0)), 42.5), "Ikinci satir yukleme_ms degerini yazmali")
		for alan in ["fps_ortanca", "kare_ms_azami", "fps", "kare_ms", "dugum_sayisi", "bellek_mb"]:
			_dene(s1.has(alan), "Sahne satirinda ortak alan %s bulunmali" % alan)

	if FileAccess.file_exists(yol_aktif):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(yol_aktif))
	aktif.free()
	print("PERFORMANS İZİ TEST: %s (%d kontrol, %d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _kontrol, _hata])
	quit(0 if _hata == 0 else 1)
