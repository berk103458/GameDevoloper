## TEZ-01: dört tezgâhın yeri; düğümü olmayan ya da ızgara dışındaki yer iş almaz.
## Yer kaydı düğüm kimliğidir; yeni sahne, yeni meslek ve YAP kademesi açılmaz.
extends SceneTree
var hata := 0
var kontrol := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _y() -> KoyYonetimi:
	return KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 19)

func _bina(y: KoyYonetimi, tur: String, hucre: Vector2i) -> KoyBinasi:
	var b := KoyBinasi.new()
	b.id = y.binalar.size() + 1
	b.tur = tur
	b.hucre = hucre
	b.insa_kalan = 0
	y.binalar.append(b)
	var hs: Array[Vector2i] = [hucre]
	y.izgara.yerlestir(b.id, hs)
	return b

func _calistir() -> void:
	_yerler()
	_dort_yer()
	_izgara_disi()
	_sabitler()
	_yuz()
	_bes_sabah()
	_usta_yok()
	_sayim()
	await process_frame
	print("TEZGAHTA GUN: %s (%d kontrol, %d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", kontrol, hata])
	quit(hata)

func _yerler() -> void:
	var y := _y()
	_kontrol(TezgahtaGun.SIRA.size() == 4, "Dört yer sabit sırada")
	for yer in TezgahtaGun.SIRA:
		_kontrol(TezgahtaGun.yer_mi(yer), "Yer tanımlı: " + yer)
	_kontrol(not TezgahtaGun.yer_mi("bilinmeyen"), "Tanımsız yer yok")
	_kontrol(y.katalog.var_mi("agil") and y.katalog.var_mi("degirmen") and y.katalog.var_mi("demirhane") and y.katalog.var_mi("bez_evi"), "Dört yerin yapı türü katalogda")
	var isler := TezgahtaGun.acik_isler(y)
	for yer in TezgahtaGun.SIRA:
		_kontrol(int(isler[yer]) == 0, "Düğümü olmayan yerde iş 0: " + yer)

func _dort_yer() -> void:
	var y := _y()
	var yerler := {"agil": Vector2i(1, 1), "degirmen": Vector2i(3, 1), "demirhane": Vector2i(5, 1), "bez": Vector2i(7, 1)}
	for yer in yerler:
		_bina(y, TezgahtaGun.YERLER[yer], yerler[yer])
	for yer in TezgahtaGun.SIRA:
		_kontrol(TezgahtaGun.dugum_var_mi(y, yer), "Düğüm oluştu: " + yer)
		_kontrol(TezgahtaGun.acik_is(y, yer) == 1, "Düğümü olan yerde açık iş 1: " + yer)
	_kontrol(TezgahtaGun.dugum(y, "agil") == Vector2i(1, 1), "Yer kaydı hücre (düğüm kimliği)")
	# Kurulmamış binanın düğümü yoktur.
	var hazir_degil := _bina(y, "degirmen", Vector2i(8, 8))
	hazir_degil.insa_kalan = 2
	_kontrol(TezgahtaGun.acik_is(y, "degirmen") == 1, "Hazır düğüm korunur")

func _izgara_disi() -> void:
	var y := _y()
	_bina(y, "agil", Vector2i(999, 999))
	_kontrol(TezgahtaGun.dugum_var_mi(y, "agil"), "Izgara dışı hücrede düğüm var sayılır")
	_kontrol(TezgahtaGun.acik_is(y, "agil") == 0, "Izgara hücresinin dışındaki yer iş almaz")

func _sabitler() -> void:
	var y := _y()
	_kontrol(TezgahtaGun.ani08_hareket("demirhane") == "dov" and TezgahtaGun.ani08_hareket("agil") == "", "ANI-08 düğüm hareketi tek okumadan gelir")
	y.gun = 40
	_kontrol(TezgahtaGun.SIRA.size() == 4, "Kış için beşinci yer açılmaz")
	_kontrol(TezgahtaGun.mevsim(y) >= 0, "Mevsim MEV-01'den okunur")
	_bina(y, "demirhane", Vector2i(2, 2))
	var once := TezgahtaGun.acik_is(y, "demirhane")
	y.gun += 1
	_kontrol(TezgahtaGun.acik_is(y, "demirhane") == once, "Boş gün sabah satırını silmez")
	var kaynak := FileAccess.get_file_as_string("res://src/koy/tezgahta_gun.gd")
	_kontrol(not kaynak.contains("koy_sahnesi"), "tezgahta_gun.gd koy_sahnesi import etmez")
	_kontrol(not kaynak.contains("PackedScene") and not kaynak.contains(".tscn"), "Yeni sahne açılmaz")
	_kontrol(not kaynak.contains("enum "), "Yeni meslek/kademe yazmaz")

