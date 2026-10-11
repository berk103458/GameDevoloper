## TEK-04: kayıt süzgeci ve gerçek yüz/heybe/CHR adaptör düğmeleri; tam ekran oto testte.
extends SceneTree
const T := preload("res://src/kapi/hastalik_teshis_adaptoru.gd")
class TestEkrani extends Control:
	var _kayit: RichTextLabel
	var _gelen: Gelen
	var evre: StringName = &""
	func _yaz(s: String) -> void:
		_kayit.append_text(T.kayit_metni(_kayit, s) + "\n")
	func _sohbet_goster() -> void: pass
	func _karar_goster() -> void: pass
var hata := 0
var kontrol := 0

func _initialize() -> void:
	call_deferred("_test")

func _test() -> void:
	var e := TestEkrani.new()
	e._kayit = RichTextLabel.new()
	e._kayit.bbcode_enabled = true
	var g := Gelen.new()
	g.acik_bayraklar = ["belirti_ates", "belirti_kanli_oksuruk"]
	g.heybe = Heybe.new()
	e._gelen = g
	var kap := VBoxContainer.new()
	T.eylem(e, g, kap)
	var heybe := Control.new()
	T.heybe_bagla(heybe, e, g)
	(kap.get_node("HastalikIncele") as Button).pressed.emit()
	(heybe.get_node("HastalikHeybeIncele") as Button).pressed.emit()
	dene(e._kayit.get_parsed_text().count("Teşhis ibresi:") == 1, "Yüz ve heybe: kayıtta ibre 1")
	dene(T.kaydet(g).size() == 2 and e._kayit.get_parsed_text().contains("kan"), "İki ipucu ve heybe bulgusu korunur")
	(kap.get_node("HastalikIncele") as Button).pressed.emit()
	(heybe.get_node("HastalikHeybeIncele") as Button).pressed.emit()
	dene(e._kayit.get_parsed_text().count("Teşhis ibresi:") == 1, "Tekrar düğmeleri ibreyi çoğaltmaz")
	dene((heybe.get_node("HastalikIbre") as Label).text.contains(T.metin(g)), "Panel etiketi güncel kalır")
	# Aynı yazma kuralı CHR portre/yük yolunda da geçerlidir.
	e._kayit.clear()
	var panel := Control.new()
	var kutu := VBoxContainer.new()
	panel.add_child(kutu)
	var portre := Button.new()
	portre.name = "GorselIz"
	kutu.add_child(portre)
	kutu.add_child(Label.new())
	var yuk := Button.new()
	kutu.add_child(yuk)
	T.chr_bagla(panel, e, g)
	portre.pressed.emit()
	yuk.pressed.emit()
	dene(e._kayit.get_parsed_text().count("Teşhis ibresi:") == 1, "CHR yüz/yük kaydında ibre 1")
	# Belirtisizden yeni şüpheye değişen ibre saklanmaz.
	e._kayit.clear()
	e._yaz(T.metin(Gelen.new()))
	e._yaz(T.metin(g))
	e._yaz(T.metin(g))
	dene(e._kayit.get_parsed_text().count("Teşhis ibresi:") == 2, "Değişen ibre bir kez görünür")
	e._kayit.clear()
	e._yaz(T.metin(g) + "\n" + T.metin(g))
	dene(e._kayit.get_parsed_text().count("Teşhis ibresi:") == 1, "Yeni ziyaret ve tek çağrı içindeki tekrar")
	e._yaz("Sıradan konuşma")
	e._yaz("Sıradan konuşma")
	dene(e._kayit.get_parsed_text().count("Sıradan konuşma") == 2, "Diğer konuşma satırları süzülmez")
	panel.free()
	heybe.free()
	kap.free()
	e._kayit.free()
	e.free()
	print("TEK-04 TEŞHİS İBRESİ: GEÇTİ (%d kontrol)" % kontrol if hata == 0 else "TEK-04 TEŞHİS İBRESİ: KALDI")
	quit(hata)

func dene(ok: bool, mesaj: String) -> void:
	kontrol += 1
	if not ok:
		hata += 1
		push_error(mesaj)
