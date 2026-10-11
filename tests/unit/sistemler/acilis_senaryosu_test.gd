extends SceneTree
const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const FAZ = preload("res://src/sistemler/oturum_fazi.gd")
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1401)
	var ilk := o.yonetim.kaynaklar.kaydet().duplicate(true)
	var akce := o.akce
	var rng := [o._rng.state, o.yonetim._rng.state]
	ACILIS.kur(o)
	dene(FAZ.durum(o) == "koy", "Yalnız yeni oyun köy fazında başlar")
	dene(o.yonetim.binalar.size() == 1 and o.yonetim.binalar[0].hazir(), "Tam bir hazır ev")
	dene(o.yonetim.nufus() == 2 and o.yonetim.yatak_kapasitesi() == 4, "Muhafız ve eş mevcut nüfus/yatak hesabında")
	dene(o.yonetim.kabul_sayisi == 0, "Kuruluş sakinleri kapı kabul sayacına yazılmaz")
	dene(o.yonetim.kaynaklar.kaydet() == ilk and o.akce == akce, "Hazır evin maliyeti başlangıç stokundan kesilmez")
	dene([o._rng.state, o.yonetim._rng.state] == rng, "Kuruluş kapı ve köy RNG akışını tüketmez")
	dene(ACILIS.kapi_kapali(o) and o.gece_kuyrugu().is_empty(), "İlk gün kapı kapalı ve doğrudan kuyruk üretimi boş")
	var h := ACILIS.durum(o)
	dene(int(h.get("es_id", -1)) > 0 and h.get("es_id") != h.get("muhafiz_id"), "İki ayrı mevcut kişi kimliği")
	var ayni := Oturum.new(kat, 1401)
	ACILIS.kur(ayni)
	dene(o.yonetim.kaydet() == ayni.yonetim.kaydet(), "Aynı tohum aynı ev ve iki kişi")
	var kayit := JSON.parse_string(JSON.stringify(o.kaydet())) as Dictionary
	var geri := Oturum.kayittan(kat, kayit)
	dene(geri != null and ACILIS.durum(geri) == h and FAZ.durum(geri) == "koy", "JSON kuruluş/faz kimlikleri korunur")
	if kayit.has("acilis_hanesi"):
		kayit.acilis_hanesi.erase("es_id")
	geri = Oturum.kayittan(kat, kayit)
	dene(geri != null and ACILIS.durum(geri).get("es_id") == h.get("es_id"), "Eksik eş kimliği kuruluş kişisinden türetilir")
	kayit.erase("acilis_hanesi")
	geri = Oturum.kayittan(kat, kayit)
	dene(geri != null and ACILIS.durum(geri) == h, "Tüm optional hane alanı eksikken kuruluş işaretleri kimliği korur")
	var once := o.yonetim.kaydet().duplicate(true)
	ACILIS.kur(o)
	dene(o.yonetim.kaydet() == once, "Kuruluş tekrarı bedava ikinci ev/kişi eklemez")
	if o.yonetim.binalar.size() == 1:
		o.yonetim.bina_yik(o.yonetim.binalar[0].id)
		ACILIS.kur(o)
		dene(o.yonetim.yatak_kapasitesi() == 0 and o.yonetim.binalar.is_empty(), "Yıkılan ev yeniden doğmaz")
		dene(o.yonetim.kaynaklar.kaydet() == ilk and o.akce == akce, "Bedava evin yıkımı kaynak/akçe üretmez")
	o.gun = 1
	dene(not ACILIS.kapi_kapali(o), "İlk gün sonrası kapı kilidi kalkar")
	for faz in ["kapi", "koy"]:
		var eski := Oturum.new(kat, 42)
		eski.gun = 12
		FAZ.ayarla(eski, faz)
		var v := eski.kaydet()
		v.erase("acilis_hanesi")
		var eski_geri := Oturum.kayittan(kat, v)
		dene(eski_geri.gun == 12 and FAZ.durum(eski_geri) == faz and eski_geri.yonetim.nufus() == 0 and eski_geri.yonetim.binalar.is_empty(), "Eski kayıt fazı/günü korunur; ev/eş eklenmez")
	print("AÇILIŞ SENARYOSU: GEÇTİ" if hata == 0 else "AÇILIŞ SENARYOSU: KALDI")
	quit(hata)
