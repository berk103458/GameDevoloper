## OGR-47, OGR-48, OGR-50: Oyuncu izi ve ikinci oyun davranislari.
## Cekirdek ayarlar dosyasini (user://ayarlar.cfg) kirletmeden ayri dosyada (user://oyuncu_izi.cfg) saklanir.
## Bir kez alti gece gecildiyse veya oyun tamamlandiysa ilk_oyun_bitti true olur.
class_name OyuncuIzi
extends RefCounted

const VARSAYILAN_YOL := "user://oyuncu_izi.cfg"
const BOLUM_ANAHTARI := "oyuncu_izi"
const NIHAI_SONLAR_YOLU := "res://data/nihai_sonlar.json"
const BES_SON := ["uc_tutundu", "ahi_kasabasi", "beyin_uc_koyu", "ertugrul_obasi", "tekfur_haraccisi"]

var dosya_yolu: String = VARSAYILAN_YOL
var ilk_oyun_bitti: bool = false
var tamamlanan_geceler: int = 0
var bitirilen_oyun_sayisi: int = 0
var bilinen_surum: int = 1
var ipucu_manuel_acik: bool = false
var alinan_sonlar: PackedStringArray = PackedStringArray()


func _init(ozel_yol: String = "") -> void:
	if not ozel_yol.is_empty():
		dosya_yolu = ozel_yol
	yukle()


func sifirla() -> void:
	ilk_oyun_bitti = false
	tamamlanan_geceler = 0
	bitirilen_oyun_sayisi = 0
	bilinen_surum = 1
	ipucu_manuel_acik = false
	alinan_sonlar = PackedStringArray()


## OGR-47: 6 gece gecildiyse ilk oyun bitmis sayilir.
func gece_kaydet(gece_sayisi: int) -> void:
	tamamlanan_geceler = maxi(tamamlanan_geceler, gece_sayisi)
	if tamamlanan_geceler >= 6:
		ilk_oyun_bitti = true
	kaydet()


func oyunu_tamamla(son_id: String = "") -> void:
	var temiz := son_id.strip_edges()
	if not temiz.is_empty():
		son_kaydet(temiz)
		return
	ilk_oyun_bitti = true
	bitirilen_oyun_sayisi += 1
	kaydet()


## OMR-47: Alinan son kaydi oyuncu_izi.cfg icine yazilir; bes sondan alinanlar listelenir.
func son_kaydet(son_id: String) -> void:
	var temiz := son_id.strip_edges()
	if temiz in BES_SON and temiz not in alinan_sonlar:
		alinan_sonlar.append(temiz)
	ilk_oyun_bitti = true
	bitirilen_oyun_sayisi += 1
	kaydet()


func alinan_sonlar_listesi() -> Array[String]:
	var sonuc: Array[String] = []
	for son_id in BES_SON:
		if son_id in alinan_sonlar:
			sonuc.append(son_id)
	return sonuc


func daha_once_satiri() -> String:
	var liste := alinan_sonlar_listesi()
	if liste.is_empty():
		return ""
	var sonlar_sozluk: Dictionary = {}
	if FileAccess.file_exists(NIHAI_SONLAR_YOLU):
		var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(NIHAI_SONLAR_YOLU))
		if veri is Dictionary:
			sonlar_sozluk = (veri as Dictionary).get("sonlar", {})
	var adlar := PackedStringArray()
	for son_id in liste:
		var baslik := String(sonlar_sozluk.get(son_id, {}).get("baslik", son_id))
		adlar.append(baslik if not baslik.is_empty() else son_id)
	return "daha önce: " + ", ".join(adlar)


## OGR-47: Ikinci oyunda ipucu ve kademeli acilis varsayilan olarak kapalidir; ayarlardan acilabilir.
func ipucu_aktif_mi() -> bool:
	if not ilk_oyun_bitti:
		return true
	return ipucu_manuel_acik


## OGR-47: Bolum 35 ayarlarindan ipucu manuel olarak acilip kapatilabilir.
func ipucu_manuel_ayarla(acik: bool) -> void:
	ipucu_manuel_acik = acik
	kaydet()


## OGR-48: Acilis kadraji ilk_oyun_bitti iken atlanir (ikinci oyunda kadraj gosterilmez / 0).
func kadraj_gosterilmeli_mi() -> bool:
	return not ilk_oyun_bitti


## OGR-50: Zorluk secimi ikinci oyunda acilir (ilk oyunda gosterilmez, olagan baslar).
func zorluk_secimi_acik_mi() -> bool:
	return ilk_oyun_bitti


## OGR-49: Surum guncellemesiyle gelen yeni sistem (surum_min > bilinen_surum) deneyimli oyuncuya da tek ipucu verir.
func kavram_ipucu_verilmeli_mi(kavram: Dictionary) -> bool:
	var surum_min := int(kavram.get("surum_min", 1))
	if not ilk_oyun_bitti:
		return true
	# Ikinci oyunda genel ipucu kapali olsa bile yeni mekanik tek ipucu alir:
	if surum_min > bilinen_surum:
		return true
	return ipucu_manuel_acik


func surumu_guncelle(yeni_surum: int) -> void:
	bilinen_surum = maxi(bilinen_surum, yeni_surum)
	kaydet()


func yukle() -> void:
	sifirla()
	if not FileAccess.file_exists(dosya_yolu):
		return
	var cfg := ConfigFile.new()
	if cfg.load(dosya_yolu) != OK:
		return
	ilk_oyun_bitti = bool(cfg.get_value(BOLUM_ANAHTARI, "ilk_oyun_bitti", false))
	tamamlanan_geceler = int(cfg.get_value(BOLUM_ANAHTARI, "tamamlanan_geceler", 0))
	bitirilen_oyun_sayisi = int(cfg.get_value(BOLUM_ANAHTARI, "bitirilen_oyun_sayisi", 0))
	bilinen_surum = int(cfg.get_value(BOLUM_ANAHTARI, "bilinen_surum", 1))
	ipucu_manuel_acik = bool(cfg.get_value(BOLUM_ANAHTARI, "ipucu_manuel_acik", false))
	var ham_sonlar: Variant = cfg.get_value(BOLUM_ANAHTARI, "alinan_sonlar", [])
	if ham_sonlar is Array or ham_sonlar is PackedStringArray:
		for s in ham_sonlar:
			var temiz := String(s).strip_edges()
			if temiz in BES_SON and temiz not in alinan_sonlar:
				alinan_sonlar.append(temiz)


func kaydet() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value(BOLUM_ANAHTARI, "ilk_oyun_bitti", ilk_oyun_bitti)
	cfg.set_value(BOLUM_ANAHTARI, "tamamlanan_geceler", tamamlanan_geceler)
	cfg.set_value(BOLUM_ANAHTARI, "bitirilen_oyun_sayisi", bitirilen_oyun_sayisi)
	cfg.set_value(BOLUM_ANAHTARI, "bilinen_surum", bilinen_surum)
	cfg.set_value(BOLUM_ANAHTARI, "ipucu_manuel_acik", ipucu_manuel_acik)
	cfg.set_value(BOLUM_ANAHTARI, "alinan_sonlar", alinan_sonlar_listesi())
	cfg.save(dosya_yolu)
