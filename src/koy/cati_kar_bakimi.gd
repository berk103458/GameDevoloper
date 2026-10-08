class_name CatiKarBakimi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/cati_kar_bakimi.json"))
## Optional çatı yükü normal bina hasarı değildir; bozuk/eski kayıt güvenle sıfırlanır.
static func oku(v: Variant) -> Dictionary:
 var r := {"yuk": 0.0, "son_gece": -1}
 if not v is Dictionary: return r
 var n: Variant = v.get("yuk")
 if (n is int or n is float) and is_finite(float(n)) and float(n) >= 0 and float(n) <= 100: r.yuk = float(n)
 n = v.get("son_gece")
 if (n is int or n is float) and is_finite(float(n)) and float(n) == floor(float(n)) and float(n) >= -1 and float(n) <= 1000000000: r.son_gece = int(n)
 return r
## Ağır kar ve hazır çatısı olan mevcut yapı adayları.
static func catilar(y: KoyYonetimi) -> Array[KoyBinasi]:
 var r: Array[KoyBinasi] = []
 if MevsimKarOrtusu.oran(y) < float(AYAR.agir_esik): return r
 for b in y.binalar:
  if b.hazir() and b.tur in AYAR.turler: r.append(b)
 r.sort_custom(func(a: KoyBinasi, b: KoyBinasi) -> bool: return a.id < b.id if a.cati_kar.yuk == b.cati_kar.yuk else float(a.cati_kar.yuk) > float(b.cati_kar.yuk))
 return r
## Sağlıklı boş yetişkinler sırayla birer çatı temizler; görev/ekonomi salt okunur önizlemesi.
static func gorevler(y: KoyYonetimi, rotaci: KoyRotasi = null) -> Dictionary:
 var r := {}
 var aday := catilar(y)
 if aday.is_empty(): return r
 if rotaci == null:
  rotaci = KoyRotasi.new()
  rotaci.kur(y.izgara, 1.0)
 var bas := rotaci.yakin(y.a.meydan.position)
 var i := 0
 for k in y.koylular:
  if i >= aday.size(): break
  if k.is_yeri != KoyYonetimi.BOSTA or k.yas_grubu != &"yetiskin" or k.saglik < int(AYAR.saglik_esigi) or k.ac: continue
  while i < aday.size():
   var b := aday[i]
   i += 1
   var son := rotaci.bina_duragi(bas, Rect2i(b.hucre, b.boyut(y.katalog)), k.id)
   if son.x < 0 or rotaci.yol(bas, son).is_empty(): continue
   r[k.id] = b.id
   break
 return r
## Gecede bir kez kar yükü/temizlik; çökme aynı iadesiz bina kaldırma API'sini kullanır.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
 var aday := catilar(y)
 var temiz := gorevler(y).values()
 var cokme := 0
 for b in y.binalar.duplicate():
  if int(b.cati_kar.son_gece) == y.gun: continue
  b.cati_kar.son_gece = y.gun
  if b not in aday:
   b.cati_kar.yuk = maxf(0.0, float(b.cati_kar.yuk) - float(AYAR.temizlik))
   continue
  b.cati_kar.yuk = minf(100.0, float(b.cati_kar.yuk) + float(AYAR.gecelik_yuk))
  if b.id in temiz:
   b.cati_kar.yuk = maxf(0.0, float(b.cati_kar.yuk) - float(AYAR.temizlik))
   olaylar.append({"anahtar": "Çatı karı temizlendi: %s (#%d).", "deger": [MeslekYapilari.ad(b.tur), b.id]})
  if float(b.cati_kar.yuk) < float(AYAR.cokme_yuku) or cokme >= int(AYAR.gecelik_azami): continue
  if y._rng.randi_range(1, 100) <= int(AYAR.cokme_yuzde):
   var ad := MeslekYapilari.ad(b.tur)
   if y.bina_el_koy(b.id):
    cokme += 1
    olaylar.append({"anahtar": "Ağır karda çatı çöktü: %s (#%d). Yapıyı yeniden kurmalısın.", "deger": [ad, b.id]})
