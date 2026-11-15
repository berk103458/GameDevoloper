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
const KAMERA_KAYMA := 1.3
const KARAR_SIMGE := {"kabul": "accept", "harc": "bribe", "ret": "reject", "rusvet": "bribe", "kisla": "barracks", "elkoy": "reject"}
const ILK_GECE = preload("res://src/kapi/ilk_gece_kisiti.gd")
const HATIRLANMA_NOTU := preload("res://src/arayuz/kapi/hatirlanma_notu.gd")

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
var _chr_muzik: Node
var _tercuman_durumu: Dictionary = {}
var _dil_sabri: int = 5
var _dil_notlari: Array[Dictionary] = []
var _hatirlanma_notu: Control

var hud: Hud
var _dunya: Control
## 3D kapı sahnesi.
var sahne: KapiSahnesi
var _vp: SubViewport
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
	# 3D, pencerenin gerçek çözünürlüğünde çizilir (4K ekranda 4K) ve arayüzün altına tam ekran serilir.
	_vp = SubViewport.new()
	_vp.msaa_3d = Viewport.MSAA_4X
	_vp.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
	_vp.size = _cizim_boyutu()
	add_child(_vp)
	var kap := TextureRect.new()
	kap.texture = _vp.get_texture()
	kap.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	kap.stretch_mode = TextureRect.STRETCH_SCALE
	kap.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	kap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(kap)
	move_child(kap, 1)
	get_window().size_changed.connect(func() -> void: _vp.size = _cizim_boyutu())
	var vp := _vp
	sahne = KapiSahnesi.new()
	sahne.gece = oturum.gun
	sahne.perde = oturum.perde
	sahne.sur = int(oturum.yapilar[&"sur"])
	sahne.yakinlik = clampf(float(oturum.yonetim.tekfur_baski + oturum.yonetim.savusturulan) / maxf(1.0, oturum.yonetim.a.zafer_bask_sayisi), 0.0, 1.0)
	vp.add_child(sahne)
	sahne.kamera.h_offset = KAMERA_KAYMA
	preload("res://src/dunya/ilk_aile_es_kadraji.gd").kur(self)

	_konusma_kur()
	_defter_kur()

	hud = Hud.new()
	add_child(hud)
	hud.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	hud.bagla(oturum)


## Sol alt: isim levhası ve bu gelenle konuşmanın tamamı (kaydırılır).
## 3D çizim boyutu: pencerenin fiziksel piksel boyutu (en az 1920×1080), 16:9.
func _cizim_boyutu() -> Vector2i:
	var p := get_window().size
	var en := maxi(p.x, 1920)
	return Vector2i(en, int(en * 9.0 / 16.0))


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
	levha.dolgu = Kabuk.LEVHA
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
	_bilgi.add_theme_font_size_override("font_size", ayarlar.boyut(Kabuk.KUCUK))
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
	ipucu.add_theme_font_size_override("font_size", ayarlar.boyut(Kabuk.KUCUK))
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


## Gelenin 3D modelinin adı (kuyrukta ve kapıda aynı model).
func _model_adi(g: Gelen) -> String:
	return Dunya3B.karakter_adi(g.id if g.adli else &"", g.portre, g.sinif)


## Defterdeki bilgi satırı: kaçıncı gece, kaçıncı gelen, sırada kaç kişi.
func _bilgi_yaz() -> void:
	_bilgi.text = tr("arayuz.kapi.bilgi") % [oturum.gosterilen_gece(), _gece_gelen, _kuyruk.size()]
	KapiFirtinaKuyrugu.bilgi(oturum, _gelen, _bilgi)
	_bilgi.text += "\n" + preload("res://src/kapi/barinak_uyarisi.gd").metin(oturum.yonetim, preload("res://src/kapi/aile_kafilesi.gd").kisi_sayisi(_gelen))


