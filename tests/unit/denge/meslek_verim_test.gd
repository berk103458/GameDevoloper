## DEN-36: Nitelikli iş, geçici işten çok üretir.
## Atölyeli kumaşçının (bez_evi) gecelik çıktısı, aynı kişinin geçici iş çıktısının üstündedir.
## Fark tabloda (`data/ayarlar/denge.json` `nitelikli_gecici_is_orani`) bir orandır.
extends SceneTree

var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error("HATA: " + ad)
		print("FAIL: " + ad)
	else:
		print("PASS: " + ad)

func _bina_ekle(y: KoyYonetimi, tur: String, id: int) -> KoyBinasi:
	var b := KoyBinasi.new()
	b.id = id
	b.tur = tur
	b.hucre = Vector2i(id * 2, 2)
	b.insa_kalan = 0
	var receteler := y.katalog.receteler(tur)
	if not receteler.is_empty():
		b.recete = String(receteler.keys()[0])
	y.binalar.append(b)
	return b

func _initialize() -> void:
	var kat := Katalog.new()
	if kat.yukle() != Katalog.Durum.HAZIR:
		dene(false, "Katalog yüklenemedi")
		quit(hata)
		return

	var denge: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/denge.json"))
	dene(denge is Dictionary and denge.has("nitelikli_gecici_is_orani"), "DEN-36: denge.json içinde nitelikli_gecici_is_orani var")
	var taban_oran := float(denge.get("nitelikli_gecici_is_orani", 0.0))
	dene(taban_oran > 1.0, "DEN-36: tablodaki oran 1.0'dan büyük (%.2f)" % taban_oran)

	# 1. Aynı kumaşçı (bezci, stat=8) atölyede (bez_evi) çalıştığında gecelik çıktısı:
	var o_atolye := Oturum.new(kat, 3601)
	var y_atolye := o_atolye.yonetim
	y_atolye.kaynaklar = Kaynaklar.new(10000, {"gida": 500, "su": 500, "odun": 500, "kece": 50, "kumas": 0, "alet": 10})
	_bina_ekle(y_atolye, "kulube", 1)
	var bez_evi := _bina_ekle(y_atolye, "bez_evi", 2)
	var kumasci_a := y_atolye.kabul({"ad": "Kumaşçı Bezci", "adli_id": "chr_028", "sinif": "esnaf", "stat": 8})
	kumasci_a.zanaat_turu = ZanaatTuru.Tur.BEZCI
	kumasci_a.ev = 1
	dene(y_atolye.ata(kumasci_a.id, bez_evi.id), "DEN-36: kumaşçı bez_evi yapısına atandı")
	var r_atolye := y_atolye.gece()
	var atolye_ciktisi := int(r_atolye.get("uretim", {}).get("kumas", 0))

	# 2. Aynı kumaşçı geçici işte (dal_toplama) çalıştığında gecelik çıktısı:
	var o_gecici := Oturum.new(kat, 3601)
	var y_gecici := o_gecici.yonetim
	y_gecici.kaynaklar = Kaynaklar.new(10000, {"gida": 500, "su": 500, "odun": 500, "kece": 50, "kumas": 0, "alet": 10})
	_bina_ekle(y_gecici, "kulube", 1)
	_bina_ekle(y_gecici, "odunluk", 2)
	var kumasci_g := y_gecici.kabul({"ad": "Kumaşçı Bezci", "adli_id": "chr_028", "sinif": "esnaf", "stat": 8})
	kumasci_g.zanaat_turu = ZanaatTuru.Tur.BEZCI
	kumasci_g.ev = 1
	dene(GeciciIsler.ata(y_gecici, kumasci_g.id, "dal_toplama"), "DEN-36: aynı kumaşçı geçici işe atandı")
	var r_gecici := y_gecici.gece()
	var gecici_satirlar: Array = r_gecici.get("gecici_isler", [])
	var gecici_ciktisi := int(gecici_satirlar[0].get("miktar", 0)) if not gecici_satirlar.is_empty() else 0

	dene(gecici_ciktisi > 0, "DEN-36: geçici iş çıktısı pozitif (%d)" % gecici_ciktisi)
	dene(atolye_ciktisi > gecici_ciktisi, "DEN-36: atölyeli kumaşçının çıktısı (%d) > geçici iş çıktısı (%d)" % [atolye_ciktisi, gecici_ciktisi])
	var gercek_oran := float(atolye_ciktisi) / float(maxi(1, gecici_ciktisi))
	dene(gercek_oran >= taban_oran, "DEN-36: gerçekleşen oran (%.2f) >= tablodaki oran (%.2f)" % [gercek_oran, taban_oran])

	# DEN-38: Meslek değişiminin bir günlük kaybı ölçülür, uzatılmaz.
	var HaneEsi38 = load("res://src/koy/hane_esi.gd")
	var kat38 := Katalog.new()
	kat38.yukle()
	var o38 := Oturum.new(kat38, 1438)
	load("res://src/sistemler/acilis_senaryosu.gd").kur(o38, "olagan")
	var y38: KoyYonetimi = o38.yonetim
	var once_cikti := int(HaneEsi38.cikti_al(y38).get("miktar", 0))
	var r38: Dictionary = HaneEsi38.meslek_sec(y38, "firinci", o38)
	dene(bool(r38.ok) and bool(r38.degisti), "DEN-38: meslek değişimi kabul edilir")
	var degisim_gunu := int(HaneEsi38.cikti_al(y38).get("miktar", 0))
	var olaylar38: Array[Dictionary] = []
	HaneEsi38.gece(y38, olaylar38)
	var ertesi_gun := int(HaneEsi38.cikti_al(y38).get("miktar", 0))
	HaneEsi38.gece(y38, olaylar38)
	var ikinci_gun := int(HaneEsi38.cikti_al(y38).get("miktar", 0))
	dene(once_cikti > 0, "DEN-38: değişim öncesi üretim pozitif (%d)" % once_cikti)
	dene(degisim_gunu < ertesi_gun, "DEN-38: değişim günü üretim (%d) < ertesi gün (%d)" % [degisim_gunu, ertesi_gun])
	dene(ertesi_gun == ikinci_gun, "DEN-38: kayıp bir günde kalır, uzamaz (%d == %d)" % [ertesi_gun, ikinci_gun])
	dene(int(HaneEsi38.AYAR.verimsiz_gun) == 1, "DEN-38: verimsiz gün tabloda 1")

	print("MESLEK VERIM TEST: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)
