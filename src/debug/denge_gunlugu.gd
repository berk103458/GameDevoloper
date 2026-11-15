## DEN-05, DEN-06, DEN-22: gece sonu denge ölçümü yalnız geliştirme günlüğüne yazılır.
## Performans günlüğü kurulu değilse (oyuncu sürümü) hiçbir şey yazılmaz; HUD'a sayı çıkmaz.
## Rapor gece_sonu() dönüşünü okur, gece hesabını yeniden çalıştırmaz.
class_name DengeGunlugu
extends RefCounted

static var _basarisiz_zar := 0
static var son_dosya := ""


## ChrSorgusu her başarısız zarda bir kez çağırır; sayı gece sonunda tek satıra yazılır.
static func zar_basarisiz() -> void:
	_basarisiz_zar += 1


static func basarisiz_zar_sayisi() -> int:
	return _basarisiz_zar


static func yaz(ekran: Node, oturum: Oturum, gece_raporu: Dictionary) -> Dictionary:
	var sayi := _basarisiz_zar
	_basarisiz_zar = 0
	var gunluk := ekran.get_parent().get_node_or_null(NodePath(String(PerformansGunlugu.AD))) as PerformansGunlugu if ekran.get_parent() != null else null
	if gunluk == null or not gunluk.etkin:
		return {}
	var rapor := DengeOlcumu.olustur(oturum, gece_raporu, {"basarisiz_zar_sayisi": sayi})
	son_dosya = gunluk.dosya_yolu.replace("performans_", "denge_")
	var f := FileAccess.open(son_dosya, FileAccess.READ_WRITE if FileAccess.file_exists(son_dosya) else FileAccess.WRITE)
	if f == null:
		return rapor
	f.seek_end()
	f.store_line(JSON.stringify(rapor))
	return rapor
