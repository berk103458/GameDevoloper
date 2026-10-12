## En çok dört eşzamanlı disk isteği; get yalnız LOADED sonrasında çağrılır.
class_name VarlikOnbellek
extends RefCounted

signal ilerledi(biten: int, toplam: int)
const ES_ZAMANLI := 4
var kaynaklar: Dictionary = {}
var hatalar: Array[String] = []
var istek_sayisi := 0
var katman: WeakRef
## `VarlikAkisDenetimi` kimliği: uçuştaki zincir defterinden düşmek için (bkz. o dosya).
var akis_is := 0


## Kaynakları tutan zincir koparsa (bitir() çağrılmadan nesne silinirse) defter kendiliğinden düşer.
func _notification(ne: int) -> void:
	if ne == NOTIFICATION_PREDELETE:
		VarlikAkisDenetimi.bitir(akis_is)

func yukle(agac: SceneTree, yollar: Array[String]) -> void:
	var sirada: Array[String] = []
	for yol in yollar:
		if yol in sirada or kaynaklar.has(yol):
			continue
		if ResourceLoader.exists(yol):
			sirada.append(yol)
		else:
			hatalar.append(yol)
	var toplam := sirada.size()
	var biten := 0
	var bekleyen: Array[String] = []
	# Dummy renderer testlerinde eşzamanlı doku başlatma hatası görüldü.
	# Gerçek renderer dört isteği korur; headless yükleme de kareler arasında yürür.
	var es_zamanli := 1 if DisplayServer.get_name() == "headless" else ES_ZAMANLI
	while not sirada.is_empty() or not bekleyen.is_empty():
		while not sirada.is_empty() and bekleyen.size() < es_zamanli:
			var yol := sirada.pop_front() as String
			var sonuc := ResourceLoader.load_threaded_request(yol)
			istek_sayisi += 1
			if sonuc == OK:
				bekleyen.append(yol)
			else:
				hatalar.append(yol)
				biten += 1
		for yol in bekleyen.duplicate():
			var durum := ResourceLoader.load_threaded_get_status(yol)
			if durum == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				continue
			if durum == ResourceLoader.THREAD_LOAD_LOADED:
				kaynaklar[yol] = ResourceLoader.load_threaded_get(yol)
			else:
				hatalar.append(yol)
			bekleyen.erase(yol)
			biten += 1
		ilerledi.emit(biten, toplam)
		# Render/girdi ana iş parçacığında ilerlemeye devam eder.
		await agac.process_frame

func bosalt() -> void:
	kaynaklar.clear()
