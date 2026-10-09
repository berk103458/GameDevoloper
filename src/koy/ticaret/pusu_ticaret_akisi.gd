## HAR-14: gerçek HAR-05 başarı makbuzundan mevcut HAR-11 seçim ağırlığına adaptör.
extends RefCounted
const META := &"har14_ticaret_akisi"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/pusu_ticaret_akisi.json"))

## Optional, tek sınırlı pencere; bozuk/legacy kayıt geçmiş temizliği ödüle dönüştürmez.
static func oku(v: Variant) -> Dictionary:
	if not v is Dictionary: return {}
	for alan in ["son_basari", "son_gorev", "baslangic", "bitis"]:
		var n: Variant = v.get(alan)
		if not (n is int or n is float) or not is_finite(float(n)) or floor(float(n)) != float(n) or float(n) < 0 or float(n) > 1000000000: return {}
	if int(v.son_basari) < 1 or int(v.son_basari) > 1000000: return {}
	if int(v.baslangic) != int(v.son_gorev) + 1 or int(v.bitis) <= int(v.baslangic) or int(v.bitis) > int(v.baslangic) + 3: return {}
	return {"son_basari":int(v.son_basari), "son_gorev":int(v.son_gorev), "baslangic":int(v.baslangic), "bitis":int(v.bitis)}

static func durum(o: Oturum) -> Dictionary:
	var d := oku(o.get_meta(META, {}))
	var g := GocYoluGuvenligi.oku(o.goc_yolu_guvenligi)
	if not d.is_empty() and (int(d.son_basari) > int(g.basari) or int(d.son_gorev) > int(g.son_gun)): return {}
	return d

## Yalnız temizle() başarıyı kaydettikten sonra çağırır; aynı görev ikinci kez yenileyemez.
static func basari(o: Oturum) -> void:
	var g := GocYoluGuvenligi.oku(o.goc_yolu_guvenligi)
	var d := durum(o)
	if o.yonetim.son != "" or g.sonuc != "basari" or int(g.son_gun) != o.gun or int(g.basari) <= 0: return
	if int(g.basari) <= int(d.get("son_basari", 0)) or o.gun <= int(d.get("son_gorev", -1)): return
	var baslangic := o.gun + 1
	o.set_meta(META, {"son_basari":int(g.basari), "son_gorev":o.gun, "baslangic":baslangic, "bitis":baslangic + clampi(int(AYAR.sure_gun), 1, 3)})

## Gün sınırı saf okunur; ne ek ziyaret ne RNG ne Güvenlik statı üretir.
static func aktif(o: Oturum) -> bool:
	var d := durum(o)
	return o.yonetim.son == "" and not d.is_empty() and o.gun >= int(d.baslangic) and o.gun < int(d.bitis)

static func agirlik(o: Oturum, sinif: StringName, taban: float) -> float:
	if sinif != StringName(GuvenlikKafileDengesi.AYAR.ticaret_sinifi) or not aktif(o): return taban
	return maxf(taban, minf(float(AYAR.azami_agirlik), taban + float(AYAR.ek_agirlik)))

## Mevcut pazar/harita bilgi alanı; uzman takvimine dair yanlış varış vaadi yok.
static func tip(o: Oturum) -> String:
	var d := durum(o)
	if d.is_empty() or o.yonetim.son != "" or o.gun >= int(d.bitis): return ""
	var kalan := int(d.bitis) - maxi(o.gun, int(d.baslangic))
	return "Yol temizliği: ticaret yolcularının (esnaf) uğrama ihtimali arttı; %s%d gün. Uzman tüccar takvimi aynı; varış garantisi yok." % ["yarından itibaren " if o.gun < int(d.baslangic) else "kalan ", kalan]
