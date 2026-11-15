## DEN-05, DEN-06, DEN-22: gerçek gece düğmesi ölçüm raporunu geliştirme günlüğüne yazar.
## Rapor gece hesabını ikinci kez çalıştırmaz, oyuncuya görünmez, yüz başarısız zar tek satırdır.
extends Node

class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_denge_gunlugu.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		katalog._olaylar.clear()
		oturum = Oturum.new(katalog, 103)
		kayit = GuvenliKayit.new("user://test_denge_gunlugu.json")
		theme = Tema.olustur(ayarlar)

var hata := 0


func _kontrol(kosul: bool, ad: String) -> void:
	if kosul:
		print("GEÇTİ: ", ad)
	else:
		hata += 1
		push_error("KALDI: " + ad)


func _metinler(n: Node, cikti: Array[String]) -> void:
	if n is Label or n is RichTextLabel or n is Button:
		cikti.append(String(n.get("text")))
	for c in n.get_children():
		_metinler(c, cikti)


func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	ana.oturum.yonetim.kabul({"ad": "Ölçümcü", "sinif": "ciftci"})
	ana._koye_git()
	await get_tree().process_frame
	var gunluk := ana.get_node("PerformansGunlugu") as PerformansGunlugu
	gunluk.etkin = true
	var ekran := ana._ekran as KoyEkrani
	_kontrol(ekran != null, "Gerçek köy ekranı")
	for i in 100:
		DengeGunlugu.zar_basarisiz()
	var gun_once: int = ana.oturum.yonetim.gun
	ekran._gece_dugmesi.pressed.emit()
	_kontrol(ana.oturum.yonetim.gun == gun_once + 1, "Gece tek kez ilerledi")
	var yol := DengeGunlugu.son_dosya
	var satirlar: Array = []
	var f := FileAccess.open(yol, FileAccess.READ)
	while f != null and not f.eof_reached():
		var metin := f.get_line()
		if not metin.is_empty():
			satirlar.append(JSON.parse_string(metin))
	_kontrol(yol.begins_with("user://denge_") and satirlar.size() == 1, "Gece başına tek JSONL satırı: %s" % yol)
	if satirlar.size() == 1 and satirlar[0] is Dictionary:
		var r: Dictionary = satirlar[0]
		_kontrol(int(r.get("basarisiz_zar_sayisi", -1)) == 100, "Yüz başarısız zar tek sayı (DEN-22)")
		_kontrol(r.get("oyuncuya_gorunur", true) == false, "Rapor oyuncuya görünmez işaretli (DEN-06)")
		_kontrol(int(r.get("gun", -1)) == ana.oturum.yonetim.gun, "Rapor gece_sonu sonrası günü okuyor, yeni gün üretmiyor (DEN-05)")
	_kontrol(DengeGunlugu.basarisiz_zar_sayisi() == 0, "Sayaç gece sonunda sıfırlanır")
	var ui: Array[String] = []
	_metinler(ana, ui)
	_kontrol(not ui.any(func(t: String) -> bool: return "basarisiz_zar" in t or "oyuncuya_gorunur" in t or "denge_" in t), "Köy ekranında ölçüm alanı görünmez (DEN-06)")
	gunluk.etkin = false
	_kontrol(DengeGunlugu.yaz(ekran, ana.oturum, {}).is_empty(), "Günlük kapalıyken (oyuncu sürümü) hiçbir şey yazılmaz")
	DirAccess.remove_absolute(yol)
	ana.kayit.sil()
	print("DENGE GUNLUGU: ", "GEÇTİ" if hata == 0 else "KALDI")
	get_tree().quit(hata)
