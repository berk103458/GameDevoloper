extends SceneTree

const OyuncuIziSinifi = preload("res://src/sistemler/oyuncu_izi.gd")

var _hata: int = 0
var _test_yolu := "user://test_oyuncu_izi.cfg"


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		push_error("OYUNCU IZI TEST HATASI: " + mesaj)


func _temizle() -> void:
	if FileAccess.file_exists(_test_yolu):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(_test_yolu))


func _initialize() -> void:
	_temizle()

	# 1. Ilk oyunda baslangic degerleri
	var izi := OyuncuIziSinifi.new(_test_yolu)
	_kontrol(not izi.ilk_oyun_bitti, "Ilk oyunda ilk_oyun_bitti false olmali")
	_kontrol(izi.ipucu_aktif_mi(), "Ilk oyunda ipucu aktif olmali (OGR-47)")
	_kontrol(izi.kadraj_gosterilmeli_mi(), "Ilk oyunda kadraj gosterilmeli (OGR-48)")
	_kontrol(not izi.zorluk_secimi_acik_mi(), "Ilk oyunda zorluk secimi kapali olmali (OGR-50)")

	# 2. Gece ilerlemesi: 5 gece bitti -> henuz ilk_oyun_bitti false
	izi.gece_kaydet(5)
	_kontrol(not izi.ilk_oyun_bitti, "5. gecede ilk_oyun_bitti false kalmali")

	# 3. 6 gece bitti -> ilk_oyun_bitti true olur (OGR-47)
	izi.gece_kaydet(6)
	_kontrol(izi.ilk_oyun_bitti, "6. gecede ilk_oyun_bitti true olmali (OGR-47)")

	# 4. Ikinci oyun baslangici (dosyadan yeniden yukleme)
	var izi2 := OyuncuIziSinifi.new(_test_yolu)
	_kontrol(izi2.ilk_oyun_bitti, "Ikinci acilista ilk_oyun_bitti yuklenmeli")
	_kontrol(not izi2.ipucu_aktif_mi(), "Ikinci oyunda ipucu kapali baslamali (OGR-47)")
	_kontrol(not izi2.kadraj_gosterilmeli_mi(), "Ikinci oyunda kadraj atlanmali (OGR-48)")
	_kontrol(izi2.zorluk_secimi_acik_mi(), "Ikinci oyunda zorluk secimi acik olmali (OGR-50)")

	# 5. Bolum 35'ten ipucu manuel olarak acilabilmeli (OGR-47)
	izi2.ipucu_manuel_ayarla(true)
	_kontrol(izi2.ipucu_aktif_mi(), "Manuel acilinca ipucu aktif olmali")

	# 6. OGR-49: Yeni mekanik surum_min > bilinen_surum ise tek ipucu alir
	izi2.ipucu_manuel_ayarla(false) # genel ipucu kapali
	_kontrol(not izi2.ipucu_aktif_mi(), "Genel ipucu kapali")
	var eski_kavram := {"id": "kapi_sorgusu", "surum_min": 1}
	var yeni_kavram := {"id": "yeni_sistem", "surum_min": 2}
	_kontrol(not izi2.kavram_ipucu_verilmeli_mi(eski_kavram), "Eski kavram icin ipucu verilmemeli")
	_kontrol(izi2.kavram_ipucu_verilmeli_mi(yeni_kavram), "Yeni kavram icin (surum_min 2 > 1) ipucu verilmeli (OGR-49)")

	# 7. OMR-47: Alinan son kaydi oyuncu_izi.cfg icine yazilir; iki oyunda bes sondan alinanlar listelenir
	izi2.son_kaydet("uc_tutundu")
	izi2.son_kaydet("ahi_kasabasi")
	var izi3 := OyuncuIziSinifi.new(_test_yolu)
	_kontrol(izi3.alinan_sonlar_listesi() == ["uc_tutundu", "ahi_kasabasi"], "OMR-47: iki oyunda alinan sonlar oyuncu_izi.cfg'den yuklenmeli")
	_kontrol(izi3.daha_once_satiri().begins_with("daha önce: "), "OMR-47: daha önce satırı üretilmeli")

	# 8. OMR-48: İkinci oyunda oda gidişat paneli alınmamış sonları soluk gösterir, koşul metni 0
	var gidisat := preload("res://src/arayuz/oda_gidisat_paneli.gd")
	var satirlar := gidisat.alinmamis_son_satirlari(izi3)
	_kontrol(satirlar.size() == 5, "OMR-48: beş son kontrol edilir")
	var soluk_sayisi := 0
	for s in satirlar:
		_kontrol(String(s.get("kosul_metni", "var")).is_empty(), "OMR-48: koşul metni 0 olmalı")
		if bool(s.get("soluk", false)):
			soluk_sayisi += 1
	_kontrol(soluk_sayisi == 3, "OMR-48: iki son alındıysa kalan üç alınmamış son soluk olmalı")

	_temizle()

	if _hata == 0:
		print("OYUNCU IZI (OGR-47, OGR-48, OGR-49, OGR-50): GEÇTİ (0 hata)")
	else:
		print("OYUNCU IZI: KALDI (%d hata)" % _hata)
	quit(_hata)
