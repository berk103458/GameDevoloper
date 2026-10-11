## MEV-15: aynı mantıksal kuyruk korunur; yalnız fırtınada yolun görünür bekleme kapasitesi daralır.
class_name KapiFirtinaKuyrugu
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/kapi_firtina_kuyrugu.json"))
const META := "firtina_kuyruk_kapasitesi"
const BEKLEME := "firtina_kuyruk_bekleme"
## Normal gecenin üç gelişi/mevcut altı model bütçesi değişmez; ağır kış tipisinde kimse yolda durmaz.
static func sinir(y: KoyYonetimi) -> int:
 if IklimDeneyi.hava(y) != "kar_firtinasi": return KapiSahnesi.KUYRUK_GORUNEN
 var agir := y.mevsim() == 3 and MevsimYoneticisi.mevsim_gunu(y.gun, y.a.mevsim_gun) >= int(AYAR.agir_kis_gunu)
 return int(AYAR.agir_kapasite) if agir else int(AYAR.tipi_kapasitesi)
## Mevcut sahneyi gecenin başında yapılandırır; ikinci liste/gelen üretimi veya RNG yok.
static func kur(o: Oturum, s: Node) -> void:
 s.set_meta(META, clampi(sinir(o.yonetim), 0, KapiSahnesi.KUYRUK_GORUNEN))
## Sahne adaptöründe normal eski sabit bütçe varsayılandır.
static func kapasite(s: Node) -> int:
 return clampi(int(s.get_meta(META, KapiSahnesi.KUYRUK_GORUNEN)), 0, KapiSahnesi.KUYRUK_GORUNEN)
## Yolda görünür kimse yoksa sıradaki uzak kişi doğru isim sırasından alınır; tekrar model doğmaz.
static func uzaktakini_al(s: Node) -> void:
 if kapasite(s) == 0 and not s._bekleyenler.is_empty(): s._bekleyenler.pop_front()
## Aktif kişi çıkarıldıktan sonra bekleyen her gerçek NPC bir kez/adım gerilir; kaynak CHR değişmez.
static func beklet(o: Oturum, kuyruk: Array[Gelen], adim: int) -> void:
 if IklimDeneyi.hava(o.yonetim) != "kar_firtinasi": return
 for g in kuyruk:
  var d: Dictionary = g.get_meta(BEKLEME, {})
  if int(d.get("adim", -1)) == adim: continue
  var artis := int(AYAR.bekleme_tansiyon)
  var toplam := clampi(int(d.get("toplam", 0)) + artis, 0, 10)
  g.set_meta(BEKLEME, {"adim":adim,"toplam":toplam})
  var sorgu := g.chr_sorgusu()
  if sorgu != null:
   sorgu.tansiyon += artis
   sorgu._dugume_git(sorgu.dugum_id)
   sorgu.tansiyon_degisti.emit(sorgu.tansiyon)
## Mevcut bilgi etiketinde tipi bekleyişi; CHR kendi tansiyon barını kullanır, figürde okunur stres bilgisi.
static func bilgi(o: Oturum, g: Gelen, l: Label) -> void:
 if IklimDeneyi.hava(o.yonetim) != "kar_firtinasi" or g == null: return
 var d: Dictionary = g.get_meta(BEKLEME, {})
 l.text += " · Tipi sırası %d · bekleme +%d" % [sinir(o.yonetim), int(d.get("toplam", 0))]
## Görünür iki kişi gerektiren sıra olayları daralmada üretilmez; olay RNG'si de çekilmez.
static func sira_olayi(o: Oturum, s: Node, n: int, kuyruk: Array[Gelen] = []) -> OlayVerisi:
 if n < 2 or (s is KapiSahnesi and s._kuyruktakiler.size() < 2): return null
 if DiplomatikHeyet.kilitli(o, kuyruk): return null
 return null if kapasite(s) < 2 else o.sira_olayi_sec(n)
