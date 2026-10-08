## TUC-13: mevcut teslimat ardından aynı zimmet işleminden komisyon.
class_name SiparisKomisyonu
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/siparis_komisyonu.json"))
## JSON sayıları float gelir; izinli oranları tamsayı değerleriyle karşılaştırır.
static func oran_uygun(oran: int) -> bool:
 for izin in AYAR.oranlar:
  if int(izin) == oran: return true
 return false
## Salt okunur teklif: tüm teslimat ve mevcut zimmet sınırları birlikte denetlenir.
static func onizle(o: Oturum, id: String, oran: int) -> Dictionary:
 var y := o.yonetim
 if not oran_uygun(oran) or not SiparisTeslimati.teslim_edilebilir(y, id): return {}
 var s: Dictionary = y.siparisler.sozlesmeler[id]
 var bedel := int(s.odul) * oran / 100
 if bedel <= 0 or not KasaTransferi.gelir_uygun(o, bedel, int(s.odul)): return {}
 return {"komisyon": bedel, "kamu": int(s.odul) - bedel, "odul": int(s.odul)}
## Ön denetim sonrası yieldsiz tek teslim; ikinci ödül veya zimmet yolu yaratmaz.
static func teslim(o: Oturum, id: String, oran: int) -> bool:
 var teklif := onizle(o, id, oran)
 if teklif.is_empty(): return false
 if not SiparisTeslimati.teslim(o.yonetim, id): return false
 KasaTransferi.uygula(o, "zimmet", int(teklif.komisyon))
 var s: Dictionary = o.yonetim.siparisler.sozlesmeler[id]
 s.komisyon = int(teklif.komisyon)
 s.komisyon_orani = oran
 return true
## Yalnız tamamlanmış siparişin donmuş ödülüne uyan isteğe bağlı makbuz yüklenir.
static func kayit(v: Dictionary, hedef: Dictionary) -> void:
 if hedef.durum != "teslim": return
 var oran: Variant = v.get("komisyon_orani")
 var tutar: Variant = v.get("komisyon")
 for n in [oran, tutar]:
  if not (n is int or n is float) or not is_finite(float(n)) or floor(float(n)) != float(n): return
 if float(oran) < 0 or float(oran) > 100 or not oran_uygun(int(oran)) or float(tutar) <= 0 or float(tutar) > int(KasaTransferi.AYAR.gunluk_zimmet_azami): return
 if int(tutar) != int(hedef.odul) * int(oran) / 100: return
 hedef.komisyon = int(tutar)
 hedef.komisyon_orani = int(oran)
