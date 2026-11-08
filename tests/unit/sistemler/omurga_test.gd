extends SceneTree

const OmurgaSinifi = preload("res://src/sistemler/omurga.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("OMURGA TEST HATASI: " + mesaj)


func _initialize() -> void:
	# OMR-02: Perde 1 uc donemi (nufus < 8 -> kurulus, 8..13 -> yerlesme, 14..18 -> oturma)
	_kontrol(OmurgaSinifi.donem(5) == &"kurulus", "Nufus 5 iken donem kurulus olmali")
	_kontrol(OmurgaSinifi.donem(10) == &"yerlesme", "Nufus 10 iken donem yerlesme olmali")
	_kontrol(OmurgaSinifi.donem(16) == &"oturma", "Nufus 16 iken donem oturma olmali")

	# OMR-04: Perde 2 uc dalgasi; hedef 12 (4+4+4) ve hedef 15 (5+5+5) sinirlari
	_kontrol(OmurgaSinifi.dalga(0, 12) == 1 and OmurgaSinifi.dalga(3, 12) == 1, "Hedef 12'de gece 0..3 dalga 1 olmali")
	_kontrol(OmurgaSinifi.dalga(4, 12) == 2 and OmurgaSinifi.dalga(7, 12) == 2, "Hedef 12'de gece 4..7 dalga 2 olmali")
	_kontrol(OmurgaSinifi.dalga(8, 12) == 3 and OmurgaSinifi.dalga(11, 12) == 3, "Hedef 12'de gece 8..11 dalga 3 olmali")

	_kontrol(OmurgaSinifi.dalga(4, 15) == 1, "Hedef 15'te gece 4 dalga 1 olmali")
	_kontrol(OmurgaSinifi.dalga(5, 15) == 2 and OmurgaSinifi.dalga(9, 15) == 2, "Hedef 15'te gece 5..9 dalga 2 olmali")
	_kontrol(OmurgaSinifi.dalga(10, 15) == 3 and OmurgaSinifi.dalga(14, 15) == 3, "Hedef 15'te gece 10..14 dalga 3 olmali")

	# OMR-06 ve OMR-34: omurga.gd icinde kaydet/yukle ve Takvim gecmemeli
	var kaynak_metin := FileAccess.get_file_as_string("res://src/sistemler/omurga.gd")
	_kontrol(not kaynak_metin.contains("kaydet") and not kaynak_metin.contains("yukle"), "OMR-06: omurga.gd icinde kaydet/yukle olmamali")
	_kontrol(not kaynak_metin.contains("Takvim") and not kaynak_metin.contains("takvim"), "OMR-34: omurga.gd icinde Takvim olmamali")

	# OMR-39: Sahte dedikodu bayrağı dış hat kapısını tetiklemez; yalnız haberci_agi doğrulanmış haber sayılır
	var dis_hat := preload("res://src/sistemler/dis_hat_kapisi.gd")
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 404)
	o.bayraklar["dedikodu_mogol_geldi"] = true
	o.yonetim.set_meta(&"dedikodu", [{"satir": "Sahte mogol dedikodusu"}])
	_kontrol(not dis_hat.dogrulanmis_haber_var_mi(o, "mogol"), "OMR-39: sahte dedikodu dış hat haberini doğrulamaz")
	o.haberci_agi = {"bekleyen": [{"hat": "mogol"}]}
	_kontrol(dis_hat.dogrulanmis_haber_var_mi(o, "mogol"), "OMR-39: haberci_agi kaydı doğrulanmış haber sayılır")

	# OMR-41: denge.json içinde kriz_dalga_carpani vardır ve > 1.0
	var denge_veri: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/denge.json"))
	_kontrol(denge_veri.has("kriz_dalga_carpani") and float(denge_veri.get("kriz_dalga_carpani", 0.0)) > 1.0, "OMR-41: denge.json içinde kriz_dalga_carpani > 1.0 olmalı")

	# OMR-42: Nüfus < 14 iken çete/pusucu risk profilleri ağırlığı 0
	var suzgec := preload("res://src/sistemler/omurga_suzgeci.gd")
	o.gun = 14
	var risk_id := StringName(GuvenlikKafileDengesi.AYAR.risk_profilleri[0])
	var adaylar: Array[StringName] = [risk_id, &"chr_013"]
	var w_erken := suzgec.agirliklar(o, adaylar)
	_kontrol(is_zero_approx(w_erken[0]), "OMR-42: nüfus < 14 iken çete/risk profili ağırlığı 0 olmalı")
	for i in 14:
		o.yonetim.kabul({"ad": "Koylu_%d" % i})
	var w_oturma := suzgec.agirliklar(o, adaylar)
	_kontrol(w_oturma[0] > 0.0, "OMR-42: nüfus >= 14 (oturma dönemi) iken risk profili açılır")

	# OMR-19: Moğol hattı 3 adımdır (duman -> haber -> öncü), adım atlanırsa sonraki tetiklenmez
	var o_hat := Oturum.new(kat, 405)
	o_hat.yonetim.agalik = true
	o_hat.yonetim.set_meta(&"perde2_baslangic", 10)
	o_hat.yonetim.perde2_hedef = 12
	o_hat.yonetim.gun = 11 # Dalga 1
	_kontrol(dis_hat.mogol_adim_izin(o_hat, 1) and not dis_hat.mogol_adim_izin(o_hat, 2), "OMR-19: dalga 1'de yalnız adım 1 (duman) açık")
	o_hat.yonetim.gun = 15 # Dalga 2, duman atlandı
	_kontrol(not dis_hat.mogol_adim_izin(o_hat, 2), "OMR-19: duman atlanırsa dalga 2'de haber tetiklenmez")
	o_hat.yonetim.gun = 11
	_kontrol(dis_hat.mogol_adim_tamamla(o_hat, 1), "OMR-19: dalga 1'de duman tamamlanır")
	o_hat.yonetim.gun = 15
	_kontrol(dis_hat.mogol_adim_tamamla(o_hat, 2), "OMR-19: dalga 2'de haber tamamlanır")
	o_hat.yonetim.gun = 19 # Dalga 3
	_kontrol(dis_hat.mogol_adim_tamamla(o_hat, 3), "OMR-19: dalga 3'te öncü tamamlanır")

	# OMR-20: Tekfur hattı (elçi -> haraç -> heyet), elçi gelmeden haraç talebi 0
	var o_tekfur := Oturum.new(kat, 406)
	o_tekfur.yonetim.agalik = true
	o_tekfur.yonetim.set_meta(&"perde2_baslangic", 10)
	o_tekfur.yonetim.perde2_hedef = 12
	o_tekfur.yonetim.gun = 15 # Dalga 2, elçi gelmedi
	_kontrol(not dis_hat.tekfur_harac_izin(o_tekfur), "OMR-20: elçi gelmeden haraç talebi 0")
	o_tekfur.yonetim.gun = 11 # Dalga 1
	_kontrol(dis_hat.tekfur_adim_tamamla(o_tekfur, 1), "OMR-20: dalga 1'de elçi gelir")
	o_tekfur.yonetim.gun = 15 # Dalga 2
	_kontrol(dis_hat.tekfur_harac_izin(o_tekfur) and dis_hat.tekfur_adim_tamamla(o_tekfur, 2), "OMR-20: elçiden sonra dalga 2'de haraç açılır")
	o_tekfur.yonetim.gun = 19 # Dalga 3
	_kontrol(dis_hat.tekfur_heyet_izin(o_tekfur) and dis_hat.tekfur_adim_tamamla(o_tekfur, 3), "OMR-20: dalga 3'te heyet açılır")

	# OMR-23: Ahi hattı: TEZ teslim sayısı >= 1 değilse ahi gelmez
	var o_ahi := Oturum.new(kat, 407)
	o_ahi.yonetim.agalik = true
	o_ahi.yonetim.set_meta(&"perde2_baslangic", 10)
	o_ahi.yonetim.perde2_hedef = 12
	o_ahi.yonetim.gun = 15 # Dalga 2
	_kontrol(not dis_hat.ahi_gelebilir_mi(o_ahi), "OMR-23: TEZ teslim 0 iken ahi gelmez")
	o_ahi.yonetim.set_meta(&"tezgahta_is", {"bez": {"teslim": 1}})
	_kontrol(dis_hat.ahi_gelebilir_mi(o_ahi), "OMR-23: TEZ teslim >= 1 iken dalga 2'de ahi gelebilir")

	# OMR-24: Hatlar aynı gece çakışmaz (sancak > tekfur > mogol > oba > ahi) ve model kapıda kalır
	var ayni_gece := dis_hat.gece_yuzu_sec(["ahi", "oba", "mogol", "tekfur", "sancak"])
	_kontrol(ayni_gece.size() == 1 and ayni_gece[0] == "sancak", "OMR-24: hepsi uygunken bir gecede yalnız en yüksek öncelikli 1 yüz seçilir")
	_kontrol(dis_hat.yuz_konumu("sancak") == "kapi", "OMR-24: dış hat yüzü modeli kapıda kalır")

	# OMR-25 & OMR-29: Üç karar üç hattı kapatır; tutulmayan söz hattı kapatır
	var o_karar := Oturum.new(kat, 408)
	var atil_veri: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/atil_bayraklar.json"))
	var b1 := dis_hat.karar_uygula(o_karar, "tekfur_elci_red")
	var b2 := dis_hat.karar_uygula(o_karar, "mogol_oncu_kabul")
	var b3 := dis_hat.karar_uygula(o_karar, "ulak_aldat")
	_kontrol(atil_veri.has(b1) and atil_veri.has(b2) and atil_veri.has(b3), "OMR-25: üç karar atil_bayraklar.json zincirine uyan bayraklar üretir")
	_kontrol(dis_hat.hat_kapali_mi(o_karar, "tekfur") and dis_hat.hat_kapali_mi(o_karar, "sancak"), "OMR-25: red ve aldatma ilgili hatları kapatır")
	var soz_bayrak := dis_hat.soz_kontrol_et(o_karar, "oba", false)
	_kontrol(soz_bayrak == "soz_oba_tutuldu" and dis_hat.hat_kapali_mi(o_karar, "oba"), "OMR-29: tutulmayan söz ilgili hattı kapatır")

	# OMR-26 & OMR-30: Kapatılan hat sona ve oda gidişat paneline yansır; dört hat kapalı + yozlaşma düşük -> uc_tutundu
	var o_son := Oturum.new(kat, 409)
	o_son.yonetim.agalik = true
	o_son.yonetim.set_meta(&"perde2_baslangic", 10)
	o_son.yonetim.perde2_hedef = 12
	o_son.yonetim.gun = 16 # Dalga 2
	o_son.yonetim.savusturulan = 1
	o_son.sancak_asker_talebi = {"gun": 12, "bekliyor": false, "levent_gonderildi": true, "gonderilen": [1]}
	var oda_paneli := preload("res://src/arayuz/oda_gidisat_paneli.gd")
	var once_cumle := oda_paneli.gidisat_cumlesi(o_son)
	dis_hat.karar_uygula(o_son, "ulak_aldat") # sancak hattını kapatır
	var sonra_cumle := oda_paneli.gidisat_cumlesi(o_son)
	_kontrol(not once_cumle.is_empty() and once_cumle != sonra_cumle, "OMR-26: hat kapatıldıktan sonra oda gidişat paneli cümlesi değişir")
	for h in ["sancak", "tekfur", "mogol", "oba", "ahi"]:
		dis_hat.soz_kontrol_et(o_son, h, false)
	var nihai := preload("res://src/sistemler/nihai_son.gd")
	_kontrol(nihai.son(o_son, &"zafer") == "uc_tutundu", "OMR-30: dört hat kapalı ve yozlaşma düşükken son uc_tutundu olur")

	# OMR-32: Üç dalgada yüz sayısı >= 3 (tüm hatlar kapalıysa ulak/sancak_cavusu döner)
	var dalga_yuzleri := dis_hat.uc_dalga_yuzleri(o_son, [["tekfur"], ["oba"], ["ahi"]])
	_kontrol(dalga_yuzleri.size() >= 3 and dalga_yuzleri[0] == "sancak_cavusu", "OMR-32: hatlar kapalıyken bile 3 dalgada en az 3 yüz (ulak) gelir")

	# OMR-36 & OMR-37: Haber dış hat yüzünden 1-2 gece önce düşer; ziyaretçi söylediyse yazılı satır 0
	var o_haber := Oturum.new(kat, 410)
	for h in ["mogol", "tekfur", "oba", "sancak"]:
		var plan := dis_hat.oncu_haber_planla(o_haber, h, 6, 2)
		var fark := int(plan["yuz_gecesi"]) - int(plan["haber_gecesi"])
		_kontrol((fark == 1 or fark == 2) and int(plan["yazili_satir"]) == 1, "OMR-36: %s için yüz gecesi - haber gecesi 1 veya 2 olmalı" % h)
	var o_insan := Oturum.new(kat, 411)
	o_insan.bayraklar["insandan_haber_mogol"] = true
	var insan_plan := dis_hat.oncu_haber_planla(o_insan, "mogol", 6, 1)
	_kontrol(int(insan_plan["yazili_satir"]) == 0, "OMR-37: ziyaretçi haberi söylediyse yazılı satır 0 olmalı")

	# OMR-44: Çınar meclisi Perde 2'de hafta başı toplanır; dış hat konusu varsa köy şikayeti yerine dış hat konuşulur
	var meclis_sesi := preload("res://src/koy/meclis_sesi.gd")
	var p2_acik_hafta := meclis_sesi.meclis_acik_mi(7, false, 2, 7)
	var p2_kapali_hafta_disi := meclis_sesi.meclis_acik_mi(8, false, 2, 7)
	_kontrol(p2_acik_hafta and not p2_kapali_hafta_disi, "OMR-44: perde 2'de kriz olmasa da hafta başı meclis 1, hafta dışı 0")
	var konu_dis_hat := meclis_sesi.meclis_konusu(o_son.yonetim, "mogol_oncusu")
	var konu_varsayilan := meclis_sesi.meclis_konusu(o_son.yonetim, "")
	_kontrol(konu_dis_hat == "mogol_oncusu" and konu_varsayilan == "koy_sikayeti", "OMR-44: dış hat varsa konuşulan konu odur, aynı gece ikisi birlikte açılmaz")

	# OMR-49: Muhafızın geçmişi hat yüzlerinin ilk cümlesini değiştirir (iki geçmişle selam farkı >= 1)
	for yuz in ["sancak", "tekfur", "mogol", "oba", "ahi"]:
		var selam_levent := dis_hat.hat_selami(yuz, "eski_levent")
		var selam_katip := dis_hat.hat_selami(yuz, "medrese_talebesi")
		_kontrol(not selam_levent.is_empty() and not selam_katip.is_empty() and selam_levent != selam_katip, "OMR-49: %s yüzünde levent ve kâtip selamı farklıdır" % yuz)

	# OMR-50: Tohum ve omurga (20 tohumda yüz gecesi daima dalga sınırı içindedir)
	for d in [1, 2, 3]:
		for t in 20:
			var tohum := 1000 + t * 37
			var gece := dis_hat.tohumlu_yuz_gecesi(tohum, d, 12)
			_kontrol(OmurgaSinifi.dalga(gece, 12) == d, "OMR-50: tohum %d için dalga %d gecesi (%d) dalga sınırları içindedir" % [tohum, d, gece])

	if _hata == 0:
		print("OMURGA: GEÇTİ (0 hata)")
	else:
		print("OMURGA: KALDI (%d hata)" % _hata)
	quit(_hata)
