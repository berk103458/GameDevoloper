## BUG-07 / SYS-12: metin tablosu (data/metin/metinler.csv) için güvenli okuma sınırı.
## Eksik ya da boş anahtar oyunu kilitlemez. Sıra: içe aktarılmış çeviri → ham CSV'nin hoşgörülü
## okuması (bozuk tırnak/sütun satırları atlanır) → ekranda `[KEY_NOT_FOUND] anahtar` + tek seferlik uyarı.
## Bağlantı: Ana._ready içinde tek satır `GuvenliMetin.kur()`; Katalog eksik anahtarı uyarıya çevirir.
class_name GuvenliMetin
extends RefCounted

const YOK := "[KEY_NOT_FOUND]"
const CSV_YOLU := "res://data/metin/metinler.csv"
const CEVIRI_YOLU := "res://data/metin/metinler.tr.translation"
const DIL := "tr"
const UZANTILAR := ["png", "svg", "jpg", "jpeg", "webp", "ogg", "wav", "mp3", "glb", "gltf", "tres", "tscn", "res", "gd", "json", "csv", "txt", "md"]

## Çalışma anında bulunamayan anahtarlar (ilk görülme sırası).
static var eksikler: PackedStringArray = []
## Son ham CSV okumasının uyarıları (satır numaralı).
static var csv_uyarilari: PackedStringArray = []
static var _yedek: Dictionary = {}
static var _yedek_okundu := false
static var _uyarilan: Dictionary = {}
static var _asil: Translation
static var _sarmal: Translation


## Sistem çevirisini sarmalayıcıyla değiştirir; tekrar çağrılması zararsızdır.
static func kur() -> void:
	var mevcut := TranslationServer.get_translation_object(DIL)
	if mevcut is _Sarmalayici:
		return
	_asil = mevcut
	if _asil == null and ResourceLoader.exists(CEVIRI_YOLU):
		_asil = load(CEVIRI_YOLU) as Translation
	if mevcut != null:
		TranslationServer.remove_translation(mevcut)
	_sarmal = _Sarmalayici.new()
	_sarmal.locale = DIL
	TranslationServer.add_translation(_sarmal)
	# Çıkışta betikli çeviri sunucuda kalırsa Godot kapanırken çöker; ağaçtan çıkarken sökülür.
	var agac := Engine.get_main_loop() as SceneTree
	if agac != null and agac.root != null:
		agac.root.add_child.call_deferred(_Bekci.new())


## Testler için: sarmalayıcıyı söküp asıl çeviriyi geri koyar.
static func kaldir() -> void:
	if _sarmal != null:
		TranslationServer.remove_translation(_sarmal)
		_sarmal = null
	if _asil != null and TranslationServer.get_translation_object(DIL) == null:
		TranslationServer.add_translation(_asil)


## Anahtar içe aktarılmış tabloda yok ya da boş mu (Katalog doğrulaması için).
static func eksik_mi(anahtar: String) -> bool:
	return _tablo(anahtar).strip_edges().is_empty()


## Kurulumdan bağımsız güvenli çeviri: tablo → ham CSV → `[KEY_NOT_FOUND] anahtar`.
static func metin(anahtar: String) -> String:
	var m := _tablo(anahtar)
	if not m.strip_edges().is_empty():
		return m
	return _yedekten(anahtar, true)


## Metin anahtarına benzeyen dizge mi (`koy.hud.gun`, `CHR_001_DUGUM_00_REPLIK`)? Düz metin ve dosya adı değildir.
static func anahtar_gibi_mi(s: String) -> bool:
	if s.is_empty() or s.length() > 120 or s.contains(" "):
		return false
	if s.begins_with("CHR_") or s.begins_with("CLUE_"):
		return s == s.to_upper() and not s.contains(".")
	var parcalar := s.split(".")
	if parcalar.size() < 2 or parcalar[-1] in UZANTILAR:
		return false
	if not (parcalar[0][0] >= "a" and parcalar[0][0] <= "z"):
		return false
	var harfli := 0
	for p in parcalar:
		if p.is_empty():
			return false
		for c in p:
			if not ((c >= "a" and c <= "z") or (c >= "0" and c <= "9") or c == "_"):
				return false
		if not p.is_valid_int():
			harfli += 1
	return harfli == parcalar.size() or parcalar.size() >= 3


## Tek seferlik uyarı; metni geri döndürür (Katalog listesine eklenebilsin).
static func uyar(mesaj: String) -> String:
	if not _uyarilan.has(mesaj):
		_uyarilan[mesaj] = true
		push_warning("Metin tablosu: " + mesaj)
	return mesaj


