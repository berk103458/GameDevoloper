## OMR-10: Ağalık gecesinden sonra gerçek perde geçişi kadrajında altı satırlık köy özeti; sayılar kayıttan, ölü sayısı kayıtta korunur.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_omr10.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 1010)
		kayit = GuvenliKayit.new("user://test_omr10_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0


func _gelen(id: String) -> Gelen:
	var g := Gelen.new()
	g.id = StringName(id)
	g.ad_anahtari = "test"
	g.sinif = &"koylu"
	return g


func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	o.gun = 5
	o.yonetim.gun = 5
	o.karar_ver(_gelen("yolcu_a"), &"ret")
	for i in o.yonetim.a.agalik_nufus + 1:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	o.yonetim.koylular[0].saglik = 0
	var s := o.gece_sonu()
	_kontrol(bool(s.get("perde_degisti", false)), "Ağalık gecesi perde değişti")
	var olen := int(o.yonetim.get_meta(PerdeOzeti.OLU_META, 0))
	_kontrol(olen >= 1, "Gece ölüm sayacı yazıldı (%d)" % olen)
	ana._perde_gecisi()
	await get_tree().process_frame
	var ekranlar := ana.find_children("*", "BilgiEkrani", true, false)
	_kontrol(not ekranlar.is_empty(), "Perde kadrajı açıldı")
	var metin := String(ekranlar[0].metin) if not ekranlar.is_empty() else ""
	var y := o.yonetim
	_kontrol(metin.contains("Kabul Edilen Can: %d" % y.kabul_sayisi), "Kabul satırı kayıttan")
	_kontrol(metin.contains("Geri Çevrilen Can: %d" % y.ret_sayisi), "Ret satırı kayıttan")
	_kontrol(metin.contains("Kapıya Gelen Toplam Can: %d" % (y.kabul_sayisi + y.ret_sayisi)), "Gelen satırı")
	_kontrol(metin.contains("Köyde Yaşanan Can Kaybı: %d" % olen), "Ölü satırı")
	_kontrol(metin.contains("%d. Gün" % y.gun), "Gün satırı")
	_kontrol(metin.contains("En Çok Hatırlanan Karar:") and not metin.contains("Henüz karar verilmedi"), "Anılan karar satırı söylenti ağından")
	_kontrol(PerdeOzeti.oturumdan(o).size() == 6, "Altı satır")
	var y2 := KoyYonetimi.kayittan(y.a, y.katalog, y.kaydet())
	_kontrol(int(y2.get_meta(PerdeOzeti.OLU_META, 0)) == olen, "Ölü sayısı kayıttan döner")
	print("OMR-10 PERDE ÖZETİ: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	get_tree().quit(1 if hata > 0 else 0)


func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
