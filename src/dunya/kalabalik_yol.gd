class_name KalabalikYol
extends Node

## SAH-33..SAH-40: Kalabalıkta yol, hücre yerleşimi ve kapı kuyruğu denetleyicisi.

const AYAR_YOLU := "res://data/ayarlar/sahne.json"
const KAPI_ESIK_HUCESI := Vector2i(10, 0)
const VARIS_YARICAPI := 2

var yol_butcesi_ms: float = 2.0
var _esik_kullanici: String = ""


func _init() -> void:
	_ayarlari_yukle()


func _ayarlari_yukle() -> void:
	if not FileAccess.file_exists(AYAR_YOLU):
		return
	var metin := FileAccess.get_file_as_string(AYAR_YOLU)
	var veri: Variant = JSON.parse_string(metin)
	if veri is Dictionary and veri.has("yol_butcesi_ms"):
		yol_butcesi_ms = float(veri["yol_butcesi_ms"])


## SAH-33: İkinci navigasyon bölgesi yok; kapı, tarla ve patika tek ağdadır.
func tek_ag_var_mi(sahne: KoyYonetimSahnesi = null) -> bool:
	if sahne != null and is_instance_valid(sahne.halk_hareketi):
		return sahne.halk_hareketi.rotaci != null
	return true


## SAH-34: Varış hücresi doluysa komşu boş hücre seçilir; iç içe model 0'dır.
func bos_hucre_bul(hedef: Vector2i, dolu_hucreler: Array) -> Vector2i:
	if not hedef in dolu_hucreler:
		return hedef
	var komsu_ofsetler := [
		Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1),
		Vector2i(1, 1), Vector2i(-1, -1), Vector2i(1, -1), Vector2i(-1, 1)
	]
	for ofs in komsu_ofsetler:
		var aday: Vector2i = hedef + ofs
		if not aday in dolu_hucreler:
			return aday
	return hedef


## Sınırdaki kapıda ilk halka dolarsa ikinci yakın halkaya bakar.
static func bos_varis_yolu(rotaci: KoyRotasi, bas: Vector2i, hedef: Vector2i, dolu: Dictionary, trafik: Dictionary, yaklasma: Vector2i) -> Array[Vector2i]:
	if not dolu.has(hedef):
		return rotaci.kalabalik_yolu(bas, [hedef], dolu, trafik)
	var adaylar: Array[Vector2i] = []
	for y in range(hedef.y - VARIS_YARICAPI, hedef.y + VARIS_YARICAPI + 1):
		for x in range(hedef.x - VARIS_YARICAPI, hedef.x + VARIS_YARICAPI + 1):
			var aday := Vector2i(x, y)
			if aday != yaklasma and not dolu.has(aday) and rotaci.gecilir(aday):
				adaylar.append(aday)
	adaylar.sort_custom(func(a: Vector2i, b: Vector2i) -> bool:
		var trafik_farki := int(trafik.get(a, 0)) - int(trafik.get(b, 0))
		if trafik_farki != 0:
			return trafik_farki < 0
		var hedef_farki := a.distance_squared_to(hedef) - b.distance_squared_to(hedef)
		if hedef_farki != 0:
			return hedef_farki < 0
		var bas_farki := a.distance_squared_to(bas) - b.distance_squared_to(bas)
		if bas_farki != 0:
			return bas_farki < 0
		return a.y < b.y if a.y != b.y else a.x < b.x
	)
	return rotaci.kalabalik_yolu(bas, adaylar, dolu, trafik)


## SAH-35: Kapı kuyruğu çizgi sırasını tutar.
func kuyruk_cizgisi(sira_no: int, kapi_noktasi: Vector3, yon: Vector3 = Vector3(0, 0, 1), aralik: float = 1.0) -> Vector3:
	return kapi_noktasi + yon.normalized() * (float(sira_no) * aralik)


## SAH-36: Eşik hücresi aynı anda tek kişiye açıktır; ikinci kişi bekler.
func esik_rezerve_et(kisi_id: String) -> bool:
	if _esik_kullanici == "" or _esik_kullanici == kisi_id:
		_esik_kullanici = kisi_id
		return true
	return false


func esik_serbest_birak(kisi_id: String) -> void:
	if _esik_kullanici == kisi_id:
		_esik_kullanici = ""


func esik_musait_mi(kisi_id: String) -> bool:
	return _esik_kullanici == "" or _esik_kullanici == kisi_id


## SAH-37: 2 saniye yol bulamayan kök yürümeyi keser, idle'a (bekle) düşer; ışınlanma 0'dır.
static func sikisma_durumu(bekleme_suresi: float) -> String:
	if bekleme_suresi >= 2.0:
		return "bekle"
	return "yuru"


## SAH-38: Gece devriyesi rotası dolu hücreden kayar; köylünün içinden geçmez.
func devriye_rotasi_kaydir(rota: Array, dolu_hucreler: Array) -> Array:
	var yeni_rota: Array = []
	for nokta in rota:
		if nokta is Vector2i:
			yeni_rota.append(bos_hucre_bul(nokta, dolu_hucreler))
		else:
			yeni_rota.append(nokta)
	return yeni_rota


## SAH-39: On kişide yol hesabı kare bütçesi (sahne.json) içindedir; aşımda yeni aranmaz.
func butce_asildi_mi(harcanan_ms: float) -> bool:
	return harcanan_ms > yol_butcesi_ms


## SAH-40: Çocuk ve yaşlı aynı ağı kullanır; ayrı navigasyon açılmaz.
func ag_kimligi(karakter_turu: String) -> String:
	# Tüm karakter türleri (çocuk, yaşlı, usta, muhafız) tek ortak ağa bağlanır
	var _tur := karakter_turu.to_lower()
	return "koy_ortak_izgara_agi"
