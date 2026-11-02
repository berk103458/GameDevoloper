extends SceneTree
var hata := 0
var cagrilar: Array[int] = []
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _adim_1(v: Dictionary) -> Dictionary:
	cagrilar.append(1)
	v["ara"] = true
	v["surum"] = 2
	return v
func _adim_2(v: Dictionary) -> Dictionary:
	cagrilar.append(2)
	dene(v.get("ara", false), "İkinci adım ara adımın sonucunu alır")
	v["surum"] = 3
	return v
func _initialize() -> void:
	if not FileAccess.file_exists("res://src/sistemler/kayit_gocu_soz.gd"):
		dene(false, "İki basamaklı göç yürütücüsü henüz yok")
		quit(hata)
		return
	var z = load("res://src/sistemler/kayit_gocu_soz.gd")
	var kaynak := {"surum":1, "kisi":{"hafiza":["selam"]}}
	var once := kaynak.duplicate(true)
	var sonuc: Dictionary = z.uygula(kaynak, 3, {1:_adim_1, 2:_adim_2})
	dene(sonuc.get("surum") == 3 and cagrilar == [1, 2], "N→N+2 iki çağrıyla, ara fonksiyon tam bir kez")
	sonuc.kisi.hafiza.append("sonuçtaki değişiklik")
	dene(kaynak == once, "Kaynak ve iç içe hafıza sözlüğü değişmez")
	cagrilar.clear()
	dene(z.uygula(kaynak, 3, {1:func(v: Dictionary) -> Dictionary: v.surum = 3; return v}).is_empty(), "Sürüm atlayan adım reddedilir")
	dene(z.uygula(kaynak, 3, {1:_adim_1}).is_empty(), "Ara adım eksikse zincir kapanır")
	# KAY-60: kaydın kendi beyanı proje onayı değildir; ara adım silinemez.
	var sahte_onay := kaynak.duplicate(true)
	sahte_onay["surum_atlama_onayi"] = true
	var onay_once := sahte_onay.duplicate(true)
	dene(z.uygula(sahte_onay, 3, {1:func(v: Dictionary) -> Dictionary: v.surum = 3; return v}).is_empty(), "Kayıttaki sahte onay sürüm atlatmaz")
	dene(sahte_onay == onay_once, "Reddedilen atlama kaynak alanları değiştirmez")
	dene(z.uygula(kaynak, 4, {1:_adim_1, 3:func(v: Dictionary) -> Dictionary: v.surum = 4; return v}).is_empty(), "Ortadaki silinmiş adım sonraki adıma sıçramaz")
	dene(z.uygula(kaynak, 3, {1:func(_v: Dictionary): return null}).is_empty(), "Boş adım sonucu reddedilir")
	dene(z.uygula(kaynak, 3, {1:Callable()}).is_empty(), "Geçersiz çağrı reddedilir")
	dene(z.uygula({"surum":4}, 3, {}).is_empty(), "Gelecek sürüm geriye göçmez")
	dene(z.uygula({"surum":1.5}, 3, {}).is_empty(), "Kesirli sürüm reddedilir")
	dene(z.uygula(kaynak, 1, {}) == kaynak, "Güncel sürüm adım çağırmaz")
	print("SÖZ KAYIT GÖÇÜ: GEÇTİ" if hata == 0 else "SÖZ KAYIT GÖÇÜ: KALDI")
	quit(hata)
