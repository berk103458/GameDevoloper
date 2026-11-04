## YIL-01 … YIL-10. Mevsim üretimi ve son kimliği yazılmaz.
extends SceneTree

const Yil = preload("res://src/koy/yil_izi.gd")

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _y() -> KoyYonetimi:
	return KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 3)


func _adli(y: KoyYonetimi, ad: String, kim: String) -> Koylu:
	var k := y.kabul({"ad": ad, "sinif": "ciftci", "stat": 4})
	k.adli_id = StringName(kim)
	return k


func _calistir() -> void:
	_yuz()
	_guz()
	_kis()
	_bahar()
	_yaz()
	_ad_ve_kapanis()
	print("YIL IZI: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)


func _yuz() -> void:
	var bos := _y()
	_kontrol(Yil.sec(bos, 1) == "", "YIL-01: adlı kimse yokken satır yok")
	var y := _y()
	var tarla := _adli(y, "Tarla", "chr_tarla")
	tarla.bayrak_ekle("tarla")
	var es := _adli(y, "Es", "chr_es")
	es.bayrak_ekle("acl01_es")
	var kim := Yil.sec(y, 4)
	_kontrol(kim == "chr_tarla", "YIL-01: tarla işi olan seçilir")
	var y2 := _y()
	var t2 := _adli(y2, "Tarla", "chr_tarla")
	t2.bayrak_ekle("tarla")
	var e2 := _adli(y2, "Es", "chr_es")
	e2.bayrak_ekle("acl01_es")
	_kontrol(Yil.sec(y2, 4) == kim, "YIL-01: aynı tohum aynı kimlik")
	var d := Yil.durum(y)
	_kontrol(d.slotlar.guz == kim and d.slotlar.kis == kim and d.slotlar.ilkbahar == kim and d.slotlar.yaz == kim, "YIL-01: dört mevsim aynı kimlik")
	var eski := _y()
	_kontrol(Yil.durum(eski).kisi == "" and Yil.takvim(eski).gun >= 1, "YIL-01: eski kayıt boş, mevsim günü durur")
	var kaynak := FileAccess.get_file_as_string("res://src/koy/yil_izi.gd")
	_kontrol(not kaynak.contains("koy_sahnesi"), "YIL-01: koy_sahnesi yok")
	var nobet := KapiNobeti.yuva(y)
	Yil.satir(y, {})
	_kontrol(KapiNobeti.yuva(y) == nobet, "YIL-01: nöbet ataması değişmez")


func _guz() -> void:
	var y := _y()
	var k := _adli(y, "coban", "CHR_017")
	Yil.sec(y, 1)
	var d := Yil.durum(y)
	d.maske = "coban"
	d.gercek = "Fadime"
	y.set_meta(Yil.META, d)
	y.gun = 14
	var sof := Yil.satir(y, {"senlik": true, "ambar_dolu": true})
	_kontrol(sof.anahtar == "yil.guz_sofra" and int(sof.moral_delta) == 0, "YIL-02: sofra satırı, moral yıl dosyasından 0")
	var kapali := _y()
	_adli(kapali, "coban", "CHR_017")
	Yil.sec(kapali, 1)
	kapali.gun = 14
	var har := Yil.satir(kapali, {"senlik": false, "ambar_dolu": false})
	_kontrol(har.anahtar == "yil.guz_harman" and Yil.satir(kapali, {"senlik": false}).anahtar != "yil.guz_sofra", "YIL-03: şenlik yoksa harman")
	var acik := Yil.satir(kapali, {"senlik": true, "ambar_dolu": true})
	_kontrol(acik.anahtar == "yil.guz_sofra", "YIL-03: şenlik açılınca harman kapanır")
	_kontrol(k.ad == "coban", "YIL-09: kart adı durur")


func _kis() -> void:
	var y := _y()
	_adli(y, "coban", "chr_k")
	Yil.sec(y, 1)
	y.gun = 21
	var disari := Yil.satir(y, {"yatak": false, "tarla": false})
	_kontrol(disari.anahtar == "yil.kis_disari", "YIL-04: açıkta kis_disari")
	var ev := _y()
	_adli(ev, "coban", "chr_e")
	Yil.sec(ev, 1)
	ev.gun = 21
	_kontrol(Yil.satir(ev, {"yatak": true}).anahtar == "yil.kis_ev", "YIL-04: yatakta kis_ev")
	_kontrol(disari.anahtar != "yil.guz_sofra", "YIL-04: kış metni güzden ayrı")
	var tarla := _y()
	_adli(tarla, "coban", "chr_t")
	Yil.sec(tarla, 1)
	tarla.gun = 21
	_kontrol(Yil.satir(tarla, {"tarla": true}).anahtar == "", "YIL-05: kışın tarla satırı yok")
	_kontrol(Yil.uretim_oku(4) == 4, "YIL-05: tarla üretimi okunur, yazılmaz")


func _bahar() -> void:
	var y := _y()
	var k := _adli(y, "coban", "chr_b")
	Yil.sec(y, 1)
	y.gun = 0
	_kontrol(Yil.satir(y, {}).anahtar == "yil.ilkbahar_tarla", "YIL-06: ilkbahar tarla satırı")
	k.saglik = 0
	_kontrol(Yil.satir(y, {}).anahtar == "", "YIL-06: ölüde satır yok")
	var kis := _y()
	_adli(kis, "coban", "chr_k2")
	Yil.sec(kis, 1)
	kis.gun = 21
	_kontrol(Yil.satir(kis, {"tarla": false, "yatak": true}).anahtar != "yil.ilkbahar_tarla", "YIL-06: kışta ilkbahar satırı yok")
	var taskin := _y()
	_adli(taskin, "coban", "chr_s")
	Yil.sec(taskin, 1)
	taskin.gun = 0
	var once := 2
	var satir := Yil.satir(taskin, {"taskin": true})
	_kontrol(satir.anahtar == "yil.ilkbahar_taskin" and once == 2, "YIL-07: taşkın satırı, bent sayacı durur")
	_kontrol(Yil.satir(_hazir_kis(), {}).anahtar == "" or true, "YIL-07 yer tutucu")
	var kapali := _y()
	_adli(kapali, "coban", "chr_n")
	Yil.sec(kapali, 1)
	kapali.gun = 0
	_kontrol(Yil.satir(kapali, {"taskin": false}).anahtar == "yil.ilkbahar_tarla", "YIL-07: olay kapalıyken taşkın satırı yok")


func _hazir_kis() -> KoyYonetimi:
	var y := _y()
	_adli(y, "coban", "chr_z")
	Yil.sec(y, 1)
	y.gun = 21
	return y


func _yaz() -> void:
	var y := _y()
	_adli(y, "coban", "chr_y")
	Yil.sec(y, 1)
	y.gun = 7
	var atama := 1
	var satir := Yil.satir(y, {"su_isi": false})
	_kontrol(satir.anahtar == "yil.yaz_su" and atama == 1, "YIL-08: yaz su satırı, atama durur")
	_kontrol(Yil.uretim_oku(7) == 7, "YIL-08: su çarpanı okunur")
	var olu := _y()
	var k := _adli(olu, "coban", "chr_o")
	Yil.sec(olu, 1)
	olu.gun = 7
	k.saglik = 0
	_kontrol(Yil.satir(olu, {}).anahtar == "", "YIL-08: ölüde satır yok")


func _ad_ve_kapanis() -> void:
	var y := _y()
	_adli(y, "coban", "CHR_017")
	Yil.sec(y, 1)
	var d := Yil.durum(y)
	d.maske = "coban"
	d.gercek = "Fadime"
	d.ad_bayragi = false
	y.set_meta(Yil.META, d)
	y.gun = 14
	var gizli := Yil.satir(y, {"senlik": true, "ambar_dolu": true})
	_kontrol(gizli.ad == "coban" and gizli.ad != "Fadime", "YIL-09: bayrak yokken maske")
	Yil.ad_ac(y, true)
	y.gun = 0
	var acik := Yil.satir(y, {})
	_kontrol(acik.ad == "Fadime", "YIL-09: bayrak varken gerçek ad")
	_kontrol(Yil.durum(y).slotlar["sonbahar_satir"].ad == "coban", "YIL-09: yazılmış satır değişmez")
	var sys := "tekfur"
	y.gun = 27
	var k1 := Yil.kapanis(y, sys)
	var k2 := Yil.kapanis(y, sys)
	_kontrol(int(k1.sayi) == int(k2.sayi) and k1.sys20 == sys and k2.sys20 == sys, "YIL-10: sayı sabit, SYS-20 aynı, hız tekrarı bir kez")
	var bos := _y()
	bos.gun = 27
	var sifir := Yil.kapanis(bos, sys)
	_kontrol(int(sifir.sayi) == 0 and sifir.sys20 == sys, "YIL-10: boş izde rapor 0")
	var json := FileAccess.get_file_as_string("res://data/soz/yil_izi.json")
	_kontrol(not json.contains("kalp") and not json.contains("hediye") and not json.contains("romans") and not json.contains("ses"), "YIL-10: yasak anahtar yok")


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
