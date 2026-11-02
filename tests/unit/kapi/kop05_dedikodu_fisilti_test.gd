extends SceneTree

const DedikoduSinifi = preload("res://src/sistemler/dedikodu.gd")
const FisiltiGazetesiSinifi = preload("res://src/kapi/fisilti_gazetesi.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("KOP05 DEDIKODU FISILTI TEST HATASI: " + mesaj)


func _initialize() -> void:
	# 1. Taniksiz rusvet pusulada 0 satir uretir
	var dedikodu := DedikoduSinifi.new()
	FisiltiGazetesiSinifi.sayaclari_sifirla()
	var taniksiz := dedikodu.olay_kaydet("olay_taniksiz_rusvet", "rusvet", 1, null, 1)
	_kontrol(not bool(taniksiz.get("olur", true)), "Taniksiz rusvet kayit acmamali")
	var satirlar_taniksiz := FisiltiGazetesiSinifi.dedikodu_pusulasi_oku(dedikodu, 2)
	_kontrol(satirlar_taniksiz.size() == 0, "Taniksiz rusvet pusulada 0 satir uretmeli")

	# 2. Tanikli rusvet 1-3 gece icinde pusulada tam 1 satir; gazete yazma cagrisi 0, okuma cagrisi 1
	dedikodu.sifirla()
	FisiltiGazetesiSinifi.sayaclari_sifirla()
	var tanikli := dedikodu.olay_kaydet("olay_tanikli_rusvet", "rusvet", 1, "chr_004", 2, {
		"satir": "Kapıda el altından akçe alındığı fısıldanıyor."
	})
	_kontrol(bool(tanikli.get("olur", false)), "Tanikli rusvet kaydi acilmali")
	dedikodu.sayaclari_sifirla()
	FisiltiGazetesiSinifi.sayaclari_sifirla()
	var satirlar_gece3 := FisiltiGazetesiSinifi.dedikodu_pusulasi_oku(dedikodu, 3)
	_kontrol(satirlar_gece3.size() == 1, "Tanikli rusvet 1-3 gece icinde pusulada tam 1 satir olmali")
	_kontrol(satirlar_gece3[0] == "Kapıda el altından akçe alındığı fısıldanıyor.", "Gazete yalniz dedikodu kaydindaki satiri basmali")
	_kontrol(FisiltiGazetesiSinifi.gazete_yazma_sayisi == 0 and dedikodu.yazma_sayisi() == 0, "Gazete yazma cagrisi 0 olmali")
	_kontrol(FisiltiGazetesiSinifi.gazete_okuma_sayisi == 1 and dedikodu.okuma_sayisi() == 1, "Gazete okuma cagrisi 1 olmali")

	# 3. Ayni olay kimligi iki gece ust uste ikinci satir uretmez
	var satirlar_gece4 := FisiltiGazetesiSinifi.dedikodu_pusulasi_oku(dedikodu, 4)
	_kontrol(satirlar_gece4.size() == 0, "Ayni olay kimligi ertesi gece ikinci satir uretmemeli")

	# 4. Tanik gece olur veya koyu terk ederse henuz basilmamis kayit duser
	dedikodu.sifirla()
	dedikodu.olay_kaydet("olay_tanik_ayrildi", "siddet", 2, "chr_008", 2)
	var dusen := dedikodu.tanik_ayrildi("chr_008", 3)
	_kontrol(dusen == 1, "Koyu terk eden tanigin basilmamis kaydi dusmeli")
	_kontrol(FisiltiGazetesiSinifi.dedikodu_pusulasi_oku(dedikodu, 4).size() == 0, "Dusen kayit pusulada gorunmemeli")

	# 5. Kisisel kasadaki rusvet: tanik varsa 1 satir, tanik yoksa 0 satir
	dedikodu.sifirla()
	var kisisel_taniksiz := dedikodu.kisisel_rusvet_kaydet("kisisel_1", 1, "")
	_kontrol(not bool(kisisel_taniksiz.get("olur", true)), "Taniksiz kisisel kasa rusveti pusulaya yazilmamali")
	var kisisel_tanikli := dedikodu.kisisel_rusvet_kaydet("kisisel_2", 1, "chr_010", 1)
	_kontrol(bool(kisisel_tanikli.get("olur", false)), "Tanikli kisisel kasa rusveti kayda alinmali")
	_kontrol(FisiltiGazetesiSinifi.dedikodu_pusulasi_oku(dedikodu, 2).size() == 1, "Tanikli kisisel kasa rusveti pusulada 1 satir olmali")

	# 6. KRI-08 / SYS-18 ayni kaydi okur
	dedikodu.sifirla()
	dedikodu.olay_kaydet("olay_haksiz_ret", "haksiz_ret", 1, "chr_012", 1)
	var ortak_kayitlar := FisiltiGazetesiSinifi.dedikodu_kayitlari_oku(dedikodu, 2, false)
	_kontrol(ortak_kayitlar.size() == 1 and String(ortak_kayitlar[0].get("bayrak", "")) == "dedikodu_haksiz_ret", "Ortak kayit SYS-18 / KRI-08 tarafindan okunabilmeli")

	if _hata == 0:
		print("KOP05 DEDIKODU FISILTI: GEÇTİ (0 hata)")
	else:
		print("KOP05 DEDIKODU FISILTI: KALDI (%d hata)" % _hata)
	quit(_hata)
