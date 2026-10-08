## TUC-15: aynı pazar kartında süreli muhafız kiralama.
class_name KervanKorumaPaneli
extends RefCounted
static func ekle(e: KoyEkrani, ust: Control) -> void:
 var y := e._y
 e._etiket(ust, "Kervan koruması: %d dışarıda · etkin nöbetçi %d · Güvenlik %d." % [KervanKorumasi.sayi(y), y.etkin_muhafiz_sayisi(), KervanKorumasi.guvenlik(y)], Tema.KUCUK_PX)
 for k in y.koylular:
  if KervanKorumasi.disarida(y, k.id):
   e._etiket(ust, "%s · %d. gün döner" % [k.ad, int(y.kervan_koruma[str(k.id)].donus) + 1], Tema.KUCUK_PX)
  elif KervanKorumasi.aday(y, k.id):
   var id := k.id
   var d := e._dugme("%s kervana kirala · %d kamu akçesi" % [k.ad, int(KervanKorumasi.AYAR.pesin_akce)], ust)
   d.name = "kervan_koruma_" + str(id)
   d.disabled = not KervanKorumasi.uygun(y, id)
   d.tooltip_text = "%d gün yerel savunma/asayiş nöbetine katılmaz; geçici Güvenlik -%d. Aynı nüfus, atama ve bordro kalır." % [int(KervanKorumasi.AYAR.sure_gun), int(KervanKorumasi.AYAR.guvenlik_kaybi)]
   d.pressed.connect(func() -> void:
    if KervanKorumasi.kirala(y, id):
     e.sahne3b.yenile()
     e.hud.guncelle()
     e._pazar_ac())
