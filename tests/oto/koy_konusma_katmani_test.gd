## SAH-26: Gerçek tarla rotasında köy repliği üst gövdeyi değiştirir.
extends Node

class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_koy_konusma.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 76)
		kayit = GuvenliKayit.new("user://test_koy_konusma.json")
		theme = Tema.olustur(ayarlar)


class PozOlcer extends SkeletonModifier3D:
	var kol_no: int
	var bacak_no: int
	var kol := Quaternion.IDENTITY
	var bacak := Quaternion.IDENTITY

	func _process_modification_with_delta(_delta: float) -> void:
		var iskelet := get_skeleton()
		kol = iskelet.get_bone_pose_rotation(kol_no)
		bacak = iskelet.get_bone_pose_rotation(bacak_no)


func _ready() -> void:
	_calistir.call_deferred()


func _calistir() -> void:
	var ana := TestAna.new()
	add_child(ana)
	var y := ana.oturum.yonetim
	var k := y.kabul({"ad": "Ali", "sinif": "ciftci", "adli_id": "chr_002"})
	var tarla := KoyBinasi.new()
	tarla.id = 700
	tarla.tur = "tarla"
	tarla.hucre = y.a.meydan.end + Vector2i(2, 0)
	y.binalar.append(tarla)
	y.izgara.yerlestir(tarla.id, tarla.hucreler(y.katalog))
	k.is_yeri = tarla.id
	ana._koye_git()
	await get_tree().process_frame
	var ekran := ana._ekran as KoyEkrani
	var h := ekran.sahne3b.halk_hareketi
	h.set_process(false)
	h._durum[k.id].sulama_i = 1
	h._iste(k.id)
	for i in 3:
		h._process(0.0)
	var f: KarakterModel = h.modeller[k.id]
	var d: Dictionary = h._durum[k.id]
	var hazir: bool = d.is and d.get("tarla_hedef", false) and f.hareket_bandi() == "yuru" and f.hareket_var("konus")
	print("SAH-26 tarla rotası=%s, hareket=%s, konuşma klibi=%s" % [d.get("tarla_hedef", false), f.hareket_bandi(), f.hareket_var("konus")])
	var gecti := await _konusmayi_dene(ekran, k, f) if hazir else false
	ana.kayit.sil()
	ana.queue_free()
	await get_tree().process_frame
	print("KÖY KONUŞMA KATMANI: GEÇTİ" if gecti else "KÖY KONUŞMA KATMANI: KALDI")
	await Ses.cik(0 if gecti else 1)


func _konusmayi_dene(ekran: KoyEkrani, k: Koylu, f: KarakterModel) -> bool:
	var iskelet := f.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var kol := iskelet.find_bone("RightArm")
	var bacak := iskelet.find_bone("RightUpLeg")
	if kol < 0 or bacak < 0:
		return false
	KoyluKarti.ac(ekran, k.id)
	var dugme: Button
	for aday in ekran._ust_kart.find_children("*", "Button", true, false):
		if aday.text == "Muhabbet Et (Konuş)":
			dugme = aday
			break
	if dugme == null:
		return false
	var bas := f.position
	var yuru := f._oynatici.current_animation
	dugme.pressed.emit()
	var katman := iskelet.get_node_or_null("KoyKonusmaKatmani") as SkeletonModifier3D
	if katman == null:
		return false
	var onceki := PozOlcer.new()
	var sonraki := PozOlcer.new()
	for olcer in [onceki, sonraki]:
		olcer.kol_no = kol
		olcer.bacak_no = bacak
		iskelet.add_child(olcer)
	iskelet.move_child(onceki, katman.get_index())
	var ornek := {"kol_farki": 0.0, "bacak_farki": 0.0, "kare": 0}
	sonraki.modification_processed.connect(func() -> void:
		ornek.kare += 1
		ornek.kol_farki = maxf(ornek.kol_farki, sonraki.kol.angle_to(onceki.kol))
		ornek.bacak_farki = maxf(ornek.bacak_farki, sonraki.bacak.angle_to(onceki.bacak))
	)
	var klip_ayni := true
	for i in 40:
		await get_tree().process_frame
		klip_ayni = klip_ayni and f._oynatici.current_animation == yuru and f.hareket_bandi() == "yuru"
	var gecti := katman.active and katman.influence >= 0.99 and klip_ayni and f.position.distance_to(bas) > 0.1
	gecti = gecti and ornek.kare >= 30 and ornek.kol_farki > 0.05 and ornek.bacak_farki < 0.003
	print("SAH-26 kare=%d, kol farkı=%.5f rad, bacak farkı=%.5f rad, kök=%.4f m, klip=%s" % [
		ornek.kare, ornek.kol_farki, ornek.bacak_farki, f.position.distance_to(bas), yuru])
	var yonetici := KoyDiyalogYoneticisi.aktif_yonetici
	if yonetici == null:
		return false
	yonetici.replik_geldi.emit("Muhafız", "Tarlada iş nasıl gidiyor?", [])
	var muhafiz_sirasi := not katman.active
	var durum: Dictionary = ekran.sahne3b.halk_hareketi._durum[k.id]
	durum.is = false
	yonetici.replik_geldi.emit("Köylü", "İyi gidiyor, muhafız ağa.", [])
	var issiz_yuruyus := not katman.active
	durum.is = true
	yonetici.replik_geldi.emit("Köylü", "İyi gidiyor, muhafız ağa.", [])
	var koylu_sirasi := katman.active
	yonetici.bitir()
	return gecti and muhafiz_sirasi and issiz_yuruyus and koylu_sirasi and not katman.active
