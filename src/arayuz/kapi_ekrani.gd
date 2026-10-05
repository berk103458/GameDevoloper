## Kapı ekranı: gelen kişi kadraja yürür, sohbet edilir, karar iki adımda verilir
## (sanat kitabı 7.2; Girdi GDD kural 15–17; Karakter kadrosu GDD).
class_name KapiEkrani
extends Control

## Gece sonu çözümü bitti; rapor `Oturum.gece_sonu()` sözlüğüdür.
signal gece_bitti(rapor: Dictionary)
## Gece içinde bar kırıldı (rüşvet hakkı kalmadı).
signal oturum_bitti(kirilan: int)
signal duraklat_istendi

## Sağdaki kapı defteri paneli ve sol alttaki konuşma kutusu (ekran px, 1080p).
const DEFTER := Rect2(1172, 104, 716, 952)
const KONUSMA := Rect2(36, 742, 1104, 314)
## Kamerayı yana kaydırır: gelen kişi ekranın sol-ortasında durur, defterin altında kalmaz.
const KAMERA_KAYMA := 1.05
const KARAR_SIMGE := {"kabul": "accept", "ret": "reject", "rusvet": "bribe", "kisla": "barracks", "elkoy": "reject"}

var oturum: Oturum
var ayarlar: Ayarlar
var evre: StringName = &""  # sohbet, karar, sonuc, gecis

var _kuyruk: Array[Gelen] = []
var _gelen: Gelen
var _sorulan: Array[int] = []
var _secili: String = ""
var _karar_dugmeleri: Array[Button] = []
var _karar_anahtarlari: PackedStringArray = []
var _belirme_id := 0
var _beliriyor := false
var _gosterilecek: Array[Button] = []
## Açık heybe paneli (yoksa null).
var _heybe_paneli: HeybePaneli
var _yalan_yazildi := false

var hud: Hud
var _dunya: Control
## 3D kapı sahnesi.
var sahne: KapiSahnesi
var _ad: Label
var _sinif: Label
var _kayit: RichTextLabel
var _secenekler: VBoxContainer
## Defterin altında her zaman görünen eylemler (Heybesini ara, Kararını ver, Sohbete dön).
var _eylemler: VBoxContainer
var _bolum: Label
var _bilgi: Label
var _levha_ad: Label
var _gece_gelen := 0
var _is_secenekleri: PackedStringArray = []
var _is_karari := ""
## Sıra olayında seçilen seçenek.
signal _sira_secildi(i: int)
var _sira_satirlari: Array[Button] = []


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var zemin := ColorRect.new()
	zemin.color = Renkler.GECE
	zemin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)

	# 3D kapı sahnesi tüm ekranı kaplar; arayüz üstüne biner.
	_dunya = Control.new()
	_dunya.position = Vector2(0, 92)
	_dunya.size = Vector2(1140, 988)
	add_child(_dunya)
	var kap := SubViewportContainer.new()
	kap.stretch = true
	kap.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(kap)
	move_child(kap, 1)
	var vp := SubViewport.new()
	vp.size = Vector2i(1920, 1080)
	vp.msaa_3d = Viewport.MSAA_4X
	kap.add_child(vp)
	sahne = KapiSahnesi.new()
	vp.add_child(sahne)
	sahne.kamera.h_offset = KAMERA_KAYMA

	_konusma_kur()
	_defter_kur()

	hud = Hud.new()
	add_child(hud)
	hud.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	hud.bagla(oturum)


## Sol alt: isim levhası ve bu gelenle konuşmanın tamamı (kaydırılır).
func _konusma_kur() -> void:
	var kutu := CerceveKutu.new()
	kutu.position = KONUSMA.position
	kutu.size = KONUSMA.size
	add_child(kutu)
	var kenar := MarginContainer.new()
	kenar.position = KONUSMA.position
	kenar.size = KONUSMA.size
	for y in ["margin_left", "margin_right"]:
		kenar.add_theme_constant_override(y, 30)
	kenar.add_theme_constant_override("margin_top", 34)
	kenar.add_theme_constant_override("margin_bottom", 18)
	add_child(kenar)
	_kayit = RichTextLabel.new()
	_kayit.bbcode_enabled = true
	_kayit.scroll_following = true
	_kayit.focus_mode = Control.FOCUS_NONE
	_kayit.add_theme_color_override("default_color", MenuSatiri.KREM)
	kenar.add_child(_kayit)
	var levha := CerceveKutu.new()
	levha.dolgu = Color(0.06, 0.05, 0.04, 0.95)
	levha.position = KONUSMA.position + Vector2(28, -22)
	levha.size = Vector2(420, 44)
	add_child(levha)
	_levha_ad = Label.new()
	_levha_ad.position = levha.position + Vector2(18, 4)
	_levha_ad.add_theme_font_override("font", Tema.font(700))
	_levha_ad.add_theme_font_size_override("font_size", ayarlar.boyut(24))
	_levha_ad.add_theme_color_override("font_color", MenuSatiri.ALTIN)
	add_child(_levha_ad)


