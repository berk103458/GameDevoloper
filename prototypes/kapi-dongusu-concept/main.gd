# PROTOTYPE - NOT FOR PRODUCTION
# Question: Önce sohbet, sonra karar — kapıdaki kararlar ağır hissettiriyor ve "bir gece daha" dedirtiyor mu?
# Date: 2026-10-04
extends Control

const BAR_ADLARI: Array[String] = ["Halk", "Soylular", "Tüccarlar", "Ordu"]
const BAR_BASLANGIC := 5
const BAR_UST := 10
const GECE_BASINA_GELEN := 3
const RUSVET_HAKKI := 3
const AZAMI_SORU := 2
const BELIRME_SN := 0.18
const SECENEK_ADLARI := {"kabul": "Kabul", "ret": "Ret", "rusvet": "Rüşvet", "kisla": "Kışla"}
const SINIF_ADLARI := {"asker": "asker", "esnaf": "esnaf", "ciftci": "çiftçi"}

const RENK_GECE := Color("#0D0F14")
const RENK_KUL := Color("#B8C2CC")
const RENK_MESALE := Color("#C4843A")
const RENK_MAVI := Color("#4A6B8A")
const RENK_AHSAP := Color("#3D2E24")

# --- İçerik (prototipte koda gömülü) ---------------------------------------
# etki: [Halk, Soylular, Tüccarlar, Ordu]
var karakterler := {
	"miraen": {
		"ad": "Miraen", "sinif": "asker", "kural": "hic_donmez", "n": 1, "en_erken": 0,
		"ziyaretler": [
			{"giris": "Atsız bir atlı. Kılıcının kını kırık, bakışı yolda.",
			 "sorular": [["Kimsin?", "Miraen. Gürcü'yüm. Sultanın ordusundaydım."],
				["Atın nerede?", "Kösedağ'da kaldı. Ben kalmadım."],
				["Birliğin nerede?", "Birlik mi... Dağıldı. Herkes dağıldı. (Gözlerini kaçırıyor.)"]]},
		],
		"secenekler": {"kabul": [0, -1, 0, 1], "ret": [0, 0, 0, -1], "kisla": [-1, 0, 0, 2]},
	},
	"sorhan": {
		"ad": "Sorhan", "sinif": "esnaf", "kural": "birden_cok", "n": 3, "en_erken": 1,
		"ziyaretler": [
			{"giris": "Üç atı yedeğinde bir Kıpçak. Atların ikisinde yabancı bir damga var.",
			 "sorular": [["Kimsin?", "Sorhan. At satarım, alan olursa."],
				["Bu atlar senin mi?", "Şimdi benim."],
				["Nereye gidiyorsun?", "Neresi kapı açarsa."]]},
			{"giris": "Sorhan yine. Bu sefer yanında bir kadın ve iki çocuk. Atlardan biri eksik.",
			 "sorular": [["Bunlar kim?", "Karım, çocuklarım. Geçen sefer yolda bekliyorlardı."],
				["Bir at nerede?", "Yol parası oldu."],
				["Neden geri geldin?", "Başka kapı açılmadı."]]},
			{"giris": "Sorhan. Yalnız. Atlar yok, aile yok.",
			 "sorular": [["Ailen nerede?", "Bir kervana verdim onları. Güneye."],
				["Atlar?", "Atlar gitti. Ben kaldım."],
				["Ne istiyorsun?", "Bir yer. Sadece bir yer."]]},
		],
		"secenekler": {"kabul": [0, 0, 1, 1], "ret": [0, 0, -1, 0], "rusvet": [-1, 0, 2, 0], "kisla": [0, -1, 0, 1]},
	},
	"thessra": {
		"ad": "Thessra", "sinif": "esnaf", "kural": "oranla", "n": 4, "en_erken": 1,
		"ziyaretler": [
			{"giris": "Kucağında tahta bir kutu taşıyan genç bir kadın.",
			 "sorular": [["Kimsin?", "Thessra. Trabzon'dan. Babam hekimdi."],
				["Kutuda ne var?", "İlaç. Ağrıya iyi gelir... başka şeye de."],
				["Baban nerede?", "Yolda gömdük."]]},
			{"giris": "Thessra yine kapıda. Kutusu daha hafif görünüyor.",
			 "sorular": [["Neden döndün?", "Kervan beni de kutuyu da istemedi."],
				["Kutu boşaldı mı?", "Yarısı. Yol uzun."],
				["Kime sattın?", "Satmadım. Verdim. Ağrıyan çoktu."]]},
		],
		"secenekler": {"kabul": [1, 0, 1, -1], "ret": [-1, 0, 0, 0], "rusvet": [0, 1, 1, -1]},
	},
	"karaca_usta": {
		"ad": "Karaca Usta", "sinif": "esnaf", "kural": "oranla", "n": 4, "en_erken": 2,
		"ziyaretler": [
			{"giris": "Belinde şed bağlı bir usta. Yanında iki çırak.",
			 "sorular": [["Kimsin?", "Karaca derler. Kayseri'de tabakhanem vardı. Yandı."],
				["Bunlar kim?", "Çıraklarım. Ben neredeysem onlar orada."],
				["Ahi ocağın ne der?", "Ocağa borcum var. Ödeyeceğim, vakti gelince."]]},
			{"giris": "Karaca Usta yine geldi. Çıraklardan biri yok.",
			 "sorular": [["Çırağın nerede?", "Başka bir ustaya verdim. Aç kalmasın diye."],
				["Neden döndün?", "Ocak sorar: kapı neden kapandı? Cevabım olsun istedim."]]},
		],
		"secenekler": {"kabul": [1, 0, 1, 0], "ret": [-1, 0, -1, 0], "rusvet": [0, 1, -1, 0], "kisla": [0, 0, -1, 1]},
	},
	"aydogdu": {
		"ad": "Aydoğdu", "sinif": "asker", "kural": "hic_donmez", "n": 1, "en_erken": 3,
		"ziyaretler": [
			{"giris": "Kolu sargılı bir okçu. Sırtında yay, belinde sadak.",
			 "sorular": [["Kimsin?", "Aydoğdu. Türkmen'im."],
				["Yaran ne?", "Kösedağ'dan hatıra."],
				["Yalnız mısın?", "Şimdilik. (Arkasındaki yola bakıyor.)"]]},
		],
		"secenekler": {"kabul": [1, -1, 0, 1], "ret": [-1, 0, 0, 0], "kisla": [0, -1, 0, 2]},
	},
	"saruca_hatun": {
		"ad": "Saruca Hatun", "sinif": "ciftci", "kural": "birden_cok", "n": 2, "en_erken": 0,
		"ziyaretler": [
			{"giris": "Kucağında çocuk, yorgun bir kadın.",
			 "sorular": [["Kimsin?", "Saruca. Sivas'ın köylerindendim."],
				["Kocan nerede?", "Yoktur artık."],
				["Ne istersin?", "Çocuğa bir çatı."]]},
			{"giris": "Saruca Hatun yine. Bu sefer sırtında bir çuval.",
			 "sorular": [["Çuvalda ne var?", "Tohum. Yemeyiz, ekeriz. Toprak verirseniz."],
				["Çocuk nerede?", "Bir hana bıraktım. Tohumu getirmek için."],
				["Kış yaklaşıyor.", "Biliyorum. Tohum da biliyor."]]},
		],
		"secenekler": {"kabul": [1, 0, 0, 0], "ret": [-1, 0, 0, 0], "rusvet": [-1, 1, 1, 0]},
	},
}

