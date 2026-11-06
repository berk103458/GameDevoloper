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
	print("ISG-62: GEÇTİ")
	quit()
