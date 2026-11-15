# gdlint: disable=max-line-length
extends SceneTree

const CeliskiSinif := preload("res://src/soz/celiski.gd")
const SozMotoruSinif := preload("res://src/soz/soz_motoru.gd")
const BeyanDefteriPaneliSinif := preload("res://src/arayuz/kapi/beyan_defteri_paneli.gd")


func _init() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	var hatalar: Array[String] = []

	# 0. Dosya kontrolu: koy_sahnesi import edilmez.
	for yol in ["res://src/soz/celiski.gd", "res://src/arayuz/kapi/beyan_defteri_paneli.gd"]:
		var kod := FileAccess.get_file_as_string(yol)
		if kod.find("koy_sahnesi") >= 0:
			hatalar.append("koy_sahnesi baglantisi yasak: %s" % yol)

	# 1. Tek kayit varken Goster kilitlidir ve kendisiyle eslesmez.
	var tek := CeliskiSinif.new()
	tek.kayit_ekle({"id": "b_tek", "tur": "beyan", "metin": "Tek basima geldim", "kaynak": "Soru (00)"})
	if tek.goster_acik():
		hatalar.append("Tek kayitta Goster acik kaldi.")
	var ayni := tek.yuzles("b_tek", "b_tek")
	if bool(ayni.get("basarili", true)) or tek.yanlis_sayisi != 0:
		hatalar.append("Kayit kendisiyle eslesmemeli ve yanlis sayisini artirmamali.")

	# 2. SozMotoru + {a, b, dal, guc} + ayni ipucunun iki celiskide kullanilmasi + 3 yanlista Goster kapanisi.
	var dosya := {
		"konusmaci": "chr_005",
		"cekirdek": "koruma_yalani",
		"ipucu_id": "Clue_Ortak",
		"celiskiler": [
			{"a": "b1", "b": "Clue_Ortak", "dal": "yuzlesme", "guc": "guclu"},
			{"a": "b2", "b": "Clue_Ortak", "dal": "zayif_dal", "guc": "zayif"},
		],
		"dugumler": {
			"giris": {
				"id": "giris",
				"satir": "Selam, uc gundur yoldayim.",
				"beyan": {"id": "b1", "metin": "Uc gundur yoldayim", "dogru": false},
				"secenekler": []
			},
			"yuzlesme": {
				"id": "yuzlesme",
				"satir": "Dogru, dun aksam han kapisi onundeydim!",
				"secenekler": []
			},
			"zayif_dal": {
				"id": "zayif_dal",
				"satir": "Sesini biraz kis muhafiz...",
				"secenekler": []
			}
		}
	}
	var motor := SozMotoruSinif.new()
	var y_ok := motor.yukle(dosya)
	if y_ok.is_empty():
		hatalar.append("SozMotoru test diyalogu yuklenemedi.")
	var c := motor.celiski() as CeliskiSinif
	c.kayit_ekle({"id": "b2", "tur": "beyan", "metin": "Hic koye ugramadim", "kaynak": "Soru (1.1)"})
	c.kayit_ekle({"id": "b3", "tur": "beyan", "metin": "Yanima azik almadim", "kaynak": "Soru (1.2)"})
	c.kayit_ekle({"id": "b4", "tur": "beyan", "metin": "Atim topal degildi", "kaynak": "Soru (1.3)"})
	c.kayit_ekle({"id": "Clue_Ortak", "tur": "ipucu", "metin": "Taze han muhru", "kaynak": "Bakış (Eller)"})
	c.kayit_ekle({"id": "Clue_Baska", "tur": "ipucu", "metin": "Camurlu carik", "kaynak": "Bakış (Ayak)"})

	# Dogru cift (sira ters: Clue_Ortak, b1) -> guclu dogrudan dala gecer.
	var bas_dogru := c.yuzles("Clue_Ortak", "b1", {"motor": motor})
	if not bool(bas_dogru.get("basarili", false)) or String(bas_dogru.get("dal", "")) != "yuzlesme":
		hatalar.append("Ters sirali celiski cifti yuzlesme dalina gecmedi: %s" % str(bas_dogru))
	if motor.mevcut_satir() != "Dogru, dun aksam han kapisi onundeydim!":
		hatalar.append("SozMotoru aktif satiri guncellenmedi: %s" % motor.mevcut_satir())
	# Cozulen cift tekrar acilamaz.
	var tekrar_coz := c.yuzles("b1", "Clue_Ortak", {"motor": motor})
	if bool(tekrar_coz.get("basarili", true)) or String(tekrar_coz.get("sebep", "")) != "zaten_cozuldu":
		hatalar.append("Cozulen celiski yeniden gosterildi.")
	# Ortak ipucu b2 ile ikinci celiskide yer alabilir; guc=zayif kanit_degistirici=-1 doner.
	var ikinci := c.yuzles("b2", "Clue_Ortak", {"motor": motor})
	if not bool(ikinci.get("basarili", false)) or not bool(ikinci.get("zayif_zar", false)) or int(ikinci.get("kanit_degistirici", 0)) != -1:
		hatalar.append("Zayif celiskide zayif_zar/-1 calismadi: %s" % str(ikinci))

	# Yanlis cift: guven -2, sabir -1, tansiyon +1; ayni yanlis cift tekrar denenemez; 3 yanlista kapanir.
	motor.guven = 8
	motor.sabir = 5
	var yanlis1 := c.yuzles("b3", "Clue_Baska", {"motor": motor})
	if bool(yanlis1.get("basarili", true)) or motor.guven != 6 or motor.sabir != 4 or c.tansiyon != 1:
		hatalar.append("Birinci yanlista guven/sabir/tansiyon beklenenden sapdi: g=%d s=%d t=%d" % [motor.guven, motor.sabir, c.tansiyon])
	var ayni_yanlis := c.yuzles("Clue_Baska", "b3", {"motor": motor})
	if String(ayni_yanlis.get("sebep", "")) != "tekrar_deneme" or c.yanlis_sayisi != 1:
		hatalar.append("Ayni yanlis cift ikinci kez sayildi: %s" % str(ayni_yanlis))
	c.yuzles("b4", "Clue_Baska", {"motor": motor})
	var yanlis3 := c.yuzles("b3", "b4", {"motor": motor})
	if not bool(yanlis3.get("goster_kapali", false)) or c.goster_acik(motor):
		hatalar.append("3 yanlistan sonra Goster kapanmadi.")

	# 3. ChrSorgusu + BeyanDefteriPaneli (KapiEkrani UI sahne kontrolu ayri celiski_goster_kontrol.tscn icindedir).
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 84)
	o.gun = 4
	var g := o._adli_gelen(&"chr_001")
	g.heybe = Heybe.new()
	var sorgu := g.chr_sorgusu()
	if sorgu == null:
		hatalar.append("chr_001 ChrSorgusu yuklenemedi.")
	else:
		if CeliskiSinif.yardim_acik_mi(o):
			hatalar.append("Gun 4 iken Celiski.yardim_acik_mi false olmali.")
		sorgu.gorsel_incele()
		var bpanel := BeyanDefteriPaneliSinif.new()
		bpanel.kur({
			"celiski": sorgu.celiski_durumu,
			"defter": sorgu.beyan_defteri,
			"sorgu": sorgu,
			"oturum": o,
		})
		root.add_child(bpanel)
		await process_frame
		var ip_id := String(sorgu.karakter.gorsel_hata_ipucu)
		bpanel.kayit_sec_kimlikle("beyan_00")
		bpanel.kayit_sec_kimlikle(ip_id)
		var ui_sonuc := bpanel.goster_bas()
		await process_frame
		if not bool(ui_sonuc.get("basarili", false)) or sorgu.dugum_id != &"3.1":
			hatalar.append("UI Goster ile chr_001 3.1 yuzlesme dalina gecemedi: %s dugum=%s" % [str(ui_sonuc), String(sorgu.dugum_id)])
		var beyan_btn := bpanel.get_node_or_null("KayitListesi/Kayit_beyan_00") as Button
		if beyan_btn != null and not beyan_btn.disabled:
			hatalar.append("Cozulen beyan satiri panelde kilitlenmedi.")
		bpanel.queue_free()
		await process_frame

	if not hatalar.is_empty():
		for h in hatalar:
			push_error(h)
		quit(1)
		return
	print("TEST PASS: celiski_goster_test.gd")
	quit(0)