var figurler := [
	{"ad": "Yorgun bir çiftçi", "sinif": "ciftci", "giris": "Sırtında boyunduruk taşıyan bir adam. Öküzü yok.",
	 "sorular": [["Öküzün nerede?", "Yolda öldü. Boyunduruğu bırakamadım."], ["Ne iş bilirsin?", "Toprak. Başka bir şey bilmem."]]},
	{"ad": "Yaralı bir asker", "sinif": "asker", "giris": "Sargısı kirlenmiş bir asker.",
	 "sorular": [["Kimin adamısın?", "Artık kimsenin."], ["Yaran ağır mı?", "Yürüyorum, değil mi?"]]},
	{"ad": "Bir Ahi çırağı", "sinif": "esnaf", "giris": "Elinde alet torbası, genç bir çırak.",
	 "sorular": [["Ustan nerede?", "Yolda kaybettim. Arıyorum."], ["Ne iş yaparsın?", "Deri. Biraz da demir."]]},
	{"ad": "Seyyar bir bakırcı", "sinif": "esnaf", "giris": "Sırtında birkaç bakır kap.",
	 "sorular": [["Malın bu kadar mı?", "Kalan bu. Borcum daha çok."], ["Nereye gidiyorsun?", "Kervansaray varsa oraya."]]},
	{"ad": "Irgat bir kadın", "sinif": "ciftci", "giris": "Elleri nasırlı bir kadın, yalnız.",
	 "sorular": [["Kimin nesisin?", "Kocam tarlada kaldı."], ["Ne istersin?", "Hasat zamanı iş."]]},
	{"ad": "Bir firari", "sinif": "asker", "giris": "Gözleri sürekli yolda olan bir adam.",
	 "sorular": [["Kimden kaçıyorsun?", "Herkes bir şeyden kaçıyor bu yolda."], ["Silahın var mı?", "Bıraktım."]]},
]

