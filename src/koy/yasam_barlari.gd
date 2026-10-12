## YSM-01: köylü başına açlık sayacı, yorgunluk (UZM-14 kaydı) ve moral (UZM-06) salt okunur özeti.
## İkinci moral sayacı, köy ortalaması çubuğu ve ayrı `yasam.json` kökü açmaz; eski köy sahnesini yüklemez.
class_name YasamBarlari
extends RefCounted

## Yüzen kartta ve köylü kartında okunan üç değer; sıra korunur.
const DEGERLER: Array[String] = ["aclik", "yorgunluk", "moral"]

## YSM-01 ek şart: oyuncunun (ACL-01 muhafızı) açlık alanı yoktur; yorgunluğu UZM-14 kaydıdır.
const OYUNCU_BAYRAGI := "acl01_muhafiz"

static func oyuncu_mu(k: Koylu) -> bool:
	return k != null and k.bayrak_var(OYUNCU_BAYRAGI)

## Yaşayan kişi: kayıtta var ve sağlığı 0'ın üstünde.
static func yasiyor(k: Koylu) -> bool:
	return k != null and k.saglik > 0

## Gece çözümü: pay alanın sayacı sıfırlanır, üst üste pay alamayanın sayacı bir artar.
## Sayaç yalnız buradan değişir; olay kartı ve kapı kabulü dokunmaz.
static func gece(y: KoyYonetimi) -> void:
	for k in y.koylular:
		if not yasiyor(k): continue
		if oyuncu_mu(k):
			k.aclik = 0
			continue
		if k.ac: k.aclik += 1
		else: k.aclik = 0

## Üç değeri tek sözlükte okur; ölü/geçersiz kişide boş döner (bar çizilmez).
static func oku(k: Koylu, y: KoyYonetimi) -> Dictionary:
	if not yasiyor(k): return {}
	if oyuncu_mu(k): return {"yorgunluk": NobetYorgunlugu.aktif(k, y), "moral": k.moral}
	return {"aclik": k.aclik, "yorgunluk": NobetYorgunlugu.aktif(k, y), "moral": k.moral}

## Köylü kartı ve ANI-14 yüzen kart için tek satır; ölü kişide boş.
static func metin(k: Koylu, y: KoyYonetimi) -> String:
	if not yasiyor(k): return ""
	var d := oku(k, y)
	if not d.has("aclik"):
		return TranslationServer.translate("koy.yasam.ozet_muhafiz") % [TranslationServer.translate("koy.yasam.var" if bool(d.yorgunluk) else "koy.yasam.yok"), int(d.moral)]
	return TranslationServer.translate("koy.yasam.ozet") % [int(d.aclik), TranslationServer.translate("koy.yasam.var" if bool(d.yorgunluk) else "koy.yasam.yok"), int(d.moral)]