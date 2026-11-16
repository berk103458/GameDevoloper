## HAE-04: eski Ses anahtarları korunur; yalnız akış kaynağı değişir.
class_name HazirSesKaynaklari
extends RefCounted

const YOLLAR := {
	"sfx_kapi_acilir": "rubberduck/door_open_01.ogg",
	"sfx_kapi_kapanir": "kenney_rpg/doorClose_1.ogg",
	"sfx_adim": "heyhey/toprak_01.ogg",
	"sfx_chr_sikke": "rpg_sound/coin.wav",
	"sfx_kese": "kenney_rpg/handleCoins.ogg",
	"sfx_ors": "heyhey_savas/anvil_strike_01.ogg",
	"ortam_koy_gunduz": "quendel/dere_dongu.ogg",
	"ortam_koy_gece": "summer/ortam/gece_cir_ruzgar.ogg",
	"ortam_mesale_dongu": "summer/ates/yanan_odun.ogg",
	"sfx_secim": "summer/arayuz/tiklama.ogg",
	"sfx_adim_tas": "summer/adim/tas.ogg",
	"sfx_adim_tahta": "summer/adim/tahta.ogg",
	"sfx_odun": "summer/odun/agac_kesimi.ogg",
	"sfx_gerilim": "summer/gerilim/karanlik_vurgu.ogg",
}

static func yol(ad: String) -> String:
	return "res://assets/ses/" + String(YOLLAR.get(ad, ad + ".wav"))
