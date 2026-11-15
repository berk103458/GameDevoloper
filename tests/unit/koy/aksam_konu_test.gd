# gdlint: disable=max-line-length
extends SceneTree

const AksamSohbeti = preload("res://src/koy/aksam_sohbeti.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	AksamSohbeti.sifirla()

	# 1. Yusuf kararı sonrası ağırlığı en yüksek olay konusu seçilir
	# Yusuf kararı: aileyi_bolmek (ağırlık 5) ve kacak_yetimi_almak (ağırlık 3)
	var kararlar := [
		{"konu_id": "kacak_yetimi_almak", "ziyaret_sirasi": 1},
		{"konu_id": "aileyi_bolmek", "ziyaret_sirasi": 2}
	]
	var secilen := AksamSohbeti.konu_sec(kararlar, 1, {"es_meslegi": "dokumaci", "es_hayatta": true})
	if secilen.is_empty():
		hatalar.append("AksamSohbeti konu seçemedi!")
	elif secilen.get("konu_id") != "aileyi_bolmek":
		hatalar.append("Ağırlığı en yüksek 'aileyi_bolmek' yerine '%s' seçildi!" % secilen.get("konu_id"))

	# 2. Eşit ağırlıkta ziyaret sırası büyük olan konu gelir
	AksamSohbeti.sifirla()
	var esit_kararlar := [
		{"konu_id": "aileyi_bolmek", "ziyaret_sirasi": 1}, # Ağırlık 5
		{"konu_id": "rusvet_almak", "ziyaret_sirasi": 4}   # Ağırlık 5, daha yeni
	]
	var esit_secim := AksamSohbeti.konu_sec(esit_kararlar, 1, {"es_meslegi": "firinci", "es_hayatta": true})
	if esit_secim.get("konu_id") != "rusvet_almak":
		hatalar.append("Eşit ağırlıkta ziyaret sırası büyük olan seçilmedi; seçilen: %s" % esit_secim.get("konu_id"))

	# 3. Atlama barı değiştirmez
	var atlama := AksamSohbeti.atla()
	if not atlama.get("atlandi", false) or atlama.get("moral_etkisi") != 0:
		hatalar.append("Atlama bar veya durum değiştirdi!")

	# 4. Ağırlığı 0 olan olay konu olmaz
	AksamSohbeti.sifirla()
	var sifir_karar := [
		{"konu_id": "olmayan_konu", "ziyaret_sirasi": 1}
	]
	var sifir_secim := AksamSohbeti.konu_sec(sifir_karar, 1, {"es_hayatta": true})
	if not sifir_secim.is_empty():
		hatalar.append("Ağırlığı 0 / tanınmayan olay konu olarak seçildi!")

	# 5. Cevap işleme ve eş hafızası kontrolü
	var cevap_sonucu := AksamSohbeti.cevap_ver("rusvet_almak", "savunmak", {"gun": 2})
	if cevap_sonucu.get("terazi") != "savundu":
		hatalar.append("Cevap teraziye 'savundu' olarak işlenmedi!")
	var hafiza := AksamSohbeti.hafiza_al()
	if hafiza.get("son_konu") != "rusvet_almak" or hafiza.get("son_cevap") != "savunmak":
		hatalar.append("Eş hafızası güncellenmedi!")

	# 6. Gerçek Oturum.karar_ver -> ağırlık eşleşmesi, DIY-11 eş hafızası, terazi/adalet ve ertesi gün ipucu
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 9202)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(o)
	o.gun = 1
	o.yonetim.gun = 1
	var es_id := int(preload("res://src/sistemler/acilis_senaryosu.gd").durum(o).get("es_id", -1))
	var es := o.yonetim.koylu(es_id)
	var es_once_moral := es.moral if es != null else 60
	var adalet_once := o.yonetim.adalet

	var g_hasta := Gelen.new()
	g_hasta.sinif = &"hasta"
	g_hasta.gizli_bayraklar = PackedStringArray(["hasta"])
	g_hasta.heybe = Heybe.new()
	o.karar_ver(g_hasta, &"kabul")

	var g_rusvet := Gelen.new()
	g_rusvet.sinif = &"tuccar"
	g_rusvet.heybe = Heybe.new()
	o.karar_ver(g_rusvet, &"rusvet")

	var sohbet1 := o.aksam_sohbeti_hazirla({"meclis_gecesi": false})
	if String(sohbet1.get("konu_id", "")) != "rusvet_almak":
		hatalar.append("Oturum kararlarından en ağır konu (rusvet_almak) seçilmedi!")

	o.aksam_sohbeti_uygula("rusvet_almak", "kabul_etmek")
	if es != null and es.moral != es_once_moral + 2:
		hatalar.append("kabul_etmek cevabı gerçek eş moraline +2 yazmalı!")
	if o.yonetim.adalet != clampi(adalet_once + 1, 0, 100):
		hatalar.append("kabul_etmek terazi/adaleti güncellemeli!")
	if String(o.get_meta(&"es_aksam_ipucu", "")) != "rusvet_fisiltisi_koyde":
		hatalar.append("Eş sohbeti ertesi gün ipucunu yazmalı!")
	var diy_es := KisiHafizasi.es_hafizasi_oku(o.kadro, &"es")
	if String(diy_es.get("son_cevap", "")) != "kabul_etmek":
		hatalar.append("Eş sohbet hafızası DIY-11 KisiHafizasi.es altına yazılmalı!")

	# Ertesi gün: yeni ağır kararda eş geçmiş sohbeti anar; susmak moral bozmadan 'kacti' yazar
	o.gun = 2
	o.yonetim.gun = 2
	var g_yetim := Gelen.new()
	g_yetim.sinif = &"ciftci"
	g_yetim.acik_bayraklar = PackedStringArray(["yetim"])
	g_yetim.heybe = Heybe.new()
	o.karar_ver(g_yetim, &"kabul")
	var sohbet2 := o.aksam_sohbeti_hazirla({"meclis_gecesi": false})
	var ani_var := false
	for r in sohbet2.get("es_replikleri", []):
		if "Geçen" in str(r):
			ani_var = true
	if not ani_var:
		hatalar.append("Ertesi akşam eş geçmiş sohbeti anmalı!")
	var es_moral_2 := es.moral if es != null else 60
	o.aksam_sohbeti_uygula(String(sohbet2.get("konu_id", "kacak_yetimi_almak")), "susmak")
	if es != null and es.moral != es_moral_2:
		hatalar.append("susmak cevabı eş moralini düşürmemeli!")
	var diy_es_2 := KisiHafizasi.es_hafizasi_oku(o.kadro, &"es")
	if String(diy_es_2.get("son_terazi", "")) != "kacti":
		hatalar.append("susmak terazi kaydına 'kacti' yazmalı!")
	if AksamSohbeti.gundelik_satir({"es_hayatta": true}).is_empty():
		hatalar.append("Ağır karar yokken gündelik kısa satır okunabilmeli!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: aksam_konu_test.gd")
	quit(0)
