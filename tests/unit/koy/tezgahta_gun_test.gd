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

func _kontrol(olur: bool, mesaj: String) -> void:
	kontrol += 1
	if not olur:
		hata += 1
		push_error(mesaj)