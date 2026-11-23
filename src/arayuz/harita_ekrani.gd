## HAR-01: mevcut köyün üzerinde tek şematik çevre haritası; salt okunur modal.
class_name HaritaEkrani
extends Control
var oturum: Oturum
var ayarlar: Ayarlar
var _alan: Control
var _bilgi: Label
var _baslik: Label
var _noktalar: Dictionary={}
var _yollar: Array[ColorRect]=[]
var _harita_tuval: Control
var _katman_mevsim: TextureRect
var _sis_tam: TextureRect
var _manzara_alt: TextureRect
var _manzara_ust: TextureRect
var _tooltip: PanelContainer
var _tooltip_yazi: Label
var _lejant: Control
var _vinyet: TextureRect
var _kart_rozet: HBoxContainer
var _gorunen: Label
var _rota_cizim: Array[Control]=[]
var _sis_bulut: Dictionary={}
var _secili: String="hisar"
var _olcek: float=1.0
var _manzara_tween: Tween
const ARKA_HARITA := "res://assets/ui/atmosfer/gece_kapisi/map_bg.png"
const DIS_MANZARA := "res://assets/art/env/harita_uc.png"
const MAP_KOK := "res://assets/art/map/"
const IKON_HISAR := "res://assets/art/icons/icon_map_hisar.png"
const IKON_TEKFUR := "res://assets/art/icons/icon_map_tekfur.png"
const IKON_GOC := "res://assets/art/icons/icon_map_goc.png"
const IKON_YOL := "res://assets/art/icons/icon_map_yol.png"
const IKON_GERI := "res://assets/ui/atmosfer/gece_kapisi/icon_geri.png"
func _ready() -> void:
 process_mode=Node.PROCESS_MODE_ALWAYS
 set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var arka:=ColorRect.new()
 arka.color=Color(String(CevreHaritasi.AYAR.arka))
 arka.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(arka)
 var dis:=_doku_rect(DIS_MANZARA, "dis_manzara")
 if dis:
  dis.modulate.a=0.18
  dis.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  add_child(dis)
 var kenar:=MarginContainer.new()
 kenar.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 for a in ["left","right","top","bottom"]: kenar.add_theme_constant_override("margin_"+a,32)
 add_child(kenar)
 var v:=VBoxContainer.new()
 v.add_theme_constant_override("separation",20)
 kenar.add_child(v)
 var h:=Label.new()
 h.text="Çevre haritası"
 h.add_theme_font_size_override("font_size",ayarlar.boyut(36))
 v.add_child(h)
 var notu:=Label.new()
 notu.text="Şematik görünüm · Bir bölgeyi seçerek incele."
 notu.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 v.add_child(notu)
 var s:=HBoxContainer.new()
 s.size_flags_vertical=Control.SIZE_EXPAND_FILL
 s.add_theme_constant_override("separation",24)
 v.add_child(s)
 var panel:=PanelContainer.new()
 panel.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 panel.add_theme_stylebox_override("panel",Kabuk.panel())
 s.add_child(panel)
 _alan=Control.new()
 _alan.name="harita_alan"
 _alan.clip_contents=true
 _alan.custom_minimum_size=Vector2(640,360)
 panel.add_child(_alan)
 var renk:=ColorRect.new()
 renk.color=Color(String(CevreHaritasi.AYAR.harita_renk))
 renk.mouse_filter=Control.MOUSE_FILTER_IGNORE
 renk.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 _alan.add_child(renk)
 _harita_tuval=Control.new()
 _harita_tuval.name="harita_tuval"
 _harita_tuval.mouse_filter=Control.MOUSE_FILTER_IGNORE
 _harita_tuval.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 _alan.add_child(_harita_tuval)
 _manzara_alt=_doku_rect(ARKA_HARITA, "harita_arka_doku")
 if _manzara_alt==null:
  _manzara_alt=_doku_rect(DIS_MANZARA, "harita_arka_doku")
 if _manzara_alt:
  _manzara_alt.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED
  _manzara_alt.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  _harita_tuval.add_child(_manzara_alt)
 _manzara_ust=TextureRect.new()
 _manzara_ust.name="harita_manzara_ust"
 _manzara_ust.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 _manzara_ust.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED
 _manzara_ust.mouse_filter=Control.MOUSE_FILTER_IGNORE
 _manzara_ust.modulate.a=0
 _manzara_ust.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 _harita_tuval.add_child(_manzara_ust)
 _vinyet=TextureRect.new()
 _vinyet.name="harita_vinyet"
 _vinyet.texture=_vinyet_doku()
 _vinyet.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 _vinyet.stretch_mode=TextureRect.STRETCH_SCALE
 _vinyet.mouse_filter=Control.MOUSE_FILTER_IGNORE
 _vinyet.modulate.a=0.0
 _vinyet.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 _harita_tuval.add_child(_vinyet)
 var mevsim_yol:=CevreHaritasi.mevsim_katmani(oturum)
 _katman_mevsim=_doku_rect(mevsim_yol, "mevsim_katman")
 if _katman_mevsim:
  _katman_mevsim.modulate.a=0.38
  _katman_mevsim.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED
  _katman_mevsim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  _harita_tuval.add_child(_katman_mevsim)
 var sis_yol:=String((CevreHaritasi.katmanlar().get("savas_sisi", {}) as Dictionary).get("tam", MAP_KOK+"savas_sisi_tam_katman.png"))
 _sis_tam=_doku_rect(sis_yol, "savas_sisi_tam")
 if _sis_tam:
  _sis_tam.modulate.a=0.0
  _sis_tam.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_COVERED
  _sis_tam.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  _harita_tuval.add_child(_sis_tam)
 for y in CevreHaritasi.AYAR.yollar:
  var c:=ColorRect.new()
  c.color=Color(String(CevreHaritasi.AYAR.yol_renk))
  c.modulate.a=0.0
  c.mouse_filter=Control.MOUSE_FILTER_IGNORE
  _harita_tuval.add_child(c)
  _yollar.append(c)
 _rota_kur()
 for b in CevreHaritasi.bolgeler():
  _nokta_kur(b)
 _sis_nokta_kur()
 var cer=_dokuz(MAP_KOK+"ui_harita_kenarlik.png", 112,112,112,112, "harita_kenarlik")
 if cer:
  cer.mouse_filter=Control.MOUSE_FILTER_IGNORE
  cer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  _alan.add_child(cer)
 _araclar_kur()
 _tooltip_kur()
 _alan.resized.connect(_yerlestir)
 var kaydir:=ScrollContainer.new()
 kaydir.name="harita_bolge_kaydir"
 kaydir.custom_minimum_size.x=520
 kaydir.size_flags_vertical=Control.SIZE_EXPAND_FILL
 kaydir.horizontal_scroll_mode=ScrollContainer.SCROLL_MODE_DISABLED
 s.add_child(kaydir)
 var kart:=PanelContainer.new()
 kart.name="harita_bolge_kart"
 kart.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 var kart_stil:=_kart_stil()
 if kart_stil: kart.add_theme_stylebox_override("panel", kart_stil)
 kaydir.add_child(kart)
 var bilgi:=VBoxContainer.new()
 bilgi.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 bilgi.add_theme_constant_override("separation",16)
 var ic_pay:=MarginContainer.new()
 ic_pay.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 for a in ["left","right","top","bottom"]: ic_pay.add_theme_constant_override("margin_"+a, 8)
 ic_pay.add_child(bilgi)
 kart.add_child(ic_pay)
 _baslik=Label.new()
 _baslik.name="harita_bolge_baslik"
 _baslik.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 _baslik.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 _baslik.add_theme_font_size_override("font_size",ayarlar.boyut(28))
 bilgi.add_child(_baslik)
 _kart_rozet=HBoxContainer.new()
 _kart_rozet.name="harita_bolge_rozetler"
 _kart_rozet.add_theme_constant_override("separation", 8)
 bilgi.add_child(_kart_rozet)
 _bilgi=Label.new()
 _bilgi.name="harita_bolge_bilgi"
 _bilgi.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 _bilgi.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 _bilgi.add_theme_font_size_override("font_size",ayarlar.boyut(24))
 bilgi.add_child(_bilgi)
 _gorunen=Label.new()
 _gorunen.name="harita_bolge_gorunen"
 _gorunen.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 _gorunen.add_theme_font_size_override("font_size",ayarlar.boyut(20))
 bilgi.add_child(_gorunen)
 var geri:=Button.new()
 geri.name="harita_kapat"
 geri.text="Köye dön"
 if ResourceLoader.exists(IKON_GERI):
  geri.icon = load(IKON_GERI)
  geri.expand_icon = true
 geri.custom_minimum_size.y=48
 geri.pressed.connect(queue_free)
 v.add_child(geri)
 bolge_sec("hisar")
 _yerlestir.call_deferred()
 geri.grab_focus()
 _rulo_ac.call_deferred()
