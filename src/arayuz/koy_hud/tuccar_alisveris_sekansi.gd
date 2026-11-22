## Uçtan uca tüccar karşılama, sohbet, pazarlık, hayvan (koyun dahil) ve mal alışverişi sekansı.
class_name TuccarAlisverisSekansi
extends RefCounted

const AD := "TuccarSekansKart"
const EkHayvan := preload("res://src/koy/ticaret/ek_hayvan_pazari.gd")


static func pazar_satiri_ekle(e: KoyEkrani, ust: Control) -> void:
	if e == null or e._y == null or ust == null:
		return
	var ozet_l := e._etiket(ust, EkHayvan.ozet_metni(e._y), Tema.KUCUK_PX)
	ozet_l.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	var b := e._dugme("Tüccar Kervanı ile Görüş & Hayvan / Mal Alışverişi", ust)
	b.name = "tuccar_sekans_dugmesi"
	b.pressed.connect(func() -> void:
		ac(e)
	)


static func ac(e: KoyEkrani, onceki_not: String = "") -> void:
	if e == null or e._y == null or e.oturum == null:
		return
	var y := e._y
	var bilgi := EkHayvan.tuccar_bilgisi(y)
	var kervan_acik := EkHayvan.tuccar_koyde_mi(y)
	var ust: VBoxContainer = e._kart_ac("Tüccar Kervanı · %s" % String(bilgi["ad"]))
	if e._ust_kart != null:
		e._ust_kart.name = AD
	var v: VBoxContainer = PazarKartKaydirma.kur(e, ust)

	var durum_satiri := ""
	if kervan_acik:
		var selam := "Kervan sur dışına konakladı. Hayvan ve erzak tezgahları açık (Kasada %d akçe, boş ambar %d)." % [y.akce, y.kaynaklar.bos_yer()]
		if bool(bilgi.get("oncu", false)):
			selam = "Öncü kervan ilk günlerde kapı dışına tezgah açtı; %d gün buradayız. (Kasa: %d akçe, Boş ambar: %d)" % [int(bilgi.get("kalan", 1)), y.akce, y.kaynaklar.bos_yer()]
		durum_satiri = "%s · Uzmanlık: %s\n%s" % [String(bilgi["ad"]), String(bilgi.get("uzmanlik", "")), selam]
	else:
		durum_satiri = "Kervan şu an yolda. Sıradaki tüccar (%s) %d. günde varacak." % [String(bilgi["ad"]), int(bilgi.get("sonraki_gun", 4))]

	var giris_l := e._etiket(v, durum_satiri, Tema.KUCUK_PX)
	giris_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	giris_l.add_theme_color_override("font_color", Kabuk.yazi())

	var yanit_l := e._etiket(v, onceki_not if not onceki_not.is_empty() else "Tüccar: 'Hoş geldin muhafız bey! Sürüye koyun, keçi, eşek ya da köye mal gerekirse pazarlık edelim.'", Tema.KUCUK_PX)
	yanit_l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	yanit_l.add_theme_color_override("font_color", Kabuk.BAR_DOLU)

	var diyalog_satir := HBoxContainer.new()
	v.add_child(diyalog_satir)
	var havadis_d := e._dugme("▸ Yol Havadisi Sor", diyalog_satir)
	havadis_d.pressed.connect(func() -> void:
		var haber := _havadis_metni(y, String(bilgi.get("id", "")))
		ac(e, haber)
	)
	var pazarlik_meta := "pazarlik_yapildi_g_%d" % (y.gun / maxi(1, y.a.kervan_araligi))
	var pazarlik_yapildi := bool(y.get_meta(pazarlik_meta, false))
	var pazarlik_d := e._dugme("▸ Pazarlık Et (Ziyaret Payı)" if not pazarlik_yapildi else "Pazarlık Yapıldı ✓", diyalog_satir)
	pazarlik_d.disabled = (not kervan_acik) or pazarlik_yapildi
	pazarlik_d.pressed.connect(func() -> void:
		y.set_meta(pazarlik_meta, true)
		var indirim := 5
		y.akce += indirim
		Ses.cal(&"sfx_kese")
		e.hud.guncelle()
		ac(e, "Tüccar: 'Sözün eri muhafızmışsın; yol hakkı ve peşin iskonto olarak kasaya %d akçe geri yazdım.'" % indirim)
	)

	var h1 := e._etiket(v, "1) Canlı Hayvan Pazarı (%s)" % EkHayvan.ozet_metni(y), Tema.KUCUK_PX)
	h1.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	for tur in EkHayvan.TURLER:
		var bilgi_h: Dictionary = EkHayvan.HAYVANLAR[tur]
		var satir := HBoxContainer.new()
		v.add_child(satir)
		var aciklama := e._etiket(satir, "%s (%d/%d) — %s" % [
			String(bilgi_h["ad"]),
			EkHayvan.sayi(y, tur),
			EkHayvan.kapasite(y, tur),
			String(bilgi_h["katki_ozet"]),
		], Tema.KUCUK_PX)
		aciklama.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		aciklama.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		var al_d := e._dugme("Al · %d akçe" % int(bilgi_h["fiyat"]), satir)
		al_d.name = "ek_hayvan_al_" + tur
		al_d.disabled = not EkHayvan.alinabilir(y, tur)
		al_d.pressed.connect(func() -> void:
			if EkHayvan.al(y, tur):
				Ses.cal(&"sfx_kese")
				e.sahne3b.yenile()
				e.hud.guncelle()
				ac(e, "Yeni bir %s köye alındı! Her gece doğrudan ürün katkısı verecek." % String(bilgi_h["ad"]))
		)
		var sat_d := e._dugme("Sat · %d akçe" % int(bilgi_h["satis"]), satir)
		sat_d.name = "ek_hayvan_sat_" + tur
		sat_d.disabled = not EkHayvan.satilabilir(y, tur)
		sat_d.pressed.connect(func() -> void:
			if EkHayvan.sat(y, tur):
				Ses.cal(&"sfx_kese")
				e.sahne3b.yenile()
				e.hud.guncelle()
				ac(e, "Bir %s tüccara satıldı; %d akçe köy kasasına eklendi." % [String(bilgi_h["ad"]), int(bilgi_h["satis"])])
		)

	if CelepHamdullah.geldi(y):
		var celep_l := e._etiket(v, "Celep Ahır/Ağıl Hayvanları (Ahır veya Ağıl gerektirir):", Tema.KUCUK_PX)
		celep_l.add_theme_color_override("font_color", Kabuk.SOLUK)
		var c_satir := HBoxContainer.new()
		v.add_child(c_satir)
		for tur in CelepHamdullah.AYAR.hayvanlar:
			var ct := String(tur)
			var cb := e._dugme("%s · %d akçe" % [CelepHamdullah.AYAR.hayvanlar[ct].ad, CekiLojistigi.FIYAT[ct]], c_satir)
			cb.disabled = not y.lojistik.alinabilir(y, ct)
			cb.pressed.connect(func() -> void:
				if y.lojistik.al(y, ct):
					Ses.cal(&"sfx_kese")
					e.sahne3b.yenile()
					e.hud.guncelle()
					ac(e, "%s köye teslim edildi." % CelepHamdullah.AYAR.hayvanlar[ct].ad)
			)

	var h2 := e._etiket(v, "2) Tüccar Erzak & Malzeme Alışı ve Köy Fazlası Satışı", Tema.KUCUK_PX)
	h2.add_theme_color_override("font_color", Kabuk.BAR_DOLU)
	var al_satir := HBoxContainer.new()
	v.add_child(al_satir)
	for erzak in [["gida", "Gıda +10", 14], ["odun", "Odun +10", 12], ["tas", "Taş +10", 16], ["saman", "Saman +10", 6]]:
		var tur_ad := String(erzak[0])
		var etiket_ad := String(erzak[1])
		var bedel := int(erzak[2])
		var ed := e._dugme("%s (%d akçe)" % [etiket_ad, bedel], al_satir)
		ed.disabled = (not kervan_acik) or y.akce < bedel or y.kaynaklar.bos_yer() < 10
		ed.pressed.connect(func() -> void:
			if kervan_acik and y.akce >= bedel and y.kaynaklar.bos_yer() >= 10:
				y.akce -= bedel
				y.kaynaklar.ekle(tur_ad, 10)
				Ses.cal(&"sfx_kese")
				e.hud.guncelle()
				ac(e, "Kervandan 10 %s alındı (-%d akçe)." % [tur_ad, bedel])
		)

	var uzman_urunler := GezginTuccarStogu.urunler(y)
	if not uzman_urunler.is_empty():
		var u_satir := HBoxContainer.new()
		v.add_child(u_satir)
		for u_tur in uzman_urunler:
			var ut := String(u_tur)
			var u_veri: Dictionary = uzman_urunler[ut]
			var ub := e._dugme("%s (%d) · %d akçe" % [String(u_veri.get("ad", ut)), y.gezgin_ticaret.kalan(y, ut), int(u_veri.get("fiyat", 5))], u_satir)
			ub.disabled = not y.gezgin_ticaret.alinabilir(y, ut, 1)
			ub.pressed.connect(func() -> void:
				if y.gezgin_ticaret.al(y, ut, 1):
					Ses.cal(&"sfx_kese")
					e.hud.guncelle()
					ac(e, "Uzman stoğundan 1 %s alındı." % String(u_veri.get("ad", ut)))
			)

	var sat_satir := HBoxContainer.new()
	v.add_child(sat_satir)
	for satis_tur in ["odun", "tas", "gida", "kereste"]:
		var st := String(satis_tur)
		var sb := e._dugme("%s 5 Sat" % TranslationServer.translate("koy.kaynak." + st), sat_satir)
		sb.disabled = (not kervan_acik) or not PazarSatisi.uygun(e.oturum, st, 5, false, false)
		sb.pressed.connect(func() -> void:
			var r := PazarSatisi.uygula(e.oturum, st, 5, false, false)
			if int(r.get("akce", 0)) > 0:
				Ses.cal(&"sfx_kese")
				e.hud.guncelle()
				ac(e, "Tüccara 5 %s satıldı (+%d akçe köy kasasına)." % [TranslationServer.translate("koy.kaynak." + st), int(r["akce"])])
		)

	var alt := HBoxContainer.new()
	alt.add_theme_constant_override("separation", 12)
	ust.add_child(alt)
	var pazara_don := e._dugme("← Pazara Dön", alt)
	pazara_don.pressed.connect(func() -> void:
		e._kart_kapat()
		e._pazar_ac()
	)
	var kapat := e._dugme(TranslationServer.translate("arayuz.olay.devam"), alt)
	kapat.pressed.connect(e._kart_kapat)
	kapat.grab_focus.call_deferred()


