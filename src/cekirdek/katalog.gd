## İçerik kataloğu: `res://data/` altındaki kayıtları bir kez yükler, doğrular,
## sonra salt okunur sunar (design/gdd/icerik-veri-hatti.md).
class_name Katalog
extends RefCounted

enum Durum { YUKLENMEDI, HAZIR, HATALI }

const SINIFLAR: Array[StringName] = [&"asker", &"esnaf", &"ciftci"]
const KARARLAR: Array[String] = ["kabul", "ret", "rusvet", "kisla"]
const KURALLAR: Array[StringName] = [&"hic_donmez", &"oranla_doner", &"birden_cok_gelir"]

var durum: Durum = Durum.YUKLENMEDI
## Doğrulama hataları (dosya + kural).
var hatalar: PackedStringArray = []
var ayarlar: OyunAyarlari
var _karakterler: Dictionary = {}
var _sohbetler: Dictionary = {}
var _siniflar: Dictionary = {}
var _olaylar: Dictionary = {}


## Verilen kök klasörden tüm içeriği yükler ve doğrular. Testler fixture kökü verir.
func yukle(kok: String = "res://data") -> Durum:
	hatalar = []
	_karakterler = _klasor_yukle(kok + "/karakterler")
	_sohbetler = _klasor_yukle(kok + "/sohbetler")
	_siniflar = _klasor_yukle(kok + "/siniflar")
	_olaylar = _klasor_yukle(kok + "/olaylar")
	ayarlar = load(kok + "/ayarlar/oyun.tres") as OyunAyarlari
	_dogrula()
	durum = Durum.HAZIR if hatalar.is_empty() else Durum.HATALI
	for h in hatalar:
		push_error("İçerik hatası: " + h)
	return durum


## Adlı karakter; yoksa null ve geliştirme hatası.
func karakter(id: StringName) -> KarakterVerisi:
	if not _karakterler.has(id):
		push_error("Bilinmeyen karakter: %s" % id)
		return null
	return _karakterler[id]


## Tüm adlı karakterler (kimlik sırasıyla).
func karakterler() -> Array[KarakterVerisi]:
	var sonuc: Array[KarakterVerisi] = []
	var anahtarlar := _karakterler.keys()
	anahtarlar.sort()
	for k in anahtarlar:
		sonuc.append(_karakterler[k])
	return sonuc


## Tüm gece olayları (kimlik sırasıyla).
func olaylar() -> Array[OlayVerisi]:
	var sonuc: Array[OlayVerisi] = []
	var anahtarlar := _olaylar.keys()
	anahtarlar.sort()
	for k in anahtarlar:
		sonuc.append(_olaylar[k])
	return sonuc


func sohbet(id: StringName) -> SohbetVerisi:
	return _sohbetler.get(id)


func sinif(id: StringName) -> SinifSablonu:
	return _siniflar.get(id)


func _klasor_yukle(yol: String) -> Dictionary:
	var sonuc := {}
	var dosyalar := ResourceLoader.list_directory(yol)
	for dosya in dosyalar:
		var ad := dosya.trim_suffix(".remap")
		if not ad.ends_with(".tres"):
			continue
		var kayit := load(yol + "/" + ad)
		if kayit == null or not ("id" in kayit):
			hatalar.append("%s/%s: yüklenemedi ya da id yok" % [yol, ad])
			continue
		var id: StringName = kayit.id
		if String(id) != ad.get_basename():
			hatalar.append("%s/%s: dosya adı id'ye eşit değil (%s)" % [yol, ad, id])
		if sonuc.has(id):
			hatalar.append("%s: tekrarlanan id %s" % [yol, id])
		sonuc[id] = kayit
	return sonuc