## Sağ: kapı defteri — gelenin kartı, sorular ya da kararlar (kaydırılır), sabit eylemler.
func _defter_kur() -> void:
	var kutu := CerceveKutu.new()
	kutu.position = DEFTER.position
	kutu.size = DEFTER.size
	add_child(kutu)
	var kenar := MarginContainer.new()
	kenar.position = DEFTER.position
	kenar.size = DEFTER.size
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 26)
	add_child(kenar)
	var dikey := VBoxContainer.new()
	dikey.add_theme_constant_override("separation", 6)
	kenar.add_child(dikey)
	_ad = Label.new()
	_ad.add_theme_font_override("font", Tema.font(600))
	_ad.add_theme_font_size_override("font_size", ayarlar.boyut(40))
	_ad.add_theme_color_override("font_color", MenuSatiri.KREM)
	dikey.add_child(_ad)
	_sinif = Label.new()
	_sinif.add_theme_font_size_override("font_size", ayarlar.boyut(Tema.KUCUK_PX))
	_sinif.add_theme_color_override("font_color", MenuSatiri.SOLUK)
	dikey.add_child(_sinif)
	_bilgi = Label.new()
	_bilgi.add_theme_font_size_override("font_size", ayarlar.boyut(19))
	_bilgi.add_theme_color_override("font_color", Renkler.SOGUK_MAVI)
	dikey.add_child(_bilgi)
	dikey.add_child(_ayrac(MenuSusu.Tur.ALT))
	_bolum = Label.new()
	_bolum.add_theme_font_override("font", Tema.font(700))
	_bolum.add_theme_font_size_override("font_size", ayarlar.boyut(22))
	_bolum.add_theme_color_override("font_color", MenuSatiri.ALTIN)
	dikey.add_child(_bolum)
	var kaydir := ScrollContainer.new()
	kaydir.size_flags_vertical = Control.SIZE_EXPAND_FILL
	kaydir.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	kaydir.follow_focus = true
	dikey.add_child(kaydir)
	_secenekler = VBoxContainer.new()
	_secenekler.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_secenekler.add_theme_constant_override("separation", 6)
	kaydir.add_child(_secenekler)
	dikey.add_child(_ayrac(MenuSusu.Tur.UST))
	_eylemler = VBoxContainer.new()
	_eylemler.add_theme_constant_override("separation", 6)
	dikey.add_child(_eylemler)
	var ipucu := Label.new()
	ipucu.text = tr("arayuz.sohbet.ipucu")
	ipucu.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	ipucu.add_theme_font_size_override("font_size", ayarlar.boyut(16))
	ipucu.add_theme_color_override("font_color", Renkler.SOGUK_MAVI)
	dikey.add_child(ipucu)


func _ayrac(tur: MenuSusu.Tur) -> Control:
	var s := MenuSusu.new()
	s.tur = tur
	s.konum = 332.0
	s.custom_minimum_size = Vector2(0, 24)
	s.mouse_filter = Control.MOUSE_FILTER_IGNORE
	s.resized.connect(s.queue_redraw)
	return s


## Defterdeki bilgi satırı: kaçıncı gece, kaçıncı gelen, sırada kaç kişi.
func _bilgi_yaz() -> void:
	_bilgi.text = tr("arayuz.kapi.bilgi") % [oturum.gosterilen_gece(), _gece_gelen, _kuyruk.size()]


## Yeni geceyi başlatır: kuyruk kurulur, ilk gelen kapıya yürür.
func gece_baslat() -> void:
	evre = &"gecis"
	_temizle()
	_kuyruk = oturum.gece_kuyrugu()
	_gece_gelen = 0
	_kayit.clear()
	_yaz("[color=#B8C2CC][b]%s[/b][/color]" % (tr("anlati.gece.basladi") % oturum.gosterilen_gece()))
	hud.guncelle()
	await Adim.kesme(self, 0.3)
	_siradaki()


