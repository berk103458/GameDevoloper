extends SceneTree

const DefterSinifi = preload("res://src/sistemler/hafiza_defteri.gd")
const EkranSinifi = preload("res://src/arayuz/hafiza_defteri_ekrani.gd")
const BagSinifi = preload("res://src/arayuz/koy_hud/hafiza_defteri_baglantisi.gd")
const EnjektorSinifi = preload("res://src/debug/hafiza_enjektoru.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("HAFIZA DEFTERI: " + mesaj)


func _initialize() -> void:
	_cekirdek()
	_karar()
	_beyan_soylenti_not()
	_siralama_ve_kayit()
	_ekran()
	_tarama()
	_kapanis()
	if _hata == 0:
		print("HAFIZA DEFTERI (HFZ-01…32): GEÇTİ (0 hata)")
	else:
		print("HAFIZA DEFTERI: KALDI (%d hata)" % _hata)
	quit(_hata)


func _cekirdek() -> void:
	var defter = DefterSinifi.new()
	var bos: Dictionary = defter.oku({})
	_kontrol(bos["sayfa_sayisi"] == 4, "dort sayfa")
	_kontrol((bos["sayfalar"] as Array).size() == 4, "sayfa listesi 4")
	_kontrol((bos["karar"] as Array).is_empty(), "bos karar")
	_kontrol((bos["beyan"] as Array).is_empty(), "bos beyan")
	_kontrol((bos["soylenti"] as Array).is_empty(), "bos soylenti")
	_kontrol((bos["not"] as Array).is_empty(), "bos not")
	_kontrol(defter.yazim_sayisi == 0 and defter.kaynak_yazimi() == 0, "yazim 0")
	_kontrol(defter.bos_anahtari("karar") == "hafiza.bos.karar", "bos anahtar karar")
	_kontrol(defter.bos_anahtari("beyan") == "hafiza.bos.beyan", "bos anahtar beyan")
	_kontrol(defter.bos_anahtari("soylenti") == "hafiza.bos.soylenti", "bos anahtar soylenti")
	_kontrol(defter.bos_anahtari("not") == "hafiza.bos.not", "bos anahtar not")
	_kontrol(defter.sabah_evresinde_acilir_mi() == false, "sabah acilisi yok")
	_kontrol(defter.tavan() == 40, "tavan 40")

	var kaynak := {"iz": "dur", "yil_izi": [{"metin": "kis"}], "gorulen_olaylar": {"kart": true}}
	var once := JSON.stringify(kaynak)
	var yil: Dictionary = defter.oku(kaynak)
	_kontrol(JSON.stringify(kaynak) == once, "okuma kaynagi degistirmez")
	_kontrol(yil["sayfa_sayisi"] == 4, "yil sayfasi yok")
	_kontrol(defter.yazim_sayisi == 0, "olay yazimi 0")


func _karar() -> void:
	var defter = DefterSinifi.new()
	var tetik: Dictionary = defter.oku({
		"diy14": [{"id": "s1", "ad": "Hasan", "kisi": "hasan", "gece": 3, "not_anahtari": "UI_BU_HATIRLANACAK"}],
	})
	_kontrol((tetik["karar"] as Array).size() == 1, "diy14 tetik 1 satir")
	var satir: Dictionary = tetik["karar"][0]
	_kontrol(not String(satir["baslik"]).contains("DIY-"), "baslikta jargon yok")
	_kontrol(not String(satir["baslik"]).contains("HFZ-"), "baslikta hfz yok")
	_kontrol(String(satir["baslik_anahtari"]) == "hafiza.satir.baslik", "baslik anahtari")
	_kontrol(String(satir["baslik"]).begins_with("Hasan"), "baslik kisi adi")

	var yok: Dictionary = defter.oku({"diy14": []})
	_kontrol((yok["karar"] as Array).is_empty(), "tetik 0 satir 0")

	var kabuller: Array = []
	for i in 10:
		kabuller.append({"karar": "kabul", "gece": i, "kisi": "adsiz", "ad": "Adsiz"})
	var adsiz: Dictionary = defter.oku({
		"kabuller": kabuller,
		"durumlar": {"a": {"ad": "Ali", "karar_gecmisi": [{"karar": "ret", "gece": 1}]}},
	})
	_kontrol((adsiz["karar"] as Array).is_empty(), "adsiz kabul satir 0")

	var donus: Dictionary = defter.oku({
		"diy14": [{"id": "s1", "ad": "Hasan", "gece": 3}],
		"dyl08": [{"hedef": "s1", "sonuc_anahtari": "hafiza.sonuc.dondu"}],
	})
	_kontrol((donus["karar"] as Array).size() == 1, "donus yeni satir acmaz")
	_kontrol(String(donus["karar"][0]["sonuc_anahtari"]) == "hafiza.sonuc.dondu", "donus sonucu")

	var hukum: Dictionary = defter.oku({
		"cas07": [{"id": "h1", "kisi": "yusuf", "ad": "Yusuf", "gece": 4, "hukum": "infaz"}],
		"sabah_satirlari": [{"id": "h1", "metin": "sabah kopya"}],
	})
	_kontrol((hukum["karar"] as Array).size() == 1, "hukum tek satir")
	_kontrol(int(hukum["sabah_kopyasi"]) == 0, "sabah kopyasi 0")

	var hat: Dictionary = defter.oku({
		"diy14": [{"id": "o1", "ad": "Bey", "gece": 2, "hat": "sancak"}],
	})
	_kontrol(typeof(hat["karar"][0]["etiket"]) == TYPE_STRING, "etiket metin")
	_kontrol(String(hat["karar"][0]["etiket"]) == "hafiza.etiket.dis_hat", "dis hat etiketi")
	_kontrol(not (hat["karar"][0] as Dictionary).has("sayac"), "yeni sayac yok")

	var jargon: Dictionary = defter.oku({
		"diy14": [{"id": "j", "ad": "Hasan", "gece": 3, "not_anahtari": "DIY-14 tetik"}],
	})
	_kontrol(not String(jargon["karar"][0]["baslik"]).contains("DIY-"), "jargon baslik")
	_kontrol(not String(jargon["karar"][0]["govde_anahtari"]).contains("DIY-"), "jargon govde")
	_kontrol(not String(jargon["karar"][0]["govde_anahtari"]).contains("HFZ-"), "jargon hfz")

	var olu: Dictionary = defter.oku({
		"durumlar": {
			"olu1": {
				"durum": "oldu",
				"ad": "Fatma",
				"karar_gecmisi": [{"id": "k1", "hatirlanacak": true, "gece": 2, "karar": "kabul"}],
			},
		},
	})
	_kontrol((olu["karar"] as Array).size() == 1, "olu satir kalir")
	_kontrol(String(olu["karar"][0]["ad"]) == "Fatma", "olu adi kayittan")
	_kontrol(String(olu["karar"][0]["durum_anahtari"]) == "hafiza.durum.gitti", "gitti isareti")
	_kontrol(String(olu["karar"][0]["ad"]) != "olu1", "uydurma ad yok")


func _beyan_soylenti_not() -> void:
	var defter = DefterSinifi.new()
	var beyanlar := [
		{"id": "b1", "kisi": "a", "ad": "Ali", "gece": 1, "metin_anahtari": "beyan.ali.gelis"},
		{"id": "b2", "kisi": "a", "ad": "Ali", "gece": 2, "metin_anahtari": "beyan.ali.yol", "celiski": true},
	]
	var beyan: Dictionary = defter.oku({"beyanlar": beyanlar})
	_kontrol((beyan["beyan"] as Array).size() == beyanlar.size(), "beyan sayisi esit")
	_kontrol(bool(beyan["beyan"][0]["celiski"]), "celiski isaretli")

	var ag := [
		{"id": "r1", "olay": "olay.pazar", "kaynak": "fatma", "kademe": "birkac", "dogrulandi": false, "gece": 2, "ad": "Fatma"},
	]
	var soylenti: Dictionary = defter.oku({"soylenti_agi": ag})
	_kontrol((soylenti["soylenti"] as Array).size() == ag.size(), "soylenti ag ile esit")
	_kontrol(String(soylenti["soylenti"][0]["kademe_anahtari"]) == "hafiza.kademe.birkac", "kademe anahtari")

	var es: Dictionary = defter.oku({
		"soylenti": [{"id": "e1", "olay": "olay.es", "kaynak": "es", "kademe": "herkes", "gece": 1, "ad": "Es"}],
	})
	_kontrol(es["sayfa_sayisi"] == 4, "es ucuncu sayfa acmaz")
	_kontrol((es["soylenti"] as Array).size() == 1, "es soylenti sayfasinda")
	_kontrol(not es.has("hane"), "hane sayfasi yok")

	var gorulen := ["ipucu_kapi", "ipucu_koy", "ipucu_gece", "ipucu_zar", "ipucu_bar", "ipucu_heybe"]
	var notlar: Dictionary = defter.oku({"ogretici": {"gorulen": gorulen}})
	_kontrol((notlar["not"] as Array).size() == 5, "not sayfasi 5")
	var kimlikler: Array = []
	for satir in notlar["not"]:
		kimlikler.append(String(satir["id"]))
	_kontrol(not kimlikler.has("ipucu_kapi"), "altinci dusen ilk ipucu")
	_kontrol(kimlikler.has("ipucu_heybe"), "son ipucu durur")


func _siralama_ve_kayit() -> void:
	var defter = DefterSinifi.new()
	var sira: Dictionary = defter.oku({
		"diy14": [
			{"id": "a", "ad": "Hasan", "kisi": "hasan", "gece": 1},
			{"id": "b", "ad": "Fatma", "kisi": "fatma", "gece": 5},
		],
	})
	_kontrol(String(sira["karar"][0]["id"]) == "b", "yeni gece onde")
	var suzulen: Array = defter.suz(sira["karar"], "Hasan")
	_kontrol(suzulen.size() == 1, "tek kisi")
	var yabanci := 0
	for satir in suzulen:
		if String(satir["ad"]) != "Hasan":
			yabanci += 1
	_kontrol(yabanci == 0, "yabanci kisi 0")

	_kontrol(defter.yukle({}), "eski kayit acilir")
	_kontrol(defter.okunan.is_empty(), "alan yoksa bos")
	_kontrol(defter.yukle({"surum": 1}), "hafiza alani olmayan kayit")
	defter.satir_goruldu("a")
	var hedef := {}
	defter.kaydet(hedef)
	_kontrol((hedef["hafiza"] as Dictionary)["okunan"][0] == "a", "okunan yazildi")
	_kontrol(not hedef.has("diy14") and not hedef.has("karar"), "satir govdesi kayda yazilmaz")

	var soluk_satirlar: Array = [{"id": "a", "ad": "Hasan"}, {"id": "b", "ad": "Fatma"}]
	_kontrol(defter.soluk_sayisi(false, soluk_satirlar) == 0, "isaret kapali soluk 0")
	_kontrol(defter.soluk_sayisi(true, soluk_satirlar) == 1, "gorulen satir soluk")

	var enjekte = DefterSinifi.new()
	_kontrol(EnjektorSinifi.satir_ekle(enjekte, {"id": "kapali", "ad": "A", "gece": 1}, false) == 0, "debug kapali enjektor 0")
	_kontrol((enjekte.oku({})["karar"] as Array).is_empty(), "kapali enjektor satir yok")
	_kontrol(not AdminHud.arac_acik(PackedStringArray()), "oyuncu surumu kapali")
	for i in 41:
		_kontrol(EnjektorSinifi.satir_ekle(enjekte, {"id": "e%d" % i, "ad": "Hasan", "gece": i}, true) == 1, "enjektor acik")
	var tavan: Dictionary = enjekte.oku({})
	_kontrol((tavan["karar"] as Array).size() == 40, "41. satirda gorunen 40")
	_kontrol(enjekte.hata_ayiklama_sayisi() == 41, "kaynak satir silinmedi")


func _ekran() -> void:
	Engine.time_scale = 2.0
	var ekran = EkranSinifi.new()
	ekran.eski_hiz = 2
	ekran.kur()
	root.add_child(ekran)
	_kontrol(ekran.sayfa == 0, "odak ilk sayfa")
	_kontrol(ekran.ilk_sayfa_odakta, "ilk sayfa odakta")
	_kontrol(is_equal_approx(Engine.time_scale, 2.0), "acikken hiz ayni")
	_kontrol(ekran.hiz_korunur(2), "saklanan hiz 2")
	var bos_metin := String(ekran._bos.text)
	_kontrol(bos_metin == "hafiza.bos.karar" or bos_metin == "henüz bir şey yazılmadı", "bos sayfa metni")

	_eylem("kisayol_2")
	_eylem("geri")
	var olay := InputEventAction.new()
	olay.action = "kisayol_2"
	olay.pressed = true
	ekran._unhandled_input(olay)
	_kontrol(ekran.sayfa == 1, "kisayol 2 ikinci sayfa")
	olay = InputEventAction.new()
	olay.action = "geri"
	olay.pressed = true
	ekran._unhandled_input(olay)
	_kontrol(ekran.kapali, "geri kapatir")
	_kontrol(is_equal_approx(Engine.time_scale, 2.0), "kapaninca hiz ayni")

	var ayar := Ayarlar.new()
	ayar.degerler[&"metin_olcegi"] = 150
	var olcek = EkranSinifi.new()
	olcek.ayarlar = ayar
	root.add_child(olcek)
	_kontrol(olcek.punto(Tema.GOVDE_PX) == ayar.boyut(Tema.GOVDE_PX), "olcek 150 tema")
	_kontrol(not BagSinifi.dugme_gorunur(true, &"sohbet"), "sohbette dugme 0")
	_kontrol(not BagSinifi.dugme_gorunur(true, &"karar"), "kararda dugme 0")
	_kontrol(not BagSinifi.dugme_gorunur(false, &""), "kapida dugme 0")
	_kontrol(BagSinifi.dugme_gorunur(true, &""), "koyde dugme 1")
	_kontrol(BagSinifi.kaynak_derle(null).is_empty(), "oturumsuz kaynak bos")
	_kontrol(BagSinifi.duraklatdan_ac(null) == null, "duraklat bos hedef")


func _eylem(ad: String) -> void:
	if InputMap.has_action(ad):
		return
	InputMap.add_action(ad)
	var tus := InputEventKey.new()
	tus.physical_keycode = KEY_2 if ad == "kisayol_2" else KEY_ESCAPE
	InputMap.action_add_event(ad, tus)


func _tarama() -> void:
	var sinif := 0
	for yol in _gd_dosyalari("res://src"):
		var kod := FileAccess.get_file_as_string(yol)
		sinif += kod.count("class_name HafizaDefteriEkrani")
	_kontrol(sinif == 1, "ekran sinifi bir kez")

	var kapi := FileAccess.get_file_as_string("res://src/arayuz/kapi_ekrani.gd")
	_kontrol(not kapi.contains("HafizaDefteri"), "kapi cagrisi 0")
	var koy := FileAccess.get_file_as_string("res://src/arayuz/koy_ekrani.gd")
	_kontrol(koy.contains("HafizaDefteriBaglantisi.kur"), "koy tek satir")

	var ana := FileAccess.get_file_as_string("res://src/arayuz/ana.gd")
	var bas := ana.find("func _duraklat")
	var son := ana.find("func _ayarlari_ac")
	var govde := ana.substr(bas, son - bas)
	_kontrol(govde.contains("arayuz.duraklat.defter"), "duraklat defter")
	_kontrol(govde.find("arayuz.duraklat.menu") < govde.find("arayuz.duraklat.defter"), "menu ucuncu sirada")
	var dizi_bas := govde.find("[tr(\"arayuz.duraklat.devam\")")
	var dizi_son := govde.find("]", dizi_bas)
	var dizi := govde.substr(dizi_bas, dizi_son - dizi_bas)
	_kontrol(dizi.count("tr(") == 4, "duraklat dugme sayisi 4")
	_kontrol(not ana.contains("HafizaDefteriEkrani"), "son ekrani defteri gommez")

	var cekirdek := FileAccess.get_file_as_string("res://src/sistemler/hafiza_defteri.gd")
	_kontrol(not cekirdek.contains("ipucu_ekle"), "ipucu yazimi 0")
	_kontrol(not cekirdek.contains("kayda_yaz"), "ipucu kayda yazimi 0")
	_kontrol(not cekirdek.contains("gorulen_olaylar"), "olay yazimi 0")
	for yol in [
		"res://src/sistemler/hafiza_defteri.gd",
		"res://src/arayuz/hafiza_defteri_ekrani.gd",
		"res://src/arayuz/koy_hud/hafiza_defteri_baglantisi.gd",
		"res://src/debug/hafiza_enjektoru.gd",
	]:
		var kod := FileAccess.get_file_as_string(yol)
		_kontrol(not kod.contains("Engine.time_scale"), "time_scale yok: " + yol)
		_kontrol(not kod.contains("kalp") and not kod.contains("romans") and not kod.contains("hediye"), "iliski yok")
	var ekran_kod := FileAccess.get_file_as_string("res://src/arayuz/hafiza_defteri_ekrani.gd")
	var re := RegEx.new()
	re.compile("font_size\",\\s*\\d")
	_kontrol(re.search(ekran_kod) == null, "yerel punto 0")
	_kontrol(not ekran_kod.contains("Color(\"#"), "duz renk anahtari yok")

	var csv := FileAccess.get_file_as_string("res://data/metin/metinler.csv")
	for anahtar in ["hafiza.bos.karar", "hafiza.bos.beyan", "hafiza.bos.soylenti", "hafiza.bos.not", "hafiza.satir.baslik"]:
		_kontrol(csv.contains(anahtar + ","), "csv " + anahtar)


func _gd_dosyalari(kok: String) -> Array[String]:
	var sonuc: Array[String] = []
	var kuyruk: Array[String] = [kok]
	while not kuyruk.is_empty():
		var yol: String = kuyruk.pop_back()
		for ad in DirAccess.get_directories_at(yol):
			kuyruk.append(yol.path_join(String(ad)))
		for ad in DirAccess.get_files_at(yol):
			if String(ad).ends_with(".gd"):
				sonuc.append(yol.path_join(String(ad)))
	return sonuc


func _kapanis() -> void:
	var defter = DefterSinifi.new()
	var diy: Dictionary = defter.oku({
		"diy14": [{"id": "s1", "ad": "Hasan", "kisi": "hasan", "gece": 3}],
	})
	_kontrol((diy["karar"] as Array).size() == 1, "kapanis diy14")
	var yeni: Dictionary = defter.oku({})
	_kontrol(yeni["sayfa_sayisi"] == 4 and (yeni["karar"] as Array).is_empty(), "kapanis bos oyun")
	var ana := FileAccess.get_file_as_string("res://src/arayuz/ana.gd")
	_kontrol(ana.contains("arayuz.duraklat.defter"), "kapanis duraklat acar")
	_kontrol(not BagSinifi.dugme_gorunur(true, &"sohbet"), "kapanis kapida kapali")
	_kontrol(defter.yukle({}), "kapanis eski kayit")
