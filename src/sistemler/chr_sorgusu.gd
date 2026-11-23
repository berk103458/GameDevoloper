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
var beyan_defteri := BeyanDefteri.new()
var celiski_durumu := preload("res://src/soz/celiski.gd").new()

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

## ZAR-01: KAP-09 olasılığı görünür zar kuralına döner; ikinci hesap yolu yoktur.
func basari_olasiligi(degistirici: int = 0) -> float:
	return SorguZari.olasilik(gerekli(degistirici), zar_turu())

func zar_turu() -> StringName:
	return StringName(karakter.zar) if SorguZari.gecerli_tur(StringName(karakter.zar)) else SorguZari.TUR_D6

func gerekli(degistirici: int = 0) -> int:
	return SorguZari.gerekli(karakter.sorgu_degeri, tansiyon, degistirici, kurallar)

## Gerekli değer zarın tavanını aşan beceri seçeneği kilitlidir; zar atılmaz.
func zar_kilitli(secenek: Dictionary, ek_baglam: Dictionary = {}) -> bool:
	if String(secenek.get("beceri", "")).is_empty():
		return false
	var deg := yaklasim_degistiricisi(secenek, ek_baglam)
	return SorguZari.kilitli(gerekli(int(deg.get("toplam", 0)) if bool(deg.get("gecerli", false)) else 0), zar_turu())


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
	if not birlesik.has("tecrube_esigi_gecti"):
		birlesik["tecrube_esigi_gecti"] = tecrube >= preload("res://src/soz/muhafiz_sezgisi.gd").esik()
	return preload("res://src/kapi/zar_degistiricileri.gd").hesapla(ham_yaklasim, birlesik)

func metin(anahtar: StringName) -> String:
	return preload("res://src/veri/chr_guvenli_okuma.gd").metin(karakter.metinler.get(String(anahtar)), String(anahtar))

func secenek_acik(secenek: Dictionary, indeks: int = -1, ek_baglam: Dictionary = {}) -> bool:
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
	return not kacti() and not zar_kilitli(secenek, ek_baglam)

## ZAR-03: tansiyon eşiği aşıldı; ziyaret "kaçtı" kararıyla biter, başka karar açılmaz.
func kacti() -> bool:
	return bool(bayraklar.get("Flag_Kacti", false))

## Başarısız zar dışındaki artışlar (çelişki, yemin, söylenti) da eşiği buradan aşar.
func tansiyon_artir(artis: int) -> bool:
	var kacti_mi := _kacis_hesapla(artis)
	tansiyon_degisti.emit(tansiyon)
	return kacti_mi

func _kacis_hesapla(artis: int) -> bool:
	var kacis := SorguZari.kacis_kontrol(tansiyon, artis, false, SorguZari.kacis_esigi_oku("res://data/ayarlar/denge.json", kurallar))
	if bool(kacis.kacti):
		bayraklar["Flag_Kacti"] = true
	tansiyon = clampi(tansiyon + artis, 0, 10)
	return bool(kacis.kacti)