func _siradaki() -> void:
	if _kuyruk.is_empty():
		_ad.text = ""
		_sinif.text = ""
		_levha_ad.text = ""
		_bilgi.text = ""
		evre = &"gecis"
		var rapor := oturum.gece_sonu()
		hud.guncelle()
		if rapor["son"] == &"kirildi":
			oturum_bitti.emit(rapor["kirilan"])
		else:
			gece_bitti.emit(rapor)
		return
	_gelen = _kuyruk.pop_front()
	_sorulan = []
	_yalan_yazildi = false
	_ad.text = tr(_gelen.ad_anahtari)
	_sinif.text = tr("arayuz.sinif.gibi") % tr("arayuz.sinif." + String(_gelen.sinif))
	_levha_ad.text = tr(_gelen.ad_anahtari)
	_gece_gelen += 1
	_bilgi_yaz()
	_bolum.text = ""
	# Yeni gelenle konuşma kaydı baştan: yalnız gece başlığı ve bu gelenin konuşması.
	_kayit.clear()
	_yaz("[color=#4A6B8A]%s[/color]" % (tr("arayuz.hud.gece") % oturum.gosterilen_gece()))
	_yaz("[i]%s[/i]" % tr(_gelen.giris_anahtari))
	oturum.ziyaret_basladi(_gelen)
	_adim_sesi(12)
	await sahne.gelen_yaklas(Dunya3B.karakter_adi(_gelen.id if _gelen.adli else &"", _gelen.portre, _gelen.sinif))
	if _gelen.acilis != "":
		_yaz("[b]%s:[/b] %s" % [tr(_gelen.ad_anahtari), tr(_gelen.acilis)])
	if oturum.perde == 2 or _gelen.sorular.is_empty():
		_karar_goster()
	else:
		_sohbet_goster()


func _sohbet_goster() -> void:
	evre = &"sohbet"
	_temizle()
	_bolum.text = tr("arayuz.kapi.sorular")
	var dugmeler: Array[Button] = []
	for i in _gelen.sorular.size():
		if i in _sorulan:
			continue
		# Takip sorusu, üst sorusu sorulunca açılır (konuştukça yeni sorular).
		var ust: int = _gelen.soru_ust[i] if i < _gelen.soru_ust.size() else -1
		if ust >= 0 and not (ust in _sorulan):
			continue
		var b := _dugme(("↳ " if ust >= 0 else "— ") + tr(_gelen.sorular[i][0]))
		b.girinti = 30.0 if ust >= 0 else 0.0
		b.pressed.connect(_soru_sor.bind(i))
		dugmeler.append(b)
	if _gelen.heybe != null and not _gelen.heybe.soruldu:
		var h := _dugme("— " + tr("arayuz.sohbet.heybe_sor"))
		h.pressed.connect(_heybe_sor)
		dugmeler.append(h)
	if _gelen.heybe != null:
		_heybe_dugmesi()
	var k := _dugme(tr("arayuz.sohbet.karar_ver"), _eylemler)
	k.ikon = MenuSatiri.Ikon.KAPI
	k.pressed.connect(_karar_goster)
	_sirayla_goster(dugmeler)


## "Heybende ne var?": gelen beyanını söyler (soru hakkından sayılmaz).
func _heybe_sor() -> void:
	if evre != &"sohbet":
		return
	_gelen.heybe.soruldu = true
	_yaz("[color=#4A6B8A]%s:[/color] %s\n[b]%s:[/b] %s" % [tr("arayuz.sohbet.sen"), tr("arayuz.sohbet.heybe_sor"),
		tr(_gelen.ad_anahtari), _beyan_metni()])
	_sohbet_goster()


## Gelenin söylediği: "Kesemde N akçe var. Bir de X, Y."
func _beyan_metni() -> String:
	var h := _gelen.heybe
	var esyalar: PackedStringArray = []
	for e in h.beyan_edilenler():
		if e["tur"] != "akce":
			esyalar.append(tr("esya." + String(e["id"])))
	var m := tr("heybe.beyan.akce") % h.beyan_akce()
	m += " " + ((tr("heybe.beyan.esya") % ", ".join(esyalar)) if not esyalar.is_empty() else tr("heybe.beyan.yok"))
	return m


