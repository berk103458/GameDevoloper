## NBT-01: kapıda tek yuva, kayıt alanları, eşlik, işten alma ve kayıt/örtüşme.
extends SceneTree
var hata := 0
var kontrol := 0

func _initialize() -> void:
	call_deferred("_calistir")

func _y() -> KoyYonetimi:
	return KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 7)

func _kisi(y: KoyYonetimi, ad: String) -> Koylu:
	return y.kabul({"ad": ad, "sinif": "ciftci", "stat": 5})

func _calistir() -> void:
	_acilis()
	_tek_yuva()
	_eslik()
	_is_alma()
	_kayit()
	_yanlis()
	_devir()
	_firtina_uyku()
	_liste_rapor()
	_bos_ve_kapi()
	await process_frame
	print("KAPI NOBETI: %s (%d kontrol, %d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", kontrol, hata])
	quit(hata)

func _acilis() -> void:
	var y := _y()
	_kontrol(KapiNobeti.bos_mu(y) and KapiNobeti.yuva(y) == -1, "Açılışta yuva boş")
	_kontrol(KapiNobeti.direk_ad(y) == "", "Açılışta direk boş")
	_kontrol(KapiNobeti.ikinci_yuva(y) == 0, "Kapıda ikinci yuva yok")
	var d := KapiNobeti.durum(y)
	for alan in ["yuva", "devir", "gorulenler", "firtina", "uyku", "bos_direk"]:
		_kontrol(d.has(alan), "Tek kayıt sözlüğü alanı: " + alan)
	_kisi(y, "Bekçi Aday")
	_kontrol(KapiNobeti.bos_mu(y), "Köylü eklenmesi nöbetçiyi kendiliğinden yazmaz")

func _tek_yuva() -> void:
	var y := _y()
	var a := _kisi(y, "Ali")
	var b := _kisi(y, "Bekir")
	_kontrol(KapiNobeti.yaz(y, a.id), "Yaşayan köylü yuvaya yazılır")
	_kontrol(KapiNobeti.yuva(y) == a.id and KapiNobeti.direk_ad(y) == "Ali", "Direk adı yuva kimliğinin kayıtlı adıdır")
	_kontrol(KapiNobeti.ikinci_yuva(y) == 0, "Yazma ikinci yuva açmaz")
	_kontrol(not KapiNobeti.yaz(y, 9999), "Köy kaydında olmayan kimlik yazılmaz")
	var olu := _kisi(y, "Ölü")
	olu.saglik = 0
	_kontrol(not KapiNobeti.yaz(y, olu.id), "Ölü kimlik yuvaya yazılmaz")
	_kontrol(KapiNobeti.yaz(y, b.id) and KapiNobeti.yuva(y) == b.id, "İkinci seçim tek yuvayı devralır")

func _eslik() -> void:
	var y := _y()
	var a := _kisi(y, "Ali")
	var b := _kisi(y, "Bekir")
	_kontrol(KapiNobeti.eslik_isaretle(y, b.id), "Eşlik eden işaretlenir")
	_kontrol(KapiNobeti.bos_mu(y), "Eşlik işi yuvayı tek başına doldurmaz")
	KapiNobeti.yaz(y, a.id)
	_kontrol(KapiNobeti.yuva(y) == a.id, "Yuva yalnız yaz ile dolar")