## Yeni geceyi başlatır: kuyruk kurulur, ilk gelen kapıya yürür.
func gece_baslat() -> void:
	evre = &"gecis"
	_temizle()
	_kuyruk = oturum.gece_kuyrugu()
	preload("res://src/arayuz/kapi_acilis_ogretici.gd").kur(self)
	var adlar: Array[String] = []
	for g in _kuyruk:
		adlar.append(_model_adi(g))
	var kuyruk_kaynaklari := await VarlikYuklemePaneli.hazirla(self, GirisVarliklari.karakterler(adlar))
	KapiFirtinaKuyrugu.kur(oturum, sahne)
	sahne.kuyruk_doldur(adlar)
	await VarlikYuklemePaneli.bitir(self, kuyruk_kaynaklari)
	_gece_gelen = 0
	_kayit.clear()
	KonusmaGecmisi.ziyaret_basi(_kayit)
	_yaz("[color=#B8C2CC][b]%s[/b][/color]" % (tr("anlati.gece.basladi") % oturum.gosterilen_gece()))
	hud.guncelle()
	await Adim.kesme(self, 0.3)
	_siradaki()


func _siradaki() -> void:
	if DiplomatikHeyet.gecis_engeli(oturum, _gelen): return
	if _kuyruk.is_empty():
		_ad.text = ""
		_sinif.text = ""
		_levha_ad.text = ""
		_bilgi.text = ""
		evre = &"gecis"
		# Kapı nöbeti bitti (Faz 1); gece hesaplaşması köy yönetiminden sonra yapılır.
		hud.guncelle()
		gece_bitti.emit({})
		return
	_gelen = _kuyruk.pop_front()
	KapiFirtinaKuyrugu.beklet(oturum, _kuyruk, _gece_gelen + 1)
	if _chr_muzik != null:
		_chr_muzik.durdur()
	_sorulan = []
	_yalan_yazildi = false
	_tercuman_durumu = {}
	_dil_sabri = 5
	_dil_notlari = []
	_ad.text = tr(_gelen.ad_anahtari)
	_sinif.text = tr("arayuz.sinif.gibi") % tr("arayuz.sinif." + String(_gelen.sinif))
	_levha_ad.text = tr(_gelen.ad_anahtari)
	_gece_gelen += 1
	_bilgi_yaz()
	_bolum.text = ""
	# Yeni gelenle konuşma kaydı baştan: yalnız gece başlığı ve bu gelenin konuşması.
	_kayit.clear()
	KonusmaGecmisi.ziyaret_basi(_kayit)
	_yaz("[color=#4A6B8A]%s[/color]" % (tr("arayuz.hud.gun") % oturum.gosterilen_gece()))
	_yaz("[i]%s[/i]" % tr(_gelen.giris_anahtari))
	oturum.ziyaret_basladi(_gelen)
	_adim_sesi(12)
	await sahne.gelen_yaklas(_model_adi(_gelen))
	preload("res://src/dunya/aile_kapi_gorunumu.gd").kur(sahne._gelen, _gelen)
	for satir in KapiHavaRepligi.satirlar(oturum, _gelen):
		_yaz(satir)
	if _gelen.acilis != "":
		_yaz("[b]%s:[/b] %s" % [tr(_gelen.ad_anahtari), tr(_gelen.acilis)])
	if oturum.perde == 2 or _gelen.sorular.is_empty():
		_karar_goster()
	else:
		_sohbet_goster()


func _sohbet_goster() -> void:
	if evre == &"karar":
		_daralt(false)
	evre = &"sohbet"
	_temizle()
	_bolum.text = tr("arayuz.kapi.sorular")
	if preload("res://src/arayuz/chr_kapi_adaptoru.gd").diyalog_goster(self, _gelen, _secenekler, _eylemler):
		preload("res://src/kapi/hastalik_teshis_adaptoru.gd").eylem(self, _gelen, _eylemler)
		if tercuman_dugmesi_gorunur_mu():
			_tercuman_dugmesi_ekle()
		return
	var ortak_dil := DilEngeli.oturum_ortak_dil_var_mi(oturum, _gelen)
	var tercuman_aktif := bool(_tercuman_durumu.get("aktif", false))
	var dugmeler: Array[Button] = []
	var konu_sayac := 0
	for i in _gelen.sorular.size():
		if i in _sorulan:
			continue
		# Takip sorusu, üst sorusu sorulunca açılır (konuştukça yeni sorular).
		var ust: int = _gelen.soru_ust[i] if i < _gelen.soru_ust.size() else -1
		if ust >= 0 and not (ust in _sorulan):
			continue
		if not ortak_dil and not tercuman_aktif and konu_sayac >= 2:
			continue
		konu_sayac += 1
		var b := _dugme(("↳ " if ust >= 0 else "— ") + tr(_gelen.sorular[i][0]))
		b.girinti = 30.0 if ust >= 0 else 0.0
		b.pressed.connect(_soru_sor.bind(i))
		dugmeler.append(b)
	var heybe_acik := ILK_GECE.heybe_acik(oturum, _gelen)
	if heybe_acik and not _gelen.heybe.soruldu:
		var h := _dugme("— " + tr("arayuz.sohbet.heybe_sor"))
		h.pressed.connect(_heybe_sor)
		dugmeler.append(h)
	if heybe_acik:
		_heybe_dugmesi()
	if tercuman_dugmesi_gorunur_mu():
		_tercuman_dugmesi_ekle()
	var k := _dugme(tr("arayuz.sohbet.karar_ver"), _eylemler)
	k.ikon = MenuSatiri.Ikon.KAPI
	k.pressed.connect(_karar_goster)
	if not ILK_GECE.etkin(oturum, _gelen):
		preload("res://src/kapi/hastalik_teshis_adaptoru.gd").eylem(self, _gelen, _eylemler)
	_sirayla_goster(dugmeler)


