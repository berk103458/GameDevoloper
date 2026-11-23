## Çalıştırma: godot --headless --path . -s tests/unit/arayuz/kare_animasyon_kabuk_test.gd
extends SceneTree

var hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _kontrol(v: bool, ad: String) -> void:
	if not v:
		push_error(ad)
		hata += 1


func _calistir() -> void:
	var yok := KareAnimasyonKabuk.yukle_kareler("res://bu_klasor_yok/", 8)
	_kontrol(yok.is_empty(), "olmayan kök boş dizi döner")
	# Dosya yoksa oynat_uzerinde ebeveyn beklerken hemen döner.
	await KareAnimasyonKabuk.oynat_uzerinde(null, null)
	_kontrol(true, "null ebeveyn/düğüm güvenli")
	var n := RusvetKesesiAnimasyonu.olustur()
	_kontrol(n != null, "kabuk alt sınıfı olusturur")
	if n != null:
		n.son_kareyi_goster()
		_kontrol(n.texture == n._kareler[n._kareler.size() - 1], "son kare atanır")
		n.queue_free()
	quit(1 if hata else 0)