## Aynı bilgi alanı seçilen bölgeyle güncellenir; oyun durumuna yazılmaz.
func bolge_sec(id: String) -> void:
 if String(id).strip_edges().is_empty():
  _secili=""
  if _baslik: _baslik.text=""
  if _bilgi: _bilgi.text=""
  if _gorunen: _gorunen.text=""
  if _kart_rozet:
   for c in _kart_rozet.get_children(): c.queue_free()
  _manzara_gec(ARKA_HARITA)
  _noktalari_guncelle()
  return
 var d:=CevreHaritasi.bilgi(oturum,id)
 if d.is_empty(): return
 _secili=id
 _baslik.text=String(d.ad)
 _bilgi.text=String(d.metin)
 var durum:=CevreHaritasi.bolge_durumu(oturum,id)
 var manzara_yol:=String(durum.get("manzara", ""))
 if manzara_yol.is_empty() or not ResourceLoader.exists(manzara_yol):
  manzara_yol=ARKA_HARITA
 _manzara_gec(manzara_yol)
 _rozet_satiri(durum)
 if _gorunen:
  var parca: PackedStringArray=[]
  if not bool(durum.get("kesfedildi", true)): parca.append("Savaş sisi: keşfedilmedi")
  elif not String(durum.get("muhur","")).is_empty(): parca.append("Mühür: "+String(durum.muhur))
  var olaylar: Array=durum.get("olaylar", [])
  if not olaylar.is_empty(): parca.append("Olay: "+", ".join(PackedStringArray(olaylar)))
  _gorunen.text=" · ".join(parca)
 _noktalari_guncelle()