## "Heybende ne var?": gelen beyanını söyler (soru hakkından sayılmaz).
func _heybe_sor() -> void:
	if evre != &"sohbet" or not ILK_GECE.heybe_acik(oturum, _gelen):
		return
	_gelen.heybe.soruldu = true
	preload("res://src/debug/ilk_saat_kancasi.gd").arac(oturum, "beyan")
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
	var chr_dugme := preload("res://src/arayuz/chr_kapi_adaptoru.gd").inceleme_dugmesi(self, _gelen, _eylemler)
	if chr_dugme != null:
		return chr_dugme
	var b := _dugme(tr("arayuz.sohbet.heybe_ara"), _eylemler)
	b.doku = Sanat.doku("ui", "icon_bribe_pouch_full_48")
	b.pressed.connect(_heybe_ac)
	return b


## Heybe panelini dünya alanının üstünde açar; kapanınca bulunulan evre yeniden çizilir.
func _heybe_ac() -> void:
	if _heybe_paneli != null or not ILK_GECE.heybe_acik(oturum, _gelen):
		return
	var donus := evre
	_secenekler.visible = false
	_eylemler.visible = false
	sahne.heybe_koy()
	if MuhafizAdaletYetenekleri.heybe_incele(oturum, _gelen.heybe): _heybe_degisti()
	_heybe_paneli = HeybePaneli.new()
	_heybe_paneli.heybe = _gelen.heybe
	_heybe_paneli.ayarlar = ayarlar
	_heybe_paneli.gelen_adi = tr(_gelen.ad_anahtari)
	_heybe_paneli.beyan_metni = _beyan_metni()
	_heybe_paneli.position = _dunya.position
	add_child(_heybe_paneli)
	HeybeKadraji.ac(self, _heybe_paneli)
	preload("res://src/debug/ilk_saat_kancasi.gd").arac(oturum, "heybe")
	preload("res://src/kapi/hastalik_teshis_adaptoru.gd").heybe_bagla(_heybe_paneli, self, _gelen)
	_heybe_paneli.degisti.connect(_heybe_degisti)
	await _heybe_paneli.kapandi
	_heybe_paneli.queue_free()
	_heybe_paneli = null
	HeybeKadraji.kapat(self, KAMERA_KAYMA)
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

func _chr_tansiyon_degisti(deger: int) -> void:
	if _chr_muzik == null:
		_chr_muzik = preload("res://src/sistemler/tansiyon_muzigi.gd").new()
		add_child(_chr_muzik)
	_chr_muzik.guncelle(deger)
	if sahne == null:
		return
	if deger >= 8:
		sahne.gelen_panik()
	elif deger >= 4:
		sahne.gelen_gergin()

func _chr_replik_basladi(metin: String) -> void:
	if sahne != null:
		var sorgu := _gelen.chr_sorgusu()
		if sorgu != null and not sorgu.bayraklar["Flag_Kilitlendi"]:
			sahne.gelen_konus(clampf(metin.length() / 28.0, 1.5, 5.0))


func _esya_yazisi(e: Dictionary, adet: int) -> String:
	var ad := tr("esya." + String(e["id"]))
	return ("%d %s" % [adet, ad]) if (adet > 1 or e["tur"] == "akce") else ad


