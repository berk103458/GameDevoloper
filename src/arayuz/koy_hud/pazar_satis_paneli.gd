## TUC-10: aynı satış düğmelerinde kasa hedefi; ikinci pazar/HUD oluşturmaz.
class_name PazarSatisPaneli
extends RefCounted
const META := &"pazar_kisisel_satis"
## Kasa seçimi UI tercihi olup model/RNG kaydını değiştirmez.
static func hedef(e: KoyEkrani, ust: Control) -> void:
 var h := HBoxContainer.new()
 ust.add_child(h)
 e._etiket(h, "Satış geliri:", Tema.KUCUK_PX)
 var sec := OptionButton.new()
 sec.name = "pazar_satis_hedefi"
 sec.add_item("Köy kasası")
 sec.add_item("Muhafız kesesi · zimmet")
 h.add_child(sec)
 sec.select(1 if kisisel(e) else 0)
 sec.tooltip_text = KasaTransferi.tip("zimmet")
 sec.item_selected.connect(func(i: int) -> void:
  e.set_meta(META, i == 1)
  e._pazar_ac())
## Aynı kart yeniden açılırken seçim korunur; varsayılan köy kasasıdır.
static func kisisel(e: KoyEkrani) -> bool:
 return bool(e.get_meta(META, false))
