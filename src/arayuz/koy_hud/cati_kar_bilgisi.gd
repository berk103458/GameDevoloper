class_name CatiKarBilgisi
extends RefCounted
## Mevcut bina bilgi kartında risk ve boş yetişkinle temizlik açıklaması.
static func ekle(y: KoyYonetimi, b: KoyBinasi, p: VBoxContainer) -> void:
 if b.tur not in CatiKarBakimi.AYAR.turler or (MevsimKarOrtusu.oran(y) < float(CatiKarBakimi.AYAR.agir_esik) and float(b.cati_kar.yuk) <= 0): return
 var temiz := b.id in CatiKarBakimi.gorevler(y).values()
 var et := Label.new()
 et.name = "cati_kar_bilgisi"
 et.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 et.text = "Çatı kar yükü %.1f / %.1f · ağır karda çökme riski %d%%. %s" % [float(b.cati_kar.yuk), float(CatiKarBakimi.AYAR.cokme_yuku), int(CatiKarBakimi.AYAR.cokme_yuzde), "Boş yetişkin kürekle temizleyecek." if temiz else "Temizlik için sağlıklı yetişkini boşta bırak."]
 et.add_theme_font_size_override("font_size", Tema.KUCUK_PX)
 et.add_theme_color_override("font_color", Hud.UYARI)
 p.add_child(et)