func _is_alma() -> void:
	var y := _y()
	var k := _kisi(y, "Ali")
	k.is_yeri = 42
	KapiNobeti.yaz(y, k.id)
	_kontrol(k.is_yeri == KoyYonetimi.BOSTA, "Nöbetçi o gece kendi işinden alınır")
	_kontrol(int(KapiNobeti.durum(y).eski_is) == 42, "Eski iş yeri tek kayıtta saklanır")
	KapiNobeti.sabah(y)
	_kontrol(k.is_yeri == 42, "Sabah ölmediyse eski işine döner")
	_kontrol(KapiNobeti.yuva(y) == k.id, "Sabah yuva kendiliğinden boşalmaz")
	var y2 := _y()
	var m := _kisi(y2, "Veli")
	KapiNobeti.yaz(y2, m.id)
	y2.koylular.erase(m)
	KapiNobeti.sabah(y2)
	_kontrol(KapiNobeti.bos_mu(y2) and bool(KapiNobeti.durum(y2).bos_direk), "Ölen nöbetçinin kimliği sabah düşer")
	var y3 := _y()
	var n := _kisi(y3, "Nuri")
	KapiNobeti.yaz(y3, n.id)
	_kontrol(n.is_yeri != KoyYonetimi.MUHAFIZ, "Nöbet MUHAFIZ işareti açıp ikinci maaş doğurmaz")

func _kayit() -> void:
	var y := _y()
	var k := _kisi(y, "Ali")
	KapiNobeti.yaz(y, k.id)
	var v: Dictionary = JSON.parse_string(JSON.stringify(y.kaydet()))
	_kontrol(int(v.get("kapi_nobeti", {}).get("yuva", -1)) == k.id, "Kayıt kapi_nobeti alanını taşır")
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, v)
	_kontrol(KapiNobeti.yuva(geri) == k.id and KapiNobeti.direk_ad(geri) == "Ali", "Restore yuva kimliğini korur")
	v.erase("kapi_nobeti")
	var eski := KoyYonetimi.kayittan(y.a, y.katalog, v)
	_kontrol(KapiNobeti.bos_mu(eski) and KapiNobeti.ikinci_yuva(eski) == 0, "Eski kayıtta nöbet yok sayılır")
	_kontrol(KapiNobeti.oku({"yuva": "bozuk"}).yuva == -1, "Bozuk optional alan boş kayda iner")

func _yanlis() -> void:
	var y := _y()
	var cocuk := _kisi(y, "Cocuk")
	cocuk.yas_grubu = &"cocuk"
	var es := _kisi(y, "Es")
	es.bayrak_ekle("acl01_es")
	var usta := _kisi(y, "Usta")
	usta.stat = 8
	_kontrol(not KapiNobeti.yaz(y, cocuk.id) and not KapiNobeti.yaz(y, es.id) and not KapiNobeti.yaz(y, usta.id), "NBT-02: eş, çocuk ve usta yazılmaz")
	_kontrol(KapiNobeti.bos_mu(y), "NBT-02: yasak atama kayda 0 yazar")
	var kaynak_ustasi := y.kabul({"adli_id": "chr_013", "sinif": "ciftci", "stat": 5})
	_kontrol(CirakEgitimi.usta(kaynak_ustasi) and not kaynak_ustasi.usta_mi(), "YAP-29: kaynak ustası düşük statla da ustadır")
	var onceki_nobet := JSON.stringify(KapiNobeti.durum(y))
	_kontrol(not KapiNobeti.yaz(y, kaynak_ustasi.id), "YAP-29: kaynak ustası nöbete yazılmaz")
	_kontrol(JSON.stringify(KapiNobeti.durum(y)) == onceki_nobet and kaynak_ustasi.is_yeri == KoyYonetimi.BOSTA, "YAP-29: ret nöbet ve işi değiştirmez")
	var asker := _kisi(y, "Asker")
	asker.sinif = &"asker"
	var ciftci := _kisi(y, "Ciftci")
	KapiNobeti.yaz(y, asker.id)
	var gelenler := [{"id": "a"}, {"id": "b"}]
	KapiNobeti.gece(y, gelenler, {"firtina": false, "uyku": false, "sahne": "koy"})
	_kontrol(KapiNobeti.durum(y).gorulmedi.is_empty(), "NBT-02: yorgun olmayan askerde görülmedi 0")
	_kontrol(KapiNobeti.guvenlik(y) == KervanKorumasi.guvenlik(y), "NBT-02: HAR-15 duran fonksiyondan okunur")
	var y2 := _y()
	KapiNobeti.yaz(y2, ciftci.id)
	var once := gelenler.duplicate(true)
	KapiNobeti.gece(y2, gelenler, {"firtina": false, "uyku": false})
	_kontrol(KapiNobeti.durum(y2).gorulmedi.size() >= 1 and gelenler.size() == once.size(), "NBT-02: asker olmayanda bir gelen görülmedi, kuyruk durur")
	var yorgun := _kisi(y, "Yorgun")
	yorgun.sinif = &"asker"
	yorgun.yorgunluk = {"son_gece": y.gun - 1}
	var y3 := _y()
	y3.gun = 2
	yorgun = _kisi(y3, "Yorgun")
	yorgun.sinif = &"asker"
	yorgun.yorgunluk = {"son_gece": 1}
	KapiNobeti.yaz(y3, yorgun.id)
	KapiNobeti.gece(y3, [{"id": "c"}], {"firtina": false, "uyku": false})
	_kontrol(not KapiNobeti.durum(y3).gorulmedi.is_empty(), "NBT-02: yorgun asker yanlış sayılır")


