extends SceneTree
# YAZ-89: eski kayıt yeni Söz dosyası referansı taşımak zorunda değildir.
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1989)
	o.yonetim.gun = 9
	o.yonetim.kabul({"ad":"Eski kaydın kişisi"})
	for surum in [2, 3]:
		var eski: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
		eski.surum = surum
		for alan in ["soz_dosyasi", "soz_dosyalari", "kisi_hafizasi", "grup_itibari", "dedikodu", "icerik_surumu", "sabah_defteri_satiri", "kapi_eylemleri"]:
			eski.erase(alan)
		var once := eski.duplicate(true)
		var geri := Oturum.kayittan(kat, eski)
		dene(geri != null, "Söz referansı olmayan eski v2/v3 kaydı açılır")
		if geri == null: continue
		dene(geri.gun == 9 and geri.yonetim.nufus() == 1, "Eski köy ve gün korunur")
		dene(geri.kaydet().rng == eski.rng, "Eksik Söz alanı RNG ilerletmez")
		dene(eski == once and not eski.has("soz_dosyasi"), "Yükleme eski girdiye zorunlu dosya alanı yazmaz")
		dene(not geri.kaydet().has("soz_dosyasi") and not geri.kaydet().has("soz_dosyalari"), "Yeni Söz dosyası referansı uydurulmaz")
	print("OPTIONAL SÖZ KAYDI: GEÇTİ" if hata == 0 else "OPTIONAL SÖZ KAYDI: KALDI")
	quit(hata)
