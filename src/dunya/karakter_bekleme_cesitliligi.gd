## ANI-12: mevcut idle modifierine faz ve üç basit davranış; asset klibi üretmez.
class_name KarakterBeklemeCesitliligi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/bekleme_cesitliligi.json"))
## Kimliğe göre kararlı saniye ofseti/varyant; rastgelelik veya oturum verisi değiştirilmez.
static func profil(id: int) -> Dictionary:
 var n := maxi(2, int(AYAR.ofset_ornekleri))
 var oran := float(posmod(id * int(AYAR.ofset_adimi), n)) / float(n - 1)
 return {"ofset": lerpf(float(AYAR.ofset_min), float(AYAR.ofset_max), oran), "varyant": posmod(id, AYAR.varyantlar.size())}
## Yeni köylü modeli kurulurken tek satırlık adaptör; faz yenilemede profil değişmez.
static func uygula(f: KarakterModel, id: int) -> void:
 var d := f.duzeltici()
 if d == null: return
 var p := profil(id)
 d.faz = p.ofset
 d.bekleme_varyanti = p.varyant
## Gövde/kalça/baş açıları; atanmamış modele önceki idle, yürüyüşe sıfır etki.
static func acilar(t: float, bekleme: float, varyant: int) -> Vector3:
 var carp: Array = AYAR.varyantlar[varyant].carpan if varyant >= 0 and varyant < AYAR.varyantlar.size() else [1.0, 1.0, 1.0]
 var nefes := sin(t * TAU / float(AYAR.nefes_suresi)) * deg_to_rad(float(AYAR.nefes_derece))
 var agirlik := sin(t * TAU / float(AYAR.agirlik_suresi)) * deg_to_rad(float(AYAR.agirlik_derece))
 var bakis := (sin(t * float(AYAR.bakis_hizlari[0])) * float(AYAR.bakis_agirliklari[0]) + sin(t * float(AYAR.bakis_hizlari[1]) + float(AYAR.bakis_faz)) * float(AYAR.bakis_agirliklari[1])) * deg_to_rad(float(AYAR.bakis_derece))
 return Vector3(nefes * float(carp[0]), agirlik * float(carp[1]), bakis * float(carp[2])) * bekleme