func _rulo_ac() -> void:
 if not is_inside_tree(): return
 HaritaRulosuAnimasyonu.oynat(self)
func _doku_rect(yol: String, ad: String) -> TextureRect:
 if yol.is_empty() or not ResourceLoader.exists(yol): return null
 var t:=TextureRect.new()
 t.name=ad
 t.texture=load(yol)
 t.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 t.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 t.mouse_filter=Control.MOUSE_FILTER_IGNORE
 return t
func _dokuz(yol: String, l: int, t: int, r: int, b: int, ad: String) -> NinePatchRect:
 if not ResourceLoader.exists(yol): return null
 var n:=NinePatchRect.new()
 n.name=ad
 n.texture=load(yol)
 n.patch_margin_left=l
 n.patch_margin_top=t
 n.patch_margin_right=r
 n.patch_margin_bottom=b
 return n
func _kart_stil() -> StyleBox:
 var yol:=MAP_KOK+"ui_bolge_kart_cerceve.png"
 if not ResourceLoader.exists(yol): return Kabuk.panel()
 var s:=StyleBoxTexture.new()
 s.texture=load(yol)
 s.texture_margin_left=128
 s.texture_margin_top=128
 s.texture_margin_right=128
 s.texture_margin_bottom=128
 s.content_margin_left=88
 s.content_margin_top=88
 s.content_margin_right=88
 s.content_margin_bottom=88
 return s
func _nokta_kur(b: Dictionary) -> void:
 var id:=String(b.id)
 var nokta:=ColorRect.new()
 nokta.name="bolge_"+id
 nokta.color=Color(0,0,0,0)
 nokta.size=Vector2(float(CevreHaritasi.AYAR.nokta_genislik),float(CevreHaritasi.AYAR.nokta_yukseklik))
 _harita_tuval.add_child(nokta)
 var halka:=TextureRect.new()
 halka.name="halka"
 halka.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 halka.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 halka.mouse_filter=Control.MOUSE_FILTER_IGNORE
 halka.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 nokta.add_child(halka)
 for k in [["kontur_u",0.0,-2.0,0.5],["kontur_d",0.0,2.0,0.5],["kontur_l",-2.0,0.0,0.5],["kontur_r",2.0,0.0,0.5],["golge",2.0,3.0,0.45]]:
  nokta.add_child(_golge_kopya(String(k[0]), float(k[1]), float(k[2]), float(k[3])))
 var ikon:=TextureRect.new()
 ikon.name="ikon"
 ikon.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 ikon.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 ikon.mouse_filter=Control.MOUSE_FILTER_IGNORE
 ikon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 var iy:=_yedek_ikon(id)
 if ResourceLoader.exists(iy): ikon.texture=load(iy)
 nokta.add_child(ikon)
 var muhur:=TextureRect.new()
 muhur.name="muhur"
 muhur.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 muhur.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 muhur.mouse_filter=Control.MOUSE_FILTER_IGNORE
 muhur.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
 muhur.offset_left=0
 muhur.offset_top=-36
 muhur.offset_right=36
 muhur.offset_bottom=0
 nokta.add_child(muhur)
 var rozet:=TextureRect.new()
 rozet.name="rozet"
 rozet.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 rozet.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 rozet.mouse_filter=Control.MOUSE_FILTER_IGNORE
 rozet.set_anchors_preset(Control.PRESET_TOP_RIGHT)
 rozet.offset_left=-32
 rozet.offset_top=0
 rozet.offset_right=0
 rozet.offset_bottom=32
 nokta.add_child(rozet)
 var dugme:=Button.new()
 dugme.name="sec_"+id
 dugme.flat=true
 dugme.focus_mode=Control.FOCUS_ALL
 var bos:=StyleBoxEmpty.new()
 dugme.add_theme_stylebox_override("normal",bos)
 dugme.add_theme_stylebox_override("hover",bos)
 dugme.add_theme_stylebox_override("pressed",bos)
 dugme.add_theme_stylebox_override("focus",bos)
 dugme.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 dugme.pressed.connect(func() -> void: bolge_sec(id))
 dugme.mouse_entered.connect(func() -> void: _tooltip_goster(id))
 dugme.mouse_exited.connect(_tooltip_gizle)
 nokta.add_child(dugme)
 _noktalar[id]=nokta
