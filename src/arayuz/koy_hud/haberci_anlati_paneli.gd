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
 satir.add_child(Kabuk.yer_tutucu("HaberciYerTutucu",String(a.renk),Vector2.ONE*int(HaberciAgi.AYAR.kutu_px)))
 e._etiket(satir,String(a.ad)+" haberi",Tema.KUCUK_PX)
