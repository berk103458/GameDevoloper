## CHR kaynaklarından ziyaret başına sorgu durumu; Resource daima değişmez.
class_name ChrSorgusu
extends RefCounted

signal ipucu_bulundu(ipucu: StringName)
signal tansiyon_degisti(deger: int)
signal replik_basladi(metin: String)
var karakter: KarakterVerisi
var _ipucu_servisi := IpucuYoneticisi.new()
var ipuclari: Dictionary:
	get:
		return _ipucu_servisi.kayitlar()
var bayraklar: Dictionary = {}
var tansiyon: int = 2:
	set(deger):
		tansiyon = DiyalogDeneyi.tansiyon(self, deger)
var dugum_id: StringName = &"00"
var tecrube: int = 0
var kurallar: Resource = preload("res://data/chr_runtime/sorgu_kurallari.tres")
var son_zar: Dictionary = {}
var zar_baglami: Dictionary = {}
var _rng := RandomNumberGenerator.new()
var _denemeler: Dictionary = {}
var _son_konusulan: StringName = &""

func replik_baslat() -> bool:
	if _son_konusulan == dugum_id:
		return false
	_son_konusulan = dugum_id
	var dugum := karakter.diyalog_dugumu(dugum_id)
	var replik := metin(StringName(dugum.get("replik_anahtari", "")))
	if replik.is_empty():
		return false
	replik_basladi.emit(replik)
	return true

func tohumla(tohum: int) -> void:
	_rng.seed = tohum

func basari_olasiligi(degistirici: int = 0) -> float:
	var taban: float = kurallar.olasilik(tecrube, tansiyon)
	if degistirici == 0:
		return taban
	return clampf(taban - float(degistirici) * 0.08, kurallar.asgari, kurallar.azami)


## ZAR-04: Seçeneğin yaklaşımına göre tutan zar değiştiricilerini döner (gizli ek yok).
func yaklasim_degistiricisi(secenek: Dictionary, ek_baglam: Dictionary = {}) -> Dictionary:
	var ham_yaklasim := String(secenek.get("yaklasim", secenek.get("beceri", ""))).strip_edges().to_lower()
	match ham_yaklasim:
		"blöf":
			ham_yaklasim = "blof"
		"gözdağı":
			ham_yaklasim = "gozdagi"
		"gönül alma", "gönül_alma":
			ham_yaklasim = "gonul_alma"
	var birlesik := zar_baglami.duplicate(true)
	for k in ek_baglam.keys():
		birlesik[k] = ek_baglam[k]
	if not ipuclari.is_empty():
		birlesik["kanit"] = true
	return preload("res://src/kapi/zar_degistiricileri.gd").hesapla(ham_yaklasim, birlesik)

func metin(anahtar: StringName) -> String:
	return preload("res://src/veri/chr_guvenli_okuma.gd").metin(karakter.metinler.get(String(anahtar)), String(anahtar))

func secenek_acik(secenek: Dictionary, indeks: int = -1) -> bool:
	if indeks >= 0 and _denemeler.has("%s:%d" % [dugum_id, indeks]):
		return false
	var ipucu_kosulu: Array = secenek.get("gerekli_ipuclari", [])
	if not ipucu_kosulu.is_empty():
		var bulundu := false
		for ipucu in ipucu_kosulu:
			if ipuclari.has(StringName(ipucu)):
				bulundu = true
		if not bulundu:
			return false
	for bayrak in secenek.get("gerekli_bayraklar", []):
		if not bayraklar.get(String(bayrak), false):
			return false
	return true

