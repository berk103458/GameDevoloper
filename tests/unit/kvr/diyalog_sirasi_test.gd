## SYS-16: adsız diyalog sırası GuvenliKayit ile kalıcı; "Devam" kaldığı diyalogdan sürer; bozuk değer güvenli.
extends SceneTree
const SIRA = preload("res://src/sistemler/diyalog_sirasi.gd")
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var a := Oturum.new(kat, 1616)
	for i in 3: a._figur_gelen()
	dene(a._gemini_sira == 3, "Üç hazır diyalog tüketildi")
	var kayit := GuvenliKayit.new("user://test_sys16.json")
	dene(kayit.yaz(a.kaydet()), "user:// kaydı yazıldı")
	var b := Oturum.kayittan(kat, kayit.oku())
	dene(b != null and b._gemini_sira == 3, "Sıra kayıttan döndü")
	var ga := a._figur_gelen()
	var gb := b._figur_gelen()
	dene(ga.giris_anahtari == gb.giris_anahtari and ga.giris_anahtari != "", "Devam: aynı (4.) diyalog gelir, baştan başlamaz")
	# Liste sonu: kayıttan sonra da tekrar etmez, sınıf şablonuna düşer.
	var c := Oturum.new(kat, 1617)
	c._gemini_sira = 100000
	var son := Oturum.kayittan(kat, c.kaydet())
	dene(son._gemini_al().is_empty(), "Biten liste kayıttan sonra yeniden başlamaz")
	# Bozuk/legacy değerler.
	dene(SIRA.oku(-1) == 0 and SIRA.oku("abc") == 0 and SIRA.oku(null) == 0 and SIRA.oku(2.5) == 0 and SIRA.oku(INF) == 0, "Bozuk değer 0")
	dene(SIRA.oku(7) == 7 and SIRA.oku(7.0) == 7 and SIRA.oku("7") == 7, "Geçerli değer korunur")
	var v := a.kaydet()
	v["diyalog_sira"] = -1
	var d := Oturum.kayittan(kat, v)
	dene(d != null and d._gemini_sira == 0, "Negatif değer sondan okumaya yol açmaz")
	v.erase("diyalog_sira")
	dene(Oturum.kayittan(kat, v)._gemini_sira == 0, "Legacy (alan yok) kayıt baştan")
	kayit.sil()
	print("DIYALOG SIRASI: GEÇTİ" if hata == 0 else "DIYALOG SIRASI: KALDI")
	quit(hata)
