extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func ham_yaz(yol: String, metin: String) -> void:
	var f := FileAccess.open(yol, FileAccess.WRITE)
	f.store_string(metin)
	f.close()
func _initialize() -> void:
	var yol := "user://kalfa_kay64_%d.json" % OS.get_process_id()
	var k := GuvenliKayit.new(yol)
	k.sil()
	for metin in ['{"surum":3,"koy_yonetimi":', '{"surum":3,"kisi":[1,', '{', '']:
		ham_yaz(yol, metin)
		var once := FileAccess.get_file_as_bytes(yol)
		dene(GuvenliKayit._oku_dosya(yol).is_empty() and k.oku().is_empty(), "Kesik dosya boş kayıt döndürür")
		dene(FileAccess.get_file_as_bytes(yol) == once, "Okuma kesik kaydı değiştirmez")
	ham_yaz(yol + ".tmp", '{"surum":3,"isaret":"tam ama geçici"}')
	dene(k.oku().is_empty(), "Geçerli tmp ana kayıt diye açılmaz")
	ham_yaz(yol + ".bak", '{"surum":3,"isaret":"sağlam yedek"}')
	var yedek_once := FileAccess.get_file_as_bytes(yol + ".bak")
	var geri := k.oku()
	dene(geri.get("_yedekten", false) and geri.get("isaret") == "sağlam yedek", "Mevcut sağlam yedek yolu çalışır")
	dene(FileAccess.get_file_as_bytes(yol + ".bak") == yedek_once, "Yedek baytları değişmez")
	k.sil()
	print("KESİK KAYIT: GEÇTİ" if hata == 0 else "KESİK KAYIT: KALDI")
	quit(hata)
