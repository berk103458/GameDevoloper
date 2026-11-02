extends Node
const TON = preload("res://src/soz/muhafiz_tonu.gd")
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _ready() -> void: call_deferred("calistir")
func calistir() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1615)
	var k := KarakterVerisi.new()
	k.metinler = {"notr":"Nötr soru", "adil":"Adil soru", "sert":"Sert soru", "yoz":"Yoz soru", "basla":"Başlangıç", "son":"Son"}
	var secenek := {"metin_anahtari":"notr", "hedef":"01", "tansiyon_delta":1, "tonlar":{
		"adil":{"metin_anahtari":"adil"}, "sert":{"metin_anahtari":"sert"}, "yoz":{"metin_anahtari":"yoz"}}}
	k.diyalog_dugumleri = {"00":{"replik_anahtari":"basla", "secenekler":[secenek]}, "01":{"replik_anahtari":"son", "secenekler":[]}}
	var sonuclar: Array = []
	for t in ["adil", "sert", "yoz"]:
		o.yonetim.adalet = 100 if t == "adil" else 0
		o.bayraklar[&"rusvet_sayisi"] = 100 if t == "yoz" else 0
		var p = preload("res://src/arayuz/chr_diyalog_paneli.gd").new()
		p.oturum = o
		p.sorgu = ChrSorgusu.new(k)
		add_child(p)
		var b := p.get_node("Secenek0") as Button
		dene(b != null and b.text == k.metinler[t], "Gerçek panel doğru tonu gösterir")
		b.pressed.emit()
		sonuclar.append({"dugum":p.sorgu.dugum_id,"tansiyon":p.sorgu.tansiyon})
		p.queue_free()
		await get_tree().process_frame
	dene(sonuclar[0] == sonuclar[1] and sonuclar[1] == sonuclar[2], "Üç tonun gerçek mekanik sonucu aynıdır")
	secenek.tonlar.yoz.metin_anahtari = "eksik"
	dene(TON.dogrula(secenek, k.metinler).size() == 1, "Olmayan metin kaynağı reddedilir")
	var p = preload("res://src/arayuz/chr_diyalog_paneli.gd").new()
	p.oturum = o
	p.sorgu = ChrSorgusu.new(k)
	add_child(p)
	dene(p.get_node_or_null("Secenek0") == null, "Eksik tonla seçenek sahnesi yüklenmez")
	p.queue_free()
	await get_tree().process_frame
	print("MUHAFIZ TON PANELİ: GEÇTİ" if hata == 0 else "MUHAFIZ TON PANELİ: KALDI")
	await get_tree().create_timer(1.0).timeout
	get_tree().quit(hata)
