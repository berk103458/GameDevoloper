extends Node
const F = preload("res://tests/oto/atama_duraklat_kontrol.gd")
const D = preload("res://src/koy/usta_defterleri.gd")
func _ready() -> void:
	call_deferred("_calistir")
func _calistir() -> void:
	get_tree().create_timer(45.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := F.TestAna.new()
	add_child(ana)
	D.ekle(ana.oturum,"usta_defteri_marangoz")
	ana._koye_git()
	await get_tree().process_frame
	var e := ana._ekran as KoyEkrani
	var once := ana.oturum.kaydet()
	KisiselKaraborsaPaneli.ac(e)
	await get_tree().process_frame
	var bulundu := false
	for l in e.find_children("*","Label",true,false):
		if l.text.contains("Marangoz ustasının defteri") and l.text.contains("1 adet"): bulundu = true
	var hata := int(not bulundu or ana.oturum.kaydet() != once)
	if hata: push_error("Usta defteri mevcut kişisel envanterde tek adet görünmeli; okuma oyun durumunu değiştirmemeli")
	ana.queue_free()
	await get_tree().process_frame
	print("USTA DEFTERİ ENVANTER: GEÇTİ" if hata == 0 else "USTA DEFTERİ ENVANTER: KALDI")
	await Ses.cik(hata)
