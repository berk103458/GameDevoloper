## KRI-03: mevcut Şifahane, ambar ve tek ölüm yoluna deterministik adaptör.
## CAT-03: kavga yaralısının (bizden veya yabancı) Şifahane ve hekim üzerinden tedavisi.
class_name HekimIlac
extends RefCounted
const HASTALIK_CARPANI := 0.20
const ILAC_SAGLIK := 25
const ERZAK_SAGLIK := 10
const YARA_GECE_KAYBI := 10

## KRI-15 bu tek reçete API'sinin girdisine ot ekleyebilir; ikinci üretim yok.
static func receteler() -> Dictionary:
	return {"bakim": {"girdi": {}, "uretim": {}}, "ilac": {"girdi": {"afyon": 1, "su": 1}, "uretim": {"ilac": 1}}}

## Ad/maske/bayrak üzerinden kimlik tahmini yapılmaz. Yalnız adsız legacy
## hekimlerde mevcut cerrah/otacı zanaatı ve ustalık durumu kullanılır.
static func yetkin(k: Koylu) -> bool:
	if k.adli_id != &"": return k.adli_id in [&"chr_008", &"chr_003"]
	return k.zanaat_turu in [ZanaatTuru.Tur.CERRAH, ZanaatTuru.Tur.OTACI] and k.usta_mi()

## Günlük tedavi makbuzu koruyucu yetkinliği tüketmez. Çalışabilir hekim,
## hazır bina ve mevcut hizmet engelleri aranır; hasta/izole hekim sayılmaz.
static func etkin(y: KoyYonetimi, bina_id: int = -1) -> bool:
	if y.son != &"" or y.isyan_kalan >= 0: return false
	for b in y.binalar:
		if bina_id >= 0 and b.id != bina_id: continue
		if b.tur != "sifahane" or not b.hazir() or KanDavasi.engel(y, b.id): continue
		for k in y.calisanlar(b.id):
			if yetkin(k) and Sifahane.hekim_calismaya_uygun(y, k, b): return true
	return false

## Sağlık tam sayı: aşağı yuvarlama köylü lehinedir (12→2, 8→1).
## Ölüm zarı/diriltme/ikinci tarama yok; diğer sağlık kayıplarına dokunmaz.
static func hastalik_kaybi(y: KoyYonetimi, kayip: int) -> int:
	return int(float(kayip) * HASTALIK_CARPANI) if etkin(y) else kayip

## Tek ortak tedavi kontenjanını çağıran tüketir. İlaç yoksa eski 2 erzak
## tedavisi aynen sürer; ilaç tek başına gizli hastalığı açığa çıkarmaz.
static func tedavi_bedeli(y: KoyYonetimi) -> Dictionary:
	return {"ilac": 1} if y.kaynaklar.miktar("ilac") > 0 else {"gida": 2}

static func metin(y: KoyYonetimi, bina_id: int = -1) -> String:
	var yetkin_hekim := etkin(y, bina_id)
	return "Yetkin hekim: %s · bulaşıcı hastalık sağlık kaybı %s\nİlaç stoğu %d · bulaşıcı hastalık tedavisi: 1 ilaç / +25 sağlık; ilaç yoksa 2 erzak / +10 sağlık\nİlaç reçetesi: 1 afyon + 1 su; üretim beceri ve bina verimine bağlı · salgında boştaki vasıfsız köylü afyon (şifalı ot) toplar" % ["etkin" if yetkin_hekim else "etkin değil", "−%80" if yetkin_hekim else "normal", y.kaynaklar.miktar("ilac")]


## CAT-03 Kural 4 ve 5: Şifahane `false` ise veya kişi ölüyse tedavi seçeneği görünmez.
static func yara_tedavi_secenegi_gorunur(baglam_veya_sifahane: Variant, olu_mu: bool = false) -> bool:
	if olu_mu:
		return false
	if typeof(baglam_veya_sifahane) == TYPE_BOOL:
		return bool(baglam_veya_sifahane)
	if baglam_veya_sifahane is Dictionary:
		var d: Dictionary = baglam_veya_sifahane
		if d.has("sifahane"):
			return bool(d["sifahane"])
		if d.get("bina") is Dictionary:
			return bool((d["bina"] as Dictionary).get("sifahane", false))
	return false


