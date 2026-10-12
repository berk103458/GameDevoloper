## MCL-01: krizsiz gecede konuşmacı yok; krizli gecede köy kaydındaki yaşayan adlar
## en çok üç; ret yemiş/ölü/kapı kuyruğu kimliği satırda durmaz; yeni sahne/ses yok.
extends SceneTree
var hata := 0
var kontrol := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _y() -> KoyYonetimi:
	return KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 11)

func _kisi(y: KoyYonetimi, ad: String) -> Koylu:
	return y.kabul({"ad": ad, "sinif": "ciftci", "stat": 5})

func _calistir() -> void:
	_krizsiz()
	_krizli()
	_adsiz()
	_sahne_yok()
	await process_frame
	print("MECLIS SESI: %s (%d kontrol, %d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", kontrol, hata])
	quit(hata)

func _krizsiz() -> void:
	var y := _y()
	_kisi(y, "Ali")
	_kisi(y, "Bekir")
	_kontrol(not MeclisSesi.kriz_var_mi(y), "Krizsiz gece: kriz kapısı kapalı")
	_kontrol(MeclisSesi.konusanlar(y).is_empty(), "Krizsiz gecede konuşmacı sayısı 0")
	_kontrol(not MeclisSesi.adsiz_mi(y), "Krizsiz gecede adsız satır açılmaz")

func _krizli() -> void:
	var y := _y()
	var adlar := {}
	for i in 5:
		var k := _kisi(y, "Köylü %d" % i)
		adlar[k.ad] = true
	KuyuKirliligi.kirlet(y)
	_kontrol(MeclisSesi.kriz_var_mi(y), "Kirli kuyu kriz kapısını açar")
	var konusan := MeclisSesi.konusanlar(y)
	_kontrol(konusan.size() > 0 and konusan.size() <= 3, "Krizli gecede konuşmacı sayısı 1..3")
	for ad in konusan:
		_kontrol(adlar.has(ad), "Konuşanların hepsi köy kaydında: " + ad)
	_kontrol(konusan == MeclisSesi.konusanlar(y), "Aynı gece liste deterministik (kimlik sırası)")
	var olu := _kisi(y, "Ölü Kimlik")
	olu.saglik = 0
	_kontrol(MeclisSesi.konusanlar(y, [olu.id]).is_empty(), "Ölü kimlik satıra yazılmaz")
	_kontrol(MeclisSesi.konusanlar(y, [9999]).is_empty(), "Ret yemiş/kapı kuyruğu kimliği satırda 0 kez durur")
	var sinirli := MeclisSesi.konusanlar(y, [1, 2, 3, 4, 5, 6, 7])
	_kontrol(sinirli.size() <= 3, "Aday listesi uzun olsa da tavan 3")

func _adsiz() -> void:
	var y := _y()
	KuyuKirliligi.kirlet(y)
	_kontrol(MeclisSesi.kriz_var_mi(y) and MeclisSesi.konusanlar(y).is_empty(), "Adlı kimse yok: konuşmacı yok")
	_kontrol(MeclisSesi.adsiz_mi(y), "Adlı kimse yoksa oylama adsız tek satırla açılır")

func _sahne_yok() -> void:
	var kaynak := FileAccess.get_file_as_string("res://src/koy/meclis_sesi.gd")
	_kontrol(not kaynak.contains(".tscn") and not kaynak.contains(".wav") and not kaynak.contains("PackedScene"), "meclis_sesi.gd sahne ve ses dosyası açmaz")

func _kontrol(olur: bool, mesaj: String) -> void:
	kontrol += 1
	if not olur:
		hata += 1
		push_error(mesaj)