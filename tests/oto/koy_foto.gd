## Köy yönetimi ekranı fotoğrafı: birkaç gün oynanmış bir köy kurar (yapılar, atamalar), KoyEkrani'ni açar,
## bir yapıyı seçip hayalet önizlemeyi gösterir ve ekran görüntüsünü CIKTI'ya kaydeder.
## Çalıştırma: CIKTI=/yol/koy.png [GUN=6] [KIP=bilgi|insa|rapor] godot --path . tests/oto/koy_foto.tscn
extends Node


func _ready() -> void:
	TranslationServer.set_locale("tr")
	var k := Katalog.new()
	k.yukle()
	var o := Oturum.new(k, 21)
	var y := o.yonetim
	var gun := int(OS.get_environment("GUN")) if OS.get_environment("GUN") != "" else 6
	var siniflar: Array[StringName] = [&"ciftci", &"ciftci", &"esnaf", &"asker", &"ciftci", &"esnaf"]
	for i in 12:
		y.kabul({"ad": ["Hasan", "Ayşe", "Bekir", "Fadime", "İdris", "Zeynep", "Osman", "Emine", "Halil", "Satı", "Cemil", "Rahime"][i],
			"sinif": siniflar[i % siniflar.size()], "portre": "", "stat": 3 + i % 6, "bayraklar": ["usta_ciftci"] if i == 1 else []})
	o._koy_esitle()
	for t in ["odun", "tas", "kereste", "alet"]:
		y.kaynaklar.ekle(t, 25)
	var m := y.a.meydan
	var yx := m.position.x + m.size.x / 2
	# Yollar meydandan dışa doğru döşenir (her hücre bağlı bir yola komşu olmalı).
	for yy in range(m.position.y - 1, m.position.y - 7, -1):
		y.yol_kur(Vector2i(yx, yy))
	for xx in range(m.position.x - 1, m.position.x - 8, -1):
		y.yol_kur(Vector2i(xx, m.position.y + 1))
	for xx in range(m.end.x, m.end.x + 7):
		y.yol_kur(Vector2i(xx, m.position.y + 2))
	var kur := func(tur: String, h: Vector2i) -> int:
		var d := y.bina_kur(tur, h)
		return d["id"]
	var t1: int = kur.call("tarla", Vector2i(m.end.x, m.position.y - 1))
	var t2: int = kur.call("tarla", Vector2i(m.end.x + 3, m.position.y + 3))
	kur.call("cadir", Vector2i(m.position.x - 2, m.position.y - 2))
	kur.call("cadir", Vector2i(m.position.x - 4, m.position.y + 2))
	kur.call("kulube", Vector2i(m.position.x - 6, m.position.y + 2))
	var hz: int = kur.call("hizarhane", Vector2i(yx + 1, m.position.y - 4))
	kur.call("tas_ocagi", Vector2i(yx - 2, m.position.y - 5))
	kur.call("ambar", Vector2i(m.position.x - 5, m.position.y - 1))
	kur.call("atolye", Vector2i(m.end.x + 3, m.position.y))
	y.kaynaklar.ekle("gida", 30)
	for g in gun:
		var i := 0
		for b in [t1, t1, t1, t2, t2, hz, hz]:
			if i < y.koylular.size():
				y.ata(y.koylular[i].id, b)
			i += 1
		y.gece()
	y.bina_kur("kulube", Vector2i(m.position.x - 6, m.position.y + 5))
	y.muhafiz_ata(y.koylular[11].id)
	o._koy_esitle()
	var ayarlar := Ayarlar.new()
	var e := KoyEkrani.new()
	e.oturum = o
	e.ayarlar = ayarlar
	var ana := Control.new()
	ana.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	ana.theme = Tema.olustur(ayarlar)
	get_tree().root.add_child.call_deferred(ana)
	ana.add_child.call_deferred(e)
	await get_tree().create_timer(1.0).timeout
	match OS.get_environment("KIP"):
		"insa":
			e._kategori = "uretim"
			e._yapi_satirini_ciz()
			e._kip_sec("insa", "tarla")
			e._imlec = Vector2i(m.position.x - 4, m.position.y - 6)
			e._hayalet_guncelle()
		"rapor":
			e._geceye_gec()
		_:
			e._secili_bina = t1
			e.sahne3b.secim_goster(y.bina(t1))
			e._bilgi_goster()
	await get_tree().create_timer(float(OS.get_environment("BEKLE")) if OS.get_environment("BEKLE") != "" else 3.0).timeout
	await RenderingServer.frame_post_draw
	get_viewport().get_texture().get_image().save_png(OS.get_environment("CIKTI"))
	Ses.cik()
