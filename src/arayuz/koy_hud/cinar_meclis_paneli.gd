## HUD -> Node ördek tiplemesi: KoyEkrani/autoload statik bağımlılığı yok.
class_name CinarMeclisPaneli
extends RefCounted

static func _ekran(n: Node) -> Node:
	return AmbarKapisiPaneli._ekran(n)

static func hud(h: Node, y: KoyYonetimi, goster: bool = true) -> void:
	CinarAltiMeclisi.esitle(y)
	var ust: Node = h._huzur_bar.get_parent()
	if not goster:
		preload("res://src/arayuz/koy_hud/hud_katmani.gd").gecici_kaldir(ust, "cinar_meclisi")
		return
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
	var haftalik := MeclisSesi.haftalik_mi(y)
	var oy_bekliyor: bool = not d.oylama.is_empty() and d.oylama.karar == ""
	b.visible = CinarAltiMeclisi.haftalik_bekliyor(y) or oy_bekliyor
	if not haftalik: b.visible = b.visible or not CinarAltiMeclisi._krizler(y).is_empty() or not d.oylama.is_empty()
	if not haftalik and e != null: b.visible = b.visible or not SoylentiKoprusu.meclis_sikayeti(e.oturum).is_empty()
	b.disabled = e == null or AmbarKapisiPaneli._kilitli(e)
	b.tooltip_text = "Kriz başına bir meclis · 2 gün bekleme · yalnız toplu oy dağılımı"

static func yukleme(e: Node) -> void:
	var o: Dictionary = CinarAltiMeclisi.durum(e.oturum.yonetim).oylama
	if e._ust_kart != null: return
	if not o.is_empty() and o.karar == "":
		sonuc(e)
	else:
		haftalik_ac(e)

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

static func haftalik_ac(e: Node) -> bool:
	var y: KoyYonetimi = e.oturum.yonetim
	if not CinarAltiMeclisi.haftalik_bekliyor(y): return false
	if e._ust_kart != null: return true
	var gun := y.gun
	var v: VBoxContainer = e._kart_ac(e.tr("koy.meclis.haftalik.baslik"))
	_metin(e, v, MeclisSesi.dis_hat_konusu(e.oturum), "meclis_dis_hat_konusu")
	var b: Button = e._dugme(e.tr("koy.meclis.haftalik.kapat"), v)
	b.name = "meclis_haftalik_bitti"
	b.pressed.connect(func() -> void:
		if not CinarAltiMeclisi.haftalik_bitir(y, gun): return
		e._kart_kapat()
		e._yenile()
	)
	return true


static func ac(e: Node) -> void:
	var y: KoyYonetimi = e.oturum.yonetim
	CinarAltiMeclisi.esitle(y)
	if _bekliyor(e):
		sonuc(e)
		return
	if MeclisSesi.haftalik_mi(y):
		haftalik_ac(e)
		return
	var v: VBoxContainer = e._kart_ac("Çınar altı köy meclisi")
	_metin(e, v, "Meydan meclisi · Kriz başına bir oylama, arada 2 gün. Oylar temel ihtiyaç, moral, sadakat ve toplumsal bağa göre verilir. Kimlikler ve tekil oylar gösterilmez; karantinadakiler temsil yoluyla katılır.")
	var konusan := MeclisSesi.konusanlar(y)
	if not konusan.is_empty():
		_metin(e, v, GuvenliMetin.metin("koy.meclis.konusanlar") % ", ".join(konusan))
	elif MeclisSesi.kriz_var_mi(y):
		_metin(e, v, GuvenliMetin.metin("koy.meclis.konusan_yok"))
	var soylenti := SoylentiKoprusu.meclis_sikayeti(e.oturum)
	if not soylenti.is_empty(): SoylentiHukmu.ekle(e, v, soylenti)
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
	var dava_btn: Button = e._dugme("Köy davalarını dinle", v)
	dava_btn.name = "meclis_davasi_ac"
	dava_btn.pressed.connect(func() -> void: dava_ac(e))
	_don(e, v)


static func dava_ac(e: Node) -> Node:
	if e == null or e.get("oturum") == null:
		return null
	if e.has_method("_kart_kapat"):
		e._kart_kapat()
	var dy: KoyDiyalogYoneticisi = preload("res://src/diyalog/koy_diyalog_yoneticisi.gd").new()
	var panel: KoyDiyalogPaneli = preload("res://src/arayuz/koy_diyalog_paneli.gd").ac(e, dy)
	panel.name = "MeclisDavaPaneli"
	dy.diyalog_sonlandi.connect(func() -> void:
		if is_instance_valid(e) and e.get("oturum") != null:
			e.oturum._koy_esitle()
			if e.has_method("_yenile"):
				e._yenile()
	)
	if not dy.sekans_baslat("meclis_davalari", e.oturum.yonetim):
		if is_instance_valid(panel):
			panel.queue_free()
		return null
	return panel

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
