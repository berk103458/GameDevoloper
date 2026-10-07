extends SceneTree
var hata := 0
func _initialize() -> void:
	var k := Katalog.new()
	k.yukle()
	var o := Oturum.new(k, 81)
	var y := o.yonetim
	y.kabul({"ad": "Test", "sinif": "ciftci"})
	for t in ["tas", "kereste", "odun"]:
		y.kaynaklar.ekle(t, 20)
	for tur in ["cadir", "ambar"]:
		var kuruldu := false
		for cy in y.a.izgara_boyut.y:
			for cx in y.a.izgara_boyut.x:
				var hucre := Vector2i(cx, cy)
				if y.yerlesim(tur, hucre)["olur"]:
					kuruldu = y.bina_kur(tur, hucre)["olur"]
					break
			if kuruldu:
				break
		_kontrol(kuruldu, "Gerçek katalog/ızgarada inşaat kurulur")
	var stok := y.kaynaklar.stok.duplicate()
	var para := y.akce
	var gun := o.gun
	var rng := o._rng.state
	var r := BinaManipulatoru.insaatlari_bitir(o)
	_kontrol(r["tamamlanan"].size() == 2, "Tüm gerçek inşaatlar tamamlanır")
	_kontrol(y.kaynaklar.kapasite == y.a.ambar_taban_kapasite + 100 and y.koylular[0].ev >= 0, "Depo kapasitesi ve köylü barınması hemen güncellenir")
	_kontrol(y.kaynaklar.stok == stok and y.akce == para and o.gun == gun and o._rng.state == rng, "Ek malzeme, kasa, gün ve RNG yan etkisi yok")
	_kontrol(BinaManipulatoru.insaatlari_bitir(o)["tamamlanan"].is_empty(), "Tekrar çağrı idempotent")
	var geri := Oturum.kayittan(k, JSON.parse_string(JSON.stringify(o.kaydet())))
	for b in geri.yonetim.binalar:
		_kontrol(b.insa_kalan == 0, "Tamamlanan inşaat normal kayıtla korunur")
	print("BİNA MANİPÜLATÖRÜ: GEÇTİ" if hata == 0 else "BİNA MANİPÜLATÖRÜ: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
