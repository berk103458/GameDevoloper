extends SceneTree
const A = preload("res://src/soz/yemin_adaptoru.gd")
var hata := 0
var kontrol := 0
var kat: Katalog
func _initialize() -> void:
	call_deferred("calistir")
func dene(v: bool, metin: String) -> void:
	kontrol += 1
	if not v:
		hata += 1
		push_error(metin)
func calistir() -> void:
	kat = Katalog.new()
	kat.yukle()
	for f in ["tutumlar", "yanlis", "chr", "kayit_donus"]:
		if call(f) != true: hata += 1
	print("YEMIN OYUN: %s (%d kontrol, %d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", kontrol, hata])
	quit(1 if hata > 0 else 0)
func tutumlar() -> bool:
	for sinif in ["ciftci", "esnaf", "asker", "dervis"]:
		var o := Oturum.new(kat, 42)
		var g := Gelen.new()
		g.sinif = StringName(sinif)
		A.veri_isle(g)
		o.ziyaret_basladi(g)
		dene(A.uygun(g), "Veriden yemin: " + sinif)
		var rng_once := o._rng.state
		var r: Dictionary = A.uygula(o, g)
		dene(r.basarili and r.tutum == g.yemin.tutum, "Gerçek dört tutum")
		dene(r.ipucu == ("yemin_kacamak" if r.tutum == "kivranir" else ""), "Kaçamak yalnız kıvranır")
		dene(("yalan_yemin" in g.gizli_bayraklar) == (r.tutum == "rahat"), "Gizli yalan yalnız rahat")
		dene(not A.uygun(g) and not A.uygula(o, g).basarili, "Ziyaret kilidi")
		dene(not r.zar_atisi and o._rng.state == rng_once and o.soz_kaydi.motor.zar == -1, "Zar yok")
		dene(g.get_meta(KapiFirtinaKuyrugu.BEKLEME).toplam == 1, "Duran tansiyon +1")
		dene(o.soz_kaydi.motor.guven == (1 if g.saygin else 3), "Saygın güven -2")
	var o := Oturum.new(kat, 42)
	var g := Gelen.new()
	g.adli = true # Verisiz karakter: inanç uydurulmaz.
	A.ziyaret(o, g)
	dene(not A.uygun(g) and not A.uygula(o, g, "hristiyan").basarili, "Boş inanç hakaret üretmez")
	return true
func yanlis() -> bool:
	var o := Oturum.new(kat, 42)
	var g := Gelen.new()
	A.veri_isle(g)
	A.ziyaret(o, g)
	var once := o.grup_itibari.deger("koylu")
	var r: Dictionary = A.uygula(o, g, "hristiyan")
	dene(o.soz_kaydi.motor.guven == 0 and o.grup_itibari.deger("koylu") == once - 1, "Yanlış şekil -3/-1")
	dene(r.ipucu == "" and not r.yalan_yemin, "Hakaret yalan kanıtı değildir")
	return true
func chr() -> bool:
	var o := Oturum.new(kat, 42)
	var g := o._adli_gelen(&"chr_001")
	o.ziyaret_basladi(g)
	var s = g.chr_sorgusu()
	var once: int = s.tansiyon
	var zar: Dictionary = s.son_zar.duplicate(true)
	s.bayraklar["Flag_Sir_Tamamen_Cozuldu"] = true
	var r: Dictionary = A.uygula(o, g)
	dene(s.tansiyon == once + 1 and s.son_zar == zar, "Gerçek ChrSorgusu +1; zar yok")
	dene(r.metin == TranslationServer.translate("anlati.yemin.sir_acik") and r.metin != TranslationServer.translate("anlati.yemin.rahat"), "Sır satırı eskisinin yerine")
	var kacamak := o._adli_gelen(&"chr_001")
	o.ziyaret_basladi(kacamak)
	kacamak.yemin = A.TABLO.figurler.esnaf.yemin.duplicate(true)
	A.uygula(o, kacamak)
	dene(kacamak.chr_sorgusu().ipuclari.has(&"Clue_Yemin_Kacamak") and "yemin_kacamak" in kacamak.acik_bayraklar, "Kaçamak gerçek ipucu servisine ve ziyaret bayrağına yazılır")
	return true
func kayit_donus() -> bool:
	var o := Oturum.new(kat, 42)
	var g := Gelen.new()
	g.sinif = &"asker"
	g.secenekler = PackedStringArray(["kabul", "ret"])
	A.veri_isle(g)
	o.ziyaret_basladi(g)
	A.uygula(o, g)
	var r := o.karar_ver(g, &"kabul")
	dene(r.kaldi and o.gecikmeli_kuyruk.any(func(x: Dictionary) -> bool: return x.has("yemin_id")), "Gerçek karar mevcut DYL-08 kuyruğunda")
	var id := String(g.get_meta(A.META).id)
	var kayit := o.kaydet()
	var ikinci := Oturum.kayittan(kat, kayit)
	dene(ikinci != null and ikinci.soz_kaydi.yeminler.has(id), "Yemin oyun kaydından döner")
	if ikinci == null: return false
	ikinci.gun += 3
	var once := ikinci.grup_itibari.deger("asker")
	KararDonusu.ilerlet(ikinci)
	dene(ikinci.grup_itibari.deger("asker") == once - 3, "Gecikmeli haberde ağır itibar kaybı")
	dene(MuhafizTerazisi.durum(ikinci).yemin_kayitlari.size() == 1, "Mevcut terazide tek kayıt")
	dene(not A.bozuldu(ikinci, id), "İkinci bozulma cezası yok")
	var tekrar := Oturum.kayittan(kat, ikinci.kaydet())
	dene(not A.bozuldu(tekrar, id) and MuhafizTerazisi.durum(tekrar).yemin_kayitlari.size() == 1, "Yüklemeden sonra da ceza tek")
	return true