var sinif_etki := {
	"ciftci": {"kabul": [1, 0, 0, 0], "ret": [-1, 0, 0, 0], "rusvet": [-1, 0, 1, 0], "kisla": [0, 0, 0, 1]},
	"esnaf": {"kabul": [0, 0, 1, 0], "ret": [0, 0, -1, 0], "rusvet": [0, 1, 1, -1], "kisla": [0, 0, -1, 1]},
	"asker": {"kabul": [0, -1, 0, 1], "ret": [0, 0, 0, -1], "rusvet": [0, 1, 0, -1], "kisla": [-1, 0, 0, 2]},
}

# --- Durum ----------------------------------------------------------------
var gun := 0  # tamamlanan gece sayısı = skor
var barlar: Array[int] = []
var rusvet := RUSVET_HAKKI
var koy := {"asker": 0, "esnaf": 0, "ciftci": 0}
var durum := {}
var kuyruk: Array = []
var simdiki := {}
var sorulan: Array[int] = []
var secili := ""
var evre := ""  # sohbet, karar, sonuc, gece_sonu, bitti
var kirilan := ""
var rng := RandomNumberGenerator.new()
var belirme_id := 0

# --- Arayüz ---------------------------------------------------------------
var bar_cubuklari: Array[ProgressBar] = []
var bar_etiketleri: Array[Label] = []
var ust_bilgi: Label
var portre: ColorRect
var portre_ad: Label
var portre_sinif: Label
var metin: RichTextLabel
var secenek_dikey: VBoxContainer
var secenek_yatay: HBoxContainer
var karar_dugmeleri: Array[Button] = []
var karar_anahtarlari: Array[String] = []


func _ready() -> void:
	rng.randomize()
	_arayuz_kur()
	_yeni_oyun()