func _heybe_dugmesi() -> Button:
	var b := _dugme(tr("arayuz.sohbet.heybe_ara"), _eylemler)
	b.doku = Sanat.doku("ui", "icon_bribe_pouch_full_48")
	b.pressed.connect(_heybe_ac)
	return b


## Heybe panelini dünya alanının üstünde açar; kapanınca bulunulan evre yeniden çizilir.
func _heybe_ac() -> void:
	if _heybe_paneli != null or _gelen == null or _gelen.heybe == null:
		return
	var donus := evre
	_secenekler.visible = false
	_eylemler.visible = false
	sahne.heybe_koy()
	_heybe_paneli = HeybePaneli.new()
	_heybe_paneli.heybe = _gelen.heybe
	_heybe_paneli.ayarlar = ayarlar
	_heybe_paneli.gelen_adi = tr(_gelen.ad_anahtari)
	_heybe_paneli.beyan_metni = _beyan_metni()
	_heybe_paneli.position = _dunya.position
	add_child(_heybe_paneli)
	_heybe_paneli.degisti.connect(_heybe_degisti)
	await _heybe_paneli.kapandi
	_heybe_paneli.queue_free()
	_heybe_paneli = null
	_secenekler.visible = true
	_eylemler.visible = true
	if donus == &"karar":
		_karar_goster()
	else:
		_sohbet_goster()


func _heybe_degisti() -> void:
	var h := _gelen.heybe
	if h.yakalandi() and not _yalan_yazildi:
		_yalan_yazildi = true
		var cikan: PackedStringArray = []
		for e in h.esyalar:
			if e["gizli"]:
				cikan.append(_esya_yazisi(e, int(e["adet"])))
		_yaz("[color=#C4843A]%s[/color]" % (tr("anlati.heybe.yakalandi") % [", ".join(cikan), tr(_gelen.ad_anahtari)]))


func _esya_yazisi(e: Dictionary, adet: int) -> String:
	var ad := tr("esya." + String(e["id"]))
	return ("%d %s" % [adet, ad]) if (adet > 1 or e["tur"] == "akce") else ad


## Karar düğmesinin yazısı; rüşvette miktar görünür.
func _karar_etiketi(anahtar: String) -> String:
	if anahtar == "rusvet" and _gelen.heybe != null:
		var h := _gelen.heybe
		if h.alinan_var():
			return tr("arayuz.karar.rusvet_deger") % h.alinan_deger()
		return tr("arayuz.karar.rusvet_miktar") % h.teklif
	return tr("arayuz.karar." + anahtar)


func _soru_sor(i: int) -> void:
	if evre != &"sohbet":
		return
	_sorulan.append(i)
	_yaz("[color=#4A6B8A]%s:[/color] %s\n[b]%s:[/b] %s" % [tr("arayuz.sohbet.sen"), tr(_gelen.sorular[i][0]),
		tr(_gelen.ad_anahtari), tr(_gelen.sorular[i][1])])
	# Cevap uzunluğu kadar konuşur; sorgu uzadıkça (üçüncü sorudan sonra) gerginleşir.
	if _sorulan.size() >= 3 and sahne.gelen_hareket_var("gergin"):
		sahne.gelen_gergin()
	else:
		sahne.gelen_konus(clampf(tr(_gelen.sorular[i][1]).length() / 28.0, 1.5, 5.0))
	if _sorulan.size() >= _gelen.soru_siniri(oturum.ayarlar.azami_soru) or _sorulan.size() >= _gelen.sorular.size():
		_karar_goster()
	else:
		_sohbet_goster()