func secenek_sec(indeks: int, ek_baglam: Dictionary = {}) -> bool:
	var dugum := karakter.diyalog_dugumu(dugum_id)
	var secenekler: Array = dugum.get("secenekler", [])
	if indeks < 0 or indeks >= secenekler.size() or not secenek_acik(secenekler[indeks], indeks):
		return false
	var secenek: Dictionary = secenekler[indeks]
	if not String(secenek.get("beceri", "")).is_empty():
		var deneme_id := "%s:%d" % [dugum_id, indeks]
		if _denemeler.has(deneme_id):
			return false
		_denemeler[deneme_id] = true
		var deg := yaklasim_degistiricisi(secenek, ek_baglam)
		var deg_toplam: int = int(deg.get("toplam", 0)) if bool(deg.get("gecerli", false)) else 0
		var olasilik := basari_olasiligi(deg_toplam)
		var zar := _rng.randf()
		son_zar = {
			"beceri": secenek["beceri"],
			"olasilik": olasilik,
			"zar": zar,
			"basarili": zar < olasilik,
			"degistirici": deg_toplam,
			"degistirici_satirlari": deg.get("satirlar", []),
			"kesildi": bool(deg.get("kesildi", false)),
		}
		if not son_zar["basarili"]:
			tansiyon = clampi(tansiyon + kurallar.basarisiz_tansiyon_delta, 0, 10)
			_dugume_git(dugum_id)
			tansiyon_degisti.emit(tansiyon)
			return true
	tansiyon = clampi(tansiyon + int(secenek.get("tansiyon_delta", 0)), 0, 10)
	_dugume_git(StringName(secenek["hedef"]))
	tansiyon_degisti.emit(tansiyon)
	return true

func _dugume_git(hedef: StringName) -> void:
	if tansiyon >= 8 and not bayraklar["Flag_Kilitlendi"]:
		bayraklar["Flag_Kilitlendi"] = true
		if karakter.diyalog_dugumleri.has("Final_Ret"):
			hedef = &"Final_Ret"
	dugum_id = hedef
	# Kaynakta replik içermeyen 3.2 gibi yönlendirme düğümleri otomatik yürür.
	for _adim in 16:
		var dugum := karakter.diyalog_dugumu(dugum_id)
		for bayrak in dugum.get("bayraklar", []):
			bayraklar[String(bayrak)] = true
		if not metin(StringName(dugum.get("replik_anahtari", ""))).is_empty():
			return
		var yonlendi := false
		for gecis in dugum.get("gecisler", []):
			var kosul: Dictionary = gecis.get("tansiyon_kosulu", {})
			var esik := int(kosul.get("deger", 8))
			var uygun := tansiyon >= esik if kosul.get("operator", "") == ">=" else tansiyon < esik
			if uygun:
				dugum_id = StringName(gecis["hedef"])
				yonlendi = true
				break
		if not yonlendi:
			return

func devam_et() -> bool:
	var dugum := karakter.diyalog_dugumu(dugum_id)
	for gecis in dugum.get("gecisler", []):
		var kosul: Dictionary = gecis.get("tansiyon_kosulu", {})
		var esik := int(kosul.get("deger", 8))
		var uygun := tansiyon >= esik if kosul.get("operator", "") == ">=" else tansiyon < esik
		if uygun:
			_dugume_git(StringName(gecis["hedef"]))
			return true
	return false

func karar_acik(karar: StringName) -> bool:
	if not preload("res://src/kapi/chr_karar_matrisi.gd").matriste_var_mi(self, karar):
		return false
	return not bayraklar["Flag_Kilitlendi"] or karar in [&"kisla", &"ret", &"zorunlu_ret", &"rusvet"]

func gorsel_incele() -> String:
	var ipucu := karakter.gorsel_hata_ipucu
	if _ipucu_servisi.kaydet(ipucu):
		ipucu_bulundu.emit(ipucu)
	return karakter.gorsel_hata

func _init(k: KarakterVerisi) -> void:
	_rng.randomize()
	karakter = k if k != null else KarakterVerisi.new()
	k = karakter
	bayraklar = k.yeni_sorgu_bayraklari()
	tansiyon = k.baslangic_tansiyonu

func obje_incele(sira: int) -> String:
	if sira not in [1, 2]:
		return ""
	var ipucu := karakter.obje_ipucu(sira)
	if _ipucu_servisi.kaydet(ipucu):
		ipucu_bulundu.emit(ipucu)
	var obje := karakter.obje_1 if sira == 1 else karakter.obje_2
	return preload("res://src/veri/chr_guvenli_okuma.gd").metin(obje.get("aciklama"))
