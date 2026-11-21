## AYR-12, AYR-23 … AYR-27: Oyun sekmesi.
extends VBoxContainer

var ayarlar: Ayarlar
var aciklama: Label
var ipucu_kaydi: IpucuKaydi

const ANAHTARLAR: Array[StringName] = [
	&"zorluk", &"koy_hizi_varsayilan", &"ipuclari", &"kademeli_hud",
	&"olayda_duraklat", &"rapor_bekle", &"karar_onayi", &"otomatik_kayit", &"kamera_eksen_ters",
]


func _ready() -> void:
	add_theme_constant_override("separation", 8)
	for anahtar in ANAHTARLAR:
		preload("res://src/arayuz/ayarlar/ayar_satiri.gd").ekle(self, ayarlar, anahtar, aciklama)
	var sifir := Button.new()
	sifir.text = tr("arayuz.ayarlar.ipuclari_sifirla")
	sifir.custom_minimum_size = Vector2(280, 46)
	sifir.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	sifir.pressed.connect(func() -> void:
		preload("res://src/sistemler/ipucu_anahtari.gd").sifirla(ipucu_kaydi)
	)
	add_child(sifir)
