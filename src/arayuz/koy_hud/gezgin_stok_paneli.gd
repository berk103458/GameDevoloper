## TUC-03: mevcut pazar kartının uzman stok satırı.
class_name GezginStokPaneli
extends RefCounted
## Geçerli uzman ürünlerini mevcut pazar kartına tek satın alma satırı olarak bağlar.
static func ekle(e: KoyEkrani, ust: Control) -> void:
 var y := e._y
 SilahKaraborsaPaneli.ekle(e, ust)
 KisiselKaraborsaPaneli.ekle(e, ust)
 var urunler := GezginTuccarStogu.urunler(y)
 if urunler.is_empty(): return
 e._etiket(ust, "Uzman stoğu · konaklama boyunca ortak miktar", Tema.KUCUK_PX)
 var h := HBoxContainer.new()
 ust.add_child(h)
 for tur in urunler:
  var t: String = tur
  var u: Dictionary = urunler[t]
  var d := e._dugme("%s %d · %d akçe" % [u.ad, y.gezgin_ticaret.kalan(y, t), u.fiyat], h)
  d.name = "gezgin_al_" + t
  d.tooltip_text = "Bir adet al; gösterilen stok bu ziyaretin iki gününde ortaktır. " + String(u.get("aciklama", ""))
  d.disabled = not y.gezgin_ticaret.alinabilir(y, t, 1)
  d.pressed.connect(func() -> void:
   if y.gezgin_ticaret.al(y, t, 1):
    e._kart_kapat()
    e._pazar_ac()
    e.hud.guncelle())
