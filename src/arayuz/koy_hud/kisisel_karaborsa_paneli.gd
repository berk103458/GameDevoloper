## TUC-11: aynı pazarda kişisel alış; mevcut muhafız eşyalarının oda görünümü.
class_name KisiselKaraborsaPaneli
extends RefCounted
## Kamu stok alışından açıkça farklı para kaynağı; mevcut kart/HUD genişletilir.
static func ekle(e: KoyEkrani, ust: Control) -> void:
 var oda := e._dugme("Muhafız odası · kişisel eşyalar", ust)
 oda.name = "muhafiz_odasi_ac"
 oda.pressed.connect(func() -> void: ac(e))
 if not KaraborsaAdaptoru.geldi(e.oturum): return
 e._etiket(ust, "Kişisel karaborsa · yalnız muhafız kesesi", Tema.KUCUK_PX)
 var h := HBoxContainer.new()
 ust.add_child(h)
 for id in KaraborsaAdaptoru.AYAR:
  var t: String = id
  var u: Dictionary = KaraborsaAdaptoru.AYAR[t]
  var d := e._dugme("%s %d · %d kişisel akçe" % [u.ad, KaraborsaAdaptoru.kalan(e.oturum, t), u.fiyat], h)
  d.name = "kisisel_al_" + t
  d.tooltip_text = u.aciklama
  d.disabled = not KaraborsaAdaptoru.alinabilir(e.oturum, t)
  d.pressed.connect(func() -> void:
   if KaraborsaAdaptoru.al(e.oturum, t):
    e.hud.guncelle()
    e._pazar_ac())
## Tek mevcut muhafız eşya listesi okunur; açmak stok/kasa/RNG değiştirmez.
static func ac(e: KoyEkrani) -> void:
 var v := e._kart_ac("Muhafız odası · kişisel envanter")
 v = PazarKartKaydirma.kur(e, v)
 if e.oturum.muhafiz_esyalari.is_empty(): e._etiket(v, "Kişisel eşya yok.", Tema.KUCUK_PX)
 for esya in e.oturum.muhafiz_esyalari:
  var h := HBoxContainer.new()
  v.add_child(h)
  var kutu := Kabuk.yer_tutucu("KisiselEsya", Kabuk.STOK_KUMAS.to_html(), Vector2(28, 28))
  h.add_child(kutu)
  e._etiket(h, "%s · %d adet" % [esya.get("ad", esya.get("kaynak", esya.get("tur", "Eşya"))), esya.get("adet", 0)], Tema.KUCUK_PX)
 var kapat := PazarKartKaydirma.dugme(e, v, "Pazara dön")
 kapat.pressed.connect(e._pazar_ac)
