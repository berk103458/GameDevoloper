## HUD -> Node ördek tiplemesi: KoyEkrani/autoload statik bağımlılığı yok.
class_name CinarMeclisPaneli
extends RefCounted

static func _ekran(n: Node) -> Node:
	return AmbarKapisiPaneli._ekran(n)

static func hud(h: Node, y: KoyYonetimi) -> void:
	CinarAltiMeclisi.esitle(y)
	var ust: Node = h._huzur_bar.get_parent()
	var b := ust.get_node_or_null("cinar_meclisi") as Button
	if b == null:
		b = Button.new()
		b.name = "cinar_meclisi"
		b.text = "Çınar altı meclisi"
		ust.add_child(b)
		b.pressed.connect(func() -> void:
			var e := _ekran(h)
			if e == null or AmbarKapisiPaneli._kilitli(e): return
			ac(e)
		)
	var e := _ekran(h)
	var d := CinarAltiMeclisi.durum(y)
	b.visible = not CinarAltiMeclisi._krizler(y).is_empty() or not d.oylama.is_empty()
	b.disabled = e == null or AmbarKapisiPaneli._kilitli(e)
	b.tooltip_text = "Kriz başına bir meclis · 2 gün bekleme · yalnız toplu oy dağılımı"

static func yukleme(e: Node) -> void:
	var o: Dictionary = CinarAltiMeclisi.durum(e.oturum.yonetim).oylama
	if e._ust_kart == null and not o.is_empty() and o.karar == "": sonuc(e)

static func _metin(e: Node, v: Control, metin: String, ad: String = "") -> Label:
	var l: Label = e._etiket(v, metin, Tema.KUCUK_PX)
	if not ad.is_empty(): l.name = ad
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = 680
	return l

static func _don(e: Node, v: Control) -> void:
	var b: Button = e._dugme("Köye dön", v)
	b.name = "meclis_don"
	b.pressed.connect(func() -> void:
		e._kart_kapat()
		e._gece_dugmesi.disabled = CenazeYasi.bekliyor(e.oturum.yonetim) or _bekliyor(e)
		e._yenile()
	)

static func _bekliyor(e: Node) -> bool:
	var o: Dictionary = CinarAltiMeclisi.durum(e.oturum.yonetim).oylama
	return not o.is_empty() and o.karar == ""

static func ac(e: Node) -> void:
	var y: KoyYonetimi = e.oturum.yonetim
	CinarAltiMeclisi.esitle(y)
	if _bekliyor(e):
		sonuc(e)
		return
	var v: VBoxContainer = e._kart_ac("Çınar altı köy meclisi")
	_metin(e, v, "Meydan meclisi · Kriz başına bir oylama, arada 2 gün. Oylar temel ihtiyaç, moral, sadakat ve toplumsal bağa göre verilir. Kimlikler ve tekil oylar gösterilmez; karantinadakiler temsil yoluyla katılır.")
	var konusan := MeclisSesi.konusanlar(y)
	if not konusan.is_empty():
		_metin(e, v, GuvenliMetin.metin("koy.meclis.konusanlar") % ", ".join(konusan))
	elif MeclisSesi.kriz_var_mi(y):
		_metin(e, v, GuvenliMetin.metin("koy.meclis.konusan_yok"))
	var krizler := CinarAltiMeclisi._krizler(y)
	for tur in CinarAltiMeclisi.TUR:
		if not krizler.has(tur): continue
		var secimler := PackedStringArray()
		for s in CinarAltiMeclisi.secenekler(y, tur):
			var neden := CinarAltiMeclisi.islem_nedeni(y, s)
			secimler.append(CinarAltiMeclisi.SECENEK[s] + " · " + CinarAltiMeclisi.bedel_metni(y, s) + (" · " + neden if not neden.is_empty() else ""))
		_metin(e, v, CinarAltiMeclisi.AD[tur] + "\n" + "\n".join(secimler))
		var b: Button = e._dugme(CinarAltiMeclisi.AD[tur] + " için meclisi topla", v)
		b.name = "meclis_topla_" + tur
		b.tooltip_text = CinarAltiMeclisi.toplanma_nedeni(y, tur)
		b.disabled = not b.tooltip_text.is_empty()
		b.pressed.connect(func() -> void:
			if CinarAltiMeclisi.topla(y, tur):
				e.oturum._koy_esitle()
				sonuc(e)
		)
	if krizler.is_empty(): _metin(e, v, "Meclis çağrısı için aktif kriz yok.")
	var o: Dictionary = CinarAltiMeclisi.durum(y).oylama
	if not o.is_empty(): _metin(e, v, "Son meclis\n" + CinarAltiMeclisi.ozet(o) + "\n" + _karar_metni(o))
	_don(e, v)

static func _karar_metni(o: Dictionary) -> String:
	return {"": "Karar bekliyor", "uygulandi": "Halkın kararı uygulandı · sadakat +4, moral +3", "reddedildi": "Muhafız kararıyla reddedildi · adalet −5, sadakat −6", "suresi_doldu": "Kriz değişti veya 2 günlük karar süresi doldu · ek etki yok"}.get(o.karar, "")

static func sonuc(e: Node) -> void:
	var y: KoyYonetimi = e.oturum.yonetim
	CinarAltiMeclisi.esitle(y)
	var o: Dictionary = CinarAltiMeclisi.durum(y).oylama
	if o.is_empty(): return
	var v: VBoxContainer = e._kart_ac("Çınar altı meclisi · oy sonucu")
	_metin(e, v, CinarAltiMeclisi.ozet(o), "meclis_dagilim")
	if o.karar == "": _metin(e, v, "Uygulama bedeli: " + CinarAltiMeclisi.bedel_metni(y, o.secenekler[o.kazanan]))
	_metin(e, v, "Eşit puanda seçmenin ilk seçeneği; eşit toplam oyda listedeki ilk seçenek kazanır. Bedel karar anında yeniden kontrol edilir. Meclis kararı en fazla 2 gün bekler.")
	_metin(e, v, _karar_metni(o), "meclis_karar")
	if o.karar == "":
		e._gece_dugmesi.disabled = true
		for uygula in [true, false]:
			var b: Button = e._dugme("Halkın kararını uygula" if uygula else "Muhafız kararıyla reddet", v)
			b.name = "meclis_uygula" if uygula else "meclis_ret"
			b.tooltip_text = CinarAltiMeclisi.karar_nedeni(y, int(o.gun), o.tur, int(o.sira), uygula)
			b.disabled = not b.tooltip_text.is_empty()
			b.pressed.connect(func() -> void:
				if CinarAltiMeclisi.karar(y, int(o.gun), o.tur, int(o.sira), uygula):
					e.oturum._koy_esitle()
					e._yenile()
				sonuc(e)
			)
	_don(e, v)
