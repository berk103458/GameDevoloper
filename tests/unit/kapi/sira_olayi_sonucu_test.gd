extends SceneTree
class KuyrukEkrani extends Node:
	var oturum: Oturum
	var sahne: KapiSahnesi
	var _kuyruk: Array[Gelen] = []
var hata := 0
var kat: Katalog
var olay: OlayVerisi
func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	olay = load("res://data/sira_olaylari/sira_bayilma.tres") as OlayVerisi
	_oran()
	_yardim()
	_sonuclar()
	print("SIRA SONUÇ: GEÇTİ" if hata == 0 else "SIRA SONUÇ: KALDI")
	quit(hata)
func hazir() -> KuyrukEkrani:
	var e := KuyrukEkrani.new()
	e.oturum = Oturum.new(kat, 2020)
	e.sahne = KapiSahnesi.new()
	e.oturum.yonetim.a = e.oturum.yonetim.a.duplicate(true)
	e.oturum.yonetim.a.iyilesme = 0
	e.oturum.yonetim.a.evsiz_moral = 0
	for i in 4:
		var g := Gelen.new()
		g.ad_anahtari = "Sıra kişisi %d" % i
		g.sinif = &"ciftci"
		e._kuyruk.append(g)
		var m := KarakterModel.new()
		SiraOlayiKisisi.model_kur(m, "ciftci_kadin" if i == 2 else "ciftci")
		e.sahne._kuyruktakiler.append(m)
	return e
func temizle(e: KuyrukEkrani) -> void:
	for k in e.sahne._kuyruktakiler: k.free()
	e.sahne.free()
	e.free()
func _oran() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 2020
	var sayilar := {"olum":0,"sakatlik":0,"ayrilma":0,"toparlanma":0}
	for i in 1000: sayilar[SiraOlayiSonucu.sec(rng)] += 1
	for tur in sayilar:
		var sapma := absf(float(sayilar[tur]) / 1000.0 - float(SiraOlayiSonucu.AYAR.agirliklar[tur]))
		dene(sayilar[tur] > 0 and sapma < 0.03, "%s 1000 zar sapması < yüzde3" % tur)
	print("1000 zar: ", sayilar)
func _yardim() -> void:
	var e := hazir()
	var o := e.oturum
	var model := e.sahne._kuyruktakiler[2]
	o.ambar = 0
	var once := JSON.stringify(o.kaydet())
	dene(not o.secenek_olur(olay, 0), "Kaynaksız yardım kapalı")
	dene(SiraOlayiSonucu.uygula(e, olay, 0, model).get("engellendi", false) and JSON.stringify(o.kaydet()) == once, "API kaynaksız seçimi atomik reddeder")
	o.ambar = 3
	var rng := o._rng.state
	var r := SiraOlayiSonucu.uygula(e, olay, 0, model)
	dene(o.ambar == 2 and r.etki.sira_sonuc == "yardim" and o._rng.state == rng, "Yardım gerçek 1 erzak, sonuç RNG yok")
	dene(not SiraOlayiSonucu.baslayabilir(e, olay, model), "Aynı kişinin ikinci bayılma canlandırması engelli")
	var kaynak := olay.secenek_etkileri[0]
	dene(not kaynak.has("sira_sonuc"), "Paylaşılan olay kaynağı değişmez")
	once = JSON.stringify(o.kaydet())
	dene(SiraOlayiSonucu.uygula(e, olay, 0, model).get("engellendi", false) and JSON.stringify(o.kaydet()) == once, "Çift seçim ücret/rapor tekrarı yok")
	dene(SiraOlayiSonucu.durum(o.yonetim).size() == 1, "Bir yardım raporu")
	temizle(e)
func _sonuclar() -> void:
	var eski: Dictionary = SiraOlayiSonucu.AYAR.agirliklar.duplicate()
	for tur in eski:
		SiraOlayiSonucu.AYAR.agirliklar = {tur:1.0}
		var e := hazir()
		var o := e.oturum
		var g := e._kuyruk[2]
		var model := e.sahne._kuyruktakiler[2]
		var r := SiraOlayiSonucu.uygula(e, olay, 1, model)
		dene(r.etki.sira_sonuc == tur, "Veri ayarlı gerçek sonuç " + tur)
		var snap := KapiAnlikGoruntusu.gelen_kaydet(g)
		var geri := KapiAnlikGoruntusu.gelen_yukle(JSON.parse_string(JSON.stringify(snap)), kat)
		dene(geri != null and geri.get_meta(SiraOlayiSonucu.META, {}).get("sonuc") == tur, "Gelen snapshot sonucu korur")
		if tur in ["olum", "ayrilma"]:
			dene(not g in e._kuyruk and e._kuyruk.size() == 3, "Aynı gerçek kişi listeden çıktı")
			dene(o.karar_ver(g, &"kabul").get("engellendi", false) and o.yonetim.nufus() == 0, "Ölen/ayrılan kişi köylü olamaz")
		else:
			dene(g in e._kuyruk and e._kuyruk.size() == 4, "Toparlanan/sakat kişi listede")
			var kabul := o.karar_ver(g, &"kabul")
			var k := o.yonetim.koylu(int(kabul.koylu_id))
			dene(k != null and k.saglik == (int(SiraOlayiSonucu.AYAR.sakat_saglik) if tur == "sakatlik" else 100), "Gerçek kabulde doğru sağlık")
		var kayit := JSON.parse_string(JSON.stringify(o.kaydet())) as Dictionary
		var yuklu := Oturum.kayittan(kat, kayit)
		dene(yuklu != null and SiraOlayiSonucu.durum(yuklu.yonetim) == SiraOlayiSonucu.durum(o.yonetim), "Gece öncesi pending rapor kayıt dönüşü")
		var yuklu_rapor: Dictionary = yuklu.gece_sonu().rapor
		dene(SiraOlayiSonucu.durum(yuklu.yonetim).is_empty(), "Yüklenmiş pending rapor bir kez tüketilir")
		var rapor: Dictionary = o.gece_sonu().rapor
		dene(yuklu_rapor.olenler == rapor.olenler, "Restore ölüm sayısı değişmez")
		var satir := 0
		for d in rapor.olaylar:
			if d.get("sira_sonuc", false): satir += 1
		dene(satir == 1 and SiraOlayiSonucu.durum(o.yonetim).is_empty(), "Tek gece raporu ve tüketim")
		if tur == "olum":
			dene(rapor.olenler == ["Sıra kişisi 2"] and rapor.cenaze.sayi == 1 and CenazeYasi.bekliyor(o.yonetim), "Ölüm mevcut cenaze KRI-05 bir kez")
			var adet: int = rapor.olenler.size()
			SiraOlayiSonucu.rapora_ekle(o.yonetim, rapor)
			dene(rapor.olenler.size() == adet, "Rapor tekrar okununca ikinci ölüm yok")
			var sonraki: Dictionary = o.gece_sonu().rapor
			dene(sonraki.olenler.is_empty() and sonraki.cenaze.secim == "toplu_mezar", "Ertesi gece ikinci cenaze üretmez, mevcut karar yürür")
		else: dene(rapor.olenler.is_empty() and not rapor.has("cenaze"), "Ölümsüz sonuç cenaze üretmez")
		temizle(e)
	SiraOlayiSonucu.AYAR.agirliklar = eski
	dene(SiraOlayiSonucu.oku(null).is_empty() and SiraOlayiSonucu.oku([{"sonuc":"olum"}]).is_empty(), "Legacy/bozuk optional rapor etkisiz")
func dene(ok: bool, ad: String) -> void:
	if not ok:
		hata += 1
		push_error(ad)