func _devir() -> void:
	var y := _y()
	var a := _kisi(y, "Ali")
	var b := _kisi(y, "Bekir")
	KapiNobeti.yaz(y, a.id)
	var d1 := KapiNobeti.devir_yaz(y)
	_kontrol(d1.brakan == "Ali" and d1.alan == "Ali", "NBT-03: aynı kişi iki ad da odur")
	KapiNobeti.yaz(y, b.id)
	var d2 := KapiNobeti.devir_yaz(y)
	_kontrol(d2.brakan == "Ali" and d2.alan == "Bekir", "NBT-03: bırakan ve alan kayda uyar")
	var y2 := _y()
	var bos := KapiNobeti.devir_yaz(y2)
	_kontrol(bos.brakan == "" and bos.alan == "", "NBT-03: boş yuvada uydurma ad yok")
	var y3 := _y()
	var c := _kisi(y3, "Can")
	KapiNobeti.yaz(y3, c.id)
	KapiNobeti.devir_yaz(y3)
	KapiNobeti.devir_yaz(y3)
	KapiNobeti.devir_yaz(y3)
	_kontrol(int(c.yorgunluk.get("son_gece", -1)) == y3.gun, "NBT-03: hız üçken yorgunluk bir kez")
	var eski := {"yuva": c.id, "eski_is": -1}
	_kontrol(KapiNobeti.oku(eski).yuva == -1, "NBT-03: devirsiz eski kayıt nöbet sayılmaz")


func _firtina_uyku() -> void:
	var y := _y()
	var a := _kisi(y, "Asker")
	a.sinif = &"asker"
	KapiNobeti.yaz(y, a.id)
	KapiNobeti.gece(y, [{"id": "g1"}], {"firtina": false, "uyku": false})
	var sakin := KapiNobeti.rapor_satirlari(y)
	_kontrol(sakin[1].anahtar != "nobet.rapor.tipi", "NBT-04: fırtınasız doğru nöbetçide tipi satırı yok")
	KapiNobeti.gece(y, [{"id": "g1"}], {"firtina": true, "uyku": false})
	_kontrol(KapiNobeti.rapor_satirlari(y)[1].anahtar == "nobet.rapor.tipi", "NBT-04: fırtınada tipi satırı")
	var bos := _y()
	var b := _kisi(bos, "Asker")
	b.sinif = &"asker"
	KapiNobeti.yaz(bos, b.id)
	KapiNobeti.gece(bos, [], {"firtina": true, "uyku": false})
	_kontrol(KapiNobeti.rapor_satirlari(bos)[1].anahtar == "nobet.rapor.tipi_bos", "NBT-04: boş kuyrukta tipi ve kapı boş")
	var uyku := _y()
	var u := _kisi(uyku, "Asker")
	u.sinif = &"asker"
	KapiNobeti.yaz(uyku, u.id)
	KapiNobeti.gece(uyku, [{"id": "g2"}], {"firtina": false, "uyku": true})
	_kontrol(KapiNobeti.durum(uyku).model == "uyku" and KapiNobeti.rapor_satirlari(uyku)[1].anahtar == "nobet.rapor.uyudu", "NBT-05: uyku hali ve satır")
	KapiNobeti.gece(uyku, [{"id": "g3"}], {"firtina": false, "uyku": false})
	_kontrol(KapiNobeti.durum(uyku).model == "idle", "NBT-05: uyumadığı gece satır yok")


