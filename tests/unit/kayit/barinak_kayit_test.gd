extends SceneTree
const BARINAK = preload("res://src/kapi/barinak_uyarisi.gd")
const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func sayilar(y: KoyYonetimi) -> Array:
	return [BARINAK.toplam(y), BARINAK.dolu(y), BARINAK.acikta(y), y.koylular.size()]
func evler(y: KoyYonetimi) -> Array:
	var sonuc := []
	for k in y.koylular:
		sonuc.append([k.ad, k.ev])
	return sonuc
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 3129)
	ACILIS.kur(o)
	for ad in ["Bir", "İki"]:
		o.yonetim.kabul({"ad": ad})
	o.yonetim._barindir()
	for ad in ["Açıkta Bir", "Açıkta İki"]:
		o.yonetim.kabul({"ad": ad})
	var once := sayilar(o.yonetim)
	var ev_once := evler(o.yonetim)
	dene(once == [4, 4, 2, 6], "Dolu dört yatak ve açıkta iki kişi fikstürü")
	var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	for surum in [3, 2]:
		var girdi := veri.duplicate(true)
		girdi.surum = surum
		if surum == 2:
			for alan in ["muhafiz_akce", "muhafiz_esyalari", "muhafiz_tecrubesi", "yeni_binalar", "mevsim"]:
				girdi.erase(alan)
		var korunmus := girdi.duplicate(true)
		var geri := Oturum.kayittan(kat, girdi)
		dene(geri != null, "Güncel ve eski kayıt açılır")
		if geri == null: continue
		dene(sayilar(geri.yonetim) == once, "Yükleme ve gerçek göç toplam/dolu/açıkta/nüfusu değiştirmez")
		dene(evler(geri.yonetim) == ev_once, "Göç kimseyi içeri veya dışarı taşımaz")
		dene(girdi == korunmus, "Göç kaynak sözlüğü değiştirmez")
		var ikiz := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(geri.kaydet())))
		dene(sayilar(ikiz.yonetim) == once and evler(ikiz.yonetim) == ev_once, "İkinci yüklemede de atama yapılmaz")
	dene(sayilar(o.yonetim) == once and evler(o.yonetim) == ev_once, "Kaynak oturum korunur")
	print("KAY-29 BARINAK KAYDI: GEÇTİ" if hata == 0 else "KAY-29 BARINAK KAYDI: KALDI")
	quit(hata)
