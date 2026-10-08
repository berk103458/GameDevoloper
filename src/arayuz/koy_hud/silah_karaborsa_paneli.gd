## TUC-08: mevcut pazarın isteğe bağlı, bedeli ve sonucu görünür kaçak teklifi.
class_name SilahKaraborsaPaneli
extends RefCounted
## Aynı kartta tek teklif; ikinci nüfus veya donanım paneli oluşturmaz.
static func ekle(e: KoyEkrani, ust: Control) -> void:
 if not SilahKaraborsasi.geldi(e._y): return
 var a := SilahKaraborsasi.AYAR
 e._etiket(ust, "Karaborsa · Kaçak tutsak teklifi · Adalet -%d, Asayiş riski +%d" % [a.adalet_kaybi, a.asayis_artis], Tema.KUCUK_PX)
 var d := e._dugme("Kaçak tutsağı al · %d akçe" % int(a.fiyat), ust)
 d.name = "karaborsa_tutsak_al"
 d.tooltip_text = "Boş yatak gerekir; kişi normal köylü olarak barındırılır. Konaklama başına tek teklif."
 d.disabled = not SilahKaraborsasi.alinabilir(e._y)
 d.pressed.connect(func() -> void:
  if SilahKaraborsasi.al(e._y) != null:
   e.sahne3b.yenile()
   e.hud.guncelle()
   e._pazar_ac())
