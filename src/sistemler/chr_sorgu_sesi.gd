## Kaynak SFX tanımı ve replikteki eyleme göre kısa, özgün foley.
extends RefCounted

static func efekt(karakter: KarakterVerisi, replik: String) -> StringName:
	var tanim := (karakter.sfx + " " + replik).to_lower()
	if tanim.contains("kabza") or tanim.contains("kılıç") or tanim.contains("hançer"):
		return &"sfx_chr_kabza"
	if tanim.contains("bebek") or tanim.contains("çocuk solu"):
		return &"sfx_chr_bebek"
	if tanim.contains("ferman") or tanim.contains("kağıt") or tanim.contains("kâğıt"):
		return &"sfx_chr_kagit"
	if tanim.contains("çapa") or tanim.contains("demir") or tanim.contains("zincir"):
		return &"sfx_chr_metal"
	if tanim.contains("sikke") or tanim.contains("akçe") or tanim.contains("gümüş"):
		return &"sfx_chr_sikke"
	return &"sfx_chr_deri"

static func cal(karakter: KarakterVerisi, replik: String) -> void:
	preload("res://src/sistemler/guvenli_ses_cagrisi.gd").oynat(efekt(karakter, replik), -12.0)
