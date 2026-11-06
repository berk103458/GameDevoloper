extends SceneTree

func _initialize() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var oturum := Oturum.new(katalog, 62)
	var kisi := oturum.yonetim.kabul({"ad": "Ali"})
	kisi.yapi_bilgisi = PackedStringArray(["tas_ev"])
	var veri: Dictionary = JSON.parse_string(JSON.stringify(oturum.kaydet()))
	for kayit in veri.koy_yonetimi.koylular:
		if int(kayit.id) == kisi.id:
			kayit.erase("yapi_bilgisi")
			kayit.erase("gecici_is")
			kayit.erase("is_yeri")
	var geri := Oturum.kayittan(katalog, veri)
	var koylu := geri.yonetim.koylu(kisi.id) if geri != null else null
	if koylu == null or koylu.is_yeri != KoyYonetimi.BOSTA or not koylu.gecici_is.is_empty():
		push_error("ISG-62: iş alanı olmayan kayıt boşta yüklenmeli")
		quit(1)
		return
	if not koylu.yapi_bilgisi.is_empty() or YapiKilidi.durum(geri.yonetim, "tas_ev").acik:
		push_error("YAP-20: eski kayıt bilgi uydurmamalı, K2 kilitli kalmalı")
		quit(1)
		return
	if koylu.kaydet().has("yapi_bilgisi"):
		push_error("YAP-20: boş bilgi optional kalmalı")
		quit(1)
		return
	var dolu: Dictionary = JSON.parse_string(JSON.stringify(oturum.kaydet()))
	var bilgili := Oturum.kayittan(katalog, dolu)
	if bilgili == null or bilgili.yonetim.koylu(kisi.id).yapi_bilgisi != PackedStringArray(["tas_ev"]):
		push_error("YAP-20: mevcut bilgi gerçek JSON yüklemede korunmalı")
		quit(1)
		return
	print("YAP-20: GEÇTİ")
	# YAP-38: defter ayrı bir zorunlu kayıt kökü değildir.
	var deftersiz: Dictionary = JSON.parse_string(JSON.stringify(oturum.kaydet()))
	deftersiz.surum = 2
	deftersiz.erase("muhafiz_esyalari")
	deftersiz.koy_yonetimi.erase("cozumleme")
	var degismedi := deftersiz.duplicate(true)
	var eski_defter := Oturum.kayittan(katalog,deftersiz)
	if eski_defter == null or not eski_defter.muhafiz_esyalari.is_empty() or deftersiz != degismedi:
		push_error("YAP-38: defter/eşya alanı olmayan eski JSON boş envanterle açılmalı, kaynak kayıt korunmalı")
		quit(1)
		return
	var diger: Dictionary = JSON.parse_string(JSON.stringify(oturum.kaydet()))
	diger.muhafiz_esyalari = [{"id":"alet","adet":2,"deger":1}]
	var diger_geri := Oturum.kayittan(katalog,diger)
	if diger_geri == null or diger_geri.muhafiz_esyalari != diger.muhafiz_esyalari:
		push_error("YAP-38: güncel deftersiz kayıt diğer eşyayı korumalı")
		quit(1)
		return
	print("YAP-38: GEÇTİ")
	print("ISG-62: GEÇTİ")
	quit()
