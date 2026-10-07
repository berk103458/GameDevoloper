## EKO-14: mevcut pazar kartındaki çift kasa eylemleri.
class_name KasaTransferPaneli
extends RefCounted
## Ayrı HUD kurmadan gerçek bakiyelerle düğmeleri etkinleştirir.
static func ekle(ekran: KoyEkrani, ust: Control) -> void:
 var o := ekran.oturum
 ekran._etiket(ust, "Kamu: %d · Kişisel: %d akçe" % [o.koy_akce, o.muhafiz_akce], Tema.KUCUK_PX)
 var satir := HBoxContainer.new()
 ust.add_child(satir)
 var adet: int = KasaTransferi.kurtarma_adedi(o)
 _dugme(ekran, satir, "kurtarma", adet, "Açığı kurtar · %d" % adet)
 for n in KasaTransferi.AYAR.dugme_adetleri:
  _dugme(ekran, satir, "zimmet", int(n), "Zimmet · %d" % int(n))
static func _dugme(ekran: KoyEkrani, ust: Control, tur: String, adet: int, ad: String) -> void:
 var o := ekran.oturum
 var d := ekran._dugme(ad, ust)
 d.tooltip_text = KasaTransferi.tip(tur)
 d.disabled = not KasaTransferi.uygun(o, tur, adet)
 d.pressed.connect(func() -> void:
  if ekran.oturum != o: return
  if KasaTransferi.uygula(o, tur, adet):
   ekran._kart_kapat()
   ekran._pazar_ac()
   ekran.hud.guncelle()
 )
