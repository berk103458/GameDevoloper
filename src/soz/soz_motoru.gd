# gdlint: disable=max-line-length
## KAY-26 / KAY-27 / KAY-36 / KAY-51: söz ziyaretinin kayıt adaptörü.
## DIY-02 / DIY-03 / DIY-04 / DIY-05 / DIY-06 / DIY-07 / DIY-10 / DIY-17 / DIY-18
## Söz motoru çekirdeği — düğüm yürütücü, konu merkezi ve sorgu mekaniği.
class_name SozMotoru
extends RefCounted

const GECIS_YOLU := "res://data/soz/gecis.json"
const SELAM := "selam"

const SozSemasi = preload("res://src/soz/soz_semasi.gd")
const SozDugumu = preload("res://src/soz/soz_dugumu.gd")
const SatirSecici = preload("res://src/soz/satir_secici.gd")

# Kayıt Adaptörü Değişkenleri (KAY-26..)
var dugum_id: String = ""
var konular: Array = []
var selam_okundu: bool = false
var zar: int = -1
var _zar_kayitli: bool = false
var _acilan: PackedStringArray = PackedStringArray()

# Diyalog Motoru Değişkenleri (DIY-02..)
var dugumler: Dictionary = {}
var aktif_dugum: SozDugumu = null
var konusmaci: String = ""
var cekirdek: String = ""
var sustu: bool = false
var veda_edildi: bool = false
var son_satir: String = ""

# Durum Değişkenleri
var guven: int = 3 # 0 - 10
var korku: int = 0 # 0 - 10
var sabir: int = 5
var beyan_defteri: Array[Dictionary] = []
var celiskiler: Array[Dictionary] = []
var _celiski: RefCounted = null
var uygulanan_etkiler: Dictionary = {}
var kesilen_dugumler: Array[String] = []
var hafiza_soylenen: Dictionary = {}

# Konu ve Derinleşme Takibi
var konu_katmanlari: Dictionary = {} # konu_id -> int
var selam_tamamlandi: bool = false
var panik_durumu: bool = false

var hatalar: Array[String] = []


func sorguyu_ac() -> void:
	GuvenliKayit.sorgu_kaydi_kapali = true


func sorguyu_kapat() -> void:
	GuvenliKayit.sorgu_kaydi_kapali = false


func kaydet() -> Dictionary:
	var veri := {
		"dugum_id": dugum_id,
		"konular": konular.duplicate(true),
		"selam_okundu": selam_okundu,
	}
	if _zar_kayitli:
		veri["zar"] = zar
	return veri


func yukle(veri: Variant, baglam_veya_sema: Variant = {}) -> Dictionary:
	if veri is Dictionary and (veri.has("dugumler") or (veri.has("cekirdek") and not veri.has("dugum_id"))):
		var ok := _yukle_diyalog(veri, baglam_veya_sema if baglam_veya_sema is Dictionary else {})
		return {"basarili": true} if ok else {}
	else:
		return _yukle_kayit(veri, baglam_veya_sema if baglam_veya_sema is Array else [])


func _yukle_kayit(veri: Variant, sema_dugumleri: Array = []) -> Dictionary:
	if not veri is Dictionary or veri.is_empty():
		dugum_id = ""
		konular = []
		selam_okundu = false
		return {"kisi_silindi": false, "dugum_id": dugum_id, "selam_yeniden": false}
	var gelen := String(veri.get("dugum_id", "")).strip_edges()
	if not gelen.is_empty() and not sema_dugumleri.is_empty() and not sema_dugumleri.has(gelen):
		push_warning("KAY36_KOPUK_DUGUM:%s" % gelen)
		dugum_id = SELAM
		konular = veri.get("konular", []) if veri.get("konular") is Array else []
		selam_okundu = false
		_zar_oku(veri)
		return {"kisi_silindi": false, "dugum_id": SELAM, "selam_yeniden": true}
	dugum_id = gelen
	konular = veri.get("konular", []).duplicate(true) if veri.get("konular") is Array else []
	selam_okundu = bool(veri.get("selam_okundu", false))
	_zar_oku(veri)
	return {"kisi_silindi": false, "dugum_id": dugum_id, "selam_yeniden": not selam_okundu and not dugum_id.is_empty()}


