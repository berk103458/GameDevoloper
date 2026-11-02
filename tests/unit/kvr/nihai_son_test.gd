## SYS-20: zafer beş nihai sona ayrılır (öncelik sırası); epilog matrisi 5 gösterge + yozlaşma; kayıp sonları korunur.
extends SceneTree
const NIHAI = preload("res://src/sistemler/nihai_son.gd")
var hata := 0
var kat: Katalog

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func hazir() -> Oturum:
	var o := Oturum.new(kat, 2020)
	var y := o.yonetim
	y.gun = SonKilidi.kilit_gecesi()
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 100, "su": 100})
	y.adalet = 50
	y.asayis_riski = 60
	for i in 6:
		var k := y.kabul({"ad": "Köylü %d" % i})
		k.moral = 50
		k.refah = 40
	y.savusturulan = 3
	return o

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	var kilitli := hazir()
	kilitli.yonetim.gun = maxi(0, SonKilidi.kilit_gecesi() - 1)
	dene(NIHAI.son(kilitli, &"zafer") == "", "İlk saat kilidi nihai son üretmez")
	var o := hazir()
	dene(NIHAI.son(o, &"zafer") == "uc_tutundu", "Varsayılan: Uç Tutundu (%s)" % NIHAI.son(o, &"zafer"))
	dene(NIHAI.son(o, &"isyan") == "", "Kayıp sonu nihai son seçmez")
	# Ahi Kasabası: refah + adalet.
	var a := hazir()
	a.yonetim.adalet = 70
	for k in a.yonetim.koylular: k.refah = 80
	dene(NIHAI.son(a, &"zafer") == "ahi_kasabasi", "Ahi Kasabası")
	# Beyin Uç Köyü: sancak fermanına levent verildi.
	var b := hazir()
	b.sancak_asker_talebi = {"son_gece": 8, "gun": 8, "bekliyor": false, "secim": 0, "gonderilen": [1, 2]}
	dene(NIHAI.son(b, &"zafer") == "beyin_uc_koyu", "Beyin Uç Köyü")
	# Ertuğrul Obası: oba ittifakı (Ahi koşulundan önce gelir).
	var e := hazir()
	e.bayraklar[StringName(ObaIttifaki.AYAR.ittifak_bayragi)] = true
	e.yonetim.adalet = 70
	for k in e.yonetim.koylular: k.refah = 80
	dene(NIHAI.son(e, &"zafer") == "ertugrul_obasi", "Ertuğrul Obası öncelikli")
	# Tekfur Haraççısı: yüksek yozlaşma her şeyden önce.
	var t := hazir()
	t.bayraklar[StringName(ObaIttifaki.AYAR.ittifak_bayragi)] = true
	t.bayraklar[&"rusvet_sayisi"] = 200
	dene(int(NIHAI.gostergeler(t).yozlasma) >= int(NIHAI.AYAR.esik.yozlasma) and NIHAI.son(t, &"zafer") == "tekfur_haraccisi", "Tekfur Haraççısı (yozlaşma)")
	# Tekfur Haraççısı: 2. perdeyi hiç haraç reddetmeden doldurdu.
	var h := hazir()
	h.yonetim.savusturulan = 0
	h.yonetim.agalik = true
	h.yonetim.set_meta(KoyYonetimi.PERDE_GECISI.META, 0)
	h.yonetim.gun = 12
	dene(NIHAI.son(h, &"zafer") == "tekfur_haraccisi", "Tekfur Haraççısı (haraca boyun)")
	# Epilog matrisi.
	var m := NIHAI.son_metni(a, &"zafer", {"baslik": "eski", "metin": "eski metin"})
	dene(m.baslik == "Ahi Kasabası" and m.nihai == "ahi_kasabasi", "Başlık nihai sondan")
	for ad in ["Huzur", "Adalet", "Refah", "Güvenlik", "Nüfus", "Yozlaşma"]: dene(String(m.metin).contains(ad + " "), "Epilog satırı: " + ad)
	var kayip := NIHAI.son_metni(o, &"isyan", {"baslik": "İsyan", "metin": "Köy dağıldı."})
	dene(kayip.baslik == "İsyan" and String(kayip.metin).begins_with("Köy dağıldı.") and String(kayip.metin).contains("Epilog"), "Kayıp sonu metni korunur + epilog")
	dene(not String(m.metin).contains("chr_") and not String(m.metin).contains("Clue_"), "Sızıntı yok")
	# Beş sonun hepsi veri olarak tanımlı.
	for n in ["tekfur_haraccisi", "ertugrul_obasi", "beyin_uc_koyu", "ahi_kasabasi", "uc_tutundu"]: dene(NIHAI.AYAR.sonlar.has(n), "Son tanımı: " + n)
	print("NIHAI SON: GEÇTİ" if hata == 0 else "NIHAI SON: KALDI")
	quit(hata)
