## HAR-09: aynı olay kartında güvercin/ulak için tek kutu anlatı yer tutucusu.
class_name HaberciAnlatiPaneli
extends RefCounted
## Yeni HUD/varlık üretmez; gerçek model gelince tek helper değişir.
static func ekle(e: KoyEkrani,kok: VBoxContainer,olay: OlayVerisi) -> void:
 if not HaberciAgi.uygun(e.oturum,olay,0): return
 var kanal:=HaberciAgi.kanal(e.oturum)
 var a: Dictionary=HaberciAgi.AYAR.kanallar[kanal]
 var satir:=HBoxContainer.new()
 kok.add_child(satir)
 var kutu:=ColorRect.new()
 kutu.name="HaberciYerTutucu"
 kutu.color=Color(String(a.renk))
 kutu.custom_minimum_size=Vector2.ONE*int(HaberciAgi.AYAR.kutu_px)
 kutu.mouse_filter=Control.MOUSE_FILTER_IGNORE
 satir.add_child(kutu)
 e._etiket(satir,String(a.ad)+" haberi",Tema.KUCUK_PX)
