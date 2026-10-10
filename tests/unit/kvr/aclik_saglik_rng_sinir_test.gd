## BUG-0015: bir görünür kaynak + üç gerçek aday; vaka tavanı RNG çekimini kısaltır.
extends SceneTree
const ACLIK = preload("res://src/koy/aclik_saglik.gd")
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var rng := RandomNumberGenerator.new()
	var tohum := -1
	var zarlar: Array[int] = []
	# Motorun gerçek RNG'sinde tabanı geçip ×2 eşiğine takılan ilk iki zarı bul.
	# Seed algoritmasına sabit sayı yakıştırmayız; bulunan seed/zarlar logda kanıttır.
	for s in 10000:
		rng.seed = s
		var a := rng.randi_range(1, 100)
		var b := rng.randi_range(1, 100)
		var c := rng.randi_range(1, 100)
		if a > 20 and a <= 40 and b > 20 and b <= 40 and c > 40:
			tohum = s
			zarlar.assign([a, b, c])
			break
	dene(tohum >= 0, "Sınır örneği gerçek motor RNG'sinde bulundu")
	if tohum < 0:
		quit(1)
		return
	rng.seed = tohum
	rng.randi_range(1, 100)
	rng.randi_range(1, 100)
	var iki := rng.state
	rng.randi_range(1, 100)
	var uc := rng.state
	var durumlar: Array[int] = []
	for aclik in [false, true]:
		var y := Oturum.new(kat, 1515).yonetim
		y.kaynaklar = Kaynaklar.new(1000, {"gida": 0 if aclik else 100, "tas": 100, "kereste": 100, "odun": 100})
		y.akce = 500
		var ev := kur(y)
		dene(ev >= 0, "Ortak hazır bina kuruldu")
		for i in 4:
			var k := y.kabul({"ad": "Temas %d" % i})
			k.ev = ev
			k.saglik = 100
		SaglikYoneticisi.enfekte(y, y.koylular[0], "humma")
		y.koylular[0].bayrak_ac("hasta")
		var olaylar: Array[Dictionary] = []
		ACLIK.baslat(y, olaylar)
		dene(y.koylular.size() == 4 and SaglikYoneticisi.hasta(y.koylular[0]) and "hasta" in y.koylular[0].bayraklar, "Bir görünür kaynak ve üç aday")
		y._rng.seed = tohum
		var yeni := SaglikYoneticisi.gece(y, olaylar)
		dene(yeni == (2 if aclik else 0), "Taban 0 / ×2 iki vaka")
		dene(y._rng.state == (iki if aclik else uc), "Gerçek döngü tabanda üç, ×2'de iki çekim")
		dene(not SaglikYoneticisi.hasta(y.koylular[3]), "Üçüncü aday vaka sınırında enfekte olmaz")
		durumlar.append(y._rng.state)
	dene(durumlar[0] != durumlar[1], "Aynı tohum sonraki RNG durumunu garanti etmez")
	print("RNG sınırı: seed=%d zarlar=%s taban=3 çekim/0 vaka, ×2=2 çekim/2 vaka" % [tohum, zarlar])
	print("ACLIK SAGLIK RNG SINIR: GEÇTİ" if hata == 0 else "ACLIK SAGLIK RNG SINIR: KALDI")
	quit(hata)

func kur(y: KoyYonetimi) -> int:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("cadir", h).olur:
				var b := y.bina(y.bina_kur("cadir", h).id)
				b.insa_kalan = 0
				return b.id
	return -1
