## MCL-01: çınarın altında konuşan, içeri alınmış kişidir. Krizli gecede köy
## kaydındaki yaşayan adaylardan en çok üçü konuşur; kapı kuyruğundaki, ret
## yemiş veya ölü kimlik satıra yazılmaz. Oy hesabı KRI-07'de kalır; bu madde
## yalnız konuşma listesini verir, ayrı meclis sahnesi/sesi açmaz.
class_name MeclisSesi
extends RefCounted

const EN_COK := 3

## Kriz KRI-07'nin kendi kapısından okunur; ikinci kriz motoru açılmaz.
static func kriz_var_mi(y: KoyYonetimi) -> bool:
	return not CinarAltiMeclisi._krizler(y).is_empty()

## Konuşan adları: krizsiz gecede boştur. Krizli gecede köy kaydındaki yaşayan
## adaylar kimlik sırasıyla en çok üçe kadar listelenir. Ölü/kapı kuyruğundaki
## (köy kaydında olmayan) ve ret yemiş kimlikler süzülür.
static func konusanlar(y: KoyYonetimi, adaylar: Array = []) -> Array[String]:
	var adlar: Array[String] = []
	if not kriz_var_mi(y): return adlar
	var kimlikler: Array[int] = []
	if adaylar.is_empty():
		for k in y.koylular: kimlikler.append(k.id)
	else:
		for id in adaylar: kimlikler.append(int(id))
	kimlikler.sort()
	for id in kimlikler:
		if adlar.size() >= EN_COK: break
		var k := y.koylu(id)
		if k == null or k.saglik <= 0: continue
		# Kapıdan içeri alınmamış kurucu hane (ACL-01 muhafızı = oyuncu, eşi) çınar altında konuşmaz.
		if k.bayrak_var("acl01_muhafiz") or k.bayrak_var("acl01_es"): continue
		adlar.append(k.ad)
	return adlar

## Adlı kimse yoksa oylama adsız tek satırla açılır.
static func adsiz_mi(y: KoyYonetimi, adaylar: Array = []) -> bool:
	return kriz_var_mi(y) and konusanlar(y, adaylar).is_empty()