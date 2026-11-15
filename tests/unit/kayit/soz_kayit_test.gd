extends SceneTree
## Bölüm 31 söz kayıt adaptörü: KAY-07…10, 13…18, 25…28, 30, 36, 50, 51, 57, 58, 61…63, 70.

const GOC = preload("res://src/sistemler/kayit_gocu_soz.gd")
const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const GECMIS = preload("res://src/sistemler/muhafiz_gecmisi.gd")
const DIS_HAT = preload("res://src/sistemler/dis_hat_kapisi.gd")

var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	_guven_ve_itiraf(kat)
	_beyan_ve_tavan(kat)
	_soz_ve_yalan()
	_cekirdek()
	_denetim(kat)
	_motor_ve_sira()
	_es_ve_gecmis(kat)
	_sorgu_kaydi(kat)
	_eski_gorunum()
	_bayrak(kat)
	_dedikodu_tavani()
	_soy01_soylenti_kaynak_ve_dogruluk(kat)
	print("SÖZ KAYDI: %s" % ("GEÇTİ" if hata == 0 else "KALDI"))
	quit(hata)

func _guven_ve_itiraf(kat: Katalog) -> void:
	var o := Oturum.new(kat, 7007)
	var id: StringName = kat.karakterler()[0].id
	dene(int(KisiHafizasi.oku(o.kadro, id, -1, 3).guven) == 0, "KAY-13 eksik güven sıfır")
	dene(int(KisiHafizasi.oku(o.kadro, id, -1, 3).korku) == 3, "KAY-13 eksik korku başlangıç tansiyonu")
	dene(not KisiHafizasi.itiraf_acik(o.kadro, id), "KAY-13 alansız kayıtta itiraf kapalı")
	KisiHafizasi.guven_yaz(o.kadro, id, 4)
	KisiHafizasi.korku_yaz(o.kadro, id, 2)
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	var h := KisiHafizasi.oku(geri.kadro, id)
	dene(int(h.guven) == 4 and int(h.korku) == 2, "KAY-07 güven ve korku kaydet-yükle ile aynı")
	dene(KisiHafizasi.guven_yaz(o.kadro, id, 40) == 10, "KAY-14 güven 40 ise 10")

func _beyan_ve_tavan(kat: Katalog) -> void:
	var defter := BeyanDefteri.new()
	dene(defter.ekle("kisi", "b1", 1) and not defter.ekle("kisi", "b1", 2), "KAY-08 aynı beyan ikinci kez yazılmaz")
	dene(defter.gece_kapat("kisi") == 1, "KAY-08 gece kapanınca satır kişi altında")
	var uc: Array = [{"id": "a", "kisi": "k"}, {"id": "", "kisi": "k"}, {"id": "c", "kisi": "k"}]
	dene(defter.yukle(uc) and defter.satirlar().size() == 2, "KAY-62 boş kimlik düşer, iki satır kalır")
	var dolu := BeyanDefteri.new()
	var oldu := true
	for i in 41:
		oldu = oldu and (dolu.ekle("kisi", "satir_%d" % i, 1) == (i < 40))
	dene(oldu and dolu.satirlar().size() == 40, "KAY-50 41. beyan satırı düşer")

func _soz_ve_yalan() -> void:
	var soz := VerilenSoz.new()
	for i in 5:
		dene(soz.ekle("s%d" % i, "yusuf", 3 + i, "yarin_gel", false), "KAY-09 açık söz %d" % i)
	dene(not soz.ekle("s5", "yusuf", 9, "yarin_gel", false) and soz.acik_sayisi() == 5, "KAY-09 altıncı söz yazılmaz")
	var alti: Array = []
	for i in 6:
		alti.append({"id": "y%d" % i, "kisi": "yusuf", "gun": 4, "tur": "yarin_gel", "tutuldu": false, "sure": 4})
	dene(soz.yukle(alti) and soz.satirlar().size() == 6, "KAY-09 yükleme altıncı satırı düşürmez")
	dene(soz.yukle({"id": "sozluk"}) and soz.satirlar().is_empty(), "KAY-18 sözlük liste boş dizi olur")
	var yalan := YalanDenetimi.new()
	yalan.ekle("yusuf_bey", "yusuf", true)
	var kayit: Array = yalan.kaydet()
	dene(kayit.size() == 1 and kayit[0].dogru == false and kayit[0].aciga_cikti == true, "KAY-10 dogru false")
	yalan.yukle(kayit)
	yalan.ekle("yusuf_bey", "yusuf", false)
	dene(yalan.aciga_cikti("yusuf_bey"), "KAY-10 açığa çıkan yalan gizlenmez")

func _cekirdek() -> void:
	var secici := CekirdekSecici.new()
	secici.kur(11)
	secici.yukle({})
	dene(secici.tohum == 11 and secici.sec().is_empty(), "KAY-16 varyantsız yükleme tohumu yenilemez")
	secici.yukle({"varyant": "a", "tohum": 11})
	dene(secici.sec() == "a" and secici.tohum == 11, "KAY-16 kayıtlı varyant durur")

