## KVR-SES-01: Kapı nöbetinde hava, ayaz ve gece vaktine bağlı açılış replikleri.
## Hava, ANI-09 ile aynı çalışma sözleşmesinden (IklimDeneyi.hava) okunur; ikinci hava motoru yoktur.
## Kapı nöbeti gecedir: kış mevsiminde açık hava ayaz sayılır.
class_name KapiHavaRepligi
extends RefCounted

const KIS := 3


static func hava(o: Oturum) -> String:
	var h := HavaReplikAdaptoru.normalize_hava(IklimDeneyi.hava(o.yonetim))
	if h == "normal" and o.yonetim.mevsim() == KIS:
		return "ayaz"
	return h


## Ziyaretçinin açılış repliğinden önce akışa yazılacak satırlar; açık havada boştur.
static func satirlar(o: Oturum, gelen: Gelen) -> PackedStringArray:
	var h := StringName(hava(o))
	var sonuc := PackedStringArray()
	var muhafiz := HavaReplikAdaptoru.muhafiz_karsilama_anahtari(h)
	if muhafiz.is_empty():
		return sonuc
	var ad := TranslationServer.translate(gelen.ad_anahtari)
	var on_ek := HavaReplikAdaptoru.ziyaretci_on_ek_anahtari(h, absi(hash(String(gelen.id))) + o.gun)
	sonuc.append("[i]%s[/i]" % TranslationServer.translate(muhafiz))
	sonuc.append("[b]%s:[/b] %s" % [ad, TranslationServer.translate(on_ek)])
	return sonuc
