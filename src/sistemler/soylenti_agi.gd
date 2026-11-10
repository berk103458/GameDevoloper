# gdlint: disable=max-line-length
class_name SoylentiAgi
extends RefCounted

## BÖLÜM 37: Söylenti, dedikodu ve kamuoyu ağı (SOY-01 … SOY-50).
## Dedikodu motorunu (DIY-13) genişletir; kaynağı, yolu, doğruluğu,
## kaynak güvenilirliğini, kamuoyuna dönüşmeyi ve bar etkilerini yönetir.

const SOYLENTI_VERI_YOLU := "res://data/soylenti.json"
const DedikoduMotoru = preload("res://src/sistemler/dedikodu.gd")

var dedikodu: RefCounted
var veri_yapilandirma: Dictionary = {}

# Söylenti ağı kayıtları: olay_id -> Dictionary
var ag_kayitlari: Dictionary = {}
# Köylü güvenilirlik sözlüğü: koylu_id -> int
var guvenilirlikler: Dictionary = {}

var bar_degisimi_toplam: int = 0
var histeri_tetik_sayisi: int = 0
var teftis_sorulari: Array[String] = []

func _init(p_dedikodu: RefCounted = null) -> void:
	if p_dedikodu != null:
		dedikodu = p_dedikodu
	else:
		dedikodu = DedikoduMotoru.new()
	_yapilandirmayi_yukle()

func _yapilandirmayi_yukle() -> void:
	var dosya := FileAccess.open(SOYLENTI_VERI_YOLU, FileAccess.READ)
	if dosya:
		var parsed = JSON.parse_string(dosya.get_as_text())
		if parsed is Dictionary:
			veri_yapilandirma = parsed

## SOY-38: ağın bütün ayar sayıları `data/soylenti.json`'dadır; eksik alan sessizce varsayılana düşmez.
func _ayar(ad: String) -> float:
	if not veri_yapilandirma.has(ad):
		push_error("soylenti.json alanı eksik: " + ad)
		return 0
	return float(veri_yapilandirma[ad])

## SOY-01, SOY-03, SOY-04: Söylenti ekleme.
func soylenti_ekle(
	olay_id: String,
	tur: String,
	tanik: String,
	dogru: bool = true,
	ek: Dictionary = {}
) -> Dictionary:
	var temiz_id := olay_id.strip_edges()
	var ek_kopya := ek.duplicate(true)
	ek_kopya["kaynak"] = tanik
	ek_kopya["dogru"] = dogru

	var dedikodu_sonuc: Dictionary = dedikodu.olay_kaydet(
		temiz_id,
		tur,
		int(ek.get("gece", 1)),
		tanik,
		int(ek.get("gecikme", 1)),
		ek_kopya
	)

	if not dedikodu_sonuc.get("olur", false) and not ag_kayitlari.has(temiz_id):
		# Dedikodu doğrudan kabul etmese bile (örneğin iyi_olay ise) ağ kaydı açılabilir
		if not (tur in veri_yapilandirma.get("iyi_olaylar", [])):
			return dedikodu_sonuc

	var duyan_dizi: Array[String] = []
	if not tanik.is_empty():
		duyan_dizi.append(tanik)

	var ag_kaydi := {
		"olay_id": temiz_id,
		"tur": tur,
		"kaynak": tanik,
		"dogru": dogru,
		"duyanlar": duyan_dizi,
		"gece": int(ek.get("gece", 1)),
		"omur": 0,
		"kamuoyu_oldu": false,
		"kamuoyu_gecesi": 0,
		"hukme_baglandi": false,
		"susturuldu": false,
		"bar_etkisi_uygulandi": false
	}
	ag_kayitlari[temiz_id] = ag_kaydi

	if not guvenilirlikler.has(tanik) and not tanik.is_empty():
		guvenilirlikler[tanik] = int(_ayar("varsayilan_guvenilirlik"))

	return { "olur": true, "kayit": ag_kaydi }

## SOY-01: DIY-13 kaydının kaynağı ve doğruluğu; ağda karşılığı olmayan eski kayıt kaynaksız ve doğru sayılır.
func kaynak_ve_dogruluk(olay_id: String) -> Dictionary:
	var k: Dictionary = ag_kayitlari.get(olay_id, {})
	return {"kaynak": String(k.get("kaynak", "")), "dogru": bool(k.get("dogru", true))}

