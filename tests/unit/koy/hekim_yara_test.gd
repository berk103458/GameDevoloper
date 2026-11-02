## CAT-03: Yaralinin tedavisi — hekim varsa iyilestirir birim testi.
## Kabul kriterleri:
## - Hekim ve sifahane varken saglik deltasi pozitiftir; hekim yokken (veya hekim yaraliyken) kayip surer.
## - Itibar artisi yalniz "tedavi edip gonder"de 1'dir (ve yabanci koylu olmaz).
## - Ek sart: ayni yara ikinci gece saglik deltasi 0'dir.
## - Sifahane false iken tedavi secenegi gorunmez; olu hekime gitmez; iki yaralidan ikincisi bekler.
extends SceneTree

const GrupItibariSinifi = preload("res://src/sistemler/grup_itibari.gd")

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	_test_hekim_ve_sifahane_saglik_deltasi()
	_test_yabanci_tedavi_edip_gonder_itibar_ve_koylu_olmama()
	_test_ayni_yara_ikinci_gece_sifir()
	_test_sifahane_false_olu_ve_iki_yarali_kuyrugu()

	await process_frame
	print("HEKIM YARA: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _test_hekim_ve_sifahane_saglik_deltasi() -> void:
	var iyilesenler := {}
	# 1) Hekim ve sifahane varken saglik deltasi pozitif
	var iyi: Dictionary = HekimIlac.yara_tedavi_uygula(
		{"yara_id": "yara_01", "saglik": 50, "yabanci": false},
		{"bina": {"sifahane": true}, "hekim_var": true, "ilac_var": true},
		iyilesenler
	)
	_kontrol(int(iyi.get("saglik_deltasi", 0)) > 0, "Hekim ve şifahane varken sağlık deltası pozitif olmalı (alınan=%d)" % int(iyi.get("saglik_deltasi", 0)))

	# 2) Hekim yokken kayip surer (negatif delta)
	var hekimsiz: Dictionary = HekimIlac.yara_tedavi_uygula(
		{"yara_id": "yara_02", "saglik": 50, "yabanci": false},
		{"bina": {"sifahane": true}, "hekim_var": false},
		{}
	)
	_kontrol(int(hekimsiz.get("saglik_deltasi", 0)) < 0, "Hekim yokken sağlık kaybı sürmeli (alınan=%d)" % int(hekimsiz.get("saglik_deltasi", 0)))

	# 3) Hekim kendisi yaraliyken de kayip surer
	var yarali_hekim: Dictionary = HekimIlac.yara_tedavi_uygula(
		{"yara_id": "yara_03", "saglik": 50, "yabanci": false},
		{"bina": {"sifahane": true}, "hekim_var": true, "hekim_yarali": true},
		{}
	)
	_kontrol(int(yarali_hekim.get("saglik_deltasi", 0)) < 0, "Hekim kendisi yaralıysa tedavi edememeli, kayıp sürmeli")


func _test_yabanci_tedavi_edip_gonder_itibar_ve_koylu_olmama() -> void:
	var gi := GrupItibariSinifi.new()
	# Yabanci tedavi edilip gonderilirse grup itibari +1 ve koylu olmaz
	var yabanci_sonuc: Dictionary = HekimIlac.yara_tedavi_uygula(
		{"yara_id": "yabanci_01", "saglik": 40, "yabanci": true, "grup": "rum", "eylem": "tedavi_edip_gonder"},
		{"sifahane": true, "hekim_var": true, "ilac_var": true},
		{},
		gi
	)
	_kontrol(int(yabanci_sonuc.get("itibar_artisi", 0)) == 1 and gi.deger("rum") == 1, "Yabancı tedavi edilip gönderilirse grup itibarı 1 artmalı")
	_kontrol(not bool(yabanci_sonuc.get("koylu_oldu", true)), "Tedavisi biten yabancı köylü olmamalı, gitmeli")

	# Bizden yaralida itibar artisi 0 olmali
	var bizden_sonuc: Dictionary = HekimIlac.yara_tedavi_uygula(
		{"yara_id": "bizden_01", "saglik": 40, "yabanci": false, "eylem": "tedavi"},
		{"sifahane": true, "hekim_var": true, "ilac_var": true},
		{},
		gi
	)
	_kontrol(int(bizden_sonuc.get("itibar_artisi", -1)) == 0, "İtibar artışı yalnız yabancı 'tedavi edip gönder'de 1 olmalı, bizden köylüde 0 kalmalı")


func _test_ayni_yara_ikinci_gece_sifir() -> void:
	var iyilesenler := {}
	var gece_1: Dictionary = HekimIlac.yara_tedavi_uygula(
		{"yara_id": "ayni_yara_1", "saglik": 50, "yabanci": false},
		{"sifahane": true, "hekim_var": true},
		iyilesenler
	)
	var gece_2: Dictionary = HekimIlac.yara_tedavi_uygula(
		{"yara_id": "ayni_yara_1", "saglik": int(gece_1.get("yeni_saglik", 75)), "yabanci": false},
		{"sifahane": true, "hekim_var": true},
		iyilesenler
	)
	_kontrol(int(gece_1.get("saglik_deltasi", 0)) > 0, "İlk gece yara iyileşmeli")
	_kontrol(int(gece_2.get("saglik_deltasi", -1)) == 0, "Aynı yara ikinci gece sağlık deltası 0 olmalı")


func _test_sifahane_false_olu_ve_iki_yarali_kuyrugu() -> void:
	_kontrol(not HekimIlac.yara_tedavi_secenegi_gorunur({"bina": {"sifahane": false}}, false), "Şifahane false iken tedavi seçeneği görünmemeli")
	_kontrol(not HekimIlac.yara_tedavi_secenegi_gorunur({"bina": {"sifahane": true}}, true), "Ölü için tedavi seçeneği görünmemeli")

	var olu_sonuc: Dictionary = HekimIlac.yara_tedavi_uygula(
		{"yara_id": "olu_1", "saglik": 0, "olu": true},
		{"sifahane": true, "hekim_var": true}
	)
	_kontrol(not bool(olu_sonuc.get("olur", true)) and String(olu_sonuc.get("neden", "")) == "olu_hekime_gitmez", "Ölü hekime gitmemeli")

	# İki yaralı aynı gece varsa hekim birini seçer, diğeri bekler; bekleyen yabancı gece ölürse itibar artışı 0
	var kuyruk: Array[Dictionary] = HekimIlac.yara_gece_kuyrugu_isle(
		[
			{"yara_id": "kuyruk_1", "saglik": 50, "yabanci": false},
			{"yara_id": "kuyruk_2", "saglik": 5, "gece_kaybi": 10, "yabanci": true, "grup": "turkmen", "eylem": "tedavi_edip_gonder"},
		],
		{"sifahane": true, "hekim_var": true}
	)
	_kontrol(kuyruk.size() == 2, "İki yaralı sonucu dönmeli")
	_kontrol(bool(kuyruk[0].get("tedavi_edildi", false)), "İlk yaralı tedavi edilmeli")
	_kontrol(bool(kuyruk[1].get("bekledi", false)) and bool(kuyruk[1].get("oldu", false)) and int(kuyruk[1].get("itibar_artisi", -1)) == 0, "Bekleyen yabancı gece ölürse itibar artışı 0 olmalı")


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
