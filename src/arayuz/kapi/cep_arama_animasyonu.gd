## Kapı heybe panelinde cep/kese arama kare dizisi.
## Varyant rastgele seçilir; kare dosyaları yoksa `olustur` null döner, eski çizim bozulmaz.
class_name CepAramaAnimasyonu
extends TextureRect

signal bitti

const KOK := "res://assets/ui/kapi/cep_arama/"
const VARYANTLAR: PackedStringArray = [
	"kahverengi_deri",
	"kirmizi_kilim",
	"lacivert_cizgili",
	"yesil_islemeli",
	"keten_sade",
]
const KARE_SURE := 0.16
const SON_TUTMA := 0.28

var varyant := ""
var _kareler: Array[Texture2D] = []


static func kare_yolu(v: String, no: int) -> String:
	return "%s%s/kare_%02d.png" % [KOK, v, no]


static func varyant_kareleri(v: String) -> Array[Texture2D]:
	var kareler: Array[Texture2D] = []
	for no in range(1, 9):
		var yol := kare_yolu(v, no)
		if not ResourceLoader.exists(yol):
			break
		var doku: Texture2D = load(yol)
		if doku == null:
			break
		kareler.append(doku)
	return kareler


## En az iki karesi olan bir varyantı rastgele seçer; yoksa null.
static func olustur(rng: RandomNumberGenerator = null) -> CepAramaAnimasyonu:
	var adaylar: PackedStringArray = []
	for v in VARYANTLAR:
		if varyant_kareleri(v).size() >= 2:
			adaylar.append(v)
	if adaylar.is_empty():
		return null
	if rng == null:
		rng = RandomNumberGenerator.new()
		rng.randomize()
	var v := adaylar[rng.randi_range(0, adaylar.size() - 1)]
	var n := CepAramaAnimasyonu.new()
	n.varyant = v
	n._kareler = varyant_kareleri(v)
	return n


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	if not _kareler.is_empty():
		texture = _kareler[0]


func oyna() -> void:
	if _kareler.size() < 2:
		bitti.emit()
		return
	texture = _kareler[0]
	for i in range(1, _kareler.size()):
		await get_tree().create_timer(KARE_SURE).timeout
		if not is_instance_valid(self):
			return
		texture = _kareler[i]
	await get_tree().create_timer(SON_TUTMA).timeout
	if is_instance_valid(self):
		bitti.emit()
