## TUC-05: mevcut kart altyapısında tek sözleşme defteri.
class_name SiparisSozlesmePaneli
extends RefCounted
## Pazar başındaki durum satırını genişletir; kartı uzatan ikinci HUD yoktur.
static func kapi(e: KoyEkrani, ust: VBoxContainer, etiket: Label) -> void:
 var h := HBoxContainer.new()
 h.add_theme_constant_override("separation", 12)
 ust.add_child(h)
 ust.move_child(h, etiket.get_index())
 etiket.reparent(h)
 var d := LinkButton.new()
 d.text = "Sözleşmeler"
 d.add_theme_font_size_override("font_size", e.ayarlar.boyut(Tema.KUCUK_PX))
 h.add_child(d)
 d.name = "siparis_defteri_ac"
 d.pressed.connect(func() -> void: ac(e))
## Geçerli ziyaret teklifi ve kabul edilmiş siparişler aynı mevcut kartta.
static func ac(e: KoyEkrani) -> void:
 var y := e._y
 var v := e._kart_ac("Sipariş sözleşmeleri")
 v = PazarKartKaydirma.kur(e, v)
 var t := SiparisSozlesmeleri.teklif(y)
 if not t.is_empty():
  e._etiket(v, "%s: %d %s · %d gün içinde · %d akçe" % [t.ad, t.adet, GezginTuccarStogu.ad("koy.kaynak." + t.urun), SiparisSozlesmeleri.AYAR.sure, t.odul], Tema.KUCUK_PX)
  var d := e._dugme("Siparişi kabul et", v)
  d.name = "siparis_kabul"
  d.disabled = not y.siparisler.kabul_edilebilir(y)
  d.pressed.connect(func() -> void:
   if y.siparisler.kabul(y): ac(e))
 else: e._etiket(v, "Şu anda konaklayan tüccar yok; yeni teklif için varışı bekle.", Tema.KUCUK_PX)
 e._etiket(v, "Açık siparişler: %d / %d" % [y.siparisler.aktif_sayisi(), SiparisSozlesmeleri.AYAR.azami_aktif], Tema.KUCUK_PX)
 for s in y.siparisler.sozlesmeler.values():
  e._etiket(v, "%s · %d %s · %d. güne kadar · %d akçe · %s" % [s.ad, s.adet, GezginTuccarStogu.ad("koy.kaynak." + s.urun), s.vade, s.odul, s.durum], Tema.KUCUK_PX)
  SiparisTeslimPaneli.ekle(e, v, s)
 var kapat := PazarKartKaydirma.dugme(e, v, "Pazara dön")
 kapat.pressed.connect(func() -> void: e._pazar_ac())
