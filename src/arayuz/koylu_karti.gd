## Köylü kartı mevcut ekran kartına eklenir; köyün gerçek iş API'leri kullanılır.
class_name KoyluKarti
extends RefCounted

const KoyDiyalogYoneticisi = preload("res://src/diyalog/koy_diyalog_yoneticisi.gd")
const KoyDiyalogPaneli = preload("res://src/arayuz/koy_diyalog_paneli.gd")

static func ac(ekran: KoyEkrani, id: int) -> void:
	var k := ekran.oturum.yonetim.koylu(id)
	if k == null: return
	KoyluTakibi.sec(ekran.sahne3b, id)
	var y := ekran.oturum.yonetim
	var v := ekran._kart_ac(k.ad + " · Köylü kartı")
	var guvenlik := ekran._etiket(v, SavunmaGuvenligi.metin(y), Tema.KUCUK_PX)
	guvenlik.name = "guvenlik_satiri"
	guvenlik.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ekran._ust_kart.set_meta("gecici_is_sekmesi",true)
	ekran._ust_kart.z_index = 110
	var kulp := KoyluSuruklemeKulpu.new()
	kulp.ekran = ekran
	kulp.kisi = id
	kulp.text = TranslationServer.translate("koy.gecici_is.kulp")
	preload("res://src/arayuz/koy_hud/ilk_atama_vurgusu.gd").uygula(kulp, y, k)
	v.add_child(kulp)
	var kaydir := ScrollContainer.new()
	kaydir.custom_minimum_size = Vector2(minf(760, ekran.size.x - 100), minf(440, ekran.size.y - 210))
	kaydir.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	v.add_child(kaydir)
	var sekmeler := TabContainer.new()
	sekmeler.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	kaydir.add_child(sekmeler)
	var ic := VBoxContainer.new()
	ic.name = TranslationServer.translate("koy.gecici_is.yapi_sekmesi")
	ic.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sekmeler.add_child(ic)
	var bilgi := ekran._etiket(ic, KoyluKartiVerisi.ozet(y, k), Tema.KUCUK_PX)
	bilgi.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ekran._etiket(ic, KoyluKartiVerisi.soz_guvenilirligi(ekran.oturum, k), Tema.KUCUK_PX).name = "soz_guvenilirligi"
	ekran._etiket(ic, KoyluGelisimYoneticisi.metin(k), Tema.KUCUK_PX).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ekran._etiket(ic, KisHastaligi.metin(k, y), Tema.KUCUK_PX).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var salgin := SaglikYoneticisi.metin(k, y)
	if not salgin.is_empty(): ekran._etiket(ic, salgin, Tema.KUCUK_PX).name = "salgin_bilgisi"
	KarantinaPaneli.ekle(ekran, ic, k)
	HekimIlacBilgisi.ekle(y, ic)
	ekran._etiket(ic, ZanaatKazalari.metin(k), Tema.KUCUK_PX).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ekran._etiket(ic, MeslekGrevi.metin(k, y), Tema.KUCUK_PX).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ekran._etiket(ic, NobetYorgunlugu.metin(k, y), Tema.KUCUK_PX).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	YasamBarlariPaneli.ekle(y, ic, k)
	var uygun := ekran._etiket(ic, "En uygun yapılar: " + KoyluKartiVerisi.uygun_turler(k), Tema.KUCUK_PX)
	uygun.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ekran._etiket(ic, "Mevcut görev: " + ekran._is_adi(k), Tema.KUCUK_PX)
	ekran._etiket(ic, "İş seçenekleri · çarpan meslek uyumudur; net üretim stok ve koşullara bağlıdır.", Tema.KUCUK_PX).autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	for s in KoyluKartiVerisi.secenekler(y, k):
		var d := ekran._dugme("#%d %s · %s%s" % [s.id, s.ad, "Danışman" if s.danisman else "Uyum ×%.2f" % s.uyum, " · " + s.neden if not s.neden.is_empty() else (" · Grev: üretim yapmaz" if s.grev else "")], ic)
		d.set_meta("hedef", s.id)
		d.disabled = not s.neden.is_empty() or k.is_yeri == s.id
		d.pressed.connect(func() -> void: _ata(ekran, id, s.id))
	KonuslanmaPaneli.ekle(ekran, ic, k)
	var muhafiz := ekran._dugme("Muhafız görevi", ic)
	muhafiz.set_meta("hedef", KoyYonetimi.MUHAFIZ)
	if KarantinaYoneticisi.aktif(k): muhafiz.hide()
	muhafiz.disabled = k.yas_grubu != &"yetiskin" or k.is_yeri == KoyYonetimi.MUHAFIZ or y.muhafiz_sayisi() >= y.a.muhafiz_azami
	muhafiz.pressed.connect(func() -> void: _ata(ekran, id, KoyYonetimi.MUHAFIZ))
	var bos := ekran._dugme("Görevden çıkar", ic)
	bos.set_meta("hedef", KoyYonetimi.BOSTA)
	if KarantinaYoneticisi.aktif(k): bos.hide()
	bos.disabled = k.is_yeri == KoyYonetimi.BOSTA
	bos.pressed.connect(func() -> void: _ata(ekran, id, KoyYonetimi.BOSTA))
	KoyGeciciIslerPaneli.ekle(ekran,sekmeler,k)
	NeDuydun.ekle(ekran, v, k)
	var konus := ekran._dugme("Muhabbet Et (Konuş)", v)
	konus.pressed.connect(func() -> void:
		ekran._kart_kapat()
		var dy = KoyDiyalogYoneticisi.new()
		KoyDiyalogPaneli.ac(ekran, dy)
		if is_instance_valid(ekran.sahne3b) and is_instance_valid(ekran.sahne3b.halk_hareketi):
			ekran.sahne3b.halk_hareketi.konusma_bagla(dy, id)
		dy.muhabbet_baslat(k, y)
	)
	var kapat := ekran._dugme("Kapat", v)
	kapat.pressed.connect(ekran._kart_kapat)
	kapat.grab_focus.call_deferred()
static func _ata(ekran: KoyEkrani, id: int, hedef: int) -> void:
	if not preload("res://src/arayuz/koy_atama_kapisi.gd").acik(ekran): return
	if not KoyluKartiVerisi.ata(ekran.oturum.yonetim, id, hedef):
		ac(ekran, id) # Açık karttan sonra dolmuş/silinmiş yapıyı yeniden doğrula.
		return
	if hedef >= 0:
		preload("res://src/debug/ilk_saat_kancasi.gd").arac(ekran.oturum, "koy_atama")
		preload("res://src/arayuz/koy_hud/ilk_atama_vurgusu.gd").atama_kaydet(ekran.oturum.yonetim)
	ekran.oturum._koy_esitle()
	ekran._yenile()
	ac(ekran, id)