func _yedek_ikon(id: String) -> String:
 match id:
  "hisar": return IKON_HISAR
  "tekfur": return IKON_TEKFUR
  "goc_yolu": return IKON_GOC
  "karaboran": return IKON_YOL
  _: return ""
func _noktalari_guncelle() -> void:
 var kat:=CevreHaritasi.katmanlar()
 var muhurler: Dictionary=kat.get("muhurler", {}) if kat.get("muhurler") is Dictionary else {}
 var olaylar_yol: Dictionary=kat.get("olaylar", {}) if kat.get("olaylar") is Dictionary else {}
 for id in _noktalar:
  var n:=_noktalar[id] as ColorRect
  var durum:=CevreHaritasi.bolge_durumu(oturum,id)
  var kes:=bool(durum.get("kesfedildi", true))
  var tehlike:=String(durum.get("durum", "normal"))=="tehlike"
  var secili: bool=String(id)==_secili
  var ikon_yol:=String(durum.get("ikon_normal", _yedek_ikon(id)))
  if secili: ikon_yol=String(durum.get("ikon_secili", ikon_yol))
  if tehlike: ikon_yol=String(durum.get("ikon_tehlike", ikon_yol))
  var ikon:=n.get_node_or_null("ikon") as TextureRect
  if ikon:
   if ResourceLoader.exists(ikon_yol): ikon.texture=load(ikon_yol)
   ikon.modulate.a=1.0 if kes else 0.35
   for ad in ["golge","kontur_u","kontur_d","kontur_l","kontur_r"]:
    var g:=n.get_node_or_null(ad) as TextureRect
    if g==null: continue
    g.texture=ikon.texture
    var taban: float=0.45 if ad=="golge" else 0.5
    g.modulate=Color(0,0,0, taban if kes else taban*0.35)
  var halka:=n.get_node_or_null("halka") as TextureRect
  if halka:
   var hyol:=""
   if secili: hyol=MAP_KOK+"ui_secili_halka.png"
   elif tehlike: hyol=MAP_KOK+"ui_tehlike_halka.png"
   halka.texture=load(hyol) if ResourceLoader.exists(hyol) else null
   halka.visible=not hyol.is_empty()
  var muhur:=n.get_node_or_null("muhur") as TextureRect
  if muhur:
   var my:=String(muhurler.get(String(durum.get("muhur", "")), ""))
   muhur.texture=load(my) if ResourceLoader.exists(my) else null
   muhur.visible=ResourceLoader.exists(my)
  var rozet:=n.get_node_or_null("rozet") as TextureRect
  if rozet:
   var olaylar: Array=durum.get("olaylar", [])
   var ry:=""
   if not olaylar.is_empty(): ry=String(olaylar_yol.get(String(olaylar[0]), ""))
   rozet.texture=load(ry) if ResourceLoader.exists(ry) else null
   rozet.visible=ResourceLoader.exists(ry) and kes
  if _sis_bulut.has(id):
   (_sis_bulut[id] as CanvasItem).visible=not kes
 var sis_var:=false
 for id2 in _noktalar:
  if not CevreHaritasi.kesfedildi_mi(oturum,id2): sis_var=true; break
 if _sis_tam: _sis_tam.modulate.a=0.42 if sis_var else 0.0
