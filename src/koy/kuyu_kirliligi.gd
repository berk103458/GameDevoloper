## KRI-04: SuDengesi'nin tek kuyu kaynağı; ayrı su/hastalık motoru değildir.
class_name KuyuKirliligi
extends RefCounted
const META := &"kuyu_kirliligi"
const SURE := 3
const KIREC := 2
const YOGUNLUK_ASGARI := 3
const YOGUNLUK_YUZDE := 25

## Fail, CHR, gizli bayrak veya kanıt bu kayıtta tutulmaz.
static func oku(v: Variant) -> Dictionary:
	var temiz := {"baslangic": -1, "bitis": -1, "son_gece": -1, "yogunluk": false}
	if not v is Dictionary or not v.get("yogunluk") is bool: return temiz
	for alan in ["baslangic", "bitis", "son_gece"]:
		var n: Variant = v.get(alan)
		if (not n is int and not n is float) or not is_finite(float(n)) or float(n) != floor(float(n)) or float(n) < -1 or float(n) > 1000000000: return temiz
	if (v.baslangic == -1) != (v.bitis == -1) or (v.baslangic >= 0 and (v.bitis <= v.baslangic or v.bitis - v.baslangic > SURE)): return temiz
	return {"baslangic": int(v.baslangic), "bitis": int(v.bitis), "son_gece": int(v.son_gece), "yogunluk": v.yogunluk}

static func durum(y: KoyYonetimi) -> Dictionary:
	var d := oku(y.get_meta(META, {}))
	if int(d.baslangic) > y.gun or int(d.bitis) <= y.gun:
		d.baslangic = -1
		d.bitis = -1
	return d

static func kirli(y: KoyYonetimi) -> bool:
	var d := durum(y)
	return d.baslangic >= 0 and y.gun >= int(d.baslangic) and y.gun < int(d.bitis)

## Gerçek yeni kirlenme süreyi yeniler, üst üste süre biriktirmez; RNG yok.
static func kirlet(y: KoyYonetimi) -> void:
	if y.son != "": return
	var d := durum(y)
	d.baslangic = y.gun
	d.bitis = y.gun + SURE
	y.set_meta(META, d)

static func yukle(y: KoyYonetimi, v: Variant) -> void:
	var d := oku(v)
	if int(d.baslangic) > y.gun or int(d.bitis) <= y.gun:
		d.baslangic = -1
		d.bitis = -1
	if int(d.son_gece) > y.gun: d.son_gece = -1
	y.set_meta(META, d)

## MEV-07/CAS ile aynı ilk N taze su kullanıcısı; rezerv ve susuzlar hariç.
static func icenler(y: KoyYonetimi, su: Dictionary) -> Array[Koylu]:
	var kisi_su := maxi(1, SuDengesi.gerek(y) / maxi(1, y.nufus()))
	var sayi := mini(y.nufus(), ceili(float(su.get("taze", 0)) / kisi_su))
	var sonuc: Array[Koylu] = []
	for k in y.koylular.slice(0, maxi(0, sayi)):
		if SaglikYoneticisi.temas_edebilir(y, k): sonuc.append(k)
	return sonuc

## Karantina temas kapısı su rutinini de kapatır; dış görev/zindan hariç.
## Yoğunluk eşik geçişidir: temizlik aynı salgında hemen geri alınmaz.
static func gece(y: KoyYonetimi, su: Dictionary, olaylar: Array[Dictionary], temas_yeni: int = 0) -> void:
	var d := durum(y)
	if y.son != "" or int(d.son_gece) == y.gun: return
	var yerel := 0
	var belirtili := 0
	for k in y.koylular:
		if not SaglikYoneticisi.temas_edebilir(y, k): continue
		yerel += 1
		if SaglikYoneticisi.hasta(k) and "hasta" in k.bayraklar: belirtili += 1
	var yogun := belirtili >= YOGUNLUK_ASGARI and belirtili * 100 >= yerel * YOGUNLUK_YUZDE
	if yogun and not d.yogunluk:
		kirlet(y)
		d = durum(y)
		olaylar.append({"anahtar": "Hasta yoğunluğu kuyu suyunu kirletti; acil kireçleme gerekli.", "deger": []})
	d.yogunluk = yogun
	d.son_gece = y.gun
	y.set_meta(META, d)
	if not kirli(y): return
	var yeni := 0
	var kalan := maxi(0, SaglikYoneticisi.AZAMI_YENI - temas_yeni)
	for k in icenler(y, su):
		if yeni >= kalan: break
		if SaglikYoneticisi.hasta(k): continue
		if y._rng.randi_range(1, 100) <= int(SaglikYoneticisi.AYAR.tifo.risk):
			if SaglikYoneticisi.enfekte(y, k, "tifo"): yeni += 1
	olaylar.append({"anahtar": "Kirli kuyu: taze su kullananlarda tifo riski. Kuyu bilgisinden %d kireçle dezenfekte et; fail kanıtı değildir.", "deger": [KIREC]})

## Aynı kaynakla ilişkili mevcut CHR bina bilgisi; -1 gerçek meydan kuyusu.
static func kuyu_bilgisi(y: KoyYonetimi, bina_id: int) -> bool:
	if bina_id == -1: return true
	var b := y.bina(bina_id)
	return b != null and b.hazir() and b.tur in ["su_kuyusu", "su_arki"]

static func neden(y: KoyYonetimi, bina_id: int = -1) -> String:
	if y.son != "" or not kuyu_bilgisi(y, bina_id): return "Güncel, hazır kuyu bilgisi gerekli"
	if not kirli(y): return "Kuyu temiz"
	if not y.kaynaklar.yeterli({"kirec": KIREC}): return "%d kireç gerekli" % KIREC
	return ""

## Hasta iyileştirme ve CAS delil silme yok. Debug zehir kaynağı da durur.
static func temizle(y: KoyYonetimi) -> void:
	var d := durum(y)
	d.baslangic = -1
	d.bitis = -1
	y.set_meta(META, d)
	y.remove_meta(KrizEnjektoru.META)

static func kirecle(y: KoyYonetimi, bina_id: int = -1) -> bool:
	if not neden(y, bina_id).is_empty() or not y.kaynaklar.harca({"kirec": KIREC}): return false
	temizle(y)
	return true

static func metin(y: KoyYonetimi) -> String:
	var bilgi := "Kirli kuyu · %d gece kaldı · taze su kullananlarda tifo riski %%%d" % [maxi(0, int(durum(y).bitis) - y.gun), int(SaglikYoneticisi.AYAR.tifo.risk)] if kirli(y) else "Kuyu temiz · su kaynaklı tifo riski yok"
	return bilgi + "\nAcil dezenfeksiyon: %d kireç · stok %d. Hastaları iyileştirmez; kırık bent ayrıca onarılmalıdır. Sağlık belirtisi fail kanıtı değildir." % [KIREC, y.kaynaklar.miktar("kirec")]
