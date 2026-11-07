## YAP-01: mevcut gece inşaat noktasının işçi/mevsim hesabı.
extends RefCounted

static func ilerlet(y: KoyYonetimi) -> int:
	var isci := 0
	for k in y.koylular:
		if preload("res://src/koy/bosta_kalma.gd").uygun(y, k): isci += 1
	var yardim := GeciciIsler.insaat_yardimi(y)
	if isci == 0 and yardim == 0: return 0
	var hiz := 1 + isci / maxi(1, y.a.insa_yardim_bolen) + yardim
	var carpan := float(MevsimYoneticisi.durum(y).insa_carpani)
	var ilerleme := 0
	for b in y.binalar:
		if b.insa_kalan <= 0: continue
		var toplam := b.insa_artik + float(hiz) * carpan
		var tam := floori(toplam)
		var artik := toplam - tam
		if is_equal_approx(artik, 1.0):
			tam += 1
			artik = 0.0
		var once := b.insa_kalan
		b.insa_kalan = maxi(0, once - tam)
		b.insa_artik = artik if b.insa_kalan > 0 else 0.0
		ilerleme += once - b.insa_kalan
	return ilerleme
