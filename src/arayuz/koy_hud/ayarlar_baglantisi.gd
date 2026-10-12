## AYR-06: ayarlar oyun içinden ve menüden aynı `AyarlarEkrani` ekranıdır.
## Mevcut köy eylem sütununu genişletir; harita/oda kalıbıyla köy hızı açılışta saklanır,
## kapanışta geri gelir. İkinci bir ayar ekranı yazılmaz, çekirdek dosya değişmez.
class_name AyarlarBaglantisi
extends RefCounted


## Köy eylem sütununa tek "Ayarlar" düğmesi ekler; düğme aynı ekranı açar.
static func kur(e: KoyEkrani, v: Container) -> void:
	if not v.find_children("ayarlar_ac", "Button", true, false).is_empty():
		return
	# Divan/Oda/Harita satırına girer (harita_baglantisi kalıbı); sütunun altına yeni satır açmaz,
	# yoksa ekranın alt kenarından taşar (Claude oyunda gördü).
	var oda := v.find_children("oda_ac", "Button", true, false)
	var hedef: Node = oda[0].get_parent() if not oda.is_empty() else v
	var b := Button.new()
	b.name = "ayarlar_ac"
	b.text = String(TranslationServer.translate("arayuz.menu.ayarlar"))
	b.custom_minimum_size.y = 42
	hedef.add_child(b)
	b.pressed.connect(func() -> void: ac(e))


## Ayarlar ekranını köyün üzerine açar; kapanışta yalnız önceki hız geri gelir.
## Gece kilidi, açık üst kart ya da bitmiş oturumda açılmaz; ikinci örnek yaratılmaz.
static func ac(e: KoyEkrani) -> AyarlarEkrani:
	if e._gece_kilidi.kilitli() or e._ust_kart != null or e.oturum.yonetim.son != "" or e.has_node("AyarlarEkrani"):
		return null
	var hiz := 0 if e.get_tree().paused else int(Engine.time_scale)
	e._hiz_sec(0)
	var a := AyarlarEkrani.new()
	a.name = "AyarlarEkrani"
	a.ayarlar = e.ayarlar
	e.add_child(a)
	a.process_mode = Node.PROCESS_MODE_ALWAYS
	a.kapandi.connect(a.queue_free)
	a.tree_exiting.connect(func() -> void:
		if is_instance_valid(e) and e.is_inside_tree() and not e.is_queued_for_deletion():
			e._hiz_sec(hiz)
			if e.hud != null:
				e.hud.guncelle()
	)
	return a
