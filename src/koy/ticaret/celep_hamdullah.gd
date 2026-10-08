## TUC-02: mevcut lojistik hayvan kaydının uzman ve barınak koşulları.
class_name CelepHamdullah
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/celep_hamdullah.json"))
## Yalnız Celep'in iki günlük konaklamasında canlı hayvan alınabilir.
static func geldi(y: KoyYonetimi) -> bool:
 var d := GezginTuccarTakvimi.durum(y.gun, y.a.kervan_araligi)
 return not TuccarKapiGecisi.engel(y) and d.aktif and d.tuccar.id == AYAR.tuccar and not SiparisIhlali.terk(y, d.tuccar.id)
## Koç ağılda, üç çeki türü ortak ahır kapasitesinde yer tutar.
static func barinak(tur: String) -> String:
 return String(AYAR.hayvanlar.get(tur, {}).get("barinak", ""))
## Tamamlanmış barınaklar; ağılın başlangıç dört koyununa ek iki koç yeri.
static func kapasite(y: KoyYonetimi, tur: String) -> int:
 var n := 0
 for b in y.binalar:
  if b.hazir() and b.tur == barinak(tur): n += int(AYAR.agil_ek_yer) if b.tur == "agil" else int(CekiLojistigi.AYAR.ahir_yer)
 return n
## Aynı barınak grubunu paylaşan satın alınmış toplam hayvan sayısı.
static func sayi(l: CekiLojistigi, tur: String) -> int:
 var n := 0
 for t in AYAR.hayvanlar:
  if barinak(t) == barinak(tur): n += int(l.hayvanlar.get(t, 0))
 return n
## Tek işlemin hem UI hem ekonomi katmanında yeniden doğrulanan koşulu.
static func alinabilir(y: KoyYonetimi, tur: String) -> bool:
 return AYAR.hayvanlar.has(tur) and CekiLojistigi.FIYAT.has(tur) and geldi(y) and sayi(y.lojistik, tur) < kapasite(y, tur) and y.akce >= int(CekiLojistigi.FIYAT[tur])
## Taşıma bonusu veren türleri aynı lojistik sayacından hesaplar.
static func ceki_sayisi(l: CekiLojistigi) -> int:
 var n := 0
 for t in AYAR.hayvanlar:
  if AYAR.hayvanlar[t].ceki: n += int(l.hayvanlar.get(t, 0))
 return n
## Kayıt sırasıyla barınaklara dağıtım; fazla hayvan yıkım sonrası silinmez.
static func barindir(y: KoyYonetimi, bina_id: int) -> Array[String]:
 var kalan := y.lojistik.hayvanlar.duplicate()
 for b in y.binalar:
  if not b.hazir() or b.tur not in ["ahir", "agil"]: continue
  var yer := int(AYAR.agil_ek_yer) if b.tur == "agil" else int(CekiLojistigi.AYAR.ahir_yer)
  var turler: Array[String] = []
  for t in AYAR.hayvanlar:
   if barinak(t) != b.tur: continue
   while yer > 0 and int(kalan.get(t, 0)) > 0:
    turler.append(t)
    kalan[t] = int(kalan[t]) - 1
    yer -= 1
  if b.id == bina_id: return turler
 return []