func _yukle_diyalog(dosya: Dictionary, baglam: Dictionary = {}) -> bool:
	hatalar.clear()
	dugumler.clear()
	beyan_defteri.clear()
	celiskiler.clear()
	if _celiski != null:
		_celiski.sifirla()
	uygulanan_etkiler.clear()
	kesilen_dugumler.clear()
	hafiza_soylenen.clear()
	konu_katmanlari.clear()
	selam_tamamlandi = false
	sustu = false
	veda_edildi = false

	# Şema denetimi (DIY-01a / DIY-02)
	var sema_hatalari := SozSemasi.dogrula(dosya)
	if not sema_hatalari.is_empty():
		for h in sema_hatalari:
			hatalar.append("sema_hatasi: " + h)
		sustu = true
		return false

	# Etki ve metin anahtarı özel denetimi
	var kurallar := SozSemasi.kurallari_oku()
	guven = int(kurallar.get("baslangic_guven", 3))
	sabir = int(kurallar.get("baslangic_sabir", 5))

	konusmaci = str(dosya.get("konusmaci", ""))
	cekirdek = str(dosya.get("cekirdek", "durust"))
	for c in dosya.get("celiskiler", []):
		if c is Dictionary:
			var kopya := (c as Dictionary).duplicate(true)
			celiskiler.append(kopya)
			celiski().celiski_ekle(String(kopya.get("a", "")), String(kopya.get("b", "")), String(kopya.get("dal", "yuzlesme")), String(kopya.get("guc", "guclu")))

	var ham_dugumler: Dictionary = dosya.get("dugumler", {})
	for d_id in ham_dugumler.keys():
		var d_veri = ham_dugumler[d_id]
		if d_veri is Dictionary:
			# Boş metin anahtarı kontrolü
			var satir_val = d_veri.get("satir", "")
			if satir_val is String and (satir_val as String).is_empty():
				hatalar.append("bos_metin_anahtari_%s" % str(d_id))
			dugumler[str(d_id)] = SozDugumu.new(str(d_id), d_veri)

	if not dugumler.has("giris"):
		sustu = true
		return false

	aktif_dugum = dugumler["giris"]
	_satiri_isle(aktif_dugum, baglam)
	return true


func mevcut_satir() -> String:
	if sustu or aktif_dugum == null:
		return ""
	return son_satir


func _satiri_isle(dugum: SozDugumu, baglam: Dictionary) -> void:
	if dugum.satir is String:
		son_satir = dugum.satir
	elif dugum.satir is Array:
		# SatirSecici ile varyant değerlendir
		var secici := SatirSecici.new()
		var sonuc := secici.sec(dugum.satir, baglam)
		son_satir = str(sonuc.get("satir", ""))
	else:
		son_satir = ""

	# Beyan varsa deftere ekle (DIY-06)
	if not dugum.beyan.is_empty():
		var beyan_kopya := dugum.beyan.duplicate(true)
		if not beyan_kopya.has("dugum"):
			beyan_kopya["dugum"] = dugum.id
		beyan_defteri.append(beyan_kopya)