func _karar_goster() -> void:
	evre = &"karar"
	_secili = ""
	_temizle()
	_bolum.text = tr("arayuz.kapi.karar")
	_daralt(true)
	_karar_dugmeleri = []
	var gorunen := PackedStringArray()
	for n in _gelen.secenekler.size():
		var esik := 0
		if n < _gelen.esikler.size():
			esik = _gelen.esikler[n]
		if _sorulan.size() >= esik:
			gorunen.append(_gelen.secenekler[n])
	if gorunen.is_empty():
		gorunen = _gelen.secenekler
	if _gelen.heybe != null and _gelen.heybe.yakalandi() and not gorunen.has("elkoy"):
		gorunen = gorunen.duplicate()
		gorunen.append("elkoy")
	_karar_anahtarlari = gorunen
	for n in _karar_anahtarlari.size():
		var anahtar := _karar_anahtarlari[n]
		var b := _dugme("%d · %s" % [n + 1, _karar_etiketi(anahtar)])
		b.doku = Sanat.doku("ui", "icon_decision_%s_48" % KARAR_SIMGE[anahtar])
		b.custom_minimum_size.y = 80
		b.punto = ayarlar.boyut(30)
		b.alt_yazi = _karar_alt_yazi(anahtar)
		b.pressed.connect(_karar_bas.bind(anahtar))
		_karar_dugmeleri.append(b)
	# Eylemler (defterin altı) hemen görünür; yalnız kararlar sırayla belirir.
	if _gelen.heybe != null:
		_heybe_dugmesi()
	if oturum.perde == 1 and _sorulan.size() < mini(_gelen.soru_siniri(oturum.ayarlar.azami_soru), _gelen.sorular.size()):
		var g := _dugme(tr("arayuz.kapi.sohbete_don"), _eylemler)
		g.pressed.connect(_sohbet_goster)
	_sirayla_goster(_karar_dugmeleri)


## Karar satırının altındaki küçük, tarafsız bilgi (sonucu söylemez).
func _karar_alt_yazi(anahtar: String) -> String:
	if anahtar == "rusvet" and _gelen.heybe != null:
		return tr("heybe.teklif") % _gelen.heybe.teklif
	if anahtar == "elkoy":
		return tr("heybe.yakalandi")
	return ""


## İki adımlı onay: ilk basış seçer, aynı karara ikinci basış verir.
## Kabul ve rüşvette ardından iş yeri seçilir.
func _karar_bas(anahtar: String) -> void:
	if evre != &"karar":
		return
	if _secili == anahtar:
		if (anahtar == "kabul" or anahtar == "rusvet") and oturum.perde == 1:
			_is_goster(anahtar)
		else:
			_karar_ver(anahtar)
		return
	_secili = anahtar
	for i in _karar_dugmeleri.size():
		var b := _karar_dugmeleri[i]
		var ad := _karar_etiketi(_karar_anahtarlari[i])
		b.toggle_mode = true
		b.set_pressed_no_signal(_karar_anahtarlari[i] == _secili)
		b.text = (tr("arayuz.karar.onayla") % ad) if _karar_anahtarlari[i] == _secili else "%d · %s" % [i + 1, ad]
		b.queue_redraw()
		if _karar_anahtarlari[i] == _secili:
			b.grab_focus()


## İş yeri adımı: kabul edilen nerede çalışacak? Altta işin sınıfı yazar (tarafsız bilgi).
func _is_goster(karar: String) -> void:
	evre = &"is"
	_temizle()
	_bolum.text = tr("arayuz.is.baslik")
	var satirlar: Array[Button] = []
	var yerler := oturum.is_yerleri()
	for n in yerler.size():
		var yer := yerler[n]
		var i := oturum.ayarlar.is_idleri.find(yer)
		var b := _dugme("%d · %s" % [n + 1, tr("arayuz.is." + yer)])
		b.custom_minimum_size.y = 80
		b.punto = ayarlar.boyut(28)
		b.alt_yazi = tr("arayuz.is.uygun") % tr("arayuz.sinif." + oturum.ayarlar.is_siniflari[i])
		b.doku = Sanat.doku("ui", "icon_decision_%s_48" % ("barracks" if yer == "kisla" else "accept"))
		b.pressed.connect(func() -> void:
			if evre == &"is":
				_karar_ver(karar, StringName(yer))
		)
		satirlar.append(b)
	_is_secenekleri = yerler
	_is_karari = karar
	var g := _dugme(tr("arayuz.is.geri"), _eylemler)
	g.pressed.connect(_karar_goster)
	_sirayla_goster(satirlar)


func _karar_birak() -> void:
	if evre != &"karar" or _secili == "":
		return
	_secili = ""
	for i in _karar_dugmeleri.size():
		_karar_dugmeleri[i].set_pressed_no_signal(false)
		_karar_dugmeleri[i].text = "%d · %s" % [i + 1, _karar_etiketi(_karar_anahtarlari[i])]
		_karar_dugmeleri[i].queue_redraw()


