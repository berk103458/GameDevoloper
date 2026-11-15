## KAP-18: savaş olayı sonrası yetim kafilesi, hane/eş emaneti, ACL-05 açıkta kalma ve 28. günde genç geçişi.
extends SceneTree

const BarinakUyarisi := preload("res://src/kapi/barinak_uyarisi.gd")
var hata := 0


func dene(kosul: bool, mesaj: String) -> void:
	if not kosul:
		hata += 1
		push_error(mesaj)


func _bina_ekle(y: KoyYonetimi, tur: String, hucre: Vector2i) -> KoyBinasi:
	var b := KoyBinasi.new()
	b.id = y.binalar.size() + 10
	b.tur = tur
	b.hucre = hucre
	b.insa_kalan = 0
	y.binalar.append(b)
	return b


func _kafile_bul(kuyruk: Array[Gelen]) -> Gelen:
	for g in kuyruk:
		if YetimBakimi.ilgilenir(g):
			return g
	return null


func _initialize() -> void:
	TranslationServer.set_locale("tr")
	var kat := Katalog.new()
	kat.yukle()

	# 1. Savaş olayı yokken 28 günde 0 geliş.
	var o1 := Oturum.new(kat, 1801)
	var gelis := 0
	for i in range(28):
		o1.gun = i
		o1.yonetim.gun = i
		if _kafile_bul(o1.gece_kuyrugu()) != null:
			gelis += 1
	dene(gelis == 0, "Savaş olayı yoksa 28 günde 0 geliş olmalı, gelen=%d" % gelis)

	# 2. DNY-01 savaş olayı sonrası geliş + mevcut hane emaneti + hane dağılınca açıkta kalma (silinmeme).
	var o2 := Oturum.new(kat, 1802)
	o2.yonetim.kaynaklar.ekle("gida", 500)
	o2.yonetim.kaynaklar.ekle("su", 500)
	var ev := _bina_ekle(o2.yonetim, "kulube", Vector2i(2, 2))
	var ev2 := _bina_ekle(o2.yonetim, "kulube", Vector2i(4, 2))
	var demirhane := _bina_ekle(o2.yonetim, "demirhane", Vector2i(6, 2))
	var reis := o2.yonetim.kabul({"ad": "Hanebası", "sinif": "ciftci", "stat": 6})
	reis.hane_id = reis.id
	reis.ev = ev.id
	var usta := o2.yonetim.kabul({"ad": "Usta", "sinif": "esnaf", "stat": 8})
	usta.ev = ev2.id
	o2.yonetim.ata(usta.id, demirhane.id)
	o2.gun = 30
	o2.yonetim.gun = 30
	DunyaZamani.gece(o2, {"gun": 30})
	var k_list := o2.gece_kuyrugu()
	var g := _kafile_bul(k_list)
	dene(g != null, "Savaş olayı sonrası yetim kafilesi kapıya gelmeli")
	if g != null:
		dene(g.aile.size() == 3 and g.aile[0].get("yas_grubu") == "cocuk", "Kafile KAP-17 çocuk şemasında 3 çocuk olmalı")
		var r := o2.karar_ver(g, &"kabul")
		dene(r.get("kaldi", false) and int(r.get("kabul_edilen", 0)) == 3, "Yetim kafilesi kabul edilmeli")
		var elif_k: Koylu = null
		for k in o2.yonetim.koylular:
			if k.bayrak_var(YetimBakimi.YETIM_BAYRAK):
				elif_k = k
				break
		dene(elif_k != null and elif_k.hane_id == reis.hane_id and elif_k.ev >= 0, "Çocuk mevcut haneye emanet edilmeli")
		dene(not o2.yonetim.ata(elif_k.id, demirhane.id) and elif_k.is_yeri == KoyYonetimi.BOSTA and int(elif_k.egitim.get("gun", 0)) == 0, "Çocuk çalışmaz ve atanmaz")
		dene(not KoyluKartiVerisi.cirak_atamasi(o2.yonetim, elif_k).acik, "28. gün dolmadan çırak düğmesi kapalı kalır")

		# Hane sonradan dağılırsa çocuk silinmez, açıkta durumuna düşer.
		o2.yonetim.koylular.erase(reis)
		var gecici_olaylar: Array[Dictionary] = []
		YetimBakimi.gece(o2.yonetim, gecici_olaylar)
		dene(elif_k in o2.yonetim.koylular and elif_k.ev == -1 and BarinakUyarisi.acikta(o2.yonetim) > 0, "Hane dağılınca çocuk silinmeden açıkta kalır")

		# 3. 27. günde hâlâ çocuk; 28. günde yaş grubu gence döner ve çırak düğmesi açılır.
		o2.yonetim.gun = elif_k.giris_gunu + 27
		gecici_olaylar.clear()
		YetimBakimi.gece(o2.yonetim, gecici_olaylar)
		dene(elif_k.yas_grubu == &"cocuk" and elif_k.is_yeri == KoyYonetimi.BOSTA and int(KoyluGelisimYoneticisi.durum(elif_k).xp) == 0, "27. günde hâlâ çocuk ve çalışmamış")
		o2.yonetim.gun = elif_k.giris_gunu + 28
		gecici_olaylar.clear()
		YetimBakimi.gece(o2.yonetim, gecici_olaylar)
		dene(elif_k.yas_grubu == &"genc", "28. günde yaş grubu gence dönmeli")
		var cirak := KoyluKartiVerisi.cirak_atamasi(o2.yonetim, elif_k)
		dene(cirak.acik and int(cirak.hedef) == demirhane.id and KoyluKartiVerisi.ata(o2.yonetim, elif_k.id, int(cirak.hedef)), "28. günde çırak düğmesi açılmalı ve çırak atanabilmeli")

		# 4. Kayıt / yükleme tamamlanmış savaş kafilesini yeniden tetiklemez.
		var kayit: Variant = JSON.parse_string(JSON.stringify(o2.kaydet()))
		var geri := Oturum.kayittan(kat, kayit)
		dene(geri != null and _kafile_bul(geri.gece_kuyrugu()) == null, "Tamamlanmış kafile yüklemede yeniden tetiklenmez")

	# 5. Eş hayatta ise y.hane'ye emanet (en çok 2) ve barınak/hane yoksa ACL-05 uyarısı ile açıkta kalma.
	var o3 := Oturum.new(kat, 1803)
	var ev_es := _bina_ekle(o3.yonetim, "kulube", Vector2i(2, 2))
	o3.yonetim.hane.ev_id = ev_es.id
	o3.yonetim.hane.es_hayatta = true
	o3.bayraklar[&"mogol_ilerleyisi_etki"] = true
	var g3 := _kafile_bul(o3.gece_kuyrugu())
	dene(g3 != null, "Bayrakla savaş sonrası kafile gelmeli")
	if g3 != null:
		var r3 := o3.karar_ver(g3, &"kabul")
		dene(int(r3.get("es", 0)) == 2 and int(r3.get("acikta", 0)) == 1 and o3.yonetim.koylular.size() == 3, "Hane yoksa eş 2 yetimi alır, 3. açıkta kalır ve hiçbiri silinmez")

	var o4 := Oturum.new(kat, 1804)
	o4.yonetim.hane.es_hayatta = false
	o4.bayraklar[&"mogol_ilerleyisi_etki"] = true
	var g4 := _kafile_bul(o4.gece_kuyrugu())
	if g4 != null:
		var r4 := o4.karar_ver(g4, &"kabul")
		dene(int(r4.get("acikta", 0)) == 3 and not String(r4.get("barinak_uyari", "")).is_empty() and o4.yonetim.koylular.size() == 3, "Hane ve barınak yoksa ACL-05 uyarısı çıkar ve çocuklar açıkta kalır, silinmez")

	print("YETIM BAKIMI TESTI: GEÇTİ" if hata == 0 else "YETIM BAKIMI TESTI: KALDI (%d hata)" % hata)
	quit(hata)
