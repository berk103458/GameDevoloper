## CAS-13: aynı ambar/değirmen bina kartında gerçekten bulunan yük ipucu; fail gözlemi değildir.
class_name KundakClueBilgisi
extends RefCounted
static func ekle(y: KoyYonetimi,b: KoyBinasi,p: VBoxContainer) -> void:
 if b.tur not in ["ambar","degirmen"]: return
 var n:=0
 for k in y.koylular:
  if SabotajClueSozlesmesi.bulunan_yuk(k,AmbarKundaklamasi.AYAR.clue_sozlesmesi): n+=1
 if n==0: return
 var l:=Label.new()
 l.name="kundak_clue_bilgisi"
 l.text="Kapıda bulunan kundak malzemesi yük ipucu: %d. Malzeme tek başına gece failinin gözlemi değildir." % n
 l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 l.add_theme_font_size_override("font_size",Tema.KUCUK_PX)
 p.add_child(l)
