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
	dene(CirakEgitimi.GEREKEN == 5, "Mevcut beş ortak gece süresi korunur")
	print("ÇIRAK YAŞ KAYNAĞI: GEÇTİ" if hata == 0 else "ÇIRAK YAŞ KAYNAĞI: KALDI")
	quit(hata)
