## ODA-09: aynı odada açıkça rüya diye etiketlenen tek kutu; Clue/başka HUD yok.
class_name OdaVicdanPaneli
extends RefCounted
## Saf vicdan görünümü ve bu günün sınırlı kutu algısı; kaynak/kasa/skor değişmez.
static func kur(e: MuhafizOdasiEkrani,v: VBoxContainer) -> void:
 var d:=MuhafizVicdani.oku(e.oturum.muhafiz_vicdani)
 var l:=Label.new()
 l.name="oda_vicdan"
 l.text="Vicdan yükü: %d/%d · haksız ret %d, köyde kaybedilen %d. Her gece yük −%d; eşik %d olduğunda kabus yorgunluğu +%d."%[int(d.yuk),int(MuhafizVicdani.AYAR.yuk_azami),int(d.haksiz_ret),int(d.olum),int(MuhafizVicdani.AYAR.gece_sonum),int(MuhafizVicdani.AYAR.kabus_esigi),int(MuhafizVicdani.AYAR.kabus_yorgunluk)]
 if MuhafizVicdani.aktif(e.oturum):
  l.text+="\nBu gölge bir rüya; kanıt veya yeni kimlik bilgisi değil. Yatakta dinlenmek yorgunluğu giderir; geçmiş kararları silmez."
  if not e.oda.has_node("kabus_golgesi"): e.oda.call("_kutu",MuhafizVicdani.AYAR.golge)
 var yoz_uyari := preload("res://src/arayuz/oda_yozlasma_uyarisi.gd").satir(e.oturum)
 if not yoz_uyari.is_empty(): l.text += "\n" + yoz_uyari
 l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 v.add_child(l)
