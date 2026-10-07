extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 92)
	var y := o.yonetim
	var k := y.kabul({"ad": "Test", "sinif": "ciftci"})
	var gun := o.gun
	var rng := y._rng.state
	var ayar := y.a
	var kasa := o.muhafiz_akce
	_kontrol(KrizEnjektoru.tetikle(o, "veba")["ok"] and k.saglik == 60 and k.bayrak_var("hasta"), "Veba gerçek köylünün sağlık/üretim bayrağına işler")
	_kontrol(KrizEnjektoru.tetikle(o, "kuyu")["ok"] and KrizEnjektoru.kalan(y) == 3, "Kuyu üç gecelik gerçek etki kurar")
	var once := o.kaydet()
	_kontrol(not KrizEnjektoru.tetikle(o, "kuyu")["ok"] and o.kaydet() == once, "Tekrarlama süre/RNG/modeli değiştirmez")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(once)))
	_kontrol(KrizEnjektoru.kalan(geri.yonetim) == 3 and geri.yonetim._rng.state == rng, "JSON kayıt zehir süresini ve RNG'yi korur")
	var stok := y.kaynaklar.stok.duplicate()
	var binalar := y.binalar.duplicate()
	_kontrol(KrizEnjektoru.tetikle(o, "kundak")["ok"], "Kundak gerçek stoklara uygulanır")
	for tur in stok:
		_kontrol(y.kaynaklar.miktar(tur) == int(stok[tur]) - ceili(int(stok[tur]) * 0.5), "Her tür stok yarıya düşer: " + tur)
	_kontrol(y.binalar == binalar and y.a == ayar and o.gun == gun and y._rng.state == rng and o.muhafiz_akce == kasa, "Bina hasarı/paylaşılan ayar/gün/RNG/kişisel kasa korunur")
	# Zehirli ve temiz kopyada aynı gerçek gece: fark yalnız zehir hasarıdır.
	var temiz := Oturum.kayittan(kat, once)
	temiz.yonetim.remove_meta(KrizEnjektoru.META)
	for i in 3:
		for oturum in [geri, temiz]:
			oturum.yonetim.kaynaklar.ekle("gida", 10)
		var r := geri.yonetim.gece()
		temiz.yonetim.gece()
		_kontrol(KrizEnjektoru.kalan(geri.yonetim) == 2 - i and r["olaylar"].any(func(e: Dictionary) -> bool: return e["anahtar"].begins_with("Debug: Zehirli")), "Gerçek gece zehri uygular ve süreyi azaltır")
		if i == 0: _kontrol(geri.yonetim.koylular[0].saglik == temiz.yonetim.koylular[0].saglik - 25, "Zehir hasarı normal gece iyileşmesine eklenir")
	_kontrol(geri.yonetim.koylular.is_empty() and temiz.yonetim.koylular.size() == 1, "Ölüm gerçek gece sağlık denetiminden gelir")
	var eski := once.duplicate(true)
	eski["koy_yonetimi"].erase("debug_kuyu_zehri")
	_kontrol(KrizEnjektoru.kalan(Oturum.kayittan(kat, eski).yonetim) == 0, "Eski kayıt zehirsiz açılır")
	for v in [-1, 4, 1.5, "3", {}, null]:
		KrizEnjektoru.yukle(temiz.yonetim, v)
		_kontrol(KrizEnjektoru.kalan(temiz.yonetim) == 0, "Geçersiz kayıt alanı reddedilir")
	_kontrol(not KrizEnjektoru.tetikle(null, "veba")["ok"] and not KrizEnjektoru.tetikle(o, "uydurma")["ok"], "Geçersiz istek reddedilir")
	print("KRİZ ENJEKTÖRÜ: GEÇTİ" if hata == 0 else "KRİZ ENJEKTÖRÜ: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
