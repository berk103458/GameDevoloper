## Mevcut bina bilgi alanı ve pazardaki mevcut su hizmetine ince ek.
class_name KuyuKireclemePaneli
extends RefCounted
const MEYDAN_KUYUSU := -3

static func ekle(e: KoyEkrani, v: Control, bina_id: int = -1, pazar: bool = false) -> void:
	var y := e.oturum.yonetim
	if not KuyuKirliligi.kuyu_bilgisi(y, bina_id): return
	var l := Label.new()
	l.name = "kuyu_kirliligi_bilgisi"
	l.text = KuyuKirliligi.metin(y)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(l)
	var b := Button.new()
	b.name = "kuyu_kirecle"
	b.text = "Kuyuyu dezenfekte et · %d kireç" % KuyuKirliligi.KIREC
	b.tooltip_text = KuyuKirliligi.neden(y, bina_id)
	b.disabled = not b.tooltip_text.is_empty()
	v.add_child(b)
	b.pressed.connect(func() -> void:
		if not KuyuKirliligi.kirecle(y, bina_id): return
		e._yenile()
		if pazar: e._pazar_ac()
	)

## Dekoratif meydan kuyusunun gerçek hücresi; hayalet bina kaydı yaratmaz.
static func hucre(e: KoyEkrani) -> Vector2i:
	var m := e.oturum.yonetim.a.meydan
	var ofset := Vector2(float(SulamaRutini.AYAR.kuyu_ofset[0]), float(SulamaRutini.AYAR.kuyu_ofset[1])) / KoyYonetimSahnesi.HUCRE
	var h := Vector2(m.position) + Vector2(m.size) / 2.0 + ofset
	return Vector2i(floori(h.x), floori(h.y))

static func bilgi(e: KoyEkrani) -> void:
	e._bilgi.visible = true
	e._etiket(e._bilgi_icerik, "Meydan su kuyusu", Tema.BASLIK_PX)
	ekle(e, e._bilgi_icerik)
