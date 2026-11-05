## MEV-01: tek oyun gününden dört mevsim; Takvim eski API adaptörüdür.
class_name MevsimYoneticisi
extends RefCounted
const MEVSIM_SAYISI := 4
const VARSAYILAN_GUN := 7
## Bozuk sıfır/negatif süre bölme hatası yaratmaz; denge Resource'u değişmez.
static func sure(mevsim_gun: int) -> int:
 return mevsim_gun if mevsim_gun > 0 else VARSAYILAN_GUN
## İlk gün 0; varsayılan yedi günde bir yeni mevsim.
static func mevsim(gun: int, mevsim_gun: int) -> int:
 return (maxi(0, gun) / sure(mevsim_gun)) % MEVSIM_SAYISI
static func mevsim_gunu(gun: int, mevsim_gun: int) -> int:
 return maxi(0, gun) % sure(mevsim_gun) + 1
static func yil_gunu(gun: int, mevsim_gun: int) -> int:
 return maxi(0, gun) % (sure(mevsim_gun) * MEVSIM_SAYISI) + 1
## Mevcut haftalık vergi koşulu; başlangıç günü tahsilat yaratmaz.
static func hafta_basi(gun: int, mevsim_gun: int) -> bool:
 return gun > 0 and gun % sure(mevsim_gun) == 0
## Salt okunur ortak takvim yüzeyi; kayıt/RNG/saat veya iklim önayarı değiştirilmez.
static func durum(y: KoyYonetimi) -> Dictionary:
 var g := maxi(0, y.gun)
 var n := sure(y.a.mevsim_gun)
 var normal := mevsim(g, n)
 var etkin := y.mevsim()
 var adlar := y.a.mevsimler if y.a.mevsimler.size() == MEVSIM_SAYISI else PackedStringArray(["ilkbahar", "yaz", "sonbahar", "kis"])
 return {"bosta_moral_carpani": float(y.a.bosta_moral_carpanlari[etkin]) if y.a.bosta_moral_carpanlari.size() == MEVSIM_SAYISI else 1.0, "gun": g + 1, "yil": g / (n * MEVSIM_SAYISI) + 1, "yil_gunu": yil_gunu(g, n), "yil_uzunlugu": n * MEVSIM_SAYISI, "mevsim": etkin, "takvim_mevsimi": normal, "mevsim_gunu": mevsim_gunu(g, n), "mevsim_suresi": n, "sonraki_mevsime": n - (g % n), "ad": String(adlar[etkin]), "zorlanmis": etkin != normal, "hava": IklimDeneyi.hava(y)}