## Karar düğmesinin yazısı; rüşvette miktar görünür.
func _karar_etiketi(anahtar: String) -> String:
	var oba = preload("res://src/sistemler/aydogdu_ziyareti.gd")
	if oba.ilgilenir(_gelen): return oba.etiket(StringName(anahtar))
	var ulak = preload("res://src/sistemler/sancak_ulagi.gd")
	if ulak.ilgilenir(_gelen): return ulak.etiket(anahtar)
	if anahtar == "cocuklari_al": return "Yalnız çocukları al"
	if DiplomatikHeyet.ilgilenir(_gelen): return HeyetKapiPaneli.etiket(anahtar)
	if TuccarKapiGecisi.ilgilenir(_gelen): return TuccarKapiPaneli.etiket(anahtar)
	var sorgu := _gelen.chr_sorgusu()
	if anahtar == "ret" and sorgu != null and sorgu.bayraklar["Flag_Kilitlendi"]:
		return "Zorunlu ret"
	if anahtar == "rusvet" and sorgu != null:
		return "Rüşvet: %d kişisel akçe" % int(sorgu.karakter.karar_verisi(&"rusvet").get("muhafiz_akce", 0))
	if anahtar == "rusvet" and _gelen.heybe != null:
		var h := _gelen.heybe
		if h.alinan_var():
			return tr("arayuz.karar.rusvet_deger") % h.alinan_deger()
		return tr("arayuz.karar.rusvet_miktar") % h.teklif
	return tr("arayuz.karar." + anahtar)


