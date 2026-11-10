extends SceneTree
## SOY-38: ağın ayar sayıları yalnız `data/soylenti.json`'dadır; kodda varsayılan sayı ve oran yoktur.

const DOSYALAR := ["res://src/sistemler/soylenti_agi.gd", "res://src/sistemler/soylenti_koprusu.gd"]
var hata := 0


func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)


func _initialize() -> void:
	var veri: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/soylenti.json"))
	var varsayilan := RegEx.create_from_string("veri_yapilandirma\\.get\\(\"[a-z_]+\",\\s*-?[0-9]")
	var oran := RegEx.create_from_string("(?<![A-Za-z_\\-])[0-9]+\\.[0-9]+")
	var ayar := RegEx.create_from_string("_ayar\\(\"([a-z_]+)\"\\)")
	var okunan := 0
	for yol in DOSYALAR:
		for satir in FileAccess.get_file_as_string(yol).split("\n"):
			var kod := satir.split("#")[0]
			if kod.strip_edges().begins_with("##"):
				continue
			dene(varsayilan.search(kod) == null, "%s kodda varsayılan sayı: %s" % [yol, satir.strip_edges()])
			dene(oran.search(kod) == null, "%s kodda oran: %s" % [yol, satir.strip_edges()])
			for m in ayar.search_all(kod):
				okunan += 1
				dene(veri.has(m.get_string(1)), "soylenti.json'da yok: " + m.get_string(1))
	dene(okunan >= 10, "Ayarlar veriden okunur")
	print("SÖYLENTİ AYAR TARAMA: GEÇTİ" if hata == 0 else "SÖYLENTİ AYAR TARAMA: KALDI (%d hata)" % hata)
	quit(1 if hata > 0 else 0)
