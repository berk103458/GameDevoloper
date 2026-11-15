# gdlint: disable=max-line-length
extends SceneTree

const AksamSohbeti = preload("res://src/koy/aksam_sohbeti.gd")

func _init() -> void:
	var hatalar: Array[String] = []

	AksamSohbeti.sifirla()

	# 1. Ağır kararlı gecede rapor öncesi sohbet 1 kez açılır
	var kararlar := [
		{"konu_id": "aileyi_bolmek", "ziyaret_sirasi": 1}
	]
	var secim := AksamSohbeti.konu_sec(kararlar, 1, {"es_meslegi": "ebe", "es_hayatta": true})
	if secim.is_empty():
		hatalar.append("Ağır kararlı gecede sohbet açılmadı!")
	elif secim.get("konu_id") != "aileyi_bolmek":
		hatalar.append("Ağır karar 'aileyi_bolmek' seçilmedi; seçilen: %s" % secim.get("konu_id"))

	# 2. Aynı kararla ertesi gece 0 kez açılır (aynı karar tekrar seçilmez)
	var ertesi_secim := AksamSohbeti.konu_sec(kararlar, 1, {"es_meslegi": "ebe", "es_hayatta": true})
	if not ertesi_secim.is_empty():
		hatalar.append("Aynı kararla ertesi gece sohbet açıldı! (Beklenen: 0)")

	# 3. Atlama barı değiştirmez
	var atlama_sonuc := AksamSohbeti.atla()
	if not atlama_sonuc.get("atlandi", false):
		hatalar.append("Atla çağrısı 'atlandi: true' döndürmedi!")
	if atlama_sonuc.get("moral_etkisi", 1) != 0:
		hatalar.append("Atlama çağrısı moral etkiledi! (Beklenen: 0)")

	# 4. Eş ölmüşken tetik 0'dır
	var olu_es_secim := AksamSohbeti.konu_sec([{"konu_id": "rusvet_almak", "ziyaret_sirasi": 2}], 2, {"es_oldu": true})
	if not olu_es_secim.is_empty():
		hatalar.append("Eş ölmüşken akşam sohbeti açıldı!")

	# 5. Meclis gecesinde sohbet 0'dır
	var meclis_secim := AksamSohbeti.konu_sec([{"konu_id": "rusvet_almak", "ziyaret_sirasi": 3}], 3, {"meclis_gecesi": true, "es_hayatta": true})
	if not meclis_secim.is_empty():
		hatalar.append("Meclis gecesinde akşam sohbeti açıldı!")

	# 6. Sohbet metni kalp anahtarı yazmaz ve yeni ses dosyası eklemez
	var veri := AksamSohbeti.veri_al()
	var json_str := JSON.stringify(veri)
	if "kalp" in json_str.to_lower() or "heart" in json_str.to_lower():
		hatalar.append("Sohbet metninde yasaklı kalp/romans anahtarı bulundu!")
	if ".ogg" in json_str.to_lower() or ".wav" in json_str.to_lower() or ".mp3" in json_str.to_lower():
		hatalar.append("Sohbet verisinde ses dosyası referansı bulundu!")

	# 7. Gerçek Oturum üzerinden ACL-03 tetik, tek-gece kilidi, atlama, ölü eş ve meclis engeli
	var katalog := Katalog.new()
	katalog.yukle()
	var oturum := Oturum.new(katalog, 9101)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(oturum)
	var es_id := int(preload("res://src/sistemler/acilis_senaryosu.gd").durum(oturum).get("es_id", -1))
	var es := oturum.yonetim.koylu(es_id)
	var es_once_moral := es.moral if es != null else 60
	oturum.aksam_sohbeti_ekle("aileyi_bolmek", 1)
	if not oturum.aksam_sohbeti_hazirla({"meclis_gecesi": false}).is_empty():
		hatalar.append("ACL-04 ilk aile kararı öncesi akşam sohbeti açılmamalı!")
	oturum.gun = 1
	var ilk := oturum.aksam_sohbeti_hazirla({"meclis_gecesi": false})
	if String(ilk.get("konu_id", "")) != "aileyi_bolmek":
		hatalar.append("Gerçek oturumda akşam sohbeti konusu seçilmedi!")
	var ikinci := oturum.aksam_sohbeti_hazirla({"meclis_gecesi": false})
	if not ikinci.is_empty():
		hatalar.append("Aynı gecede ikinci kez akşam sohbeti açılmamalı!")
	oturum.aksam_sohbeti_atla()
	if es != null and es.moral != es_once_moral:
		hatalar.append("Atlama gerçek eşin moralini değiştirmemeli!")
	oturum.gun += 1
	oturum.aksam_sohbeti_ekle("rusvet_almak", 2)
	if not oturum.aksam_sohbeti_hazirla({"meclis_gecesi": true}).is_empty():
		hatalar.append("Meclis gecesinde gerçek oturum akşam sohbeti açmamalı!")
	if es != null:
		es.saglik = 0
	if not oturum.aksam_sohbeti_hazirla({"meclis_gecesi": false}).is_empty():
		hatalar.append("Eş ölmüşken gerçek oturum akşam sohbeti açmamalı!")

	# 8. HAN-13: Misafir gecesi akşam sohbeti 3 katılımcılı açılır ve DIY-11 dalını Söz'den okur
	var o_misafir := Oturum.new(katalog, 9102)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(o_misafir)
	o_misafir.gun = 1
	o_misafir.yonetim.gun = 1
	KisiHafizasi.kaydet_olay(o_misafir.kadro, &"chr_004", {"karar": "kabul"}, 0)
	KisiHafizasi.kaydet_olay(o_misafir.kadro, &"chr_004", {"karar": "kabul"}, 1)
	o_misafir.yonetim.hane.misafir_al("chr_004", "normal")
	var misafir_sohbet := o_misafir.aksam_sohbeti_hazirla({"meclis_gecesi": false})
	var katilimcilar: Array = misafir_sohbet.get("katilimcilar", [])
	if katilimcilar.size() != 3 or not ("misafir" in katilimcilar) or String(misafir_sohbet.get("misafir_replik", "")).is_empty():
		hatalar.append("HAN-13: misafir gecesi akşam sohbeti 3 katılımcı ve misafir repliği vermeli!")

	# 9. HAN-34: Eş çınarda söz aldığında akşam sohbeti açılmaz
	var o_mcl := Oturum.new(katalog, 9103)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(o_mcl)
	o_mcl.gun = 2
	o_mcl.yonetim.gun = 2
	o_mcl.aksam_sohbeti_ekle("rusvet_almak", 1)
	o_mcl.set_meta(&"es_meclis_sozu_gecesi", 2)
	if not o_mcl.aksam_sohbeti_hazirla({}).is_empty():
		hatalar.append("HAN-34: eş çınarda söz aldıysa aynı gece akşam sohbeti açılmamalı!")
	if not AksamSohbeti.konu_sec([{"konu_id": "rusvet_almak", "ziyaret_sirasi": 1}], 3, {"es_meclis_sozu": true, "es_hayatta": true}).is_empty():
		hatalar.append("HAN-34: AksamSohbeti.konu_sec es_meclis_sozu=true iken boş dönmeli!")

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: aksam_sohbeti_test.gd")
	quit(0)
