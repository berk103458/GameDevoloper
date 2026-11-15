## DIY-14: "Bu hatirlanacak" bildirimi.
## Hafiza (DIY-11), dedikodu (DIY-13), kacis (ZAR-03) veya aga yazilan muhafiz dugumu
## (SOY-26, anahtar soylenti_muhafiz) olan secimde oyuncu 2 saniye notu gorur.
## Kural bu siniftadir; ikinci bir not sistemi yoktur.
## Notta isim, grup ve gece sayisi yoktur; metin ceviri anahtaridir.
## Ayar kapatilirsa not gizlenir, kayit yine yazilir. Ayni secimde not bir kez cikar.
class_name HatirlanmaNotu
extends PanelContainer


const CEVIRI_ANAHTARI := &"UI_BU_HATIRLANACAK"
const VARSAYILAN_METIN := "Bu hatırlanacak"
const SURE_SANIYE := 2.0
## Yeni yazim turu buraya tek anahtar ekler. Notun cikis kurali degismez.
const TETIK_ANAHTARLARI: Array[String] = ["hafiza", "kacis_hafiza", "dedikodu", "soylenti_muhafiz"]

var bildirim_acik: bool = true
var _etiket: Label = null
var _kalan_sure: float = 0.0
var _gorunme_sayisi: int = 0
var _kayit_yazim_sayisi: int = 0
var _aktif_not_sayisi: int = 0


func _init() -> void:
	visible = false
	mouse_filter = Control.MOUSE_FILTER_STOP
	_etiket = Label.new()
	_etiket.name = "HatirlanmaEtiketi"
	_etiket.text = VARSAYILAN_METIN
	add_child(_etiket)


func _ready() -> void:
	_metni_guncelle()


func _process(delta: float) -> void:
	if visible and _kalan_sure > 0.0:
		ilerlet(delta)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			tikla()


## Ceviri anahtarindan metni cozer; anahtar tanimli degilse "Bu hatırlanacak" doner.
## Metinde asla ozel ad, grup veya gece sayisi yer almaz.
func metin_oku() -> String:
	var ceviri := tr(String(CEVIRI_ANAHTARI))
	if ceviri.is_empty() or ceviri == String(CEVIRI_ANAHTARI):
		return VARSAYILAN_METIN
	return ceviri


## Toplam kac kez gorundugunu doner (test ve olcum icin).
func gorunme_sayisi() -> int:
	return _gorunme_sayisi


## Toplam kac secimde kayit yazildigini doner.
func kayit_yazim_sayisi() -> int:
	return _kayit_yazim_sayisi


## Su an ekranda acik olan not sayisini doner (en cok 1 olabilir, ust uste binmez ve kuyruk birikmez).
func aktif_not_sayisi() -> int:
	return _aktif_not_sayisi


## Kalan gosterim suresini saniye cinsinden doner.
func kalan_sure() -> float:
	return _kalan_sure


## Bir secim sonucunda tetik listesindeki yazimi isler ve gerekiyorsa notu acar.
## - Ayar kapaliyken de `kayit_islemi` calisir ve kayit sayaci 1 artar; yalniz not gizlenir.
## - Ayni secimde birden fazla tetik varsa not 1 kez cikar.
## - Ikinci not birincinin ustune binmez; birincisi kapanir, kuyruk birikmez.
func secim_bildir(olay: Dictionary, kayit_islemi: Callable = Callable()) -> Dictionary:
	if not _tetik_var(olay):
		return {
			"kayit_yazildi": false,
			"not_gorundu": false,
			"not_sayisi": 0,
			"metin": "",
		}

	# Ayar kapali olsa bile kayit yazimi durmaz
	if kayit_islemi.is_valid():
		kayit_islemi.call()
	_kayit_yazim_sayisi += 1

	if not bildirim_acik:
		kapat()
		return {
			"kayit_yazildi": true,
			"not_gorundu": false,
			"not_sayisi": 0,
			"metin": "",
		}

	# Eger onceki bir not aciksa once onu kapat (ust uste binmez, kuyruk birikmez)
	if visible or _aktif_not_sayisi > 0:
		kapat()

	_metni_guncelle()
	visible = true
	_kalan_sure = SURE_SANIYE
	_aktif_not_sayisi = 1
	_gorunme_sayisi += 1

	return {
		"kayit_yazildi": true,
		"not_gorundu": true,
		"not_sayisi": 1,
		"metin": _etiket.text,
		"ceviri_anahtari": String(CEVIRI_ANAHTARI),
	}


## Zamani ilerletir; 2 saniye dolunca not kendiliginden kapanir.
func ilerlet(delta: float) -> void:
	if not visible:
		return
	_kalan_sure = maxf(0.0, _kalan_sure - maxf(0.0, delta))
	if _kalan_sure <= 0.0:
		kapat()


## Oyuncu nota tikladiginda aninda kapatir.
func tikla() -> void:
	kapat()


## Notu kapatir ve sifirlar.
func kapat() -> void:
	visible = false
	_kalan_sure = 0.0
	_aktif_not_sayisi = 0


func _tetik_var(olay: Dictionary) -> bool:
	for anahtar in TETIK_ANAHTARLARI:
		if bool(olay.get(anahtar, false)):
			return true
	return false


func _metni_guncelle() -> void:
	if _etiket != null:
		_etiket.text = metin_oku()
