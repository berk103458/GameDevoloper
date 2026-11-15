# gdlint: disable=max-line-length
class_name KararDonusu
extends RefCounted

## DYL-08 & KOP-04: Kararın sonradan dönüşü tek gecikmeli kuyrukta yaşar.
## İkinci dönüş kuyruğu kurulmaz; DYL-08 gecikmeli_etkiler ve sonraki_spawns alanlarını kullanır.
## Her gecikmeli satır açık alanlarla taşınır: hedef_sistem, alan, deger, tur_offset.

const GECERLI_HEDEF_SISTEMLER := ["bar", "dedikodu", "spawn", "kuyu_zehri", "ambar_kundak"]
const AZAMI_GUNLUK_DONUS := 2

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


## KOP-04: Kayıttan gelen gecikmeli kuyruk satırlarını güvenli biçimde yükler.
static func oku(ham: Variant) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	if not ham is Array:
		return sonuc
	for oge in ham as Array:
		if not oge is Dictionary:
			continue
		var kopya: Dictionary = (oge as Dictionary).duplicate(true)
		if kopya.has("tur_offset"):
			kopya["tur_offset"] = int(kopya["tur_offset"])
		if not gecikmeli_satir_gecerli_mi(kopya):
			continue
		kopya["eklenme_gunu"] = int(kopya.get("eklenme_gunu", 0))
		kopya["hedef_gun"] = int(kopya.get("hedef_gun", int(kopya["eklenme_gunu"]) + int(kopya["tur_offset"])))
		kopya["uygulandi"] = bool(kopya.get("uygulandi", false))
		kopya["spawned"] = bool(kopya.get("spawned", false))
		kopya["tanikli"] = bool(kopya.get("tanikli", false))
		sonuc.append(kopya)
	return sonuc


## KOP-04: Kapı kararını tek gecikmeli_kuyruk + sonraki_spawns zincirine yazar.
static func kapi_kararini_yaz(o: Oturum, gelen: Gelen, karar: StringName, ek: Dictionary = {}) -> Dictionary:
	if o == null or gelen == null or bool(ek.get("engellendi", false)):
		return {}
	preload("res://src/kapi/kapi_kavgasi_adaptoru.gd").sozleri_kapat(o, gelen, karar)
	if ek.get("durum", "") == "kavga_acik": return {} # CAT-02 sonucu beklenir; sıradan ret dönüşü yazılmaz.
	var sorgu := gelen.chr_sorgusu()
	if not gelen.adli and sorgu == null and not gelen.has_meta(&"defter_id"):
		return {}
	var chr_id := String(gelen.id)
	if chr_id.is_empty():
		chr_id = "figur"
	var karar_metni := "kabul" if (karar == &"harc" or karar == &"kisla") else String(karar)
	var veri: Variant = sorgu.get("karakter") if sorgu != null else null
	var sonraki_spawns: Dictionary = veri.sonraki_spawns if veri != null else {}
	var defter_id := String(gelen.get_meta(&"defter_id", "")) if gelen.has_meta(&"defter_id") else ""
	var yalan_yakalandi := bool(gelen.heybe != null and gelen.heybe.astar_yoklandi and gelen.heybe.yalan_var())
	var tanikli := not o.yonetim.koylular.is_empty()
	var karar_kaydi := {
		"chr_id": chr_id,
		"karar": karar_metni,
		"yalan_yakalandi": yalan_yakalandi,
		"defter_id": defter_id,
		"tanikli": tanikli,
	}
	var onceki_boy := o.gecikmeli_kuyruk.size()
	var satir := tek_kuyruga_yaz(o.gecikmeli_kuyruk, sonraki_spawns, karar_kaydi)
	if o.gecikmeli_kuyruk.size() > onceki_boy:
		var eklenen: Dictionary = o.gecikmeli_kuyruk[o.gecikmeli_kuyruk.size() - 1]
		eklenen["eklenme_gunu"] = o.gun
		eklenen["hedef_gun"] = o.gun + int(eklenen.get("tur_offset", 3))
		eklenen["uygulandi"] = false
		eklenen["spawned"] = false
		eklenen["tanikli"] = tanikli
		eklenen["kanal"] = "haberci" if yalan_yakalandi else "sabah"
		eklenen["metin"] = String(satir.get("metin", ""))
	return satir


