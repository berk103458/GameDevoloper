## EKO-15: gerçek gece raporunu açıklayan salt okunur bilanço adaptörü.
class_name GeceBilancosu
extends RefCounted
## Gece başlamadan mevcut kasaları, stoğu ve bordroyu kopyalar; RNG tüketmez.
static func fotograf(o: Oturum) -> Dictionary:
 return {"kamu": o.koy_akce, "kisisel": o.muhafiz_akce, "stok": o.yonetim.kaynaklar.stok.duplicate(true), "tasma": o.yonetim.kaynaklar.bakim.tasma.duplicate(true), "bordro": o.yonetim.maas_durumu.duplicate(true), "asinma": o.yonetim.alet_asinma}
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
 ## DEN-55: fiyat kaynağıyla durur; kış çarpanı ayrı satır, tablo TUC-09'dur ve yeni bilanço yoktur.
 var mevsim := y.mevsim()
 if mevsim == MevsimYoneticisi.MEVSIM_SAYISI - 1:
  sonuc["kis_carpani"] = {"carpan": float(TicaretFiyatlari.AYAR.mevsim_carpani[mevsim]), "mevsim": mevsim, "kaynak": "mevsim_carpani"}
 return sonuc
