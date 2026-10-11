extends SceneTree

var hata := 0
var kat: Katalog

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1601)
	dene(not o._kosul_tutar({"bina_var": ["ambar"]}), "Ambar yokken kart kapalı")
	dene(not o._kosul_tutar({"nufus_en_az": 2}), "Gerçek nüfus eşiği")
	dene(not o._kosul_tutar({"cocuk_var": true}), "Çocuksuz köyde çocuk olayı kapalı")
	dene(not o._kosul_tutar({"yas_grubu": "yasli"}), "Yaş grubu yokken kapalı")
	dene(not o._kosul_tutar({"bilinmeyen_kosul": 1}), "Tanınmayan koşul kapalı")
	var b := KoyBinasi.new()
	b.tur = "ambar"
	o.yonetim.binalar.append(b)
	var kisi := o.yonetim.kabul({"ad": "Çocuk", "yas_grubu": "cocuk"})
	kisi.yas_grubu = &"cocuk"
	dene(o._kosul_tutar({"bina_var": ["ambar"], "nufus_en_az": 1, "cocuk_var": true, "yas_grubu": "cocuk"}), "Dört koşul birlikte sağlanır")
	b.insa_kalan = 1
	dene(not o._kosul_tutar({"bina_var": "ambar"}), "İnşa halindeki bina yeterli değil")
	dene(preload("res://src/sistemler/olay_on_kosulu.gd").dogrula({"bilinmeyen": 1}).size() == 1, "Bilinmeyen koşul tam bir doğrulama hatası")
	_secim_ve_kayit()
	print("OLAY ÖN KOŞUL: GEÇTİ" if hata == 0 else "OLAY ÖN KOŞUL: KALDI")
	quit(hata)

func _secim_ve_kayit() -> void:
	# Gerçek ağırlıklı seçiciyi yalnız iki kartlık kontrollü katalogla çalıştır.
	var kart := OlayVerisi.new()
	kart.id = &"test_ambar"
	kart.tek_sefer = false
	kart.kosullar = {"bina_var": ["ambar"]}
	kat._olaylar = {kart.id: kart}
	kat.ayarlar = kat.ayarlar.duplicate(true)
	kat.ayarlar.olay_olasiligi = 1.0
	var o := Oturum.new(kat, 1616)
	var secilen := 0
	for i in 100:
		o.gun = i
		if o.olay_sec() != null: secilen += 1
	dene(secilen == 0, "100 gecede ambarsız kart 0; boş havuz null")
	var b := KoyBinasi.new()
	b.id = 999
	b.tur = "ambar"
	o.yonetim.binalar.append(b)
	dene(o.olay_sec() == kart, "Uygun kart mevcut seçicide seçilir")
	var diger := OlayVerisi.new()
	diger.id = &"test_serbest"
	diger.tek_sefer = false
	kat._olaylar[diger.id] = diger
	var tekrar := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(tekrar != null, "Kayıt yeniden açılır")
	if tekrar != null:
		for i in 100:
			dene(o.olay_sec().id == tekrar.olay_sec().id, "Kayıt RNG aynı kimliği seçer")
		o.yonetim.binalar.clear()
		tekrar.yonetim.binalar.clear()
		for i in 100:
			dene(o.olay_sec() == diger and tekrar.olay_sec() == diger, "Bina kaldırılınca ertesi seçim koşula yeniden bakar")

func dene(ok: bool, mesaj: String) -> void:
	if not ok:
		hata += 1
		print("KALDI: " + mesaj)
