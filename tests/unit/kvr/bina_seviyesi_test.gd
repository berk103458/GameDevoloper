extends SceneTree
var hata := 0
func _initialize() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var o := Oturum.new(katalog, 84)
	var y := o.yonetim
	var kaynak := JSON.stringify(katalog.binalar.turler)
	var bina := KoyBinasi.new()
	bina.tur = "cadir"
	for n in [1, 2, 3, 6]:
		bina.seviye = n
		_kontrol(is_equal_approx(bina.uretim_carpani(), 1.0 + 0.25 * (n - 1)), "N seviyesi gerçek üretim çarpanı")
		_kontrol(bina.yatak(y.katalog) == ceili(3.0 * (1 + 0.2 * (n - 1))), "Yatak tabanı %20/ek seviye, yukarı yuvarlama")
		bina.tur = "ambar"
		_kontrol(bina.depo_kapasitesi(y.katalog) == 100 + 20 * (n - 1), "Depo tabanı %20/ek seviye")
		bina.tur = "cadir"
	var eski := KoyBinasi.kayittan({"tur": "cadir", "insa": 0})
	_kontrol(eski.seviye == 1 and eski.yatak(y.katalog) == 3, "Eski kayıtta seviye 1; taban denge korunur")
	_kontrol(not eski.kaydet().has("hasar"), "Normal binada hasar alanı yok")
	# Gerçek tarla/çalışan ve üretim artığı üzerinden 2 → 2.5 → 3.
	var d := _kur(y, "tarla")
	_kontrol(d["olur"], "Gerçek katalogdan tarla kurulur")
	var tarla := y.bina(d["id"])
	tarla.insa_kalan = 0
	var calisan := y.kabul({"ad": "Test", "sinif": "ciftci", "stat": 5})
	_kontrol(y.ata(calisan.id, tarla.id), "Gerçek iş atama API'si")
	calisan.moral = 50
	for n in [1, 2, 3]:
		tarla.seviye = n
		y._artik.clear()
		var uretim := {}
		var olaylar: Array[Dictionary] = []
		y._uret(uretim, olaylar)
		var tam := int(uretim.get("gida", 0))
		var artik := float(y._artik.get("%d:gida" % tarla.id, 0.0))
		_kontrol(is_equal_approx(tam + artik, 3.2 * (1.0 + 0.25 * (n - 1))), "Gerçek üretimde meslek, seviye bonusu ve kesir artığı korunur")
	var once_gun := o.gun
	var rng := o._rng.state
	_kontrol(BinaManipulatoru.seviye_artir(o, tarla.id)["ok"] and tarla.seviye == 4, "Gerçek bina seviye adaptörü")
	_kontrol(o.gun == once_gun and o._rng.state == rng, "Seviye atlama gece/RNG çalıştırmaz")
	y.sur_seviye = 2
	for hasar in [0, 50, 100]:
		_kontrol(BinaManipulatoru.sur_durumu(o, hasar)["ok"] and y.savunma_gucu() == 4 - int(hasar / 25), "Hasar yalnız surun savunma payını azaltır")
	var geri := Oturum.kayittan(katalog, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(geri.yonetim.bina(tarla.id).seviye == 4 and geri.yonetim.sur_hasar == 100, "Seviye ve sur hasarı kayıtla korunur")
	_kontrol(JSON.stringify(katalog.binalar.turler) == kaynak, "Katalog tabanı değişmez")
	print("BİNA SEVİYESİ: GEÇTİ" if hata == 0 else "BİNA SEVİYESİ: KALDI")
	quit(hata)

func _kur(y: KoyYonetimi, tur: String) -> Dictionary:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h)["olur"]:
				return y.bina_kur(tur, h)
	return {"olur": false, "id": -1}
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
