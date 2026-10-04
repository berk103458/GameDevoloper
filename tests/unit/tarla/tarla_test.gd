## Tarla ve ürün kuralları (design/gdd/tarla-ve-urunler.md). Düz betik:
##   godot --headless --path . -s tests/unit/tarla/tarla_test.gd   (çıkış 0 = geçti)
extends SceneTree

var _hata := 0
const SURE := {"bugday": 4, "arpa": 3}
const VERIM := {"bugday": 10, "arpa": 7}


func _init() -> void:
	var t := Tarlalar.new()
	t.alan_guncelle(5, 2, 6)
	_esit("ceil(5/2)=3 parsel", t.parseller.size(), 3)
	t.alan_guncelle(20, 2, 6)
	_esit("azami 6", t.parseller.size(), 6)
	t.alan_guncelle(4, 2, 6)
	_esit("çiftçi azalınca 2", t.parseller.size(), 2)
	_esit("ek", t.ek("bugday"), true)
	_esit("ek 2", t.ek("arpa"), true)
	_esit("boş yer yok", t.ek("arpa"), false)
	for g in 2:
		_esit("erken hasat yok", t.gece(SURE, VERIM).size(), 0)
	var h := t.gece(SURE, VERIM)
	_esit("arpa 3. gece hasat", h, [{"bitki": "arpa", "verim": 7}])
	t.verim_carp(0.5)
	h = t.gece(SURE, VERIM)
	_esit("buğday yarı verim", h, [{"bitki": "bugday", "verim": 5}])
	t.ek("bugday")
	t.gun_ekle(2)
	_esit("yağmur büyütür", int(t.parseller[0]["gun"]), 2)
	t.gun_ekle(-5)
	_esit("kuraklık 0'ın altına inmez", int(t.parseller[0]["gun"]), 0)
	_esit("don genç ekini öldürür", t.genc_yok_et(1), 1)
	var k := Tarlalar.new()
	k.yukle(t.kaydet())
	_esit("kayıt", k.parseller, t.parseller)
	# Oturum: tohum ambardan düşer, olay etkisi tarlaya işler.
	var kat := Katalog.new()
	if kat.yukle() == Katalog.Durum.HAZIR:
		var o := Oturum.new(kat, 3)
		o.tarlalar.alan_guncelle(4, kat.ayarlar.ciftci_tarla_basina, kat.ayarlar.tarla_azami)
		var ambar := o.ambar
		_esit("oturum ek", o.tarla_ek("bugday"), true)
		_esit("tohum düştü", o.ambar, ambar - kat.ayarlar.bitki_tohumlari[kat.ayarlar.bitki_idleri.find("bugday")])
	print("TARLA TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
