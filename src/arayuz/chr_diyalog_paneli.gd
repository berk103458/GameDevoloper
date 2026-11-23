## CHR sorgu ağacı; kilitli JSON diyalog motoruna yazmaz.
extends VBoxContainer

signal karar_istendi
## ZAR-03: tansiyon eşiği aşıldı; kapı ziyareti "kaçtı" kararıyla kapatır.
signal kacis_istendi
var sorgu: RefCounted
var kapi_sozu: SozMotoru
var oturum: Oturum
var ayarlar: Ayarlar
# Konuşma tepkisi bağlamı. Zar için ChrSorgusu.zar_baglami kullanılır.
var baglam: Dictionary = {}
var _ton_tepkisi := ""
var _zar_ipucu := ""
const TON = preload("res://src/soz/muhafiz_tonu.gd")

func _ready() -> void:
	sorgu.ipucu_bulundu.connect(func(_ipucu: StringName) -> void: guncelle())
	guncelle()

func _heybe_acik_mi() -> bool:
	var p: Node = get_parent()
	while p != null:
		if p.has_method("heybe_acik_mi"):
			return bool(p.call("heybe_acik_mi"))
		p = p.get_parent()
	return false


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
		var sozcuk := "başarılı" if sorgu.son_zar["basarili"] else "başarısız — tansiyon arttı"
		var soz_anahtari := String(sorgu.son_zar.get("sozcuk", ""))
		if soz_anahtari.begins_with("ZAR_"):
			sozcuk = tr("diyalog.zar." + soz_anahtari.trim_prefix("ZAR_").to_lower())
		if sorgu.son_zar.has("gerekli"):
			sonuc.name = "ZarSonucu"
			sonuc.text = "%s — %s: %d, gereken %d+ · %s" % [yak_ad, String(sorgu.son_zar.get("tur", "d6")), int(sorgu.son_zar["zar"]), int(sorgu.son_zar["gerekli"]), sozcuk]
		else:
			sonuc.text = "%s: %s" % [yak_ad, sozcuk]
		add_child(sonuc)
		if not _zar_ipucu.is_empty():
			var ipucu_lbl := Label.new()
			ipucu_lbl.name = "ZarIpucuNotu"
			ipucu_lbl.text = _zar_ipucu
			ipucu_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			add_child(ipucu_lbl)
	var replik := Label.new()
	var replik_anahtari := String(dugum.get("replik_anahtari", ""))
	replik.text = sorgu.metin(StringName(replik_anahtari))
	if kapi_sozu != null and not replik.text.is_empty():
		replik.text = kapi_sozu.kapi_satir(replik_anahtari)
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
		var secim_anahtari := TON.anahtar(oturum, secenek)
		b.text = SozMotoru.kapi_metni(secim_anahtari) if kapi_sozu != null else sorgu.metin(StringName(secim_anahtari))
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.custom_minimum_size.y = 80
		b.disabled = not sorgu.secenek_acik(secenek, i)
		if b.disabled and sorgu.has_method("zar_kilitli") and sorgu.zar_kilitli(secenek):
			var kilit_sozu := tr("diyalog.zar.kilitli")
			b.tooltip_text = kilit_sozu if b.tooltip_text.is_empty() else "%s — %s" % [b.tooltip_text, kilit_sozu]
		acik_var = acik_var or not b.disabled
		if not secenek.get("gerekli_ipuclari", []).is_empty():
			b.tooltip_text = "Önce nişan, yük veya fiziksel izi incele" if b.disabled else "Bulunan kanıtla yüzleş"
			if not b.disabled:
				b.modulate = Kabuk.vurgu()
		b.pressed.connect(func() -> void:
			if _heybe_acik_mi():
				return
			_zar_ipucu = ""
			var sec := Callable(sorgu, "secenek_sec").bind(i)
			var olustu: bool = kapi_sozu.kapi_chr_secim("chr_soru", secim_anahtari, sec) if kapi_sozu != null else sec.call()
			if olustu:
				if sorgu.has_method("kacti") and sorgu.kacti():
					kacis_istendi.emit()
					return
				_ton_tepkisi = TON.tepki(oturum, secenek, baglam)
				if not sorgu.son_zar.is_empty():
					var z_res := preload("res://src/kapi/zar_ipucu.gd").oturumda_goster(oturum, ayarlar)
					if int(z_res.get("ipucu_sayisi", 0)) > 0:
						_zar_ipucu = String(z_res.get("metin", ""))
					var z_tur := StringName(sorgu.son_zar.get("tur", "d6"))
					var kok: Node = self
					while kok != null and not (kok is KapiEkrani):
						kok = kok.get_parent()
					await ZarAtisiAnimasyonu.oynat(kok if kok is Control else self, z_tur, ayarlar, int(sorgu.son_zar.get("zar", 0)))
				guncelle()
		)
		add_child(b)
		if not String(secenek.get("beceri", "")).is_empty() and not b.disabled and sorgu.has_method("yaklasim_degistiricisi"):
			var deg: Dictionary = sorgu.yaklasim_degistiricisi(secenek)
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
		cikis.text = tr("arayuz.sohbet.karar_ver")
		cikis.tooltip_text = "Söylenecek söz kalmadı; ipucu bulursan yüzleşebilirsin."
		cikis.custom_minimum_size.y = 70
		cikis.pressed.connect(func() -> void:
			if _heybe_acik_mi(): return
			karar_istendi.emit()
		)
		add_child(cikis)
	if secenekler.is_empty():
		var karar := Button.new()
		var gecis_var: bool = not dugum.get("gecisler", []).is_empty()
		karar.text = tr("arayuz.olay.devam") if gecis_var else tr("arayuz.sohbet.karar_ver")
		karar.custom_minimum_size.y = 70
		karar.pressed.connect(func() -> void:
			if _heybe_acik_mi():
				return
			if gecis_var:
				var devam := Callable(sorgu, "devam_et")
				if kapi_sozu.kapi_chr_secim("chr_devam", "devam", devam) if kapi_sozu != null else devam.call():
					guncelle()
			else:
				karar_istendi.emit()
		)
		add_child(karar)