func _rozet_satiri(durum: Dictionary) -> void:
 if _kart_rozet==null: return
 for c in _kart_rozet.get_children(): c.queue_free()
 var kat:=CevreHaritasi.katmanlar()
 var muhurler: Dictionary=kat.get("muhurler", {}) if kat.get("muhurler") is Dictionary else {}
 var olaylar_yol: Dictionary=kat.get("olaylar", {}) if kat.get("olaylar") is Dictionary else {}
 var my:=String(muhurler.get(String(durum.get("muhur", "")), ""))
 if ResourceLoader.exists(my):
  var t:=TextureRect.new()
  t.custom_minimum_size=Vector2(48,48)
  t.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
  t.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  t.texture=load(my)
  _kart_rozet.add_child(t)
 for olay in durum.get("olaylar", []):
  var ry:=String(olaylar_yol.get(String(olay), ""))
  if not ResourceLoader.exists(ry): continue
  var t2:=TextureRect.new()
  t2.custom_minimum_size=Vector2(40,40)
  t2.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
  t2.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
  t2.texture=load(ry)
  _kart_rozet.add_child(t2)
func _rota_kur() -> void:
 for n in _rota_cizim: n.queue_free()
 _rota_cizim.clear()
 for r in CevreHaritasi.rotalar():
  if not r is Dictionary: continue
  var tip:=String(r.get("tip", "ana_yol"))
  var tex_yol:=MAP_KOK+"rota_duz.png"
  if tip=="patika": tex_yol=MAP_KOK+"rota_kesik.png"
  elif tip=="sinir": tex_yol=MAP_KOK+"sinir_cizgisi.png"
  var tehlike:=_rota_tehlike(String(r.get("baslangic","")), String(r.get("bitis","")))
  if tehlike: tex_yol=MAP_KOK+"rota_tehlike_kesik.png"
  var serit:=Control.new()
  serit.mouse_filter=Control.MOUSE_FILTER_IGNORE
  serit.set_meta("rota", r)
  serit.set_meta("tex", tex_yol)
  _harita_tuval.add_child(serit)
  _rota_cizim.append(serit)
  if bool(r.get("nehir_gecisi", false)):
   var nehir:=_doku_rect(MAP_KOK+"nehir_isaret.png", "nehir_"+String(r.get("id","")))
   if nehir:
    nehir.set_meta("konum", r.get("kopru_konum", []))
    nehir.custom_minimum_size=Vector2(48,24)
    _harita_tuval.add_child(nehir)
    _rota_cizim.append(nehir)
  var kpos: Variant=r.get("kopru_konum", [])
  if kpos is Array and (kpos as Array).size()>=2:
   var kyol:=MAP_KOK+("kopru_yikik.png" if CevreHaritasi.kopru_yikik_mi(oturum) else "kopru_saglam.png")
   var kopru:=_doku_rect(kyol, "kopru_"+String(r.get("id","")))
   if kopru:
    kopru.set_meta("konum", kpos)
    kopru.custom_minimum_size=Vector2(48,48)
    _harita_tuval.add_child(kopru)
    _rota_cizim.append(kopru)
func _rota_tehlike(a: String,b: String) -> bool:
 for id in [a,b]:
  var d:=CevreHaritasi.bolge_durumu(oturum,id)
  if String(d.get("durum",""))=="tehlike": return true
 return CevreHaritasi.yol_kapali(oturum)
func _sis_nokta_kur() -> void:
 var bulut:=String((CevreHaritasi.katmanlar().get("savas_sisi", {}) as Dictionary).get("bulut", MAP_KOK+"savas_sisi_bulut.png"))
 for b in CevreHaritasi.bolgeler():
  var id:=String(b.id)
  var t:=_doku_rect(bulut, "sis_"+id)
  if t==null: continue
  t.visible=not CevreHaritasi.kesfedildi_mi(oturum,id)
  t.custom_minimum_size=Vector2(128,128)
  _harita_tuval.add_child(t)
  _sis_bulut[id]=t
