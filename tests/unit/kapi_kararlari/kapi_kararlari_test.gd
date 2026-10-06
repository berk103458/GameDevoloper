## Kapı kararlarının köye etkisi (design/gdd/koy-yonetimi.md 1.3–1.4, 2, 3). Düz betik:
##   godot --headless --path . -s tests/unit/kapi_kararlari/kapi_kararlari_test.gd   (çıkış 0 = geçti)
extends SceneTree

var _hata := 0
var _k: Katalog


func _init() -> void:
	_k = Katalog.new()
	if _k.yukle() != Katalog.Durum.HAZIR:
		print("katalog yüklenemedi: ", _k.hatalar)
		quit(1)
		return
	var ka := _k.koy_ayarlari
	# Kabul: boştaki iş gücüne yazılır; köy nüfusu eşitlenir.
	var o := Oturum.new(_k, 11)
	var s := o.karar_ver(_gelen(5), &"kabul")
	var k := o.yonetim.koylu(s["koylu_id"])
	_esit("kabul köye yazıldı", k != null and k.is_yeri == KoyYonetimi.BOSTA, true)
	_esit("köy nüfusu eşit", o.koy.toplam(), 1)
	# Harç: yoksuldan akçe, sömürülmüş.
	var akce := o.akce
	s = o.karar_ver(_gelen(5), &"harc")
	k = o.yonetim.koylu(s["koylu_id"])
	_esit("harç akçesi", o.akce, akce + ka.harc_akce)
	_esit("harç sömürülmüş", k.bayrak_var("somurulmus"), true)
	# Rüşvet: kusurlu gelen asayiş riskini artırır; dürüstte artmaz.
	var risk := o.yonetim.asayis_riski
	o.karar_ver(_gelen(5), &"rusvet")
	_esit("dürüst rüşvet asayışa dokunmaz", o.yonetim.asayis_riski, risk)
	var supheli := _gelen(5)
	supheli.tehlikeli = true
	o.karar_ver(supheli, &"rusvet")
	_esit("şüpheli rüşvet asayiş riski", o.yonetim.asayis_riski, risk + ka.rusvet_asayis)
	# Ret: haksız +3, gerekçeli +1; haksız reddedilen usta Tekfur'a geçer.
	var h := o.yonetim.husumet.puan
	o.karar_ver(_gelen(8), &"ret")
	_esit("haksız ret +3", o.yonetim.husumet.puan, h + ka.husumet_haksiz)
	_esit("usta Tekfur'a geçti", "ciftci" in o.yonetim.husumet.tekfura_gecenler, true)
	var kotu := _gelen(5)
	kotu.tehlikeli = true
	o.karar_ver(kotu, &"ret")
	_esit("gerekçeli ret +1", o.yonetim.husumet.puan, h + ka.husumet_haksiz + ka.husumet_gerekceli)
	# Kışla: asker olarak alınır, muhafız yapılır.
	s = o.karar_ver(_gelen(5), &"kisla")
	k = o.yonetim.koylu(s["koylu_id"])
	_esit("kışla asker", k.sinif, &"asker")
	_esit("kışla muhafız", k.is_yeri, KoyYonetimi.MUHAFIZ)
	# Bayraklar: soru sorulunca açılır ve köylüye işlenir; sorulmayan gerçek gizli taşınır (koşullu kilit).
	var g := _gelen(5)
	g.sorular = [PackedStringArray(["s1", "c1"]), PackedStringArray(["s2", "c2"])]
	g.soru_bayraklari = PackedStringArray(["usta_ciftci", ""])
	g.gizli_bayraklar = PackedStringArray(["hasta"])
	g.soru_soruldu(1)
	_esit("bayraksız soru bayrak açmaz", g.acik_bayraklar.size(), 0)
	g.soru_soruldu(0)
	s = o.karar_ver(g, &"kabul")
	k = o.yonetim.koylu(s["koylu_id"])
	_esit("açılan bayrak işlendi", k.bayrak_var("usta_ciftci"), true)
	_esit("sorulmayan gerçek gizli", "hasta" in k.gizli_bayraklar and not k.bayrak_var("hasta"), true)
	# Hasta bayrağı açılmış birinin reddi gerekçelidir.
	var hasta := _gelen(5)
	hasta.acik_bayraklar = PackedStringArray(["hasta"])
	_esit("açık hasta: kusurlu", hasta.kusurlu(), true)
	# Kanıt sorusu birden çok gerçeği birden açar (virgüllü bayrak).
	var cok := _gelen(5)
	cok.sorular = [PackedStringArray(["s1", "c1"])]
	cok.soru_bayraklari = PackedStringArray(["sabotajci,hasta"])
	cok.soru_soruldu(0)
	_esit("virgüllü bayrak ikisini açar", cok.acik_bayraklar, PackedStringArray(["sabotajci", "hasta"]))
	# Sayfadan gizli ustalık: sorulmadıkça sınıftan usta bayrağı türetilmez; sorulursa o ustalık işlenir.
	var gizli_usta := _gelen(9)
	gizli_usta.gizli_bayraklar = PackedStringArray(["usta_demirci"])
	s = o.karar_ver(gizli_usta, &"kabul")
	k = o.yonetim.koylu(s["koylu_id"])
	_esit("gizli ustalık sınıftan türemez", k.bayrak_var("usta_ciftci"), false)
	_esit("gizli ustalık köye gizli", "usta_demirci" in k.gizli_bayraklar, true)
	var acik_usta := _gelen(9)
	acik_usta.gizli_bayraklar = PackedStringArray(["usta_demirci"])
	acik_usta.acik_bayraklar = PackedStringArray(["usta_demirci"])
	s = o.karar_ver(acik_usta, &"kabul")
	k = o.yonetim.koylu(s["koylu_id"])
	_esit("açılan ustalık tek", k.bayraklar, PackedStringArray(["usta_demirci"]))
	# Sayfa verisi: CHR_003'ün kanıt sorusu ustalığını açar.
	var sohbet := _k.sohbet(&"chr_003")
	_esit("CHR_003 kanıt bayrağı", sohbet != null and "usta_demirci" in sohbet.soru_bayraklari, true)
	# Gece: köy yönetimi çözer, gün ilerler; kayıt geri yüklenir.
	o.yonetim.kaynaklar.ekle("gida", 50)
	var r := o.gece_sonu()
	_esit("gün ilerledi", o.gun, 1)
	_esit("rapor", r.has("rapor"), true)
	var z := Oturum.kayittan(_k, JSON.parse_string(JSON.stringify(o.kaydet())))
	_esit("kayıt nüfus", z.yonetim.nufus(), o.yonetim.nufus())
	_esit("kayıt köy eşit", z.koy.toplam(), o.koy.toplam())
	print("KAPI KARARLARI TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _gelen(stat: int) -> Gelen:
	var g := Gelen.new()
	g.ad_anahtari = "deneme"
	g.sinif = &"ciftci"
	g.stat = stat
	g.secenekler = PackedStringArray(["kabul", "harc", "ret", "rusvet", "kisla"])
	return g


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
