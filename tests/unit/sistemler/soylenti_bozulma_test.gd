extends SceneTree
## SOY-05/44: söylenti gerçek gece sonunda yayılırken bozulur; kopya yanlıştır, kaynağı bozandır, asıl kalır.
## Bozulma oranı tablodadır, üç biçim üç kalıptır.

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
	o.yonetim.a = o.yonetim.a.duplicate(true)
	o.yonetim.a.ambar_taban_kapasite = 100000
	o.karar_ver(_gelen("yolcu_a"), &"ret")
	for i in 30:
		o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
	o.yonetim.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000})
	var ag: RefCounted = SoylentiKoprusu.ag(o)
	var asil := "kapi_haksiz_ret_5_yolcu_a"
	var beklenen := 0
	var tutarli := true
	for gece in 4:
		var onceki: Array = (ag.ag_kayitlari[asil].duyanlar as Array).duplicate()
		o.gece_sonu()
		for yd in ag.ag_kayitlari[asil].duyanlar:
			if yd in onceki:
				continue
			var bicim: String = ag.bozulma_bicimi(asil, yd, o.gun)
			var kopya: Dictionary = ag.ag_kayitlari.get("%s~%s" % [asil, yd], {})
			if bicim.is_empty() != kopya.is_empty():
				tutarli = false
			if not bicim.is_empty():
				beklenen += 1
				if not (kopya.get("dogru") == false and kopya.get("kaynak") == yd and kopya.get("asil") == asil and kopya.get("bicim") == bicim):
					tutarli = false
	dene(tutarli, "Gerçek gecede her yeni duyan için kopya, zarın dediği gibi açılır")
	dene(beklenen > 0, "Örnek köyde en az bir bozulma olur")
	dene(ag.ag_kayitlari.has(asil) and bool(ag.ag_kayitlari[asil].dogru), "Asıl kayıt silinmez, doğru kalır")
	dene(o.dedikodu.kayitlar().all(func(k: Dictionary) -> bool: return not String(k.olay_id).contains("~")), "Kopya ikinci dedikodu kaydı açmaz")
	var satirlar := SoylentiKoprusu.defter_satirlari(o)
	var kalip_metni := false
	var bozuk: Dictionary = ag.veri_yapilandirma.bozulma_kaliplari
	for s in satirlar:
		for b in bozuk:
			if String(s.olay) == String(bozuk[b]).replace("{kaynak}", ag.veri_yapilandirma.bozulma_faili):
				kalip_metni = true
	dene(kalip_metni, "Defter bozuk kopyayı kendi biçim kalıbıyla yazar")

	var sayac := {}
	var bozulan := 0
	for i in 1000:
		var b: String = ag.bozulma_bicimi("olay_%d" % i, str(i % 37), i % 11)
		if not b.is_empty():
			bozulan += 1
			sayac[b] = int(sayac.get(b, 0)) + 1
	var oran := float(bozulan) / 1000.0
	dene(absf(oran - float(ag.veri_yapilandirma.bozulma_orani)) <= 0.05, "Bozulma oranı tablo ±%%5 (%f)" % oran)
	dene(sayac.size() == 3 and bozuk.size() == 3, "Üç biçim, üç kalıp")
	print("SÖYLENTİ BOZULMA: GEÇTİ" if hata == 0 else "SÖYLENTİ BOZULMA: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
