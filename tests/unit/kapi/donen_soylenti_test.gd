extends SceneTree
## SOY-24: dönen ve duyan adlı karakter dal 1; ilk ziyaret, duymayan veya ağsız dal 0.
## Çevrilmiş cümleye bakılmaz.

var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _initialize() -> void:
	if _kos() != true:
		hata += 1
		push_error("SOY-24: test bitmedi")
	print("SOY-24 GECTI" if hata == 0 else "SOY-24 KALDI (%d)" % hata)
	quit(1 if hata > 0 else 0)


func _kos() -> bool:
	var kat := Katalog.new()
	kat.yukle()
	_ilk_ziyaret_duymus(kat)
	_ikinci_ziyaret_duymus(kat)
	_ikinci_ziyaret_duymamis(kat)
	_ag_yok(kat)
	return true


func _ilk_ziyaret_duymus(kat: Katalog) -> void:
	var o := Oturum.new(kat, 2401)
	var g := o._adli_gelen(&"chr_001")
	o.ziyaret_basladi(g)
	_duyur(o, String(g.id))
	var secim := DonenSoylenti.sec(o, g)
	dene(int(secim.get("dal", -1)) == 0, "İlk ziyaret duymuş olsa da dal 0")
	dene(String(secim.get("id", "")) == "", "İlk ziyarette dal kimliği yok")
	dene(DonenSoylenti.satirlar(o, g).is_empty(), "İlk ziyarette satır yok")


func _ikinci_ziyaret_duymus(kat: Katalog) -> void:
	var o := Oturum.new(kat, 2402)
	var g := o._adli_gelen(&"chr_001")
	o.ziyaret_basladi(g)
	var karar := o.karar_ver(g, &"kabul")
	dene(bool(karar.get("kaldi", false)), "İlk geliş kabul ile köye girer")
	var koylu_id := int(karar.get("koylu_id", -1))
	var k := o.yonetim.koylu(koylu_id)
	dene(k != null and k.adli_id == g.id, "Kabul edilen köylünün adlı kimliği gelenle aynı")
	var g2 := o._adli_gelen(&"chr_001")
	o.ziyaret_basladi(g2)
	_duyur(o, str(koylu_id))
	var secim := DonenSoylenti.sec(o, g2)
	dene(int(secim.get("dal", 0)) == 1, "İkinci ziyaret ve duymuş dal 1")
	dene(String(secim.get("id", "")) == "donen_soylenti", "Dal kimliği donen_soylenti")
	dene(String(secim.get("metin_anahtari", "")) == "kapi.donen.soylenti", "Metin anahtarı kapi.donen.soylenti")
	dene(DonenSoylenti.satirlar(o, g2).size() == 1, "Dönen duyan tek satır söyler")


func _ikinci_ziyaret_duymamis(kat: Katalog) -> void:
	var o := Oturum.new(kat, 2403)
	var g := o._adli_gelen(&"chr_001")
	o.ziyaret_basladi(g)
	o.karar_ver(g, &"ret")
	var g2 := o._adli_gelen(&"chr_001")
	o.ziyaret_basladi(g2)
	_duyur(o, "baska")
	var secim := DonenSoylenti.sec(o, g2)
	dene(int(secim.get("dal", -1)) == 0, "İkinci ziyaret duymamış dal 0")
	dene(DonenSoylenti.satirlar(o, g2).is_empty(), "Duymayan satır söylemez")


func _ag_yok(kat: Katalog) -> void:
	var o := Oturum.new(kat, 2404)
	var g := o._adli_gelen(&"chr_001")
	o.ziyaret_basladi(g)
	o.karar_ver(g, &"ret")
	var g2 := o._adli_gelen(&"chr_001")
	o.ziyaret_basladi(g2)
	dene(not o.has_meta(SoylentiKoprusu.META), "Karar yolu ağı kendiliğinden kurmaz")
	var secim := DonenSoylenti.sec(o, g2)
	dene(int(secim.get("dal", -1)) == 0, "Ağ yokken dal 0")
	dene(not o.has_meta(SoylentiKoprusu.META), "Seçim ağı kurmaz")
	dene(DonenSoylenti.satirlar(o, g2).is_empty() and not o.has_meta(SoylentiKoprusu.META), "Satır okuması da ağı kurmaz")


func _duyur(o: Oturum, kimlik: String) -> void:
	var ag: RefCounted = SoylentiKoprusu.ag(o)
	ag.soylenti_ekle("kapi_donen", "haksiz_ret", "0", true, {"gece": 2})
	var kayit: Dictionary = ag.ag_kayitlari["kapi_donen"]
	var duyanlar: Array = kayit.get("duyanlar", [])
	if not kimlik in duyanlar:
		duyanlar.append(kimlik)
	kayit["duyanlar"] = duyanlar
