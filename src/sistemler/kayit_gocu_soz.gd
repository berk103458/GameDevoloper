## KAY-03 ve KAY-04: SYS-14'ün tek-adım yürütücüsü ve içerik/kayıt sürümü ayrımı; dosya yazmaz.
extends RefCounted

const OYNANIS_GRUBU := &"kayit_gocu_oynanis_ekrani"

const ICERIK_YOLU := "res://data/ayarlar/icerik.tres"

## Adım listesi yalnız güvenilir kodun Callable'larından gelir; kayıt dosyasından kod yüklenmez.
static func uygula(kayit: Dictionary, hedef_surumu: int, adimlar: Dictionary) -> Dictionary:
	var surum := _surum(kayit.get("surum"))
	if surum < 0 or hedef_surumu < surum: return {}
	if surum < hedef_surumu and oynanis_acik():
		push_error("KAY71_GAMEPLAY_MIGRATION: sürüm göçü yalnız yükleme adımında çalışır")
		return {}
	var veri := kayit.duplicate(true)
	while surum < hedef_surumu:
		var adim: Variant = adimlar.get(surum)
		if not adim is Callable or not adim.is_valid(): return {}
		# Hatalı adım ne başlangıç sözlüğüne ne önceki sağlam adıma yazabilir.
		var sonuc: Variant = adim.call(veri.duplicate(true))
		if not sonuc is Dictionary or _surum(sonuc.get("surum")) != surum + 1: return {}
		veri = sonuc.duplicate(true)
		surum += 1
	return veri


## KAY-04: `data/ayarlar/icerik.tres` yalnız okunur; yazılmaz.
static func icerik_surumu_oku(yol: String = ICERIK_YOLU) -> int:
	if not ResourceLoader.exists(yol):
		return 1
	var res := load(yol)
	if res != null and "icerik_surumu" in res:
		return maxi(1, int(res.get("icerik_surumu")))
	return 1


## KAY-04: İçerik sürümü ile kayıt sürümü ayrıdır; eski kayıttaki eksik sabah/eylem/boş gün alanlarını
## varsayılanlarıyla tamamlar, kişi hafızasını silmez ve aynı kapı eylemini ikinci kez uygulamaz.
static func kay04_hazirla(kayit: Dictionary, guncel_icerik_surumu: int = -1) -> Dictionary:
	var veri := kayit.duplicate(true)
	var hedef_icerik := guncel_icerik_surumu if guncel_icerik_surumu > 0 else icerik_surumu_oku()
	veri["icerik_surumu"] = hedef_icerik
	# Kişi hafızası (`kisi_hafizasi` / `durumlar`) içerik sürümü artsa da silinmez; katalog yeniden kurulmaz.
	if not (veri.get("sabah_defteri_satiri", null) is String):
		veri["sabah_defteri_satiri"] = ""
	if not (veri.get("sabah_gun_sayaci", null) is int or veri.get("sabah_gun_sayaci", null) is float):
		veri["sabah_gun_sayaci"] = 0
	else:
		veri["sabah_gun_sayaci"] = maxi(0, int(veri["sabah_gun_sayaci"]))
	var ham_eylemler: Variant = veri.get("kapi_eylemleri", [])
	var tekil_eylemler: Array[String] = []
	if ham_eylemler is Array:
		for e in ham_eylemler:
			var s := String(e).strip_edges()
			if not s.is_empty() and not tekil_eylemler.has(s):
				tekil_eylemler.append(s)
	veri["kapi_eylemleri"] = tekil_eylemler
	var gun_turu := String(veri.get("gun_turu", "")).strip_edges()
	veri["gun_turu"] = "bos" if gun_turu == "bos" else ""
	return veri


static func _surum(v: Variant) -> int:
	if (v is int or v is float) and is_finite(float(v)) and float(v) >= 0 and float(v) == floor(float(v)) and float(v) <= 1000000000:
		return int(v)
	return -1


## KAY-71: UI sınıflarını içeri almadan mevcut Ana ekranının yaşam döngüsünü oku.
static func oynanis_isaretle(ekran: Node, acik: bool) -> void:
	if ekran == null: return
	if acik: ekran.add_to_group(OYNANIS_GRUBU)
	elif ekran.is_in_group(OYNANIS_GRUBU): ekran.remove_from_group(OYNANIS_GRUBU)

static func oynanis_acik() -> bool:
	var agac := Engine.get_main_loop() as SceneTree
	if agac == null: return false
	for ekran in agac.get_nodes_in_group(OYNANIS_GRUBU):
		if not ekran.is_queued_for_deletion(): return true
	return false
