class_name GezginStokIkonu
extends RefCounted
## Yeni stok ikonları gerçek asset gelene kadar aynı kartta düz renk kutudur.
static func ikon(r: TextureRect, tur: String) -> bool:
 if tur not in ["civi", "tirpan", "balta"]: return false
 var c := ColorRect.new()
 r.add_child(c)
 c.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 c.color = Color("#857c65")
 c.mouse_filter = Control.MOUSE_FILTER_IGNORE
 return true
