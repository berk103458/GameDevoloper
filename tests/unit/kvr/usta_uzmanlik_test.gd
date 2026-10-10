## BUG-0001 regresyonu: gerçek zanaatı olan CHR, eski üçlü sınıftan yanlış usta bayrağı almaz.
extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1010)
	var y := o.yonetim
	# Otacı Dudu (esnaf sınıfı): usta ise Şifahane uzmanlığı "cerrah", asla "demirci".
	var g := o._adli_gelen(&"chr_008")
	g.stat = 8
	var dudu := y.koylu(o.karar_ver(g, &"kabul").koylu_id)
	_kontrol(dudu != null and not "usta_demirci" in dudu.bayraklar, "Otacı CHR usta_demirci almaz")
	_kontrol(dudu != null and "usta_cerrah" in dudu.bayraklar, "Otacı CHR Şifahane uzmanlığıyla usta")
	# Sayfasında gizli ustalığı olan CHR (Haydar, CHR_029) otomatik açık bayrak almaz;
	# ustalık sorguda açılınca işe yarar (mevcut tasarım). Zanaat eşlemesi yine doğrudur.
	for id in [&"chr_003", &"chr_029"]:
		g = o._adli_gelen(id)
		g.stat = 8
		_kontrol(o._uzmanlik_bayragi(g).is_empty() and "usta_demirci" in g.gizli_bayraklar, "Gizli CHR ustalığı otomatik açılmaz: " + id)
	g = o._adli_gelen(&"chr_003")
	g.stat = 8
	_kontrol(o._usta_uzmanlik(g) == "cerrah", "Cerrah CHR zanaat eşlemesi")
	g = o._adli_gelen(&"chr_029")
	g.stat = 8
	_kontrol(o._usta_uzmanlik(g) == "demirci", "Demirci CHR zanaat eşlemesi")
	# Adsız gelenlerde eski sınıf eşlemesi değişmez.
	var adsiz := Gelen.new()
	adsiz.ad_anahtari = "Usta esnaf"
	adsiz.sinif = &"esnaf"
	adsiz.stat = 8
	var esnaf := y.koylu(o.karar_ver(adsiz, &"kabul").koylu_id)
	_kontrol(esnaf != null and "usta_demirci" in esnaf.bayraklar, "Adsız esnaf eski usta_demirci eşlemesi")
	# Düşük beceri usta sayılmaz.
	g = o._adli_gelen(&"chr_008")
	g.stat = 5
	_kontrol(o._usta_uzmanlik(g) == "", "Beceri 7 altı usta bayrağı yok")
	print("USTA UZMANLIK: GEÇTİ" if hata == 0 else "USTA UZMANLIK: KALDI")
	quit(hata)
func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