func _araclar_kur() -> void:
 var arac:=Control.new()
 arac.name="harita_araclar"
 arac.mouse_filter=Control.MOUSE_FILTER_IGNORE
 arac.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 _alan.add_child(arac)
 var pusula:=_doku_rect(MAP_KOK+"ui_pusula_gulu.png", "ui_pusula_gulu")
 if pusula:
  pusula.set_anchors_preset(Control.PRESET_TOP_RIGHT)
  pusula.offset_left=-88
  pusula.offset_top=16
  pusula.offset_right=-16
  pusula.offset_bottom=88
  arac.add_child(pusula)
 var olcek:=_doku_rect(MAP_KOK+"ui_olcek_cubugu.png", "ui_olcek_cubugu")
 if olcek:
  olcek.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
  olcek.offset_left=16
  olcek.offset_top=-48
  olcek.offset_right=200
  olcek.offset_bottom=-16
  arac.add_child(olcek)
 var dugmeler:=VBoxContainer.new()
 dugmeler.mouse_filter=Control.MOUSE_FILTER_STOP
 dugmeler.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
 dugmeler.offset_left=-72
 dugmeler.offset_top=-200
 dugmeler.offset_right=-16
 dugmeler.offset_bottom=-16
 dugmeler.add_theme_constant_override("separation", 8)
 arac.add_child(dugmeler)
 dugmeler.add_child(_ikon_dugme(MAP_KOK+"ui_btn_yakinlastir.png", "btn_yakinlastir", func() -> void: _olcek_ayarla(_olcek+float(CevreHaritasi.yakinlastirma().get("adim", 0.15)))))
 dugmeler.add_child(_ikon_dugme(MAP_KOK+"ui_btn_uzaklastir.png", "btn_uzaklastir", func() -> void: _olcek_ayarla(_olcek-float(CevreHaritasi.yakinlastirma().get("adim", 0.15)))))
 dugmeler.add_child(_ikon_dugme(MAP_KOK+"ui_btn_merkezle.png", "btn_merkezle", func() -> void: _olcek_ayarla(float(CevreHaritasi.yakinlastirma().get("varsayilan", 1.0)))))
 var lejant_btn:=_ikon_dugme(MAP_KOK+"ui_lejant_cerceve.png", "btn_lejant", _lejant_ac)
 if lejant_btn: dugmeler.add_child(lejant_btn)
 _lejant=_dokuz(MAP_KOK+"ui_lejant_cerceve.png", 64,64,64,64, "lejant_paneli")
 if _lejant:
  _lejant.visible=false
  _lejant.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
  _lejant.offset_left=16
  _lejant.offset_top=-280
  _lejant.offset_right=260
  _lejant.offset_bottom=-56
  var yazi:=Label.new()
  yazi.text="Lejant\nSeçili: amber ışık\nTehlike: uyarı mangalı\nSis: keşfedilmemiş\nMühür / olay rozeti pin köşesinde"
  yazi.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
  var pay:=MarginContainer.new()
  for a in ["left","right","top","bottom"]: pay.add_theme_constant_override("margin_"+a, 28)
  pay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
  pay.add_child(yazi)
  _lejant.add_child(pay)
  arac.add_child(_lejant)
func _ikon_dugme(yol: String, ad: String, fn: Callable) -> Button:
 var b:=Button.new()
 b.name=ad
 b.custom_minimum_size=Vector2(48,48)
 b.flat=true
 if ResourceLoader.exists(yol):
  b.icon=load(yol)
  b.expand_icon=true
 b.pressed.connect(fn)
 return b
func _lejant_ac() -> void:
 if _lejant: _lejant.visible=not _lejant.visible
func _olcek_ayarla(v: float) -> void:
 var y:=CevreHaritasi.yakinlastirma()
 _olcek=clampf(v, float(y.get("min", 0.85)), float(y.get("max", 1.85)))
 if _harita_tuval:
  _harita_tuval.pivot_offset=_harita_tuval.size*0.5
  _harita_tuval.scale=Vector2(_olcek, _olcek)
func _tooltip_kur() -> void:
 _tooltip=PanelContainer.new()
 _tooltip.name="harita_tooltip"
 _tooltip.visible=false
 _tooltip.z_index=20
 _tooltip.mouse_filter=Control.MOUSE_FILTER_IGNORE
 var stil:=StyleBoxTexture.new()
 var tyol:=MAP_KOK+"ui_harita_tooltip.png"
 if ResourceLoader.exists(tyol):
  stil.texture=load(tyol)
  stil.texture_margin_left=48
  stil.texture_margin_top=48
  stil.texture_margin_right=48
  stil.texture_margin_bottom=48
  _tooltip.add_theme_stylebox_override("panel", stil)
 _tooltip_yazi=Label.new()
 _tooltip_yazi.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
 _tooltip_yazi.custom_minimum_size.x=200
 var pay:=MarginContainer.new()
 for a in ["left","right","top","bottom"]: pay.add_theme_constant_override("margin_"+a, 20)
 pay.add_child(_tooltip_yazi)
 _tooltip.add_child(pay)
 add_child(_tooltip)
