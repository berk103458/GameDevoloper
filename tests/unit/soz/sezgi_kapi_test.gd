extends Node
const S = preload("res://src/soz/muhafiz_sezgisi.gd")
class Host extends Control:
	var oturum: Oturum
	var satirlar: Array[String] = []
	func _yaz(m: String) -> void: satirlar.append(m)
	func _chr_tansiyon_degisti(_v: int) -> void: pass
	func _chr_replik_basladi(_m: String) -> void: pass
	func _karar_goster() -> void: pass
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _ready() -> void:
	call_deferred("calistir")
func calistir() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var h := Host.new()
	add_child(h)
	h.oturum = Oturum.new(kat, 1706)
	preload("res://src/sistemler/muhafiz_gecmisi.gd").sec(h.oturum, "medrese_talebesi")
	h.oturum.muhafiz_tecrubesi = S.esik()
	var g := h.oturum._adli_gelen(&"chr_001")
	var kap := VBoxContainer.new()
	h.add_child(kap)
	var eylem := VBoxContainer.new()
	h.add_child(eylem)
	var adapter = preload("res://src/arayuz/chr_kapi_adaptoru.gd")
	dene(adapter.diyalog_goster(h, g, kap, eylem), "Gerçek CHR adaptörü sezgiye bağlandı")
	dene(h.satirlar.size() == 1 and h.satirlar[0].contains("Sezgi:"), "Ek satır kendiliğinden görünür")
	adapter.diyalog_goster(h, g, kap, eylem)
	dene(h.satirlar.size() == 1, "Panel yeniden açılınca ikinci satır yok")
	h.queue_free()
	await get_tree().process_frame
	print("SEZGİ KAPI: GEÇTİ" if hata == 0 else "SEZGİ KAPI: KALDI")
	await get_tree().create_timer(1.0).timeout
	get_tree().quit(hata)
