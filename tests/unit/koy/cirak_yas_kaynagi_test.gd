## ISG-73: UZM eğitimi/tezgâh mevcut YasRolleri izinlerini kullanır.
extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	for tur in ["demirhane", "bez_evi"]:
		var y := KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), 7373)
		var b := KoyBinasi.new()
		b.id = 1
		b.tur = tur
		b.hucre = Vector2i(2, 2)
		y.binalar.append(b)
		var usta := y.kabul({"ad": "Usta", "sinif": "esnaf", "stat": 7})
		var k := y.kabul({"adli_id": "chr_006", "stat": 2})
		var izin := YasRolleri.atanabilir(k, tur)
		dene(izin == (tur == "bez_evi"), "Mevcut çocuk hafif iş kaynağı: " + tur)
		if not izin: dene(not y.ata(k.id, b.id), "Normal atama ağır işi reddeder")
		# Eski/uyumsuz atama veya çalışma listesi ikinci yaş eşiği açmamalı.
		usta.is_yeri = b.id
		k.is_yeri = b.id
		CirakEgitimi.gece(y, {usta.id: b.id, k.id: b.id}, [])
		dene(k.egitim.is_empty() == not izin, "UZM-04 eğitim izni yaş kaynağıyla aynı: " + tur)
		var yer := "bez" if tur == "bez_evi" else "demirhane"
		TezgahtaGun.yuz_bagla(y, yer, str(usta.id), "usta", true)
		var sabah := TezgahtaGun.sabah(y, yer, {"usta": -1, "cirak": k.id, "bina": b.id, "stok": 1})
		dene(int(sabah.titreme) == int(izin) and int(sabah.gun) == 0, "TEZ çırak aynı yaş iznini okur: " + tur)
		var yuklu := Koylu.kayittan(JSON.parse_string(JSON.stringify(k.kaydet())))
		dene(yuklu.yas_grubu == k.yas_grubu and YasRolleri.atanabilir(yuklu, tur) == izin, "Kayıt aynı yaş iznini korur")
	_aile_cirak()
	dene(CirakEgitimi.GEREKEN == 5, "Mevcut beş ortak gece süresi korunur")
	print("ÇIRAK YAŞ KAYNAĞI: GEÇTİ" if hata == 0 else "ÇIRAK YAŞ KAYNAĞI: KALDI")
	quit(hata)

## YAP-28: gerçek KAP-17 ailesi; DNY-01 yaş büyümesi bu testte uygulanmaz.
func _aile_cirak() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 2828)
	var g := Gelen.new()
	g.ad_anahtari = "Usta"
	g.sinif = &"esnaf"
	g.stat = 8
	g.secenekler = PackedStringArray(["kabul", "ret"])
	g.aile.assign([{"ad": "Usta", "yas_grubu": "yetiskin", "sinif": "esnaf", "stat": 8}, {"ad": "Çocuğu", "yas_grubu": "cocuk", "sinif": "esnaf", "stat": 2}])
	var r := o.karar_ver(g, &"kabul")
	dene(r.get("kaldi", false) and o.yonetim.koylular.size() == 2, "YAP-28: usta ve çocuk gerçek aile kabulünden gelir")
	if o.yonetim.koylular.size() != 2: return
	var y := o.yonetim
	var usta := y.koylular[0]
	var cocuk := y.koylular[1]
	dene(usta.hane_id == cocuk.hane_id and cocuk.hane_id != -1 and CirakEgitimi.usta(usta), "YAP-28: gerçek ortak hane ve usta kaydı")
	var b := KoyBinasi.new()
	b.id = 90
	b.tur = "demirhane"
	b.hucre = Vector2i(2, 2)
	y.binalar.append(b)
	dene(y.ata(usta.id, b.id) and not y.ata(cocuk.id, b.id), "YAP-28: usta çalışır, küçük çocuk ağır işe erken atanamaz")
	CirakEgitimi.gece(y, {usta.id: b.id, cocuk.id: b.id}, [])
	dene(cocuk.egitim.is_empty(), "YAP-28: erken eğitim ilerlemesi sıfır")
	# Yetişkinlik fixture girdisidir; DNY-01 takvim/büyüme uygulanmış sayılmaz.
	cocuk.yas_grubu = &"yetiskin"
	var geri := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(geri != null, "YAP-28: aile ve yaş JSON yüklemesi")
	if geri == null: return
	y = geri.yonetim
	usta = y.koylu(usta.id)
	cocuk = y.koylu(cocuk.id)
	dene(usta.hane_id == cocuk.hane_id and y.ata(cocuk.id, b.id), "YAP-28: yaşı uygun usta çocuğu normal atamayla çırak olur")
	for gece in range(CirakEgitimi.GEREKEN):
		CirakEgitimi.gece(y, {usta.id: b.id, cocuk.id: b.id}, [])
	dene(cocuk.egitim.get("tamamlandi", false) and cocuk.stat == 6 and cocuk.egitim.get("usta") == usta.id, "YAP-28: aynı aile çocuğu mevcut beş ortak çalışma ile yarı usta olur")