## KOP-04: Tek kuyruktaki vadesi gelmiş canlı spawn hedeflerini kapı sırasına bağlar.
static func spawn_ekle(o: Oturum, sonuc: Array[Gelen]) -> void:
	if o == null or o.gecikmeli_kuyruk.is_empty():
		return
	preload("res://src/kapi/kapi_kavgasi_adaptoru.gd").sozleri_kapat(o)
	var mevcutlar := {}
	for g in sonuc:
		if g != null and not String(g.id).is_empty():
			mevcutlar[String(g.id).to_lower()] = true
	for satir in o.gecikmeli_kuyruk:
		if not (satir is Dictionary):
			continue
		if String(satir.get("hedef_sistem", "")) != "spawn":
			continue
		if bool(satir.get("spawned", false)):
			continue
		if int(satir.get("hedef_gun", 999999)) > o.gun:
			continue
		var ham_id := String(satir.get("deger", "")).strip_edges()
		if ham_id.is_empty():
			continue
		if satir.has("cat02_soz") and not satir.get("cat02_figur", {}).is_empty():
			var figur := Gelen.new()
			var veri: Dictionary = satir.cat02_figur
			for alan in veri:
				if alan in ["acik_bayraklar", "gizli_bayraklar"]: figur.set(alan, PackedStringArray(veri[alan]))
				elif alan == "aile": figur.aile.assign(veri[alan])
				else: figur.set(alan, veri[alan])
			figur.id = StringName(ham_id)
			figur.secenekler = PackedStringArray(["kabul", "ret"])
			figur.heybe = o.heybe_uret(figur.sinif)
			sonuc.append(figur)
			satir["spawned"] = true
			continue
		var aday_id := _karakter_kimligi_bul(o, ham_id)
		if aday_id == &"": continue
		if mevcutlar.has(String(aday_id).to_lower()):
			if satir.has("cat02_soz"): satir["spawned"] = true
			continue
		var durum := String(o.kadro.durumlar.get(aday_id, {}).get("durum", ""))
		if HafizaDefteri.GITTI_DURUMLARI.has(durum):
			satir["spawned"] = true
			continue
		o.kadro.iste(aday_id, o.gun)
		var gelen: Gelen = o._adli_gelen(aday_id)
		if gelen != null:
			sonuc.append(gelen)
			mevcutlar[String(aday_id).to_lower()] = true
			satir["spawned"] = true


static func _karakter_kimligi_bul(o: Oturum, ham_id: String) -> StringName:
	for aday in [StringName(ham_id.to_lower()), StringName(ham_id)]:
		if o.kadro.durumlar.has(aday) and o.katalog.karakter(aday) != null:
			return aday
	return &""


