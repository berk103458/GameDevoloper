## TUC-06: aynı sözleşme defterinde teslim düğmesi ve tüccar itibar satırı.
class_name SiparisTeslimPaneli
extends RefCounted
## Normal teslim kamuya gider; isteğe bağlı komisyon aynı defter adaptöründedir.
static func ekle(e: KoyEkrani, ust: Control, s: Dictionary) -> void:
 var y := e._y
 SiparisKomisyonPaneli.ekle(e, ust, s)
 e._etiket(ust, "Tüccar itibarı: %d / %d" % [int(y.tuccar_itibari.get(s.tuccar, {}).get("puan", 0)), int(SiparisTeslimati.AYAR.itibar_ust)], Tema.KUCUK_PX)
 if s.durum != "bekliyor": return
 var d := e._dugme("Siparişi teslim et", ust)
 d.name = "siparis_teslim_" + String(s.id).replace(":", "_")
 d.disabled = not SiparisTeslimati.teslim_edilebilir(y, s.id)
 d.tooltip_text = "Tam miktar ambardan düşer; vade günü dahil zamanında teslim ödül ve itibar verir."
 d.pressed.connect(func() -> void:
  if SiparisTeslimati.teslim(y, s.id):
   e.hud.guncelle()
   SiparisSozlesmePaneli.ac(e))