func mevcut_secenekler(baglam: Dictionary = {}) -> Array[Dictionary]:
	if sustu or aktif_dugum == null or veda_edildi:
		return []

	var sonuc: Array[Dictionary] = []

	# İtiraf seçeneği: Güven >= 7 ise zarsız itiraf düğmesi ekle (DIY-17)
	var itiraf_esigi: int = 7
	if guven >= itiraf_esigi and cekirdek != "durust":
		sonuc.append({
			"id": "sec_itiraf",
			"metin": "[Güven İtirafı] Bana her şeyi dosdoğru anlat.",
			"hedef": "yuzlesme",
			"itiraf": true
		})

	for sec in aktif_dugum.secenekler:
		var sec_id: String = str(sec.get("id", ""))
		var hedef: String = str(sec.get("hedef", ""))

		# Kesilmiş düğüme tekrar erişilemez (DIY-18)
		if kesilen_dugumler.has(hedef):
			continue

		# Kilitlerin denetimi (DIY-02)
		var kosul: Dictionary = sec.get("kosul", {})
		if not _kilit_uygun_mu(kosul, baglam):
			continue

		# Sabır bittiyse yeni konular açılamaz (DIY-05)
		if sabir <= 0 and sec.get("konu_baslat", false):
			continue

		sonuc.append(sec)

	return sonuc


func _kilit_uygun_mu(kosul: Dictionary, baglam: Dictionary) -> bool:
	if kosul.is_empty():
		return true

	# 1. Tansiyon kilidi
	if kosul.has("tansiyon_max") and int(baglam.get("tansiyon", 0)) > int(kosul.get("tansiyon_max")):
		return false
	if kosul.has("tansiyon_min") and int(baglam.get("tansiyon", 0)) < int(kosul.get("tansiyon_min")):
		return false

	# 2. İpucu kilidi
	if kosul.has("gerekli_ipucu"):
		var ipuclari: Array = baglam.get("ipuclari", [])
		if not (kosul.get("gerekli_ipucu") in ipuclari):
			return false

	# 3. Bayrak kilidi
	if kosul.has("gerekli_bayrak"):
		var bayraklar: Dictionary = baglam.get("bayraklar", {})
		var b_ad = kosul.get("gerekli_bayrak")
		if not bayraklar.get(b_ad, false):
			return false

	# 4. Panik kilidi: Panikte ikna ve gözdağı kapanır, Final_Ret yolu açık kalır
	if baglam.get("panik", false) or panik_durumu:
		if kosul.get("eylem_turu", "") in ["ikna", "gozdagi"]:
			return false

	# 5. Final_Ret kilidi
	if kosul.get("final_ret", false) and not baglam.get("final_ret_uygun", true):
		return false

	# 6. Karar kısıtı
	if kosul.has("karar_kisiti") and not baglam.get(kosul.get("karar_kisiti"), false):
		return false

	# 7. Söylenen geçmişi koşulu (DIY-18)
	if kosul.has("gerekli_soylenen"):
		var beklenen = kosul.get("gerekli_soylenen")
		if not hafiza_soylenen.has(beklenen):
			return false

	return true


