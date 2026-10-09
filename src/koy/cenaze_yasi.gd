## KRI-05: tek ölüm raporuna bağlı, iki günlük geçici yas ve cenaze kararı.
class_name CenazeYasi
extends RefCounted

const META := &"cenaze_yasi"
const SURE := 2
const TAVAN := 12
const KISI_CEZA := 3
const KATILIM_TAVAN := 6
const IS_CARPANI := 0.9

static func _tam(v: Variant, alt: int, ust: int) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and float(v) >= alt and float(v) <= ust

## Optional JSON; gelecek/bozuk kayıt moral, ücret veya hastalık üretemez.
static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary or v.is_empty(): return {}
	for alan in ["baslangic", "bitis", "olum_gecesi"]:
		if not _tam(v.get(alan), 0, 1000000000): return {}
	if v.bitis != v.baslangic + SURE or v.olum_gecesi != v.baslangic: return {}
	if not _tam(v.get("sayi"), 1, 1000000) or not _tam(v.get("ceza"), 1, TAVAN) or not _tam(v.get("onceki_ceza"), 0, TAVAN): return {}
	if not v.get("salgin") is bool or v.get("secim") not in ["", "toplu_mezar", "toren"]: return {}
	var taban := mini(TAVAN, int(v.sayi) * KISI_CEZA)
	var beklenen := maxi(int(v.onceki_ceza), ceili(taban / 2.0) if v.secim == "toren" else taban)
	if int(v.ceza) != beklenen or not _tam(v.get("toren_gun"), -1, 1000000000): return {}
	if int(v.toren_gun) != (int(v.baslangic) + 1 if v.secim == "toren" else -1): return {}
	if not v.get("katilanlar") is Array or v.katilanlar.size() > KATILIM_TAVAN or not v.get("uygulanan") is Dictionary: return {}
	var ids: Array[int] = []
	for id in v.katilanlar:
		if not _tam(id, 1, 1000000000) or int(id) in ids: return {}
		ids.append(int(id))
	if v.secim != "toren" and not ids.is_empty(): return {}
	var uygulanan := {}
	for id in v.uygulanan:
		if not id is String or not id.is_valid_int() or str(int(id)) != id or not _tam(int(id), 1, 1000000000) or not _tam(v.uygulanan[id], 1, int(v.ceza)): return {}
		uygulanan[id] = int(v.uygulanan[id])
	return {"baslangic": int(v.baslangic), "bitis": int(v.bitis), "olum_gecesi": int(v.olum_gecesi), "sayi": int(v.sayi), "ceza": int(v.ceza), "onceki_ceza": int(v.onceki_ceza), "salgin": v.salgin, "secim": String(v.secim), "toren_gun": int(v.toren_gun), "katilanlar": ids, "uygulanan": uygulanan}

static func durum(y: KoyYonetimi) -> Dictionary:
	return oku(y.get_meta(META, {}))

static func yukle(y: KoyYonetimi, v: Variant) -> void:
	var d := oku(v)
	if not d.is_empty():
		if y.gun < int(d.baslangic) or y.gun > int(d.bitis): d = {}
		else:
			for id in d.uygulanan.keys():
				if y.koylu(int(id)) == null: d.uygulanan.erase(id)
	y.set_meta(META, d)

## Önce yalnız gerçekten kesilmiş miktarı geri al; sonra sağlık/moral normal çalışır.
## Düşük moralde iade kazancı, tekrar gecede yığılma ve yeni üyede hayalet iade yok.
static func kaldir(y: KoyYonetimi) -> void:
	var d := durum(y)
	if d.is_empty(): return
	for id in d.uygulanan:
		var k := y.koylu(int(id))
		if k != null: k.moral = mini(100, k.moral + int(d.uygulanan[id]))
	d.uygulanan.clear()
	y.set_meta(META, d)

static func _uygula(y: KoyYonetimi, d: Dictionary) -> void:
	d.uygulanan.clear()
	for k in y.koylular:
		var miktar := mini(k.moral, int(d.ceza))
		if miktar <= 0: continue
		k.moral -= miktar
		d.uygulanan[str(k.id)] = miktar
	y.set_meta(META, d)