## CAT-03: Tek bir yaralının gece tedavisini değerlendirir.
## - Ölü hekime gitmez.
## - Aynı yara ikinci gece bir daha iyileşmez (sağlık deltası 0).
## - Hekim ve şifahane varsa (ve hekim yaralı değilse) sağlık deltası pozitiftir (+25 ilaçla, +10 erzakla).
## - Hekim yoksa veya hekim kendisi yaralıysa sağlık kaybı sürer (-YARA_GECE_KAYBI).
## - Yalnız yabancı yaralıda ve `eylem == "tedavi_edip_gonder"` durumunda grup itibarı +1 artar, köylü olmaz.
static func yara_tedavi_uygula(
	yarali: Dictionary,
	durum: Dictionary,
	iyilesen_yaralar: Dictionary = {},
	grup_itibari: Variant = null
) -> Dictionary:
	var olu := bool(yarali.get("olu", false)) or int(yarali.get("saglik", 50)) <= 0
	if olu:
		return {
			"olur": false,
			"neden": "olu_hekime_gitmez",
			"tedavi_edildi": false,
			"saglik_deltasi": 0,
			"itibar_artisi": 0,
			"koylu_oldu": false,
		}

	var yara_id := String(yarali.get("yara_id", yarali.get("id", "varsayilan_yara")))
	if iyilesen_yaralar.has(yara_id) or bool(yarali.get("iyilesti", false)):
		return {
			"olur": true,
			"neden": "ayni_yara_ikinci_gece_iyilesmez",
			"tedavi_edildi": false,
			"saglik_deltasi": 0,
			"itibar_artisi": 0,
			"koylu_oldu": not bool(yarali.get("yabanci", false)),
		}

	var sifahane_acik := yara_tedavi_secenegi_gorunur(durum, false)
	var hekim_var := bool(durum.get("hekim_var", false))
	var hekim_yarali := bool(durum.get("hekim_yarali", false))
	var hekim_uygun := sifahane_acik and hekim_var and (not hekim_yarali)

	var baslangic_saglik := int(yarali.get("saglik", 50))
	var yabanci := bool(yarali.get("yabanci", false))
	var eylem := String(yarali.get("eylem", "tedavi_edip_gonder" if yabanci else "tedavi"))

	if not hekim_uygun:
		var kayip := -maxi(1, int(yarali.get("gece_kaybi", YARA_GECE_KAYBI)))
		var yeni_saglik := maxi(0, baslangic_saglik + kayip)
		return {
			"olur": true,
			"neden": "hekim_yarali" if hekim_yarali else ("sifahane_yok" if not sifahane_acik else "hekim_yok"),
			"tedavi_edildi": false,
			"saglik_deltasi": kayip,
			"yeni_saglik": yeni_saglik,
			"oldu": yeni_saglik <= 0,
			"itibar_artisi": 0,
			"koylu_oldu": false if yabanci else true,
		}

	var ilac_var := bool(durum.get("ilac_var", true))
	var artis := ILAC_SAGLIK if ilac_var else ERZAK_SAGLIK
	var yeni_saglik_iyi := mini(100, baslangic_saglik + artis)
	iyilesen_yaralar[yara_id] = true

	var itibar_delta := 0
	if yabanci and eylem == "tedavi_edip_gonder":
		itibar_delta = 1
		if grup_itibari != null and grup_itibari.has_method("uygula"):
			var grup_adi := String(yarali.get("grup", "koylu"))
			if grup_itibari.has_method("ziyaret_baslat"):
				grup_itibari.call("ziyaret_baslat")
			grup_itibari.call("uygula", grup_adi, 1, true)

	return {
		"olur": true,
		"neden": "tedavi_basarili",
		"tedavi_edildi": true,
		"saglik_deltasi": artis,
		"yeni_saglik": yeni_saglik_iyi,
		"oldu": false,
		"itibar_artisi": itibar_delta,
		"koylu_oldu": false if yabanci else true,
		"durum": "tedavi_edilip_gonderildi" if (yabanci and eylem == "tedavi_edip_gonder") else "iyilesti",
	}


## CAT-03 Uç durum: İki yaralı aynı gece varsa hekim birini seçer, diğeri bekler.
## Bekleyen yabancı gece ölürse itibar artışı yazılmaz.
static func yara_gece_kuyrugu_isle(
	yaralilar: Array,
	durum: Dictionary,
	iyilesen_yaralar: Dictionary = {},
	grup_itibari: Variant = null
) -> Array[Dictionary]:
	var sonuclar: Array[Dictionary] = []
	var hekim_hakki_kullanildi := false
	for ham in yaralilar:
		if not (ham is Dictionary):
			continue
		var yarali: Dictionary = ham
		var olu := bool(yarali.get("olu", false)) or int(yarali.get("saglik", 50)) <= 0
		if olu:
			sonuclar.append(yara_tedavi_uygula(yarali, durum, iyilesen_yaralar, grup_itibari))
			continue

		if not hekim_hakki_kullanildi:
			var r := yara_tedavi_uygula(yarali, durum, iyilesen_yaralar, grup_itibari)
			if bool(r.get("tedavi_edildi", false)):
				hekim_hakki_kullanildi = true
			sonuclar.append(r)
		else:
			# Hekim bu gece baska yaraliyla mesgul; bekleyen yaralida kayip surer.
			var bekleyen_durum := durum.duplicate(true)
			bekleyen_durum["hekim_var"] = false
			var r_bekleyen := yara_tedavi_uygula(yarali, bekleyen_durum, iyilesen_yaralar, null)
			r_bekleyen["bekledi"] = true
			r_bekleyen["itibar_artisi"] = 0
			sonuclar.append(r_bekleyen)
	return sonuclar
