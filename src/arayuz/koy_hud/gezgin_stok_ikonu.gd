class_name GezginStokIkonu
extends RefCounted
## Stok ikonları gerçek dokuyu kullanır; tema/test uyumu için yer_tutucu çocuk korunur.
const DOKU := {
	"su": "res://assets/art/icons/icon_stok_su.png",
	"saman": "res://assets/art/icons/icon_esya_arpa_64.png",
	"balta": "res://assets/art/icons/icon_stok_balta.png",
	"civi": "res://assets/art/icons/icon_stok_civi.png",
	"tirpan": "res://assets/art/icons/icon_stok_tirpan.png",
	"sargi": "res://assets/art/icons/icon_stok_sargi.png",
	"afyon": "res://assets/art/icons/icon_esya_ilac_64.png",
	"kumas": "res://assets/art/icons/icon_stok_kumas_stok.png",
	"kece": "res://assets/ui/atmosfer/gece_kapisi/icon_bez.png",
	"zirh": "res://assets/art/icons/icon_stok_zirh.png",
	"yay": "res://assets/art/icons/icon_stok_yay.png",
	"kalkan": "res://assets/art/icons/icon_stok_kalkan.png",
	"ilac": "res://assets/art/icons/icon_stok_ilac_stok.png",
	"demir": "res://assets/art/icons/icon_stok_demir.png",
	"cevher": "res://assets/art/icons/icon_stok_cevher.png",
	"kurk": "res://assets/art/icons/icon_stok_kurk.png",
	"bugday": "res://assets/art/icons/icon_stok_bugday.png",
}


static func ikon(r: TextureRect, tur: String) -> bool:
	if tur not in ["civi", "tirpan", "balta", "afyon", "sargi", "kece", "kumas", "zirh", "yay", "kalkan", "su", "saman", "ilac", "demir", "cevher", "kurk", "bugday"]: return false
	var renk := String(SamanBakimi.AYAR.ikon_renk) if tur == "saman" else (Kabuk.STOK_SU.to_html() if tur == "su" else Kabuk.STOK_KUMAS.to_html())
	var c := Kabuk.yer_tutucu(tur, renk, Vector2.ZERO)
	r.add_child(c)
	c.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var yol := String(DOKU.get(tur, ""))
	if not yol.is_empty() and ResourceLoader.exists(yol):
		r.texture = load(yol)
		c.self_modulate.a = 0.0
	return true
