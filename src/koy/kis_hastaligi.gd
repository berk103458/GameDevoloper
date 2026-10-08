## MEV-13: sert kış tetikleyicisi, mevcut sağlık/üretim/şifahane; ayrı hasta ekonomisi yok.
class_name KisHastaligi
extends RefCounted
static var AYAR: Dictionary = preload("res://data/kis_hastaligi.json").data
const FLAG := "kis_hastasi"
const META := &"kis_hastaligi_son_gece"
static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary: return {}
	for alan in ["bitis", "son_gece"]:
		var n: Variant = v.get(alan)
		if (not n is int and not n is float) or not is_finite(float(n)) or float(n) != floor(float(n)) or float(n) < 0 or float(n) > 1000000000: return {}
	if v.bitis <= v.son_gece or v.bitis - v.son_gece > int(AYAR.sure_gun): return {}
	return {"bitis": int(v.bitis), "son_gece": int(v.son_gece)}
static func gece_oku(v: Variant) -> int:
	if (not v is int and not v is float) or not is_finite(float(v)) or float(v) != floor(float(v)) or float(v) < -1 or float(v) > 1000000000: return -1
	return int(v)
static func hasta(k: Koylu) -> bool:
	return not k.kis_hastaligi.is_empty()
static func sert(y: KoyYonetimi) -> bool:
	return IklimDeneyi.hava(y) == "kar_firtinasi" or (y.mevsim() == 3 and MevsimYoneticisi.mevsim_gunu(y.gun, y.a.mevsim_gun) >= int(AYAR.sert_kis_gunu))
## Sağlık öncesi/üretim öncesi tek gerçek gece. En çok bir yeni hasta; süresi biten kendi bayrağını temizler.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	if y.son != "" or y.nufus() == 0 or gece_oku(y.get_meta(META, -1)) == y.gun: return
	y.set_meta(META, y.gun)
	for k in y.koylular:
		if hasta(k) and y.gun >= int(k.kis_hastaligi.bitis): _temizle(k)
		if hasta(k):
			k.saglik = maxi(0, k.saglik - int(AYAR.saglik_kaybi))
			k.kis_hastaligi.son_gece = y.gun
	if not sert(y): return
	var adaylar: Array[Koylu] = []
	for k in y.koylular:
		if not hasta(k) and k.saglik > 0: adaylar.append(k)
	if adaylar.is_empty() or y._rng.randi_range(1, 100) > int(AYAR.risk_yuzde): return
	adaylar.sort_custom(func(a: Koylu, b: Koylu) -> bool: return a.id < b.id)
	var k := adaylar[y._rng.randi_range(0, adaylar.size() - 1)]
	k.kis_hastaligi = {"bitis": y.gun + int(AYAR.sure_gun), "son_gece": y.gun}
	k.bayrak_ekle(FLAG)
	k.saglik = maxi(0, k.saglik - int(AYAR.saglik_kaybi))
	olaylar.append({"anahtar": "Sert kışta %s hastalandı; üretim düşüyor, Şifahane tedavisi bekliyor.", "deger": [k.ad]})
## Yanıklar sonrası kalan aynı kontenjan ve ortak gıda. Hastalık yalnız kendi bayrağını temizler.
static func tedavi(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	for k in y.koylular:
		if not hasta(k) or k.saglik <= 0: continue
		if Sifahane.tedavi_kapasitesi(y) <= 0 or not y.kaynaklar.harca({"gida": int(AYAR.tedavi_gida)}): break
		SifahaneKontenjani.kullan(y)
		k.saglik = mini(100, k.saglik + int(AYAR.iyilesme))
		_temizle(k)
		olaylar.append({"anahtar": "Şifahane %s kış hastalığını tedavi etti; %d erzak kullanıldı.", "deger": [k.ad, int(AYAR.tedavi_gida)]})
static func _temizle(k: Koylu) -> void:
	k.kis_hastaligi.clear()
	k.bayraklar.erase(FLAG)
static func metin(k: Koylu, y: KoyYonetimi) -> String:
	return "Kış hastalığı: %d gün · Şifahane boş kontenjanı %d" % [maxi(0, int(k.kis_hastaligi.bitis) - y.gun), Sifahane.tedavi_kapasitesi(y)] if hasta(k) else "Kış hastalığı yok"