func _usta(y: KoyYonetimi) -> Koylu:
	return y.kabul({"ad": "Usta", "sinif": "esnaf", "stat": 4})


func _yuz() -> void:
	var y := _y()
	_bina(y, "bez_evi", Vector2i(2, 2))
	var k := _usta(y)
	_kontrol(TezgahtaGun.yuz_bagla(y, "bez", str(k.id), "usta", true) == 0, "TEZ-02: yüz tezgâha iner")
	_kontrol(TezgahtaGun.yuz_bagla(y, "bez", "", "usta", true) == 1, "TEZ-02: yüzsüz inmez")
	var y2 := _y()
	_bina(y2, "bez_evi", Vector2i(2, 2))
	var a := _usta(y2)
	TezgahtaGun.yuz_bagla(y2, "bez", str(a.id), "usta", true)
	_kontrol(TezgahtaGun.yuz_bagla(y2, "bez", str(a.id), "usta", true) == 1, "TEZ-02: aynı yüzde ikinci sipariş hata")
	var kayit := JSON.stringify(TezgahtaGun.isler(y2))
	_kontrol(not kayit.contains("kalp") and not kayit.contains(".ogg"), "TEZ-02: yüzde ses ve kalp yok")


func _bes_sabah() -> void:
	var y := _y()
	_bina(y, "bez_evi", Vector2i(2, 2))
	var usta := _usta(y)
	TezgahtaGun.yuz_bagla(y, "bez", str(usta.id), "usta", true)
	var s0 := TezgahtaGun.sabah(y, "bez", {"usta": usta.id, "stok": 0, "ucret": 3})
	_kontrol(int(s0.gun) == 0 and int(s0.teslim) == 0, "TEZ-03: stok 0 iken sabah açılmaz")
	y.gun += 1
	var s1 := TezgahtaGun.sabah(y, "bez", {"usta": usta.id, "stok": 2, "ucret": 3})
	_kontrol(int(s1.gun) == 1 and s1.hal == "ham" and int(s1.stok_dusum) == 1, "TEZ-03: ham ve tek stok düşüşü")
	var tekrar := TezgahtaGun.sabah(y, "bez", {"usta": usta.id, "stok": 2, "ucret": 3})
	_kontrol(int(tekrar.stok_dusum) == 1, "TEZ-03: aynı sabah ikinci düşüş yok")
	y.gun += 1
	var s2 := TezgahtaGun.sabah(y, "bez", {"usta": usta.id, "stok": 2, "ucret": 3})
	_kontrol(int(s2.gun) == 2 and s2.hal == "iz", "TEZ-04: iz")
	y.gun += 1
	var s3 := TezgahtaGun.sabah(y, "bez", {"usta": usta.id, "stok": 2, "ucret": 3, "uyar": true, "alet": 1})
	_kontrol(int(s3.gun) == 3 and int(s3.teslim) == 0, "TEZ-05: biçim, teslim düğmesi yok")
	y.gun += 1
	var boyasiz := TezgahtaGun.sabah(y, "bez", {"usta": usta.id, "boya_ister": true, "boya": 0, "ucret": 3})
	_kontrol(int(boyasiz.gun) == 4 and int(boyasiz.boya_dusum) == 0 and bool(boyasiz.boyasiz), "TEZ-06: boyasızda stok deltası 0")
	_kontrol(y.binalar.size() == 1, "TEZ-06: demirhane yerine ocak açılmaz")
	y.gun += 1
	var tam := TezgahtaGun.sabah(y, "bez", {"usta": usta.id, "ucret": 3, "koyde": true})
	_kontrol(int(tam.gun) == 5 and int(tam.teslim) == 1 and not bool(tam.acik) and tam.cumle == "tez.cumle.tam", "TEZ-08: teslim ve tam cümle")
	y.gun += 1
	var ikinci := TezgahtaGun.sabah(y, "bez", {"usta": usta.id, "ucret": 3, "koyde": true})
	_kontrol(int(ikinci.teslim) == 1, "TEZ-08: ikinci kapanış yok")


