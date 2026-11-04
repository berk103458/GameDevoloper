extends SceneTree
## TEK-03, TEK-05, TEK-09, TEK-11, TEK-29, TEK-31, TEK-34.

const DUMAN = preload("res://tests/oto/duman_cekirdek.gd")

var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	_tek01()
	_yetim_import()
	_uc_gece()
	_yukleme_paneli()
	_hiz()
	_kopru()
	_usta_bayragi()
	_esik_dosyasi()
	_surum()
	_bellek()
	print("TEKNİK BORÇ: %s" % ("GEÇTİ" if hata == 0 else "KALDI"))
	quit(hata)

func _tek01() -> void:
	var nufus := KoyNufusu.new()
	dene(nufus.sayi(&"olmayan_sinif") == 0, "TEK-34 TST-0001 dönüş 0")

func _yetim_import() -> void:
	var yetim := 0
	var kok := "res://assets/model/karakter"
	var dizin := DirAccess.open(kok)
	if dizin != null:
		dizin.list_dir_begin()
		var ad := dizin.get_next()
		while ad != "":
			if ad.ends_with("_yuru_Image_0.jpg.import") and not FileAccess.file_exists(kok + "/" + ad.trim_suffix(".import")):
				yetim += 1
			ad = dizin.get_next()
	dene(yetim == 0, "TEK-34 yetim import 0")

func _uc_gece() -> void:
	var gunluk := PerformansGunlugu.new()
	gunluk.etkin = true
	gunluk.dosya_yolu = "user://tek34_%d.jsonl" % OS.get_process_id()
	for gece in 3:
		gunluk.gece_yaz(gece + 1)
	dene(gunluk.satir_sayisi == 3, "TEK-34 üç gece satırı")
	var kapali := PerformansGunlugu.new()
	kapali.etkin = false
	kapali.dosya_yolu = "user://tek11_%d.jsonl" % OS.get_process_id()
	kapali.gece_yaz(1)
	dene(kapali.satir_sayisi == 0 and not FileAccess.file_exists(kapali.dosya_yolu), "TEK-11 bayraksız günlük yok")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(gunluk.dosya_yolu))
	gunluk.free()
	kapali.free()

func _yukleme_paneli() -> void:
	var kok := Node.new()
	get_root().add_child(kok)
	var katman := VarlikYuklemePaneli.new()
	kok.add_child(katman)
	var kaynak := VarlikOnbellek.new()
	kaynak.katman = weakref(katman)
	await VarlikYuklemePaneli.bitir(kok, kaynak)
	await process_frame
	dene(kok.get_child_count() == 0 or katman.is_queued_for_deletion(), "TEK-34 yükleme paneli kalkar")
	if is_instance_valid(katman) and not katman.is_queued_for_deletion():
		katman.queue_free()
	kok.queue_free()

func _hiz() -> void:
	Engine.time_scale = 3.0
	paused = true
	preload("res://src/arayuz/koy_hiz_kapisi.gd").sifirla(self, Engine.max_physics_steps_per_frame)
	dene(is_equal_approx(Engine.time_scale, 1.0) and not paused, "TEK-34 menüde hız 1")

func _kopru() -> void:
	dene(preload("res://src/debug/kopru_portu.gd").oku(PackedStringArray(), "") == 0, "TEK-34 portsuz köprü 0")

func _usta_bayragi() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var oturum := Oturum.new(kat, 4105)
	var dudu := oturum.yonetim.kabul({"ad": "Dudu", "sinif": "esnaf"})
	dudu.adli_id = &"chr_008"
	dudu.bayraklar = PackedStringArray(["usta_demirci"])
	var esnaf := oturum.yonetim.kabul({"ad": "Usta", "sinif": "esnaf"})
	esnaf.bayraklar = PackedStringArray(["usta_demirci"])
	var veri: Dictionary = JSON.parse_string(JSON.stringify(oturum.kaydet()))
	var geri := Oturum.kayittan(kat, veri)
	var chr := geri.yonetim.koylu(dudu.id)
	var adsiz := geri.yonetim.koylu(esnaf.id)
	dene(chr != null and not chr.bayrak_var("usta_demirci") and chr.bayrak_var("usta_cerrah"), "TEK-05 CHR bayrağı cerraha döner")
	dene(adsiz != null and adsiz.bayrak_var("usta_demirci"), "TEK-05 adsız esnaf usta_demirci kalır")

func _esik_dosyasi() -> void:
	dene(FileAccess.file_exists("res://data/atil_bayraklar.json"), "TEK-09 eşik kaynağı DEN dosyasında")
	dene(not FileAccess.file_exists("res://data/adv07_esikler.json"), "TEK-09 ikinci eşik tablosu yok")

func _surum() -> void:
	dene(Oturum.KAYIT_SURUMU == 3, "TEK-31 kayıt sürümü artmaz")

func _bellek() -> void:
	var alt := DUMAN.bellek_raporu(100, 150)
	var ust := DUMAN.bellek_raporu(100, 250)
	dene(not alt.sicrama and ust.sicrama, "TEK-29 eşik altı geçer, üstü bir satır")
	var kat := Katalog.new()
	kat.yukle()
	var rapor: Dictionary = DUMAN.model_dongusu(DUMAN.gocmus_oturum(kat), kat, 20)
	dene(rapor.olur and int(rapor.gece) == 20 and not rapor.sicrama, "TEK-29 yirmi gece bellek sıçraması yok")
