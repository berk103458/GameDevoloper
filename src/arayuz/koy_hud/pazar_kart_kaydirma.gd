## TUC-06: büyüyen mevcut pazar/defter kartına sınırlı içerik alanı; kapanış sabit kalır.
class_name PazarKartKaydirma
extends RefCounted
## Başlık mevcut üst kutuda kalır; yalnız içerik kaydırılır, ikinci panel oluşmaz.
static func kur(e: KoyEkrani, ust: VBoxContainer) -> VBoxContainer:
 var sc := ScrollContainer.new()
 sc.name = "pazar_kart_kaydirma"
 sc.custom_minimum_size = Vector2(maxf(180, minf(720, e.size.x - 100)), maxf(120, e.size.y - 220))
 sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
 sc.follow_focus = true
 ust.add_child(sc)
 var v := VBoxContainer.new()
 v.add_theme_constant_override("separation", 10)
 v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 sc.add_child(v)
 v.set_meta("kart_ust", ust)
 var limit := maxf(120, e.size.y - 220)
 var boyutla := func() -> void:
  if is_instance_valid(sc) and is_instance_valid(v):
   sc.custom_minimum_size.y = minf(limit, maxf(120, v.get_combined_minimum_size().y))
   if is_instance_valid(e._ust_kart): e._ust_kart.reset_size.call_deferred()
 v.minimum_size_changed.connect(boyutla)
 boyutla.call_deferred()
 return v
## Kaydırma konumu ne olursa olsun dönüş/kapanış düğmesi görünür.
static func dugme(e: KoyEkrani, v: VBoxContainer, metin: String) -> Button:
 return e._dugme(metin, v.get_meta("kart_ust", v))
