## DIY-13: Dedikodu yayilimi — haber gecikmeli dolasir birim testi.
## Kabul kriterleri:
## - Taniksiz rusvet 0 satir uretir.
## - Tanikli rusvet uc gece icinde 1 satir olur.
## - Gun sifirda pusula satiri 0'dir.
## - Ayni olay kimligi ikinci kayit acmaz; tanik yayilmadan olurse kayit duser;
##   ucuncu geceden sonra basilmamis satir silinir; kamu vergisi dedikodu degildir.
extends SceneTree

const DedikoduSinifi = preload("res://src/sistemler/dedikodu.gd")

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	_test_taniksiz_ve_tanikli_rusvet()
	_test_gun_sifirda_pusula_sifir()
	_test_ayni_olay_ikinci_kayit_acmaz()
	_test_tanik_olumu_ve_ucuncu_gece_silinme()
	_test_kamu_vergisi_ve_gecersiz_turler()

	await process_frame
	print("DEDIKODU: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _test_taniksiz_ve_tanikli_rusvet() -> void:
	var d := DedikoduSinifi.new()
	# Kabul 1: Taniksiz rusvet 0 satir uretir
	var taniksiz: Dictionary = d.olay_kaydet("rusvet_01", "rusvet", 1, "")
	_kontrol(not bool(taniksiz.get("olur", true)), "Tanıksız rüşvet reddedilmeli")
	_kontrol(d.kayitlar().size() == 0, "Tanıksız rüşvet 0 satır üretmeli")

	# Kabul 2: Tanikli rusvet uc gece icinde 1 satir olur
	var tanikli: Dictionary = d.olay_kaydet("rusvet_02", "rüşvet", 1, "koylu_hasan", 2)
	_kontrol(bool(tanikli.get("olur", false)), "Tanıklı şahsi rüşvet kaydedilmeli")
	var kayit: Dictionary = tanikli.get("kayit", {})
	var aralik: Array = kayit.get("gun_araligi", [])
	_kontrol(aralik == [2, 4], "Gün aralığı [gece+1, gece+3] olarak kayıtta yazmalı (alınan=%s)" % str(aralik))

	# Gece 1 (olay gecesi) henuz yayilmamis olmali
	_kontrol(d.pusula_satirlari(1).size() == 0, "Olay gecesinde henüz pusula satırı çıkmamalı")
	# 3 gece icinde (gece 3) tam 1 satir olmali
	var satirlar: Array[Dictionary] = d.pusula_satirlari(3, true)
	_kontrol(satirlar.size() == 1, "Tanıklı rüşvet üç gece içinde tam 1 satır olmalı (alınan=%d)" % satirlar.size())


func _test_gun_sifirda_pusula_sifir() -> void:
	var d := DedikoduSinifi.new()
	d.olay_kaydet("siddet_01", "şiddet", 0, "koylu_ali", 1)
	_kontrol(d.pusula_satirlari(0).size() == 0, "Gün sıfırda pusula satırı 0 olmalı")
	_kontrol(d.pusula_satirlari(1).size() == 1, "Gün 1'de pusula satırı 1 olmalı")


func _test_ayni_olay_ikinci_kayit_acmaz() -> void:
	var d := DedikoduSinifi.new()
	var ilk: Dictionary = d.olay_kaydet("aile_01", "aileyi bölme", 2, "tanik_1", 1)
	var ikinci: Dictionary = d.olay_kaydet("aile_01", "aileyi bölme", 3, "tanik_2", 1)
	_kontrol(bool(ilk.get("olur", false)) and not bool(ikinci.get("olur", true)), "Aynı olay kimliği ikinci kayıt açmamalı")
	_kontrol(d.kayitlar().size() == 1, "Kayıt sayısı 1 kalmalı")


func _test_tanik_olumu_ve_ucuncu_gece_silinme() -> void:
	var d := DedikoduSinifi.new()
	d.olay_kaydet("haksiz_01", "haksız ret", 2, "tanik_veli", 2)
	# Tanik ertesi gece (gece 3, yayilim_gecesi=4'ten once) olurse yayilmamis kayit duser
	var dusen := d.tanik_oldu("tanik_veli", 3)
	_kontrol(dusen == 1 and d.kayitlar().size() == 0, "Tanık ertesi gece ölürse yayılmamış kayıt düşmeli")

	# Ucuncu geceden sonra basilmamis satir silinir, birikmez
	d.olay_kaydet("siddet_02", "siddet", 2, "tanik_canli", 1)
	# gun_araligi = [3, 5]. Gece 6'da hala basilmamissa silinmeli:
	var gec_satirlar: Array[Dictionary] = d.pusula_satirlari(6)
	_kontrol(gec_satirlar.size() == 0 and d.kayitlar().size() == 0, "Üçüncü geceden sonra basılmamış satır silinmeli, birikmemeli")


func _test_kamu_vergisi_ve_gecersiz_turler() -> void:
	var d := DedikoduSinifi.new()
	var vergi_1: Dictionary = d.olay_kaydet("vergi_01", "kamu_vergisi", 1, "tanik_1")
	var vergi_2: Dictionary = d.olay_kaydet("vergi_02", "rusvet", 1, "tanik_1", 1, {"kamu_vergisi": true})
	var listede_yok: Dictionary = d.olay_kaydet("normal_kabul_01", "normal_kabul", 1, "tanik_1")
	_kontrol(not bool(vergi_1.get("olur", true)) and not bool(vergi_2.get("olur", true)), "Kamu vergisi dedikodu üretmemeli")
	_kontrol(not bool(listede_yok.get("olur", true)), "Listede olmayan olay dedikodu üretmemeli")
	_kontrol(d.kayitlar().size() == 0, "Geçersiz olaylardan sonra kayıt sayısı 0 olmalı")


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
