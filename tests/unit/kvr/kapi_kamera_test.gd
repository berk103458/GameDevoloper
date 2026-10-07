extends SceneTree
var hata := 0
var _iptal_bitti := false
func _initialize() -> void:
	call_deferred("_calistir")
func _calistir() -> void:
	var sahne := KapiSahnesi.new()
	root.add_child(sahne)
	_uzun_bakis(sahne)
	await create_timer(0.1).timeout
	await sahne.daralt(false)
	await create_timer(0.7).timeout
	_kontrol(is_equal_approx(sahne.kamera.fov, 46.0), "Karar dönüşünden sonra eski kuyruk tweeni 28 dereceye kaydırmaz")
	_kontrol(_iptal_bitti, "İptal edilen kuyruk await'i askıda kalmaz")
	_kontrol(sahne._bakis.is_equal_approx(KapiSahnesi.BAKIS_KAPI), "Son hedef kapı bakışıdır")
	await sahne.kuyruga_bak(true)
	_kontrol(is_equal_approx(sahne.kamera.fov, 28.0), "Kuyruk yakınlaşması korunur")
	sahne.daralt(true)
	await create_timer(0.1).timeout
	await sahne.kuyruga_bak(false)
	await create_timer(0.3).timeout
	_kontrol(is_equal_approx(sahne.kamera.fov, 46.0), "Yeni kuyruk dönüşü eski karar adımlarını iptal eder")
	await sahne.daralt(true)
	_kontrol(is_equal_approx(sahne.kamera.fov, 37.0), "Karar yakın planı korunur")
	await sahne.daralt(false)
	_kontrol(is_equal_approx(sahne.kamera.fov, 46.0), "Karar sonrası FOV tam tabana döner")
	sahne.kuyruga_bak(true)
	await process_frame
	sahne.free()
	await create_timer(0.7).timeout
	print("KAPI KAMERA: GEÇTİ" if hata == 0 else "KAPI KAMERA: KALDI")
	quit(hata)
func _uzun_bakis(s: KapiSahnesi) -> void:
	await s.kuyruga_bak(true)
	_iptal_bitti = true
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