func _arayuz_kur() -> void:
	var tema := Theme.new()
	tema.default_font_size = 26
	tema.set_color("font_color", "Label", RENK_KUL)
	tema.set_color("font_color", "Button", RENK_KUL)
	tema.set_color("default_color", "RichTextLabel", RENK_KUL)
	var normal := StyleBoxFlat.new()
	normal.bg_color = RENK_GECE
	normal.border_color = RENK_AHSAP
	normal.set_border_width_all(2)
	normal.set_content_margin_all(14)
	var odak := normal.duplicate() as StyleBoxFlat
	odak.border_color = RENK_KUL
	odak.set_border_width_all(4)
	var basili := normal.duplicate() as StyleBoxFlat
	basili.bg_color = RENK_KUL
	tema.set_stylebox("normal", "Button", normal)
	tema.set_stylebox("hover", "Button", normal)  # tek odak: hover normal ile aynı
	tema.set_stylebox("focus", "Button", odak)
	tema.set_stylebox("pressed", "Button", basili)
	tema.set_color("font_pressed_color", "Button", RENK_GECE)
	tema.set_color("font_hover_color", "Button", RENK_KUL)
	tema.set_color("font_focus_color", "Button", RENK_KUL)
	theme = tema

	var zemin := ColorRect.new()
	zemin.color = RENK_GECE
	zemin.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(zemin)

	var kenar := MarginContainer.new()
	kenar.set_anchors_preset(Control.PRESET_FULL_RECT)
	for y in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		kenar.add_theme_constant_override(y, 40)
	add_child(kenar)

	var dikey := VBoxContainer.new()
	dikey.add_theme_constant_override("separation", 24)
	kenar.add_child(dikey)

	# Üst şerit: barlar solda, gün ve rüşvet sağda
	var ust := HBoxContainer.new()
	ust.add_theme_constant_override("separation", 28)
	dikey.add_child(ust)
	for i in BAR_ADLARI.size():
		var kutu := VBoxContainer.new()
		var etiket := Label.new()
		kutu.add_child(etiket)
		var cubuk := ProgressBar.new()
		cubuk.min_value = 0
		cubuk.max_value = BAR_UST
		cubuk.step = 1
		cubuk.show_percentage = false
		cubuk.custom_minimum_size = Vector2(220, 22)
		kutu.add_child(cubuk)
		ust.add_child(kutu)
		bar_etiketleri.append(etiket)
		bar_cubuklari.append(cubuk)
	var bosluk := Control.new()
	bosluk.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ust.add_child(bosluk)
	ust_bilgi = Label.new()
	ust_bilgi.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	ust.add_child(ust_bilgi)

	# Orta: portre solda, sohbet sağda
	var orta := HBoxContainer.new()
	orta.size_flags_vertical = Control.SIZE_EXPAND_FILL
	orta.add_theme_constant_override("separation", 40)
	dikey.add_child(orta)

	var sol := VBoxContainer.new()
	sol.custom_minimum_size = Vector2(520, 0)
	orta.add_child(sol)
	portre = ColorRect.new()
	portre.custom_minimum_size = Vector2(520, 560)
	portre.color = RENK_AHSAP
	sol.add_child(portre)
	portre_ad = Label.new()
	portre_ad.add_theme_font_size_override("font_size", 36)
	portre_ad.add_theme_color_override("font_color", RENK_MESALE)
	sol.add_child(portre_ad)
	portre_sinif = Label.new()
	sol.add_child(portre_sinif)

	var sag := VBoxContainer.new()
	sag.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sag.add_theme_constant_override("separation", 18)
	orta.add_child(sag)
	metin = RichTextLabel.new()
	metin.bbcode_enabled = true
	metin.scroll_following = true
	metin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sag.add_child(metin)
	secenek_dikey = VBoxContainer.new()
	secenek_dikey.add_theme_constant_override("separation", 10)
	sag.add_child(secenek_dikey)
	secenek_yatay = HBoxContainer.new()
	secenek_yatay.add_theme_constant_override("separation", 16)
	sag.add_child(secenek_yatay)

	var ipucu := Label.new()
	ipucu.text = "Fare / ok tuşları + Enter. Kararda: 1–4 seçer, aynı düğmeye tekrar basmak onaylar, Esc seçimi bırakır."
	ipucu.add_theme_font_size_override("font_size", 20)
	ipucu.add_theme_color_override("font_color", RENK_MAVI)
	dikey.add_child(ipucu)


