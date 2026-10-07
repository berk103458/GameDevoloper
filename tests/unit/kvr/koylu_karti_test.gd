extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 73)
	var y := o.yonetim
	y.akce = 100
	for tur in ["gida", "odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 100)
	var k := y.kabul({"ad": "Usta", "sinif": "ciftci", "gizli": ["haydut", "casus"]})
	var b := _kur(y, "tarla")
	var h := _kur(y, "hizarhane")
	_kontrol(not KoyluKartiVerisi.uygun_turler(k).contains("koy.yapi."), "Bina önerileri CSV kilitliyken de okunur")
	var once := o.kaydet()
	var secenekler := KoyluKartiVerisi.secenekler(y, k)
	_kontrol(secenekler[0].id == b.id and secenekler[0].uyum == 1.6, "Gerçek çiftçiye tarla uyumu önce önerilir")
	var metin := KoyluKartiVerisi.ozet(y, k)
	_kontrol(not metin.contains("haydut") and not metin.contains("casus") and not metin.contains("DEBUG"), "Oyuncu kartı gizli bayrak ve eğilimleri açıklamaz")
	_kontrol(o.kaydet() == once, "Kart verisi salt okunur ve RNG değişmez")
	_kontrol(KoyluKartiVerisi.ata(y, k.id, b.id) and k.is_yeri == b.id, "Gerçek bina atama")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(geri.yonetim.koylu(k.id).is_yeri == b.id, "Atama gerçek kayıt/yüklemede korunur")
	var cocuk := y.kabul({"adli_id": "chr_006"})
	_kontrol(not KoyluKartiVerisi.ata(y, cocuk.id, h.id) and not KoyluKartiVerisi.ata(y, cocuk.id, KoyYonetimi.MUHAFIZ), "Kart çocuk ağır iş ve nöbet kurallarını aşamaz")
	var dolu := _kur(y, "tarla")
	while y.calisanlar(dolu.id).size() < y.katalog.slot(dolu.tur):
		var kisi := y.kabul({})
		y.ata(kisi.id, dolu.id)
	_kontrol(not KoyluKartiVerisi.ata(y, k.id, dolu.id) and k.is_yeri == b.id, "Dolu hedef başarısız; eski iş korunur")
	var insaat := _kur(y, "tarla")
	insaat.insa_kalan = 1
	_kontrol(not KoyluKartiVerisi.ata(y, k.id, insaat.id), "Hazır olmayan binaya atama yok")
	_kontrol(KoyluKartiVerisi.ata(y, k.id, KoyYonetimi.BOSTA) and k.is_yeri == KoyYonetimi.BOSTA, "Gerçek görevden çıkarma")
	_kontrol(not KoyluKartiVerisi.ata(y, 99999, b.id), "Ayrılmış kişi kartından atama yok")
	print("KÖYLÜ KARTI: GEÇTİ" if hata == 0 else "KÖYLÜ KARTI: KALDI")
	quit(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h)["olur"]:
				var b := y.bina(y.bina_kur(tur, h)["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
