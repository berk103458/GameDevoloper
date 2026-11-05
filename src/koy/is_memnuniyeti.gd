## UZM-06 denge varsayımları; mevcut moral/atama/pasif veriden türetilir.
class_name IsMemnuniyeti
extends RefCounted
const MORAL := 2
const TABAN_ESIK := 20
const SABOTAJ := 0.02
const ISYAN_SABOTAJ := 0.12

static func esik(k: Koylu) -> int:
	var zayif: Array = k.pasif_ozellikler.get("zayif", [])
	if "ofkeli" in zayif or "inatci" in zayif or "kibirli" in zayif: return 30
	if "dayanikli" in k.pasif_ozellikler.get("guclu", []): return 10
	return TABAN_ESIK

static func gorev(k: Koylu, y: KoyYonetimi) -> String:
	if k.is_yeri == TasYatagi.IS_YERI: return "tas_ocagi"
	if k.is_yeri == KoyYonetimi.MUHAFIZ: return "muhafiz_kislasi"
	var b := y.bina(k.is_yeri)
	return b.tur if b != null and b.hazir() else ""

static func uyum(k: Koylu, y: KoyYonetimi) -> float:
	var tur := gorev(k, y)
	if tur == "degirmen" and YasRolleri.danisman(k, tur): return 1.0
	return MeslekUyumu.carpan(k, tur) if not tur.is_empty() else 1.0

static func isyanci(k: Koylu, y: KoyYonetimi) -> bool:
	if MeslekGrevi.aktif(k, y): return true
	if not YasRolleri.atanabilir(k, gorev(k, y)): return false
	return uyum(k, y) < 1.0 and k.moral <= esik(k) and CirakEgitimi.saglam(k)

static func sabotaj_riski(k: Koylu, y: KoyYonetimi) -> float:
	if MeslekGrevi.aktif(k, y): return 0.0
	if uyum(k, y) >= 1.0 or not CirakEgitimi.saglam(k) or IsKazalari.uyuyor(k): return 0.0
	var r := ISYAN_SABOTAJ if isyanci(k, y) else SABOTAJ
	return r * 2.0 if IsKazalari.nobet(k, y) else r

static func gece(y: KoyYonetimi, calismalar: Dictionary, olaylar: Array[Dictionary]) -> void:
	for k in y.koylular:
		if MeslekGrevi.aktif(k, y): continue
		if not YasRolleri.atanabilir(k, gorev(k, y)): continue
		# Fiilî çalışma/nöbet veya uyumsuz göreve kişisel iş reddi.
		var aktif := calismalar.has(k.id) or (IsKazalari.nobet(k, y) and not IsKazalari.uyuyor(k)) or isyanci(k, y)
		if not aktif or not CirakEgitimi.saglam(k): continue
		var u := uyum(k, y)
		if is_equal_approx(u, 1.0): continue # Genel esnaf/belirsiz için sevdiği iş uydurulmaz.
		k.moral = clampi(k.moral + (MORAL if u > 1.0 else -MORAL), 0, 100)
		var risk := sabotaj_riski(k, y)
		if risk == 0.0 or y._rng.randf() >= risk: continue
		var kaynak := "alet" if y.kaynaklar.miktar("alet") > 0 else "gida"
		var kayip := y.kaynaklar.azalt(kaynak, 1 if kaynak == "alet" else 3)
		y.asayis_riski = mini(100, y.asayis_riski + 3)
		k.sadakat = maxi(0, k.sadakat - 2)
		CasusGeceTakibi.kaydet(y, k, "cephanelik" if kaynak == "alet" else "ambar", -1, "sabotaj", kaynak, kayip, false)
		olaylar.append({"anahtar": "Köylü %d iş uyumsuzluğu nedeniyle sabotaj yaptı: %d %s kayıp.", "deger": [k.id, kayip, kaynak]})

	preload("res://src/koy/bosta_kalma.gd").gece(y, calismalar)

static func metin(k: Koylu, y: KoyYonetimi) -> String:
	var u := uyum(k, y)
	var durum := "Nötr iş" if is_equal_approx(u, 1.0) else ("Uyumlu iş: fiilî gece +2 moral" if u > 1.0 else "Uyumsuz iş: fiilî gece −2 moral")
	if gorev(k, y).is_empty(): durum = "Görev yok"
	return "%s · moral %d · kişisel isyan eşiği %d%s · aktif uyumsuz görevde sabotaj %%%.0f" % [durum, k.moral, esik(k), " · işi reddediyor" if isyanci(k, y) else "", sabotaj_riski(k, y) * 100.0]
