## EKO-15: gerçek gece raporunu açıklayan salt okunur bilanço adaptörü.
class_name GeceBilancosu
extends RefCounted
const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const KAPI_ACILIS = preload("res://src/sistemler/kapi_acilis_olayi.gd")
const GELEN_META := &"ogr05_gece_gelenleri"

static func kisa_mi(o: Oturum) -> bool:
 return o.gun < 3 and ACILIS.durum(o).get("kuruldu", false)

static func gelenleri_oku(v: Variant) -> Array[String]:
 var adlar: Array[String] = []
 if not v is Array or v.size() > 128: return adlar
 for ad in v:
  if not ad is String or ad.is_empty() or ad.length() > 192: continue
  if ad not in adlar: adlar.append(ad)
 return adlar

static func gelen_yaz(o: Oturum, gelen: Gelen) -> void:
 if not kisa_mi(o): return
 var adlar := gelenleri_oku(o.get_meta(GELEN_META, []))
 var ad := o.tr_gelen(gelen)
 if ad not in adlar and adlar.size() < 128 and not ad.is_empty() and ad.length() <= 192:
  adlar.append(ad)
  o.set_meta(GELEN_META, adlar)

static func kapi_ozeti(o: Oturum) -> Dictionary:
 if not kisa_mi(o): return {}
 var gelenler := gelenleri_oku(o.get_meta(GELEN_META, []))
 if o.gun == 0 and o.bayraklar.has(KAPI_ACILIS.ULAK):
  gelenler.push_front(String(KAPI_ACILIS.AYAR.ulak))
 var kalanlar: Array[String] = []
 for kisi in o.yonetim.koylular:
  if kisi.giris_gunu == o.gun and not kisi.bayrak_var(ACILIS.MUHAFIZ) and not kisi.bayrak_var(ACILIS.ES):
   kalanlar.append(kisi.ad)
 return {"gelenler": gelenler, "kalanlar": kalanlar}

## Gece başlamadan mevcut kasaları, stoğu ve bordroyu kopyalar; RNG tüketmez.
static func fotograf(o: Oturum) -> Dictionary:
 return {"kamu": o.koy_akce, "kisisel": o.muhafiz_akce, "stok": o.yonetim.kaynaklar.stok.duplicate(true), "tasma": o.yonetim.kaynaklar.bakim.tasma.duplicate(true), "bordro": o.yonetim.maas_durumu.duplicate(true), "asinma": o.yonetim.alet_asinma, "kapi_ozeti": kapi_ozeti(o)}
## Gerçek açılış/kapanış ile gerçekleşen üretim/tüketim/ziyanı mutabık hale getirir.
static func olustur(o: Oturum, once: Dictionary, rapor: Dictionary) -> Dictionary:
 var y := o.yonetim
 var vergi := 0
 for e in rapor.olaylar:
  if e.get("anahtar") == "koy.olay.vergi": vergi += int(e.deger[0])
 var maas := 0
 for id in y.maas_durumu:
  var yeni: Dictionary = y.maas_durumu[id]
  var eski: Dictionary = once.bordro.get(id, {})
  if int(yeni.son_gece) == int(rapor.gun) and int(eski.get("son_gece", -1)) != int(rapor.gun) and int(yeni.borc) == 0:
   maas += y.a.muhafiz_maas + int(eski.get("borc", 0))
 var kamu := {"once": int(once.kamu), "sonra": o.koy_akce, "net": o.koy_akce - int(once.kamu), "maas": maas, "vergi": vergi}
 kamu["diger_net"] = int(kamu.net) - vergi + maas
 var kisisel := {"once": int(once.kisisel), "sonra": o.muhafiz_akce, "net": o.muhafiz_akce - int(once.kisisel)}
 var stok := {}
 var ziyan: Dictionary = rapor.get("ziyan", {})
 for tur in Kaynaklar.TURLER:
  var ilk := int(once.stok.get(tur, 0))
  var son := y.kaynaklar.miktar(tur)
  var u := int(rapor.uretim.get(tur, 0))
  var t := int(rapor.tuketim.get(tur, 0))
  var b := int(ziyan.get("bozulma", {}).get(tur, 0))
  var bildirim := int(ziyan.get("tasma", {}).get(tur, 0))
  # Gündüz kaybı açılış stoğundan zaten düşülmüştür; bu gece ikinci kez gider yazılmaz.
  var tasma := bildirim + int(y.kaynaklar.bakim.tasma.get(tur, 0)) - int(once.tasma.get(tur, 0))
  stok[tur] = {"once": ilk, "sonra": son, "net": son - ilk, "uretim": u, "tuketim": t, "bozulma": b, "tasma_bildirimi": bildirim, "tasma_gece": tasma, "diger_net": son - ilk - u + t + b + tasma}
 var sonuc := {"surum": 1, "gun": int(rapor.gun), "kamu": kamu, "kisisel": kisisel, "stok": stok, "alet_asinma": {"once": float(once.asinma), "sonra": y.alet_asinma}, "transfer_ozeti": o.kasa_transferleri.duplicate(true)}
 if not once.get("kapi_ozeti", {}).is_empty(): sonuc["kapi_ozeti"] = once.kapi_ozeti
 ## DEN-55: fiyat kaynağıyla durur; kış çarpanı ayrı satır, tablo TUC-09'dur ve yeni bilanço yoktur.
 var mevsim := y.mevsim()
 if mevsim == MevsimYoneticisi.MEVSIM_SAYISI - 1:
  sonuc["kis_carpani"] = {"carpan": float(TicaretFiyatlari.AYAR.mevsim_carpani[mevsim]), "mevsim": mevsim, "kaynak": "mevsim_carpani"}
 return sonuc

## OZL-05: BUG-16 havuzu boşsa kart çıkmaz; rapor "bu gece köy sessiz" satırı yazar, oyun devam eder.
static func sessiz_gece_kontrol(olay: Variant, rapor: Dictionary) -> void:
 if olay == null and rapor.get("olaylar") is Array: rapor.olaylar.append({"anahtar": "bu gece köy sessiz"})
