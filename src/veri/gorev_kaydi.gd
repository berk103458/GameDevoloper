## Deneme görevi. Kimlik eklentinin tamsayısıdır; oyundaki ad `slug` (İngilizce).
## Oyuncu metni `metinler.csv` anahtarındadır. Ödül yazmaz, oturum bayrağı yazmaz.
extends Quest
class_name GorevKaydi

## İngilizce görev kimliği (`quest_gate_admit_three`).
@export var slug: String = ""
## Başlık çeviri anahtarı.
@export var baslik_anahtari: String = ""
## Tek satırlık amaç çeviri anahtarı.
@export var amac_anahtari: String = ""
## `kabul_sayisi`, `gida_esik` ya da `bayrak`.
@export var tur: String = ""
## Eşik. Bayrak görevinde 1.
@export var hedef: int = 1
## Çalışma anı bayrak dizgesi (`usta_ciftci`). Boşsa bayrak aranmaz.
@export var bayrak: String = ""
## `gelen`, `koylu` ya da `oturum`.
@export var bayrak_yeri: String = ""
## Ölçülen ilerleme.
var ilerleme: int = 0
## Tamamlandığı oyun günü; -1 ise henüz bitmedi.
var bitti_gun: int = -1


## Kayıt için yalnız ilerleme. Kaynak üstündeki metin anahtarları pakette durur.
func serialize() -> Dictionary:
	return {
		"slug": slug,
		"ilerleme": ilerleme,
		"objective_completed": objective_completed,
		"bitti_gun": bitti_gun,
	}


## JSON tamsayıyı floata çevirir; alanlar elle okunur.
func deserialize(data: Dictionary) -> void:
	ilerleme = int(data.get("ilerleme", ilerleme))
	bitti_gun = int(data.get("bitti_gun", bitti_gun))
	objective_completed = bool(data.get("objective_completed", objective_completed))
