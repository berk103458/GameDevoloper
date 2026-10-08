class_name SamanBilgisi
extends RefCounted
## Aynı bina kartında mevcut barınak hayvanı ve ortak ambar yem durumu.
static func ekle(y: KoyYonetimi, b: KoyBinasi, p: VBoxContainer) -> void:
 if b.tur not in ["agil", "ahir"]: return
 var et := Label.new()
 et.name = "saman_bilgisi"
 et.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 et.text = "Yaşayan başlangıç koyunu: %d · barınan satın alınmış: %d\n%s" % [SamanBakimi.taban(b), CelepHamdullah.barindir(y, b.id).size(), SamanBakimi.tip(y)]
 et.add_theme_font_size_override("font_size", Tema.KUCUK_PX)
 p.add_child(et)
## Tek mevcut pazar kartında saman alış satırı; stok/para aynı atomik helper ile değişir.
static func pazar(e: KoyEkrani, p: VBoxContainer) -> void:
 var b := Button.new()
 b.name = "saman_al"
 b.text = "%d saman al · %d akçe" % [int(SamanBakimi.AYAR.alis_partisi), ceili(int(SamanBakimi.AYAR.alis_partisi) * float(SamanBakimi.AYAR.alis_fiyat))]
 b.disabled = not e._y.kervan_gunu() or e._y.akce < ceili(int(SamanBakimi.AYAR.alis_partisi) * float(SamanBakimi.AYAR.alis_fiyat)) or e._y.kaynaklar.bos_yer() < int(SamanBakimi.AYAR.alis_partisi)
 b.tooltip_text = SamanBakimi.tip(e._y)
 p.add_child(b)
 b.pressed.connect(func() -> void:
  if SamanBakimi.al(e._y):
   e._kart_kapat()
   e._pazar_ac()
   e.hud.guncelle()
 )
