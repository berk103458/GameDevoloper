# gdlint: disable=max-line-length
class_name SoylentiAgi
extends RefCounted

## BÖLÜM 37: Söylenti, dedikodu ve kamuoyu ağı (SOY-01 … SOY-50).
## Dedikodu motorunu (DIY-13) genişletir; kaynağı, yolu, doğruluğu,
## kaynak güvenilirliğini, kamuoyuna dönüşmeyi ve bar etkilerini yönetir.

const SOYLENTI_VERI_YOLU := "res://data/soylenti.json"
const DIS_SOYLENTI_VERI_YOLU := "res://data/soz/dis_soylenti.json"
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

## SOY-01, SOY-03, SOY-04, SOY-25: Söylenti ekleme.
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

	# SOY-SON-01: kritik söylenti muhafızın fiili değildir, DIY-13 dedikodu kapısından geçmez.
	var kritik := bool(ek.get("kritik", false))
	var dis_soylenti := tur == "dunya_haberi" or bool(ek.get("dis_soylenti", false))
	var koy_olayi: bool = tur in (veri_yapilandirma.get("koy_olay_turleri", []) as Array)
	if koy_olayi and (temiz_id.is_empty() or tanik.is_empty() or ag_kayitlari.has(temiz_id)):
		return dedikodu_sonuc
	if not kritik and not koy_olayi and not dedikodu_sonuc.get("olur", false) and not ag_kayitlari.has(temiz_id):
		# Dedikodu doğrudan kabul etmese bile (örneğin iyi_olay ise) ağ kaydı açılabilir
		if not (tur in veri_yapilandirma.get("iyi_olaylar", [])) and not dis_soylenti:
			return dedikodu_sonuc

	var kayit_id := temiz_id
	if dis_soylenti and ag_kayitlari.has(temiz_id):
		var mevcut_kaynak := String(ag_kayitlari[temiz_id].get("kaynak", ""))
		if not tanik.is_empty() and tanik != mevcut_kaynak:
			kayit_id = "%s~%s" % [temiz_id, tanik]

	var duyan_dizi: Array[String] = []
	if not tanik.is_empty():
		duyan_dizi.append(tanik)

	var dis_olay := String(ek.get("olay", temiz_id)).strip_edges()
	var satir_metni := String(ek.get("satir", ek.get("metin", ""))).strip_edges()
	if dis_soylenti and satir_metni.is_empty():
		satir_metni = dis_soylenti_metni(dis_olay, dogru)

	var ag_kaydi := {
		"olay_id": kayit_id,
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
	if dis_soylenti:
		ag_kaydi["dis_soylenti"] = true
		ag_kaydi["olay"] = dis_olay
		if kayit_id != temiz_id:
			ag_kaydi["asil"] = temiz_id
	if not satir_metni.is_empty():
		ag_kaydi["satir"] = satir_metni
	if not String(ek.get("meslek", "")).is_empty():
		ag_kaydi["meslek"] = String(ek.get("meslek", ""))
	if not String(ek.get("hedef", "")).is_empty():
		ag_kaydi["hedef"] = String(ek.get("hedef", ""))
	if kritik:
		ag_kaydi["kritik"] = true
	ag_kayitlari[kayit_id] = ag_kaydi

	if not guvenilirlikler.has(tanik) and not tanik.is_empty():
		guvenilirlikler[tanik] = int(_ayar("varsayilan_guvenilirlik"))

	return { "olur": true, "kayit": ag_kaydi }


## SOY-25: dünya olayına bağlı tüm dış söylenti satırlarını (doğru ve yanlış kaynaklarıyla) döner.
func olay_satirlari(olay_id: String) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	var hedef := olay_id.strip_edges()
	if hedef.is_empty():
		return sonuc
	for k in ag_kayitlari.values():
		if not (k is Dictionary):
			continue
		var kd := k as Dictionary
		if String(kd.get("olay_id", "")) == hedef or String(kd.get("asil", "")) == hedef or String(kd.get("olay", "")) == hedef:
			sonuc.append(kd)
	return sonuc


## SOY-25: Söz dosyasından (dis_soylenti.json) dış dünya söylentisi satırı çözer.
static func dis_soylenti_metni(olay_id: String, dogru: bool) -> String:
	var yol := DIS_SOYLENTI_VERI_YOLU
	if not FileAccess.file_exists(yol):
		return ""
	var okunan: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
	if not (okunan is Dictionary):
		return ""
	var kok := okunan as Dictionary
	var olaylar: Dictionary = kok.get("olaylar", {})
	var kayit: Dictionary = olaylar.get(olay_id, kok.get("varsayilan", {}))
	var anahtar := String(kayit.get("dogru_anahtar" if dogru else "yanlis_anahtar", "")).strip_edges()
	if not anahtar.is_empty():
		var cevrilen := TranslationServer.translate(anahtar)
		if not cevrilen.is_empty() and cevrilen != anahtar:
			return cevrilen
	return String(kayit.get("varsayilan_dogru" if dogru else "varsayilan_yanlis", "")).strip_edges()

## SOY-01: DIY-13 kaydının kaynağı ve doğruluğu; ağda karşılığı olmayan eski kayıt kaynaksız ve doğru sayılır.
func kaynak_ve_dogruluk(olay_id: String) -> Dictionary:
	var k: Dictionary = ag_kayitlari.get(olay_id, {})
	return {"kaynak": String(k.get("kaynak", "")), "dogru": bool(k.get("dogru", true))}

func dogru_kayit_mi(olay_id: String) -> bool:
	return bool(kaynak_ve_dogruluk(olay_id).get("dogru", true))

func dogru_kayitlar() -> Dictionary:
	var sonuc := {}
	for olay_id in ag_kayitlari:
		var k: Variant = ag_kayitlari[olay_id]
		if k is Dictionary and bool((k as Dictionary).get("dogru", true)):
			sonuc[olay_id] = (k as Dictionary).duplicate(true)
	return sonuc

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
	var kopyalar: Array[Dictionary] = []

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
		var hiz := yayilim_hizi * (int(_ayar("susturma_ters_carpan")) if bool(k.get("hizlandi", false)) else 1)

		for duyan in duyanlar:
			var komsular: Array = komsuluklar.get(duyan, [])
			for koms in komsular:
				var koms_str := str(koms)
				if not (koms_str in duyanlar) and not (koms_str in yeni_duyanlar):
					yeni_duyanlar.append(koms_str)
					if yeni_duyanlar.size() >= hiz:
						break
			if yeni_duyanlar.size() >= hiz:
				break

			var arkadaslar: Array = calisma_arkadaslari.get(duyan, [])
			for ark in arkadaslar:
				var ark_str := str(ark)
				if not (ark_str in duyanlar) and not (ark_str in yeni_duyanlar):
					yeni_duyanlar.append(ark_str)
					if yeni_duyanlar.size() >= hiz:
						break
			if yeni_duyanlar.size() >= hiz:
				break

		# Eğer komsuluk verilmemişse nüfustan temsili köylüler eklenir; gerçek harita varken uydurma ad yok (SOY-45)
		if komsuluklar.is_empty() and calisma_arkadaslari.is_empty() and yeni_duyanlar.is_empty() and duyanlar.size() < koy_nufusu:
			for i in range(1, koy_nufusu + 1):
				var aday := "koylu_%d" % i
				if not (aday in duyanlar):
					yeni_duyanlar.append(aday)
					if yeni_duyanlar.size() >= hiz:
						break

		for yd in yeni_duyanlar:
			duyanlar.append(yd)
		k["duyanlar"] = duyanlar

		# SOY-05/44: doğru asıl kayıt her yeni duyanda bozulabilir; kopya `dogru=false`, kaynağı bozandır, asıl silinmez
		if bool(k.get("dogru", true)) and not k.has("asil") and not bool(k.get("kritik", false)):
			for yd in yeni_duyanlar:
				var bicim := bozulma_bicimi(olay_id, yd, guncel_gece)
				if not bicim.is_empty():
					kopyalar.append(_bozuk_kopya(k, olay_id, yd, bicim, guncel_gece))

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
			if not bool(k.get("dogru", true)) and not str(k.get("tur", "")) in iyi_olaylar:
				histeri_tetik_sayisi += 1

			# SOY-22: Tanıklı rüşvet kamuoyu olunca teftişe eklenir
			if str(k.get("tur", "")) == "rusvet" and bool(k.get("dogru", true)):
				teftis_sorulari.append(olay_id)

		# SOY-16: Kamuoyu 5 gece sonra söner
		if bool(k.get("kamuoyu_oldu", false)):
			var kamuoyu_yasi := guncel_gece - int(k.get("kamuoyu_gecesi", guncel_gece))
			if kamuoyu_yasi >= kamuoyu_omru:
				k["kamuoyu_oldu"] = false

	for s in silinecekler:
		ag_kayitlari.erase(s)
	for c in kopyalar:
		if not ag_kayitlari.has(c.olay_id):
			ag_kayitlari[c.olay_id] = c
			if not guvenilirlikler.has(c.kaynak):
				guvenilirlikler[c.kaynak] = int(_ayar("varsayilan_guvenilirlik"))

## SOY-05/41/44: bozulma zarı tohumdan bağımsız ve tekrarlanabilir (olay, bozan, gece); biçim veridedir.
func bozulma_bicimi(olay_id: String, bozan: String, gece: int) -> String:
	var olcek := int(_ayar("bozulma_zar_cozunurlugu"))
	var h := hash("%s|%s|%d" % [olay_id, bozan, gece])
	if olcek <= 0 or posmod(h, olcek) >= int(round(_ayar("bozulma_orani") * olcek)):
		return ""
	var bicimler: Array = (veri_yapilandirma.get("bozulma_kaliplari", {}) as Dictionary).keys()
	if bicimler.is_empty():
		return ""
	bicimler.sort()
	return String(bicimler[posmod(h / olcek, bicimler.size())])

func _bozuk_kopya(k: Dictionary, olay_id: String, bozan: String, bicim: String, gece: int) -> Dictionary:
	var kopya := {
		"olay_id": "%s~%s" % [olay_id, bozan],
		"asil": olay_id,
		"bicim": bicim,
		"tur": k.get("tur", ""),
		"kaynak": bozan,
		"dogru": false,
		"duyanlar": [bozan],
		"gece": gece,
		"omur": 0,
		"kamuoyu_oldu": false,
		"kamuoyu_gecesi": 0,
		"hukme_baglandi": false,
		"susturuldu": false,
		"bar_etkisi_uygulandi": true
	}
	if not str(k.get("hedef", "")).is_empty():
		kopya["hedef"] = str(k.get("hedef", ""))
	if not str(k.get("meslek", "")).is_empty():
		kopya["meslek"] = str(k.get("meslek", ""))
	return kopya

## SOY-34: iş kazası / ücret söylentisi kamuoyu olursa meslek grevi olasılık artışı döner.
func grev_olasilik_artisi(meslek: String = "") -> float:
	var turler: Array = veri_yapilandirma.get("grev_soylenti_turleri", [])
	for k in ag_kayitlari.values():
		if not (k is Dictionary) or not bool(k.get("kamuoyu_oldu", false)) or bool(k.get("hukme_baglandi", false)):
			continue
		if not (str(k.get("tur", "")) in turler):
			continue
		var hedef_meslek := str(k.get("meslek", ""))
		if meslek.is_empty() or hedef_meslek.is_empty() or hedef_meslek == meslek:
			return float(_ayar("grev_olasilik_artisi"))
	return float(0)


## SOY-35: hedefi belli yanlış söylentilerin ikili husumet artışlarını tek seferde toplar.
func yanlis_hedef_husumetleri_al() -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	var artis := int(_ayar("yanlis_soylenti_husumet_artisi"))
	for k in ag_kayitlari.values():
		if not (k is Dictionary) or bool(k.get("dogru", true)) or bool(k.get("husumet_islendi", false)):
			continue
		var kaynak := str(k.get("kaynak", "")).strip_edges()
		var hedef := str(k.get("hedef", "")).strip_edges()
		if kaynak.is_empty() or hedef.is_empty() or kaynak == hedef:
			continue
		k["husumet_islendi"] = true
		sonuc.append({"kaynak": kaynak, "hedef": hedef, "artis": artis})
	return sonuc


## SOY-36: "kervan_gelmeyecek" kamuoyu olunca bir gün pazar fiyat çarpanı aktif olur (yanlışsa ertesi gün biter).
func pazar_soylenti_aktif_mi(guncel_gun: int) -> bool:
	var pazar_tur := str(veri_yapilandirma.get("pazar_soylenti_turu", ""))
	var omur := int(_ayar("pazar_soylenti_gun_omru"))
	for k in ag_kayitlari.values():
		if not (k is Dictionary) or not bool(k.get("kamuoyu_oldu", false)) or bool(k.get("hukme_baglandi", false)):
			continue
		if str(k.get("tur", "")) != pazar_tur:
			continue
		var baslangic := int(k.get("etki_gunu", k.get("kamuoyu_gecesi", guncel_gun)))
		var yas := guncel_gun - baslangic
		if yas >= 0 and yas < omur:
			return true
	return false


## SOY-37: "yol_guvensiz" kamuoyu olunca o gece gelen sayısı -1 (doğruysa ertesi gün de).
func goc_gelen_farki(guncel_gun: int) -> int:
	var goc_tur := str(veri_yapilandirma.get("goc_soylenti_turu", ""))
	var azaltma := int(_ayar("goc_gelen_azaltma"))
	var dogru_sure := int(_ayar("goc_sure_dogru_gece"))
	var yanlis_sure := int(_ayar("goc_sure_yanlis_gece"))
	for k in ag_kayitlari.values():
		if not (k is Dictionary) or not bool(k.get("kamuoyu_oldu", false)) or bool(k.get("hukme_baglandi", false)):
			continue
		if str(k.get("tur", "")) != goc_tur:
			continue
		var baslangic := int(k.get("etki_gunu", k.get("kamuoyu_gecesi", guncel_gun)))
		var yas := guncel_gun - baslangic
		var sure := dogru_sure if bool(k.get("dogru", true)) else yanlis_sure
		if yas >= 0 and yas < sure:
			return -azaltma
	return 0


## SOY-12 & SOY-33: Çınar meclisi için canlı kamuoyu konusu seçimi.
func meclis_sikayeti_sec() -> Dictionary:
	for olay_id in ag_kayitlari:
		var k: Dictionary = ag_kayitlari[olay_id]
		if bool(k.get("kamuoyu_oldu", false)) and not bool(k.get("hukme_baglandi", false)) and not String(k.get("tur", "")) in veri_yapilandirma.get("iyi_olaylar", []) and not bool(k.get("kritik", false)):
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
			ag_kayitlari[olay_id]["hizlandi"] = true
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