# --- Akış -------------------------------------------------------------------
func _yeni_oyun() -> void:
	gun = 0
	barlar = []
	for i in BAR_ADLARI.size():
		barlar.append(BAR_BASLANGIC)
	rusvet = RUSVET_HAKKI
	koy = {"asker": 0, "esnaf": 0, "ciftci": 0}
	durum = {}
	for id in karakterler:
		durum[id] = {"durum": "gelmedi", "ziyaret": 0, "donus": 0}
	metin.clear()
	_gece_basla()


func _gece_basla() -> void:
	kuyruk = []
	var uygun: Array = []
	for id in karakterler:
		var d: Dictionary = durum[id]
		if d["durum"] == "gelmedi" and gun >= karakterler[id]["en_erken"]:
			uygun.append(id)
		elif d["durum"] == "donebilir" and gun >= d["donus"]:
			uygun.append(id)
	uygun.shuffle()
	for i in GECE_BASINA_GELEN:
		if uygun.size() > 0 and rng.randf() < 0.6:
			kuyruk.append({"tip": "adli", "id": uygun.pop_back()})
		else:
			kuyruk.append({"tip": "figur", "veri": _figur_uret()})
	_yaz("\n[color=#C4843A]— %d. gece —[/color]" % (gun + 1))
	_ust_guncelle()
	_siradaki()


func _figur_uret() -> Dictionary:
	var f: Dictionary = figurler[rng.randi_range(0, figurler.size() - 1)].duplicate(true)
	var etki: Dictionary = sinif_etki[f["sinif"]].duplicate(true)
	# Her figürde gizli küçük bir fark: kabulün bir bara ek etkisi
	var kabul: Array = etki["kabul"]
	kabul[rng.randi_range(0, 3)] += [-1, 1][rng.randi_range(0, 1)]
	f["secenekler"] = etki
	return f


func _siradaki() -> void:
	if kuyruk.is_empty():
		_gece_sonu()
		return
	var gelen: Dictionary = kuyruk.pop_front()
	if gelen["tip"] == "adli":
		var id: String = gelen["id"]
		var c: Dictionary = karakterler[id]
		durum[id]["ziyaret"] += 1
		var z: Array = c["ziyaretler"]
		var ziyaret: Dictionary = z[mini(durum[id]["ziyaret"] - 1, z.size() - 1)]
		simdiki = {"adli": true, "id": id, "ad": c["ad"], "sinif": c["sinif"], "giris": ziyaret["giris"],
			"sorular": ziyaret["sorular"], "secenekler": c["secenekler"]}
	else:
		var f: Dictionary = gelen["veri"]
		simdiki = {"adli": false, "id": "", "ad": f["ad"], "sinif": f["sinif"], "giris": f["giris"],
			"sorular": f["sorular"], "secenekler": f["secenekler"]}
	sorulan = []
	portre_ad.text = simdiki["ad"]
	portre_sinif.text = "(%s gibi görünüyor)" % SINIF_ADLARI[simdiki["sinif"]]
	portre.color = RENK_MAVI if simdiki["adli"] else RENK_AHSAP
	_yaz("\n[i]%s[/i]" % simdiki["giris"])
	_sohbet_goster()


func _sohbet_goster() -> void:
	evre = "sohbet"
	_temizle()
	var dugmeler: Array[Button] = []
	var sorular: Array = simdiki["sorular"]
	if sorulan.size() < AZAMI_SORU:
		for i in sorular.size():
			if i in sorulan:
				continue
			var b := _dugme("“%s”" % sorular[i][0], secenek_dikey)
			b.pressed.connect(_soru_sor.bind(i))
			dugmeler.append(b)
	var k := _dugme("Kararını ver", secenek_dikey)
	k.pressed.connect(_karar_goster)
	dugmeler.append(k)
	_sirayla_goster(dugmeler)


func _soru_sor(i: int) -> void:
	var s: Array = simdiki["sorular"][i]
	sorulan.append(i)
	_yaz("[color=#4A6B8A]Sen:[/color] %s\n[color=#C4843A]%s:[/color] %s" % [s[0], simdiki["ad"], s[1]])
	if sorulan.size() >= AZAMI_SORU:
		_karar_goster()
	else:
		_sohbet_goster()


