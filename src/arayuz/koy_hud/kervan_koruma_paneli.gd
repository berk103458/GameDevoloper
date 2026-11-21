## TUC-15: aynı pazar kartında süreli muhafız kiralama.
class_name KervanKorumaPaneli
extends RefCounted

const IKON_KERVAN := "res://assets/art/icons/icon_trade_caravan.png"

static func ekle(e: KoyEkrani, ust: Control) -> void:
 var y := e._y
 var baslik_satir := HBoxContainer.new()
 baslik_satir.add_theme_constant_override("separation", 8)
 ust.add_child(baslik_satir)
 if ResourceLoader.exists(IKON_KERVAN):
  var tr := TextureRect.new()
  tr.texture = load(IKON_KERVAN)
  tr.modulate = Kabuk.BAR_DOLU
  tr.custom_minimum_size = Vector2(20, 20)
  tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
  tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
  baslik_satir.add_child(tr)
 e._etiket(baslik_satir, "Kervan koruması: %d dışarıda · etkin nöbetçi %d · Güvenlik %d." % [KervanKorumasi.sayi(y), y.etkin_muhafiz_sayisi(), KervanKorumasi.guvenlik(y)], Tema.KUCUK_PX)
 for k in y.koylular:
  if KervanKorumasi.disarida(y, k.id):
   e._etiket(ust, "%s · %d. gün döner" % [k.ad, int(y.kervan_koruma[str(k.id)].donus) + 1], Tema.KUCUK_PX)
  elif KervanKorumasi.aday(y, k.id):
   var id := k.id
   var d := e._dugme("%s kervana kirala · %d kamu akçesi" % [k.ad, int(KervanKorumasi.AYAR.pesin_akce)], ust)
   d.name = "kervan_koruma_" + str(id)
   d.disabled = not KervanKorumasi.uygun(y, id)
   d.tooltip_text = "%d gün yerel savunma/asayiş nöbetine katılmaz; savunma hazırlığı katkısı kalkar, ayrıca geçici Güvenlik -%d. Aynı nüfus, atama ve bordro kalır." % [int(KervanKorumasi.AYAR.sure_gun), int(KervanKorumasi.AYAR.guvenlik_kaybi)]
   d.pressed.connect(func() -> void:
    if KervanKorumasi.kirala(y, id):
     e.sahne3b.yenile()
     e.hud.guncelle()
     e._pazar_ac())
