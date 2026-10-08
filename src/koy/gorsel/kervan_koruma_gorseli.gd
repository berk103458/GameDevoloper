## TUC-15: kervana giden mevcut figür köyde devriye çizmez; yeni model yoktur.
class_name KervanKorumaGorseli
extends RefCounted
static func hedef(h: KoyHalkHareketi, k: Koylu, d: Dictionary, _bas: Vector2i, normal: Vector2i) -> Vector2i:
 var dis := KervanKorumasi.disarida(h.sahne.yonetim, k.id)
 h.modeller[k.id].visible = not dis and not DivanHukmu.zindanda(k)
 if not dis: return normal
 for alan in ["is", "dinlen", "siginma", "sinsi", "ates_basi", "coban", "zanaat", "sulama", "oduncu", "degirmenci"]: d[alan] = false
 d.devriye = true
 d.devriye_ad = "Kervan korumasında"
 return Vector2i(-1, -1)
