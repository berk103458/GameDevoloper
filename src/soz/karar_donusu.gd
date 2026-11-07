# gdlint: disable=max-line-length
class_name KararDonusu
extends RefCounted

## DYL-08 & KOP-04: Kararın sonradan dönüşü tek gecikmeli kuyrukta yaşar.
## İkinci dönüş kuyruğu kurulmaz; DYL-08 gecikmeli_etkiler ve sonraki_spawns alanlarını kullanır.
## Her gecikmeli satır açık alanlarla taşınır: hedef_sistem, alan, deger, tur_offset.

const GECERLI_HEDEF_SISTEMLER := ["bar", "dedikodu", "spawn", "kuyu_zehri", "ambar_kundak"]

static func gecikmeli_satir_gecerli_mi(satir: Dictionary) -> bool:
	var hs := String(satir.get("hedef_sistem", ""))
	if not hs in GECERLI_HEDEF_SISTEMLER:
		return false
	if String(satir.get("alan", "")).strip_edges().is_empty():
		return false
	if not satir.has("deger"):
		return false
	if not (satir.get("tur_offset") is int) or int(satir.get("tur_offset", 0)) < 1:
		return false
	return true

static func donus_hesapla(karar_kaydi: Dictionary, gun_farki: int) -> Dictionary:
	var karar: String = str(karar_kaydi.get("karar", "ret"))
	var chr_id: String = str(karar_kaydi.get("chr_id", ""))
	var yalan_yakalandi: bool = bool(karar_kaydi.get("yalan_yakalandi", false))
	var defter_id: String = str(karar_kaydi.get("defter_id", ""))

	if gun_farki < 2:
		return { "donus_var": false }

	if not defter_id.is_empty():
		if karar == "ret":
			return {
				"donus_var": true,
				"tur": "defter_kaybi_haberi",
				"defter_id": defter_id,
				"metin_anahtari": "yap37.donus.defter_ret",
				"metin": "Kapıdan çevrilen yolcunun heybesindeki usta defteri komşu menzilde başkasına satılmış.",
				"moral_etkisi": -1,
				"hedef_sistem": "dedikodu",
				"alan": "Moral",
				"deger": -1,
				"tur_offset": gun_farki,
				"chr_id": chr_id,
				"karar": karar
			}
		return {
			"donus_var": true,
			"tur": "defter_sozu_donusu",
			"defter_id": defter_id,
			"metin_anahtari": "yap37.donus.defter_kabul",
			"metin": "Söz verilen usta defteri ve yapı resmi haberciyle kapıya ulaştırıldı.",
			"defter_teslim": true,
			"hedef_sistem": "bar",
			"alan": "Refah",
			"deger": 1,
			"tur_offset": gun_farki,
			"chr_id": chr_id,
			"karar": karar
		}

	if karar == "ret":
		if yalan_yakalandi:
			return {
				"donus_var": true,
				"tur": "intikam_haberi",
				"metin": "Kapıdan çevrilen şahıs dağ çetesine sığınmış; köye tehdit savurur.",
				"asayis_riski": 2,
				"hedef_sistem": "bar",
				"alan": "Guvenlik",
				"deger": -2,
				"tur_offset": gun_farki,
				"chr_id": chr_id,
				"karar": karar
			}
		else:
			return {
				"donus_var": true,
				"tur": "vicdan_azabi",
				"metin": "Karaköy yolunda donarak ölen garibin haberi köye ulaştı.",
				"moral_etkisi": -2,
				"hedef_sistem": "dedikodu",
				"alan": "Moral",
				"deger": -2,
				"tur_offset": gun_farki,
				"chr_id": chr_id,
				"karar": karar
			}
	else: # kabul
		var spawn_hedef: String = str(karar_kaydi.get("spawn_id", "CHR_004"))
		return {
			"donus_var": true,
			"tur": "akraba_gelisi",
			"metin": "Kabul edilen köylünün geride kalan ailesi kapıya dayandı.",
			"yeni_ziyaretci_tetikle": true,
			"hedef_sistem": "spawn",
			"alan": "on_accept",
			"deger": spawn_hedef,
			"tur_offset": gun_farki,
			"chr_id": chr_id,
			"karar": karar
		}

## KOP-04: Kararın gecikmeli dönüşünü ikinci bir kuyruk açmadan mevcut tek kuyruğa yazar.
## Aynı karar iki kuyruğa veya aynı kuyruğa iki kez yazılmaz (ör. Yusuf'un kabul dönüşü tek satırdır).
static func tek_kuyruga_yaz(gecikmeli_kuyruk: Array, sonraki_spawns: Dictionary, karar_kaydi: Dictionary, gun_farki: int = 3) -> Dictionary:
	var donus := donus_hesapla(karar_kaydi, gun_farki)
	if not bool(donus.get("donus_var", false)):
		return donus
	if not gecikmeli_satir_gecerli_mi(donus):
		return {"donus_var": false, "hata": "gecersiz_hedef_sistem"}

	var chr_id := String(karar_kaydi.get("chr_id", "CHR_003"))
	var karar := String(karar_kaydi.get("karar", "kabul"))

	# Aynı karar zaten gecikmeli_kuyruk içinde varsa ikinci satır eklenmez.
	for mevcut in gecikmeli_kuyruk:
		if mevcut is Dictionary and String(mevcut.get("chr_id", "")) == chr_id and String(mevcut.get("karar", "")) == karar:
			return mevcut

	var satir := {
		"chr_id": chr_id,
		"karar": karar,
		"hedef_sistem": String(donus["hedef_sistem"]),
		"alan": String(donus["alan"]),
		"deger": donus["deger"],
		"tur_offset": int(donus["tur_offset"]),
		"hedef_bina": String(karar_kaydi.get("hedef_bina", "Köy Meydanı")),
		"olay_id": "%s_%s" % [chr_id, String(donus.get("tur", "donus"))],
		"stat_etkisi": {String(donus["alan"]): int(donus["deger"])} if donus["deger"] is int else {}
	}
	# Eğer hedef_sistem 'spawn' ise ve sonraki_spawns içinde zaten bu karar koşulu varsa,
	# ikinci kuyruk oluşmaması için yalnızca tek kayıtta tutulur.
	var spawn_kosul := String(donus["alan"])
	if satir["hedef_sistem"] == "spawn" and sonraki_spawns.has(spawn_kosul):
		satir["deger"] = String(sonraki_spawns[spawn_kosul].get("entity_id", satir["deger"]))
		satir["tur_offset"] = int(sonraki_spawns[spawn_kosul].get("offset", satir["tur_offset"]))
	gecikmeli_kuyruk.append(satir)
	return satir
