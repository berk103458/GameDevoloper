## Gerçek ana menü ve istenen Ses/Ana bağımlılıkları; kullanıcı kaydına yazmaz.
extends Node
const BETIKLER := {"EfektHavuzuTemizligi": "src/ses/efekt_havuzu_temizligi.gd", "Sanat": "src/arayuz/sanat.gd", "Pbr": "src/dunya/pbr.gd", "Dunya3B": "src/dunya/dunya3b.gd", "KarakterModel": "src/dunya/karakter_model.gd", "DurusDuzeltici": "src/dunya/durus_duzeltici.gd", "KapiManzarasi": "src/dunya/kapi_manzarasi.gd", "Katalog": "src/cekirdek/katalog.gd", "Oturum": "src/sistemler/oturum.gd", "KoyEkrani": "src/arayuz/koy_ekrani.gd", "KapiEkrani": "src/arayuz/kapi_ekrani.gd", "Tema": "src/arayuz/tema.gd", "VarlikYuklemePaneli": "src/arayuz/varlik_yukleme_paneli.gd", "GuvenliKayit": "src/koy/guvenli_kayit.gd", "Ayarlar": "src/sistemler/ayarlar.gd", "AdminHud": "src/debug/admin_hud.gd", "GrafikProfiliAdaptoru": "src/dunya/grafik_profili_adaptoru.gd", "KapiAnlikGoruntusu": "src/debug/kapi_anlik_goruntusu.gd", "BilgiEkrani": "src/arayuz/bilgi_ekrani.gd", "MenuEkrani": "src/arayuz/menu_ekrani.gd"}
var hata := 0
func _ready() -> void:
	get_tree().create_timer(90.0).timeout.connect(func() -> void: get_tree().quit(1))
	for ad in BETIKLER:
		var betik := load("res://" + String(BETIKLER[ad])) as GDScript
		_kontrol(betik != null and betik.can_instantiate(), ad + " parse / sınıf")
		print("BAĞIMLILIK: ", ad, " — ", BETIKLER[ad])
	var paket := load("res://src/arayuz/ana.tscn") as PackedScene
	_kontrol(paket != null and paket.can_instantiate(), "Gerçek ana sahne")
	if paket == null:
		await Ses.cik(1)
		return
	var ana := paket.instantiate()
	add_child(ana)
	for i in 600:
		await get_tree().process_frame
		if is_instance_valid(ana.get("_ekran")):
			break
	var ekran: Control = ana.get("_ekran")
	_kontrol(ekran != null and ekran.get_script().resource_path == "res://src/arayuz/menu_ekrani.gd", "Gerçek Ana._ready menüyü açar")
	_kontrol(ana.get("katalog").durum == Katalog.Durum.HAZIR, "Gerçek Katalog.yukle HAZIR")
	for eylem in ["geri", "menu", "kisayol_1", "kisayol_2", "kisayol_3", "kisayol_4", "kisayol_5"]:
		_kontrol(InputMap.has_action(eylem), "Runtime input: " + eylem)
	_kontrol(Ses._efektler.size() == Ses.ES_ZAMANLI, "Ses._ready efekt havuzu kurulur")
	ana.queue_free()
	await get_tree().process_frame
	print("AÇILIŞ BAĞIMLILIK DENETİMİ: GEÇTİ" if hata == 0 else "AÇILIŞ BAĞIMLILIK DENETİMİ: KALDI")
	await Ses.cik(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
