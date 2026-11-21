## ODA-04: aynı oda listesinde salt okunur kişisel terazi; köy adalet HUD'ı çoğaltılmaz.
class_name OdaTerazisiPaneli
extends RefCounted

const IKON_TERAZI := "res://assets/art/icons/icon_oda_terazi.png"

## Güncel makbuzlar okunur; ekran gösterimi oyun state'ine yazmaz.
static func kur(e: MuhafizOdasiEkrani,v: VBoxContainer) -> void:
 var n:=VBoxContainer.new()
 n.name="oda_terazisi"
 n.add_theme_constant_override("separation",8)
 v.add_child(n)
 var ust_satir:=HBoxContainer.new()
 ust_satir.add_theme_constant_override("separation",8)
 n.add_child(ust_satir)
 if ResourceLoader.exists(IKON_TERAZI):
  var tr:=TextureRect.new()
  tr.texture=load(IKON_TERAZI)
  tr.modulate=Kabuk.BAR_DOLU
  tr.custom_minimum_size=Vector2(28,28)
  tr.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
  tr.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  tr.mouse_filter=Control.MOUSE_FILTER_IGNORE
  ust_satir.add_child(tr)
 var l:=Label.new()
 l.name="terazi_unvan"
 l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 l.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 ust_satir.add_child(l)
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
