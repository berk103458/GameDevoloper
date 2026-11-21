## AYR-30: Hızlı kayıt yalnız köyde. Sorgu sırasında etki 0. Yazım atomiktir (SYS-02).
extends RefCounted

const EYLEM := "hizli_kayit"


static func eylem_kur() -> void:
	if InputMap.has_action(EYLEM):
		return
	InputMap.add_action(EYLEM)
	var tus := InputEventKey.new()
	tus.physical_keycode = KEY_F5
	InputMap.action_add_event(EYLEM, tus)


static func dene(faz: StringName, yuvalar: KayitYuvalari, veri: Dictionary) -> bool:
	if faz != &"koy" or yuvalar == null:
		return false
	return yuvalar.yaz(1, veri)


static func girdi(ekran: Node, olay: InputEvent) -> bool:
	eylem_kur()
	if olay == null or not olay.is_action_pressed(EYLEM):
		return false
	if ekran == null or ekran.get_script() == null:
		return true
	if ekran.get_script().resource_path != "res://src/arayuz/koy_ekrani.gd":
		return true
	# Rapor veya olay çözülmeden yazılan kayıt yeniden açılışta o adımı kaybeder.
	if ekran.get("oturum") == null or ekran.call("_ust_panel_var"):
		return true
	var ana := ekran.get_parent()
	if ana != null and ana.has_method("_kayit_yaz") and ana.get("_ekran") == ekran and ana.get("_ust") == null:
		ana.call("_kayit_yaz")
	return true
