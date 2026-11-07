## CHR derleyicisi ve runtime adaptörlerinin ortak doğrulama sınırı.
class_name ChrSozlesmesi
extends RefCounted

const BAYRAKLAR := ["Flag_Yol_Sirri_Acik", "Flag_Kimlik_Cozuldu", "Flag_Sir_Tamamen_Cozuldu", "Flag_Kilitlendi"]
const STATLAR := ["Refah", "Erzak", "Guvenlik", "Moral", "Saglik"]
const KARARLAR := ["kabul", "gonullu_ret", "zorunlu_ret", "rusvet", "kisla"]
const HEDEF_SISTEMLER := ["bar", "dedikodu", "spawn", "kuyu_zehri", "ambar_kundak"]

## Derlenmiş CHR profili için katı kontrol; eski katalog profilleri bu kapıdan geçirilmez.
static func karakter_hatalari(k: KarakterVerisi) -> PackedStringArray:
	var hatalar := PackedStringArray()
	var desen := RegEx.new()
	desen.compile("^CHR_[0-9]{3}$")
	if desen.search(String(k.entity_id)) == null:
		hatalar.append("entity_id CHR_XXX olmalı")
	if k.ad.strip_edges().is_empty() or k.sinif == &"" or k.fraksiyon == &"":
		hatalar.append("Ad/sınıf/fraksiyon eksik")
	if k.baslangic_tansiyonu < 1 or k.baslangic_tansiyonu > 3:
		hatalar.append("Başlangıç tansiyonu 1–3 olmalı")
	hatalar.append_array(karar_hatalari(k.karar_matrisi))
	hatalar.append_array(diyalog_hatalari(k.diyalog_dugumleri))
	for d in k.diyalog_dugumleri.values():
		if d is Dictionary: hatalar.append_array(preload("res://src/soz/muhafiz_tonu.gd").dugum_hatalari(d, k.metinler))
	hatalar.append_array(bayrak_hatalari(k.sorgu_bayraklari))
	hatalar.append_array(gecikmeli_hatalari(k.gecikmeli_etkiler))
	hatalar.append_array(spawn_hatalari(k.sonraki_spawns))
	return hatalar

static func spawn_hatalari(spawns: Dictionary) -> PackedStringArray:
	var hatalar := PackedStringArray()
	var desen := RegEx.new()
	desen.compile("^CHR_[0-9]{3}$")
	for kosul in spawns:
		if not String(kosul) in ["on_accept", "on_reject", "on_bribe", "on_jail"]:
			hatalar.append("Tanımsız spawn koşulu: %s" % kosul)
		var spawn: Variant = spawns[kosul]
		if not spawn is Dictionary:
			hatalar.append("Spawn sözlük olmalı")
			continue
		var hedef_id := String(spawn.get("entity_id", ""))
		if desen.search(hedef_id) == null:
			hatalar.append("Spawn entity_id CHR_XXX olmalı")
		elif not ResourceLoader.exists("res://data/chr_runtime/%s.tres" % hedef_id):
			hatalar.append("KOP-09: Sayfası olmayan spawn entity_id: %s" % hedef_id)
		if not spawn.get("offset") is int or int(spawn.get("offset", -1)) < 1:
			hatalar.append("Spawn offset pozitif int olmalı")
	return hatalar

static func gecikmeli_hatalari(olaylar: Array[Dictionary]) -> PackedStringArray:
	var hatalar := PackedStringArray()
	for olay in olaylar:
		if not olay.get("tur_offset") is int or int(olay.get("tur_offset", -1)) < 1:
			hatalar.append("Gecikmeli olay tur_offset pozitif int olmalı")
		for alan in ["hedef_bina", "olay_id"]:
			if String(olay.get(alan, "")).is_empty():
				hatalar.append("Gecikmeli olay %s eksik" % alan)
		if olay.has("hedef_sistem"):
			var hs := String(olay.get("hedef_sistem", ""))
			if not hs in HEDEF_SISTEMLER:
				hatalar.append("KOP-04: Geçersiz hedef_sistem: %s" % hs)
			if String(olay.get("alan", "")).is_empty() or not olay.has("deger"):
				hatalar.append("KOP-04: Gecikmeli olay alan/deger eksik")
		var stat: Variant = olay.get("stat_etkisi")
		if stat is Dictionary:
			hatalar.append_array(stat_hatalari(stat))
		else:
			hatalar.append("Gecikmeli olay stat_etkisi eksik")
	return hatalar