func sec(secenek_id: String, baglam: Dictionary = {}) -> Dictionary:
	if sustu or aktif_dugum == null:
		return {}

	# İtiraf seçilmişse
	if secenek_id == "sec_itiraf":
		if dugumler.has("yuzlesme"):
			aktif_dugum = dugumler["yuzlesme"]
			_satiri_isle(aktif_dugum, baglam)
			return {"basarili": true, "hedef": "yuzlesme", "itiraf": true}
		return {}

	var secilen_secenek: Dictionary = {}
	for s in aktif_dugum.secenekler:
		if str(s.get("id", "")) == secenek_id:
			secilen_secenek = s
			break

	if secilen_secenek.is_empty():
		return {}

	var hedef_id: String = str(secilen_secenek.get("hedef", ""))

	# Söz Kesme mekaniği (DIY-18)
	if secilen_secenek.get("kesme", false):
		son_satir = son_satir + "—"
		sabir += 1
		guven = clampi(guven - 1, 0, 10)
		kesilen_dugumler.append(hedef_id)
		return {
			"kesildi": true,
			"satir": son_satir,
			"sabir": sabir,
			"guven": guven
		}

	# Karşı soru ve muhafız beyanı (DIY-18)
	if secilen_secenek.has("muhafiz_cevabi"):
		var m_cev = str(secilen_secenek.get("muhafiz_cevabi"))
		hafiza_soylenen[m_cev] = true

	# Güven ve korku etkileri
	if secilen_secenek.has("guven_degisim"):
		guven = clampi(guven + int(secilen_secenek.get("guven_degisim")), 0, 10)
	if secilen_secenek.has("korku_degisim"):
		korku = clampi(korku + int(secilen_secenek.get("korku_degisim")), 0, 10)

	# Sabır maliyeti
	if secilen_secenek.get("sabir_harca", true):
		sabir = maxi(sabir - 1, 0)

	# Etkileri tekil uygula (DIY-02 Kural 1 & Kabul)
	var etkiler: Dictionary = secilen_secenek.get("etkiler", {})
	var uygulanan := _etkileri_uygula(secenek_id, etkiler, baglam)

	if not dugumler.has(hedef_id):
		if hedef_id == "veda":
			veda_edildi = true
			return {"veda": true, "uygulanan_etkiler": uygulanan}
		# Hedef yoksa sahne sustu ile kapanır
		sustu = true
		return {"sustu": true}

	aktif_dugum = dugumler[hedef_id]

	# Konu katmanı takibi (DIY-04)
	if not aktif_dugum.konu.is_empty():
		var k_id := aktif_dugum.konu
		var k_katman: int = int(konu_katmanlari.get(k_id, 0)) + 1
		konu_katmanlari[k_id] = k_katman
		aktif_dugum.katman = k_katman

	_satiri_isle(aktif_dugum, baglam)

	if aktif_dugum.son_dugum or hedef_id == "veda":
		veda_edildi = true

	return {
		"basarili": true,
		"hedef": hedef_id,
		"satir": son_satir,
		"guven": guven,
		"korku": korku,
		"sabir": sabir,
		"uygulanan_etkiler": uygulanan
	}


func _etkileri_uygula(sec_id: String, etkiler: Dictionary, _baglam: Dictionary) -> Dictionary:
	# Bir seçimin sonucu yalnızca 1 kez uygulanır
	if uygulanan_etkiler.has(sec_id) or etkiler.is_empty():
		return {}

	var kurallar := SozSemasi.kurallari_oku()
	var izinli: Array = kurallar.get("izinli_etki_alanlari", [])
	var gerceklesen: Dictionary = {}

	for anahtar in etkiler.keys():
		var a_str := str(anahtar)
		if not (a_str in izinli):
			hatalar.append("gecersiz_etki_anahtari_%s" % a_str)
			continue
		gerceklesen[a_str] = etkiler[anahtar]

	uygulanan_etkiler[sec_id] = gerceklesen
	return gerceklesen


## Çelişki ve Yüzleşme (DIY-07 / DYL-01)
func celiski() -> RefCounted:
	if _celiski == null:
		_celiski = preload("res://src/soz/celiski.gd").new()
		for c in celiskiler:
			_celiski.celiski_ekle(String(c.get("a", "")), String(c.get("b", "")), String(c.get("dal", "yuzlesme")), String(c.get("guc", "guclu")))
	return _celiski


func celiski_yuzlestir(beyan_id_1: String, beyan_id_2: String) -> Dictionary:
	var durum := celiski()
	if not durum.kayitlari_al(self).is_empty():
		var sonuc: Dictionary = durum.yuzles(beyan_id_1, beyan_id_2, {"motor": self})
		if String(sonuc.get("sebep", "")) != "kayit_bulunamadi":
			return sonuc
	var b1: Dictionary = {}
	var b2: Dictionary = {}
	for b in beyan_defteri:
		if str(b.get("id")) == beyan_id_1:
			b1 = b
		if str(b.get("id")) == beyan_id_2:
			b2 = b

	if b1.is_empty() or b2.is_empty():
		return {"basarili": false, "sebep": "beyan_bulunamadi"}

	var celiski_var: bool = (b1.get("dogru") != b2.get("dogru")) or (b1.has("celisir_ile") and b1.get("celisir_ile") == beyan_id_2)

	if celiski_var:
		if dugumler.has("yuzlesme"):
			aktif_dugum = dugumler["yuzlesme"]
			_satiri_isle(aktif_dugum, {})
			return {"basarili": true, "yuzlesme_acildi": true, "satir": son_satir}
		return {"basarili": true, "yuzlesme_acildi": false}
	else:
		guven = clampi(guven - 2, 0, 10)
		sabir = maxi(sabir - 1, 0)
		return {"basarili": false, "sebep": "celiski_yok", "guven": guven, "sabir": sabir}