func _denetim(kat: Katalog) -> void:
	GOC.gunluk_temizle()
	var o := Oturum.new(kat, 7014)
	o.yonetim.kabul({"ad": "Köylü"})
	var nufus := o.yonetim.nufus()
	var veri: Dictionary = o.kaydet()
	var koy: Dictionary = veri.koy_yonetimi.duplicate(true)
	veri.soz.guven = 40
	veri.soz.sure = -3
	dene(GOC.soz_denetle(veri) and int(veri.soz.guven) == 10 and int(veri.soz.sure) == 0, "KAY-14 taşan sayı kıskaçlanır")
	dene(veri.koy_yonetimi == koy, "KAY-14 köy barları kıskaçlanmaz")
	var id := String(veri.kadro.keys()[0])
	var koy_sayisi: int = koy.koylular.size()
	veri.soz.hafiza = [{"id": "sahte_kisi", "ziyaret": 1}, {"id": id, "ziyaret": 2, "guven": 3}, {"id": id, "ziyaret": 9, "guven": 1}]
	dene(GOC.soz_denetle(veri), "KAY-15 sahte kimlik oyunu düşürmez")
	dene(veri.soz.hafiza.size() == 1 and int(veri.soz.hafiza[0].ziyaret) == 9, "KAY-61 büyük ziyaret kalır")
	dene(veri.koy_yonetimi.koylular.size() == koy_sayisi, "KAY-15 köylü sayısı kaydı durur")
	dene(o.yonetim.nufus() == nufus, "KAY-15 kaynak köylü sayısı aynı")
	var yarim: Dictionary = o.kaydet()
	var koy_n: int = yarim.koy_yonetimi.koylular.size()
	yarim.soz.kapi_kuyrugu = {"yarim": true, "ids": ["", "kirik"]}
	dene(GOC.soz_denetle(yarim) and yarim.soz.kapi_kuyrugu.yeniden == true, "KAY-25 yarım kuyruk yeniden kurulur")
	dene(yarim.koy_yonetimi.koylular.size() == koy_n, "KAY-25 yarım kuyruk köylüyü silmez")
	var bozuk: Dictionary = o.kaydet()
	bozuk.soz.guven = "yuksek"
	dene(not GOC.soz_denetle(bozuk), "KAY-17 dize göçü durdurur")
	var liste: Dictionary = {"soz": {"sozler": {"id": "yanlis"}}}
	dene(GOC.soz_denetle(liste) and liste.soz.sozler is Array and liste.soz.sozler.is_empty(), "KAY-18 göçte sözlük boş dizi")

func _motor_ve_sira() -> void:
	var motor := SozMotoru.new()
	motor.dugum_id = "1.1"
	motor.konular = ["yol"]
	motor.selam_okundu = true
	var yuklenen := motor.yukle(motor.kaydet(), ["1.1", "selam"])
	dene(yuklenen.dugum_id == "1.1" and not motor.selam_yeniden_okunur(), "KAY-26 selam yeniden okunmaz")
	var kopuk := motor.yukle({"dugum_id": "silinmis", "konular": ["yol"], "selam_okundu": true}, ["selam"])
	dene(kopuk.kisi_silindi == false and motor.dugum_id == "selam", "KAY-36 kopuk düğüm selama döner, kişi durur")
	var yollar := {"a": "res://a.tres", "b": "res://b.tres", "c": "res://c.tres"}
	dene(motor.gece_dosyalarini_ac(["a", "b"], yollar) == 2, "KAY-51 açılan dosya kuyruğu geçmez")
	dene(motor.gece_dosyalarini_ac(["a"], yollar) == 1, "KAY-51 katalogun geri kalanı açılmaz")

func _es_ve_gecmis(kat: Katalog) -> void:
	var o := Oturum.new(kat, 7028)
	ACILIS.kur(o)
	dene(GECMIS.sec(o, "eski_levent"), "KAY-28 geçmiş seçilir")
	var h: Dictionary = ACILIS.durum(o)
	var es := o.yonetim.koylu(int(h.es_id))
	es.sinif = &"esnaf"
	var veri: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	veri.surum = 2
	for alan in ["muhafiz_akce", "muhafiz_esyalari", "muhafiz_tecrubesi", "mevsim", "yeni_binalar"]:
		veri.erase(alan)
	var geri := Oturum.kayittan(kat, veri)
	dene(geri != null and GECMIS.kimlik(geri) == "eski_levent", "KAY-28 muhafızın geçmişi varsayılana çekilmez")
	var es_geri := geri.yonetim.koylu(int(h.es_id)) if geri != null else null
	dene(es_geri != null and es_geri.sinif == &"esnaf", "KAY-28 eşin mesleği göçte durur")

