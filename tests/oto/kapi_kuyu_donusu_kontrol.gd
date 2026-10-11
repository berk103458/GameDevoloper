## BUG-25: gerçek köy kuyusu, mevcut kapı çerçevesi ve renderer görüntüsü.
extends Node
var hata := 0
func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 25)
	var y := o.yonetim
	y.kabul({"sinif": "ciftci", "ad": "Ölçüm köylüsü"})
	var once := JSON.stringify(y.kaydet())
	var s := KoyYonetimSahnesi.new()
	s.yonetim = y
	add_child(s)
	s.set_process(false)
	s.halk_hareketi.set_process(false)
	await get_tree().process_frame
	var kuyu := s._yapilar.get_node("kuyu") as Node3D
	var beklenen := SulamaRutini.kuyu_konumu(s)
	kontrol(kuyu.position.is_equal_approx(beklenen), "Sulama hedefi ve kuyu merkezi korunur")
	var k: KarakterModel = s.halk_hareketi.modeller.values()[0]
	k.position = kuyu.position + Vector3(-1.1, 0, 0)
	k.yurumeyi_durdur()
	var sk := k.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var bas := sk.global_transform * sk.get_bone_global_rest(sk.find_bone("Head")).origin
	var kutu := kuyu.global_transform * Dunya3B._kutu(kuyu)
	print("Gerçek sahne kuyu taban/tepe: ", kutu.position.y, " / ", kutu.end.y, "; köylü başı: ", bas.y)
	kontrol(is_zero_approx(kutu.position.y) and kutu.end.y < bas.y, "Gerçek kuyunun tabanı zemin, tepesi köylü başının altında")
	s.kamera.position = kuyu.position + Vector3(3, 2.7, 4)
	s.kamera.look_at(kuyu.position + Vector3(0, 0.7, 0))
	s.kamera.make_current()
	await fotograf("bug25_kuyu.png")
	kontrol(JSON.stringify(y.kaydet()) == once, "Görsel düzeltme su/ekonomi/kayıt/RNG değiştirmez")
	s.queue_free()
	await get_tree().process_frame
	var dunya := Node3D.new()
	add_child(dunya)
	Dunya3B.ortam_kur(dunya)
	Dunya3B.zemin_kur(dunya)
	var c := KapiCercevesi.new()
	dunya.add_child(c)
	var kamera := Camera3D.new()
	dunya.add_child(kamera)
	kamera.position = Vector3(0, 2.1, 3.6)
	kamera.look_at(Vector3(0, 1.9, -1.2))
	kamera.make_current()
	for l in c.isiklar:
		var a: Node3D = l.get_meta("alev")
		kontrol(l.global_position.is_equal_approx(a.global_position), "Görünür kapıda iki alev/ışık farkı sıfır")
	await fotograf("bug25_kapi.png")
	dunya.queue_free()
	await get_tree().process_frame
	print("KAPI KUYU SAHNE: GEÇTİ" if hata == 0 else "KAPI KUYU SAHNE: KALDI")
	await Ses.cik(hata)
func fotograf(ad: String) -> void:
	var dizin := OS.get_environment("ADMIN_TEST_CIKTI")
	if dizin.is_empty() or DisplayServer.get_name() == "headless": return
	await get_tree().create_timer(0.5).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(dizin.path_join(ad))
func kontrol(ok: bool, ad: String) -> void:
	if not ok:
		hata += 1
		push_error(ad)