func selam_yeniden_okunur() -> bool:
	return not selam_okundu


func zar_kaydet(deger: int) -> void:
	zar = deger
	_zar_kayitli = true


## Kayıtlı zar varsa yeni atış yoktur.
func zar_at(rng: RandomNumberGenerator) -> int:
	if _zar_kayitli:
		return zar
	zar = rng.randi_range(1, 6)
	_zar_kayitli = true
	return zar


## Kuyruktaki kişilerin dosyaları açılır. Katalogun geri kalanı bu yüklemede açılmaz.
func gece_dosyalarini_ac(kuyruk: Array, katalog_yollari: Dictionary) -> int:
	_acilan = PackedStringArray()
	for kisi in kuyruk:
		if _acilan.size() >= kuyruk.size():
			break
		var yol := String(katalog_yollari.get(String(kisi), "")).strip_edges()
		if yol.is_empty():
			continue
		_acilan.append(yol)
	return _acilan.size()


func acilan_dosyalar() -> PackedStringArray:
	return _acilan.duplicate()


static func gecis_kisileri(yol: String = GECIS_YOLU) -> Array:
	if not FileAccess.file_exists(yol):
		return []
	var okunan: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
	if okunan is Dictionary and okunan.get("yeni_motor") is Array:
		return (okunan["yeni_motor"] as Array).duplicate()
	return []


## Geçiş tablosundaki kişi için eski sıra yok sayılır. Tabloda olmayan kişi eski sırasından devam eder.
static func sira_etkin(kisi: String, sira: int, tablo: Array) -> int:
	if tablo.has(kisi):
		return -1
	return sira


## Kayıtlı bağlamın satır kimliklerini yeniden oynatır. Metin üretmez.
static func oynat(kayit: Dictionary) -> PackedStringArray:
	var sonuc := PackedStringArray()
	var satirlar: Variant = kayit.get("satirlar", [])
	if satirlar is Array:
		for satir in satirlar:
			sonuc.append(String(satir))
	return sonuc


static func etkiler_ayni(beklenen: Dictionary, gelen: Dictionary) -> bool:
	return beklenen == gelen


## KLT-54: koşulu tutan ilk seçeneğin kimliği. Metin okumaz.
static func secim_kimligi(baglam: Dictionary) -> String:
	var secenekler: Variant = baglam.get("secenekler", [])
	if not secenekler is Array or secenekler.is_empty():
		return ""
	var bayraklar: Dictionary = baglam.get("bayraklar", {}) if baglam.get("bayraklar") is Dictionary else {}
	for secenek in secenekler:
		if not secenek is Dictionary:
			continue
		var kosul: Dictionary = secenek.get("kosul", {}) if secenek.get("kosul") is Dictionary else {}
		var olur := true
		for ad in kosul.keys():
			if bool(bayraklar.get(ad, false)) != bool(kosul[ad]):
				olur = false
				break
		if olur:
			return String(secenek.get("id", ""))
	return String((secenekler[0] as Dictionary).get("id", "")) if secenekler[0] is Dictionary else ""


func _zar_oku(veri: Dictionary) -> void:
	if veri.has("zar") and (veri["zar"] is int or veri["zar"] is float) and is_finite(float(veri["zar"])):
		zar = int(veri["zar"])
		_zar_kayitli = true
	else:
		_zar_kayitli = false
		zar = -1

