extends SceneTree
const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	if not FileAccess.file_exists("res://src/sistemler/kapi_acilis_olayi.gd"):
		dene(false, "İlk akşam ulak ve aile akışı henüz uygulanmamış")
		quit(hata)
		return
	var ak = load("res://src/sistemler/kapi_acilis_olayi.gd")
	var kat := Katalog.new()
	kat.yukle()
	for karar in [&"kabul", &"ret"]:
		var o := Oturum.new(kat, 1404)
		ACILIS.kur(o)
		var kaynak := o.yonetim.kaydet().duplicate(true)
		dene(not ZamanMakinesi.ilerlet(o, 1).get("ok", true), "Debug zaman atlama açılışı atlayamaz")
		dene(not SenaryoKosucusu.calistir(o, "baskin").get("ok", true), "Debug senaryo açılıştan önce köyü değiştirmez")
		dene(o.yonetim.kaydet() == kaynak, "Engellenen debug senaryo kaynak/husumet değiştirmez")
		dene(o.gece_sonu().get("engellendi", false) and o.gun == 0, "Açılış ve ilk aile olmadan gece çözülmez")
		dene(o.yonetim.kaydet() == kaynak, "Engellenen gece kaynak/gün/RNG değiştirmez")
		dene(ak.baslat(o) and not ak.baslat(o), "Ulak aynı kayıtta bir kez başlatılır")
		dene(ak.ulak_suresi() > 0 and ak.ulak_suresi() < 60, "Ulak bölümü 60 saniyenin altında")
		dene(o.yonetim.nufus() == 2 and o.gece_kuyrugu().is_empty(), "Ulak nüfus ve kuyruk yaratmaz")
		var ulak := Gelen.new()
		ulak.id = &"acl04_ulak"
		dene(o.karar_ver(ulak, &"kabul").get("engellendi", false) and o.yonetim.nufus() == 2, "Ulak doğrudan karar API çağrısıyla da köylü olamaz")
		ak.ulak_bitir(o)
		var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
		dene(not ak.baslat(geri) and ak.aile_bekliyor(geri), "Ulak sonrasında yükleme ulağı tekrarlamaz")
		var aile: Array[Gelen] = geri.gece_kuyrugu()
		dene(aile.size() == 1 and aile[0].sorular.size() == 2 + ak.AYAR.ek_sorular.size() and aile[0].acilis == String(ak.AYAR.acilis) and aile[0].heybe != null, "Tehdit takvimine takılmadan ilk aile, selam/konu/ek sorular/açılış/heybe")
		dene(geri.gece_sonu().get("engellendi", false) and geri.gun == 0, "Öğretici atlanınca da aile kararı gerekir")
		dene(geri.karar_ver(aile[0], &"rusvet").get("engellendi", false), "İlk aile için geçersiz karar reddedilir")
		var sonuc := geri.karar_ver(aile[0], karar)
		dene(not sonuc.get("engellendi", false) and not ak.aile_bekliyor(geri), "Normal karar API'si açılışı tamamlar")
		dene(geri.yonetim.nufus() == (4 if karar == &"kabul" else 2), "Kabul iki kişilik aileyi, ret sıfır kişiyi ekler; ulak eklenmez")
		var once := geri.yonetim.kaydet().duplicate(true)
		dene(geri.karar_ver(aile[0], karar).get("engellendi", false) and geri.yonetim.kaydet() == once, "Aynı aile kararı iki kez uygulanmaz")
		geri.gece_sonu()
		dene(geri.gun == 1 and not ACILIS.kapi_kapali(geri), "Ertesi sabah kapı açık ve gün tam bir ilerler")
		var yine := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(geri.kaydet())))
		dene(not ak.baslat(yine) and not ak.aile_bekliyor(yine), "Ertesi sabah kayıt tekrarı yok")
	var eski := Oturum.new(kat, 42)
	eski.gun = 7
	dene(not ak.gece_engelli(eski) and not ak.baslat(eski), "Eski kayda açılış dayatılmaz")
	print("KAPI AÇILIŞ OLAYI: GEÇTİ" if hata == 0 else "KAPI AÇILIŞ OLAYI: KALDI")
	quit(hata)
