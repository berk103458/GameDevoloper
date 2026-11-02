## CAT-04: Kapida siddet sirayi korkutur.
## Askerle karsilik veya olum, siradaki kisilerin sabir ve tansiyonunu okur.
## Esik ustundekiler `data/kapi_kavgasi.json` tablosundaki olasilikla ayrilabilir; herkes ayrilmaz.
## Yatistirma ve erteleme bu ayrilmayi tetiklemez. Yeni korku bari acilmaz.
## Menu acikken artis donar; menu acilip kapaninca tansiyon artisi degismez.
class_name SiddetKorkusu
extends RefCounted


const VERI_YOLU := "res://data/kapi_kavgasi.json"

var _tablo: Dictionary = {}
var _menu_acik: bool = false
var _bekleyen_artis: int = 0
var _ayrilmis_kimlikler: Dictionary = {}


func _init() -> void:
	_tablo_yukle()


func _tablo_yukle() -> void:
	var okunan: Variant = JSON.parse_string(FileAccess.get_file_as_string(VERI_YOLU))
	if okunan is Dictionary and (okunan as Dictionary).get("siddet_korkusu") is Dictionary:
		_tablo = (okunan as Dictionary)["siddet_korkusu"]


## Menu acik/kapali durumunu gunceller.
## Menu acikken tansiyon artisi donar; menu acilip kapaninca tansiyon artisi degismez.
func menu_durumu_ayarla(acik: bool) -> void:
	_menu_acik = acik


func menu_acik_mi() -> bool:
	return _menu_acik


## Olay turune gore tablodaki tansiyon artis miktarini doner.
## Menu acilip kapansa da tablodaki artis miktari degismez; menu acikken canli artis uygulanmaz (donar).
func tansiyon_artisi_hesapla(olay_turu: String, tablo_override: Dictionary = {}) -> int:
	var etkin_tablo := _etkin_tablo(tablo_override)
	var norm_tur := _norm(olay_turu)
	if not _siddet_mi(norm_tur, etkin_tablo):
		return 0
	var artis_tablosu: Variant = etkin_tablo.get("tansiyon_artisi", {})
	if artis_tablosu is Dictionary:
		return int((artis_tablosu as Dictionary).get(norm_tur, 0))
	return 0


## Siradaki bir kisinin tansiyonuna siddet artisini uygular.
## Menu aciksa artis donar (`_bekleyen_artis` icinde tutulur) ve menu kapaninca tek seferde uygulanir;
## menuyu acip kapatmak artisi ne cogaltir ne de siler.
func tansiyon_uygula(mevcut_tansiyon: int, olay_turu: String, tablo_override: Dictionary = {}) -> int:
	var artis := tansiyon_artisi_hesapla(olay_turu, tablo_override)
	if _menu_acik:
		_bekleyen_artis = artis
		return mevcut_tansiyon
	return mevcut_tansiyon + artis


func menu_kapat_ve_donmus_artisi_coz(mevcut_tansiyon: int) -> int:
	_menu_acik = false
	var t := mevcut_tansiyon + _bekleyen_artis
	_bekleyen_artis = 0
	return t


