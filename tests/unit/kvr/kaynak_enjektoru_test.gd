extends SceneTree
var hata := 0
func _initialize() -> void:
	var k := Katalog.new()
	k.yukle()
	var o := Oturum.new(k, 42)
	var y := o.yonetim
	var rng := o._rng.state
	var gun := o.gun
	for alan in ["koy_akce", "muhafiz_akce"]:
		o.set(alan, 10)
		var r := KaynakEnjektoru.degistir(o, alan, 7)
		_kontrol(r["sonra"] == 17 and o.get(alan) == 17, "Gerçek kasa artırılır")
		r = KaynakEnjektoru.degistir(o, alan, -100)
		_kontrol(r["sonra"] == 0 and r["fark"] == -17, "Kasa eksiye düşmez; gerçek delta raporlanır")
	for alan in ["gida", "odun", "tas", "demir"]:
		y.kaynaklar.stok[alan] = 5
		var r := KaynakEnjektoru.degistir(o, alan, 3)
		_kontrol(r["sonra"] == 8, "Gerçek stok artırılır")
		r = KaynakEnjektoru.degistir(o, alan, -100)
		_kontrol(r["sonra"] == 0 and r["fark"] == -8, "Stok eksiye düşmez")
	y.kaynaklar.kapasite = y.kaynaklar.toplam() + 2
	var sigan := KaynakEnjektoru.degistir(o, "demir", 100)
	_kontrol(sigan["fark"] == 2 and y.kaynaklar.toplam() == y.kaynaklar.kapasite, "Debug aracı ambar kapasitesini aşmaz")
	var once := JSON.stringify(o.kaydet())
	_kontrol(not KaynakEnjektoru.degistir(o, "yabanci", 4)["ok"], "Bilinmeyen alan reddedilir")
	_kontrol(not KaynakEnjektoru.degistir(o, "koy_akce", 1000001)["ok"], "Girdi sınırı modelde de korunur")
	_kontrol(JSON.stringify(o.kaydet()) == once and o.gun == gun and o._rng.state == rng, "Hatalar yan etkisiz; kaynak düzenlemesi gece/RNG çalıştırmaz")
	var geri := Oturum.kayittan(k, JSON.parse_string(once))
	_kontrol(geri.yonetim.kaynaklar.miktar("demir") == 2 and geri.muhafiz_akce == 0, "Kaynaklar normal kayıtla korunur")
	print("KAYNAK ENJEKTÖRÜ: GEÇTİ" if hata == 0 else "KAYNAK ENJEKTÖRÜ: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
