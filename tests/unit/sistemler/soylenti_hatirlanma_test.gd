extends SceneTree
## SOY-26: çınar meclisi nitelik düğmesi muhafız düğümü yazınca DIY-14 notu bir kez çıkar.
## Yol: SoylentiHukmu.ekle (CinarMeclisPaneli buradan düğmeyi kurar) → nitele → HatirlanmaNotu.

class MeclisEkrani extends Control:
	var oturum: Oturum
	var ayarlar: Ayarlar

	func _etiket(ust: Control, metin: String, _punto: int) -> Label:
		var l := Label.new()
		l.text = metin
		ust.add_child(l)
		return l

	func _dugme(metin: String, ust: Control) -> Button:
		var b := Button.new()
		b.text = metin
		ust.add_child(b)
		return b


var hata := 0
var _kat: Katalog


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _initialize() -> void:
	await process_frame
	_kat = Katalog.new()
	_kat.yukle()
	if _not_bir_kez() != true:
		hata += 1
		push_error("SOY-26 not bir kez bitmedi")
	if _ikinci_nitelik() != true:
		hata += 1
		push_error("SOY-26 ikinci nitelik bitmedi")
	if _ayar_kapali() != true:
		hata += 1
		push_error("SOY-26 ayar kapali bitmedi")
	print("SOY-26 GECTI" if hata == 0 else "SOY-26 KALDI (%d)" % hata)
	quit(1 if hata > 0 else 0)


func _not_bir_kez() -> bool:
	dene(HatirlanmaNotu.TETIK_ANAHTARLARI.has("soylenti_muhafiz"), "Tetik listesinde soylenti_muhafiz")
	var kur := _kur(true)
	if kur.is_empty():
		return false
	var ekran: MeclisEkrani = kur.ekran
	dene(ekran.get_node_or_null("HatirlanmaNotu") == null, "Düğmeden önce not yok")
	var dugme: Button = kur.dugme
	dugme.pressed.emit()
	var notu := ekran.get_node_or_null("HatirlanmaNotu") as HatirlanmaNotu
	dene(notu != null and notu.visible and notu.gorunme_sayisi() == 1, "Muhafız düğümü yazılınca not tam 1")
	var sonuc: Dictionary = notu.get_meta(&"son_sonuc", {}) if notu != null else {}
	dene(String(sonuc.get("ceviri_anahtari", "")) == String(HatirlanmaNotu.CEVIRI_ANAHTARI), "Sonuçtaki anahtar DIY-14 anahtarı")
	dene(String(HatirlanmaNotu.CEVIRI_ANAHTARI) == "UI_BU_HATIRLANACAK", "DIY-14 anahtarı UI_BU_HATIRLANACAK")
	dene(_dugum(kur.oturum).has("muhafiz_dugumu"), "İlk nitelik kayda düğüm yazar")
	ekran.queue_free()
	return true


func _ikinci_nitelik() -> bool:
	var kur := _kur(true)
	if kur.is_empty():
		return false
	var dugme: Button = kur.dugme
	dugme.pressed.emit()
	var notu := (kur.ekran as MeclisEkrani).get_node_or_null("HatirlanmaNotu") as HatirlanmaNotu
	var once := notu.gorunme_sayisi() if notu != null else -1
	var nitelik := String(_dugum(kur.oturum).get("muhafiz_dugumu", {}).get("nitelik", ""))
	dugme.pressed.emit()
	var diger: Button = kur.kutu.get_node_or_null("meclis_soylenti_nitele_yalan") as Button
	if diger != null:
		diger.pressed.emit()
	var sonra := notu.gorunme_sayisi() if notu != null else -1
	dene(once == 1 and (sonra - once) == 0, "Aynı konuya ikinci nitelikte not 0")
	dene(String(_dugum(kur.oturum).get("muhafiz_dugumu", {}).get("nitelik", "")) == nitelik, "İkinci nitelik düğümü yeniden yazmaz")
	(kur.ekran as Node).queue_free()
	return true


func _ayar_kapali() -> bool:
	var kur := _kur(false)
	if kur.is_empty():
		return false
	(kur.dugme as Button).pressed.emit()
	var notu := (kur.ekran as MeclisEkrani).get_node_or_null("HatirlanmaNotu") as HatirlanmaNotu
	var sonuc: Dictionary = notu.get_meta(&"son_sonuc", {}) if notu != null else {}
	dene(notu != null and notu.gorunme_sayisi() == 0 and not notu.visible, "Ayar kapalıyken not 0")
	dene(int(sonuc.get("not_sayisi", -1)) == 0 and not bool(sonuc.get("not_gorundu", true)), "Ayar kapalıyken sonuç notu gizli")
	dene(_dugum(kur.oturum).has("muhafiz_dugumu"), "Ayar kapalıyken muhafız düğümü kayıtta 1")
	(kur.ekran as Node).queue_free()
	return true


func _kur(ayar_acik: bool) -> Dictionary:
	var o := _koy()
	var sikayet := SoylentiKoprusu.meclis_sikayeti(o)
	dene(not sikayet.is_empty(), "Meclis şikâyeti var")
	if sikayet.is_empty():
		return {}
	var ekran := MeclisEkrani.new()
	ekran.oturum = o
	ekran.ayarlar = Ayarlar.new("user://unused_soy26.cfg")
	ekran.ayarlar.degerler[&"hatirlanma_notu"] = ayar_acik
	root.add_child(ekran)
	var kutu := VBoxContainer.new()
	ekran.add_child(kutu)
	SoylentiHukmu.ekle(ekran, kutu, sikayet)
	var dugme := kutu.get_node_or_null("meclis_soylenti_nitele_dogru") as Button
	dene(dugme != null and kutu.get_node_or_null("meclis_soylenti_nitele_yalan") != null, "Yol SoylentiHukmu nitelik düğmesi")
	if dugme == null:
		ekran.queue_free()
		return {}
	return {"ekran": ekran, "oturum": o, "kutu": kutu, "dugme": dugme}


func _dugum(o: Oturum) -> Dictionary:
	var a: RefCounted = SoylentiKoprusu.ag(o)
	var konu: Dictionary = a.meclis_sikayeti_sec()
	if konu.is_empty():
		return {}
	return a.ag_kayitlari[konu.olay_id]


func _gelen(id: String) -> Gelen:
	var g := Gelen.new()
	g.id = StringName(id)
	g.ad_anahtari = "test"
	g.sinif = &"koylu"
	return g


func _koy() -> Oturum:
	var o := Oturum.new(_kat, 3112)
	o.yonetim.gun = 5
	o.gun = 5
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.karar_ver(_gelen("yolcu_a"), &"ret")
	for i in 20:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	for i in 2:
		o.gece_sonu()
	return o