## Siddet olayindan sonra siradaki kisilerin ayrilma ve dedikodu (DIY-13) durumunu degerlendirir.
func degerlendir(
	olay_turu: String,
	siradakiler: Array,
	baglam: Dictionary = {},
	dedikodu: Dedikodu = null,
	rng: RandomNumberGenerator = null,
	tablo_override: Dictionary = {}
) -> Dictionary:
	var etkin_tablo := _etkin_tablo(tablo_override)
	var norm_tur := _norm(olay_turu)
	var heyet_aktif := bool(baglam.get("heyet_aktif", false))

	# Kural 4 ve Uç durum: Heyet sirasinda veya siddet sayilmayan secenekte ayrilma 0'dir.
	if heyet_aktif or not _siddet_mi(norm_tur, etkin_tablo) or siradakiler.is_empty():
		return {
			"siddet_sayildi": not heyet_aktif and _siddet_mi(norm_tur, etkin_tablo),
			"ayrilan_sayisi": 0,
			"ayrilanlar": [],
			"dedikodu_sayisi": 0,
		}

	var esik := int(etkin_tablo.get("tansiyon_esigi", 0))
	var ziyaret_konusu := String(baglam.get("ziyaret_konusu_id", "")).strip_edges()
	var gun := int(baglam.get("gun", 1))
	var yerel_rng := rng if rng != null else RandomNumberGenerator.new()

	var ayrilanlar: Array[String] = []
	var dedikodu_sayisi := 0

	for ham in siradakiler:
		if not (ham is Dictionary):
			continue
		var kisi: Dictionary = ham
		var kisi_id := String(kisi.get("id", "")).strip_edges()
		if kisi_id.is_empty():
			continue

		# Uç durum: Ayrilan kisi o ziyaretin konusuysa veya zaten kactiysa ikinci kez kacmaz.
		if kisi_id == ziyaret_konusu or bool(kisi.get("ayrildi", false)) or _ayrilmis_kimlikler.has(kisi_id):
			continue

		var tansiyon := int(kisi.get("tansiyon", 0))
		if tansiyon < esik:
			continue

		var olasilik := _olasilik_bul(tansiyon, etkin_tablo, kisi)
		if olasilik <= 0.0:
			continue

		var ayrildi_mi := true if olasilik >= 1.0 else (yerel_rng.randf() < olasilik)
		if ayrildi_mi:
			ayrilanlar.append(kisi_id)
			_ayrilmis_kimlikler[kisi_id] = true
			if dedikodu != null:
				var olay_id := "sira_siddet_%d_%s" % [gun, kisi_id]
				var r: Dictionary = dedikodu.olay_kaydet(olay_id, "siddet", gun, kisi_id, 1)
				if bool(r.get("olur", false)):
					dedikodu_sayisi += 1

	return {
		"siddet_sayildi": true,
		"ayrilan_sayisi": ayrilanlar.size(),
		"ayrilanlar": ayrilanlar,
		"dedikodu_sayisi": dedikodu_sayisi,
	}


func _etkin_tablo(tablo_override: Dictionary) -> Dictionary:
	if not tablo_override.is_empty():
		var birlesik := _tablo.duplicate(true)
		for k in tablo_override.keys():
			birlesik[k] = tablo_override[k]
		return birlesik
	return _tablo


static func _siddet_mi(norm_tur: String, etkin_tablo: Dictionary) -> bool:
	var sayilmayanlar: Variant = etkin_tablo.get("siddet_sayilmayanlar", [])
	if sayilmayanlar is Array and (norm_tur in (sayilmayanlar as Array)):
		return false
	var siddet_listesi: Variant = etkin_tablo.get("siddet_sonuclari", [])
	if siddet_listesi is Array:
		return norm_tur in (siddet_listesi as Array)
	return false


static func _olasilik_bul(tansiyon: int, etkin_tablo: Dictionary, kisi: Dictionary) -> float:
	if kisi.has("tablo_olasilik"):
		return clampf(float(kisi["tablo_olasilik"]), 0.0, 1.0)
	var satirlar: Variant = etkin_tablo.get("ayrilma_olasilik_tablosu", [])
	if satirlar is Array:
		for oge in satirlar:
			if oge is Dictionary:
				var s: Dictionary = oge
				var alt := int(s.get("min_tansiyon", 0))
				var ust := int(s.get("max_tansiyon", 999))
				if tansiyon >= alt and tansiyon <= ust:
					return clampf(float(s.get("olasilik", 0.0)), 0.0, 1.0)
	return 0.0


static func _norm(metin: String) -> String:
	var s := metin.strip_edges().to_lower()
	s = s.replace("ü", "u").replace("ş", "s").replace("ı", "i").replace("ç", "c").replace("ğ", "g").replace("ö", "o").replace(" ", "_")
	return s
