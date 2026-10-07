extends SceneTree
var hata := 0
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 35)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar.kapasite = 10000
	y.akce = 1000
	for t in ["odun", "tas", "alet", "gida", "kereste"]: y.kaynaklar.ekle(t, 100)
	var kisla := _kur(y, "muhafiz_kislasi")
	_kontrol(kisla != null, "Gerçek kışla kurulabilir")
	if kisla == null:
		quit(1)
		return
	var k := y.kabul({"ad": "Nöbetçi", "sinif": "asker", "stat": 5})
	k.moral = 50
	var onizleme_once := y.kaydet()
	var onizleme := AtamaOnizlemesi.oku(y, k.id, kisla.id)
	_kontrol(onizleme.yesil and onizleme.fark.nobet == 1 and y.kaydet() == onizleme_once, "Yeni kışla ataması gerçek etkin nöbet artışını salt okunur gösterir")
	_kontrol(y.ata(k.id, kisla.id) and y.muhafiz_sayisi() == 1 and y.etkin_muhafiz_sayisi() == 1, "Kışla çalışanı maaş ve gerçek savunma nöbetçisidir")
	var olaylar: Array[Dictionary] = []
	var once := y.akce
	var rng_once := y._rng.state
	y._akce(olaylar)
	_kontrol(once - y.akce == 1 and y._rng.state == rng_once, "Ödenen gece kişi başına bir kamu akçesi; rüşvet zarı yok")
	y.gun += 1
	y.akce = 0
	o.muhafiz_akce = 37
	MuhafizMaasi.AYAR = MuhafizMaasi.AYAR.duplicate(true)
	MuhafizMaasi.AYAR.rusvet_riski = 1.0
	var asayis_once := y.asayis_riski
	y._akce(olaylar)
	var durum: Dictionary = y.maas_durumu[str(k.id)]
	_kontrol(y.muhafiz_sayisi() == 0 and y.etkin_muhafiz_sayisi() == 0 and y.asayis_riski > asayis_once, "Ödenmeyen nöbetçi bırakır; gerçek güvenlik kaybı oluşur")
	_kontrol(durum.borc == 1 and durum.rusvet_akce == 2 and y.akce == 0 and o.muhafiz_akce == 37, "Ödenmeyen gece borç ve gizli rüşvet kaydı; kamu kasasına para üretilmez")
	var borclu_onizleme := AtamaOnizlemesi.oku(y, k.id, kisla.id)
	_kontrol(not borclu_onizleme.yesil and borclu_onizleme.fark.nobet == 0, "Borçlu nöbetçi önizlemesi bedelsiz savunma vaat etmez")
	_kontrol(y.ata(k.id, kisla.id) and y.etkin_muhafiz_sayisi() == 0, "Yeniden atama maaş borcunun savunma engelini atlatmaz")
	y.bosalt(k.id)
	var tekrar := y.kaydet()
	y._akce(olaylar)
	_kontrol(y.kaydet() == tekrar, "Görevi bırakmış kişi ikinci kez maaş/borç/rüşvet üretmez")
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	_kontrol(geri.yonetim.maas_durumu == y.maas_durumu, "Borç/rüşvet ledger JSON dönüşümünde korunur")
	y.gun += 1
	y.akce = 10
	_kontrol(y.ata(k.id, kisla.id), "Nöbetçi tekrar atanabilir")
	once = y.akce
	y._akce(olaylar)
	_kontrol(once - y.akce == 2 and y.maas_durumu[str(k.id)].borc == 0 and y.etkin_muhafiz_sayisi() == 1, "Cari maaş ve eski borç kamu kasasından ödenir; görev toparlanır")
	var ikinci := y.kabul({"ad": "İkinci nöbetçi", "sinif": "asker"})
	var ucuncu := y.kabul({"ad": "Üçüncü aday", "sinif": "asker"})
	_kontrol(y.muhafiz_ata(ikinci.id) and not y.ata(ucuncu.id, kisla.id), "Kışla ve eski muhafız görevi aynı küresel yuva sınırını kullanır")
	var cocuk := y.kabul({"adli_id": "chr_006"})
	_kontrol(not y.ata(cocuk.id, kisla.id), "Çocuk kışla nöbetçisi yapılamaz")
	var eski := y.kaydet()
	eski.erase("maas_durumu")
	_kontrol(KoyYonetimi.kayittan(y.a, y.katalog, eski).maas_durumu.is_empty(), "Eski kayıtta maaş borcu uydurulmaz")
	_kontrol(MuhafizMaasi.oku({"1": {"borc": -1}}).is_empty(), "Bozuk maaş kaydı reddedilir")
	print("MUHAFIZ MAAŞI: GEÇTİ" if hata == 0 else "MUHAFIZ MAAŞI: KALDI")
	quit(hata)
func _kur(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h)["olur"]:
				var b := y.bina(y.bina_kur(tur, h)["id"])
				if b == null: return null
				b.insa_kalan = 0
				return b
	return null
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