func _tooltip_goster(id: String) -> void:
 var durum:=CevreHaritasi.bolge_durumu(oturum,id)
 if durum.is_empty() or _tooltip==null: return
 _tooltip_yazi.text=String(durum.get("tooltip", durum.get("ad", id)))
 _tooltip.visible=true
 _tooltip.global_position=get_global_mouse_position()+Vector2(16,16)
func _tooltip_gizle() -> void:
 if _tooltip: _tooltip.visible=false
func _golge_kopya(ad: String, dx: float, dy: float, a: float) -> TextureRect:
 var t:=TextureRect.new()
 t.name=ad
 t.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
 t.stretch_mode=TextureRect.STRETCH_KEEP_ASPECT_CENTERED
 t.mouse_filter=Control.MOUSE_FILTER_IGNORE
 t.modulate=Color(0,0,0,a)
 t.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 t.offset_left=dx
 t.offset_top=dy
 t.offset_right=dx
 t.offset_bottom=dy
 return t
func _vinyet_doku() -> Texture2D:
 var img:=Image.create(256, 256, false, Image.FORMAT_RGBA8)
 for y in 256:
  for x in 256:
   var u:=(float(x)+0.5)/256.0
   var v:=(float(y)+0.5)/256.0
   var dx:=u-0.5
   var dy:=(v-0.64)/0.72
   var r:=sqrt(dx*dx+dy*dy)
   var kenar:=clampf(r, 0.0, 1.0)
   var gokyuzu:=clampf((0.42-v)*1.5, 0.0, 1.0)
   var a:=clampf(0.14+0.14*kenar*kenar+0.12*gokyuzu, 0.14, 0.34)
   img.set_pixel(x, y, Color(0, 0, 0, a))
 return ImageTexture.create_from_image(img)
func _manzara_gec(yol: String) -> void:
 if yol.is_empty() or not ResourceLoader.exists(yol) or _manzara_ust==null or _manzara_alt==null: return
 var doku:=load(yol) as Texture2D
 var bolge_manzara: bool=yol!=ARKA_HARITA
 var hedef_vinyet: float=1.0 if bolge_manzara else 0.0
 if _manzara_alt.texture==doku:
  if _vinyet: _vinyet.modulate.a=hedef_vinyet
  return
 _manzara_ust.texture=doku
 _manzara_ust.modulate.a=0
 if _manzara_tween: _manzara_tween.kill()
 var aninda: bool=ayarlar!=null and String(ayarlar.al(&"belirme_hizi"))=="aninda"
 if aninda:
  _manzara_alt.texture=doku
  _manzara_ust.modulate.a=0
  if _vinyet: _vinyet.modulate.a=hedef_vinyet
  return
 _manzara_tween=create_tween()
 _manzara_tween.set_parallel(true)
 _manzara_tween.tween_property(_manzara_ust, "modulate:a", 1.0, 0.4)
 if _vinyet:
  _manzara_tween.tween_property(_vinyet, "modulate:a", hedef_vinyet, 0.4)
 _manzara_tween.chain().tween_callback(func() -> void:
  _manzara_alt.texture=_manzara_ust.texture
  _manzara_ust.modulate.a=0
 )
func _yerlestir() -> void:
 if _harita_tuval: _harita_tuval.pivot_offset=_harita_tuval.size*0.5
 var alan:=_harita_tuval.size if _harita_tuval else _alan.size
 for b in CevreHaritasi.AYAR.bolgeler:
  var n:=_noktalar[String(b.id)] as ColorRect
  n.position=Vector2(float(b.x)*alan.x,float(b.y)*alan.y)-n.size/2
  if _sis_bulut.has(String(b.id)):
   var s:=_sis_bulut[String(b.id)] as TextureRect
   s.size=Vector2(128,128)
   s.position=Vector2(float(b.x)*alan.x,float(b.y)*alan.y)-s.size/2
 for i in _yollar.size():
  var y: Array=CevreHaritasi.AYAR.yollar[i]
  var a:=Vector2(float(y[0])*alan.x,float(y[1])*alan.y)
  var b2:=Vector2(float(y[2])*alan.x,float(y[3])*alan.y)
  _yollar[i].position=a
  _yollar[i].size=Vector2(a.distance_to(b2),3)
  _yollar[i].rotation=(b2-a).angle()
 for n in _rota_cizim:
  if n.has_meta("rota"):
   _serit_yerlestir(n, alan)
  elif n.has_meta("konum"):
   var k: Variant=n.get_meta("konum")
   if k is Array and (k as Array).size()>=2:
    n.size=n.custom_minimum_size
    n.position=Vector2(float(k[0])*alan.x,float(k[1])*alan.y)-n.size/2
