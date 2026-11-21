## TUC-09: mevcut pazar durumuna mevsim fiyat açıklaması.
class_name TicaretFiyatPaneli
extends RefCounted

const IKON_FIYAT := "res://assets/art/icons/icon_trade_price.png"

## Tek kartta ortak hesap; yeni HUD veya fiyat simülasyonu yoktur.
static func ekle(e: KoyEkrani, ust: Control) -> void:
 var h := HBoxContainer.new()
 h.add_theme_constant_override("separation", 8)
 ust.add_child(h)
 if ResourceLoader.exists(IKON_FIYAT):
  var tr := TextureRect.new()
  tr.texture = load(IKON_FIYAT)
  tr.modulate = Kabuk.BAR_DOLU
  tr.custom_minimum_size = Vector2(20, 20)
  tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
  h.add_child(tr)
 var l := e._etiket(h, "Odun/erzak fiyat çarpanı: ×%.2f · genel alışlar parti bedeline yuvarlanır." % TicaretFiyatlari.carpan(e._y, "gida"), Tema.KUCUK_PX)
 l.name = "ticaret_mevsim_fiyati"
