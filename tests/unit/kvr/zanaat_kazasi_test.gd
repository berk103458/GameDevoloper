extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 41)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for tur in ["gida", "odun", "tas", "kereste", "demir", "alet"]: y.kaynaklar.ekle(tur, 100)
	var b := _kur(y, "demirhane")
	var k := y.kabul({"ad": "Ali", "sinif": "ciftci", "stat": 5})
	k.moral = 50
	y.ata(k.id, b.id)
	y._rng.seed = _tohum(false)
	var rapor := y.gece()
	_kontrol(k.zanaat_kazasi.get("tur") == "yanik" and ZanaatKazalari.durur(k) and k.saglik == 80, "Gerçek uyumsuz ocak kazası yanık/sağlık/duruş üretir")
	_kontrol(rapor["olaylar"].any(func(e: Dictionary) -> bool: return e["anahtar"].contains("ocakta yandı")), "Yanık gerçek gece raporunda")
	kat.koy_ayarlari = y.a.duplicate(true)
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	geri.yonetim.a = y.a.duplicate(true)
	geri.yonetim._ambar_kapasitesi()
	var demir := y.kaynaklar.miktar("demir")
	var kereste := y.kaynaklar.miktar("kereste")
	var ikinci := y.gece()
	geri.yonetim.gece()
	_kontrol(not ikinci["uretim"].has("alet") and y.kaynaklar.miktar("demir") == demir and y.kaynaklar.miktar("kereste") == kereste, "Sonraki gerçek gece üretim ve girdi durur")
	_kontrol(k.zanaat_kazasi == geri.yonetim.koylu(k.id).zanaat_kazasi and y._rng.state == geri.yonetim._rng.state, "Duruş/yanık JSON RNG replay")
	_kontrol(not ZanaatKazalari.durur(k) and k.zanaat_kazasi.tedavi and k.saglik == 80, "Duruş bir gece; tedavi ihtiyacı kaybolmaz")
	var klinik := _kur(y, "sifahane")
	var doktor := y.kabul({"ad": "Cerrah", "sinif": "esnaf", "stat": 7})
	doktor.zanaat_turu = ZanaatTuru.Tur.CERRAH
	doktor.moral = 50
	_kontrol(y.ata(doktor.id, klinik.id) and Sifahane.tedavi_kapasitesi(y) == 1, "Gerçek kurulabilir Şifahane ve sağlık çalışanı")
	y.isyan_kalan = 1
	_kontrol(Sifahane.tedavi_kapasitesi(y) == 0, "İsyan sırasında tedavi yok")
	y.isyan_kalan = -1
	y.kaynaklar.stok["gida"] = 1
	ZanaatKazalari.gece(y, [])
	_kontrol(k.zanaat_kazasi.tedavi and y.kaynaklar.miktar("gida") == 1, "İki erzak yoksa tedavi harcaması bölünmez")
	y.kaynaklar.stok["gida"] = 100
	y.bosalt(k.id)
	var gida := y.kaynaklar.miktar("gida")
	var tedavi := y.gece()
	_kontrol(k.zanaat_kazasi.is_empty() and k.saglik == 100 and not k.bayrak_var("agir_yarali"), "Gerçek gece Şifahane yanığı ve kazaya ait bayrağı iyileştirir")
	_kontrol(y.kaynaklar.miktar("gida") == gida - 2 - int(tedavi["tuketim"]["gida"]) - int(tedavi.ziyan.bozulma.get("gida", 0)) and tedavi["olaylar"].any(func(e: Dictionary) -> bool: return e["anahtar"].contains("Şifahane")), "Tedavi gerçek iki erzak ve raporu kullanır")
	# Alet kırma mevcut zarından gelir; ikincil kaza zarını güvenli kaçır.
	y.ata(k.id, b.id)
	k.moral = 50
	y._rng.seed = _tohum(true)
	var alet := y.kaynaklar.miktar("alet")
	y.gece()
	_kontrol(k.zanaat_kazasi.get("tur") == "alet" and ZanaatKazalari.durur(k) and y.kaynaklar.miktar("alet") <= alet, "Gerçek alet kırması acemiyi bir gece durdurur")
	var ilk := Koylu.kayittan({"id": 1})
	_kontrol(ilk.zanaat_kazasi.is_empty(), "Eski kayıt yeni kaza alanı olmadan açılır")
	for bozuk in [null, {}, {"tur": "yanik", "kalan": 1.5, "son_gece": 0, "tedavi": true}, {"tur": "alet", "kalan": 1, "son_gece": 0, "tedavi": true}]:
		_kontrol(ZanaatKazalari.oku(bozuk).is_empty(), "Bozuk zanaat kazası kaydı reddedilir")
	print("ZANAAT KAZASI: GEÇTİ" if hata == 0 else "ZANAAT KAZASI: KALDI")
	quit(hata)
func _tohum(alet: bool) -> int:
	var zar := RandomNumberGenerator.new()
	for n in range(1, 10000):
		zar.seed = n
		var a := zar.randf()
		var b := zar.randf()
		if (alet and a < 0.1 and b >= 0.08) or (not alet and a >= 0.1 and b < 0.08): return n
	return 1
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