func _serit_yerlestir(serit: Control, alan: Vector2) -> void:
 var r: Dictionary=serit.get_meta("rota")
 var noktalar: Array=[]
 var b1:=CevreHaritasi.kayit(String(r.get("baslangic","")))
 var b2:=CevreHaritasi.kayit(String(r.get("bitis","")))
 if b1.is_empty() or b2.is_empty(): return
 noktalar.append(Vector2(float(b1.x)*alan.x, float(b1.y)*alan.y))
 var ara: Variant=r.get("ara_noktalar", [])
 if ara is Array:
  for p in ara:
   if p is Array and (p as Array).size()>=2:
    noktalar.append(Vector2(float(p[0])*alan.x, float(p[1])*alan.y))
 noktalar.append(Vector2(float(b2.x)*alan.x, float(b2.y)*alan.y))
 for c in serit.get_children(): c.queue_free()
 var tex_yol:=String(serit.get_meta("tex", MAP_KOK+"rota_duz.png"))
 var tex: Texture2D=load(tex_yol) if ResourceLoader.exists(tex_yol) else null
 for i in range(noktalar.size()-1):
  var p:=noktalar[i] as Vector2
  var q:=noktalar[i+1] as Vector2
  var parca: Control=TextureRect.new() if tex else ColorRect.new()
  parca.mouse_filter=Control.MOUSE_FILTER_IGNORE
  if parca is TextureRect:
   (parca as TextureRect).texture=tex
   (parca as TextureRect).expand_mode=TextureRect.EXPAND_IGNORE_SIZE
   (parca as TextureRect).stretch_mode=TextureRect.STRETCH_SCALE
  else:
   (parca as ColorRect).color=Color(String(CevreHaritasi.AYAR.yol_renk))
  var golge_r: Control=TextureRect.new() if tex else ColorRect.new()
  golge_r.mouse_filter=Control.MOUSE_FILTER_IGNORE
  golge_r.modulate=Color(0,0,0,0.5)
  if golge_r is TextureRect:
   (golge_r as TextureRect).texture=tex
   (golge_r as TextureRect).expand_mode=TextureRect.EXPAND_IGNORE_SIZE
   (golge_r as TextureRect).stretch_mode=TextureRect.STRETCH_SCALE
  else:
   (golge_r as ColorRect).color=Color(0,0,0,0.5)
  golge_r.position=p+Vector2(2,2)
  golge_r.size=Vector2(p.distance_to(q), 12)
  golge_r.rotation=(q-p).angle()
  golge_r.pivot_offset=Vector2(0, 6)
  serit.add_child(golge_r)
  parca.position=p
  parca.size=Vector2(p.distance_to(q), 10)
  parca.rotation=(q-p).angle()
  parca.pivot_offset=Vector2(0, 5)
  serit.add_child(parca)
  if i==noktalar.size()-2 and ResourceLoader.exists(MAP_KOK+"rota_uc_ok.png"):
   var ok_g:=TextureRect.new()
   ok_g.texture=load(MAP_KOK+"rota_uc_ok.png")
   ok_g.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
   ok_g.modulate=Color(0,0,0,0.5)
   ok_g.custom_minimum_size=Vector2(24,16)
   ok_g.size=Vector2(24,16)
   ok_g.position=q-ok_g.size/2+Vector2(2,2)
   ok_g.rotation=(q-p).angle()
   ok_g.mouse_filter=Control.MOUSE_FILTER_IGNORE
   serit.add_child(ok_g)
   var ok:=TextureRect.new()
   ok.texture=load(MAP_KOK+"rota_uc_ok.png")
   ok.expand_mode=TextureRect.EXPAND_IGNORE_SIZE
   ok.custom_minimum_size=Vector2(24,16)
   ok.size=Vector2(24,16)
   ok.position=q-ok.size/2
   ok.rotation=(q-p).angle()
   ok.mouse_filter=Control.MOUSE_FILTER_IGNORE
   serit.add_child(ok)
func _unhandled_input(olay: InputEvent) -> void:
 if olay is InputEventKey:
  if olay.pressed and not olay.echo and olay.keycode==KEY_ESCAPE: queue_free()
  get_viewport().set_input_as_handled()
