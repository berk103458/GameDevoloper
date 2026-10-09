## KRI-02: mevcut Şifahane içinde iki gecelik, oyuncunun seçtiği izolasyon.
class_name KarantinaYoneticisi
extends RefCounted
const SURE := 2
const GIRIS_GIDA := 1
const MORAL_KAYBI := 2
const TABAN_KONTENJAN := 2
const AZAMI_KONTENJAN := 4

## Optional JSON; gizli enfeksiyon/bayrak bu kayıttan türetilmez.
static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary: return {}
	for alan in ["baslangic", "bitis", "bina"]:
		var n: Variant = v.get(alan)
		if (not n is int and not n is float) or not is_finite(float(n)) or float(n) != floor(float(n)) or float(n) < 0 or float(n) > 1000000000: return {}
	if v.bina <= 0 or v.bitis - v.baslangic != SURE: return {}
	return {"baslangic": int(v.baslangic), "bitis": int(v.bitis), "bina": int(v.bina)}

static func aktif(k: Koylu) -> bool:
	return k != null and not k.karantina.is_empty()

## Günlük tedavi makbuzundan bağımsız yatak; aynı hekim işleyiş koşulları.
static func kapasite(y: KoyYonetimi, b: KoyBinasi) -> int:
	if b == null or b.tur != "sifahane" or not b.hazir() or y.isyan_kalan >= 0 or KanDavasi.engel(y, b.id): return 0
	for k in y.calisanlar(b.id):
		if Sifahane.hekim_calismaya_uygun(y, k, b):
			return mini(AZAMI_KONTENJAN, BinaSeviyesi.kapasite(TABAN_KONTENJAN, b.seviye))
	return 0

static func dolu(y: KoyYonetimi, bina_id: int) -> int:
	var n := 0
	for k in y.koylular:
		if aktif(k) and int(k.karantina.bina) == bina_id: n += 1
	return n

static func bos(y: KoyYonetimi) -> int:
	var n := 0
	for b in y.binalar: n += maxi(0, kapasite(y, b) - dolu(y, b.id))
	return n

## Gizli hasta durumu okunmaz: aynı düğme sağlıklı kişide de vardır.
static func neden(y: KoyYonetimi, k: Koylu) -> String:
	if y.son != &"" or k == null or k.saglik <= 0: return "Köylü karantinaya alınamıyor"
	if aktif(k): return "Zaten karantinada"
	if DivanHukmu.zindanda(k) or KervanKorumasi.disarida(y, k.id): return "Köylü köyde serbest değil"
	if bos(y) <= 0: return "İşler Şifahane karantina kontenjanı yok"
	if y.kaynaklar.miktar("gida") < GIRIS_GIDA: return "1 erzak gerekli"
	return ""

static func al(y: KoyYonetimi, id: int) -> bool:
	var k := y.koylu(id)
	if not neden(y, k).is_empty(): return false
	var uygun: Array[KoyBinasi] = []
	for b in y.binalar:
		if kapasite(y, b) > dolu(y, b.id): uygun.append(b)
	uygun.sort_custom(func(a: KoyBinasi, b: KoyBinasi) -> bool: return a.id < b.id)
	if uygun.is_empty() or not y.kaynaklar.harca({"gida": GIRIS_GIDA}): return false
	k.karantina = {"baslangic": y.gun, "bitis": y.gun + SURE, "bina": uygun[0].id}
	k.moral = maxi(0, k.moral - MORAL_KAYBI)
	return true

static func cikar(y: KoyYonetimi, id: int) -> bool:
	var k := y.koylu(id)
	if y.son != &"" or not aktif(k): return false
	k.karantina.clear()
	return true

## Yükleme/gece başı ve gün ilerledikten sonra; atama/bedel değişmez.
## Hekim geçici durursa mevcut kişiler süreyi tamamlar, yeni kabul sıfıra iner.
static func esitle(y: KoyYonetimi, olaylar: Array[Dictionary] = []) -> void:
	for k in y.koylular:
		if not aktif(k): continue
		var d := oku(k.karantina)
		var b := y.bina(int(d.get("bina", -1)))
		if d.is_empty() or y.gun < int(d.baslangic) or y.gun >= int(d.bitis) or b == null or b.tur != "sifahane" or not b.hazir() or k.saglik <= 0 or DivanHukmu.zindanda(k) or KervanKorumasi.disarida(y, k.id):
			k.karantina.clear()
			olaylar.append({"anahtar": "%s karantinadan çıktı; mevcut görev ve ev ataması korunuyor.", "deger": [k.ad]})

static func metin(y: KoyYonetimi, k: Koylu) -> String:
	if aktif(k): return "Karantina: %d gün kaldı · temas engelli · çalışmaz · görev/ev ataması korunur" % maxi(0, int(k.karantina.bitis) - y.gun)
	return "Şüpheyle karantina: 2 gün · 1 erzak, kişisel moral −2 · boş kontenjan %d" % bos(y)
