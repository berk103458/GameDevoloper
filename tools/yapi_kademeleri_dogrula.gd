## YAP-01: mevcut katalogdan kimlik doğrulaması; tablosuz tür yalnız uyarıdır.
extends SceneTree
func _initialize() -> void:
	var kat := BinaKatalogu.new()
	var hatalar := YapiKilidi.dogrula(kat)
	for hata in hatalar: printerr("YAPI KADEME HATASI: " + hata)
	for tur in YapiKilidi.eksik_turler(kat): print("YAPI KADEME UYARI: %s tabloda yok, K0 kabul edilir" % tur)
	print("YAPI KADEMELERİ: GEÇTİ" if hatalar.is_empty() else "YAPI KADEMELERİ: KALDI")
	quit(0 if hatalar.is_empty() else 1)
