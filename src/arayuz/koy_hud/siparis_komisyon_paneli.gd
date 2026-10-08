## TUC-13: mevcut sözleşme defterinin tek teslimat satırını genişletir.
class_name SiparisKomisyonPaneli
extends RefCounted
## Oyuncu komisyon ve kamu netini işlem öncesinde görür; kayıt ikinci kasa yaratmaz.
static func ekle(e: KoyEkrani, ust: Control, s: Dictionary) -> void:
 if s.durum == "teslim" and s.has("komisyon"):
  e._etiket(ust, "Muhafız komisyonu: %d akçe (%d%%); net kamu ödülü %d." % [s.komisyon, s.komisyon_orani, int(s.odul) - int(s.komisyon)], Tema.KUCUK_PX)
 if s.durum != "bekliyor": return
 for oran in SiparisKomisyonu.AYAR.oranlar:
  var teklif := SiparisKomisyonu.onizle(e.oturum, s.id, int(oran))
  var d := e._dugme("Teslim et · %d%% kişisel komisyon" % int(oran), ust)
  d.name = "siparis_komisyon_%s_%d" % [String(s.id).replace(":", "_"), int(oran)]
  d.disabled = teklif.is_empty()
  d.tooltip_text = KasaTransferi.tip("zimmet") + (" Net kamu %d, kişisel %d akçe." % [teklif.kamu, teklif.komisyon] if not teklif.is_empty() else " Teslim veya günlük zimmet koşulları sağlanmıyor.")
  d.pressed.connect(func() -> void:
   if SiparisKomisyonu.teslim(e.oturum, s.id, int(oran)):
    e.hud.guncelle()
    SiparisSozlesmePaneli.ac(e))
