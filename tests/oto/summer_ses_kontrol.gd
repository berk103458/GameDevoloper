## Summer sesleri yüklenir, üç bus Master'a gider, eksik kaynakta çıkar.
extends Node

const DOSYALAR: PackedStringArray = [
	"res://assets/ses/summer/ates/yanan_odun.ogg",
	"res://assets/ses/summer/arayuz/tiklama.ogg",
	"res://assets/ses/summer/adim/tahta.ogg",
	"res://assets/ses/summer/adim/tas.ogg",
	"res://assets/ses/summer/odun/agac_kesimi.ogg",
	"res://assets/ses/summer/ortam/gece_cir_ruzgar.ogg",
	"res://assets/ses/summer/gerilim/karanlik_vurgu.ogg",
	"res://assets/ses/summer/KAYNAKLAR.csv",
	"res://data/ses/ses_denge_tablosu.json",
	"res://data/ses/default_bus_layout.tres",
]


func _ready() -> void:
	var hata := 0
	for ad in ["Muzik", "Efekt", "Ortam"]:
		var i := AudioServer.get_bus_index(ad)
		if i < 0 or AudioServer.get_bus_send(i) != &"Master":
			hata += 1
			push_error("bus yok ya da Master'a gitmiyor: " + ad)
	var ortam := AudioServer.get_bus_index("Ortam")
	var efekt := AudioServer.get_bus_index("Efekt")
	AudioServer.set_bus_mute(ortam, true)
	if AudioServer.is_bus_mute(efekt):
		hata += 1
		push_error("Ortam susturulunca Efekt de sustu")
	AudioServer.set_bus_mute(ortam, false)
	if Ses.ortam_busu_adi() != &"Ortam":
		hata += 1
		push_error("ortam çaları Ortam bus'ında değil")
	for yol in DOSYALAR:
		if not ResourceLoader.exists(yol) and not FileAccess.file_exists(yol):
			hata += 1
			push_error("eksik kaynak: " + yol)
	for anahtar in [&"sfx_secim", &"sfx_adim_tas", &"sfx_adim_tahta", &"sfx_odun", &"sfx_gerilim", &"ortam_koy_gece", &"ortam_mesale_dongu"]:
		if not Ses.oynat(anahtar, -80.0):
			hata += 1
			push_error("çalınamadı: " + String(anahtar))
	if Ayarlar.BUSLAR[&"ses_ortam"] != "Ortam" or int(Ayarlar.VARSAYILAN[&"ses_ortam"]) != 8:
		hata += 1
		push_error("ortam sürgüsü bağlı değil")
	print("SUMMER SES: GEÇTİ" if hata == 0 else "SUMMER SES: KALDI (%d)" % hata)
	get_tree().quit(1 if hata > 0 else 0)
