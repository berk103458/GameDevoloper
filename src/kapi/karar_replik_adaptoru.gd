## BUG-03: rüşvet kabul ve ret kararında diyalog kutusu repliği ile mevcut ses tetikleyicisi.
## Yeni ses dosyası üretmez. Kapıdaki onay, kese ve kapı sesleri olduğu gibi kalır.
extends RefCounted

const ANLATI := "anlati.sonuc."


static func ilgilendirir(anahtar: String) -> bool:
	return anahtar == "rusvet" or anahtar == "ret"


## `%s` varsa adı yerleştirir. Yer tutucu yoksa kalıbı olduğu gibi bırakır;
## Godot'un `%` operatörü eksik yer tutucuda satırı boşaltıp kararı kesebilir.
static func yerlestir(kalip: String, ad: String) -> String:
	if kalip.contains("%s"):
		return kalip.replace("%s", ad)
	return kalip


static func _ad(gelen: Gelen) -> String:
	if gelen.ad_anahtari.is_empty():
		return ""
	var ad := TranslationServer.translate(gelen.ad_anahtari)
	return gelen.ad_anahtari if ad.is_empty() else ad


static func csv_satiri(gelen: Gelen, anahtar: String) -> String:
	var kalip := TranslationServer.translate(ANLATI + anahtar)
	if kalip.is_empty():
		kalip = ANLATI + anahtar
	var ad := _ad(gelen)
	var satir := yerlestir(kalip, ad)
	if satir == kalip and not ad.is_empty() and not kalip.contains(ad):
		satir = "%s — %s" % [kalip, ad]
	return satir


## JSON yanıtı düz metinse aynen, CSV anahtarıysa çevirisiyle döner.
static func soylenen(gelen: Gelen, anahtar: String) -> String:
	if not gelen.yanitlar.has(anahtar):
		return ""
	var ham := str(gelen.yanitlar[anahtar]).strip_edges()
	if ham.is_empty():
		return ""
	var ceviri := TranslationServer.translate(ham)
	return yerlestir(ceviri if not ceviri.is_empty() else ham, _ad(gelen))


static func satirlar(gelen: Gelen, anahtar: String) -> PackedStringArray:
	var sonuc := PackedStringArray()
	var anlat := csv_satiri(gelen, anahtar)
	if not anlat.is_empty():
		sonuc.append(anlat)
	var soz := soylenen(gelen, anahtar)
	if soz.is_empty() or soz == anlat:
		return sonuc
	var ad := _ad(gelen)
	sonuc.append(("[b]%s:[/b] %s" % [ad, soz]) if not ad.is_empty() else soz)
	return sonuc


## Replik metnindeki eyleme göre mevcut foley. Karakterin ortam tanımı kararı ezmez.
static func ses_adi(metin: String, anahtar: String) -> StringName:
	var eslesen: StringName = preload("res://src/sistemler/chr_sorgu_sesi.gd").efekt(KarakterVerisi.new(), metin)
	if eslesen != &"sfx_chr_deri":
		return eslesen
	if anahtar == "rusvet":
		return &"sfx_chr_sikke"
	return &"sfx_chr_deri"


static func dosya_var(ad: StringName) -> bool:
	return ad != &"" and ResourceLoader.exists(HazirSesKaynaklari.yol(String(ad)))


## Satırları döndürür ve mevcut karar sesini kayıtlı Ses autoload üzerinden ister.
static func uygula(gelen: Gelen, anahtar: String) -> Dictionary:
	var liste := satirlar(gelen, anahtar)
	var metin := "\n".join(liste)
	var sfx := ses_adi(metin, anahtar)
	var var_mi := dosya_var(sfx)
	var calindi := preload("res://src/sistemler/guvenli_ses_cagrisi.gd").oynat(sfx, -12.0, true)
	return {"satirlar": liste, "metin": metin, "sfx": sfx, "dosya": var_mi, "calindi": calindi}
