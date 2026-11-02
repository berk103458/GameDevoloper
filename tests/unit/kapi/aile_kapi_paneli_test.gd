extends Node
const A = preload("res://src/kapi/aile_kafilesi.gd")
class TestKapi extends KapiEkrani:
	var son_karar := ""
	func _ready() -> void: pass
	func _daralt(_dar: bool) -> void: pass
	func _sirayla_goster(_d: Array[Button]) -> void: pass
	func _karar_ver(anahtar: String, _is_yeri: StringName = &"") -> void:
		son_karar = anahtar
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _ready() -> void:
	call_deferred("calistir")
func calistir() -> void:
	GuvenliMetin.kur()
	var e := TestKapi.new()
	add_child(e)
	e.ayarlar = Ayarlar.new()
	var kat := Katalog.new()
	kat.yukle()
	e.oturum = Oturum.new(kat, 1517)
	for alan in ["_secenekler", "_eylemler"]:
		var kap := VBoxContainer.new()
		e.add_child(kap)
		e.set(alan, kap)
	for alan in ["_bolum", "_bilgi"]:
		var label := Label.new()
		e.add_child(label)
		e.set(alan, label)
	e._gelen = Gelen.new()
	e._gelen.secenekler = PackedStringArray(["kabul", "ret"])
	e._gelen.aile = A.uyeleri_oku([{ "ad":"Ali" }, { "ad":"Ayşe", "yas_grubu":"cocuk" }])
	e._karar_goster()
	dene(e._karar_anahtarlari.has("cocuklari_al") and e._karar_dugmeleri.size() == 3, "Çocuklu ailede ayrı karar düğmesi")
	var bolme := e._karar_dugmeleri[2]
	dene(bolme.text.contains("Yalnız çocukları al"), "İnsan okunur bölme etiketi")
	bolme.pressed.emit()
	dene(e.son_karar.is_empty(), "İlk basış yalnız onay seçer")
	bolme.pressed.emit()
	dene(e.son_karar == "cocuklari_al", "İkinci basış aynı karar yoluna bağlanır")
	e._gelen.aile[1].yas_grubu = "yetiskin"
	e._karar_goster()
	dene(not e._karar_anahtarlari.has("cocuklari_al"), "Çocuksuz ailede düğme yok")
	var grup := Node3D.new()
	preload("res://src/dunya/aile_kapi_gorunumu.gd").kur(grup, e._gelen)
	dene(grup.get_node("AileRefakatcileri").get_child_count() == 1, "Refakatçi reise bağlı isimli kutudur")
	grup.free()
	var f := KarakterModel.new()
	var k := Koylu.new()
	k.yas_grubu = &"yasli"
	k.bayrak_ekle("kap17_aile")
	preload("res://src/koy/gorsel/aile_yas_gorunumu.gd").kur(f, k)
	preload("res://src/koy/gorsel/aile_yas_gorunumu.gd").kur(f, k)
	dene(f.get_child_count() == 1 and is_equal_approx(f.scale.y, 0.92), "Yaşlı yer tutucusu tek yerde, tekrar küçültülmez")
	f.free()
	e.queue_free()
	await get_tree().create_timer(0.5).timeout
	print("AİLE KAPI PANELİ: GEÇTİ" if hata == 0 else "AİLE KAPI PANELİ: KALDI")
	get_tree().quit(hata)
