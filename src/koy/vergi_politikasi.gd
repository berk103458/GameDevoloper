## EKO-08: gerçek haftalık kamu tahsilatı, Moral ve ekonomik Refah.
class_name VergiPolitikasi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/vergi_politikasi.json"))
## Tanımlı seçimi kaydeder; oran değiştirme tahsilat veya gün/RNG üretmez.
static func sec(y: KoyYonetimi, oran: String) -> bool:
	if not AYAR.has(oran): return false
	y.vergi_orani = oran
	return true
## Eski işçi/usta tabanını seçilen dış denge oranıyla çarpar, toplamı yukarı yuvarlar.
static func bedel(y: KoyYonetimi) -> int:
	var taban := 0
	for k in y.koylular:
		if not DivanHukmu.zindanda(k): taban += y.a.vergi_usta if k.usta_mi() else y.a.vergi_isci
	return ceili(taban * float(AYAR[y.vergi_orani].carpan))
## Yalnız gerçek vergi gecesinde ve muafiyet dışında; aynı gece bir kez uygular.
static func tahsil(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	if not Takvim.hafta_basi(y.gun + 1, y.a.mevsim_gun) or y.vergi_muaf or y.son_vergi_gece == y.gun: return
	var vergi := bedel(y)
	y.akce += vergi
	y.son_vergi_gece = y.gun
	y._herkese_moral(int(AYAR[y.vergi_orani].moral))
	EkonomikRefah.degistir(y, int(AYAR[y.vergi_orani].refah))
	olaylar.append({"anahtar": "koy.olay.vergi", "deger": [vergi]})
## Optional eski kayıt; bilinmeyen oran orta, bozuk gün -1 olur.
static func yukle(y: KoyYonetimi, v: Variant) -> void:
	if not v is Dictionary: return
	if v.get("oran") is String and AYAR.has(v.oran): y.vergi_orani = v.oran
	var gun: Variant = v.get("son_gece")
	if (gun is int or gun is float) and is_finite(float(gun)) and floor(float(gun)) == float(gun) and float(gun) >= -1 and float(gun) <= 1000000000: y.son_vergi_gece = int(gun)
## Pazar açıklaması yalnız uygulanan kuralları sunar.
static func metin(y: KoyYonetimi) -> String:
	return "Vergi: %s · haftalık %d akçe · Moral %+d · Refah %+d\nEkonomik Refah: %d/100. Hafta sonunda tahsil edilir; vergi muafiyeti korunur." % [AYAR[y.vergi_orani].ad, bedel(y), int(AYAR[y.vergi_orani].moral), int(AYAR[y.vergi_orani].refah), EkonomikRefah.oku(y)]
