## OGR-12: Debug HUD'da ipucu akisi izlenir.
## `admin_hud.gd` listesine "gorulen ipuclari" satiri ve "hepsini sifirla" dugmesi ekler.
## Oyuncu arayuzune girmez; debug kapaliyken (`not AdminHud.arac_acik()`) dugme olusturulmaz.
class_name IpucuPaneli
extends HBoxContainer

signal sifirlandi

var kayit: IpucuKaydi = IpucuKaydi.new()
var etiket: Label
var sifirla_dugmesi: Button


func _init(debug_acik: bool = AdminHud.arac_acik()) -> void:
	name = "IpucuPaneli"
	visible = debug_acik
	if not debug_acik:
		return
	etiket = Label.new()
	etiket.name = "GorulenIpuclariEtiketi"
	etiket.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	add_child(etiket)
	sifirla_dugmesi = Button.new()
	sifirla_dugmesi.name = "HepsiniSifirlaDugmesi"
	sifirla_dugmesi.text = "Hepsini sıfırla"
	sifirla_dugmesi.pressed.connect(hepsini_sifirla)
	add_child(sifirla_dugmesi)
	yenile()


static func kur(ust: Node, debug_acik: bool = AdminHud.arac_acik()) -> IpucuPaneli:
	var p := IpucuPaneli.new(debug_acik)
	if ust != null and debug_acik:
		ust.add_child(p)
	return p


func dugme_sayisi() -> int:
	return 1 if sifirla_dugmesi != null else 0


func yenile() -> void:
	if etiket == null:
		return
	var liste := kayit.gorulen_listesi() if kayit != null else []
	if liste.is_empty():
		etiket.text = "Görülen ipuçları: (yok)"
	else:
		etiket.text = "Görülen ipuçları: " + ", ".join(liste)


func hepsini_sifirla() -> void:
	if kayit != null:
		kayit.sifirla()
	yenile()
	sifirlandi.emit()