## DYL-08: Gece sonunda vadesi gelen karar dönüşlerini günde en çok 2 sınırıyla ilerletir.
## Ölen/giden karakterler yalnız haberci kanalına düşer; SAB-01 sabah defterine yazmaz; bar etkisi bir kez uygulanır.
static func ilerlet(o: Oturum, r: Dictionary = {}) -> Array[Dictionary]:
	var donen: Array[Dictionary] = []
	if o == null or o.gecikmeli_kuyruk.is_empty():
		return donen
	for satir in o.gecikmeli_kuyruk:
		if donen.size() >= AZAMI_GUNLUK_DONUS:
			break
		if not (satir is Dictionary):
			continue
		if bool(satir.get("uygulandi", false)):
			continue
		if int(satir.get("hedef_gun", 999999)) > o.gun:
			continue
		var chr_id := String(satir.get("chr_id", ""))
		var durum := _karakter_durumu(o, chr_id)
		var gitti := HafizaDefteri.GITTI_DURUMLARI.has(durum)
		var kanal := "haberci" if gitti else String(satir.get("kanal", "sabah"))
		if not kanal in ["sabah", "haberci", "koylu"]:
			kanal = "haberci" if gitti else "sabah"
		satir["uygulandi"] = true
		satir["uygulanan_gun"] = o.gun
		satir["kanal"] = kanal
		if gitti:
			satir["gitti"] = true
			satir["ad_etiketi"] = "gitti"
		_etki_uygula(o, satir)
		var ozet := {
			"chr_id": chr_id,
			"karar": String(satir.get("karar", "")),
			"olay_id": String(satir.get("olay_id", "")),
			"hedef_sistem": String(satir.get("hedef_sistem", "")),
			"kanal": kanal,
			"gitti": gitti,
			"metin": String(satir.get("metin", "")),
			"gece": o.gun,
		}
		donen.append(ozet)
	if not donen.is_empty() and not r.is_empty():
		var liste: Array = r.get("karar_donusleri", [])
		liste.append_array(donen)
		r["karar_donusleri"] = liste
	return donen


## DYL-08 / HFZ: Bölüm 39 hafıza defteri için çözülmüş dönüş satırlarını üretir.
static func defter_donusleri(o: Oturum) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	if o == null:
		return sonuc
	for satir in o.gecikmeli_kuyruk:
		if not (satir is Dictionary) or not bool(satir.get("uygulandi", false)):
			continue
		var chr_id := String(satir.get("chr_id", ""))
		var gece := int(satir.get("eklenme_gunu", 0))
		var karar := String(satir.get("karar", ""))
		var ad := "gitti" if bool(satir.get("gitti", false)) else chr_id
		sonuc.append({
			"hedef": "karar:%s:%d:%s" % [chr_id, gece, karar],
			"kisi": chr_id,
			"ad": ad,
			"durum": "gitti" if bool(satir.get("gitti", false)) else "",
			"gece": int(satir.get("uygulanan_gun", gece)),
			"sonuc_anahtari": String(satir.get("metin", "")),
		})
	return sonuc


static func _karakter_durumu(o: Oturum, chr_id: String) -> String:
	for aday in [StringName(chr_id.to_lower()), StringName(chr_id)]:
		if o.kadro.durumlar.has(aday):
			return String(o.kadro.durumlar[aday].get("durum", ""))
	return ""


static func _etki_uygula(o: Oturum, satir: Dictionary) -> void:
	var hs := String(satir.get("hedef_sistem", ""))
	var alan := String(satir.get("alan", "")).to_lower()
	if hs == "bar":
		var v := int(satir.get("deger", 0))
		if v != 0:
			match alan:
				"erzak", "gida":
					o.ambar += v
				"moral", "huzur":
					o._bar_uygula(PackedInt32Array([v, 0, 0, 0]))
				"adalet":
					o._bar_uygula(PackedInt32Array([0, v, 0, 0]))
				"akce":
					o.akce += v
				"guvenlik", "asayis":
					o._bar_uygula(PackedInt32Array([0, 0, 0, v]))
	var tanikli := bool(satir.get("tanikli", false))
	var olay_id := "dyl08_%s" % String(satir.get("olay_id", ""))
	if tanikli and (hs == "dedikodu" or olay_id.contains("intikam")):
		var tanik_id := "koy_tanigi" if o.yonetim.koylular.is_empty() else str(o.yonetim.koylular[0].id)
		var metin := String(satir.get("metin", "")).strip_edges()
		if metin.is_empty():
			metin = "Kapı kararının yankısı köyde konuşuluyor."
		o.dedikodu.olay_kaydet(olay_id, "siddet" if olay_id.contains("intikam") else "haksiz_ret", o.gun, tanik_id, 1, {"satir": metin, "hedef_id": String(satir.get("chr_id", ""))})
