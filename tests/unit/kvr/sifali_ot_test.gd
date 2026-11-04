## KRI-15: salgında boştaki vasıfsız köylü şifalı ot (afyon) toplar; tavan, kuluçka gizliliği, ilaç reçetesi girdisi.
extends SceneTree
const OT = preload("res://src/koy/sifali_ot.gd")
var hata := 0
var kat: Katalog

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func hazir(gorunur_hasta: bool) -> KoyYonetimi:
	var y := Oturum.new(kat, 1515).yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 1000
	y.a.isyan_esigi = -1
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 200, "odun": 100, "su": 100})
	y.akce = 200
	var h := y.kabul({"ad": "Hasta"})
	SaglikYoneticisi.enfekte(y, h, "humma")
	h.enfeksiyon.bitis = y.gun + 4
	if gorunur_hasta: h.bayrak_ac("hasta")
	for i in 4: y.kabul({"ad": "Boşta %d" % i, "stat": 4})
	y.kabul({"ad": "Usta", "stat": 8})
	return y

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	var saglam := hazir(false)
	for kisi in saglam.koylular:
		SaglikYoneticisi.iyilestir(kisi)
	var saglam_rapor := saglam.gece()
	dene(saglam.kaynaklar.miktar("afyon") == 0, "DEN-40: salgınsız gerçek gecede afyon üretilmez")
	dene(not saglam_rapor.olaylar.any(func(e: Dictionary) -> bool: return e.has("sifali_ot")), "DEN-40: salgınsız gecede ot toplama satırı yok")
	var y := hazir(true)
	var t := OT.toplayicilar(y)
	dene(t.size() == int(OT.AYAR.azami_toplayici), "Toplayıcı tavanı")
	for k in t: dene(not k.usta_mi() and not SaglikYoneticisi.hasta(k), "Toplayıcı vasıfsız ve sağlıklı: " + k.ad)
	var ol: Array[Dictionary] = []
	var rng := y._rng.state
	OT.gece(y, ol)
	dene(y.kaynaklar.miktar("afyon") == int(OT.AYAR.azami_toplayici) * int(OT.AYAR.kisi_basina_ot), "Afyon (şifalı ot) eklendi")
	dene(ol.size() == 1 and IflasYoneticisi.olay_metin(ol[0]).contains("şifalı ot"), "Tek rapor satırı")
	dene(y._rng.state == rng, "RNG çekilmez")
	# Gizli kuluçka (belirti yok) toplamayı başlatmaz: kimse ifşa edilmez.
	var g := hazir(false)
	dene(OT.toplayicilar(g).is_empty(), "Gizli kuluçkada toplama yok")
	# İşi olan köylü toplamaz.
	var z := hazir(true)
	for k in z.koylular: k.is_yeri = 999
	dene(OT.toplayicilar(z).is_empty(), "Görevli köylü toplamaz")
	# Gerçek gecede ot üretimden önce eklenir, ilaç reçetesinin girdisidir.
	var r := hazir(true)
	var rapor := r.gece()
	dene(rapor.olaylar.filter(func(e: Dictionary) -> bool: return e.has("sifali_ot")).size() == 1, "Gerçek gecede tek ot satırı")
	dene(HekimIlac.receteler().ilac.girdi.has("afyon"), "Ot = ilaç reçetesi girdisi")
	# İsyan sürerken toplama yok.
	var i := hazir(true)
	i.isyan_kalan = 2
	var ol2: Array[Dictionary] = []
	OT.gece(i, ol2)
	dene(ol2.is_empty(), "İsyanda toplama yok")
	# Kayıt: afyon stoğu kalıcı, yeni alan yok.
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, y.kaydet())
	dene(geri.kaynaklar.miktar("afyon") == y.kaynaklar.miktar("afyon"), "Ot stoğu kayıtta")
	print("SIFALI OT: GEÇTİ" if hata == 0 else "SIFALI OT: KALDI")
	quit(hata)
