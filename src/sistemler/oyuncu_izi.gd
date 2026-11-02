## OGR-47, OGR-48, OGR-50: Oyuncu izi ve ikinci oyun davranislari.
## Cekirdek ayarlar dosyasini (user://ayarlar.cfg) kirletmeden ayri dosyada (user://oyuncu_izi.cfg) saklanir.
## Bir kez alti gece gecildiyse veya oyun tamamlandiysa ilk_oyun_bitti true olur.
class_name OyuncuIzi
extends RefCounted

const VARSAYILAN_YOL := "user://oyuncu_izi.cfg"
const BOLUM_ANAHTARI := "oyuncu_izi"

var dosya_yolu: String = VARSAYILAN_YOL
var ilk_oyun_bitti: bool = false
var tamamlanan_geceler: int = 0
var bitirilen_oyun_sayisi: int = 0
var bilinen_surum: int = 1
var ipucu_manuel_acik: bool = false


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


## OGR-47: 6 gece gecildiyse ilk oyun bitmis sayilir.
func gece_kaydet(gece_sayisi: int) -> void:
	tamamlanan_geceler = maxi(tamamlanan_geceler, gece_sayisi)
	if tamamlanan_geceler >= 6:
		ilk_oyun_bitti = true
	kaydet()


func oyunu_tamamla() -> void:
	ilk_oyun_bitti = true
	bitirilen_oyun_sayisi += 1
	kaydet()


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


func kaydet() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value(BOLUM_ANAHTARI, "ilk_oyun_bitti", ilk_oyun_bitti)
	cfg.set_value(BOLUM_ANAHTARI, "tamamlanan_geceler", tamamlanan_geceler)
	cfg.set_value(BOLUM_ANAHTARI, "bitirilen_oyun_sayisi", bitirilen_oyun_sayisi)
	cfg.set_value(BOLUM_ANAHTARI, "bilinen_surum", bilinen_surum)
	cfg.set_value(BOLUM_ANAHTARI, "ipucu_manuel_acik", ipucu_manuel_acik)
	cfg.save(dosya_yolu)
