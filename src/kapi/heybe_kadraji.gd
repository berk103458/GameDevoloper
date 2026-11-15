## SAH-50: Heybe paneli dünya alanının solunu örter; açıkken kamera gelen kişiyi panelin
## sağındaki boş alana kaydırır, yaklaşmaz. Kapanınca kapı kaydırması geri gelir.
class_name HeybeKadraji
extends RefCounted


static func ac(ekran: Control, panel: Control) -> void:
	var sahne: Node = ekran.get("sahne")
	if sahne == null or not is_instance_valid(sahne._gelen) or panel == null:
		return
	var kamera: Camera3D = sahne.kamera
	var vp: SubViewport = ekran.get("_vp")
	var bos_orta := (panel.get_global_rect().end.x + ekran.size.x) * 0.5
	var hedef_x := bos_orta * float(vp.size.x) / ekran.size.x
	var odak := KapiKameraVurgu.kadraj_hesapla(sahne._gelen.global_position)
	var kayma := KapiKameraVurgu.kaydirma_bul(kamera, odak, hedef_x)
	sahne._kamera_gecisi.kaydir(kayma)


static func kapat(ekran: Control, kapi_kaymasi: float) -> void:
	var sahne: Node = ekran.get("sahne")
	if sahne != null:
		sahne._kamera_gecisi.kaydir(kapi_kaymasi)