func _soru_sor(i: int) -> void:
	if evre != &"sohbet":
		return
	var chr := _gelen.chr_sorgusu()
	if chr != null:
		if chr.secenek_sec(i):
			_sohbet_goster()
		return
	if i < 0 or i >= _gelen.sorular.size() or i in _sorulan or _sorulan.size() >= _gelen.soru_siniri(oturum.ayarlar.azami_soru):
		return
	_sorulan.append(i)
	if ILK_GECE.etkin(oturum, _gelen) and i < 2:
		preload("res://src/debug/ilk_saat_kancasi.gd").arac(oturum, "kapi_selam" if i == 0 else "kapi_konu")
	var once := _gelen.acik_bayraklar.size()
	_gelen.soru_soruldu(i)
	var ortak_dil := DilEngeli.oturum_ortak_dil_var_mi(oturum, _gelen)
	var soru_metni := tr(_gelen.sorular[i][0])
	var cevap_tam := tr(_gelen.sorular[i][1])
	var diller := DilEngeli.gelen_dilleri(_gelen)
	var kirik_yazi := "%s bir şeyler söylüyor..." % String(diller[0]).capitalize()
	var cozum := DilEngeli.satir_coz({"id": soru_metni, "tam": cevap_tam, "kirik": kirik_yazi}, ortak_dil, _tercuman_durumu)
	var gosterilen := String(cozum.get("metin", cevap_tam))
	if bool(cozum.get("kirik_mi", false)):
		_dil_notlari.append(DilEngeli.tercumansiz_beyan_kaydi(soru_metni))
	if not String(cozum.get("es_aksam_anisi", "")).is_empty():
		_dil_notlari.append({"tur": "es_aksam_anisi", "metin": cevap_tam})
	_yaz("[color=#4A6B8A]%s:[/color] %s\n[b]%s:[/b] %s" % [tr("arayuz.sohbet.sen"), soru_metni,
		tr(_gelen.ad_anahtari), gosterilen])
	if not String(cozum.get("sezgi", "")).is_empty():
		_yaz("[i][color=#C4843A]%s[/color][/i]" % String(cozum.get("sezgi", "")))
	preload("res://src/kapi/es_yorumu_adaptoru.gd").soru_soruldu(self, _gelen, _sorulan.size())
	if _gelen.acik_bayraklar.size() > once:
		Ses.cal(&"sfx_olay", -6.0)
		for b in _gelen.acik_bayraklar.slice(once):
			_yaz("[i][color=#C4843A]%s[/color][/i]" % (tr("arayuz.bayrak.acildi") % tr("koy.bayrak." + b)))
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
	preload("res://src/kapi/meslek_uyarisi.gd").ekle(_secenekler,oturum.yonetim,_gelen,ayarlar.boyut(Tema.KUCUK_PX))
	preload("res://src/kapi/es_yorumu_adaptoru.gd").karar_gosterildi(self, _gelen)
	var gorunen := PackedStringArray()
	for n in _gelen.secenekler.size():
		var esik := 0
		if n < _gelen.esikler.size():
			esik = _gelen.esikler[n]
		if _sorulan.size() >= esik:
			gorunen.append(_gelen.secenekler[n])
	if gorunen.is_empty():
		gorunen = _gelen.secenekler
	var heybe_acik := ILK_GECE.heybe_acik(oturum, _gelen)
	if heybe_acik and _gelen.heybe.yakalandi() and not gorunen.has("elkoy"):
		gorunen = gorunen.duplicate()
		gorunen.append("elkoy")
	_karar_anahtarlari = gorunen
	var chr := _gelen.chr_sorgusu()
	if chr != null:
		_karar_anahtarlari = PackedStringArray()
		for karar in gorunen:
			if not preload("res://src/kapi/chr_karar_matrisi.gd").matriste_var_mi(chr, StringName(karar)):
				continue
			if chr.karar_acik(StringName(karar)) or karar == "kabul":
				_karar_anahtarlari.append(karar)
	_karar_anahtarlari = preload("res://src/arayuz/aile_kapi_paneli.gd").secenekler(_gelen, _karar_anahtarlari)
	for n in _karar_anahtarlari.size():
		var anahtar := _karar_anahtarlari[n]
		var b := _dugme("%d · %s" % [n + 1, _karar_etiketi(anahtar)])
		b.doku = Sanat.doku("ui", "icon_decision_%s_48" % KARAR_SIMGE.get(anahtar, "accept"))
		b.custom_minimum_size.y = 80
		b.punto = ayarlar.boyut(30)
		b.alt_yazi = _karar_alt_yazi(anahtar)
		preload("res://src/arayuz/chr_kapi_adaptoru.gd").karar_kilidi(b, chr, StringName(anahtar))
		HeyetKapiPaneli.kilit(b, oturum, _gelen, anahtar)
		var ulak = preload("res://src/sistemler/sancak_ulagi.gd")
		if ulak.ilgilenir(_gelen): b.disabled = not ulak.uygun(oturum, _gelen, anahtar)
		preload("res://src/kapi/hastalik_teshis_adaptoru.gd").kilit(b, oturum, _gelen, StringName(anahtar))
		b.pressed.connect(_karar_bas.bind(anahtar))
		_karar_dugmeleri.append(b)
	OdakHalkasi.bagla(_karar_dugmeleri)
	# Eylemler (defterin altı) hemen görünür; yalnız kararlar sırayla belirir.
	if heybe_acik:
		_heybe_dugmesi()
	if oturum.perde == 1 and _sorulan.size() < mini(_gelen.soru_siniri(oturum.ayarlar.azami_soru), _gelen.sorular.size()):
		var g := _dugme(tr("arayuz.kapi.sohbete_don"), _eylemler)
		g.pressed.connect(_sohbet_goster)
	if not ILK_GECE.etkin(oturum, _gelen):
		preload("res://src/kapi/hastalik_teshis_adaptoru.gd").eylem(self, _gelen, _eylemler)
	_sirayla_goster(_karar_dugmeleri)


## Karar satırının altındaki küçük, tarafsız bilgi (sonucu söylemez).
func _karar_alt_yazi(anahtar: String) -> String:
	if DiplomatikHeyet.ilgilenir(_gelen): return HeyetKapiPaneli.alt(oturum, anahtar)
	if TuccarKapiGecisi.ilgilenir(_gelen): return TuccarKapiPaneli.alt(_gelen, anahtar)
	var sorgu := _gelen.chr_sorgusu()
	if anahtar == "rusvet" and sorgu != null:
		return ", ".join(sorgu.karakter.karar_verisi(&"rusvet").get("esyalar", []))
	if anahtar == "rusvet" and _gelen.heybe != null:
		return tr("heybe.teklif") % _gelen.heybe.teklif
	if anahtar == "elkoy":
		return tr("heybe.yakalandi")
	return ""


