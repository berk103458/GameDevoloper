extends Node
## GRV-65..100 (Claude-Berk): köy HUD panelleri temaya bağlıdır.
## Her dosyada ham renk, yerel ColorRect, yerel StyleBox ve sayı punto yoktur;
## yer tutucu kutular Kabuk.yer_tutucu'dan, düğmeler Tema'nın dört durumundan gelir;
## her dosya oyunda başka bir betikten çağrılır.

const DOSYALAR := {
	"GRV-65": "res://src/arayuz/koy_hud/muhafiz_odasi_baglantisi.gd",
	"GRV-66": "res://src/arayuz/koy_hud/pazar_satis_paneli.gd",
	"GRV-67": "res://src/arayuz/koy_hud/saman_bilgisi.gd",
	"GRV-68": "res://src/arayuz/koy_hud/siparis_sozlesme_paneli.gd",
	"GRV-69": "res://src/arayuz/koy_hud/su_rezerv_paneli.gd",
	"GRV-71": "res://src/arayuz/koy_hud/alet_asinma_bilgisi.gd",
	"GRV-72": "res://src/arayuz/koy_hud/ceki_hayvani_paneli.gd",
	"GRV-73": "res://src/arayuz/koy_hud/celep_pazar_adaptoru.gd",
	"GRV-74": "res://src/arayuz/koy_hud/cenaze_raporu.gd",
	"GRV-75": "res://src/arayuz/koy_hud/cete_anlasma_paneli.gd",
	"GRV-76": "res://src/arayuz/koy_hud/gezgin_stok_paneli.gd",
	"GRV-77": "res://src/arayuz/koy_hud/gezgin_tuccar_pazar_adaptoru.gd",
	"GRV-78": "res://src/arayuz/koy_hud/goc_yolu_paneli.gd",
	"GRV-79": "res://src/arayuz/koy_hud/hayvan_takas_paneli.gd",
	"GRV-80": "res://src/arayuz/koy_hud/karantina_paneli.gd",
	"GRV-81": "res://src/arayuz/koy_hud/kasa_transfer_paneli.gd",
	"GRV-82": "res://src/arayuz/koy_hud/kervan_koruma_paneli.gd",
	"GRV-83": "res://src/arayuz/koy_hud/konuslanma_paneli.gd",
	"GRV-84": "res://src/arayuz/koy_hud/kumas_aktar_paneli.gd",
	"GRV-85": "res://src/arayuz/koy_hud/mevsim_takvim.gd",
	"GRV-86": "res://src/arayuz/koy_hud/oba_ittifak_paneli.gd",
	"GRV-87": "res://src/arayuz/koy_hud/pazar_kart_kaydirma.gd",
	"GRV-88": "res://src/arayuz/koy_hud/silah_karaborsa_paneli.gd",
	"GRV-89": "res://src/arayuz/koy_hud/siparis_ihlal_paneli.gd",
	"GRV-90": "res://src/arayuz/koy_hud/siparis_komisyon_paneli.gd",
	"GRV-91": "res://src/arayuz/koy_hud/siparis_teslim_paneli.gd",
	"GRV-92": "res://src/arayuz/koy_hud/ticaret_fiyat_paneli.gd",
	"GRV-93": "res://src/arayuz/koy_hud/vergi_paneli.gd",
	"GRV-95": "res://src/arayuz/koy_hud/haberci_anlati_paneli.gd",
	"GRV-97": "res://src/arayuz/koy_hud/tekfur_heyeti_paneli.gd",
	"GRV-98": "res://src/arayuz/koylu_surukleme_kulpu.gd",
	"GRV-99": "res://src/kapi/divan_baglantisi.gd",
	"GRV-100": "res://src/arayuz/chr_kapi_adaptoru.gd",
}

var _hata := 0


func _ready() -> void:
	get_tree().create_timer(60).timeout.connect(func() -> void: get_tree().quit(1))
	var ihlal_re := RegEx.create_from_string("\\bColor\\s*\\(|\\bColor8\\s*\\(|Color\\.from_|Color\\.html|ColorRect\\.new|StyleBoxFlat\\.new|add_theme_stylebox_override|\"font_size\"\\s*,\\s*\\d")
	var kaynaklar := _src_metinleri("res://src")
	for madde in DOSYALAR:
		var yol: String = DOSYALAR[madde]
		var betik := load(yol) as Script
		_kontrol(betik != null and betik.can_instantiate(), "%s %s yüklenmedi" % [madde, yol])
		var satirlar := FileAccess.get_file_as_string(yol).split("\n")
		var ihlal := 0
		for i in satirlar.size():
			var s := satirlar[i].strip_edges()
			if s.begins_with("#"):
				continue
			if ihlal_re.search(s) != null:
				ihlal += 1
				printerr("%s %s:%d tema dışı: %s" % [madde, yol, i + 1, s])
		_kontrol(ihlal == 0, "%s %d ihlal" % [madde, ihlal])
		var ad := betik.get_global_name() if betik != null else &""
		_kontrol(_cagriliyor(kaynaklar, yol, String(ad)), "%s oyunda çağrılmıyor" % madde)
	# Yer tutucu kutu yalnız Kabuk'tan; renk veriden gelir.
	var tek := Kabuk.yer_tutucu("Deneme", String(TekfurHaracHeyeti.AYAR.yer_tutucu_renk), Vector2(30, 30))
	_kontrol(tek.color == Color.html(String(TekfurHaracHeyeti.AYAR.yer_tutucu_renk)) and tek.has_meta("kabuk_yer_tutucu") and tek.custom_minimum_size == Vector2(30, 30) and tek.mouse_filter == Control.MOUSE_FILTER_IGNORE, "Kabuk.yer_tutucu yanlış")
	tek.free()
	var bozuk := Kabuk.yer_tutucu("Bozuk", "zz", Vector2.ONE)
	_kontrol(bozuk.color == Kabuk.SOLUK, "bozuk renk nötr yedeğe düşmedi")
	bozuk.free()
	# Düğmeler genel temanın dört durumunu okur.
	var tema := Tema.olustur(Ayarlar.new("user://grv_tema_unused.cfg"))
	for durum in ["normal", "hover", "pressed", "disabled"]:
		_kontrol(tema.has_stylebox(durum, "Button"), "Button %s durumu yok" % durum)
	if _hata == 0:
		print("GRV TEMA BAGLARI: GEÇTİ (%d dosya)" % DOSYALAR.size())
		get_tree().quit(0)
	else:
		printerr("GRV TEMA BAGLARI: KALDI (%d hata)" % _hata)
		get_tree().quit(1)


func _kontrol(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hata += 1
		printerr("HATA: " + mesaj)


func _cagriliyor(kaynaklar: Dictionary, yol: String, ad: String) -> bool:
	var dosya := yol.get_file()
	for diger in kaynaklar:
		if diger == yol:
			continue
		var metin: String = kaynaklar[diger]
		if (not ad.is_empty() and metin.contains(ad)) or metin.contains(dosya):
			return true
	return false


func _src_metinleri(kok: String) -> Dictionary:
	var sonuc := {}
	var dizin := DirAccess.open(kok)
	if dizin == null:
		return sonuc
	for alt in dizin.get_directories():
		sonuc.merge(_src_metinleri(kok.path_join(alt)))
	for dosya in dizin.get_files():
		if dosya.ends_with(".gd") or dosya.ends_with(".tscn"):
			sonuc[kok.path_join(dosya)] = FileAccess.get_file_as_string(kok.path_join(dosya))
	return sonuc
