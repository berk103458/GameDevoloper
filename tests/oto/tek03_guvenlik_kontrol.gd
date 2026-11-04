extends Node

class SessizAna extends Ana:
	func _ready() -> void:
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 4103)
		ayarlar = Ayarlar.new("user://tek03.cfg")
		kayit = GuvenliKayit.new("user://tek03.json")
		theme = Tema.olustur(ayarlar)

func _ready() -> void:
	var ana := SessizAna.new()
	add_child(ana)
	ana.size = Vector2(1920, 1080)
	ana._koye_git()
	await get_tree().process_frame
	var ekran := ana._ekran as KoyEkrani
	ekran.size = Vector2(1920, 1080)
	var y := ekran.oturum.yonetim
	y.agalik = true
	var kisi := y.kabul({"ad": "Nöbetçi", "sinif": "asker", "stat": 6})
	kisi.saglik = 100
	kisi.moral = 80
	KoyluKarti.ac(ekran, kisi.id)
	await get_tree().process_frame
	var satir := ekran.find_child("guvenlik_satiri", true, false) as Label
	var scroll: ScrollContainer = null
	for n in ekran.find_children("*", "ScrollContainer", true, false):
		if n.get_parent() == satir.get_parent() if satir != null else false:
			scroll = n
			break
	if scroll == null:
		for n in ekran.find_children("*", "ScrollContainer", true, false):
			scroll = n
			break
	var yasam := ekran.find_child("yasam_barlari", true, false)
	var olur := satir != null and satir.text.begins_with("Güvenlik")
	olur = olur and scroll != null and scroll.scroll_vertical == 0 and not _icinde(satir, scroll)
	if yasam != null:
		olur = olur and _icinde(yasam, scroll)
	if not olur:
		push_error("satir=%s scroll=%s yasam=%s" % [satir != null, scroll != null, yasam != null])
	print("TEK-03 GÜVENLİK SATIRI: %s" % ("GEÇTİ" if olur else "KALDI"))
	get_tree().quit(0 if olur else 1)

func _icinde(dugum: Node, ata: Node) -> bool:
	var gezgin := dugum
	while gezgin != null:
		if gezgin == ata:
			return true
		gezgin = gezgin.get_parent()
	return false
