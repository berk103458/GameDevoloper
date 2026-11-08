extends Node
const G = preload("res://src/sistemler/muhafiz_gecmisi.gd")
class TestAna extends Ana:
	var basladi := false
	func _ready() -> void:
		pass
	func _goster(e: Control) -> void:
		if _ekran != null: _ekran.queue_free()
		_ekran = e
		add_child(e)
	func _koye_git(_rapor: Dictionary = {}) -> void:
		basladi = true
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _ready() -> void:
	call_deferred("calistir")
func calistir() -> void:
	var a := TestAna.new()
	add_child(a)
	a.katalog = Katalog.new()
	a.katalog.yukle()
	a.ayarlar = Ayarlar.new("user://acl06_ayar_%d.cfg" % OS.get_process_id())
	AyarlarEk.bagla(a.ayarlar)
	a.oyuncu_izi.sifirla()
	a.kayit = GuvenliKayit.new("user://acl06_akis_%d.json" % OS.get_process_id())
	var eski := Oturum.new(a.katalog, 42)
	a.kayit.yaz(eski.kaydet())
	a.yeni_oyun(1406)
	dene(a.oturum == null and not a.basladi and a.kayit.var_mi(), "Seçimsiz oyun başlamaz ve mevcut kayıt silinmez")
	dene(a._ekran is BilgiEkrani and a._ekran.dugmeler.size() == 5, "Dört geçmiş ve geri dönüş sunulur")
	# Aynı sinyal menü düğmelerinden de yayılır; seçim gerçek Ana yolunu kullanır.
	a._ekran.secildi.emit(2)
	dene(a._ekran.name == &"IlkSaatKadraci" and a.oturum == null and a.kayit.var_mi(), "İlk saat kadrajı kayıt silinmeden gösterilir")
	a._ekran.secildi.emit(0)
	dene(a.basladi and a.oturum != null and G.kimlik(a.oturum) == "medrese_talebesi", "Seçim gerçek açılışa aktarılır")
	dene(a.oturum != null and a.oturum.yonetim.nufus() == 2, "ACL-01 kuruluşu korunur")
	a.kayit.sil()
	a.queue_free()
	await get_tree().process_frame
	print("MUHAFIZ GEÇMİŞİ AKIŞ: GEÇTİ" if hata == 0 else "MUHAFIZ GEÇMİŞİ AKIŞ: KALDI")
	await Ses.cik(hata)
