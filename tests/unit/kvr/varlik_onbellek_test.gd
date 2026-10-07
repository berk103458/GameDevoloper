extends SceneTree
var hata := 0
var kare := 0
func _initialize() -> void:
	process_frame.connect(func() -> void: kare += 1)
	call_deferred("_calistir")
func _calistir() -> void:
	var cache := VarlikOnbellek.new()
	var menu := GirisVarliklari.menu()
	var yollar: Array[String] = menu.duplicate()
	yollar.append(menu[0])
	yollar.append("res://assets/test_missing_bug01.glb")
	await cache.yukle(self, yollar)
	_kontrol(cache.kaynaklar.size() == menu.size(), "Menünün gerçek font/model/shader kaynakları yüklendi")
	_kontrol(cache.istek_sayisi == menu.size() and cache.hatalar.size() == 1, "Mükerrer istek yok, eksik dosya güvenle raporlanır")
	_kontrol(kare >= 2, "Yükleme boyunca ana kare döngüsü ilerler")
	_kontrol(cache.kaynaklar[Tema.FONT_DIK] is Font and cache.kaynaklar[MenuSahnesi.GOKYUZU] is Shader, "Kaynak tipleri korunur")
	var onceki := cache.istek_sayisi
	await cache.yukle(self, menu)
	_kontrol(cache.istek_sayisi == onceki, "Hazır batch tekrar disk isteği oluşturmaz")
	var kapi := GirisVarliklari.kapi()
	for yol in kapi:
		_kontrol(ResourceLoader.exists(yol), "Kapı manifesti mevcut dosyadan türetilir")
	var modeller := GirisVarliklari.karakterler(["chr_001", "chr_001", "ciftci"])
	_kontrol(modeller.size() >= 2 and modeller.size() == _tekil(modeller), "Kuyruk modeli/klip manifesti tekildir")
	cache.bosalt()
	_kontrol(cache.kaynaklar.is_empty(), "Sahne kurulunca batch referansları bırakılır")
	var gecis := Control.new()
	root.add_child(gecis)
	Adim.kesme(gecis, 0.1)
	gecis.free()
	await create_timer(0.15).timeout
	print("VARLIK ÖNBELLEK: GEÇTİ" if hata == 0 else "VARLIK ÖNBELLEK: KALDI")
	quit(hata)
func _tekil(a: Array) -> int:
	var d := {}
	for v in a:
		d[v] = true
	return d.size()
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
