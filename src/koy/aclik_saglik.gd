## KRI-12: açlık–sağlık çaprazı; ikinci açlık/salgın motoru değildir.
## Gece başında ambarda erzak eşiğin altındaysa o gece herkes ek sağlık kaybeder
## ve mevcut SaglikYoneticisi temas bulaşma riski katlanır. Yeni RNG çağrısı eklenmez;
## iki yeni vaka sınırına daha erken varılınca mevcut döngü daha az zar çekebilir.
extends RefCounted

const META := &"aclik_saglik_gecesi"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/aclik_saglik.json"))

## Gece başı fotoğrafı: aynı gecede üretim/tüketim sırası sonucu değiştirmez.
static func baslat(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	var aktif := y.son == &"" and not y.koylular.is_empty() and y.kaynaklar.miktar("gida") < int(AYAR.erzak_esigi)
	y.set_meta(META, y.gun if aktif else -1)
	if aktif:
		olaylar.append({"anahtar": "aclik_saglik", "aclik_saglik": {"erzak": y.kaynaklar.miktar("gida"), "esik": int(AYAR.erzak_esigi), "kayip": int(AYAR.saglik_kaybi), "carpan": int(AYAR.yayilma_carpani)}})

## Bu gece çapraz etki açık mı (yalnız gece içinde anlamlı; kayda yazılmaz).
static func aktif(y: KoyYonetimi) -> bool:
	return int(y.get_meta(META, -1)) == y.gun

## Mevcut temas bulaşma riskine çarpan; tavan 100.
static func risk(y: KoyYonetimi, taban: int) -> int:
	return mini(100, taban * int(AYAR.yayilma_carpani)) if aktif(y) else taban

## Mevcut tek sağlık döngüsünde, ölüm kontrolünden önce ek kayıp; dış görev hariç.
static func saglik_kaybi(y: KoyYonetimi, k: Koylu) -> void:
	if aktif(y) and not KervanKorumasi.disarida(y, k.id): k.saglik -= int(AYAR.saglik_kaybi)

## Gece raporu satırı (mevcut olay metni adaptörü üzerinden).
static func olay_metin(e: Dictionary) -> String:
	var d: Dictionary = e.aclik_saglik
	return "Açlık ve hastalık · ambarda %d erzak kaldı (eşik %d). Bu gece her köylü ek %d sağlık kaybeder; salgın bulaşma riski ×%d." % [d.erzak, d.esik, d.kayip, d.carpan]