func _liste_rapor() -> void:
	var y := _y()
	var a := _kisi(y, "Asker")
	a.sinif = &"asker"
	KapiNobeti.yaz(y, a.id)
	var kabul := y.kabul_sayisi
	KapiNobeti.gece(y, [{"id": "1"}, {"id": "2"}, {"id": "3"}], {"firtina": false, "uyku": false, "sahne": "kapi"})
	var d := KapiNobeti.durum(y)
	_kontrol(d.gorulen_kimlikler.size() == 3, "NBT-06: kapı sahnesinde kaçırma yok")
	KapiNobeti.gece(y, [{"id": "1"}, {"id": "2"}, {"id": "3"}], {"firtina": false, "uyku": true, "sahne": "koy"})
	d = KapiNobeti.durum(y)
	_kontrol(d.gorulen_kimlikler.size() == 2, "NBT-06: üç gelişten biri düşünce listede 2")
	var replik := 0
	for gid in d.gorulen_kimlikler:
		if String(gid).find("replik") >= 0:
			replik += 1
	_kontrol(replik == 0, "NBT-06: listede replik anahtarı yok")
	_kontrol(y.kabul_sayisi == kabul, "NBT-06: görülen kişi kabul sayılmaz")
	_kontrol(KapiNobeti.rapor_satirlari(y, true).size() == 2, "NBT-07: açık kapıda iki satır")
	_kontrol(KapiNobeti.rapor_satirlari(y, false).is_empty(), "NBT-07: kapalı kapıda satır yok")


func _bos_ve_kapi() -> void:
	var y := _y()
	KapiNobeti.gece(y, [{"id": "1"}, {"id": "2"}, {"id": "3"}], {"kapi_acik": true, "sahne": "koy", "firtina": false, "uyku": false})
	_kontrol(KapiNobeti.durum(y).gorulen_kimlikler.is_empty() and KapiNobeti.durum(y).gorulmedi.size() == 3, "NBT-08: boş direkte hepsi görülmedi")
	var kapi := _y()
	KapiNobeti.gece(kapi, [{"id": "1"}], {"sahne": "kapi", "firtina": false, "uyku": false})
	_kontrol(KapiNobeti.durum(kapi).gorulmedi.is_empty(), "NBT-08: kapı sahnesinde boş direk kaçırmaz")
	var n := _kisi(y, "Nöbetçi")
	var once := KapiNobeti.yuva(y)
	KapiNobeti.yaz(y, n.id)
	KapiNobeti.kapiya_gir(y)
	_kontrol(KapiNobeti.replik_soyleyen(y) == 0 and bool(KapiNobeti.durum(y).kenarda), "NBT-09: replik söyleyen yuva kimliği değil")
	_kontrol(KapiNobeti.koye_don(y) == n.id and KapiNobeti.yuva(y) == n.id, "NBT-09: dönüşte aynı kimlik")
	_kontrol(once == KapiNobeti.YUVA_YOK, "NBT-09: önceki yuva boştu")
	KapiNobeti.oyuncu_nobet_yaz(y)
	_kontrol(not KapiNobeti.sorgu_acilir(y), "NBT-09: oyuncu nöbetinde sorgu açılmaz")


func _kontrol(olur: bool, mesaj: String) -> void:
	kontrol += 1
	if not olur:
		hata += 1
		push_error(mesaj)