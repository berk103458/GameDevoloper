## SAH-53: Kuruluş eşi ilk aileyi mevcut kapı kamerasının yanında karşılar.
extends RefCounted

const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const KAPI_ACILISI = preload("res://src/sistemler/kapi_acilis_olayi.gd")
const GORUNUM = preload("res://src/koy/gorsel/acilis_hane_gorunumu.gd")
const KONUM := Vector3(-0.75, 0.0, -1.9)


static func kur(ekran: KapiEkrani) -> void:
	var o := ekran.oturum
	var sahne := ekran.sahne
	if not KAPI_ACILISI.aile_bekliyor(o) or sahne.has_node("IlkAileEs"):
		return
	var es_id := int(ACILIS.durum(o).get("es_id", -1))
	var es := o.yonetim.koylu(es_id)
	if es == null or es.saglik <= 0 or not es.bayrak_var(ACILIS.ES):
		return
	var model := Dunya3B.karakter(HazirKarakterler.koy_adi(es, Dunya3B.karakter_adi(es.adli_id, es.portre, es.sinif)))
	model.name = "IlkAileEs"
	model.position = KONUM + Vector3.UP * KapiManzarasi.yukseklik(KONUM.x, KONUM.z)
	sahne.add_child(model)
	GORUNUM.kur(model, es)
	var etiket := model.get_node_or_null("acilis_hane_etiketi") as Label3D
	if etiket != null:
		etiket.pixel_size = 0.0025
		etiket.position.y = 1.92
		EtiketEkranSiniri.bagla(etiket, sahne.kamera)
	model.bak(sahne.kamera.position)
	ekran.gece_bitti.connect(func(_rapor: Dictionary) -> void:
		if is_instance_valid(model):
			model.queue_free()
	, CONNECT_ONE_SHOT)
