class_name GezginStokIkonu
extends RefCounted
## Yeni stok ikonları gerçek asset gelene kadar aynı kartta düz renk kutudur.
static func ikon(r: TextureRect, tur: String) -> bool:
 if tur not in ["civi", "tirpan", "balta", "afyon", "sargi", "kece", "kumas", "zirh", "yay", "kalkan", "su", "saman", "ilac"]: return false
 var renk := String(SamanBakimi.AYAR.ikon_renk) if tur == "saman" else (Kabuk.STOK_SU.to_html() if tur == "su" else Kabuk.STOK_KUMAS.to_html())
 var c := Kabuk.yer_tutucu(tur, renk, Vector2.ZERO)
 r.add_child(c)
 c.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 return true