func _karar_goster() -> void:
	evre = "karar"
	secili = ""
	_temizle()
	karar_dugmeleri = []
	karar_anahtarlari = []
	var secenekler: Dictionary = simdiki["secenekler"]
	var n := 1
	for anahtar in ["kabul", "ret", "rusvet", "kisla"]:
		if not secenekler.has(anahtar):
			continue
		var b := _dugme("%d · %s" % [n, SECENEK_ADLARI[anahtar]], secenek_yatay)
		b.custom_minimum_size = Vector2(220, 64)
		b.pressed.connect(_karar_bas.bind(anahtar))
		karar_dugmeleri.append(b)
		karar_anahtarlari.append(anahtar)
		n += 1
	_sirayla_goster(karar_dugmeleri)


func _karar_bas(anahtar: String) -> void:
	if evre != "karar":
		return
	if secili == anahtar:
		_karar_ver(anahtar)
		return
	secili = anahtar
	for i in karar_dugmeleri.size():
		var ad: String = SECENEK_ADLARI[karar_anahtarlari[i]]
		if karar_anahtarlari[i] == secili:
			karar_dugmeleri[i].text = "▶ %s — onayla" % ad
			karar_dugmeleri[i].grab_focus()
		else:
			karar_dugmeleri[i].text = "%d · %s" % [i + 1, ad]


func _karar_birak() -> void:
	if evre != "karar" or secili == "":
		return
	secili = ""
	for i in karar_dugmeleri.size():
		karar_dugmeleri[i].text = "%d · %s" % [i + 1, SECENEK_ADLARI[karar_anahtarlari[i]]]


func _karar_ver(anahtar: String) -> void:
	evre = "sonuc"
	var etki: Array = simdiki["secenekler"][anahtar]
	for i in BAR_ADLARI.size():
		barlar[i] += int(etki[i])
	var kaldi := anahtar != "ret"
	var ad: String = simdiki["ad"]
	match anahtar:
		"kabul":
			_yaz("Kapı açıldı. %s içeri girdi." % ad)
		"ret":
			_yaz("Kapı kapalı kaldı. %s yoluna döndü." % ad)
		"rusvet":
			_yaz("Kese el değiştirdi. %s içeri girdi." % ad)
		"kisla":
			_yaz("%s kışlaya yazıldı." % ad)
	if kaldi:
		var sinif: String = "asker" if anahtar == "kisla" else simdiki["sinif"]
		koy[sinif] += 1
		if simdiki["adli"]:
			durum[simdiki["id"]]["durum"] = "koyde"
	elif simdiki["adli"]:
		_donus_kurali(simdiki["id"])
	_ust_guncelle()
	if _bar_kontrol():
		_bitir()
		return
	_temizle()
	var d := _dugme("Devam", secenek_dikey)
	d.pressed.connect(_siradaki)
	_sirayla_goster([d])


func _donus_kurali(id: String) -> void:
	var c: Dictionary = karakterler[id]
	var d: Dictionary = durum[id]
	match c["kural"]:
		"hic_donmez":
			d["durum"] = "kalici"
		"oranla":
			var k: int = d["ziyaret"]
			var p := 0.6 * pow(0.5, k - 1)
			if k < int(c["n"]) and rng.randf() < p:
				d["durum"] = "donebilir"
				d["donus"] = gun + rng.randi_range(2, 4)
			else:
				d["durum"] = "kalici"
		"birden_cok":
			if int(d["ziyaret"]) < int(c["n"]):
				d["durum"] = "donebilir"
				d["donus"] = gun + rng.randi_range(2, 4)
			else:
				d["durum"] = "kalici"


func _bar_kontrol() -> bool:
	for i in BAR_ADLARI.size():
		if barlar[i] <= 0 or barlar[i] >= BAR_UST:
			if rusvet > 0:
				rusvet -= 1
				_yaz("[color=#C4843A]%s kırılmak üzereydi. Bir rüşvet hakkı harcandı; kalan %d.[/color]" % [BAR_ADLARI[i], rusvet])
				barlar[i] = BAR_BASLANGIC
			else:
				kirilan = BAR_ADLARI[i]
				_ust_guncelle()
				return true
	_ust_guncelle()
	return false


