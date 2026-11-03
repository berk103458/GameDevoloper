## Güvenli kayıt (design/gdd/koy-yonetimi.md, 13): düz JSON; önce `.tmp`'ye yazılır ve geri okunarak doğrulanır,
## sonra mevcut kayıt `.bak` olur ve geçici dosya ana kaydın yerine geçer. Ana kayıt bozuksa yedek okunur.
## Kaynak (.tres) kaydı kullanılmaz: yüklenen kaynak betik çalıştırabilir.
class_name GuvenliKayit
extends RefCounted

var yol: String
## KAY-30: sorgu açıkken otomatik yazma dosyaya dokunmaz. Gece sonu ve menü sorguyu kapatır.
static var sorgu_kaydi_kapali := false


func _init(yol_: String = "user://savegame.json") -> void:
	yol = yol_


func var_mi() -> bool:
	return FileAccess.file_exists(yol) or FileAccess.file_exists(yol + ".bak")


## Yazar; başarısızsa ana kayda dokunmaz ve false döner. Sürüm ilk alan olarak başa yazılır (KAY-01).
func yaz(veri: Dictionary) -> bool:
	if sorgu_kaydi_kapali:
		return false
	# KAY-02: yeni sürüm ana/yedek dosyayı eski motorla otomatik yazma.
	if gelecek_surum(veri) or gelecek_surum(_oku_dosya(yol)) or gelecek_surum(_oku_dosya(yol + ".bak")):
		return false
	return preload("res://src/sistemler/atomik_json_kaydi.gd").yaz(yol, _surum_basa(veri))


## Kayıt sözlüğü: ana kayıt bozuk ya da eksikse yedek; ikisi de yoksa boş. `yedekten` okunduysa işaretlenir.
## KAY-01: ana kayıtta sürüm alanı yoksa ya da geçersizse yükleme durur, köy uydurulmaz; yedek yerinde durur.
func oku() -> Dictionary:
	var v := _oku_dosya(yol)
	if not v.is_empty():
		if gelecek_surum(v):
			push_warning("Kayıt daha yeni bir oyun sürümünde oluşturulmuş; dosya korundu")
			return {}
		if not surum_gecerli(v):
			push_warning("Kayıt sürümü yok; yükleme durduruldu")
			return {}
		return v
	v = _oku_dosya(yol + ".bak")
	if gelecek_surum(v):
		push_warning("Yedek kayıt daha yeni bir oyun sürümünde oluşturulmuş; dosya korundu")
		return {}
	if not v.is_empty():
		push_warning("Ana kayıt bozuk; yedek yüklendi")
		v["_yedekten"] = true
	return v


func sil() -> void:
	for y in [yol, yol + ".bak", yol + ".tmp", yol + ".bak.tmp"]:
		if FileAccess.file_exists(y):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(y))


static func _oku_dosya(y: String) -> Dictionary:
	return preload("res://src/sistemler/atomik_json_kaydi.gd").oku(y)


## Kayıt dosyasının başında sürüm dursun diye sözlüğü sürüm-önce sıraya koyar (KAY-01).
static func _surum_basa(veri: Dictionary) -> Dictionary:
	if not veri.has("surum"):
		return veri
	var sirali := {"surum": veri["surum"]}
	for anahtar in veri:
		if anahtar != "surum":
			sirali[anahtar] = veri[anahtar]
	return sirali


## Sürüm tek bir tam sayıdır (KAY-01); eksik, kesirli, metin, mantık ya da sonsuz sürüm geçersizdir.
static func surum_gecerli(veri: Dictionary) -> bool:
	if not veri.has("surum"):
		return false
	var s: Variant = veri["surum"]
	return (s is int or s is float) and is_finite(float(s)) and float(s) == floor(float(s))

## SYS-14 ile aynı güncel sürüm; ikinci bir sürüm sabiti yok.
static func gelecek_surum(veri: Dictionary) -> bool:
	return surum_gecerli(veri) and float(veri.surum) > float(preload("res://src/sistemler/kayit_gocu.gd").GUNCEL_SURUM)
