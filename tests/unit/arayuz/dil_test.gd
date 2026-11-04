## YER-01, YER-03, YER-08, YER-18.
extends SceneTree

const YOL := "user://test_dil_ayar.cfg"
var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _calistir() -> void:
	_sil()
	GuvenliMetin.kur()
	var a := Ayarlar.new(YOL)
	a.yukle()
	DilAyari.bagla(a)
	_kontrol(DilAyari.diller().size() == 1 and DilAyari.diller()[0] == "tr", "YER-01: dosya yokken liste 1")
	DilAyari.uygula(a)
	_kontrol(TranslationServer.get_locale() == "tr", "YER-03: varsayılan locale tr")
	a.degerler[&"dil"] = "cop"
	DilAyari.uyari_sayisi = 0
	DilAyari.uygula(a)
	_kontrol(TranslationServer.get_locale() == "tr" and DilAyari.uyari_sayisi == 1, "YER-03: çöp dilde tr ve uyarı 1")
	GuvenliMetin.eksikler = PackedStringArray(["eski.anahtar.dil"])
	GuvenliMetin.kur()
	_kontrol(GuvenliMetin.eksikler.is_empty(), "YER-08: eksikler yeniden sayılır")
	_kontrol(DilAyari.gorunen("menu", "eski", "arayuz.dil.baslik") == tr("arayuz.dil.baslik"), "YER-18: menü etiketi yenilenir")
	_kontrol(DilAyari.gorunen("sorgu", "eski satır", "arayuz.dil.baslik") == "eski satır", "YER-18: sorgu satırı kalır")
	var ekran := AyarlarEkrani.new()
	ekran.ayarlar = a
	root.add_child(ekran)
	await process_frame
	_kontrol(ekran.find_child("DilSekmesiDugmesi", true, false) != null, "YER-01: dil düğmesi")
	ekran.queue_free()
	_sil()
	print("DIL: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(0 if hata == 0 else 1)


func _sil() -> void:
	if FileAccess.file_exists(YOL):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(YOL))


func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error("FAIL " + metin)
