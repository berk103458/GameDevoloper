## KRI-14: erzak tükenince nöbetçi ambara yönelir; yağma gecesinde arbede, geri alım ve moral kaybı.
extends SceneTree
const NOBET = preload("res://src/koy/kitlik_nobeti.gd")
var hata := 0
var kat: Katalog

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func hazir(nobetci: int) -> KoyYonetimi:
	var y := Oturum.new(kat, 1414).yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 1000
	y.a.isyan_esigi = -1
	y.a.muhafiz_azami = 20
	y.agalik = true
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 0, "odun": 150, "tas": 150, "kereste": 150, "su": 100})
	y.akce = 500
	for i in 3:
		var k := y.kabul({"ad": "Halk %d" % i})
		k.moral = 80
		k.saglik = 100
	for i in nobetci:
		var n := y.kabul({"ad": "Nöbetçi %d" % i, "sinif": "asker", "stat": 7})
		n.moral = 80
		n.saglik = 100
		dene(y.muhafiz_ata(n.id), "Nöbet ataması")
	return y

func olay(r: Dictionary, anahtar: String) -> Array:
	return r.olaylar.filter(func(e: Dictionary) -> bool: return e.has(anahtar))

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	var y := hazir(2)
	dene(NOBET.nobetciler(y).size() == 2, "İki etkin nöbetçi")
	var r1 := y.gece()
	var u := olay(r1, "kitlik_nobeti")
	dene(u.size() == 1 and u[0].kitlik_nobeti.tur == "uyari" and olay(r1, "kitlik_isyani").is_empty(), "İlk kıtlık gecesi: ambara yönelme uyarısı, yağma yok")
	var m1 := IflasYoneticisi.olay_metin(u[0])
	dene(m1.contains("ambar kapısına yöneldi"), "Uyarı metni")
	var moral_once := {}
	for k in y.koylular: moral_once[k.id] = k.moral
	var r2 := y.gece()
	var yagma := olay(r2, "kitlik_isyani")
	var arb := olay(r2, "kitlik_nobeti")
	dene(yagma.size() == 1 and arb.size() == 1 and arb[0].kitlik_nobeti.tur == "arbede", "Yağma gecesi tek arbede satırı")
	if arb.size() == 1 and yagma.size() == 1:
		var geri: Dictionary = arb[0].kitlik_nobeti.geri
		dene(not yagma[0].kitlik_isyani.yagma.is_empty() and not geri.is_empty(), "Gerçek yağma ve geri alım oldu")
		for tur in yagma[0].kitlik_isyani.yagma:
			dene(int(geri.get(tur, 0)) == floori(int(yagma[0].kitlik_isyani.yagma[tur]) * 0.5), "İki nöbetçi yağmanın yarısını geri alır: " + tur)
		dene(IflasYoneticisi.olay_metin(arb[0]).contains("Ambarda arbede"), "Arbede metni")
	# Nöbetsiz köy: uyarı/arbede yok, yağma aynen sürer (KRI-06 davranışı değişmez).
	var z := hazir(0)
	var z1 := z.gece()
	var z2 := z.gece()
	dene(olay(z1, "kitlik_nobeti").is_empty() and olay(z2, "kitlik_nobeti").is_empty() and olay(z2, "kitlik_isyani").size() == 1, "Nöbetçi yoksa bu madde sessiz, KRI-06 yağması aynen")
	# Moral: arbedeli köyde halk ve nöbetçi, nöbetsiz köydekinden daha fazla düşer.
	var halk_arb := y.koylular[0].moral
	var halk_z := z.koylular[0].moral
	dene(halk_arb < halk_z, "Arbede köy moralini ek düşürür (%d < %d)" % [halk_arb, halk_z])
	# Erzak varken hiçbir etki yok.
	var t := hazir(2)
	t.kaynaklar.ekle("gida", 100)
	dene(olay(t.gece(), "kitlik_nobeti").is_empty(), "Erzak varken etki yok")
	# Kayıt sonrası aynı gece tekrar çağrı ikinci arbede üretmez (KRI-06 makbuzu).
	var geri_y := KoyYonetimi.kayittan(y.a, y.katalog, y.kaydet())
	var ol: Array[Dictionary] = []
	NOBET.gece(geri_y, ol)
	dene(ol.filter(func(e: Dictionary) -> bool: return e.has("kitlik_nobeti") and e.kitlik_nobeti.tur == "arbede").is_empty(), "Kayıttan sonra arbede tekrarlanmaz")
	print("KITLIK NOBETI: GEÇTİ" if hata == 0 else "KITLIK NOBETI: KALDI")
	quit(hata)
