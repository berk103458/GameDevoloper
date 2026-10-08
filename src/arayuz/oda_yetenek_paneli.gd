## ODA-05: aynı oda listesinde veri ayarlı iki bağlı yetenek; ikinci ekonomi/terazi yok.
class_name OdaYetenekPaneli
extends RefCounted
## Tek satır ağacı tekrar çizilir; düğme işlem anında koşulları yeniden doğrular.
static func kur(e: MuhafizOdasiEkrani,v: VBoxContainer) -> void:
 var indeks:=v.get_child_count()
 if v.has_node("oda_yetenekleri"):
  var once:=v.get_node("oda_yetenekleri")
  indeks=once.get_index()
  v.remove_child(once)
  once.queue_free()
 var n:=VBoxContainer.new()
 n.name="oda_yetenekleri"
 n.add_theme_constant_override("separation",12)
 v.add_child(n)
 v.move_child(n,indeks)
 var l:=Label.new()
 l.text="Yozlaşma yetenek ağacı"
 n.add_child(l)
 for id in MuhafizYetenekleri.YETENEKLER:
  var a: Dictionary=MuhafizYetenekleri.AYAR[id]
  var b:=Button.new()
  b.name="yetenek_"+id
  b.text=String(a.ad)+(" · açıldı" if MuhafizYetenekleri.var_mi(e.oturum,id) else " · %d kişisel akçe"%int(a.bedel))
  b.disabled=not MuhafizYetenekleri.alinabilir(e.oturum,id)
  if MuhafizYetenekleri.var_mi(e.oturum,id): b.add_theme_color_override("font_disabled_color",Renkler.KUL)
  b.custom_minimum_size.y=48
  b.tooltip_text="%s\nEn az %d tecrübe ve %d yozlaşma. Önceki yetenek: %s."%[a.aciklama,a.tecrube,a.yozlasma,"yok" if String(a.on_kosul).is_empty() else String(MuhafizYetenekleri.AYAR[a.on_kosul].ad)]
  n.add_child(b)
  var aciklama:=Label.new()
  aciklama.text=String(a.aciklama)
  aciklama.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
  aciklama.add_theme_font_size_override("font_size",Tema.KUCUK_PX)
  n.add_child(aciklama)
  b.pressed.connect(func() -> void:
   if MuhafizYetenekleri.al(e.oturum,id):
    OdaTerazisiPaneli.guncelle(e)
    OdaKasasiPaneli.guncelle(e)
    kur(e,v)
  )