## İki adımlı onay: ilk basış seçer, aynı karara ikinci basış verir.
## Kabul ve rüşvette ardından iş yeri seçilir.
func _karar_bas(anahtar: String) -> void:
	if not preload("res://src/kapi/hastalik_teshis_adaptoru.gd").neden(oturum, _gelen, StringName(anahtar)).is_empty(): return
	var sorgu := _gelen.chr_sorgusu()
	if sorgu != null and not sorgu.karar_acik(StringName(anahtar)) and not (anahtar == "cocuklari_al" and preload("res://src/kapi/aile_kafilesi.gd").bolunur(_gelen)):
		return
	if evre != &"karar":
		return
	var ulak = preload("res://src/sistemler/sancak_ulagi.gd")
	if ulak.ilgilenir(_gelen) and not ulak.uygun(oturum, _gelen, anahtar): return
	if _secili == anahtar:
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


func _karar_birak() -> void:
	if evre != &"karar" or _secili == "":
		return
	_secili = ""
	for i in _karar_dugmeleri.size():
		_karar_dugmeleri[i].set_pressed_no_signal(false)
		_karar_dugmeleri[i].text = "%d · %s" % [i + 1, _karar_etiketi(_karar_anahtarlari[i])]
		_karar_dugmeleri[i].queue_redraw()


func _karar_ver(anahtar: String, is_yeri: StringName = &"") -> void:
	if not preload("res://src/sistemler/karar_onayi.gd").izinli(ayarlar, anahtar): return
	if not preload("res://src/kapi/hastalik_teshis_adaptoru.gd").neden(oturum, _gelen, StringName(anahtar)).is_empty(): return
	if DiplomatikHeyet.ilgilenir(_gelen) and not DiplomatikHeyet.karar_olur(oturum, _gelen, StringName(anahtar)): return
	var sorgu := _gelen.chr_sorgusu()
	if sorgu != null and not sorgu.karar_acik(StringName(anahtar)) and not (anahtar == "cocuklari_al" and preload("res://src/kapi/aile_kafilesi.gd").bolunur(_gelen)):
		return
	evre = &"sonuc"
	_temizle()
	_bolum.text = ""
	Ses.cal(&"sfx_onay")
	var dedikodu_once := oturum.dedikodu.yazma_sayisi() if oturum != null else 0
	preload("res://src/kapi/kapi_kavgasi_adaptoru.gd").tanik_hazirla(oturum, _kuyruk)
	var sonuc := oturum.karar_ver(_gelen, StringName(anahtar), is_yeri)
	if not _dil_notlari.is_empty():
		_gelen.set_meta(&"dil_notlari", _dil_notlari.duplicate(true))
	if not sonuc.get("engellendi", false):
		preload("res://src/debug/ilk_saat_kancasi.gd").arac(oturum, "kapi_karar")
	preload("res://src/kapi/hastalik_teshis_adaptoru.gd").sonuc_yaz(self, sonuc)
	if not sonuc.get("engellendi", false):
		hatirlanma_notunu_bildir({
			"hafiza": bool(sonuc.get("hafiza_yazildi", false)) or bool(sonuc.get("aile_bolundu", false)),
			"dedikodu": bool(sonuc.get("dedikodu_yazildi", false)) or (oturum != null and oturum.dedikodu.yazma_sayisi() > dedikodu_once),
			"kacis_hafiza": bool(sonuc.get("kacis_hafiza", false)),
		})
	set_meta(&"sonuclanan_gelen", _gelen)
	if anahtar == "rusvet" or anahtar == "elkoy":
		Ses.cal(&"sfx_kese")
	Ses.cal(&"sfx_kapi_acilir" if sonuc["kaldi"] else &"sfx_kapi_kapanir", -4.0)
	var replik := preload("res://src/kapi/karar_replik_adaptoru.gd")
	if preload("res://src/arayuz/aile_kapi_paneli.gd").sonuc(self, _gelen, sonuc): pass
	elif HeyetKapiPaneli.sonuc(self, _gelen, sonuc): pass
	elif TuccarKapiPaneli.sonuc(self, _gelen, sonuc): pass
	elif sonuc.get("oba_ziyareti", false) or sonuc.get("ulak_ziyareti", false):
		_yaz(tr(String(sonuc.sonuc_anahtari)))
	elif replik.ilgilendirir(anahtar):
		_karar_replik_dusur(replik, anahtar)
	else:
		_yaz(tr("anlati.sonuc." + anahtar) % tr(_gelen.ad_anahtari))
	if sonuc["kaldi"] and not sonuc.get("tuccar", false):
		_yaz("[i]%s[/i]" % (tr("anlati.koy.yazildi") % tr(_gelen.ad_anahtari)))
	if sonuc.get("harc", false):
		_yaz("[i][color=#C4843A]%s[/color][/i]" % (tr("anlati.harc") % oturum.yonetim.a.harc_akce))
	if not sonuc.get("alinan", []).is_empty():
		var parca: PackedStringArray = []
		for a in sonuc["alinan"]:
			parca.append(_esya_yazisi({"id": a["id"], "tur": "akce" if a["id"] == "akce" else ""}, int(a["adet"])))
		_yaz("[i]%s[/i]" % (tr("anlati.heybe.alinan") % ", ".join(parca)))
	if sonuc.get("gasp", false):
		_yaz("[i][color=#C4843A]%s[/color][/i]" % tr("anlati.heybe.gasp"))
	preload("res://src/kapi/es_yorumu_adaptoru.gd").karar_verildi(self, _gelen, StringName(anahtar))
	if sonuc.get("durust_arandi", false):
		_yaz("[i][color=#C4843A]%s[/color][/i]" % tr("anlati.heybe.durust"))
	if not replik.ilgilendirir(anahtar) and _gelen.yanitlar.has(anahtar):
		_yaz("[b]%s:[/b] %s" % [tr(_gelen.ad_anahtari), str(_gelen.yanitlar[anahtar])])
	preload("res://src/kapi/kapi_kavgasi_adaptoru.gd").sonuc_yaz(self, sonuc)
	hud.guncelle()
	_daralt(false)
	_adim_sesi(8)
	await sahne.gelen_git(sonuc["kaldi"], _gelen.tehlikeli or not _gelen.adli)
	# İki gelen arasında sırada bir şey olabilir.
	var so := KapiFirtinaKuyrugu.sira_olayi(oturum, sahne, _kuyruk.size(), _kuyruk)
	if so != null and await _sira_olayi(so):
		return
	_siradaki()


