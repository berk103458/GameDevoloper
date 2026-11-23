## ACL-04: ilk akşamın tek seferlik geçişi. Ek ekonomi/diyalog motoru yok.
extends RefCounted
const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const BASLADI := &"acl04_basladi"
const ULAK := &"acl04_ulak_gecti"
const BITTI := &"acl04_aile_karari"
const AILE := &"acl04_ilk_aile"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/kapi_acilisi.json"))

static func gece_engelli(o: Oturum) -> bool:
	return o.gun == 0 and ACILIS.durum(o).get("kuruldu", false) and not o.bayraklar.has(BITTI)

static func baslat(o: Oturum) -> bool:
	if not gece_engelli(o) or o.bayraklar.has(BASLADI): return false
	o.bayraklar[BASLADI] = true
	return true

static func ulak_suresi() -> float:
	return clampf(float(AYAR.ulak_saniye), 1.0, 59.0)

static func ulak_bitir(o: Oturum) -> void:
	if gece_engelli(o) and o.bayraklar.has(BASLADI):
		o.bayraklar[ULAK] = true

static func aile_bekliyor(o: Oturum) -> bool:
	return gece_engelli(o) and o.bayraklar.has(ULAK)

static func kuyruk(o: Oturum) -> Array[Gelen]:
	var sonuc: Array[Gelen] = []
	if not aile_bekliyor(o): return sonuc
	var g := Gelen.new()
	g.aile_id = "acl04_ilk_aile"
	g.aile = preload("res://src/kapi/aile_kafilesi.gd").uyeleri_oku(AYAR.aile)
	g.id = AILE
	g.ad_anahtari = String(AYAR.aile_adi)
	g.portre = String(AYAR.aile[0].portre)
	g.giris_anahtari = "diyalog.kapi.ilk_aile.sahne"
	g.acilis = String(AYAR.acilis)
	g.sorular = [PackedStringArray(AYAR.selam), PackedStringArray(AYAR.konu)]
	g.soru_ust = PackedInt32Array([-1, 0])
	for ek: Array in AYAR.ek_sorular:
		g.sorular.append(PackedStringArray(ek))
		g.soru_ust.append(-1)
	g.secenekler = PackedStringArray(["kabul", "ret"])
	g.esikler = PackedInt32Array([0, 0])
	g.heybe = Heybe.new()
	g.heybe.ekle("akce", "akce", 1, 0, false)
	sonuc.append(g)
	return sonuc

static func karar_engelli(o: Oturum, g: Gelen, karar: StringName) -> bool:
	if g.id == &"acl04_ulak": return true
	return g.id == AILE and (not aile_bekliyor(o) or not karar in [&"kabul", &"ret"])

## İlk kişi mevcut karar API'sinden geçer; sabit sahnedeki ikinci yetişkin aynı kararı paylaşır.
## Genel aile motoru değildir; KAP-17'ye geçiş kaydı data/gecis.json içindedir.
static func karar_sonrasi(o: Oturum, g: Gelen, sonuc: Dictionary) -> void:
	if g.id != AILE or not aile_bekliyor(o) or sonuc.get("engellendi", false): return
	if sonuc.get("kaldi", false):
		var ilk := o.yonetim.koylu(int(sonuc.koylu_id))
		if ilk != null: ilk.ad = String(AYAR.aile[0].ad)
		if g.aile.size() < 2: o.yonetim.kabul(AYAR.aile[1].duplicate(true))
		o._koy_esitle()
	o.bayraklar[BITTI] = "kabul" if sonuc.get("kaldi", false) else "ret"
