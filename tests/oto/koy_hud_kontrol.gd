## HUD net değişimi, maliyet kapısı, kategori kaydırması ve duraklatmadan dönüş için entegrasyon testi.
extends Node

var _hata := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_dene")

func _dene() -> void:
	TranslationServer.set_locale("tr")
	var k := Katalog.new()
	k.yukle()
	var o := Oturum.new(k, 21)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(o)
	var a := Ayarlar.new()
	var ana := Control.new()
	ana.theme = Tema.olustur(a)
	get_tree().root.add_child(ana)
	var e := KoyEkrani.new()
	e.oturum = o
	e.ayarlar = a
	ana.add_child(e)
	await get_tree().process_frame
	if e.hud == null:
		push_error("Köy HUD kurulamadı")
		get_tree().quit(1)
		return
	var ilk_paneller := _paneller(e.hud)
	_dogrula(ilk_paneller.size() <= 6 and ilk_paneller.has("hud.gd:takvim"), "OGR-25 ilk gece en çok altı gerçek panel")
	for tur in ["akce", "gida", "odun", "tas", "su"]:
		_dogrula(ilk_paneller.has("kaynak_gostergesi.gd:" + tur), "OGR-25 ilk gece temel kaynak: " + tur)
	_dogrula(not e.hud._stok_etiketleri["kereste"].is_inside_tree() and not e.hud._kese.is_inside_tree(), "OGR-25 bekleyen paneller sahne ağacında yok")
	var nufus_grubu := e.hud._nufus.get_parent()
	_dogrula(not nufus_grubu.has_node("KarantinaSayisi"), "OGR-26 ilk gece karantina verisi yokken panel yok")
	var koylu := o.yonetim.kabul({"ad": "Karantina kontrolü"})
	koylu.karantina = {"baslangic": 0, "bitis": 2, "bina": 1}
	e.hud.guncelle()
	var karantina := nufus_grubu.get_node_or_null("KarantinaSayisi") as Label
	_dogrula(karantina != null and karantina.is_visible_in_tree() and karantina.text == "Karantinada: 1 kişi", "OGR-26 ilk gece karantina kaydı paneli erken açar")
	e.hud.guncelle()
	_dogrula(nufus_grubu.get_node_or_null("KarantinaSayisi") == karantina, "OGR-26 yenileme paneli çoğaltmaz")
	koylu.karantina.clear()
	e.hud.guncelle()
	_dogrula(not nufus_grubu.has_node("KarantinaSayisi"), "OGR-26 erken karantina verisi bittiğinde panel ağaçtan ayrılır")
	var ambar := KitlikIsyani.durum(o.yonetim)
	ambar.kapi_kirik = true
	KitlikIsyani.yukle(o.yonetim, ambar)
	e.hud.guncelle()
	var ambar_grubu := e.hud._ambar_bar.get_parent()
	_dogrula(ambar_grubu.has_node("ambar_kapisi_onar"), "İlk gece kırık kapının onarımı açılır")
	ambar.kapi_kirik = false
	KitlikIsyani.yukle(o.yonetim, ambar)
	e.hud.guncelle()
	_dogrula(not ambar_grubu.has_node("ambar_kapisi_onar"), "Onarılan kapının kontrolü ilk gece ağaçtan ayrılır")
	_dogrula(e.find_children("oda_ac", "Button", true, false).is_empty() and MuhafizOdasiBaglantisi.ac(e) == null, "OGR-27 tetiksiz köyde oda düğmesi ve girişi kapalı")
	var tetiksiz_kayit := Oturum.kayittan(k, o.kaydet())
	var kayit_katmani = preload("res://src/arayuz/koy_hud/hud_katmani.gd").new()
	kayit_katmani.kur(tetiksiz_kayit, a)
	_dogrula(tetiksiz_kayit != null and not kayit_katmani.acik("muhafiz_odasi_baglantisi.gd"), "OGR-27 tetiksiz kayıt yüklenince oda kilitli")
	o.bayraklar[&"rusvet_sayisi"] = 1
	e.hud.guncelle()
	_dogrula(e.find_children("oda_ac", "Button", true, false).size() == 1, "OGR-27 ilk rüşvet kararı odayı açar")
	o.bayraklar.erase(&"rusvet_sayisi")
	e.hud.guncelle()
	_dogrula(e.find_children("oda_ac", "Button", true, false).is_empty(), "OGR-27 teftiş yolunu tetiksiz durumdan sınar")
	o.sancak_teftisi = {"son_gece": 1, "sonuc": "temiz"}
	e.hud.guncelle()
	_dogrula(e.find_children("oda_ac", "Button", true, false).size() == 1, "OGR-27 temiz sancak teftişi de odayı açar")
	var once := o.yonetim.akce
	o.yonetim.akce += 3
	o.yonetim.gun += 1
	e.hud.guncelle()
	_dogrula(e.hud._stok_etiketleri["kereste"].is_inside_tree() and not e.hud._kese.is_inside_tree(), "OGR-25 birinci gecede yalnız ilgili katman açılır")
	_dogrula(e.hud._akce._miktar.text == str(once + 3), "Akçe güncellendi")
	_dogrula(e.hud._akce._net.text == "+3", "Akçe net değişimi")
	e.hud.guncelle()
	_dogrula(e.hud._akce._net.text == "+3", "Aynı gün yenileme neti korur")
	o.yonetim.gun = 3
	e.hud.guncelle()
	_dogrula(_paneller(e.hud).size() == Hud.STOKLAR.size() + 5 and e.hud._kese.is_inside_tree(), "OGR-25 üçüncü gecede tüm üst şerit panelleri bağlı")
	_dogrula(e.find_children("harita_ac", "Button", true, false).is_empty() and HaritaBaglantisi.ac(e) == null, "OGR-28 üçüncü gece tetik yoksa harita kapalı")
	o.gorulen_olaylar[&"kervan"] = true
	e.hud.guncelle()
	_dogrula(e.find_children("harita_ac", "Button", true, false).size() == 1, "OGR-28 kervan olayı haritayı açar")
	o.gorulen_olaylar.erase(&"kervan")
	var gelenler: Array[Gelen] = []
	TuccarKapiGecisi.ekle(o, gelenler)
	e.hud.guncelle()
	_dogrula(not gelenler.is_empty() and e.find_children("harita_ac", "Button", true, false).size() == 1, "OGR-28 gerçek takvim ziyaretinin kapı makbuzu haritayı açar")
	o.yonetim.tuccar_girisi.clear()
	e.hud.guncelle()
	_dogrula(e.find_children("harita_ac", "Button", true, false).is_empty(), "OGR-28 haber yolu tetiksiz durumdan sınanır")
	HaberciAgi.gece(o, {"gun": 2, "olaylar": [{"anahtar": "koy.olay.baskin", "deger": [1, 2]}]})
	var haber := HaberciAgi.olay(o)
	_dogrula(haber != null and HaberciAgi.uygula(o, haber, 0).ok, "OGR-28 haber mevcut işlemden okunur")
	e.hud.guncelle()
	_dogrula(e.find_children("harita_ac", "Button", true, false).size() == 1, "OGR-28 haber okunduktan sonra harita açılır")
	var haber_kaydi := Oturum.kayittan(k, o.kaydet())
	kayit_katmani.kur(haber_kaydi, a)
	_dogrula(haber_kaydi != null and kayit_katmani.acik("harita_baglantisi.gd"), "OGR-28 okunmuş haber yüklemede haritayı açık tutar")
	e._hiz_sec(3)
	_dogrula(Engine.time_scale == 3.0 and not get_tree().paused, "3x çalışıyor")
	var bosluk := InputEventKey.new()
	bosluk.physical_keycode = KEY_SPACE
	bosluk.pressed = true
	e._unhandled_input(bosluk)
	_dogrula(get_tree().paused and e.can_process(), "Duraklamada UI çalışıyor")
	_dogrula(not e.sahne3b.can_process(), "Duraklamada dünya duruyor")
	e._unhandled_input(bosluk)
	_dogrula(not get_tree().paused and Engine.time_scale == 3.0, "Son hızda sürüyor")
	e._hiz_sec(1)
	e._kategori = "uretim"
	e._yapi_satirini_ciz()
	_dogrula(e._yapi_satiri.get_child_count() == o.yonetim.katalog.kategoridekiler("uretim").size(), "Üretim kartlarının tamamı var")
	_dogrula(e._yapi_satiri.get_parent() is ScrollContainer, "Kartlar kaydırılabilir")
	var kart := YapiKarti.new()
	ana.add_child(kart)
	o.yonetim.kaynaklar.stok.clear()
	kart.kur("kulube", o.yonetim, a)
	_dogrula(kart.disabled, "Yetersiz malzeme inşayı engeller")
	e._hiz_sec(0)
	e.queue_free()
	await get_tree().process_frame
	_dogrula(not get_tree().paused and Engine.time_scale == 1.0, "Ekrandan çıkış zamanı sıfırlar")
	ana.queue_free()
	await get_tree().process_frame
	print("KOY HUD TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	get_tree().quit(0 if _hata == 0 else 1)

func _dogrula(olur: bool, ad: String) -> void:
	if not olur:
		_hata += 1
		push_error(ad)

func _paneller(hud: Hud) -> Array[String]:
	var sonuc: Array[String] = []
	for n in hud.find_children("*", "Control", true, false):
		if n.has_meta(&"hud_katmani"): sonuc.append(String(n.get_meta(&"hud_katmani")))
	return sonuc
