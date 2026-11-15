## MEV-10: tek ağıl çevresindeki üç kutu kurt, mevcut A*; yalnız görsel yaklaşma/kaçış.
class_name KurtSurusu
extends Node3D
var halk: KoyHalkHareketi
var hedef_id := -1
var kurtlar: Array[Node3D] = []
var yol: Array[Vector3] = []
var adim := 0
var geri := false
## Tek düğüm; sıcak/gündüz/yıkılmış ağıl durumunda anında gizlenip kaldırılır.
static func yenile(h: KoyHalkHareketi) -> void:
	var s := h.get_node_or_null("KurtSurusu") as KurtSurusu
	var bs := KurtBaskini.agillar(h.sahne.yonetim)
	var aktif := h.faz_adi in [&"aksam", &"gece"] and not bs.is_empty()
	if not aktif:
		if s != null:
			s.visible = false
			h.remove_child(s)
			s.queue_free()
		return
	if s == null:
		s = KurtSurusu.new()
		s.name = "KurtSurusu"
		s.halk = h
		h.add_child(s)
		s._kur()
	s.hedef_id = bs[0].id
	s._rota(bs[0])
func _kur() -> void:
	for i in int(KurtBaskini.AYAR.surudeki_kurt):
		var n := Node3D.new()
		n.name = "kurt_kutu_%d" % i
		var m := MeshInstance3D.new()
		var kutu := BoxMesh.new()
		kutu.size = Vector3(0.35, 0.4, 0.8)
		m.mesh = kutu
		m.position.y = 0.2
		var mat := Dunya3B.duz_malzeme(Color(KurtBaskini.AYAR.renk))
		m.material_override = mat
		n.add_child(m)
		if Dunya3B.model_var_mi("kurt", "hayvan"):
			mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			mat.albedo_color = Color(0, 0, 0, 0)
			n.add_child(Dunya3B.nesne("kurt", 0.65, "hayvan"))
		add_child(n)
		kurtlar.append(n)
func _rota(b: KoyBinasi) -> void:
	yol.clear()
	adim = 0
	geri = false
	var y := halk.sahne.yonetim
	var son := halk.rotaci.bina_duragi(y.a.meydan.position, Rect2i(b.hucre, b.boyut(y.katalog)), 0)
	if son.x < 0:
		visible = false
		return
	var en := y.a.izgara_boyut - Vector2i.ONE
	for kenar in [Vector2i(son.x, 0), Vector2i(son.x, en.y), Vector2i(0, son.y), Vector2i(en.x, son.y)]:
		if not halk.rotaci.gecilir(kenar): continue
		var rota := halk.rotaci.yol(kenar, son)
		if rota.size() < 2: continue
		for c in rota: yol.append(halk._konum(c))
		break
	visible = not yol.is_empty()
	if visible:
		for n in kurtlar: n.position = yol[0]
func _process(delta: float) -> void:
	var b := halk.sahne.yonetim.bina(hedef_id)
	if b == null or not halk.sahne.yonetim.kis_mi():
		visible = false
		return
	if yol.is_empty() or adim >= yol.size(): return
	# Muhafız korumasında yolun ortasında uzaklaşır; gerçek gece sonucu ayrı tek API'dedir.
	if not geri and KurtBaskini.korunan(halk.sahne.yonetim, b) and adim >= maxi(1, yol.size() / 2):
		geri = true
		yol = yol.slice(0, adim + 1)
		yol.reverse()
		adim = 0
	var varildi := false
	for i in kurtlar.size():
		var n := kurtlar[i]
		var hedef := yol[maxi(0, adim - i * 2)]
		n.position = n.position.move_toward(hedef, maxf(0.0, delta) * float(KurtBaskini.AYAR.hiz))
		if i == 0: varildi = n.position.distance_to(hedef) <= 0.02
	if varildi: adim += 1
