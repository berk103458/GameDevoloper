## KRI-13: triyaj en ağır hastayı önce tedavi eder; yataklar doluyken açıkta bekleyen hasta ve köy morali çöker.
extends SceneTree
const TRIYAJ = preload("res://src/koy/sifahane_triyaj.gd")
var hata := 0
var kat: Katalog

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func kur(s: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in s.a.izgara_boyut.y:
		for cx in s.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if s.yerlesim(tur, h).olur:
				var b := s.bina(s.bina_kur(tur, h).id)
				b.insa_kalan = 0
				return b
	return null

func hasta_yap(y: KoyYonetimi, k: Koylu) -> void:
	SaglikYoneticisi.enfekte(y, k, "humma")
	k.enfeksiyon.bitis = y.gun + 4
	k.bayrak_ac("hasta")

func hazir() -> Array:
	var o := Oturum.new(kat, 1313)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 1000
	y.a.isyan_esigi = -1
	kat.koy_ayarlari = y.a
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 200, "odun": 200, "tas": 200, "kereste": 200, "su": 100})
	y.akce = 200
	var g := o._adli_gelen(&"chr_008")
	var hekim := y.koylu(o.karar_ver(g, &"kabul").koylu_id)
	var sif := kur(y, "sifahane")
	y.ata(hekim.id, sif.id)
	return [o, y, sif, hekim]

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	var p := hazir()
	var y: KoyYonetimi = p[1]
	var sif: KoyBinasi = p[2]
	dene(TRIYAJ.yatak(y) == KarantinaYoneticisi.kapasite(y, sif) and TRIYAJ.yatak(y) > 0, "Yatak = mevcut karantina kontenjanı")
	# Yatakları doldur.
	for i in TRIYAJ.yatak(y):
		var q := y.kabul({"ad": "Yatakta %d" % i})
		dene(KarantinaYoneticisi.al(y, q.id), "Karantina yatağı")
	var hastalar: Array[Koylu] = []
	for s in [70, 30, 50]:
		var k := y.kabul({"ad": "Hasta %d" % s})
		k.saglik = s
		k.moral = 60
		hasta_yap(y, k)
		hastalar.append(k)
	var saglam := y.kabul({"ad": "Sağlam"})
	saglam.moral = 60
	# Triyaj: tek hekimlik kontenjan en düşük sağlıklıya (30) gider.
	var ol: Array[Dictionary] = []
	var rng := y._rng.state
	SaglikYoneticisi.tedavi(y, ol)
	dene(not SaglikYoneticisi.hasta(hastalar[1]) and SaglikYoneticisi.hasta(hastalar[0]) and SaglikYoneticisi.hasta(hastalar[2]), "Triyaj en ağır hastayı önce tedavi etti")
	TRIYAJ.gece(y, ol)
	var satir := ol.filter(func(e: Dictionary) -> bool: return e.has("sifahane_triyaj"))
	dene(satir.size() == 1, "Yatak dolu + açıkta hasta: tek rapor satırı")
	dene(hastalar[0].saglik == 70 - int(TRIYAJ.AYAR.bakimsiz_saglik_kaybi) and hastalar[2].saglik == 50 - int(TRIYAJ.AYAR.bakimsiz_saglik_kaybi), "Bekleyen hastalar ek sağlık kaybı")
	dene(saglam.moral == 60 - int(TRIYAJ.AYAR.koy_moral_kaybi), "Köy morali çöker")
	dene(y._rng.state == rng, "RNG çekilmez")
	var m := IflasYoneticisi.olay_metin(satir[0])
	dene(m.contains("Şifahane dolu") and m.contains("Hasta 70") and not m.contains("chr_"), "Rapor metni")
	# Boş yatak varsa çöküş yok.
	var p2 := hazir()
	var y2: KoyYonetimi = p2[1]
	var k2 := y2.kabul({"ad": "Tek hasta"})
	k2.saglik = 60
	hasta_yap(y2, k2)
	var k3 := y2.kabul({"ad": "İkinci hasta"})
	k3.saglik = 60
	hasta_yap(y2, k3)
	var ol2: Array[Dictionary] = []
	TRIYAJ.gece(y2, ol2)
	dene(ol2.is_empty() and k2.saglik == 60, "Boş yatak varken çöküş yok")
	# Şifahane hiç yoksa (yatak 0) bu madde ceza üretmez; mevcut hastalık kaybı yeter.
	var y3 := Oturum.new(kat, 1314).yonetim
	var k4 := y3.kabul({"ad": "Şifahanesiz hasta"})
	hasta_yap(y3, k4)
	var ol3: Array[Dictionary] = []
	TRIYAJ.gece(y3, ol3)
	dene(ol3.is_empty(), "Şifahane yokken yatak çöküşü yok")
	# Gizli kuluçka (belirti açılmamış) bekleyen sayılmaz.
	var p4 := hazir()
	var y4: KoyYonetimi = p4[1]
	for i in TRIYAJ.yatak(y4): KarantinaYoneticisi.al(y4, y4.kabul({"ad": "Y%d" % i}).id)
	var gizli := y4.kabul({"ad": "Kuluçkada"})
	SaglikYoneticisi.enfekte(y4, gizli, "humma")
	var ol4: Array[Dictionary] = []
	TRIYAJ.gece(y4, ol4)
	dene(ol4.is_empty(), "Gizli kuluçka ifşa edilmez/cezalandırılmaz")
	# Gerçek gece entegrasyonu ve kayıt.
	var o5: Oturum = p[0]
	var r := y.gece()
	dene(r.olaylar.filter(func(e: Dictionary) -> bool: return e.has("sifahane_triyaj")).size() <= 1, "Gerçek gecede en fazla tek satır")
	var geri := Oturum.kayittan(kat, o5.kaydet())
	var a1: Dictionary = o5.kaydet()
	var a2: Dictionary = geri.kaydet()
	dene(geri != null and JSON.stringify(a1) == JSON.stringify(a2), "Kayıt/yükleme aynı durum")
	print("SIFAHANE TRIYAJ: GEÇTİ" if hata == 0 else "SIFAHANE TRIYAJ: KALDI")
	quit(hata)
