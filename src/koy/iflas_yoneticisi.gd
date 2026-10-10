## EKO-10: üst üste gerçek kamu açığında tefeci baskını ve iadesiz el koyma.
class_name IflasYoneticisi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/iflas.json"))
## Optional kayıt geçmişini doğrular; eski kayda iflas uydurmaz.
static func oku(v: Variant) -> Dictionary:
	var r := {"eksi_gece": 0, "el_konuldu": false, "son_gece": -1, "son_varlik": ""}
	if not v is Dictionary: return r
	r.eksi_gece = _tam(v.get("eksi_gece"), 0, int(AYAR.eksi_gece_esigi), 0)
	r.son_gece = _tam(v.get("son_gece"), -1, 1000000000, -1)
	r.el_konuldu = v.get("el_konuldu") is bool and v.el_konuldu and r.eksi_gece == int(AYAR.eksi_gece_esigi)
	if v.get("son_varlik") is String: r.son_varlik = String(v.son_varlik).left(128)
	return r
## Gecede bir kez sayaç; borç serisinde eşiğe gelince bir kamu varlığına el koyar.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	var s := y.iflas_durumu
	if s.son_gece == y.gun: return
	s.son_gece = y.gun
	if y.akce >= 0:
		s.eksi_gece = 0
		s.el_konuldu = false
		return
	s.eksi_gece = mini(int(AYAR.eksi_gece_esigi), int(s.eksi_gece) + 1)
	if s.eksi_gece < int(AYAR.eksi_gece_esigi) or s.el_konuldu: return
	s.el_konuldu = true
	s.son_varlik = _el_koy(y)
	olaylar.append({"anahtar": "koy.olay.iflas", "deger": [s.son_varlik]})
## Oyuncuya gerçek kamu açığı serisini açıklar; kasaya veya RNG'ye yazmaz.
static func tip(y: KoyYonetimi) -> String:
	return "Kamu akçesi: %d\nÜst üste eksi geceler: %d/%d. Tefeci baskını kamu varlığına el koyar; kişisel kese korunur." % [y.akce, y.iflas_durumu.eksi_gece, int(AYAR.eksi_gece_esigi)]
## Yeni iflas olayının CSV kilidiyle uyumlu ince metin adaptörü; diğer olaylar eski çeviriyi kullanır.
static func olay_metin(e: Dictionary) -> String:
	if e.has("kriz_kenetlenmesi"): return KoyYonetimi.KRIZ_KENETLENMESI.olay_metin(e)
	if e.has("aclik_saglik"): return KoyYonetimi.ACLIK_SAGLIK.olay_metin(e)
	if e.has("levent_firari"): return KoyYonetimi.LEVENT_FIRARI.olay_metin(e)
	if e.has("kitlik_isyani"): return KitlikIsyani.olay_metin(e)
	if e.has("tekfur_harac"): return TekfurHaracHeyeti.metin(e.tekfur_harac)
	if e.has("mogol_oncusu"): return MogolOncusu.olay_metin(e.mogol_oncusu)
	if e.has("muhafiz_kabus"): return MuhafizVicdani.olay_metin(e.muhafiz_kabus)
	if e.has("sancak_teftisi"): return SancakTeftisi.olay_metin(e.sancak_teftisi)
	if e.has("muhafiz_harac"): return MuhafizYetenekleri.olay_metin(e.muhafiz_harac)
	if e.get("anahtar") == "koy.olay.ambar_ziyan": return AmbarBakimi.olay_metin(e)
	var d: Array = e.get("deger", [])
	if e.get("anahtar") == "koy.olay.iflas": return "Tefeci baskını: %d gece kamu açığı. El konulan kamu varlığı: %s. Borç ve kişisel kese değişmedi." % [int(AYAR.eksi_gece_esigi), String(d[0])]
	return (TranslationServer.translate(e.anahtar) % d) if not d.is_empty() else TranslationServer.translate(e.anahtar)
static func _el_koy(y: KoyYonetimi) -> String:
	var son_bina: KoyBinasi
	for b in y.binalar:
		if son_bina == null or b.id > son_bina.id: son_bina = b
	if son_bina != null:
		var ad := KoyluKartiVerisi.bina_adi(son_bina.tur)
		y.bina_el_koy(son_bina.id)
		return ad
	for tur in AYAR.stok_el_koyma:
		var adet := y.kaynaklar.azalt(tur, int(AYAR.stok_el_koyma[tur]))
		if adet > 0: return "%d %s" % [adet, DemirZinciri.ad("koy.kaynak." + tur)]
	return "El konulabilir kamu malı yok"
static func _tam(v: Variant, alt: int, ust: int, varsayilan: int) -> int:
	if (v is int or v is float) and is_finite(float(v)) and floor(float(v)) == float(v) and float(v) >= alt and float(v) <= ust: return int(v)
	return varsayilan
