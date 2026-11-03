# gdlint: disable=max-line-length
class_name AksamSohbeti
extends RefCounted

## ACL-03 / DYL-07: Akşam sohbeti — eş günün kararlarını konuşur.
## Gece raporundan önce ocak başında en çok bir sohbet açılır.
## Konu, günün kararları arasından ağırlık tablosuna göre seçilir;
## eşin mesleği bakış açısını belirler; sohbet atlanabilir.

const VERI_YOLU: String = "res://data/soz/aksam_konulari.json"

static var _veri_onbellek: Dictionary = {}
static var _islenen_karar_anahtarlari: Array[String] = []
static var _es_hafizasi: Dictionary = {}

static func veri_al() -> Dictionary:
	if not _veri_onbellek.is_empty():
		return _veri_onbellek
	var dosya := FileAccess.open(VERI_YOLU, FileAccess.READ)
	if dosya:
		var json_metin := dosya.get_as_text()
		var json = JSON.new()
		var hata := json.parse(json_metin)
		if hata == OK and json.data is Dictionary:
			_veri_onbellek = json.data
	return _veri_onbellek

static func sifirla() -> void:
	_islenen_karar_anahtarlari.clear()
	_es_hafizasi.clear()

static func hafiza_al() -> Dictionary:
	return _es_hafizasi.duplicate(true)

## Konu seçimi: Kararlar arasından ağırlığı en yüksek, eşitlikte ziyaret sırası en büyük olanı seçer.
static func konu_sec(kararlar: Array, gun: int = 1, baglam: Dictionary = {}) -> Dictionary:
	# Uç durumlar: eş ölmüşse veya meclis gecesiyse sohbet açılmaz.
	if baglam.get("es_oldu", false) or not baglam.get("es_hayatta", true):
		return {}
	if baglam.get("meclis_gecesi", false):
		return {}
	if kararlar.is_empty():
		return {}

	var veri := veri_al()
	var konular: Dictionary = veri.get("konular", {})
	if konular.is_empty():
		return {}

	var secilen_konu_id: String = ""
	var en_yuksek_agirlik: int = -1
	var en_buyuk_ziyaret_sirasi: int = -1
	var secilen_karar_anahtari: String = ""

	for i in range(kararlar.size()):
		var karar_veri = kararlar[i]
		var konu_id: String = ""
		var ziyaret_sirasi: int = i

		if karar_veri is Dictionary:
			konu_id = str(karar_veri.get("konu_id", karar_veri.get("olay_id", "")))
			ziyaret_sirasi = int(karar_veri.get("ziyaret_sirasi", i))
		elif karar_veri is String:
			konu_id = karar_veri

		if konu_id.is_empty() or not konular.has(konu_id):
			continue

		var karar_tekil_anahtar: String = "%d_%s" % [gun, konu_id]
		# Aynı kararla ertesi gece tekrar açılmaz
		if _islenen_karar_anahtarlari.has(karar_tekil_anahtar):
			continue

		var agirlik: int = int(konular[konu_id].get("agirlik", 0))
		# Ağırlığı 0 olan olay konu olmaz
		if agirlik <= 0:
			continue

		if agirlik > en_yuksek_agirlik or (agirlik == en_yuksek_agirlik and ziyaret_sirasi > en_buyuk_ziyaret_sirasi):
			en_yuksek_agirlik = agirlik
			en_buyuk_ziyaret_sirasi = ziyaret_sirasi
			secilen_konu_id = konu_id
			secilen_karar_anahtari = karar_tekil_anahtar

	if secilen_konu_id.is_empty():
		return {}

	# İşlendi olarak kaydet
	_islenen_karar_anahtarlari.append(secilen_karar_anahtari)

	var konu_sablonu: Dictionary = konular[secilen_konu_id]
	var es_meslegi: String = str(baglam.get("es_meslegi", "dokumaci")).to_lower()
	var replikler: Array = (konu_sablonu.get("es_replikleri", []) as Array).duplicate()

	# Meslek varyantı satırı ekle
	var meslek_varyantlari: Dictionary = konu_sablonu.get("meslek_varyantlari", {})
	if meslek_varyantlari.has(es_meslegi):
		replikler.append(meslek_varyantlari[es_meslegi])
	elif not meslek_varyantlari.is_empty():
		# Varsayılan ilk varyant
		replikler.append(meslek_varyantlari.values()[0])

	return {
		"konu_id": secilen_konu_id,
		"baslik": konu_sablonu.get("baslik", ""),
		"agirlik": en_yuksek_agirlik,
		"ziyaret_sirasi": en_buyuk_ziyaret_sirasi,
		"es_replikleri": replikler,
		"cevaplar": konu_sablonu.get("cevaplar", {}),
		"ipucu": konu_sablonu.get("ipucu", "")
	}

## Oyuncunun cevabını işler; eşin moralini ve muhafız terazisini döndürür.
static func cevap_ver(konu_id: String, cevap_tipi: String, baglam: Dictionary = {}) -> Dictionary:
	var veri := veri_al()
	var konular: Dictionary = veri.get("konular", {})
	if not konular.has(konu_id):
		return {}

	var konu_sablonu: Dictionary = konular[konu_id]
	var cevaplar: Dictionary = konu_sablonu.get("cevaplar", {})
	if not cevaplar.has(cevap_tipi):
		# Geçersiz cevapta varsayılan susmak
		cevap_tipi = "susmak"

	var secilen_cevap: Dictionary = cevaplar.get(cevap_tipi, {})
	var terazi: String = str(secilen_cevap.get("terazi", "kacti"))
	var moral_etkisi: int = int(secilen_cevap.get("moral_etkisi", 0))

	# Eş hafızasına kaydet (DYL-07 Kural 5 / DIY-11)
	_es_hafizasi["son_konu"] = konu_id
	_es_hafizasi["son_cevap"] = cevap_tipi
	_es_hafizasi["son_terazi"] = terazi
	_es_hafizasi["gun"] = int(baglam.get("gun", 1))

	return {
		"konu_id": konu_id,
		"cevap_tipi": cevap_tipi,
		"metin": secilen_cevap.get("metin", ""),
		"terazi": terazi,
		"moral_etkisi": moral_etkisi,
		"ipucu": konu_sablonu.get("ipucu", "")
	}

## Sohbeti atla: Hiçbir bar veya terazi değişmez (Kural 8).
static func atla() -> Dictionary:
	return {
		"atlandi": true,
		"moral_etkisi": 0,
		"terazi": ""
	}
