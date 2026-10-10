## KRI-12: erzak eşiğin altındayken gece ek sağlık kaybı ve salgın riski ×2; RNG çekimi değişmez.
extends SceneTree
const ACLIK = preload("res://src/koy/aclik_saglik.gd")
var hata := 0
var kat: Katalog

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func hazir(gida: int) -> KoyYonetimi:
	var y := Oturum.new(kat, 1212).yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 1000
	y.a.isyan_esigi = -1
	y.kaynaklar = Kaynaklar.new(1000, {"gida": gida, "odun": 100, "su": 100})
	y.akce = 200
	for i in 3:
		var k := y.kabul({"ad": "Komşu %d" % i})
		k.saglik = 80
		k.moral = 70
	return y

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	var esik := int(ACLIK.AYAR.erzak_esigi)
	var kayip := int(ACLIK.AYAR.saglik_kaybi)
	# Eşik altı: aynı köyde ek kaybı kapatılmış kopyayla birebir fark tam ek kayıp kadar.
	var y := hazir(esik - 1)
	var kontrol := hazir(esik - 1)
	var rapor := y.gece()
	dene(rapor.olaylar.filter(func(e: Dictionary) -> bool: return e.has("aclik_saglik")).size() == 1, "Eşik altında tek rapor satırı")
	ACLIK.AYAR.saglik_kaybi = 0
	kontrol.gece()
	ACLIK.AYAR.saglik_kaybi = kayip
	for i in y.koylular.size():
		dene(kontrol.koylular[i].saglik - y.koylular[i].saglik == kayip, "Her köylü ek %d sağlık kaybeder" % kayip)
	dene(y._rng.state == kontrol._rng.state, "Ek kayıp RNG çekimini değiştirmez")
	var metin := IflasYoneticisi.olay_metin(rapor.olaylar.filter(func(e: Dictionary) -> bool: return e.has("aclik_saglik"))[0])
	dene(metin.contains("Açlık ve hastalık") and metin.contains("×2") and not metin.contains("chr_"), "Rapor metni somut ve sızıntısız")
	# Eşik ve üstü: etki yok.
	var tok := hazir(esik)
	var r2 := tok.gece()
	dene(r2.olaylar.filter(func(e: Dictionary) -> bool: return e.has("aclik_saglik")).is_empty() and not ACLIK.aktif(tok), "Eşikte etki yok")
	# Risk çarpanı: yalnız aktif gecede ×2, tavan 100.
	var z := hazir(0)
	var ol: Array[Dictionary] = []
	ACLIK.baslat(z, ol)
	dene(ACLIK.aktif(z) and ACLIK.risk(z, 30) == 60 and ACLIK.risk(z, 70) == 100, "Aktif gecede risk ×2, tavan 100")
	z.gun += 1
	dene(not ACLIK.aktif(z) and ACLIK.risk(z, 30) == 30, "Ertesi gün kendiliğinden kapanır")
	# Gerçek bulaşma: ×2 risk aynı RNG akışında daha fazla ya da eşit vaka üretir.
	var toplam := [0, 0]
	for tohum in 40:
		for j in 2:
			var s := hazir(0 if j == 1 else 100)
			s._rng.seed = 5000 + tohum
			var ev := kur(s, "cadir")
			for k in s.koylular: k.ev = ev
			SaglikYoneticisi.enfekte(s, s.koylular[0], "humma")
			s.koylular[0].enfeksiyon.son_gece = s.gun - 1
			var o2: Array[Dictionary] = []
			if j == 1: ACLIK.baslat(s, o2)
			else: s.set_meta(ACLIK.META, -1)
			toplam[j] += SaglikYoneticisi.gece(s, o2)
	dene(toplam[1] > toplam[0], "Kıtlıkta salgın daha hızlı yayılır (%d > %d)" % [toplam[1], toplam[0]])
	# Kayıt: gece içi fotoğraf kayda yazılmaz; yüklenen köy bir sonraki gece yeniden ölçer.
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, y.kaydet())
	dene(not ACLIK.aktif(geri), "Kayıttan dönen köyde eski gece etkisi taşınmaz")
	print("ACLIK SAGLIK: GEÇTİ" if hata == 0 else "ACLIK SAGLIK: KALDI")
	quit(hata)

func kur(s: KoyYonetimi, tur: String) -> int:
	for cy in s.a.izgara_boyut.y:
		for cx in s.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if s.yerlesim(tur, h).olur:
				var b := s.bina(s.bina_kur(tur, h).id)
				b.insa_kalan = 0
				return b.id
	return -1
