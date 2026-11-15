extends SceneTree

const USTA := preload("res://src/kapi/usta_gelisi.gd")
const BARINAK := preload("res://src/kapi/barinak_uyarisi.gd")
const ACILIS := preload("res://src/sistemler/acilis_senaryosu.gd")

var hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		hata += 1
		push_error("YAP-03 HATA: %s" % mesaj)


func _yeni_oturum(kat: Katalog, tohum: int) -> Oturum:
	var o := Oturum.new(kat, tohum)
	ACILIS.kur(o)
	o.koy_akce = 200
	o.muhafiz_akce = 55
	return o


func _init() -> void:
	TranslationServer.set_locale("tr")
	var kat := Katalog.new()
	kat.yukle()

	# 1. Veri doğrulama ve kalp alanı kuralı (ek şart: 1 hata verir)
	var hatalar := USTA.dogrula()
	_kontrol(hatalar.is_empty(), "data/ustalar.json temiz dogrulanmali: %s" % str(hatalar))
	var ustalar := USTA.ustalar()
	_kontrol(ustalar.size() >= 4, "En az 4 usta tanimli olmali")
	var sinan := ustalar[0].duplicate(true)
	sinan["kalp"] = 3
	var kalp_hatalari := USTA.dogrula({"ustalar": [sinan]})
	_kontrol(kalp_hatalari.size() == 1, "kalp alani 1 hata vermeli, gelen: %d (%s)" % [kalp_hatalari.size(), str(kalp_hatalari)])

	# 2. Ağırlık KAP-16 çekiciliği ve DNY olayını okur
	var o_cek := _yeni_oturum(kat, 9101)
	var u_sinan := ustalar[0]
	var w_dusuk := USTA.agirlik(o_cek, u_sinan)
	for k in o_cek.yonetim.koylular:
		k.refah = 90
	var b_ev := KoyBinasi.new()
	b_ev.id = o_cek.yonetim._sonraki_id
	o_cek.yonetim._sonraki_id += 1
	b_ev.tur = "kulube"
	b_ev.hucre = Vector2i(3, 3)
	o_cek.yonetim.binalar.append(b_ev)
	o_cek.yonetim.asayis_riski = 0
	var d_olay := DunyaZamani.oku(o_cek.dunya_zamani)
	(d_olay["isaretler"] as Array).append("mogol_ilerleyisi.etki")
	o_cek.dunya_zamani = d_olay
	var w_yuksek := USTA.agirlik(o_cek, u_sinan)
	_kontrol(w_yuksek > w_dusuk, "KAP-16 cekiciligi ve DNY olayi gelis agirligini artirmali (%f -> %f)" % [w_dusuk, w_yuksek])

	# 3. Tohumlu 28 gün koşusunda K2 ustası geliş sayısı >= 1 (ikinci zar açılmadan)
	for tohum in [101, 202, 777]:
		var o_run := _yeni_oturum(kat, tohum)
		var k2_gelen := 0
		for g in 28:
			o_run.yonetim.gun = g
			var kuyruk := o_run.gece_kuyrugu()
			for gelen in kuyruk:
				if USTA.ilgilenir(gelen):
					var u: Dictionary = gelen.get_meta(USTA.USTA_META, {})
					if int(u.get("kademe", 0)) >= 2:
						k2_gelen += 1
					# Çeşitlilik için ilk gelenlerden birini kabul veya ret edelim
					if k2_gelen == 1:
						o_run.karar_ver(gelen, &"ret")
			o_run.yonetim.kaynaklar.stok["gida"] = maxi(100, o_run.yonetim.kaynaklar.miktar("gida"))
			o_run.yonetim.akce = maxi(200, o_run.yonetim.akce)
		_kontrol(k2_gelen >= 1, "Tohum %d 28 gun kosusunda en az 1 K2 ustasi gelmeli (gelen: %d)" % [tohum, k2_gelen])

	# 4. Pazarlık 3 başlık + kamu kasasından düşüş + muhafız kesesi dokunulmazlığı + ACL-05 yatak uyarısı
	var o_paz := _yeni_oturum(kat, 4242)
	var g_sinan := USTA.gelen_olustur(o_paz, u_sinan)
	_kontrol(g_sinan != null and g_sinan.sorular.size() == 3, "Usta pazarligi 3 soru baslikli olmali")
	_kontrol(USTA.kisi_sayisi(g_sinan) == 3, "Sinan Kalfa ve ailesi 3 yatak istemeli")
	# Açılış kulübesi 2 kişilik ve dolu (muhafız + eş) -> yatak dolu, ACL-05 uyarısı görünmeli
	_kontrol(not BARINAK.yeter_mi(o_paz.yonetim, USTA.kisi_sayisi(g_sinan)), "Baslangic kulubesinde 3 yeni kisiye yatak yetersiz olmali")
	var alt_metin := USTA.karar_alt_yazi(o_paz, g_sinan, "kabul")
	_kontrol(alt_metin.contains(TranslationServer.translate(BARINAK.UYARI)), "Yatak doluyken karar alt yazisi ACL-05 uyarisi gostermeli")

	var koy_once := o_paz.koy_akce
	var muhafiz_once := o_paz.muhafiz_akce
	var ucret := int((u_sinan["pazarlik"] as Dictionary).get("ucret_koy_akce", 0))
	var sonuc_kabul := o_paz.karar_ver(g_sinan, &"kabul")
	_kontrol(not bool(sonuc_kabul.get("engellendi", true)) and bool(sonuc_kabul.get("kaldi", false)), "Yatak dolu olsa da usta kabul edilebilmeli")
	_kontrol(o_paz.koy_akce == koy_once - ucret, "Ucret kamu kasasindan dusmeli (%d -> %d)" % [koy_once, o_paz.koy_akce])
	_kontrol(o_paz.muhafiz_akce == muhafiz_once, "Kabul ucreti muhafiz_akce'yi degistirmemeli (%d == %d)" % [o_paz.muhafiz_akce, muhafiz_once])
	_kontrol(int(sonuc_kabul.get("kabul_edilen", 0)) == 3, "Usta ve 2 aile uyesi birlikte kabul edilmeli")
	_kontrol(BARINAK.acikta(o_paz.yonetim) >= 1, "Yatak yetersizse fazla kalanlar acikta uyumali (acikta=%d)" % BARINAK.acikta(o_paz.yonetim))
	_kontrol(int(sonuc_kabul.get("bilgi_deltasi", 0)) == YapiKilidi.bilgi_oku(u_sinan["yapi_bilgisi"]).size() and int(sonuc_kabul.get("bilgi_deltasi", 0)) > 0, "Ilk ziyarette yapi bilgisi acilmali (delta=%d)" % int(sonuc_kabul.get("bilgi_deltasi", -1)))
	_kontrol(YapiKilidi.durum(o_paz.yonetim, "tas_ocagi").acik, "Ilk kabul sonrasi tas_ocagi bilgisi acik olmali")

	# Tam dolu yatak senaryosu: bos yatak = 0 iken gelen ustanin tum grubu acikta kalir ama kabul edilir
	var o_dolu := _yeni_oturum(kat, 4243)
	while BARINAK.yeter_mi(o_dolu.yonetim, 1):
		o_dolu.yonetim.kabul({"ad": "Dolgu Koylusu", "sinif": &"ciftci"})
		o_dolu.yonetim._barindir()
	var g_dolu := USTA.gelen_olustur(o_dolu, u_sinan)
	_kontrol(USTA.karar_alt_yazi(o_dolu, g_dolu, "kabul").contains(TranslationServer.translate(BARINAK.UYARI)), "0 bos yatakta ACL-05 uyarisi gosterilmeli")
	var dolu_kabul := o_dolu.karar_ver(g_dolu, &"kabul")
	_kontrol(bool(dolu_kabul.get("kaldi", false)) and BARINAK.acikta(o_dolu.yonetim) == 3, "Yatak tam doluyken kabulde 3 kisi acikta kalmali (acikta=%d)" % BARINAK.acikta(o_dolu.yonetim))

	# 5. Ek şart: aynı usta ikinci ziyarette bilgi deltası sıfırdır (kayıt sonrası dahil)
	var kayit: Dictionary = JSON.parse_string(JSON.stringify(o_paz.kaydet()))
	var o_geri := Oturum.kayittan(kat, kayit)
	_kontrol(o_geri != null, "Usta durumu JSON kayit/yukleme ile korunmali")
	if o_geri != null:
		# İlk ustanın köyden ayrılması durumunda bile ikinci ziyarette bilgi deltası 0 kalmalı
		o_geri.yonetim.koylular = o_geri.yonetim.koylular.filter(func(k: Koylu) -> bool: return k.adli_id != &"usta_sinan_kalfa")
		o_geri.yonetim.gun = 15
		var g_ikinci := USTA.gelen_olustur(o_geri, u_sinan)
		var onceki_akce := o_geri.koy_akce
		var onceki_muhafiz := o_geri.muhafiz_akce
		var sonuc_2 := o_geri.karar_ver(g_ikinci, &"kabul")
		_kontrol(bool(sonuc_2.get("ikinci_ziyaret", false)), "Ayni ustanin ikinci ziyareti isaretlenmeli")
		_kontrol(int(sonuc_2.get("bilgi_deltasi", -1)) == 0, "Ayni usta ikinci ziyarette bilgi deltasi 0 olmali (delta=%d)" % int(sonuc_2.get("bilgi_deltasi", -1)))
		_kontrol(o_geri.koy_akce == onceki_akce - ucret and o_geri.muhafiz_akce == onceki_muhafiz, "Ikinci ziyarette de yalniz kamu kasasi dusmeli")

	# 6. Reddedilen usta bilgi açmaz ve aynı gün yeniden kuyruğa eklenmez
	var o_ret := _yeni_oturum(kat, 5151)
	o_ret.yonetim.gun = 10
	var g_mihali := USTA.gelen_olustur(o_ret, ustalar[1])
	var ret_once_akce := o_ret.koy_akce
	var ret_once_muhafiz := o_ret.muhafiz_akce
	var sonuc_ret := o_ret.karar_ver(g_mihali, &"ret")
	_kontrol(not bool(sonuc_ret.get("kaldi", true)) and int(sonuc_ret.get("bilgi_deltasi", -1)) == 0, "Reddedilen usta bilgi acmamali")
	_kontrol(not YapiKilidi.durum(o_ret.yonetim, "degirmen").acik, "Ret sonrasi degirmen bilgisi kapali kalmali")
	_kontrol(o_ret.koy_akce == ret_once_akce and o_ret.muhafiz_akce == ret_once_muhafiz, "Ret sirasinda kasalara dokunulmamali")
	var ayni_gun_kuyruk: Array[Gelen] = [o_ret._figur_gelen()]
	USTA.ekle(o_ret, ayni_gun_kuyruk)
	for g_k in ayni_gun_kuyruk:
		if USTA.ilgilenir(g_k):
			_kontrol(String(g_k.id) != "usta_mihali_degirmenci", "Reddedilen usta ayni gun yeniden kuyruga eklenmemeli")
	var tam_kuyruk := o_ret.gece_kuyrugu()
	for g_k2 in tam_kuyruk:
		if USTA.ilgilenir(g_k2):
			_kontrol(String(g_k2.id) != "usta_mihali_degirmenci", "gece_kuyrugu ayni gun reddedilen ustayi yeniden eklememeli")

	print("USTA GELISI (YAP-03): GEÇTİ" if hata == 0 else "USTA GELISI (YAP-03): KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