func _karar_ver(anahtar: String, is_yeri: StringName = &"") -> void:
	evre = &"sonuc"
	_temizle()
	_bolum.text = ""
	Ses.cal(&"sfx_onay")
	var sonuc := oturum.karar_ver(_gelen, StringName(anahtar), is_yeri)
	if anahtar == "rusvet" or anahtar == "elkoy":
		Ses.cal(&"sfx_kese")
	Ses.cal(&"sfx_kapi_acilir" if sonuc["kaldi"] else &"sfx_kapi_kapanir", -4.0)
	_yaz(tr("anlati.sonuc." + anahtar) % tr(_gelen.ad_anahtari))
	if is_yeri != &"":
		_yaz("[i]%s[/i]" % (tr("anlati.is.yazildi") % [tr(_gelen.ad_anahtari), tr("anlati.is.yer." + String(is_yeri))]))
	if sonuc.get("uyumsuz", false):
		_yaz("[i][color=#C4843A]%s[/color][/i]" % (tr("anlati.is.uyumsuz") % tr(oturum.ayarlar.bar_anahtarlari[sonuc["uyumsuz_bar"]])))
	if not sonuc.get("alinan", []).is_empty():
		var parca: PackedStringArray = []
		for a in sonuc["alinan"]:
			parca.append(_esya_yazisi({"id": a["id"], "tur": "akce" if a["id"] == "akce" else ""}, int(a["adet"])))
		_yaz("[i]%s[/i]" % (tr("anlati.heybe.alinan") % ", ".join(parca)))
	if sonuc.get("gasp", false):
		_yaz("[i][color=#C4843A]%s[/color][/i]" % tr("anlati.heybe.gasp"))
	if sonuc.get("durust_arandi", false):
		_yaz("[i][color=#C4843A]%s[/color][/i]" % tr("anlati.heybe.durust"))
	if _gelen.yanitlar.has(anahtar):
		_yaz("[b]%s:[/b] %s" % [tr(_gelen.ad_anahtari), str(_gelen.yanitlar[anahtar])])
	if sonuc["rusvet_harcandi"] >= 0:
		Ses.cal(&"sfx_bar_catlak")
		_yaz("[i]%s[/i]" % (tr("anlati.rusvet.harcandi") % tr(oturum.ayarlar.bar_anahtarlari[sonuc["rusvet_harcandi"]])))
	hud.guncelle()
	_daralt(false)
	_adim_sesi(8)
	await sahne.gelen_git(sonuc["kaldi"], _gelen.tehlikeli or not _gelen.adli)
	if sonuc["kirilan"] >= 0:
		oturum_bitti.emit(sonuc["kirilan"])
		return
	# İki gelen arasında sırada bir şey olabilir.
	var so := oturum.sira_olayi_sec(_kuyruk.size())
	if so != null and await _sira_olayi(so):
		return
	_siradaki()


## Sıra olayı: kuyrukta olan canlandırılır, bekçi seçer, sonucu oynar. Bar kırıldıysa true.
func _sira_olayi(o: OlayVerisi) -> bool:
	evre = &"sira"
	_temizle()
	_kayit.clear()
	_ad.text = tr("arayuz.kapi.sira")
	_sinif.text = tr(o.baslik_anahtari)
	_levha_ad.text = tr(o.baslik_anahtari)
	_bolum.text = tr("arayuz.kapi.karar")
	_bilgi_yaz()
	Ses.cal(&"sfx_olay")
	if o.ses != &"":
		Ses.cal(o.ses, -3.0)
	_yaz("[i]%s[/i]" % tr(o.metin_anahtari))
	var anahtar := String(o.kosullar.get("canlandirma", ""))
	await sahne.sira_olayi_baslat(anahtar)
	_sira_satirlari = []
	for i in o.secenek_anahtarlari.size():
		var b := _dugme("%d · %s" % [i + 1, tr(o.secenek_anahtarlari[i])])
		b.custom_minimum_size.y = 66
		b.disabled = not oturum.secenek_olur(o, i)
		b.pressed.connect(func() -> void: _sira_secildi.emit(i))
		_sira_satirlari.append(b)
	_sirayla_goster(_sira_satirlari)
	var i: int = await _sira_secildi
	_temizle()
	var etki: Dictionary = o.secenek_etkileri[i]
	var sonuc := oturum.olay_uygula(o, i)
	_yaz(tr(sonuc["sonuc_anahtari"]))
	if int(etki.get("kuyruk", 0)) < 0 and _kuyruk.size() > 0:
		_kuyruk.pop_back()
		_bilgi_yaz()
	hud.guncelle()
	await sahne.sira_olayi_bitir(anahtar, etki)
	await get_tree().create_timer(0.8).timeout
	if sonuc["kirilan"] >= 0:
		oturum_bitti.emit(sonuc["kirilan"])
		return true
	return false


