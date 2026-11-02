extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 3111)
	var grup: Variant = o.get("grup_itibari")
	if grup == null:
		dene(false, "Grup itibarı oturum kaydına henüz bağlı değil")
		quit(hata)
		return
	grup.uygula("turkmen", -3)
	grup.uygula("rum", 4)
	var veri := JSON.parse_string(JSON.stringify(o.kaydet())) as Dictionary
	var geri := Oturum.kayittan(kat, veri)
	dene(geri != null, "İtibar kaydı gerçek Oturum olarak açılır")
	dene(geri.get("grup_itibari").deger("turkmen") == -3 and geri.get("grup_itibari").deger("rum") == 4, "Türkmen -3 / Rum +4 yüklemede korunur")
	dene(geri.get("grup_itibari").tum_degerler().size() == 6, "Altı grup kayıtta")
	veri.grup_itibari.puanlar.erase("rum")
	geri = Oturum.kayittan(kat, veri)
	dene(geri.get("grup_itibari").deger("rum") == 0 and geri.get("grup_itibari").deger("turkmen") == -3, "Eksik grup sıfır, diğer puan değişmez")
	veri.grup_itibari.puanlar["turkmen"] = -200
	geri = Oturum.kayittan(kat, veri)
	dene(geri.get("grup_itibari").deger("turkmen") == -10, "Mevcut itibar yükleyicisi sınırı korur")
	veri.erase("grup_itibari")
	geri = Oturum.kayittan(kat, veri)
	for g in geri.get("grup_itibari").tum_degerler(): dene(geri.get("grup_itibari").deger(g) == 0, "Eski kayıtta olmayan grup sıfır")
	dene(o.get("grup_itibari").deger("turkmen") == -3, "Yükleme kaynak oturumu değiştirmez")
	print("GRUP İTİBARI KAYIT: GEÇTİ" if hata == 0 else "GRUP İTİBARI KAYIT: KALDI")
	quit(hata)
