## HAR-08: mevcut Pazar kartına tek süreli anlaşma eylemi.
class_name CeteAnlasmaPaneli
extends RefCounted
## Anlık kamu ödeme koşulu; tıklamada atomik model kontrolü yeniden yapılır.
static func ekle(e: Control,kok: VBoxContainer) -> void:
 var y: KoyYonetimi=e.oturum.yonetim
 var l: Label=e._etiket(kok,CeteAnlasmasi.tip(y),Tema.KUCUK_PX)
 l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 var d: Button=e._dugme(String(CeteAnlasmasi.AYAR.dugme),kok)
 d.name="cete_anlasma_ode"
 d.disabled=not CeteAnlasmasi.odenebilir(y)
 d.pressed.connect(func() -> void:
  if CeteAnlasmasi.ode(y):
   e._kart_kapat()
   e._pazar_ac()
   e.hud.guncelle()
 )
