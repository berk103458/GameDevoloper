## SOY-SON-01 (Claude-Berk): kritik söylentiler gerçek Oturum yolunda açılır ve kapanır.
## Başlatıcı gece kartı Oturum.olay_uygula ile uygulanır → söylenti ağa köydeki tanıkla girer;
## kapanış kartı rastgele havuzda yoktur, `kapanis_gecesi` dolunca Oturum.olay_sec onu getirir;
## kapanış seçimi Oturum.olay_uygula ile söylentiyi hükme bağlar. Kayıt/yükleme sonrası da sürer.
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var tablo := SoylentiKapanisi.tablo()
	_dene(tablo.size() == 5, "Beş kritik söylenti veride (%d)" % tablo.size())
	for anahtar in tablo:
		_dene(kat.olay(StringName(String(tablo[anahtar].baslatan))) != null and kat.olay(StringName(String(tablo[anahtar].kapanis))) != null, "%s başlatıcı ve kapanış kartı katalogda" % anahtar)

	# Kapanış kartları söylenti yokken rastgele gelmez.
	var o := Oturum.new(kat, 77)
	o.ayarlar.olay_olasiligi = 1.0
	for i in 4:
		o.yonetim.kabul({"ad": "Köylü %d" % i, "sinif": "ciftci", "stat": 5})
	o.gun = 6
	var rastgele_kapanis := 0
	for i in 80:
		var x := o.olay_sec()
		if x != null and SoylentiKapanisi.tanimli(x):
			rastgele_kapanis += 1
	_dene(rastgele_kapanis == 0, "Söylenti yokken kapanış kartı çıkmaz (%d)" % rastgele_kapanis)

	# Her kritik söylenti: başlat → bekle → kapanış → hüküm.
	for anahtar in tablo:
		var t := Oturum.new(kat, 91)
		for i in 6:
			t.yonetim.kabul({"ad": "Köylü %d" % i, "sinif": "ciftci", "stat": 5})
		t.gun = 4
		var baslatan := kat.olay(StringName(String(tablo[anahtar].baslatan)))
		t.olay_uygula(baslatan, 0)
		var a: SoylentiAgi = SoylentiKoprusu.ag(t)
		var k: Dictionary = a.ag_kayitlari.get(anahtar, {})
		_dene(bool(k.get("kritik", false)) and String(k.get("kaynak", "")).is_valid_int() and t.yonetim.koylu(int(k.kaynak)) != null, "%s: başlatıcı kart söylentiyi köydeki tanıkla açar" % anahtar)
		var kaynak := String(k.get("kaynak", ""))
		var guven_once := a.guvenilirlik_al(kaynak)
		_dene(not SoylentiKapanisi.tanimli(t.olay_sec()), "%s: aynı gece kapanış gelmez" % anahtar)
		t.gun += 1
		SoylentiKoprusu.gece(t, {"olaylar": []})
		_dene(not SoylentiKapanisi.tanimli(t.olay_sec()), "%s: bir gece sonra kapanış henüz gelmez" % anahtar)
		_dene(SoylentiKoprusu.meclis_sikayeti(t).is_empty(), "%s: kritik söylenti genel meclis şikâyetine düşmez" % anahtar)
		var defter := SoylentiKoprusu.defter_satirlari(t)
		_dene(defter.any(func(s: Dictionary) -> bool: return String(s.id) == "soy:" + anahtar and not String(s.olay).is_empty()), "%s: defterde kapanış başlığıyla anılır" % anahtar)
		# Kayıt/yükleme olgunlaşmayı korur.
		t = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(t.kaydet())))
		t.ayarlar.olay_olasiligi = 1.0
		t.gun += 1
		var kart := t.olay_sec()
		_dene(kart != null and String(kart.id) == String(tablo[anahtar].kapanis), "%s: %d gece sonra kapanış kartı gelir (%s)" % [anahtar, int(SoylentiKapanisi._ayar().kapanis_gecesi), String(kart.id) if kart != null else "yok"])
		if kart == null:
			continue
		t.olay_uygula(kart, 0)
		a = SoylentiKoprusu.ag(t)
		k = a.ag_kayitlari.get(anahtar, {})
		_dene(bool(k.get("hukme_baglandi", false)) and bool(k.get("cozuldu", false)) and String(k.get("cozum_secimi", "")) == "adalet", "%s: kapanış seçimi söylentiyi hükme bağlar" % anahtar)
		_dene(a.guvenilirlik_al(kaynak) == mini(guven_once + 1, int(a._ayar("azami_guvenilirlik"))), "%s: tanığın sözü sınandı" % anahtar)
		t.gun += 1
		var tekrar := 0
		for i in 30:
			var y := t.olay_sec()
			if y != null and SoylentiKapanisi.tanimli(y):
				tekrar += 1
		_dene(tekrar == 0, "%s: kapanış ikinci kez gelmez" % anahtar)

	# Tanık yoksa söylenti açılmaz.
	var bos := Oturum.new(kat, 5)
	bos.olay_uygula(kat.olay(&"ambarda_hirsizlik"), 0)
	_dene(not SoylentiKoprusu.ag(bos).ag_kayitlari.has("degirmen_un"), "Köyde tanık yokken söylenti açılmaz")

	print("SOY-SON-01 OYUN: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(1 if hata > 0 else 0)


func _dene(v: bool, ad: String) -> void:
	if v:
		print("  ok: " + ad)
	else:
		hata += 1
		push_error(ad)