## Ölümler hâlâ _saglik_ve_moral içinde; önceki kişi referansları yalnız nedeni korur.
static func gece(y: KoyYonetimi, rapor: Dictionary, onceki_kisiler: Array[Koylu]) -> void:
	var d := durum(y)
	if not d.is_empty() and y.gun >= int(d.bitis): d = {}
	var sayi: int = rapor.olenler.size()
	if sayi > 0:
		var onceki := int(d.get("ceza", 0))
		var salgin := false
		for k in onceki_kisiler:
			if y.koylu(k.id) == null and SaglikYoneticisi.hasta(k): salgin = true
		d = {"baslangic": y.gun, "bitis": y.gun + SURE, "olum_gecesi": y.gun, "sayi": sayi, "ceza": maxi(onceki, mini(TAVAN, sayi * KISI_CEZA)), "onceki_ceza": onceki, "salgin": salgin, "secim": "", "toren_gun": -1, "katilanlar": [], "uygulanan": {}}
	if d.is_empty():
		y.set_meta(META, {})
		return
	_uygula(y, d)
	rapor["cenaze"] = {"gece": d.olum_gecesi, "sayi": d.sayi, "salgin": d.salgin, "secim": d.secim, "ceza": d.ceza}
	rapor.olaylar.append({"anahtar": "Yas: moral −%d (tavan %d), %d gün. Yeni ölümler cezayı toplamaz.", "deger": [d.ceza, TAVAN, int(d.bitis) - y.gun], "cenaze_yasi": true})

static func bekliyor(y: KoyYonetimi) -> bool:
	var d := durum(y)
	return y.son == "" and not d.is_empty() and d.secim == "" and y.gun == int(d.olum_gecesi) + 1

static func bedel(y: KoyYonetimi) -> int:
	return mini(6, int(durum(y).get("sayi", 0)) * 2)

## UI karar vermeden ilerlemez. Doğrudan gece/otomatik oyuncu için ücretsiz varsayılan.
static func gece_baslat(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	if not bekliyor(y): return
	if sec(y, int(durum(y).olum_gecesi), "toplu_mezar"):
		olaylar.append({"anahtar": "Bekleyen cenaze için ücretsiz toplu mezar uygulandı."})

static func neden(y: KoyYonetimi, gece_no: int, secim: String) -> String:
	if not bekliyor(y) or int(durum(y).olum_gecesi) != gece_no: return "Bu cenaze kararı artık beklemiyor"
	if secim not in ["toplu_mezar", "toren"]: return "Geçersiz cenaze seçimi"
	if secim == "toren" and (y.akce < bedel(y) or not y.kaynaklar.yeterli({"gida": bedel(y)})): return "%d erzak ve %d kamu akçesi gerekli" % [bedel(y), bedel(y)]
	return ""

## Karar atomik ve bir kez; gizli hastaları ifşa etmez, RNG çekmez.
static func sec(y: KoyYonetimi, gece_no: int, secim: String) -> bool:
	if not neden(y, gece_no, secim).is_empty(): return false
	var d := durum(y)
	var ucret := bedel(y)
	if secim == "toren":
		if not y.kaynaklar.harca({"gida": ucret}): return false
		y.akce -= ucret
	kaldir(y)
	d.uygulanan.clear()
	d.secim = secim
	if secim == "toren":
		d.ceza = maxi(int(d.onceki_ceza), ceili(mini(TAVAN, int(d.sayi) * KISI_CEZA) / 2.0))
		d.toren_gun = y.gun
		var kisiler := y.koylular.duplicate()
		kisiler.sort_custom(func(a: Koylu, b: Koylu) -> bool: return a.id < b.id)
		for k in kisiler:
			if SaglikYoneticisi.temas_edebilir(y, k) and k.yas_grubu == &"yetiskin": d.katilanlar.append(k.id)
			if d.katilanlar.size() >= KATILIM_TAVAN: break
	elif d.salgin:
		KuyuKirliligi.kirlet(y)
	_uygula(y, d)
	return true

## Karantina/zindan/dış görev kapısı KRI-01'de iki yönde tekrar doğrulanır.
static func ortak_toren(y: KoyYonetimi, a: Koylu, b: Koylu) -> bool:
	var d := durum(y)
	return not d.is_empty() and d.salgin and d.secim == "toren" and int(d.toren_gun) == y.gun and a.id in d.katilanlar and b.id in d.katilanlar

static func is_carpani(y: KoyYonetimi, k: Koylu) -> float:
	var d := durum(y)
	return IS_CARPANI if not d.is_empty() and d.secim == "toren" and int(d.toren_gun) == y.gun and k.id in d.katilanlar else 1.0

static func metin(y: KoyYonetimi) -> String:
	var d := durum(y)
	if d.is_empty(): return ""
	return "Cenaze: %d kişi · %s · geçici moral −%d · %d gün kaldı" % [d.sayi, {"": "karar bekliyor", "toplu_mezar": "Toplu mezar", "toren": "Cenaze töreni"}.get(d.secim), d.ceza, maxi(0, int(d.bitis) - y.gun + 1)]