# Kapıdaki her ziyaret kendi motorunu taşır. Soru yanıtı, seçenek ve karar aynı düğüm yürütücüsünden geçer.
var kapi_izi: Dictionary = {"satirlar": [], "secimler": [], "karar": "", "sonuc": {}}


func kapi_satir(anahtar: String) -> String:
	if anahtar.is_empty():
		return ""
	var satir := kapi_metni(anahtar)
	aktif_dugum = SozDugumu.new("kapi_satir", {"satir": satir})
	_satiri_isle(aktif_dugum, {})
	if anahtar not in kapi_izi.satirlar:
		kapi_izi.satirlar.append(anahtar)
	return mevcut_satir()


func kapi_secim(tur: String, kimlik: String, cevap: String = "") -> String:
	var hedef := "kapi_" + tur
	dugumler[hedef] = SozDugumu.new(hedef, {"satir": kapi_metni(cevap)})
	aktif_dugum = SozDugumu.new("kapi_secim", {"secenekler": [
		{"id": kimlik, "hedef": hedef, "sabir_harca": false}
	]})
	var sonuc := sec(kimlik)
	if bool(sonuc.get("basarili", false)):
		kapi_izi.secimler.append({"tur": tur, "id": kimlik})
	if not cevap.is_empty() and cevap not in kapi_izi.satirlar:
		kapi_izi.satirlar.append(cevap)
	return mevcut_satir()


static func kapi_metni(anahtar: String) -> String:
	if not GuvenliMetin.anahtar_gibi_mi(anahtar):
		return anahtar
	var ceviri := String(TranslationServer.translate(anahtar))
	return GuvenliMetin.metin(anahtar) if ceviri == anahtar else ceviri


func kapi_soru_acik(gelen: Object, indeks: int, sorulan: Array, azami: int) -> bool:
	if indeks < 0 or indeks >= gelen.sorular.size() or indeks in sorulan or sorulan.size() >= gelen.soru_siniri(azami):
		return false
	var ust: int = gelen.soru_ust[indeks] if indeks < gelen.soru_ust.size() else -1
	return ust < 0 or ust in sorulan


func kapi_soru(gelen: Object, indeks: int) -> String:
	gelen.soru_soruldu(indeks)
	return kapi_secim("soru", str(indeks), gelen.sorular[indeks][1])


func kapi_chr_secim(tur: String, kimlik: String, uygula: Callable) -> bool:
	if not uygula.call():
		return false
	kapi_secim(tur, kimlik)
	return true


func kapi_karar(anahtar: StringName, uygula: Callable, yonetim: Object, etki_grubu: String) -> Dictionary:
	kapi_secim("karar", String(anahtar))
	var sonuc: Dictionary = uygula.call()
	if not bool(sonuc.get("engellendi", false)):
		kapi_izi.karar = String(anahtar)
		kapi_izi.sonuc = {
			"kaldi": bool(sonuc.get("kaldi", false)),
			"koylu_id": int(sonuc.get("koylu_id", -1)),
			"durum": String(sonuc.get("durum", "")),
		}
		if kapi_izi.has("ziyaret"):
			kapi_izi.sonuc.merge(_kapi_etkisi(yonetim, etki_grubu, String(anahtar)))
	return sonuc


func _kapi_etkisi(yonetim: Object, grup: String, anahtar: String) -> Dictionary:
	var kurallar: Dictionary = SozSemasi.kurallari_oku().get("kapi_karar_etkileri", {})
	var etki: Dictionary = kurallar.get(grup, {}).get(anahtar, {})
	if etki.is_empty() or yonetim.koylular.is_empty():
		return {}
	var kisi: Object = yonetim.koylular[0]
	for koylu in yonetim.koylular:
		if koylu.sinif == StringName(etki.sinif):
			kisi = koylu
			break
	var once: float = kisi.is_gucu
	kisi.is_gucu = minf(once, float(etki.is_gucu_tavan))
	return {"debuff_koylu_id": kisi.id, "is_gucu_once": once, "is_gucu_sonra": kisi.is_gucu}