## SOY-07 & SOY-08: Köylü söz güvenilirliği (0..3).
func guvenilirlik_al(koylu_id: String) -> int:
	return int(guvenilirlikler.get(koylu_id, _ayar("varsayilan_guvenilirlik")))

func guvenilirlik_degistir(koylu_id: String, delta: int) -> int:
	var mevcut := guvenilirlik_al(koylu_id)
	var asgari := int(_ayar("asgari_guvenilirlik"))
	var azami := int(_ayar("azami_guvenilirlik"))
	var yeni := clampi(mevcut + delta, asgari, azami)
	guvenilirlikler[koylu_id] = yeni
	return yeni

func guvenilirlik_kelimesi(koylu_id: String) -> String:
	var g := guvenilirlik_al(koylu_id)
	if g >= int(_ayar("azami_guvenilirlik")):
		return "ağzı sıkı"
	if g == _ayar("varsayilan_guvenilirlik"):
		return "konuşkan"
	return "uyduruyor"

## SOY-02, SOY-05, SOY-06, SOY-12, SOY-13, SOY-16, SOY-40: Gece ilerletme ve yayılım.
func gece_ilerlet(
	guncel_gece: int,
	koy_nufusu: int = 10,
	komsuluklar: Dictionary = {},
	calisma_arkadaslari: Dictionary = {}
) -> void:
	dedikodu.gece_ilerlet(guncel_gece)

	var asgari_nufus := int(_ayar("asgari_nufus"))
	var yayilim_hizi := int(_ayar("yayilim_hizi_gece_basi_azami"))
	var kamuoyu_esik_oran := _ayar("kamuoyu_esigi_oran")
	var ag_omru := int(_ayar("ag_kayit_omru_gece"))
	var kamuoyu_omru := int(_ayar("kamuoyu_omru_gece"))
	var iyi_olaylar: Array = veri_yapilandirma.get("iyi_olaylar", [])

	var silinecekler: Array[String] = []

	for olay_id in ag_kayitlari:
		var k: Dictionary = ag_kayitlari[olay_id]
		k["omur"] = int(k.get("omur", 0)) + 1

		# SOY-06: 7 geceden sonra ağ kaydı düşer
		if int(k["omur"]) > ag_omru:
			silinecekler.append(olay_id)
			continue

		# SOY-40: Küçük köyde ağ susar (nüfus < 5 ise yayılım ve kamuoyu 0)
		if koy_nufusu < asgari_nufus:
			continue

		# SOY-20: Susturulduysa yayılım durur
		if bool(k.get("susturuldu", false)) or bool(k.get("hukme_baglandi", false)):
			continue

		# SOY-02: Duyanlar kümesi genişler (komşular ve iş arkadaşları)
		var duyanlar: Array = k.get("duyanlar", [])
		var yeni_duyanlar: Array[String] = []

		for duyan in duyanlar:
			var komsular: Array = komsuluklar.get(duyan, [])
			for koms in komsular:
				var koms_str := str(koms)
				if not (koms_str in duyanlar) and not (koms_str in yeni_duyanlar):
					yeni_duyanlar.append(koms_str)
					if yeni_duyanlar.size() >= yayilim_hizi:
						break
			if yeni_duyanlar.size() >= yayilim_hizi:
				break

			var arkadaslar: Array = calisma_arkadaslari.get(duyan, [])
			for ark in arkadaslar:
				var ark_str := str(ark)
				if not (ark_str in duyanlar) and not (ark_str in yeni_duyanlar):
					yeni_duyanlar.append(ark_str)
					if yeni_duyanlar.size() >= yayilim_hizi:
						break
			if yeni_duyanlar.size() >= yayilim_hizi:
				break

		# Eğer komsuluk verilmemişse nüfustan temsili köylüler eklenir; gerçek harita varken uydurma ad yok (SOY-45)
		if komsuluklar.is_empty() and calisma_arkadaslari.is_empty() and yeni_duyanlar.is_empty() and duyanlar.size() < koy_nufusu:
			for i in range(1, koy_nufusu + 1):
				var aday := "koylu_%d" % i
				if not (aday in duyanlar):
					yeni_duyanlar.append(aday)
					if yeni_duyanlar.size() >= yayilim_hizi:
						break

		for yd in yeni_duyanlar:
			duyanlar.append(yd)
		k["duyanlar"] = duyanlar

		# SOY-12: Kamuoyu konusu olma kontrolü (>= %40)
		var gereken_kisi := int(ceil(float(koy_nufusu) * kamuoyu_esik_oran))
		if duyanlar.size() >= gereken_kisi and not bool(k.get("kamuoyu_oldu", false)):
			k["kamuoyu_oldu"] = true
			k["kamuoyu_gecesi"] = guncel_gece

			# SOY-13 & SOY-17: Bar etkisi yalnız kamuoyu olunca bir kez uygulanır
			if not bool(k.get("bar_etkisi_uygulandi", false)):
				k["bar_etkisi_uygulandi"] = true
				var tur := str(k.get("tur", ""))
				if tur in iyi_olaylar:
					bar_degisimi_toplam += int(_ayar("iyi_olay_bar_etkisi"))
				else:
					bar_degisimi_toplam += int(_ayar("bar_etkisi_halk"))

			# SOY-15: Yanlış söylenti kamuoyu olursa histeri sayacını artırır
			if not bool(k.get("dogru", true)):
				histeri_tetik_sayisi += 1

			# SOY-22: Tanıklı rüşvet kamuoyu olunca teftişe eklenir
			if str(k.get("tur", "")) == "rusvet":
				teftis_sorulari.append(olay_id)

		# SOY-16: Kamuoyu 5 gece sonra söner
		if bool(k.get("kamuoyu_oldu", false)):
			var kamuoyu_yasi := guncel_gece - int(k.get("kamuoyu_gecesi", guncel_gece))
			if kamuoyu_yasi >= kamuoyu_omru:
				k["kamuoyu_oldu"] = false

	for s in silinecekler:
		ag_kayitlari.erase(s)

