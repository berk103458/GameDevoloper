# gdlint: disable=max-line-length
class_name MuhafizYalani
extends RefCounted

## DYL-04: Muhafız da yalan söyler.
## Seçenek [Yalan] etiketi taşır. Karakterin sezgisi d10 >= esik ise yalan yakalanır.
## Yakalanırsa: güven -3, tansiyon +2. Yakalanmazsa: karakter inanır/korkar.
## Her yalan dogru: false olarak muhafız beyanına yazılır.

static func yalan_soyle(yalan_turu: String, karakter: Dictionary, baglam: Dictionary, zar_sonucu: int = -1) -> Dictionary:
	var sezgi_esigi: int = int(karakter.get("sezgi_esigi", 6))
	var zar: int = zar_sonucu
	if zar < 0:
		zar = randi_range(1, 10)

	var yakalandi: bool = (zar >= sezgi_esigi)
	var guven_farki: int = -3 if yakalandi else 0
	var tansiyon_farki: int = 2 if yakalandi else 0

	var beyan_kaydi := {
		"id": "muhafiz_yalani_" + yalan_turu,
		"tur": yalan_turu,
		"dogru": false,
		"yakalandi": yakalandi,
		"zaman": Time.get_unix_time_from_system()
	}

	return {
		"yalan_turu": yalan_turu,
		"yakalandi": yakalandi,
		"zar": zar,
		"sezgi_esigi": sezgi_esigi,
		"guven_farki": guven_farki,
		"tansiyon_farki": tansiyon_farki,
		"beyan_kaydi": beyan_kaydi
	}
