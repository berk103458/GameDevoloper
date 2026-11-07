extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	call_deferred("_calistir")
func _calistir() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var y := KoyYonetimi.new(kat.koy_ayarlari,kat.binalar)
	TranslationServer.clear()
	TranslationServer.set_locale("tr")
	# Kartın diğer metinleri geçerli; yalnız kilit anahtarları eksik.
	var ceviri := Translation.new()
	ceviri.locale = "tr"
	ceviri.add_message("koy.kart.sure","%d gün")
	ceviri.add_message("koy.kart.eksik","Kaynak eksik")
	TranslationServer.add_translation(ceviri)
	var once := y.kaydet()
	var kart := YapiKarti.new()
	root.add_child(kart)
	kart.kur("hizarhane",y,Ayarlar.new())
	await process_frame
	var bilgi := kart.find_child("YapiKademeBilgisi",true,false) as Label
	dene(is_instance_valid(kart) and bilgi != null,"YAP-60 eksik kilit metninde gerçek kart ayakta kalır")
	if bilgi != null:
		dene(bilgi.text.contains("Bilgi bekleniyor") and not bilgi.text.contains("koy.yapi_kilidi.") and not bilgi.text.contains(GuvenliMetin.YOK),"YAP-60 kart nötr sebep gösterir")
	dene(kart.disabled and not YapiKilidi.durum(y,"hizarhane").acik and y.kaydet() == once,"YAP-60 metin eksikliği gerçek yapı kilidini veya kaydı değiştirmez")
	kart.queue_free()
	await process_frame
	var bilen := y.kabul({"ad":"Yapı bilgisi olan"})
	bilen.yapi_bilgisi = PackedStringArray(["tas_ev"])
	dene(YapiKilidi.durum(y,"tas_ev").neden == "yapi_on_kademe","YAP-60 ikinci kilit gerçek fiziksel ön şarttır")
	var on_kart := YapiKarti.new()
	root.add_child(on_kart)
	on_kart.kur("tas_ev",y,Ayarlar.new())
	var on_bilgi := on_kart.find_child("YapiKademeBilgisi",true,false) as Label
	dene(on_bilgi != null and on_bilgi.text.contains("Bilgi bekleniyor") and on_kart.disabled,"YAP-60 eksik ön kademe anahtarı da nötr kalır")
	ceviri.add_message("koy.yapi_kilidi.on_kademe","%s %s")
	dene(YapiKilidi.metin(y,"tas_ev").contains("Bilgi bekleniyor"),"YAP-60 bozuk biçim şablonu da güvenli kalır")
	on_kart.queue_free()
	await process_frame
	TranslationServer.remove_translation(ceviri)
	TranslationServer.add_translation(load("res://data/metin/metinler.tr.translation"))
	print("YAPI KARTI: GEÇTİ" if hata == 0 else "YAPI KARTI: KALDI")
	quit(hata)
