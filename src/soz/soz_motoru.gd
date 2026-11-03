# gdlint: disable=max-line-length
class_name SozMotoru
extends RefCounted

## DIY-02 / DIY-03 / DIY-04 / DIY-05 / DIY-06 / DIY-07 / DIY-10 / DIY-17 / DIY-18
## Söz motoru çekirdeği — düğüm yürütücü, konu merkezi ve sorgu mekaniği.

const SozSemasi = preload("res://src/soz/soz_semasi.gd")
const SozDugumu = preload("res://src/soz/soz_dugumu.gd")
const SatirSecici = preload("res://src/soz/satir_secici.gd")

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
var uygulanan_etkiler: Dictionary = {}
var kesilen_dugumler: Array[String] = []
var hafiza_soylenen: Dictionary = {}

# Konu ve Derinleşme Takibi
var konu_katmanlari: Dictionary = {} # konu_id -> int
var selam_tamamlandi: bool = false
var panik_durumu: bool = false

var hatalar: Array[String] = []

func yukle(dosya: Dictionary, baglam: Dictionary = {}) -> bool:
	hatalar.clear()
	dugumler.clear()
	beyan_defteri.clear()
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
		sabir = maxi(sabir - 1, 0)

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

func _etkileri_uygula(sec_id: String, etkiler: Dictionary, baglam: Dictionary) -> Dictionary:
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
func celiski_yuzlestir(beyan_id_1: String, beyan_id_2: String) -> Dictionary:
	var b1: Dictionary = {}
	var b2: Dictionary = {}
	for b in beyan_defteri:
		if str(b.get("id")) == beyan_id_1:
			b1 = b
		if str(b.get("id")) == beyan_id_2:
			b2 = b

	if b1.is_empty() or b2.is_empty():
		return {"basarili": false, "sebep": "beyan_bulunamadi"}

	# Eğer biri yalan, biri doğru veya ikisi çelişkiliyse yüzleşme açılır
	var celiski_var := (b1.get("dogru") != b2.get("dogru")) or (b1.has("celisir_ile") and b1.get("celisir_ile") == beyan_id_2)

	if celiski_var:
		if dugumler.has("yuzlesme"):
			aktif_dugum = dugumler["yuzlesme"]
			_satiri_isle(aktif_dugum, {})
			return {"basarili": true, "yuzlesme_acildi": true, "satir": son_satir}
		return {"basarili": true, "yuzlesme_acildi": false}
	else:
		# Yanlış eşleştirme güveni düşürür
		guven = clampi(guven - 1, 0, 10)
		return {"basarili": false, "sebep": "celiski_yok", "guven": guven}
