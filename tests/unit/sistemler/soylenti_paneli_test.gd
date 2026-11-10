extends SceneTree
## SOY-32: söylenti ağı paneli yalnız debug açıkken kurulur; kaynak→duyan ve geceyi gösterir, okuma ağı kurmaz.

class Baglam extends Node:
	var oturum: Oturum

var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _gelen(id: String) -> Gelen:
	var g := Gelen.new()
	g.id = StringName(id)
	g.ad_anahtari = "test"
	g.sinif = &"koylu"
	return g


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var ust := VBoxContainer.new()
	dene(not AdminHud.arac_acik() and SoylentiPaneli.kur(ust, null) == null and ust.get_child_count() == 0, "Debug kapalıyken panel 0")
	var bos := Oturum.new(kat, 1)
	dene(SoylentiPaneli.satirlar(bos).is_empty() and not bos.has_meta(SoylentiKoprusu.META), "Boş oturumda satır yok, ağ kurulmaz")
	var o := Oturum.new(kat, 3112)
	o.yonetim.gun = 5
	o.gun = 5
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.karar_ver(_gelen("yolcu_a"), &"ret")
	for i in 15:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	o.gece_sonu()
	var b := Baglam.new()
	b.oturum = o
	var p := SoylentiPaneli.kur(ust, b, true)
	var k: Dictionary = SoylentiKoprusu.ag(o).ag_kayitlari["kapi_haksiz_ret_5_yolcu_a"]
	var duyan: Array = k.duyanlar
	dene(p != null and p.text.contains("kapi_haksiz_ret_5_yolcu_a") and p.text.contains("gece 5") and p.text.contains("%s → %s" % [k.kaynak, ", ".join(PackedStringArray(duyan))]), "Panel kaynak→duyanlar ve geceyi gösterir")
	print("SÖYLENTİ PANELİ: GEÇTİ" if hata == 0 else "SÖYLENTİ PANELİ: KALDI (%d hata)" % hata)
	ust.free()
	b.free()
	quit(1 if hata > 0 else 0)
