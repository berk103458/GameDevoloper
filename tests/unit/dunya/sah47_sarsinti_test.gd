## SAH-47 (Claude-Berk): kamera sarsıntısı yalnız kapı olayındadır.
## Gerçek oyun yolu: KapiEkrani._karar_ver("ret") → CAT-02 kavga paneli sarsıntısı (kapıda > 0 sn);
## ardından Ana._koye_git() ile gerçek KoyEkrani açılır, köy kamerası kare kare örneklenir (köyde 0 sn).
extends "res://tests/unit/kapi/kapi_kavgasi_ekran_test.gd"

const DT := 0.02
const ORNEK := 20


func _ekran() -> bool:
	var ana := TestAna.new()
	add_child(ana)
	ana.ayarlar.degerler[&"karar_onayi"] = false
	var e := KapiEkrani.new()
	e.oturum = ana.oturum
	e.ayarlar = ana.ayarlar
	ana._kapi = e
	ana._goster(e)
	await get_tree().process_frame
	var o := ana.oturum
	var k := o.yonetim.kabul({"ad": "nöbetçi", "sinif": "asker"})
	o.yonetim.muhafiz_ata(k.id)
	var g := Gelen.new()
	g.kavga_tip = "genc_erkek"
	g.ad_anahtari = "sablon.esnaf.ad1"
	g.secenekler = PackedStringArray(["ret", "kabul"])
	e._gelen = g
	e._kuyruk.clear()
	var kayit_ornek: Array = [e._kayit.position]
	e._karar_ver("ret")
	for i in ORNEK:
		await get_tree().create_timer(DT).timeout
		kayit_ornek.append(e._kayit.position)
	var kapi_sure := KameraSurukleme.sarsinti_suresi(kayit_ornek, DT)
	dene(e.evre == &"kavga", "Kapıda kavga paneli açıldı")
	dene(kapi_sure > 0.0, "SAH-47: kapı kavgasında sarsıntı var (%.2f sn)" % kapi_sure)
	dene(kayit_ornek.back() == kayit_ornek[0], "SAH-47: kapı sarsıntısı yerine döner")

	# Köy: aynı oturum, kavga kaydı açıkken gerçek köy ekranı.
	ana._koye_git()
	await get_tree().process_frame
	await get_tree().process_frame
	var koy := ana.find_children("*", "KoyEkrani", true, false)
	dene(koy.size() == 1, "Ana._koye_git köy ekranını açtı")
	if koy.size() != 1:
		ana.queue_free()
		return false
	var s: KoyYonetimSahnesi = (koy[0] as KoyEkrani).sahne3b
	s.halk_hareketi.set_process(false)
	var konum: Array = [s.kamera.global_position]
	var kayma: Array = [Vector2(s.kamera.h_offset, s.kamera.v_offset)]
	for i in ORNEK:
		await get_tree().create_timer(DT).timeout
		konum.append(s.kamera.global_position)
		kayma.append(Vector2(s.kamera.h_offset, s.kamera.v_offset))
	var koy_sure := KameraSurukleme.koyde_sarsinti_suresi(konum, DT) + KameraSurukleme.koyde_sarsinti_suresi(kayma, DT)
	dene(koy_sure == 0.0, "SAH-47: köyde sarsıntı süresi 0 (%.2f sn)" % koy_sure)
	ana.queue_free()
	await get_tree().process_frame
	return true


func dene(v: bool, metin: String) -> void:
	if not v:
		hata += 1
		push_error(metin)
	else:
		print("  ok: " + metin)
