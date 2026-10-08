## TUC-02: mevcut pazar/çeki özeti altında aynı hayvan işlemi düğmeleri.
class_name CelepPazarAdaptoru
extends RefCounted
static func ekle(e: KoyEkrani, ust: Control) -> void:
 var y := e.oturum.yonetim
 if not CelepHamdullah.geldi(y): return
 HayvanTakasPaneli.ekle(e, ust)
 e._etiket(ust, "Koç: %d / %d ek ağıl yeri · Celep konaklamasında alım" % [CelepHamdullah.sayi(y.lojistik, "koc"), CelepHamdullah.kapasite(y, "koc")], Tema.KUCUK_PX)
 var satir := HBoxContainer.new()
 ust.add_child(satir)
 for t in CelepHamdullah.AYAR.hayvanlar:
  var tur: String = t
  var d := e._dugme("%s al · %d akçe" % [CelepHamdullah.AYAR.hayvanlar[t].ad, CekiLojistigi.FIYAT[t]], satir)
  d.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  d.disabled = not y.lojistik.alinabilir(y, tur)
  d.tooltip_text = "Celep pazarda, kamu kasasında para ve hazır %s içinde boş yer gerekir." % CelepHamdullah.barinak(tur)
  d.pressed.connect(func() -> void:
   if y.lojistik.al(y, tur):
    e.sahne3b.yenile()
    e._kart_kapat()
    e._pazar_ac()
    e.hud.guncelle())
