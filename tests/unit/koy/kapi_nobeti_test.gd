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

func _kontrol(olur: bool, mesaj: String) -> void:
	kontrol += 1
	if not olur:
		hata += 1
		push_error(mesaj)