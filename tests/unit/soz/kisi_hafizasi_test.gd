## DIY-11: Kisi hafizasi — donen karakter hatirlar birim testi.
## Kabul kriterleri:
## - `son_karar=ret` iken selam kimligi `selam_ret` olur.
## - Kadroda ikinci sozluk yazimi 0'dir (`KarakterKadrosu.durumlar` tek kaynaktir).
## - Ek sart: kaydet-yukle sonrasi ziyaret sayisi ayni kalir.
## - Ek sart: onuncu ziyaret dokuzuncu ziyaretin selam anahtarini kullanir.
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var oturum := Oturum.new(katalog, 4213)
	var kadro := oturum.kadro
	var ornek_id: StringName = katalog.karakterler()[0].id

	_test_ilk_ziyaret_ve_selam_ret(kadro, ornek_id)
	_test_ret_sonrasi_kabul_ve_gecmis_koruma(kadro, ornek_id)
	_test_kadroda_ikinci_sozluk_yok(kadro, ornek_id)
	_test_kaydet_yukle_ziyaret_sayisi_ve_eski_kayit(katalog, kadro, ornek_id)
	_test_onuncu_ziyaret_dokuzuncu_anahtar(kadro, ornek_id)
	_test_olum_kapanisi_ve_dyl08(kadro, ornek_id)
	_test_ayni_gun_ve_ertesi_kapi(katalog)
	_test_diy09_selam_ve_konu_degisimi(oturum, kadro, ornek_id)

	await process_frame
	print("KISI HAFIZASI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _test_ilk_ziyaret_ve_selam_ret(kadro: KarakterKadrosu, id: StringName) -> void:
	# Ilk ziyarette hafiza bosken selam_ilk gelir
	kadro.ziyaret_basladi(id, 1)
	_kontrol(KisiHafizasi.selam_kimligi(kadro, id, 2) == "selam_ilk", "Hafıza yokken ilk ziyaret selamı selam_ilk olmalı")

	# Ret kararindan sonra ertesi kapida selam_ret olur
	KisiHafizasi.kaydet_olay(kadro, id, {
		"son_karar": "ret",
		"verilen_soz": "kislada_bekle",
		"yapilan_yardim": "ekmek_verildi",
		"yuzlesilen_yalan": "sahte_muhur",
		"odenen_akce": 3,
		"alinan_akce": 5,
	}, 1)
	_kontrol(KisiHafizasi.selam_kimligi(kadro, id, 2) == "selam_ret", "son_karar=ret iken selam kimliği selam_ret olmalı")

	var h := KisiHafizasi.oku(kadro, id, 2)
	_kontrol(String(h.get("verilen_soz", "")) == "kislada_bekle", "Verilen söz hafızada tutulmalı")
	_kontrol(String(h.get("yapilan_yardim", "")) == "ekmek_verildi", "Yapılan yardım hafızada tutulmalı")
	_kontrol(String(h.get("yuzlesilen_yalan", "")) == "sahte_muhur", "Yüzleşilen yalan hafızada tutulmalı")
	_kontrol(int(h.get("akce_farki", 0)) == 2, "Ödenen ve alınan akçe farkı doğru tutulmalı (5 - 3 = 2)")


func _test_ret_sonrasi_kabul_ve_gecmis_koruma(kadro: KarakterKadrosu, id: StringName) -> void:
	# Uç durum: ret sonrası kabul, son_karar alanını ezer; ret satırı silinmez, selam son kararı okur.
	KisiHafizasi.kaydet_olay(kadro, id, {"son_karar": "kabul"}, 3)
	_kontrol(KisiHafizasi.selam_kimligi(kadro, id, 4) == "selam_kabul", "Ret sonrası kabulde selam son kararı (selam_kabul) okumalı")
	var h := KisiHafizasi.oku(kadro, id, 4)
	var gecmis: Array = h.get("karar_gecmisi", [])
	var ret_var := false
	for kayit in gecmis:
		if kayit is Dictionary and String((kayit as Dictionary).get("karar", "")) == "ret":
			ret_var = true
	_kontrol(ret_var, "Ret sonrası kabulde geçmişteki ret satırı silinmemeli")


func _test_kadroda_ikinci_sozluk_yok(kadro: KarakterKadrosu, id: StringName) -> void:
	# Kural 2 ve5: Tek kaynak KarakterKadrosu.durumlar[id] alanlarıdır; eş hafızası da aynı kaydın `es` altıdır.
	KisiHafizasi.es_hafizasi_yaz(kadro, id, {"yorum": "Merhamet ettin.", "gece": 3})
	var es := KisiHafizasi.es_hafizasi_oku(kadro, id)
	_kontrol(String(es.get("yorum", "")) == "Merhamet ettin.", "Eşin akşam hafızası aynı kaydın `es` altında okunmalı")
	_kontrol((kadro.durumlar[id] as Dictionary).has("es"), "Eş verisi doğrudan kadro.durumlar[id]['es'] içinde durmalı")

	# KisiHafizasi sinifinda ikinci bir durum/hafiza sozlugu mulku bulunmamali
	var ornek := KisiHafizasi.new()
	var ikinci_sozluk_sayisi := 0
	for p in ornek.get_property_list():
		var ad := String(p.get("name", ""))
		if int(p.get("usage", 0)) & PROPERTY_USAGE_SCRIPT_VARIABLE != 0:
			ikinci_sozluk_sayisi += 1
	_kontrol(ikinci_sozluk_sayisi == 0, "KisiHafizasi içinde ikinci sözlük/depo değişkeni 0 olmalı (bulunan=%d)" % ikinci_sozluk_sayisi)


func _test_kaydet_yukle_ziyaret_sayisi_ve_eski_kayit(katalog: Katalog, kadro: KarakterKadrosu, id: StringName) -> void:
	kadro.durumlar[id]["ziyaret"] = 4
	var onceki_ziyaret := int(kadro.durumlar[id]["ziyaret"])
	var kayit_verisi := kadro.kaydet()

	var yeni_oturum := Oturum.new(katalog, 4213)
	var yuklendi := yeni_oturum.kadro.yukle(kayit_verisi)
	_kontrol(yuklendi, "Kadro kaydı hatasız yüklenmeli")
	var sonraki_ziyaret := int(yeni_oturum.kadro.durumlar[id]["ziyaret"])
	_kontrol(sonraki_ziyaret == onceki_ziyaret, "Kaydet-yükle sonrası ziyaret sayısı aynı kalmalı (%d == %d)" % [sonraki_ziyaret, onceki_ziyaret])

	var h := KisiHafizasi.oku(yeni_oturum.kadro, id, 10)
	_kontrol(String(h.get("verilen_soz", "")) == "kislada_bekle", "Kaydet-yükle sonrası opsiyonel hafıza alanları korunmalı")

	# Eski kayitta opsiyonel alanlar yoksa bos sayilmali, oyun cokmemeli
	var eski_kayit := kadro.kaydet()
	for k_id in eski_kayit.keys():
		var d: Dictionary = eski_kayit[k_id]
		d.erase("verilen_soz")
		d.erase("yapilan_yardim")
		d.erase("yuzlesilen_yalan")
		d.erase("akce_farki")
		d.erase("karar_gecmisi")
		d.erase("es")
	var eski_oturum := Oturum.new(katalog, 99)
	_kontrol(eski_oturum.kadro.yukle(eski_kayit), "Eski kayıt formatı çökmeden yüklenmeli")
	var eski_h := KisiHafizasi.oku(eski_oturum.kadro, id, 10)
	_kontrol(String(eski_h.get("verilen_soz", "")) == "", "Eski kayıtta olmayan alan boş sayılmalı")


func _test_onuncu_ziyaret_dokuzuncu_anahtar(kadro: KarakterKadrosu, id: StringName) -> void:
	var dokuzuncu := KisiHafizasi.ziyaret_selam_anahtari(9)
	var onuncu := KisiHafizasi.ziyaret_selam_anahtari(10)
	var on_besinci := KisiHafizasi.ziyaret_selam_anahtari(15)
	_kontrol(dokuzuncu == "selam_9", "Dokuzuncu ziyaret anahtarı selam_9 olmalı")
	_kontrol(onuncu == dokuzuncu, "Onuncu ziyaret dokuzuncu ziyaretin selam anahtarını kullanmalı (%s == %s)" % [onuncu, dokuzuncu])
	_kontrol(on_besinci == dokuzuncu, "9'dan sonraki tüm ziyaretler 9. ziyaretin selam anahtarını kullanmalı")

	kadro.durumlar[id]["ziyaret"] = 10
	var h := KisiHafizasi.oku(kadro, id, 20)
	_kontrol(int(h.get("etkin_ziyaret", 0)) == 9, "Etkin ziyaret sayacı 9'da tavanlanmalı")


func _test_olum_kapanisi_ve_dyl08(kadro: KarakterKadrosu, id: StringName) -> void:
	var haber := KisiHafizasi.oldu_isaretle(kadro, id, 7)
	_kontrol(String(haber.get("kanal", "")) == "DYL-08", "Ölüm haberi DYL-08 kanalına gitmeli")
	_kontrol(KisiHafizasi.selam_kimligi(kadro, id, 8) == "", "Ölen kişi için selam kimliği boş dönmeli")
	var secilen := KisiHafizasi.selam_sec([{"id": "selam_ret", "kosullar": {}}], {}, kadro, id, 8)
	_kontrol(secilen.is_empty(), "Ölen kişi için selam varyantı seçilmemeli")


func _test_ayni_gun_ve_ertesi_kapi(katalog: Katalog) -> void:
	var o := Oturum.new(katalog, 123)
	var id: StringName = katalog.karakterler()[0].id
	o.kadro.ziyaret_basladi(id, 5)
	KisiHafizasi.kaydet_olay(o.kadro, id, {"son_karar": "ret"}, 5)
	# Ayni gece (gece=5) ikinci ziyaret yoksa hafiza ertesi kapida (gece=6) okunur
	_kontrol(KisiHafizasi.selam_kimligi(o.kadro, id, 5) == "selam_ilk", "Aynı gün ikinci ziyaret yoksa hafıza o gece henüz selamı değiştirmemeli")
	_kontrol(KisiHafizasi.selam_kimligi(o.kadro, id, 6) == "selam_ret", "Ertesi kapıda (gece 6) hafıza selam_ret olarak okunmalı")


func _test_diy09_selam_ve_konu_degisimi(oturum: Oturum, kadro: KarakterKadrosu, id: StringName) -> void:
	# Karakteri canli duruma geri alip ret + verilen_soz ile DIY-09 secimini dogrula
	kadro.durumlar[id]["durum"] = &"donebilir"
	kadro.durumlar[id]["ziyaret"] = 2
	KisiHafizasi.kaydet_olay(kadro, id, {"son_karar": "ret", "verilen_soz": "emanet_getir"}, 2)

	var baz_baglam := BaglamSorgusu.new().kur(oturum, null)
	var selam_varyantlari := [
		{"id": "selam_ilk", "metin": "Kapı açık mı muhafız?", "kosullar": {}},
		{"id": "selam_ret", "metin": "Geçen gelişimde kapıdan çevirmiştin.", "kosullar": {"son_karar": "ret"}},
	]
	var konu_varyantlari := [
		{"id": "konu_varsayilan", "metin": "Yolum uzundur.", "kosullar": {}},
		{"id": "konu_soz_hatirlatma", "metin": "Söz verdiğim emaneti getirdim.", "kosullar": {"son_karar": "ret", "verilen_soz": "emanet_getir"}},
	]

	var secilen_selam := KisiHafizasi.selam_sec(selam_varyantlari, baz_baglam, kadro, id, 4)
	var secilen_konu := KisiHafizasi.konu_sec(konu_varyantlari, baz_baglam, kadro, id, 4)
	_kontrol(String(secilen_selam.get("id", "")) == "selam_ret", "Dönüşte selam DIY-09 varyantıyla selam_ret olmalı")
	_kontrol(String(secilen_konu.get("id", "")) == "konu_soz_hatirlatma", "Dönüşte en az 1 konu hafızaya göre değişmeli")


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