func _adim_sesi(adet: int) -> void:
	for i in adet / 2:
		Ses.cal(&"sfx_adim", -6.0)
		await get_tree().create_timer(Adim.KARE_SN * 4.0).timeout


func _daralt(icerden: bool) -> void:
	await sahne.daralt(icerden)


## Defter satırı (altın çerçeveli, menü satırıyla aynı dil). Varsayılan yer: sorular/kararlar listesi.
func _dugme(yazi: String, kap: Container = null) -> MenuSatiri:
	var b := MenuSatiri.new()
	b.text = yazi
	b.ikon = MenuSatiri.Ikon.YOK
	b.font_ = Tema.font(500)
	b.punto = ayarlar.boyut(26)
	b.alt_punto = ayarlar.boyut(17)
	b.custom_minimum_size = Vector2(0, 58)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.focus_entered.connect(func() -> void: Ses.cal(&"sfx_secim", -8.0))
	(kap if kap != null else _secenekler).add_child(b)
	return b


func _temizle() -> void:
	_belirme_id += 1
	_beliriyor = false
	for c in _secenekler.get_children() + _eylemler.get_children():
		c.queue_free()


## Seçenekler tek tek belirir (sanat kitabı 7.7); belirme süresi ayardan.
func _sirayla_goster(dugmeler: Array[Button]) -> void:
	var benim := _belirme_id
	_gosterilecek = dugmeler
	for b in dugmeler:
		b.visible = false
	var bekle := ayarlar.belirme_ms(oturum.ayarlar.belirme_ms) / 1000.0
	_beliriyor = true
	for i in dugmeler.size():
		if benim != _belirme_id or not is_instance_valid(dugmeler[i]):
			return
		dugmeler[i].visible = true
		if i == 0:
			dugmeler[i].grab_focus()
		if bekle > 0.0 and i < dugmeler.size() - 1:
			await get_tree().create_timer(bekle).timeout
	if benim == _belirme_id:
		_beliriyor = false


func _tumunu_goster() -> void:
	_belirme_id += 1
	_beliriyor = false
	for b in _gosterilecek:
		if is_instance_valid(b):
			b.visible = true


func _yaz(s: String) -> void:
	_kayit.append_text(s + "\n")


func _input(olay: InputEvent) -> void:
	if _heybe_paneli != null:
		return
	# Belirme sürerken bir basış atlamadır: kalanlar görünür, hiçbiri seçilmez (Girdi kural 17).
	if _beliriyor and (olay.is_action_pressed("ui_accept") or (olay is InputEventMouseButton and olay.pressed)):
		_tumunu_goster()
		get_viewport().set_input_as_handled()


func _unhandled_input(olay: InputEvent) -> void:
	if _heybe_paneli != null:
		return
	if evre == &"karar":
		for n in 5:
			if olay.is_action_pressed("kisayol_%d" % (n + 1)) and n < _karar_anahtarlari.size():
				_karar_bas(_karar_anahtarlari[n])
				get_viewport().set_input_as_handled()
				return
	if evre == &"sira":
		for n in 5:
			if olay.is_action_pressed("kisayol_%d" % (n + 1)) and n < _sira_satirlari.size() and not _sira_satirlari[n].disabled:
				_sira_secildi.emit(n)
				get_viewport().set_input_as_handled()
				return
	if evre == &"is":
		for n in 5:
			if olay.is_action_pressed("kisayol_%d" % (n + 1)) and n < _is_secenekleri.size():
				_karar_ver(_is_karari, StringName(_is_secenekleri[n]))
				get_viewport().set_input_as_handled()
				return
		if olay.is_action_pressed("geri"):
			get_viewport().set_input_as_handled()
			_karar_goster()
			return
	if olay.is_action_pressed("geri"):
		get_viewport().set_input_as_handled()
		if evre == &"karar" and _secili != "":
			_karar_birak()
		else:
			duraklat_istendi.emit()
	elif olay.is_action_pressed("menu"):
		get_viewport().set_input_as_handled()
		duraklat_istendi.emit()
