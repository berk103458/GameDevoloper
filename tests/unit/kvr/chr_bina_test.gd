extends SceneTree

var hata := 0

func _initialize() -> void:
	var katalog := BinaKatalogu.new()
	_kontrol(katalog.chr_hedef_turleri("Ağıl ve Ahır") == PackedStringArray(["agil", "ahir"]), "Birleşik hedef iki ayrı türe açılır")
	_kontrol(katalog.chr_hedef_turleri("bilinmeyen").is_empty(), "Bilinmeyen hedef tahmini türe bağlanmaz")
	_kontrol(katalog.chr_hedef_turleri(" Şifahane ") == PackedStringArray(["sifahane"]), "Kaynak adı korunur")
	var eski: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(BinaKatalogu.YOL))
	for tur in eski:
		if not String(tur).begins_with("_"):
			_kontrol(katalog.veri(tur) == eski[tur], "Mevcut katalog verisi korunur: " + tur)
	for n in range(1, 31):
		var chr := load("res://data/chr_runtime/CHR_%03d.tres" % n) as KarakterVerisi
		for olay in chr.gecikmeli_etkiler:
			var turler := katalog.chr_hedef_turleri(olay["hedef_bina"])
			_kontrol(not turler.is_empty(), "CHR hedef adı eşlenir: " + olay["hedef_bina"])
			for tur in turler:
				_kontrol(katalog.var_mi(tur), "CHR hedefi katalogda var: " + tur)
	var yonetim := KoyYonetimi.new(KoyAyarlari.new(), katalog)
	var kaynak_once := yonetim.kaydet()
	_kontrol(not yonetim.bina_kur("sifahane", Vector2i(5, 5))["olur"], "Henüz inşa sistemi olmayan hedef bedelsiz kurulmaz")
	_kontrol(yonetim.kaydet() == kaynak_once, "Reddedilen hedef kurulumu yan etkisiz")
	print("CHR BİNA SÖZLÜĞÜ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