static func stat_hatalari(etki: Dictionary) -> PackedStringArray:
	var hatalar := PackedStringArray()
	for anahtar in etki:
		if not String(anahtar) in STATLAR or not etki[anahtar] is int:
			hatalar.append("Geçersiz stat/tip: %s" % anahtar)
	return hatalar

static func karar_hatalari(matris: Dictionary) -> PackedStringArray:
	var hatalar := PackedStringArray()
	for karar in KARARLAR:
		var sonuc: Variant = matris.get(karar)
		if not sonuc is Dictionary:
			hatalar.append("Karar eksik/geçersiz: %s" % karar)
			continue
		var stat: Variant = sonuc.get("stat_etkisi")
		if stat is Dictionary:
			hatalar.append_array(stat_hatalari(stat))
		else:
			hatalar.append("%s: stat_etkisi eksik" % karar)
		if not sonuc.get("muhafiz_akce", 0) is int:
			hatalar.append("%s: kişisel akçe int olmalı" % karar)
		if not sonuc.get("esyalar", []) is Array:
			hatalar.append("%s: esyalar dizi olmalı" % karar)
		var varyantlar: Variant = sonuc.get("varyantlar", [])
		if not varyantlar is Array:
			hatalar.append("%s: varyantlar dizi olmalı" % karar)
			continue
		for varyant in varyantlar:
			if not varyant is Dictionary or not varyant.get("stat_etkisi") is Dictionary:
				hatalar.append("%s: varyant stat_etkisi eksik" % karar)
			else:
				hatalar.append_array(stat_hatalari(varyant["stat_etkisi"]))
	return hatalar

static func bayrak_hatalari(bayraklar: Dictionary) -> PackedStringArray:
	var hatalar := PackedStringArray()
	for anahtar in BAYRAKLAR:
		if not bayraklar.get(anahtar) is bool:
			hatalar.append("%s: bool bayrak eksik/geçersiz" % anahtar)
	for anahtar in bayraklar:
		if not String(anahtar) in BAYRAKLAR:
			hatalar.append("Tanımsız standart bayrak: %s" % anahtar)
	return hatalar

static func diyalog_hatalari(dugumler: Dictionary) -> PackedStringArray:
	var hatalar := PackedStringArray()
	if not dugumler.has("00"):
		hatalar.append("Düğüm 00 eksik")
	for kimlik in dugumler:
		var dugum: Variant = dugumler[kimlik]
		if not dugum is Dictionary:
			hatalar.append("%s: düğüm sözlük olmalı" % kimlik)
			continue
		if String(dugum.get("replik_anahtari", "")).is_empty():
			hatalar.append("%s: replik_anahtari eksik" % kimlik)
		var secenekler: Variant = dugum.get("secenekler", [])
		if not secenekler is Array:
			hatalar.append("%s: secenekler dizi olmalı" % kimlik)
			continue
		for secenek in secenekler:
			if not secenek is Dictionary:
				hatalar.append("%s: seçenek sözlük olmalı" % kimlik)
				continue
			if String(secenek.get("metin_anahtari", "")).is_empty():
				hatalar.append("%s: metin_anahtari eksik" % kimlik)
			if not secenek.get("tansiyon_delta") is int:
				hatalar.append("%s: tansiyon_delta int olmalı" % kimlik)
			var hedef := String(secenek.get("hedef", ""))
			if not hedef.is_empty() and not dugumler.has(hedef):
				hatalar.append("%s: hedef bulunamadı: %s" % [kimlik, hedef])
	return hatalar
