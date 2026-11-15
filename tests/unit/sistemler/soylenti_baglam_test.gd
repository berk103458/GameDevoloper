extends SceneTree
## SOY-23: duyan karakterin bağlamında söylenti anahtarları; "duydum ki" dalı kart yolundan seçilir.

var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _initialize() -> void:
	if _kos() != true:
		hata += 1
		push_error("SOY-23: test bitmedi")
	print("SOY-23 GECTI" if hata == 0 else "SOY-23 KALDI (%d)" % hata)
	quit(1 if hata > 0 else 0)


func _kos() -> bool:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 9)
	var duyan := o.yonetim.kabul({"ad": "Duyan"})
	var sagir := o.yonetim.kabul({"ad": "Duymayan"})
	dene(NeDuydun.duydum_ki_sec(o, duyan).is_empty() and not o.has_meta(SoylentiKoprusu.META), "Ağ yokken dal yok, kart ağı kurmaz")
	var ag: RefCounted = SoylentiKoprusu.ag(o)
	var dogru_kayit: Dictionary = ag.soylenti_ekle("kapi_soz", "haksiz_ret", str(duyan.id), true, {"gece": 2})
	var yalan_kayit: Dictionary = ag.soylenti_ekle("yalan_soz", "siddet", str(duyan.id), false, {"gece": 2})
	dene(bool(dogru_kayit.get("olur", false)) and bool(yalan_kayit.get("olur", false)), "İki kayıt açıldı")
	var baglam := NeDuydun.sohbet_baglami(o, str(duyan.id))
	for olay_id in ["kapi_soz", "yalan_soz"]:
		var sorgu: Dictionary = ag.baglam_sorgusu_al(str(duyan.id), olay_id)
		var kayit: Dictionary = ag.ag_kayitlari[olay_id]
		var taban := "soylenti.%s." % olay_id
		dene(baglam.get(taban + "duydu") == true, "%s duydu true" % olay_id)
		dene(baglam.get(taban + "dogru") == sorgu.get("dogru"), "%s dogru sorgu" % olay_id)
		dene(str(baglam.get(taban + "kaynak", "")) == str(sorgu.get("kaynak", "")), "%s kaynak sorgu" % olay_id)
		dene(bool(baglam.get(taban + "dogru")) == bool(kayit.get("dogru", true)), "%s dogru ağ" % olay_id)
		dene(str(baglam.get(taban + "kaynak", "")) == str(kayit.get("kaynak", "")), "%s kaynak ağ" % olay_id)
	dene(baglam.get("soylenti.yalan_soz.dogru") == false, "Yanlış kaydın dogru anahtarı false")
	dene(baglam.get(SoylentiBaglami.OZET) == true, "Duyan özet true")
	var sessiz := NeDuydun.sohbet_baglami(o, str(sagir.id))
	dene(sessiz.get("soylenti.kapi_soz.duydu") == false and sessiz.get("soylenti.yalan_soz.duydu") == false, "Duymayanda duydu false")
	dene(sessiz.get(SoylentiBaglami.OZET) == false, "Duymayan özet false")
	var dal_yok := NeDuydun.duydum_ki_sec(o, sagir)
	dene(dal_yok.is_empty() or String(dal_yok.get("id", "")) != "duydum_ki", "Duymayanda dal seçilmez")
	dene(NeDuydun.duydum_ki_metin(o, sagir).is_empty(), "Duymayanda cümle yok")
	var dal := NeDuydun.duydum_ki_sec(o, duyan)
	dene(String(dal.get("id", "")) == "duydum_ki", "Duyanda duydum ki dalı")
	dene(String(dal.get("metin_anahtari", "")) == "soz.soylenti.duydum_ki", "Metin anahtarı")
	var cumle := NeDuydun.duydum_ki_metin(o, duyan)
	dene(cumle.begins_with("Duydum ki"), "Duyan cümlesi: %s" % cumle)
	return true