func _dogrula() -> void:
	if ayarlar == null:
		hatalar.append("ayarlar/oyun.tres yok")
		return
	var bar_sayisi := ayarlar.bar_anahtarlari.size()
	if _karakterler.is_empty():
		hatalar.append("karakterler: hiç adlı karakter yok")
	for k: KarakterVerisi in _karakterler.values():
		_anahtar_dogrula(k.ad_anahtari, "karakter %s" % k.id)
		if not k.sinif in SINIFLAR:
			hatalar.append("karakter %s: bilinmeyen sınıf %s" % [k.id, k.sinif])
		if not k.donus_kurali in KURALLAR:
			hatalar.append("karakter %s: bilinmeyen dönüş kuralı" % k.id)
		if not _sohbetler.has(k.sohbet_id):
			hatalar.append("karakter %s: sohbet %s yok" % [k.id, k.sohbet_id])
		_secenek_dogrula(k.karar_secenekleri, "karakter %s" % k.id)
		for karar in k.karar_secenekleri:
			if k.etki(karar).size() != bar_sayisi:
				hatalar.append("karakter %s: %s etkisi %d bar olmalı" % [k.id, karar, bar_sayisi])
		if k.donus_kurali == &"oranla_doner" and (k.p0 <= 0.0 or k.p0 > 1.0 or k.d < 0.0 or k.d > 1.0 or k.k_azami < 2 or k.k_azami > 6):
			hatalar.append("karakter %s: oranla_doner değerleri aralık dışı" % k.id)
		if k.donus_kurali == &"birden_cok_gelir" and (k.n_ziyaret < 2 or k.n_ziyaret > 6):
			hatalar.append("karakter %s: n_ziyaret 2–6 olmalı" % k.id)
		if k.donus_kurali != &"hic_donmez" and (k.g_min < 1 or k.g_min > k.g_max or k.g_max > 10):
			hatalar.append("karakter %s: g_min/g_max aralık dışı" % k.id)
	for s: SohbetVerisi in _sohbetler.values():
		for a in s.giris_anahtarlari:
			_anahtar_dogrula(a, "sohbet %s" % s.id)
		for a in s.soru_anahtarlari + s.cevap_anahtarlari:
			_anahtar_dogrula(a, "sohbet %s" % s.id)
	for o: OlayVerisi in _olaylar.values():
		_anahtar_dogrula(o.baslik_anahtari, "olay %s" % o.id)
		_anahtar_dogrula(o.metin_anahtari, "olay %s" % o.id)
		if o.secenek_anahtarlari.size() != o.secenek_etkileri.size() or o.secenek_anahtarlari.is_empty():
			hatalar.append("olay %s: seçenek ve etki sayısı eşit olmalı" % o.id)
		for i in o.secenek_anahtarlari.size():
			_anahtar_dogrula(o.secenek_anahtarlari[i], "olay %s" % o.id)
			_anahtar_dogrula("%s.sonuc%d" % [o.metin_anahtari.trim_suffix(".metin"), i + 1], "olay %s" % o.id)
		for id in o.kosullar.get("koyde", []) + o.kosullar.get("ayrildi", []):
			if not _karakterler.has(StringName(id)):
				hatalar.append("olay %s: bilinmeyen karakter %s" % [o.id, id])
	for sinif_adi in SINIFLAR:
		var s: SinifSablonu = _siniflar.get(sinif_adi)
		if s == null:
			hatalar.append("sınıf şablonu yok: %s" % sinif_adi)
			continue
		if s.ad_havuzu.size() < 3:
			hatalar.append("sınıf %s: ad havuzu ≥ 3 olmalı" % sinif_adi)
		_secenek_dogrula(s.karar_secenekleri, "sınıf %s" % sinif_adi)
		for a in s.ad_havuzu + s.giris_anahtarlari + s.soru_anahtarlari + s.cevap_anahtarlari:
			_anahtar_dogrula(a, "sınıf %s" % sinif_adi)


func _secenek_dogrula(secenekler: PackedStringArray, kim: String) -> void:
	if secenekler.is_empty():
		hatalar.append("%s: karar seçeneği yok" % kim)
	var gorulen := {}
	for s in secenekler:
		if not s in KARARLAR:
			hatalar.append("%s: bilinmeyen karar %s" % [kim, s])
		if gorulen.has(s):
			hatalar.append("%s: tekrarlanan karar %s" % [kim, s])
		gorulen[s] = true


func _anahtar_dogrula(anahtar: String, kim: String) -> void:
	var metin := TranslationServer.translate(anahtar)
	if metin == anahtar or metin.strip_edges().is_empty():
		hatalar.append("%s: metin anahtarı tabloda yok ya da boş: %s" % [kim, anahtar])