## SOY-12 & SOY-33: Çınar meclisi için canlı kamuoyu konusu seçimi.
func meclis_sikayeti_sec() -> Dictionary:
	for olay_id in ag_kayitlari:
		var k: Dictionary = ag_kayitlari[olay_id]
		if bool(k.get("kamuoyu_oldu", false)) and not bool(k.get("hukme_baglandi", false)):
			return {
				"olay_id": olay_id,
				"tur": k.get("tur", ""),
				"kaynak": k.get("kaynak", ""),
				"duyan_sayisi": (k.get("duyanlar", []) as Array).size()
			}
	return {}

## SOY-21: Divan hükmü verilince kamuoyu konusu kapanır.
func divan_hukmu_ver(olay_id: String) -> void:
	if ag_kayitlari.has(olay_id):
		var k: Dictionary = ag_kayitlari[olay_id]
		k["hukme_baglandi"] = true
		k["kamuoyu_oldu"] = false

## SOY-SON-01: Söylentinin somut kapanış olayı karşılığı
const SOYLENTI_KAPANISLARI := {
	"degirmen_un": "soylenti_degirmen_kapanis",
	"kuyu_zehir": "soylenti_kuyu_kapanis",
	"tekfur_altin": "soylenti_tekfur_araba_kapanis",
	"mogol_casus": "soylenti_mogol_casus_kapanis",
	"vebali_kumas": "soylenti_vebali_kumas_kapanis"
}

func soylenti_kapanis_olayi_al(olay_id: String) -> String:
	return SOYLENTI_KAPANISLARI.get(olay_id, "")

func soylenti_kapanisi_uygula(olay_id: String, cozum_secimi: String = "adalet") -> Dictionary:
	if not ag_kayitlari.has(olay_id):
		return {"cozuldu": false}
	var k: Dictionary = ag_kayitlari[olay_id]
	k["hukme_baglandi"] = true
	k["kamuoyu_oldu"] = false
	k["cozuldu"] = true
	k["cozum_secimi"] = cozum_secimi
	if cozum_secimi == "adalet":
		dogru_soylenti_dogrulandi(olay_id)
	else:
		yanlis_soylenti_dogrulandi(olay_id)
	return {
		"cozuldu": true,
		"olay_id": olay_id,
		"kapanis": soylenti_kapanis_olayi_al(olay_id)
	}

