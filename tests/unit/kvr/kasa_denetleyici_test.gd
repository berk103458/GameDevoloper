extends SceneTree
var hata := 0
func _initialize() -> void:
	var k := Katalog.new()
	k.yukle()
	var o := Oturum.new(k, 99)
	# Rüşvet geliri önce gerçek karar API'sinden alınır.
	var g := o._adli_gelen(&"chr_001")
	o.ziyaret_basladi(g)
	o.karar_ver(g, &"rusvet")
	o.muhafiz_esyalari.append({"id": "test", "adet": 2, "deger": 7})
	var once := _kese_disinda(o)
	var kamu := o.koy_akce
	var kisi := o.muhafiz_akce
	_kontrol(KasaDenetleyici.degistir(o, "koy_akce", 125)["ok"] and o.koy_akce == 125 and o.muhafiz_akce == kisi, "Kamu bakiyesi yalnız kamu kasası")
	_kontrol(KasaDenetleyici.degistir(o, "muhafiz_akce", 33)["ok"] and o.koy_akce == 125 and o.muhafiz_akce == 33, "Kişisel bakiye yalnız kişisel kasa")
	_kontrol(KasaDenetleyici.degistir(o, "kese_ekle", 17)["ok"] and o.muhafiz_akce == 50 and o.muhafiz_esyalari.size() == 1, "Keseye ekleme akçe ve mevcut eşya")
	var geri := Oturum.kayittan(k, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(geri.muhafiz_akce == 50 and geri.koy_akce == 125 and geri.muhafiz_esyalari == o.muhafiz_esyalari, "Çift kasa ve kişisel eşya gerçek JSON kaydında")
	_kontrol(KasaDenetleyici.degistir(o, "kese_sifirla")["ok"] and o.muhafiz_akce == 0 and o.muhafiz_esyalari.is_empty() and o.koy_akce == 125, "Kese sıfırlama kamuya dokunmaz")
	_kontrol(_kese_disinda(o) == once and int(o.bayraklar[&"rusvet_sayisi"]) == 1, "Kaynaklar, karar geçmişi, kadro, gün ve tüm RNG korunur")
	var sabit := o.kaydet()
	for islem in ["yok", "koy_akce", "muhafiz_akce", "kese_ekle"]:
		_kontrol(not KasaDenetleyici.degistir(o, islem, -1)["ok"] and not KasaDenetleyici.degistir(o, islem, 1000001)["ok"], "Geçersiz işlem/miktar reddedilir")
	_kontrol(not KasaDenetleyici.degistir(o, "kese_ekle", 0)["ok"] and o.kaydet() == sabit, "Hatalı input yan etkisiz")
	o.muhafiz_akce = 9223372036854775807
	_kontrol(not KasaDenetleyici.degistir(o, "kese_ekle", 1)["ok"] and o.muhafiz_akce == 9223372036854775807, "64-bit toplam taşması reddedilir")
	o.yonetim.son = "halk_kirildi"
	_kontrol(not KasaDenetleyici.degistir(o, "koy_akce", kamu)["ok"] and not KasaDenetleyici.degistir(null, "kese_sifirla")["ok"], "Bitmiş/eksik oturum reddedilir")
	print("KASA DENETLEYİCİ: GEÇTİ" if hata == 0 else "KASA DENETLEYİCİ: KALDI")
	quit(hata)
func _kese_disinda(o: Oturum) -> Dictionary:
	var v := o.kaydet()
	v.erase("muhafiz_akce")
	v.erase("muhafiz_esyalari")
	v["koy_yonetimi"].erase("akce")
	return v
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