## BUG-03: rüşvet ve ret satırını kutuya yazar, mevcut foley ile konuşturur.
func _karar_replik_dusur(adaptoru: GDScript, anahtar: String) -> void:
	var paket: Dictionary = adaptoru.uygula(_gelen, anahtar)
	for satir in paket["satirlar"]:
		_yaz(String(satir))
	var metin := String(paket["metin"])
	if sahne != null and not metin.is_empty():
		sahne.gelen_konus(clampf(metin.length() / 28.0, 1.5, 5.0))


## Sıra olayı: kuyrukta olan canlandırılır, bekçi seçer, sonucu oynar. Bar kırıldıysa true.
func _sira_olayi(o: OlayVerisi) -> bool:
	var anahtar := String(o.kosullar.get("canlandirma", ""))
	var model := SiraOlayiKisisi.sec(sahne, anahtar)
	if model == null or not SiraOlayiSonucu.baslayabilir(self, o, model): return false
	var kisi := GuvenliMetin.metin(SiraOlayiKisisi.anahtar(model))
	evre = &"sira"
	_temizle()
	_kayit.clear()
	KonusmaGecmisi.ziyaret_basi(_kayit)
	_ad.text = tr("arayuz.kapi.sira")
	_sinif.text = tr(o.baslik_anahtari)
	_levha_ad.text = tr(o.baslik_anahtari)
	_bolum.text = tr("arayuz.kapi.karar")
	_bilgi_yaz()
	Ses.cal(&"sfx_olay")
	if o.ses != &"":
		Ses.cal(o.ses, -3.0)
	_yaz("[i]%s[/i]" % SiraOlayiKisisi.metin(o.metin_anahtari, kisi))
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
	var sonuc := SiraOlayiSonucu.uygula(self, o, i, model)
	if sonuc.get("engellendi", false): return false
	var etki: Dictionary = sonuc.etki
	_yaz(SiraOlayiKisisi.metin(sonuc["sonuc_anahtari"], kisi))
	if int(etki.get("kuyruk", 0)) < 0 and _kuyruk.size() > 0:
		# Sahnede kuyruktan ayrılan, görünen kuyruğun sonundaki kişidir; gecenin listesinden de o çıkar.
		_kuyruk.remove_at(mini(_kuyruk.size(), KapiSahnesi.KUYRUK_GORUNEN) - 1)
		_bilgi_yaz()
	_bilgi_yaz()
	hud.guncelle()
	if await preload("res://src/kapi/sira_atlama_adaptoru.gd").uygula(self, anahtar, etki):
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
	b.alt_punto = ayarlar.boyut(Kabuk.KUCUK)
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
	var bekle := preload("res://src/arayuz/soz/belirme_baglantisi.gd").satir_ms(ayarlar, oturum.ayarlar.belirme_ms) / 1000.0
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
	s = preload("res://src/kapi/hastalik_teshis_adaptoru.gd").kayit_metni(_kayit, s)
	_kayit.append_text(s + "\n")


