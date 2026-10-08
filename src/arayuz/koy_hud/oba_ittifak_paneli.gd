## HAR-07: mevcut Pazar kartına tek oba adaptörü; ikinci HUD yok.
class_name ObaIttifakPaneli
extends RefCounted
## Aynı modelin güncel koşullarını gösterir; tıklamada koşullar yeniden doğrulanır.
static func ekle(e: Control,kok: VBoxContainer) -> void:
 var o: Oturum=e.oturum
 var l: Label=e._etiket(kok,ObaIttifaki.tip(o),Tema.KUCUK_PX)
 l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 for tur in ["at","alp"]:
  var d: Button=e._dugme(String(ObaIttifaki.AYAR.at_dugme if tur=="at" else ObaIttifaki.AYAR.alp_dugme),kok)
  d.name="oba_takas_"+tur
  d.disabled=not ObaIttifaki.uygun(o,tur)
  d.pressed.connect(func() -> void:
   if ObaIttifaki.takas(o,tur).ok:
    e._kart_kapat()
    e._yenile()
    e._pazar_ac()
  )
