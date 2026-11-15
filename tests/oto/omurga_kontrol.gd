## OMR-55: Kapanış testi — iki perde tek koşu.
## Beş iddia: nüfus 18'e ulaşılır, geçiş gecesi kapı kapalıdır, üç dalgada ≥ 3 yüz gelir,
## son beş nihai sondan biridir, kayıt `son.nihai` yazar.
extends Node

const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const KAPI = preload("res://src/sistemler/kapi_acilis_olayi.gd")
const DIS_HAT = preload("res://src/sistemler/dis_hat_kapisi.gd")
const NIHAI = preload("res://src/sistemler/nihai_son.gd")
const AZAMI_ADIM := 80

var hata := 0


func dene(kosul: bool, mesaj: String) -> void:
	if kosul:
		print("PASS: " + mesaj)
	else:
		hata += 1
		push_error("KALDI: " + mesaj)


func _ready() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 3535)
	ACILIS.kur(o)
	_bolluk_kur(o)
	KAPI.baslat(o)
	KAPI.ulak_bitir(o)

	var nufus_18 := false
	var gecis_kapali := false
	var gecis_goruldu := false
	var dalga_yuzleri := {1: 0, 2: 0, 3: 0}
	var yuz_kimlikleri: Array = Omurga.yuz_eslemesi().values()
	yuz_kimlikleri.append(String(preload("res://src/sistemler/sancak_ulagi.gd").ID)) # OMR-32: uygun yüz yoksa ulak gelir
	var son := ""
	for _adim in AZAMI_ADIM:
		var y := o.yonetim
		if y.nufus() >= y.a.agalik_nufus:
			nufus_18 = true
		if y.agalik and GecisGecesi.gecis_gecesi_mi(y):
			gecis_goruldu = true
			gecis_kapali = o.gece_kuyrugu().is_empty()
		var kuyruk := o.gece_kuyrugu()
		if y.agalik and not GecisGecesi.gecis_gecesi_mi(y):
			var d := DIS_HAT.dalga(y)
			for g in kuyruk:
				if String(g.id) in yuz_kimlikleri or String(g.sinif) in yuz_kimlikleri:
					dalga_yuzleri[d] = int(dalga_yuzleri.get(d, 0)) + 1
		var alindi := false
		for gelen in kuyruk:
			if not y.agalik and not alindi and not gelen.tehlikeli and gelen.secenekler.has("kabul"):
				o.ziyaret_basladi(gelen)
				alindi = bool(o.karar_ver(gelen, &"kabul").get("kaldi", false))
		y.kaynaklar.ekle("gida", 150)
		y.kaynaklar.ekle("su", 150)
		if y.huzur() < 70:
			y.as_dagit()
		TekfurHaracHeyeti.ode(y)
		var sonuc := o.gece_sonu()
		son = String(sonuc.get("son", ""))
		if not son.is_empty() or sonuc.get("engellendi", false):
			break

	var toplam_yuz := 0
	var bos_dalga := 0
	for d in [1, 2, 3]:
		toplam_yuz += int(dalga_yuzleri[d])
		if int(dalga_yuzleri[d]) == 0:
			bos_dalga += 1
	print("Dalga yüzleri: ", dalga_yuzleri, " son: ", son, " gece: ", o.gun)

	dene(nufus_18, "OMR-55: otomatik oyuncu nüfus 18'e ulaşır")
	dene(gecis_goruldu and gecis_kapali, "OMR-55: geçiş gecesi kapı kapalıdır")
	dene(toplam_yuz >= 3 and bos_dalga == 0, "OMR-55: üç dalgada ≥ 3 yüz gelir (%d, yüzsüz dalga %d)" % [toplam_yuz, bos_dalga])
	var nihai := NIHAI.son(o, StringName(son))
	var bes_son: Array = NIHAI.AYAR.sonlar.keys()
	dene(nihai in bes_son, "OMR-55: son beşten biridir (%s → %s)" % [son, nihai])
	var kayit: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	SonKaydi.kayda_son_ekle(kayit, NIHAI.son_metni(o, StringName(son), {"baslik": "", "metin": ""}))
	kayit = JSON.parse_string(JSON.stringify(kayit))
	dene(String(SonKaydi.kayittan_nihai_al(kayit)) == nihai and not nihai.is_empty(), "OMR-55: kayıt son.nihai yazar")

	print("OMURGA KONTROL: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	get_tree().quit(0 if hata == 0 else 1)


## Tempo koşusunda açlık ve evsizlik omurgayı maskelemesin (omurga_ikiz_kontrol ile aynı kurulum).
func _bolluk_kur(o: Oturum) -> void:
	o.yonetim.binalar[0].seviye = 40
	o.yonetim.akce = 100
	var ambar := KoyBinasi.new()
	ambar.tur = "ambar"
	ambar.hucre = Vector2i(0, 4)
	ambar.id = o.yonetim._sonraki_id
	ambar.seviye = 25
	o.yonetim._sonraki_id += 1
	o.yonetim.binalar.append(ambar)
	o.yonetim.izgara.yerlestir(ambar.id, ambar.hucreler(o.yonetim.katalog))
	o.yonetim._ambar_kapasitesi()
	o.yonetim.kaynaklar.ekle("bugday", 60)
