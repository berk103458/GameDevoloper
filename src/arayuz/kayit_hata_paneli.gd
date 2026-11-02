## KAY-64: başarısız yükleme mevcut bilgi ekranında görünür; kayıt silinmez.
extends RefCounted
static func goster(a: Control) -> void:
	var k := a.get("kayit") as GuvenliKayit
	var metin := "Kayıt veya yedek dosyası okunamadı. Dosyalar korundu. Ana menüye dönüp yeniden deneyebilirsin."
	if k != null and (GuvenliKayit.gelecek_surum(GuvenliKayit._oku_dosya(k.yol)) or GuvenliKayit.gelecek_surum(GuvenliKayit._oku_dosya(k.yol + ".bak"))):
		metin = "Bu kayıt oyunun daha yeni bir sürümünde oluşturulmuş. Dosyalar korundu. Uygun oyun sürümüyle yeniden açabilirsin."
	var e: BilgiEkrani = a.call("_bilgi", "Kayıt açılamadı", metin, ["Ana menüye dön"], -1, "")
	e.secildi.connect(func(_i: int) -> void: a.call("ana_menu"))
	a.call("_goster", e)
