extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 110)
	var y := o.yonetim
	y.akce = 100
	var b := _kur(y)
	var k := y.kabul({"ad": "Kamu çiftçisi", "stat": 5})
	if b != null: y.ata(k.id, b.id)
	o.muhafiz_akce = 77
	o.koy_akce = -10
	_kontrol(y.akce == -10, "Kamu açığı gerçek kamu erişimcisinde korunur")
	for i in 2: y.gece()
	_kontrol(y.iflas_durumu.eksi_gece == 2 and y.binalar.size() == 1, "İlk iki eksi gece kamu varlığına el koymaz")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	var odun_once := y.kaynaklar.miktar("odun")
	var r := y.gece()
	_kontrol(y.iflas_durumu.el_konuldu and y.binalar.is_empty() and k.is_yeri == KoyYonetimi.BOSTA, "Üçüncü gerçek eksi gece tefeci kamu yapısına el koyar; çalışanı boşa çıkarır")
	_kontrol(y.kaynaklar.miktar("odun") == odun_once and y.akce == -10 and o.muhafiz_akce == 77, "El koyma yıkım iadesi/borç silme/kişisel keseye el koyma üretmez")
	_kontrol(r.olaylar.any(func(e: Dictionary) -> bool: return e.get("anahtar", "") == "koy.olay.iflas"), "Tefeci baskını gerçek gece raporundadır")
	var restore_rapor := geri.yonetim.gece()
	var kaynak_kayit := y.kaydet()
	var restore_kayit := geri.yonetim.kaydet()
	_kontrol(restore_rapor == r and restore_kayit == kaynak_kayit, "Restore üçüncü gece aynı el koyma sonucunu üretir")
	y.gun -= 1
	var once := y.kaydet()
	var olaylar: Array[Dictionary] = []
	IflasYoneticisi.gece(y, olaylar)
	_kontrol(y.kaydet() == once and olaylar.is_empty(), "Aynı gece kontrolü tekrar el koymaz")
	y.gun += 1
	y.akce = 0
	y.gece()
	_kontrol(y.iflas_durumu.eksi_gece == 0 and not y.iflas_durumu.el_konuldu, "Sıfır veya pozitif kamu açığı seriyi sıfırlar")
	var eski := y.kaydet()
	eski.erase("iflas")
	_kontrol(KoyYonetimi.kayittan(y.a, y.katalog, eski).iflas_durumu.eksi_gece == 0, "Eski kayda uydurma iflas geçmişi yazılmaz")
	_kontrol(not y.izgara.dolu.values().has(b.id) and y._artik.is_empty(), "El konulan yapı ızgaradan ve kesirli üretim artıklarından da çıkar")
	var stok_o := Oturum.new(kat, 112)
	var stok_y := stok_o.yonetim
	stok_o.koy_akce = -20
	stok_o.muhafiz_akce = 9
	for i in 3: stok_y.gece()
	_kontrol(stok_y.kaynaklar.miktar("kereste") == 0 and stok_o.muhafiz_akce == 9, "Yapısız köyde gerçek kamu stoğuna el koyulur; özel kese korunur")
	var stok_once := stok_y.kaynaklar.stok.duplicate()
	var sonraki := stok_y.gece()
	stok_once["gida"] -= int(sonraki.ziyan.bozulma.get("gida", 0))
	_kontrol(stok_y.kaynaklar.stok == stok_once and not sonraki.olaylar.any(func(e: Dictionary) -> bool: return e.get("anahtar") == "koy.olay.iflas"), "Aynı kesintisiz borç serisi ikinci baskın üretmez")
	for bozuk in [{"eksi_gece": 2.5, "son_gece": -4, "el_konuldu": "evet"}, [3], null]:
		_kontrol(IflasYoneticisi.oku(bozuk).eksi_gece == 0 and IflasYoneticisi.oku(bozuk).son_gece == -1, "Bozuk iflas geçmişi güvenli varsayılana döner")
	var sabit := stok_y.kaydet()
	IflasYoneticisi.tip(stok_y)
	_kontrol(stok_y.kaydet() == sabit, "HUD iflas gözlemi model/RNG değiştirmez")
	print("İFLAS YÖNETİMİ: GEÇTİ" if hata == 0 else "İFLAS YÖNETİMİ: KALDI")
	quit(hata)
func _kur(y: KoyYonetimi) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim("tarla", h)["olur"]:
				var b := y.bina(y.bina_kur("tarla", h)["id"])
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