## SOY-11: Yanlış ve doğru söylenti doğrulama.
func yanlis_soylenti_dogrulandi(olay_id: String) -> void:
	if ag_kayitlari.has(olay_id):
		var kaynak := str(ag_kayitlari[olay_id].get("kaynak", ""))
		if not kaynak.is_empty():
			guvenilirlik_degistir(kaynak, -int(_ayar("dogrulama_guvenilirlik_degisimi")))

func dogru_soylenti_dogrulandi(olay_id: String) -> void:
	if ag_kayitlari.has(olay_id):
		var kaynak := str(ag_kayitlari[olay_id].get("kaynak", ""))
		if not kaynak.is_empty():
			guvenilirlik_degistir(kaynak, int(_ayar("dogrulama_guvenilirlik_degisimi")))

## SOY-20: Susturma eylemi.
func sustur(koylu_id: String, olay_id: String) -> bool:
	var g := guvenilirlik_al(koylu_id)
	if ag_kayitlari.has(olay_id):
		if g >= _ayar("varsayilan_guvenilirlik"):
			ag_kayitlari[olay_id]["susturuldu"] = true
			return true
		else:
			# Düşük güvenilirlikte susturma ters teper, yayılım hızlanır
			return false
	return false

## SOY-23: Söz motoru için bağlam sorgusu.
func baglam_sorgusu_al(koylu_id: String, olay_id: String) -> Dictionary:
	if not ag_kayitlari.has(olay_id):
		return { "duydu": false, "dogru": false, "kaynak": "" }
	var k: Dictionary = ag_kayitlari[olay_id]
	var duyanlar: Array = k.get("duyanlar", [])
	return {
		"duydu": koylu_id in duyanlar,
		"dogru": bool(k.get("dogru", true)),
		"kaynak": str(k.get("kaynak", ""))
	}

## SOY-29: Defter için söylenti sayfası.
func soylenti_sayfasi_al(koy_nufusu: int = 10) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	for olay_id in ag_kayitlari:
		var k: Dictionary = ag_kayitlari[olay_id]
		var duyan_sayisi: int = (k.get("duyanlar", []) as Array).size()
		var kademe := "birkaç"
		if duyan_sayisi >= int(ceil(float(koy_nufusu) * _ayar("kademe_herkes_orani"))):
			kademe = "herkes"
		elif duyan_sayisi >= int(ceil(float(koy_nufusu) * _ayar("kademe_yari_koy_orani"))):
			kademe = "yarı köy"

		sonuc.append({
			"olay": olay_id,
			"kaynak": str(k.get("kaynak", "")),
			"kademe": kademe,
			"dogrulandi": bool(k.get("dogru", true))
		})
	return sonuc

## SOY-30: HUD kamuoyu şeridi tek satırı.
func kamuoyu_hud_satiri_al() -> String:
	for olay_id in ag_kayitlari:
		var k: Dictionary = ag_kayitlari[olay_id]
		if bool(k.get("kamuoyu_oldu", false)) and not bool(k.get("hukme_baglandi", false)):
			return "Köy %s konusunu konuşuyor." % str(k.get("tur", "bir olayı"))
	return ""

## SOY-42: KAY zinciri kayıt alma ve yükleme.
func kayit_verisi_al() -> Dictionary:
	return {
		"ag_kayitlari": ag_kayitlari.duplicate(true),
		"guvenilirlikler": guvenilirlikler.duplicate(true),
		"bar_degisimi_toplam": bar_degisimi_toplam,
		"histeri_tetik_sayisi": histeri_tetik_sayisi,
		"teftis_sorulari": teftis_sorulari.duplicate()
	}

func kayit_verisi_yukle(veri: Dictionary) -> void:
	ag_kayitlari = (veri.get("ag_kayitlari", {}) as Dictionary).duplicate(true)
	guvenilirlikler = (veri.get("guvenilirlikler", {}) as Dictionary).duplicate(true)
	bar_degisimi_toplam = int(veri.get("bar_degisimi_toplam", 0))
	histeri_tetik_sayisi = int(veri.get("histeri_tetik_sayisi", 0))
	teftis_sorulari.assign(veri.get("teftis_sorulari", []))