func _input(olay: InputEvent) -> void:
	if _heybe_paneli != null or has_node("ChrInceleme"):
		return
	if KonusmaGecmisi.kaydir(_kayit, olay):
		get_viewport().set_input_as_handled()
		return
	# Belirme sürerken bir basış atlamadır: kalanlar görünür, hiçbiri seçilmez (Girdi kural 17).
	if _beliriyor and (olay.is_action_pressed("ui_accept") or (olay is InputEventMouseButton and olay.pressed)):
		_tumunu_goster()
		get_viewport().set_input_as_handled()


func _unhandled_input(olay: InputEvent) -> void:
	if _heybe_paneli != null or has_node("ChrInceleme"):
		return
	if evre == &"karar" and olay.is_action_pressed("kapi_kabul"):
		_karar_bas("kabul")
		get_viewport().set_input_as_handled()
		return
	if evre == &"karar" and olay.is_action_pressed("kapi_ret"):
		_karar_bas("ret")
		get_viewport().set_input_as_handled()
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
	if olay.is_action_pressed("geri"):
		get_viewport().set_input_as_handled()
		if evre == &"karar" and _secili != "":
			_karar_birak()
		else:
			duraklat_istendi.emit()
	elif olay.is_action_pressed("menu"):
		get_viewport().set_input_as_handled()
		duraklat_istendi.emit()


## DYL-06: Gelenle ortak dil yoksa ve uygun tercüman köyde varsa tercüman düğmesi görünür.
func tercuman_dugmesi_gorunur_mu(bayrak: bool = true) -> bool:
	if bool(_tercuman_durumu.get("aktif", false)):
		return false
	return DilEngeli.oturum_dugme_sayisi(oturum, _gelen, bayrak) == 1


func _tercuman_dugmesi_ekle() -> void:
	var t := _dugme("— Tercüman çağır (−2 sabır)", _eylemler)
	t.name = &"TercumanCagir"
	t.pressed.connect(_tercuman_cagir)


func _tercuman_cagir() -> void:
	if evre != &"sohbet" or not tercuman_dugmesi_gorunur_mu():
		return
	var sonuc := DilEngeli.oturumda_tercuman_cagir(oturum, _gelen, _dil_sabri)
	if not bool(sonuc.get("olur", false)):
		return
	_tercuman_durumu = sonuc
	_dil_sabri = int(sonuc.get("kalan_sabir", _dil_sabri))
	var ad := String(sonuc.get("koylu_ad", "Köylü"))
	_yaz("[i][color=#82C4C4]%s tercüman olarak çağrıldı (sabır −2).[/color][/i]" % ad)
	_sohbet_goster()



## DIY-14: Kapı kararında hafıza veya dedikodu yazıldığında 2 sn "Bu hatırlanacak" notunu açar.
func _hatirlanma_notu_al() -> Control:
	if _hatirlanma_notu == null or not is_instance_valid(_hatirlanma_notu):
		_hatirlanma_notu = HATIRLANMA_NOTU.new()
		_hatirlanma_notu.name = "HatirlanmaNotu"
		_hatirlanma_notu.z_index = 40
		_hatirlanma_notu.position = Vector2(360, 28)
		add_child(_hatirlanma_notu)
	if ayarlar != null:
		_hatirlanma_notu.set("bildirim_acik", bool(ayarlar.degerler.get(&"hatirlanma_notu", true)))
	return _hatirlanma_notu


func hatirlanma_notunu_bildir(olay: Dictionary, kayit_islemi: Callable = Callable()) -> Dictionary:
	return _hatirlanma_notu_al().call("secim_bildir", olay, kayit_islemi)