func secenek_sec(indeks: int, ek_baglam: Dictionary = {}) -> bool:
	var dugum := karakter.diyalog_dugumu(dugum_id)
	var secenekler: Array = dugum.get("secenekler", [])
	if indeks < 0 or indeks >= secenekler.size() or not secenek_acik(secenekler[indeks], indeks, ek_baglam):
		return false
	var secenek: Dictionary = secenekler[indeks]
	if not String(secenek.get("beceri", "")).is_empty():
		var deneme_id := "%s:%d" % [dugum_id, indeks]
		if _denemeler.has(deneme_id):
			return false
		_denemeler[deneme_id] = true
		var deg := yaklasim_degistiricisi(secenek, ek_baglam)
		var deg_toplam: int = int(deg.get("toplam", 0)) if bool(deg.get("gecerli", false)) else 0
		var atis := SorguZari.sonuc(_rng, zar_turu(), karakter.sorgu_degeri, tansiyon, deg_toplam, kurallar)
		if not bool(atis.atildi):
			_denemeler.erase(deneme_id)
			return false
		son_zar = {
			"beceri": secenek["beceri"],
			"tur": atis.tur,
			"olasilik": basari_olasiligi(deg_toplam),
			"zar": int(atis.zar),
			"gerekli": int(atis.gerekli),
			"sozcuk": atis.sozcuk,
			"basarili": bool(atis.basarili),
			"degistirici": deg_toplam,
			"degistirici_satirlari": deg.get("satirlar", []),
			"kesildi": bool(deg.get("kesildi", false)),
		}
		if not son_zar["basarili"]:
			preload("res://src/debug/denge_gunlugu.gd").zar_basarisiz()
			var artis := int(secenek.get("basarisiz_tansiyon_delta", kurallar.basarisiz_tansiyon_delta))
			if _kacis_hesapla(artis):
				son_zar["kacti"] = true
			else:
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
		var replik_metni := metin(StringName(dugum.get("replik_anahtari", "")))
		if not replik_metni.is_empty():
			_dugum_beyanini_kaydet(dugum_id, replik_metni)
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
	if kacti():
		return false
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
	var oz: WeakRef = weakref(self)
	_ipucu_servisi.ipucu_bulundu.connect(func(ipucu: StringName) -> void:
		var s: ChrSorgusu = oz.get_ref() as ChrSorgusu
		if s == null:
			return
		s.celiski_durumu.kayit_ekle({
			"id": String(ipucu),
			"ipucu_id": String(ipucu),
			"tur": "ipucu",
			"metin": s._ipucu_metni(ipucu),
			"kaynak": "İnceleme / Bakış",
		})
	)
	_celiskileri_bagla()
	var ilk_dugum := karakter.diyalog_dugumu(dugum_id)
	var ilk_replik := metin(StringName(ilk_dugum.get("replik_anahtari", "")))
	if not ilk_replik.is_empty():
		_dugum_beyanini_kaydet(dugum_id, ilk_replik)


func celiski_dalina_gec(hedef: StringName, tansiyon_delta: int = 0) -> bool:
	if not karakter.diyalog_dugumleri.has(String(hedef)):
		return false
	tansiyon = clampi(tansiyon + tansiyon_delta, 0, 10)
	_dugume_git(hedef)
	tansiyon_degisti.emit(tansiyon)
	return true


func _celiskileri_bagla() -> void:
	for d_anahtar in karakter.diyalog_dugumleri.keys():
		var d_id := String(d_anahtar)
		var d_veri: Dictionary = karakter.diyalog_dugumu(StringName(d_id))
		for sec in d_veri.get("secenekler", []):
			if not sec is Dictionary:
				continue
			var reqs: Array = sec.get("gerekli_ipuclari", [])
			var hedef := String(sec.get("hedef", ""))
			if reqs.is_empty() or hedef.is_empty():
				continue
			for ip in reqs:
				celiski_durumu.celiski_ekle("beyan_" + d_id, String(ip), hedef, "guclu")


func _dugum_beyanini_kaydet(d_id: StringName, metin_str: String) -> void:
	var bid := "beyan_" + String(d_id)
	beyan_defteri.beyan_ekle(bid, metin_str, true, "")
	celiski_durumu.kayit_ekle({
		"id": bid,
		"tur": "beyan",
		"metin": metin_str,
		"kaynak": "Soru (%s)" % String(d_id),
		"dugum": String(d_id),
	})


func _ipucu_metni(ipucu: StringName) -> String:
	var baslik := String(ipucu).to_upper().replace("GÖRSEL", "GORSEL") + "_BASLIK"
	if karakter.metinler.has(baslik):
		return String(karakter.metinler[baslik])
	return String(ipucu)

func obje_incele(sira: int) -> String:
	if sira not in [1, 2]:
		return ""
	var ipucu := karakter.obje_ipucu(sira)
	if _ipucu_servisi.kaydet(ipucu):
		ipucu_bulundu.emit(ipucu)
	var obje := karakter.obje_1 if sira == 1 else karakter.obje_2
	return preload("res://src/veri/chr_guvenli_okuma.gd").metin(obje.get("aciklama"))
