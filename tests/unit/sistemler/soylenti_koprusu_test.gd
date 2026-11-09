extends SceneTree
## SOY-01/03/04: kapıdaki ağır olay gerçek kapı kararıyla oturumun dedikodu kaydına ve söylenti ağına düşer.

var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _gelen(id: String) -> Gelen:
	var g := Gelen.new()
	g.id = StringName(id)
	g.ad_anahtari = "test"
	g.sinif = &"koylu"
	return g


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 3112)
	o.yonetim.gun = 5
	o.gun = 5
	var ret := o.karar_ver(_gelen("yolcu_a"), &"ret")
	dene(not bool(ret.get("engellendi", false)), "Ret kararı uygulanır")
	dene(o.dedikodu.kayitlar().is_empty(), "Taşıyan girmeden kayıt yok")
	var kabul := o.karar_ver(_gelen("yolcu_b"), &"kabul")
	var tasiyan := str(int(kabul.get("koylu_id", -1)))
	var olay_id := "kapi_haksiz_ret_5_yolcu_a"
	var ag: RefCounted = SoylentiKoprusu.ag(o)
	dene(ag.ag_kayitlari.has(olay_id), "Haksız ret ağa düşer")
	dene(ag.kaynak_ve_dogruluk(olay_id) == {"kaynak": tasiyan, "dogru": true}, "Kaynak kabul edilen taşıyandır")
	dene(o.dedikodu.kayitlar().size() == 1 and o.dedikodu.kayitlar()[0].tanik_id == tasiyan, "Aynı kayıt DIY-13 kuyruğunda, tanık taşıyan")
	dene(ag.kaynak_ve_dogruluk("eski_kayit") == {"kaynak": "", "dogru": true}, "Eski kayıt kaynaksız ve doğru")
	o.karar_ver(_gelen("yolcu_c"), &"kabul")
	dene(o.dedikodu.kayitlar().size() == 1, "Aynı haber ikinci kez taşınmaz")

	o.karar_ver(_gelen("yolcu_d"), &"rusvet")
	o.gece_sonu()
	o.karar_ver(_gelen("yolcu_e"), &"kabul")
	dene(not ag.ag_kayitlari.has("kapi_rusvet_5_yolcu_d"), "Gece biter, taşıyansız rüşvet düşer")

	var veri := JSON.parse_string(JSON.stringify(o.kaydet())) as Dictionary
	var geri := Oturum.kayittan(kat, veri)
	dene(geri != null and SoylentiKoprusu.ag(geri).kaynak_ve_dogruluk(olay_id).kaynak == tasiyan, "Kaynak kayıttan döner")
	veri.erase("soylenti_agi")
	var eski := Oturum.kayittan(kat, veri)
	dene(eski != null and SoylentiKoprusu.ag(eski).ag_kayitlari.is_empty(), "Eski kayıt ağsız açılır")
	print("SÖYLENTİ KÖPRÜSÜ: GEÇTİ" if hata == 0 else "SÖYLENTİ KÖPRÜSÜ: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