func _gece_sonu() -> void:
	evre = "gece_sonu"
	var toplam: int = koy["asker"] + koy["esnaf"] + koy["ciftci"]
	if toplam > 0 and koy["ciftci"] * 3 < toplam:
		barlar[0] -= 1
		_yaz("[i]Ambar azaldı. Halk homurdanıyor.[/i]")
	if gun >= 3 and koy["asker"] * 2 < gun:
		barlar[3] -= 1
		_yaz("[i]Uzakta Tekfur'un adamlarının ateşleri görüldü.[/i]")
	if _bar_kontrol():
		_bitir()
		return
	gun += 1
	_yaz("[color=#C4843A]— Gece bitti. Köy: %d asker, %d esnaf, %d çiftçi —[/color]" % [koy["asker"], koy["esnaf"], koy["ciftci"]])
	_ust_guncelle()
	_temizle()
	var d := _dugme("Sonraki gece", secenek_dikey)
	d.pressed.connect(_gece_basla)
	_sirayla_goster([d])


func _bitir() -> void:
	evre = "bitti"
	_temizle()
	_yaz("\n[color=#C4843A][b]%s kırıldı.[/b][/color]\nHayatta kalınan gün: [b]%d[/b]" % [kirilan, gun])
	portre_ad.text = ""
	portre_sinif.text = ""
	portre.color = RENK_GECE
	var d := _dugme("Yeniden başla", secenek_dikey)
	d.pressed.connect(_yeni_oyun)
	_sirayla_goster([d])


# --- Yardımcılar ---------------------------------------------------------
func _yaz(s: String) -> void:
	metin.append_text(s + "\n")


func _ust_guncelle() -> void:
	for i in BAR_ADLARI.size():
		bar_cubuklari[i].value = clampi(barlar[i], 0, BAR_UST)
		bar_etiketleri[i].text = "%s  %d" % [BAR_ADLARI[i], barlar[i]]
	ust_bilgi.text = "%d. gece   ·   Rüşvet hakkı: %s   ·   Köy: %d" % [
		gun + 1, "●".repeat(rusvet) + "○".repeat(RUSVET_HAKKI - rusvet),
		koy["asker"] + koy["esnaf"] + koy["ciftci"]]


func _dugme(yazi: String, kap: Container) -> Button:
	var b := Button.new()
	b.text = yazi
	b.alignment = HORIZONTAL_ALIGNMENT_LEFT
	b.focus_mode = Control.FOCUS_ALL
	b.mouse_entered.connect(b.grab_focus)  # tek odak: fare odak taşır
	kap.add_child(b)
	return b


func _temizle() -> void:
	belirme_id += 1
	for c in secenek_dikey.get_children():
		c.queue_free()
	for c in secenek_yatay.get_children():
		c.queue_free()


func _sirayla_goster(dugmeler: Array) -> void:
	var benim := belirme_id
	for b in dugmeler:
		b.visible = false
	for i in dugmeler.size():
		if benim != belirme_id or not is_instance_valid(dugmeler[i]):
			return
		dugmeler[i].visible = true
		if i == 0:
			dugmeler[i].grab_focus()
		await get_tree().create_timer(BELIRME_SN).timeout


func _unhandled_input(event: InputEvent) -> void:
	var tus := event as InputEventKey
	if tus == null or not tus.pressed or tus.echo:
		return
	var k: int = tus.keycode
	if evre == "karar":
		if k >= KEY_1 and k <= KEY_4:
			var i := k - KEY_1
			if i < karar_anahtarlari.size():
				_karar_bas(karar_anahtarlari[i])
				get_viewport().set_input_as_handled()
		elif k == KEY_ESCAPE:
			_karar_birak()
			get_viewport().set_input_as_handled()