static func _havadis_metni(y: KoyYonetimi, tid: String) -> String:
	if y != null and y.kis_mi():
		return "Tüccar: 'Balkanlardan ayaz erken indi; sürüsü, otu ve yakacağı tam olan köyler kışı kayıpsız atlatıyor.'"
	match tid:
		"celep_hamdullah":
			return "Celep Hamdullah: 'Öküz tarlayı şenlendirir, koyun ile keçi hem sofrayı hem keçeyi besler. Çiftçine hayvan almadan büyüme yavaş kalır.'"
		"nalbur":
			return "Nalbur: 'Demir çivisi eksik dam fırtınada uçar; taş ocağının ve demirhanenin el aleti hep tam olsun.'"
		"kumasci_aktar":
			return "Kumaşçı ve Aktar: 'Yollarda öksürük salgını dolaşır; afyon ile sargı olmadan hekimin eli yarım kalır.'"
		"silah_tuccari":
			return "Silah Tüccarı: 'Dağ eşkıyası kervan gözlüyor muhafız; kalkan ve zırh almadan devriye çıkarma.'"
		_:
			return "Öncü Kervan: 'Büyük Celep Hamdullah ve diğer tüccar kafileleri her 4 günde bir buradan geçecek; şimdiden sürü ve stok kurmak iyidir.'"