func _sorgu_kaydi(kat: Katalog) -> void:
	var yol := "user://kay30_%d.json" % OS.get_process_id()
	var kayit := GuvenliKayit.new(yol)
	kayit.sil()
	var o := Oturum.new(kat, 7030)
	dene(kayit.yaz(o.kaydet()), "KAY-30 ilk kayıt")
	var zaman := FileAccess.get_modified_time(kayit.yol)
	var bayt := FileAccess.get_file_as_bytes(kayit.yol)
	var motor := SozMotoru.new()
	motor.sorguyu_ac()
	dene(not kayit.yaz(o.kaydet()), "KAY-30 sorgu sırasında yazılmaz")
	dene(FileAccess.get_file_as_bytes(kayit.yol) == bayt and FileAccess.get_modified_time(kayit.yol) == zaman, "KAY-30 dosyanın saati ve baytı değişmez")
	motor.sorguyu_kapat()
	dene(kayit.yaz(o.kaydet()), "KAY-30 gece sonu ve menü yazabilir")
	kayit.sil()

func _eski_gorunum() -> void:
	var kayit := {"surum": 3, "soz": {"guven": 6, "hafiza": [{"id": "chr_001", "guven": 6, "ziyaret": 1}]}}
	var gorunum: Dictionary = GOC.eski_surum_gorunumu(kayit)
	dene(not gorunum.soz.has("guven") and not gorunum.soz.hafiza[0].has("guven"), "KAY-57 eski sürüm güveni okumaz")
	dene(int(kayit.soz.guven) == 6 and int(kayit.soz.hafiza[0].guven) == 6, "KAY-57 dosyadaki alan silinmez")

func _bayrak(kat: Katalog) -> void:
	var o := Oturum.new(kat, 7058)
	o.ayarlar.soz_alanlari_acik = false
	KisiHafizasi.guven_yaz(o.kadro, kat.karakterler()[0].id, 5)
	dene(not o.kaydet().has("soz"), "KAY-58 kapalı bayrakta güven alanı yazılmaz")
	o.ayarlar.soz_alanlari_acik = true
	dene(o.kaydet().has("soz"), "KAY-58 açık bayrak Söz alanlarını yazar")
	var id: StringName = kat.karakterler()[0].id
	o.kadro.durumlar[id]["Flag_Sir_Tamamen_Cozuldu"] = "evet"
	o.kadro.durumlar[id]["guven"] = 10
	dene(not KisiHafizasi.itiraf_acik(o.kadro, id), "KAY-63 evet değeri itirafı açmaz")

func _dedikodu_tavani() -> void:
	var d := Dedikodu.new()
	for i in 81:
		d.olay_kaydet("olay_%d" % i, "rusvet", 1, "tanik", 1)
	dene(d.kayitlar().size() == 80, "KAY-70 kayıtta 80 satır")
	var kimlikler: Array[String] = []
	for satir in d.kayitlar():
		kimlikler.append(String(satir.olay_id))
	dene(not kimlikler.has("olay_0") and kimlikler.has("olay_80"), "KAY-70 en eski satır düşer, 81. listeyi büyütmez")
	dene(not d.olay_kaydet("olay_0", "rusvet", 1, "tanik", 1).olur, "KAY-70 düşen yayılmamış olay geri gelmez")


func _soy01_soylenti_kaynak_ve_dogruluk(kat: Katalog) -> void:
	var o := Oturum.new(kat, 7071)
	var ag: RefCounted = SoylentiKoprusu.ag(o)
	ag.soylenti_ekle("dogru_olay", "rusvet", "koylu_1", true, {"gece": 2})
	ag.soylenti_ekle("yanlis_olay", "siddet", "koylu_2", false, {"gece": 2})
	dene(ag.kaynak_ve_dogruluk("dogru_olay") == {"kaynak": "koylu_1", "dogru": true}, "SOY-01 doğru olay kaynağı ve doğruluğu SoylentiAgi kaydında tutulur")
	dene(ag.kaynak_ve_dogruluk("yanlis_olay") == {"kaynak": "koylu_2", "dogru": false}, "SOY-01 yanlış söylenti dogru=false korunur")
	dene(DIS_HAT.soylenti_dogru_haber_var_mi(o, "dogru_olay") and not DIS_HAT.soylenti_dogru_haber_var_mi(o, "yanlis_olay"), "SOY-01/OMR-39 yalnız dogru=true söylentiyi okur")
	dene(ag.dogru_kayitlar().has("dogru_olay") and not ag.dogru_kayitlar().has("yanlis_olay"), "SOY-01 doğru kayıtlar süzgeci yanlış söylentiyi ayıklar")

	var kayit: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	var geri := Oturum.kayittan(kat, kayit)
	dene(geri != null and SoylentiKoprusu.ag(geri).kaynak_ve_dogruluk("dogru_olay") == {"kaynak": "koylu_1", "dogru": true}, "SOY-01 kaynak ve doğruluk kayıttan döner")
	dene(geri != null and SoylentiKoprusu.ag(geri).kaynak_ve_dogruluk("yanlis_olay").dogru == false, "SOY-01 dogru=false kayıttan korunur")

	var eski := kayit.duplicate(true)
	eski.erase("soylenti_agi")
	var eski_oturum := Oturum.kayittan(kat, eski)
	dene(eski_oturum != null and SoylentiKoprusu.ag(eski_oturum).kaynak_ve_dogruluk("dogru_olay") == {"kaynak": "", "dogru": true}, "SOY-01 eski kayıtta SoylentiAgi yokken kaynak='' ve dogru=true sayılır")
