## OGR-24: Pazar ve divan dugmeleri acilinca isaretlenir.
## Pazar (TUC) ve divan (CAS-07) HUD dugmeleri ilk kez etkin olunca kenarinda bir kez yanip sonen isaret
## ve tek satir ipucu verir; girince/tiklaninca kalkar, iki kez tiklanmis dugmede isaret 0 olur.
class_name YeniDugmeIsareti
extends Control

const VURGU_RENGI := Kabuk.BAR_DOLU

var _isaretli: Dictionary = {}
var _gorulen: Dictionary = {}
var _tiklama_sayisi: Dictionary = {}


func dugme_etkinlesti(dugme_id: String, kayit: IpucuKaydi = null) -> Dictionary:
	var temiz := dugme_id.strip_edges().to_lower()
	if temiz.is_empty():
		return {"isaret": 0, "metin": ""}
	var ipucu_anahtari := "yeni_dugme_" + temiz
	if _gorulen.has(temiz) or (kayit != null and kayit.goruldu_mu(ipucu_anahtari)):
		return {"isaret": 0, "metin": ""}
	_gorulen[temiz] = true
	_isaretli[temiz] = true
	if kayit != null:
		kayit.ipucu_ekle(ipucu_anahtari)
	var metin := "Pazar açıldı; tüccarla alışveriş yapabilirsin." if temiz == "pazar" else (
		"Divan açıldı; şüphelileri burada yargılayabilirsin." if temiz == "divan" else ("%s açıldı." % temiz)
	)
	queue_redraw()
	return {
		"isaret": 1,
		"metin": metin,
		"dugme_id": temiz,
	}


func dugmeye_girildi(dugme_id: String) -> void:
	var temiz := dugme_id.strip_edges().to_lower()
	if temiz.is_empty():
		return
	_tiklama_sayisi[temiz] = int(_tiklama_sayisi.get(temiz, 0)) + 1
	if _isaretli.has(temiz):
		_isaretli.erase(temiz)
		queue_redraw()


func isaret_sayisi(dugme_id: String) -> int:
	var temiz := dugme_id.strip_edges().to_lower()
	return 1 if bool(_isaretli.get(temiz, false)) else 0


func tiklama_sayisi(dugme_id: String) -> int:
	var temiz := dugme_id.strip_edges().to_lower()
	return int(_tiklama_sayisi.get(temiz, 0))


func _draw() -> void:
	if _isaretli.is_empty():
		return
	var renk := VURGU_RENGI
	renk.a = 0.92
	draw_rect(Rect2(Vector2.ZERO, size), renk, false, 2.0)
