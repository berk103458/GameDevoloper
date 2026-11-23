## ZAR-01, ZAR-03, ZAR-04, DEN-19: görünür zar ve tansiyon kaçışı gerçek kapı ekranında, CHR paneli düğmesiyle.
extends Node

var hata := 0


func _kontrol(kosul: bool, ad: String) -> void:
	if kosul:
		print("GEÇTİ: ", ad)
	else:
		hata += 1
		push_error("KALDI: " + ad)


func _tohum(tur: StringName, yuz: int) -> int:
	var t := 0
	while true:
		var r := RandomNumberGenerator.new()
		r.seed = t
		if SorguZari.at(r, tur) == yuz:
			return t
		t += 1
	return t


func _panel(n: Node) -> Node:
	if n.has_signal(&"kacis_istendi"):
		return n
	for c in n.get_children():
		var p := _panel(c)
		if p != null:
			return p
	return null


func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 641)
	o.muhafiz_tecrubesi = 12
	var kok := Control.new()
	kok.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var a := Ayarlar.new()
	kok.theme = Tema.olustur(a)
	add_child(kok)
	var e := KapiEkrani.new()
	e.oturum = o
	e.ayarlar = a
	kok.add_child(e)
	await get_tree().process_frame
	var g := o._adli_gelen(&"chr_001")
	o.grup_itibari.uygula("asker", 8)
	e._gelen = g
	e.evre = &"sohbet"
	e._sohbet_goster()
	await get_tree().process_frame
	var s := g.chr_sorgusu()
	var panel := _panel(e)
	_kontrol(panel != null and s.zar_baglami.has("terazi"), "Kapı adaptörü CHR panelini ve zar bağlamını kuruyor")
	_kontrol(panel != null and not panel.kacis_istendi.get_connections().is_empty(), "Kaçış sinyali kapı ekranına bağlı")

	# ZAR-01 + ZAR-04: zar SorguZari ile atılır; sayı, gerekli değer ve söz panelde görünür.
	s._dugume_git(&"1.1")
	var tansiyon_once: int = s.tansiyon
	_kontrol(o.grup_itibari.zar_etkisi("asker") == -1 and s.zar_baglami.itibar == 1, "Yüksek grup itibarı zar eşiğini düşürür")
	var deg: Dictionary = s.yaklasim_degistiricisi(s.karakter.diyalog_dugumu(s.dugum_id)["secenekler"][1], {})
	_kontrol(deg.satirlar.any(func(r: Dictionary) -> bool: return String(r.tur) == "tecrube" and String(r.metin) == String(TranslationServer.translate("zar.degistirici.tecrube"))), "Tecrübe satırı zar.degistirici.tecrube anahtarından geliyor")
	s.tohumla(_tohum(s.zar_turu(), 6))
	panel.guncelle()
	var liste := panel.find_child("ZarDegistiriciler1", true, false)
	var itibar_yazisi := String(TranslationServer.translate("zar.degistirici.grup_itibari"))
	_kontrol(liste != null and liste.get_children().any(func(r: Label) -> bool: return itibar_yazisi + " (-1)" in r.text), "Gerçek panel grup itibarı eksi bir satırını gösteriyor")
	var tecrube_yazisi := String(TranslationServer.translate("zar.degistirici.tecrube"))
	_kontrol(liste != null and liste.get_child_count() > 0 and tecrube_yazisi in String(liste.get_child(liste.get_child_count() - 1).text), "Panel tecrübe satırını anahtardan yazıyor")
	var b := panel.find_child("Secenek1", true, false) as Button
	_kontrol(b != null and not b.disabled, "Beceri seçeneği açık")
	if b != null:
		b.pressed.emit()
	await get_tree().process_frame
	var beklenen := SorguZari.gerekli(s.karakter.sorgu_degeri, tansiyon_once, int(deg.toplam), s.kurallar)
	_kontrol(int(s.son_zar.get("zar", 0)) == 6 and int(s.son_zar.get("gerekli", 0)) == beklenen and bool(s.son_zar.get("basarili", false)), "Zar 6 tavan; gerekli değer ZAR-01 formülü")
	var zar_lbl := panel.find_child("ZarSonucu", true, false) as Label
	_kontrol(zar_lbl != null and ": 6, gereken %d+" % beklenen in zar_lbl.text and "başarılı" in zar_lbl.text, "Panel zar sayısını, gerekeni ve sözü yazıyor")

	_kontrol(s.son_zar.get("degistirici_satirlari", []).any(func(r: Dictionary) -> bool: return r.tur == "grup_itibari" and r.deger == -1), "Atılan zar önizlemedeki grup itibarı değerini kullanıyor")

	# Ek bağlam verilirse ön kontrol ve atış aynı tavanı kullanır.
	var baglamli := ChrSorgusu.new(s.karakter.duplicate())
	baglamli.karakter.sorgu_degeri = 6
	baglamli.karakter.zar = "d6"
	baglamli.tansiyon = 0
	baglamli._dugume_git(&"1.1")
	var secenek: Dictionary = baglamli.karakter.diyalog_dugumu(&"1.1").secenekler[1]
	var destek := {"itibar": 1}
	_kontrol(not baglamli.secenek_acik(secenek, 1) and baglamli.secenek_acik(secenek, 1, destek), "Ek itibar tavandaki kilidi açabiliyor")
	_kontrol(baglamli.secenek_sec(1, destek) and baglamli.son_zar.get("gerekli") == 6, "Aynı bağlam zar atışını da açıyor")

	# Kilit: gerekli tavanı aşınca seçenek kapanır, zar atılmaz.
	var kilit := preload("res://src/sistemler/chr_sorgusu.gd").new(s.karakter.duplicate())
	kilit.karakter.sorgu_degeri = 20
	kilit._dugume_git(&"1.1")
	_kontrol(kilit.zar_kilitli(kilit.karakter.diyalog_dugumu(kilit.dugum_id)["secenekler"][1]) and not kilit.secenek_acik(kilit.karakter.diyalog_dugumu(kilit.dugum_id)["secenekler"][1], 1) and not kilit.secenek_sec(1), "Tavanı aşan zar kilitli")
	var eski_deger: int = s.karakter.sorgu_degeri
	s.karakter.sorgu_degeri = 20
	s._dugume_git(&"1.1")
	s._denemeler.clear()
	panel.guncelle()
	var kilitli := panel.find_child("Secenek1", true, false) as Button
	_kontrol(kilitli != null and kilitli.disabled and String(TranslationServer.translate("diyalog.zar.kilitli")) in kilitli.tooltip_text, "Kilitli seçenek ZAR_KILITLI sözünü gösteriyor")
	s.karakter.sorgu_degeri = eski_deger
	s._denemeler.clear()

	# ZAR-03 + DEN-19: tansiyon 9 + başarısız zar eşiği aşar; ziyaret kaçışla biter.
	var ret_once: int = o.yonetim.ret_sayisi
	var akce_once := o.muhafiz_akce
	var kamu_once := o.koy_akce
	var kuyruk_once := e._kuyruk.size()
	s.tansiyon = 3
	s._dugume_git(&"1.1")
	s.tansiyon = 10
	s._denemeler.clear()
	s.tohumla(_tohum(s.zar_turu(), 1))
	panel.guncelle()
	await get_tree().process_frame
	b = panel.find_child("Secenek1", true, false) as Button
	_kontrol(b != null and not b.disabled, "Tansiyon 10'da beceri seçeneği hâlâ açık (aynı düğüm)")
	if b != null:
		b.pressed.emit()
	_kontrol(s.kacti() and not s.karar_acik(&"kabul") and not s.karar_acik(&"ret"), "Eşik aşıldı: Flag_Kacti, karar düğmeleri kapalı")
	var bekle := 0
	while e.get_meta(&"sonuclanan_gelen", null) != g and bekle < 400:
		await get_tree().process_frame
		bekle += 1
	_kontrol(e.get_meta(&"sonuclanan_gelen", null) == g, "Kaçış ziyareti kapatıyor")
	_kontrol(o.yonetim.ret_sayisi == ret_once, "Kaçış ret sayısını artırmıyor")
	_kontrol(o.muhafiz_akce == akce_once and o.koy_akce == kamu_once, "Kaçışta muhafız kasası ve köy kasası değişmiyor (DEN-19)")
	_kontrol(String(o.kadro.durumlar[g.id].get("son_karar", "")) == String(SorguZari.KARAR_KACTI), "Kadroya kaçtı yazıldı")
	_kontrol(e._kuyruk.size() <= kuyruk_once, "Kuyruk sıradakine geçti")
	# Başka artış: panik kilidinde çelişki/yemin/söylenti artışı tansiyon_artir ile eşiği aşar, ekran ziyareti kapatır.
	await get_tree().create_timer(0.3).timeout
	var g2 := o._adli_gelen(&"chr_002")
	e._gelen = g2
	e.evre = &"sohbet"
	e._sohbet_goster()
	await get_tree().process_frame
	var s2 := g2.chr_sorgusu()
	s2.tansiyon = 10
	var ret2: int = o.yonetim.ret_sayisi
	_kontrol(not s2.tansiyon_artir(0) and not s2.kacti(), "Tansiyon 10'da +0 artış kaçırmıyor")
	_kontrol(s2.tansiyon_artir(1) and s2.kacti(), "Tansiyon 10'da +1 artış kaçırıyor")
	bekle = 0
	while e.get_meta(&"sonuclanan_gelen", null) != g2 and bekle < 400:
		await get_tree().process_frame
		bekle += 1
	_kontrol(e.get_meta(&"sonuclanan_gelen", null) == g2 and o.yonetim.ret_sayisi == ret2, "Zarsız artışla kaçış da ziyareti kapatıyor, ret yazmıyor")
	print("ZAR OYUN BAGLANTI: ", "GEÇTİ" if hata == 0 else "KALDI")
	get_tree().quit(hata)
