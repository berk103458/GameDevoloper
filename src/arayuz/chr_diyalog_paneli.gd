## CHR sorgu ağacı; kilitli JSON diyalog motoruna yazmaz.
extends VBoxContainer

signal karar_istendi
var sorgu: RefCounted
var oturum: Oturum
var ayarlar: Ayarlar
var baglam: Dictionary = {}
var _ton_tepkisi := ""
var _zar_ipucu := ""
const TON = preload("res://src/soz/muhafiz_tonu.gd")

func _ready() -> void:
	sorgu.ipucu_bulundu.connect(func(_ipucu: StringName) -> void: guncelle())
	guncelle()

func guncelle() -> void:
	for cocuk in get_children():
		remove_child(cocuk)
		cocuk.queue_free()
	var dugum: Dictionary = sorgu.karakter.diyalog_dugumu(sorgu.dugum_id)
	if not TON.dugum_hatalari(dugum, sorgu.karakter.metinler).is_empty():
		var hata := Label.new()
		hata.text = "Konuşma seçeneklerinin ton verisi eksik."
		add_child(hata)
		return
	if not _ton_tepkisi.is_empty():
		var cevap := Label.new()
		cevap.text = _ton_tepkisi
		cevap.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		add_child(cevap)
	var durum := preload("res://src/arayuz/kapi/tansiyon_gostergesi.gd").new()
	durum.name = "TansiyonGostergesi"
	durum.sorgu = sorgu
	add_child(durum)
	if not sorgu.son_zar.is_empty():
		var sonuc := Label.new()
		var yak_ad := "İkna"
		match String(sorgu.son_zar["beceri"]):
			"blof": yak_ad = "Blöf"
			"gozdagi": yak_ad = "Gözdağı"
			"gonul_alma": yak_ad = "Gönül alma"
		sonuc.text = "%s: %s" % [yak_ad, "başarılı" if sorgu.son_zar["basarili"] else "başarısız — tansiyon arttı"]
		add_child(sonuc)
		if not _zar_ipucu.is_empty():
			var ipucu_lbl := Label.new()
			ipucu_lbl.name = "ZarIpucuNotu"
			ipucu_lbl.text = _zar_ipucu
			ipucu_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			add_child(ipucu_lbl)
	var replik := Label.new()
	replik.text = sorgu.metin(StringName(dugum.get("replik_anahtari", "")))
	replik.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	replik.add_theme_font_size_override("font_size", Kabuk.GOVDE)
	var replik_kaydir := ScrollContainer.new()
	replik_kaydir.name = "replik_kaydir"
	replik_kaydir.custom_minimum_size.y = 72
	replik_kaydir.size_flags_vertical = Control.SIZE_EXPAND_FILL
	replik_kaydir.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	replik.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	replik_kaydir.add_child(replik)
	add_child(replik_kaydir)
	if sorgu.replik_baslat():
		preload("res://src/sistemler/chr_sorgu_sesi.gd").cal(sorgu.karakter, replik.text)
	var secenekler: Array = dugum.get("secenekler", [])
	var acik_var := false
	for i in secenekler.size():
		var secenek: Dictionary = secenekler[i]
		if not TON.gorunur(oturum, secenek): continue
		if not secenek.get("gerekli_ipuclari", []).is_empty() and not preload("res://src/soz/celiski.gd").yardim_acik_mi(oturum, ayarlar):
			continue
		var b := Button.new()
		b.name = "Secenek%d" % i
		b.text = sorgu.metin(StringName(TON.anahtar(oturum, secenek)))
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.custom_minimum_size.y = 80
		b.disabled = not sorgu.secenek_acik(secenek, i)
		acik_var = acik_var or not b.disabled
		if not secenek.get("gerekli_ipuclari", []).is_empty():
			b.tooltip_text = "Önce nişan, yük veya fiziksel izi incele" if b.disabled else "Bulunan kanıtla yüzleş"
			if not b.disabled:
				b.modulate = Kabuk.vurgu()
		b.pressed.connect(func() -> void:
			_zar_ipucu = ""
			if sorgu.secenek_sec(i, baglam):
				_ton_tepkisi = TON.tepki(oturum, secenek, baglam)
				if not sorgu.son_zar.is_empty():
					var z_res := preload("res://src/kapi/zar_ipucu.gd").oturumda_goster(oturum, ayarlar)
					if int(z_res.get("ipucu_sayisi", 0)) > 0:
						_zar_ipucu = String(z_res.get("metin", ""))
				guncelle()
		)
		add_child(b)
		if not String(secenek.get("beceri", "")).is_empty() and not b.disabled and sorgu.has_method("yaklasim_degistiricisi"):
			var deg: Dictionary = sorgu.yaklasim_degistiricisi(secenek, baglam)
			var satirlar: Array = deg.get("satirlar", [])
			if not satirlar.is_empty():
				var liste := VBoxContainer.new()
				liste.name = "ZarDegistiriciler%d" % i
				for satir in satirlar:
					if satir is Dictionary:
						var lbl := Label.new()
						var d_val := int(satir.get("deger", 0))
						lbl.text = "%s (%+d)" % [String(satir.get("metin", "")), d_val] if d_val != 0 else String(satir.get("metin", ""))
						liste.add_child(lbl)
				add_child(liste)
	if not secenekler.is_empty() and not acik_var:
		# Tüm cevaplar denenmiş ya da ipucu kilitli: oyuncu sıkışmasın, kanıt aramadan karara geçebilsin.
		var cikis := Button.new()
		cikis.name = "KilitliKarar"
		cikis.text = "Kararını ver"
		cikis.tooltip_text = "Söylenecek söz kalmadı; ipucu bulursan yüzleşebilirsin."
		cikis.custom_minimum_size.y = 70
		cikis.pressed.connect(func() -> void: karar_istendi.emit())
		add_child(cikis)
	if secenekler.is_empty():
		var karar := Button.new()
		var gecis_var: bool = not dugum.get("gecisler", []).is_empty()
		karar.text = "Devam et" if gecis_var else "Kararını ver"
		karar.custom_minimum_size.y = 70
		karar.pressed.connect(func() -> void:
			if gecis_var:
				if sorgu.devam_et():
					guncelle()
			else:
				karar_istendi.emit()
		)
		add_child(karar)
