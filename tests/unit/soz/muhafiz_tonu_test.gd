extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func secenek() -> Dictionary:
	return {"metin_anahtari":"notr", "etki":{"tansiyon":1}, "tonlar":{
		"adil":{"metin_anahtari":"adil", "etki":{"tansiyon":1}},
		"sert":{"metin_anahtari":"sert", "etki":{"tansiyon":1}},
		"yoz":{"metin_anahtari":"yoz", "etki":{"tansiyon":1}}}}
func _initialize() -> void:
	if not FileAccess.file_exists("res://src/soz/muhafiz_tonu.gd"):
		dene(false, "Ton katmanı henüz yok")
		quit(hata)
		return
	var t = load("res://src/soz/muhafiz_tonu.gd")
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1615)
	var s := secenek()
	var once := s.duplicate(true)
	o.yonetim.adalet = 100
	var adil: String = t.anahtar(o, s)
	o.yonetim.adalet = 0
	o.bayraklar[&"rusvet_sayisi"] = 100
	var yoz: String = t.anahtar(o, s)
	dene(adil == "adil" and yoz == "yoz" and adil != yoz, "Terazi iki farklı metin seçer")
	dene(s == once, "Etki ve veri sözlüğü değişmez")
	o.bayraklar.erase(&"rusvet_sayisi")
	dene(t.anahtar(o, s) == "sert", "Orta terazi sert varyanttır")
	s.tonlar.yoz.metin_anahtari = ""
	dene(t.dogrula(s).size() == 1, "Boş yoz varyant tam bir hata")
	s = secenek()
	s.tonlar.yoz.etki.tansiyon = 2
	dene(t.dogrula(s).size() == 1, "Farklı etki reddedilir")
	s = secenek()
	s["gecmis"] = "ahi_ciragi"
	dene(not t.gorunur(o, s), "Geçmiş yoksa özel seçenek gizlenir")
	preload("res://src/sistemler/muhafiz_gecmisi.gd").sec(o, "ahi_ciragi")
	dene(t.gorunur(o, s), "Doğru geçmiş seçeneği açar")
	dene(t.anahtar(o, {"metin_anahtari":"notr"}) == "notr", "Ton anahtarı yoksa nötr")
	s.tonlar.sert["tepki_varyantlari"] = [{"metin":"Sakin cevap", "kosullar":{"hava":"normal"}, "oncelik":1}, {"metin":"Varsayılan cevap", "kosullar":{}}]
	dene(t.tepki(o, s, {"hava":"normal"}) == "Sakin cevap", "Karşı tepki DIY-09 seçicisinden")
	print("MUHAFIZ TONU: GEÇTİ" if hata == 0 else "MUHAFIZ TONU: KALDI")
	quit(hata)
