extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 76)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for t in ["gida", "odun", "tas", "kereste", "alet"]: y.kaynaklar.ekle(t, 100)
	var orman := _kur(y, "odunluk")
	var hizar := _kur(y, "hizarhane")
	var oduncu := y.kabul({"ad": "Oduncu", "sinif": "oduncu", "stat": 5})
	var isci := y.kabul({"ad": "Hızarcı", "sinif": "oduncu", "stat": 5})
	for k in [oduncu, isci]: k.moral = 50
	_kontrol(y.ata(oduncu.id, orman.id) and y.ata(isci.id, hizar.id), "Gerçek katalogdan orman kampı ve hızar kurulup atanır")
	var odun := y.kaynaklar.miktar("odun")
	var kereste := y.kaynaklar.miktar("kereste")
	var r := y.gece()
	_kontrol(r.uretim.get("tomruk", 0) == 3 and y.kaynaklar.miktar("tomruk") == 1 and y.kaynaklar.miktar("odun") == odun + 3, "Gerçek gece: orman 3 tomruk, hızar 2 tüketip 3 yakacak üretir")
	_kontrol(y.recete_sec(hizar.id, "kereste"), "Eski kereste tarif kimliği geçerli")
	r = y.gece()
	_kontrol(r.uretim.get("kereste", 0) == 1 and y.kaynaklar.miktar("tomruk") == 2 and y.kaynaklar.miktar("kereste") == kereste + 1, "Gerçek gece: kalas yalnız tomruk işleyerek mevcut kereste stoğuna yazılır")
	y.bosalt(oduncu.id)
	y.kaynaklar.azalt("tomruk", 10000)
	var once := y.kaynaklar.kaydet()
	var u := {}
	var olaylar: Array[Dictionary] = []
	y._uret(u, olaylar)
	_kontrol(u.is_empty() and y.kaynaklar.kaydet() == once and hizar.bekliyor == "girdi", "Tomruk yoksa yakacak/kalas üretilemez; eski odun stoğu zinciri atlatmaz")
	_kontrol(y.recete_sec(hizar.id, "odun"), "Eski odun tarif kimliği geçerli")
	u.clear()
	y._uret(u, olaylar)
	_kontrol(u.is_empty(), "Yakacak tarifi de tomruksuz durur")
	var cocuk := y.kabul({"adli_id": "chr_006"})
	_kontrol(not y.ata(cocuk.id, orman.id), "Çocuk ormanda ağır işe atanamaz")
	y.kaynaklar.ekle("tomruk", 5)
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(geri.yonetim.kaynaklar.miktar("tomruk") == 5 and geri.yonetim.bina(orman.id).tur == "odunluk" and geri.yonetim.bina(hizar.id).recete == "odun", "Yeni kaynak/bina ve eski tarif JSON dönüşümünde korunur")
	var eski := Kaynaklar.kayittan({"stok": {"odun": 12, "kereste": 4}, "kapasite": 150})
	_kontrol(eski.miktar("tomruk") == 0 and eski.miktar("odun") == 12 and eski.miktar("kereste") == 4, "Eski kayıt yeni kaynağı sıfır varsayar, inşaat malzemesi korunur")
	_kontrol(OdunZinciri.ad("koy.kaynak.tomruk") == "Tomruk" and MeslekYapilari.ad("odunluk") == "Orman Kampı", "CSV değiştirmeden oyuncu etiketleri okunur")
	print("ODUN ZİNCİRİ: GEÇTİ" if hata == 0 else "ODUN ZİNCİRİ: KALDI")
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
