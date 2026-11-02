extends SceneTree

const IlkSaatSinifi = preload("res://src/sistemler/ilk_saat.gd")
const ZarIpucuSinifi = preload("res://src/kapi/zar_ipucu.gd")

var _hata: int = 0


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("ILK SAAT TEST HATASI: " + mesaj)


func _initialize() -> void:
	var ilk := IlkSaatSinifi.new()
	var kavramlar := ilk.kavramlar()
	_kontrol(kavramlar.size() == 9, "ilk_saat.json icinde 9 temel kavram olmali")
	for k in kavramlar:
		_kontrol(k.has("gece_min") and k.has("tetik"), "Her kavramin gece_min ve tetik alani olmali")

	# Listede olmayan ipucu cikmaz
	var uydurma := ilk.tetikle("uydurma_ipucu", 5)
	_kontrol(not bool(uydurma.get("gosterildi", true)), "Listede olmayan ipucu cikmamali")

	# OGR-03: Gece 1'de ilk zar atisinda ipucu 1 kez gorunur, `zar_gosterildi` yazilir; ayni kayitla ikinci acilista ipucu 0
	var zar_ilk := ZarIpucuSinifi.ilk_atis_ipucu(ilk, 1)
	_kontrol(int(zar_ilk.get("ipucu_sayisi", 0)) == 1 and bool(ilk.zar_gosterildi), "Ilk zar atisinda ipucu 1 kez gorunmeli ve zar_gosterildi yazilmali")
	var kayit := ilk.kaydet()
	var yuklenen := IlkSaatSinifi.new()
	yuklenen.yukle(kayit)
	var zar_ikinci := ZarIpucuSinifi.ilk_atis_ipucu(yuklenen, 1)
	_kontrol(int(zar_ikinci.get("ipucu_sayisi", -1)) == 0, "Ayni kayitla ikinci acilista zar ipucu 0 olmali")

	# OGR-06: tehdit_baslangic BUG-18 sabitini okur; deger degisince ikisi birlikte degisir ve pazar/divan'dan sonradir
	var eski_tehdit := int(TehditTakvimi.AYAR.get("tehdit_baslangic_gunu", 14))
	_kontrol(IlkSaatSinifi.tehdit_baslangic_gunu() == eski_tehdit, "tehdit_baslangic BUG-18 ile ayni degeri okumali")
	TehditTakvimi.AYAR["tehdit_baslangic_gunu"] = 18
	_kontrol(IlkSaatSinifi.tehdit_baslangic_gunu() == 18 and TehditTakvimi.acik(18) and not TehditTakvimi.acik(17), "BUG-18 sabiti degisince IlkSaat ve TehditTakvimi birlikte degismeli")
	TehditTakvimi.AYAR["tehdit_baslangic_gunu"] = eski_tehdit

	# Ilk alti gecede (gece 0..5) tum kavramlar tetiklendiginde gosterilen ipucu sayisi kavram sayisiyla esittir
	ilk.sifirla()
	var gosterilen := 0
	for gece in range(0, 6):
		for k in kavramlar:
			var sonuc := ilk.tetikle(String(k.get("tetik", "")), gece)
			if bool(sonuc.get("gosterildi", false)):
				gosterilen += 1
	_kontrol(gosterilen == ilk.kavram_sayisi(), "Dosyadaki kavram sayisi ile ilk alti gecede gosterilen ipucu sayisi esit olmali")

	if _hata == 0:
		print("ILK SAAT: GEÇTİ (0 hata)")
	else:
		print("ILK SAAT: KALDI (%d hata)" % _hata)
	quit(_hata)
