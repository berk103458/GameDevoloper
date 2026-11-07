## Köylü kartının mevcut yüzeyi; gizli kuluçka bilgisi içermez.
class_name KarantinaPaneli
extends RefCounted
static func hud_guncelle(h: Node, y: KoyYonetimi, katman: RefCounted) -> void:
	var sayi := 0
	for k in y.koylular:
		if KarantinaYoneticisi.aktif(k): sayi += 1
	var ust: Node = h._nufus.get_parent()
	if not katman.acik("karantina_paneli.gd", "ana", sayi > 0):
		katman.gecici_kaldir(ust, "KarantinaSayisi")
		return
	var l := ust.get_node_or_null("KarantinaSayisi") as Label
	if l == null:
		l = h._etiket(ust, Tema.KUCUK_PX)
		l.name = "KarantinaSayisi"
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	l.text = TranslationServer.translate("koy.karantina.hud") % sayi

static func ekle(e: KoyEkrani, v: VBoxContainer, k: Koylu) -> void:
	var y := e.oturum.yonetim
	var bilgi := e._etiket(v, KarantinaYoneticisi.metin(y, k), Tema.KUCUK_PX)
	bilgi.name = "karantina_bilgisi"
	bilgi.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var cikis := KarantinaYoneticisi.aktif(k)
	var neden := "" if cikis else KarantinaYoneticisi.neden(y, k)
	var d := e._dugme("Karantinadan çıkar" if cikis else "Şüpheyle 2 gün karantinaya al", v)
	d.name = "karantina_dugmesi"
	d.disabled = y.son != &"" or not neden.is_empty()
	d.tooltip_text = "Erken çıkarma teması yeniden açar; giriş bedeli iade edilmez." if cikis else neden
	d.pressed.connect(func() -> void:
		var oldu := KarantinaYoneticisi.cikar(y, k.id) if cikis else KarantinaYoneticisi.al(y, k.id)
		if oldu:
			e.oturum._koy_esitle()
			e._yenile()
		KoyluKarti.ac(e, k.id))
