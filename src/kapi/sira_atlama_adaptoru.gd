## BUG-02/KAP-15: gecenin listesi ve görünen model sırası aynı kişiyle ilerler.
extends RefCounted

static func uygula(ekran: KapiEkrani, anahtar: String, etki: Dictionary) -> bool:
	if anahtar != "atlama" or etki.get("geri", false):
		return false
	var sahne := ekran.sahne
	var indeks := sahne._kuyruktakiler.size() - 1
	if indeks < 1 or indeks >= ekran._kuyruk.size() or sahne._kuyruk_adlari.size() != indeks + 1:
		return false
	var gelen: Gelen = ekran._kuyruk[indeks]
	var model: KarakterModel = sahne._kuyruktakiler[indeks]
	var ad: String = sahne._kuyruk_adlari[indeks]
	# Kimliği olan nesneler erase ile taşınır; tekrar eden model adı indeksle çıkarılır.
	ekran._kuyruk.erase(gelen)
	ekran._kuyruk.push_front(gelen)
	sahne._kuyruktakiler.erase(model)
	sahne._kuyruktakiler.push_front(model)
	sahne._kuyruk_adlari.remove_at(indeks)
	sahne._kuyruk_adlari.push_front(ad)
	# Bu olayın rüşveti de kişisel keseye gider; olay motoru önce kamu kasasına yazmıştır.
	var gelir := maxi(0, int(etki.get("akce", 0)))
	ekran.oturum.koy_akce -= gelir
	ekran.oturum.muhafiz_akce += gelir
	for i in sahne._kuyruktakiler.size():
		sahne._kuyruk_yerleri[i] = KapiSahnesi.kuyruk_yeri(i)
		if i > 0:
			sahne._yerine_yuru(sahne._kuyruktakiler[i], i * KapiSahnesi.ILERLEME_GECIKMESI)
	await model.yuru(KapiSahnesi.DURMA, KapiSahnesi.YAKLASMA_HIZI)
	return true
