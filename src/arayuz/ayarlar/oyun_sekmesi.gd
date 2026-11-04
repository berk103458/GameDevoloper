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
	for anahtar in ANAHTARLAR:
		preload("res://src/arayuz/ayarlar/ayar_satiri.gd").ekle(self, ayarlar, anahtar, aciklama)
	var sifir := Button.new()
	sifir.text = tr("arayuz.ayarlar.ipuclari_sifirla")
	sifir.pressed.connect(func() -> void:
		preload("res://src/sistemler/ipucu_anahtari.gd").sifirla(ipucu_kaydi)
	)
	add_child(sifir)