func _usta_yok() -> void:
	var y := _y()
	_bina(y, "demirhane", Vector2i(1, 1))
	var usta := _usta(y)
	var cirak := y.kabul({"ad": "Cirak", "sinif": "esnaf", "stat": 2})
	TezgahtaGun.yuz_bagla(y, "demirhane", str(usta.id), "usta", true)
	for adim in 4:
		y.gun += 1
		TezgahtaGun.sabah(y, "demirhane", {"usta": usta.id, "stok": 1, "alet": 1, "uyar": true, "ucret": 2})
	var once := int(TezgahtaGun.isler(y)["demirhane"].gun)
	y.gun += 1
	var yok := TezgahtaGun.sabah(y, "demirhane", {"usta": -1, "cirak": cirak.id, "stok": 1, "ucret": 2})
	_kontrol(int(yok.gun) == once and int(yok.titreme) == 1 and int(yok.rutbe_delta) == 0, "TEZ-07: usta yoksa gün durur, titreme 1")
	y.gun += 1
	var ciraksiz := TezgahtaGun.sabah(y, "demirhane", {"usta": -1, "cirak": -1, "stok": 1})
	_kontrol(int(ciraksiz.titreme) == 1, "TEZ-07: çırak yokken titreme artmaz")
	y.set_meta(&"sabah_defteri", {"kapali": 4})
	y.gun += 1
	var kapali := TezgahtaGun.sabah(y, "demirhane", {"usta": -1, "cirak": cirak.id, "bina": 4, "stok": 1})
	_kontrol(int(kapali.titreme) == 1, "TEZ-07: SAB kapalıyken titreme yazılmaz")


func _sayim() -> void:
	var y := _y()
	_bina(y, "agil", Vector2i(1, 1))
	var usta := _usta(y)
	TezgahtaGun.yuz_bagla(y, "agil", str(usta.id), "hane", true)
	for adim in 5:
		y.gun += 1
		TezgahtaGun.sabah(y, "agil", {"usta": usta.id, "stok": 1, "alet": 1, "uyar": true, "ucret": 4, "koyde": true})
	var s := TezgahtaGun.sayim(y, "agil")
	_kontrol(int(s.gun) == 5 and int(s.titreme) == 0 and int(s.teslim) == 1 and s.cumle == "tez.cumle.tam", "TEZ-10: beş sabah tam")
	_kontrol(int(s.rutbe_delta) == 0 and int(s.un_delta) == 0 and int(s.kademe_delta) == 0, "TEZ-10: rütbe, un ve kademe yazılmaz")
	var a := TezgahtaGun.sayim(y, "agil")
	var b := TezgahtaGun.sayim(y, "agil")
	_kontrol(a.gun == b.gun and a.titreme == b.titreme and a.teslim == b.teslim, "TEZ-10: aynı sayım")
	var eski := _y()
	var bos := TezgahtaGun.sayim(eski, "agil")
	_kontrol(int(bos.gun) == 0 and int(bos.teslim) == 0, "TEZ-10: eski kayıtta teslim ve gün 0")
	var yz := _y()
	_bina(yz, "bez_evi", Vector2i(2, 2))
	var u := _usta(yz)
	TezgahtaGun.yuz_bagla(yz, "bez", str(u.id), "usta", true)
	for adim in 4:
		yz.gun += 1
		TezgahtaGun.sabah(yz, "bez", {"usta": u.id, "stok": 1, "alet": 1, "uyar": true, "ucret": 1, "koyde": true})
	yz.gun += 1
	var kaldi := TezgahtaGun.sabah(yz, "bez", {"usta": u.id, "ucret": -1, "koyde": false, "cumle_yok": true})
	_kontrol(bool(kaldi.acik) and int(kaldi.ev_parca) == 0, "TEZ-09: anahtar yoksa parça eve inmez")


func _kontrol(olur: bool, mesaj: String) -> void:
	kontrol += 1
	if not olur:
		hata += 1
		push_error(mesaj)