## Hoşgörülü CSV okuyucu: {"metinler": {anahtar: metin}, "uyarilar": [...]}. Bozuk satır çökertmez;
## kapanmamış tırnak bir sonraki anahtar satırında kesilir, eksik sütunlu/boş satır atlanır.
static func csv_coz(kaynak: String) -> Dictionary:
	var metinler := {}
	var uyarilar := PackedStringArray()
	var satirlar := kaynak.trim_prefix("\uFEFF").replace("\r\n", "\n").split("\n")
	var basliklar := PackedStringArray()
	var dil_sutunu := -1
	var i := 0
	while i < satirlar.size():
		var no := i + 1
		var alanlar := PackedStringArray()
		var alan := ""
		var tirnak := false
		var satir: String = satirlar[i]
		var j := 0
		while true:
			if j >= satir.length():
				if tirnak:
					if i + 1 < satirlar.size() and not _yeni_satir_mi(satirlar[i + 1]):
						i += 1
						alan += "\n"
						satir = satirlar[i]
						j = 0
						continue
					uyarilar.append("satır %d: kapanmamış tırnak; alan satır sonunda kesildi" % no)
				break
			var c := satir[j]
			if tirnak:
				if c == "\"":
					if j + 1 < satir.length() and satir[j + 1] == "\"":
						alan += "\""
						j += 1
					else:
						tirnak = false
				else:
					alan += c
			elif c == "\"" and alan.is_empty():
				tirnak = true
			elif c == ",":
				alanlar.append(alan)
				alan = ""
			else:
				alan += c
			j += 1
		alanlar.append(alan)
		i += 1
		if basliklar.is_empty():
			basliklar = alanlar
			dil_sutunu = basliklar.find(DIL)
			if basliklar[0].strip_edges() != "keys" or dil_sutunu < 1:
				uyarilar.append("satır %d: başlık 'keys,%s' değil; tablo okunamadı" % [no, DIL])
				break
			continue
		if alanlar.size() == 1 and alanlar[0].strip_edges().is_empty():
			continue
		var anahtar := alanlar[0].strip_edges()
		if anahtar.is_empty():
			uyarilar.append("satır %d: boş anahtar atlandı" % no)
			continue
		if alanlar.size() != basliklar.size():
			uyarilar.append("satır %d: %s için %d sütun bekleniyordu, %d geldi" % [no, anahtar, basliklar.size(), alanlar.size()])
		if alanlar.size() <= dil_sutunu or alanlar[dil_sutunu].strip_edges().is_empty():
			uyarilar.append("satır %d: %s için Türkçe metin yok" % [no, anahtar])
			continue
		if metinler.has(anahtar):
			uyarilar.append("satır %d: mükerrer anahtar %s (sonraki geçerli)" % [no, anahtar])
		metinler[anahtar] = alanlar[dil_sutunu].c_unescape()
	return {"metinler": metinler, "uyarilar": uyarilar}


## Testler için önbelleği sıfırlar.
static func sifirla() -> void:
	eksikler = []
	csv_uyarilari = []
	_yedek = {}
	_yedek_okundu = false
	_uyarilan = {}


static func _yeni_satir_mi(satir: String) -> bool:
	var virgul := satir.find(",")
	return virgul > 0 and anahtar_gibi_mi(satir.substr(0, virgul))


static func _tablo(anahtar: String) -> String:
	var t := _asil if _asil != null else TranslationServer.get_translation_object(DIL)
	if t == null or t is _Sarmalayici:
		return ""
	return String(t.get_message(anahtar))


static func _yedekten(anahtar: String, isaretle: bool) -> String:
	if not _yedek_okundu:
		_yedek_okundu = true
		if FileAccess.file_exists(CSV_YOLU):
			var sonuc := csv_coz(FileAccess.get_file_as_string(CSV_YOLU))
			_yedek = sonuc.metinler
			csv_uyarilari = sonuc.uyarilar
			for u in csv_uyarilari:
				uyar(u)
	if _yedek.has(anahtar):
		uyar("%s içe aktarılmış tabloda yok; ham CSV'den okundu" % anahtar)
		return _yedek[anahtar]
	if not isaretle:
		return ""
	if not anahtar in eksikler:
		eksikler.append(anahtar)
	uyar("eksik anahtar %s; ekranda %s gösteriliyor" % [anahtar, YOK])
	return "%s %s" % [YOK, anahtar]


class _Bekci extends Node:
	func _init() -> void:
		name = "GuvenliMetinBekci"

	func _exit_tree() -> void:
		GuvenliMetin.kaldir()


class _Sarmalayici extends Translation:
	func _get_message(src_message: StringName, context: StringName) -> StringName:
		var anahtar := String(src_message)
		var m := GuvenliMetin._tablo(anahtar) if GuvenliMetin._asil != null else ""
		if not m.is_empty():
			return StringName(m)
		if not GuvenliMetin.anahtar_gibi_mi(anahtar):
			return &""
		return StringName(GuvenliMetin._yedekten(anahtar, true))
