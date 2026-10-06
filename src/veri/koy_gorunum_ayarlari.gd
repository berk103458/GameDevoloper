## Köy görünümünün ayar değerleri (köylü programı, saat hızı, kamera). Oyun kurallarını etkilemez;
## yalnız görünümü ve temposu belirler. Kaynak: `data/ayarlar/koy_gorunum.tres`.
class_name KoyGorunumAyarlari
extends Resource

## Köy görünümü açıldığında saat (24 saatlik).
@export var baslangic_saati := 16.5
## Geceye geçildiğinde saat; bu saatten sonra herkes evdedir.
@export var gece_saati := 21.5
## 1× hızda bir oyun saati kaç gerçek saniye sürer.
@export var saat_suresi_sn := 30.0
## Ortalama iş bitişi; köylü başına ±yarım saat sapar.
@export var is_bitis_saati := 18.4
## Meydandan eve dönüş saati (ortalama).
@export var eve_donus_saati := 20.0
## Köylü yürüyüş hızı (m/s) ve kişi başına sapma oranı (±).
@export var yurume_hizi := 1.6
@export var hiz_sapmasi := 0.15
## Halk barı bu değerin altındaysa köylüler ağır, yorgun yürür.
@export var yorgun_esik := 4
@export var yorgun_hiz_carpani := 0.75
## Yapay zekâ kararları: karede kaç köylü düşünür.
@export var karede_dusunen := 5
## Yumuşak ayrışma: bu mesafeden yakın iki köylü birbirini iter (m).
@export var ayrisma_mesafesi := 0.75
## Bu uzaklıktan sonra animasyon yarı hızda güncellenir (m).
@export var lod_uzaklik := 30.0
## Kamera yakınlaşma sınırları (m) ve eğim (derece, yakın → uzak).
@export var kamera_yakin := 8.0
@export var kamera_uzak := 45.0
@export var kamera_egim_yakin := -30.0
@export var kamera_egim_uzak := -65.0
## Yapı simgeleri bu uzaklıktan sonra gizlenir (m).
@export var simge_uzaklik := 32.0
## Tavuk ve köpek sayısı.
@export var tavuk_sayisi := 5
@export var kopek_sayisi := 1
@export var koyun_sayisi := 7


## Kaynaktan yükler; dosya yoksa varsayılanlar.
static func yukle() -> KoyGorunumAyarlari:
	var yol := "res://data/ayarlar/koy_gorunum.tres"
	if ResourceLoader.exists(yol):
		var r := load(yol) as KoyGorunumAyarlari
		if r != null:
			return r
	return KoyGorunumAyarlari.new()
