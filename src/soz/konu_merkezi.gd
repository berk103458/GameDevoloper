# gdlint: disable=max-line-length
class_name KonuMerkezi
extends RefCounted

## DIY-03: Selam önce, hikâye sonra — konu merkezi.
## Selam verilmeden konu listesi açılmaz; konu açıkken karar çubuğu kapalıdır;
## veda veya sustu anında karar çubuğu açılır.

const SABIT_KONU_BASLIKLARI := {
	"nereden": "Nereden gelirsin?",
	"neden_yola_dustun": "Neden yola düştün?",
	"kiminle": "Kiminle geldin?",
	"ne_is_bilirsin": "Ne iş bilirsin?",
	"yukun": "Heybende ne var?",
	"yolda_ne_gordun": "Yolda ne gördün?",
	"haber": "Dışarıdan ne haber?"
}

var motor: SozMotoru = null
var selam_goruldu: bool = false
var karar_cubugu_etkin: bool = false
var koy_gecisi_yasak: bool = false

func _init(p_motor: SozMotoru = null) -> void:
	motor = p_motor
	selam_goruldu = false
	karar_cubugu_etkin = false
	koy_gecisi_yasak = false

func selam_oku() -> String:
	if motor == null:
		return ""
	var satir := motor.mevcut_satir()
	selam_goruldu = true
	karar_cubugu_etkin = false
	koy_gecisi_yasak = true
	return satir

func mevcut_konular(guncel_gece: int = -1) -> Array[Dictionary]:
	# Selam öncesi konu listesi 0 düğümdür (Kural 1 & Kabul)
	if not selam_goruldu or motor == null:
		return []

	var sonuc: Array[Dictionary] = []
	var secenekler := motor.mevcut_secenekler()

	for s in secenekler:
		var hedef_id: String = str(s.get("hedef", ""))
		if motor.dugumler.has(hedef_id):
			var d: SozDugumu = motor.dugumler[hedef_id]
			# OGR-13: İlk aile sorgusu kılavuzsuz ama dar.
			# gece_min şartı: güncel gece eşikten küçükse konu henüz açılmaz
			if guncel_gece >= 0 and d.gece_min > guncel_gece:
				continue
			if not d.konu.is_empty():
				var baslik = SABIT_KONU_BASLIKLARI.get(d.konu, s.get("metin", ""))
				sonuc.append({
					"konu_id": d.konu,
					"secenek_id": s.get("id"),
					"baslik": baslik,
					"hedef": hedef_id
				})

	return sonuc

func konu_sec(secenek_id: String) -> Dictionary:
	if motor == null:
		return {}

	# Konu açıkken karar çubuğu kapalıdır
	karar_cubugu_etkin = false
	koy_gecisi_yasak = true

	var sonuc := motor.sec(secenek_id)

	# Veda veya sustu durumunda karar çubuğu açılır
	if motor.veda_edildi or motor.sustu:
		karar_cubugu_etkin = true
		koy_gecisi_yasak = false

	return sonuc
