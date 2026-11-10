extends SceneTree
## SOY-09: "Ne duydun?" — duyan köylü kendi sürümünü söyler, duymayan ve hükme bağlanan konuda dal yoktur.

var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 9)
	var tasiyan := o.yonetim.kabul({"ad": "Taşıyan"})
	var bozan := o.yonetim.kabul({"ad": "Bozan"})
	var sagir := o.yonetim.kabul({"ad": "Duymayan"})
	dene(NeDuydun.metin(o, tasiyan) == "" and not o.has_meta(SoylentiKoprusu.META), "Ağ yokken dal yok, kart ağı kurmaz")
	var a: RefCounted = SoylentiKoprusu.ag(o)
	a.soylenti_ekle("kapi_x", "haksiz_ret", str(tasiyan.id), true, {"gece": 3})
	a.ag_kayitlari["kapi_x"].duyanlar.append(str(bozan.id))
	a.ag_kayitlari["kapi_x~" + str(bozan.id)] = a._bozuk_kopya(a.ag_kayitlari["kapi_x"], "kapi_x", str(bozan.id), "yer_kaymasi", 4)
	var asil := String(a.veri_yapilandirma.soylenti_kaliplari.haksiz_ret)
	var bozuk := String(a.veri_yapilandirma.bozulma_kaliplari.yer_kaymasi)
	dene(NeDuydun.metin(o, tasiyan) == "Taşıyan: «%s»" % asil, "Taşıyan asıl haberi söyler")
	dene(NeDuydun.metin(o, bozan) == "Bozan: «%s»" % bozuk, "Bozan kendi bozuk sürümünü söyler")
	dene(NeDuydun.metin(o, sagir) == "", "Duymayanda dal 0")
	a.ag_kayitlari["kapi_x"].hukme_baglandi = true
	dene(NeDuydun.metin(o, tasiyan) == "", "Hükme bağlanan konu sorulmaz")
	print("NE DUYDUN: GEÇTİ" if hata == 0 else "NE DUYDUN: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
