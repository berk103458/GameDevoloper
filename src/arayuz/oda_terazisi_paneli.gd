## ODA-04: aynı oda listesinde salt okunur kişisel terazi; köy adalet HUD'ı çoğaltılmaz.
class_name OdaTerazisiPaneli
extends RefCounted
## Güncel makbuzlar okunur; ekran gösterimi oyun state'ine yazmaz.
static func kur(e: MuhafizOdasiEkrani,v: VBoxContainer) -> void:
 var n:=VBoxContainer.new()
 n.name="oda_terazisi"
 n.add_theme_constant_override("separation",8)
 v.add_child(n)
 var l:=Label.new()
 l.name="terazi_unvan"
 l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 n.add_child(l)
 var p:=ProgressBar.new()
 p.name="terazi_denge"
 p.max_value=100
 p.show_percentage=false
 p.custom_minimum_size.y=20
 n.add_child(p)
 guncelle(e)

## Yetenek alımı sonrasında aynı etiket/bar yeniden okunur; ikinci panel üretilmez.
static func guncelle(e: MuhafizOdasiEkrani) -> void:
 var d:=MuhafizTerazisi.durum(e.oturum)
 var l:=e.find_children("terazi_unvan","Label",true,false)[0] as Label
 l.text="%s\nAdalet %d · Yozlaşma %d"%[d.unvan,d.adalet,d.yozlasma]
 var p:=e.find_children("terazi_denge","ProgressBar",true,false)[0] as ProgressBar
 p.value=float(d.denge)
 p.tooltip_text="Sol: yozlaşmış derebeyi. Sağ: adil muhafız.\nRüşvet: %d karar · Zimmet: %d akçe · Haraç: %d akçe · Onarılmamış haksız karar: %d"%[d.rusvet,d.zimmet,d.harac,d.haksizlik]
