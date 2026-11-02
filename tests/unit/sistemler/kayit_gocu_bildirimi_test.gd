extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	if not FileAccess.file_exists("res://src/sistemler/kayit_gocu_bildirimi.gd"):
		dene(false, "Göç bildirimi henüz yok")
		quit(hata)
		return
	var b = load("res://src/sistemler/kayit_gocu_bildirimi.gd")
	TranslationServer.set_locale("tr")
	GuvenliMetin.kur()
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 3106)
	var eski := o.kaydet()
	eski.surum = 2
	var kapali := Oturum.new(kat, 3106)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(kapali)
	var kapali_kayit := kapali.kaydet()
	kapali_kayit.surum = 2
	var kapali_geri := Oturum.kayittan(kat, kapali_kayit)
	dene(kapali_geri.gece_sonu().get("engellendi", false) and b.durum(kapali_geri).get("bekliyor", false), "Engellenen gece bildirimi tüketmez")
	var geri := Oturum.kayittan(kat, eski)
	dene(geri != null and b.durum(geri).get("bekliyor", false), "Başarılı göç bildirimi bekliyor")
	var ara := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(geri.kaydet())))
	var rapor := ara.gece_sonu()
	var adet := 0
	for e in rapor.olaylar:
		if e.anahtar == b.ANAHTAR:
			adet += 1
			dene(IflasYoneticisi.olay_metin(e) == "Kayıt 2 sürümünden 3 sürümüne güncellendi.", "Gerçek rapor biçimi ve CSV metni")
	dene(adet == 1 and not b.durum(ara).get("bekliyor", true), "İlk gece tek satır, makbuz tüketildi")
	var tekrar := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(ara.kaydet())))
	var r: Dictionary = {"olaylar":[]}
	b.gece(tekrar, r)
	dene(r.olaylar.is_empty(), "Yüklemede veya ikinci raporda tekrar yok")
	b.gece(o, r)
	dene(r.olaylar.is_empty(), "Normal oturum göç bildirimi üretmez")
	dene(TranslationServer.translate(b.ANAHTAR) != b.ANAHTAR, "Metin anahtarı tabloda")
	print("KAYIT GÖÇÜ BİLDİRİMİ: GEÇTİ" if hata == 0 else "KAYIT GÖÇÜ BİLDİRİMİ: KALDI")
	quit(hata)
