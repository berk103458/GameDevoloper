## Dekorlar ızgaranın dışında, tabanda ve birbirine değmeden durur.
extends Node

var hata := 0

func _ready() -> void:
	call_deferred("_calistir")

func _calistir() -> void:
	var beklenen := ToplulukDekoru._liste().size()
	var s := KoyYonetimSahnesi.new()
	s.yonetim = KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 28)
	var ust := Node3D.new()
	add_child(ust)
	OlayYapilari.kur(s, ust)
	ToplulukDekoru.kur(s, ust)
	var kok := ust.get_node_or_null(^"topluluk_dekoru")
	dene(kok != null and kok.get_child_count() == beklenen, "Her dekor bir kez kuruldu (%d/%d)" % [kok.get_child_count() if kok else 0, beklenen])
	var kutular: Array[AABB] = []
	var adlar: PackedStringArray = []
	if kok != null:
		for n in kok.get_children():
			var kutu := _dunya(n)
			kutular.append(kutu)
			adlar.append(n.name)
			dene(absf(kutu.position.y) < 0.06, "%s tabanı y=0 (%.3f)" % [n.name, kutu.position.y])
			dene(n.has_meta(&"topluluk_dosya"), "%s modeli yüklendi" % n.name)
			dene(_disarida(kutu), "%s yürüme ızgarasının dışında" % n.name)
			dene(not _kapi_yolu(kutu), "%s kapı yolunda değil" % n.name)
	for n in ust.get_children():
		if n.name == "topluluk_dekoru":
			continue
		var eski := _dunya(n)
		for i in kutular.size():
			if kutular[i].intersects(eski):
				dene(false, "%s mevcut %s ile çakışıyor" % [adlar[i], n.name])
	for i in kutular.size():
		for j in range(i + 1, kutular.size()):
			if kutular[i].intersects(kutular[j]):
				dene(false, "%s ile %s çakışıyor" % [adlar[i], adlar[j]])
	print("TOPLULUK DEKOR: GEÇTİ" if hata == 0 else "TOPLULUK DEKOR: KALDI")
	get_tree().quit(0 if hata == 0 else 1)

func _dunya(n: Node3D) -> AABB:
	return n.global_transform * Dunya3B._kutu(n)

func _disarida(k: AABB) -> bool:
	var ic := AABB(Vector3(-24.0, -0.2, -24.0), Vector3(48.0, 12.0, 48.0))
	return not ic.intersects(k)

func _kapi_yolu(k: AABB) -> bool:
	var yol := AABB(Vector3(-8.0, -0.2, 22.0), Vector3(16.0, 12.0, 30.0))
	return yol.intersects(k)

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
