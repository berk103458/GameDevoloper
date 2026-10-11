## BUG-20: gerçek kuyruk kişisinde tek seçim; cenaze mevcut gece taramasında çözülür.
class_name SiraOlayiSonucu
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/sira_olaylari/sonuclar.json"))
const META := &"sira_bayilma_sonucu"
const RAPOR := &"sira_olayi_raporu"
const TURLER := ["olum", "sakatlik", "ayrilma", "toparlanma", "yardim"]

static func sec(rng: RandomNumberGenerator) -> String:
	var toplam := 0.0
	for agirlik in AYAR.agirliklar.values(): toplam += float(agirlik)
	var zar := rng.randf() * toplam
	for tur in AYAR.agirliklar:
		zar -= float(AYAR.agirliklar[tur])
		if zar < 0.0: return tur
	return "toparlanma"

## Optional rapor makbuzu; bozuk kayıt ölüm/RNG veya ücret üretmez.
static func oku(v: Variant) -> Array[Dictionary]:
	var r: Array[Dictionary] = []
	if not v is Array: return r
	for d in v:
		if not d is Dictionary or d.get("sonuc") not in TURLER: continue
		if not d.get("ad") is String or not d.get("kisi") is String: continue
		r.append({"sonuc": String(d.sonuc), "ad": String(d.ad), "kisi": String(d.kisi)})
	return r

static func durum(y: KoyYonetimi) -> Array[Dictionary]:
	return oku(y.get_meta(RAPOR, []))

static func neden(g: Gelen) -> String:
	return "Bu kişi sıradan ayrıldı" if g.get_meta(META, {}).get("sonuc", "") in ["olum", "ayrilma"] else ""

static func kabul(g: Gelen, k: Koylu) -> void:
	if g.get_meta(META, {}).get("sonuc", "") == "sakatlik":
		k.saglik = mini(k.saglik, int(AYAR.sakat_saglik))
		k.bayrak_ekle("sira_sakatligi")

## Daha önce sonuçlandırılmış kişi ikinci kez yere düşürülmez.
static func baslayabilir(e: Node, olay: OlayVerisi, model: KarakterModel) -> bool:
	if olay.id != &"sira_bayilma": return true
	var s: KapiSahnesi = e.get("sahne")
	var kuyruk: Array[Gelen] = e.get("_kuyruk")
	var i := s._kuyruktakiler.find(model)
	return i >= 0 and i < kuyruk.size() and not kuyruk[i].has_meta(META)

## UI kaynağı kopyalar; genel olay etkisi ve yardım bedeli mevcut motor tarafından bir kez uygulanır.
static func uygula(e: Node, olay: OlayVerisi, i: int, model: KarakterModel) -> Dictionary:
	var o: Oturum = e.get("oturum")
	var engel := {"engellendi": true, "kirilan": -1}
	if i < 0 or i >= olay.secenek_etkileri.size() or not o.secenek_olur(olay, i): return engel
	if olay.id != &"sira_bayilma":
		var genel := o.olay_uygula(olay, i)
		genel["etki"] = olay.secenek_etkileri[i].duplicate(true)
		return genel
	var s: KapiSahnesi = e.get("sahne")
	var kuyruk: Array[Gelen] = e.get("_kuyruk")
	var indeks := s._kuyruktakiler.find(model)
	if indeks < 0 or indeks >= kuyruk.size() or model != SiraOlayiKisisi.sec(s, "bayilma"): return engel
	var g: Gelen = kuyruk[indeks]
	if g.has_meta(META): return engel
	var sonuc := o.olay_uygula(olay, i)
	var tur := "yardim" if i == 0 else sec(o._rng)
	g.set_meta(META, {"sonuc": tur})
	var kisi := GuvenliMetin.metin(SiraOlayiKisisi.anahtar(model))
	var r := durum(o.yonetim)
	r.append({"sonuc": tur, "ad": o.tr_gelen(g), "kisi": kisi})
	o.yonetim.set_meta(RAPOR, r)
	var etki: Dictionary = olay.secenek_etkileri[i].duplicate(true)
	etki["sira_sonuc"] = tur
	if tur in ["olum", "ayrilma"]:
		kuyruk.remove_at(indeks)
		if g.adli and o.kadro.durumlar.has(g.id): o.kadro.durumlar[g.id]["durum"] = &"kalici_ayrildi"
	sonuc["etki"] = etki
	sonuc["sonuc_anahtari"] = "olay.sira_bayilma.sonuc_" + tur
	return sonuc

## Sağlık taramasından sonra, mevcut CenazeYasi.gece çağrısından hemen önce bir kez tüketilir.
static func rapora_ekle(y: KoyYonetimi, rapor: Dictionary) -> void:
	var r := durum(y)
	y.set_meta(RAPOR, [])
	for d in r:
		rapor.olaylar.append({"anahtar": SiraOlayiKisisi.metin("olay.sira_bayilma.rapor_" + d.sonuc, d.kisi), "sira_sonuc": true})
		if d.sonuc == "olum": rapor.olenler.append(d.ad)

## Sakat/toparlanmış kişi ayağa kalkar; ölen/ayrılan gerçek model ve isim sırası birlikte çıkar.
static func canlandir(s: KapiSahnesi, i: int, etki: Dictionary) -> void:
	var k: KarakterModel = s._kuyruktakiler[i]
	var tur := String(etki.get("sira_sonuc", "yardim" if etki.get("bar", [0])[0] > 0 else "toparlanma"))
	if tur not in ["olum", "ayrilma"]:
		var t := s.create_tween()
		t.tween_property(k, "rotation:x", 0.0, 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await t.finished
		k.bak(Vector3(0, 0, 10))
		return
	s._kuyruktakiler.remove_at(i)
	s._kuyruk_yerleri.remove_at(i)
	s._kuyruk_adlari.remove_at(i)
	s._kuyruk_ilerle()
	if tur == "ayrilma":
		k.rotation.x = 0.0
		await k.yuru(k.position + Vector3(0, 0, -8.0), 3.0)
	else:
		var t := s.create_tween()
		t.tween_property(k, "position:x", k.position.x - 2.4, 1.2)
		await t.finished
	await s._belir(k, 0.0)
	if is_instance_valid(k): k.queue_free()
