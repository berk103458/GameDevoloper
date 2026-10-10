## KRI-13: Şifahane yatak kapasitesi + triyaj. Yatak = mevcut KRI-02 karantina kontenjanı,
## tedavi = mevcut SaglikYoneticisi.tedavi; ikinci yatak/tedavi sistemi yoktur. RNG yok.
extends RefCounted

static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/sifahane_triyaj.json"))

## Triyaj sırası: en düşük sağlık önce, eşitlikte kimlik; mevcut tedavi bu sırayla kontenjanı harcar.
static func sira(y: KoyYonetimi) -> Array[Koylu]:
	var r: Array[Koylu] = y.koylular.duplicate()
	r.sort_custom(func(a: Koylu, b: Koylu) -> bool: return a.saglik < b.saglik if a.saglik != b.saglik else a.id < b.id)
	return r

## Toplam işleyen yatak (hekimli Şifahane karantina kontenjanı).
static func yatak(y: KoyYonetimi) -> int:
	var n := 0
	for b in y.binalar: n += KarantinaYoneticisi.kapasite(y, b)
	return n

## Belirtisi açık, tedavi edilmemiş, yatakta (karantinada) olmayan köydeki hasta.
static func bakimsiz(y: KoyYonetimi) -> Array[Koylu]:
	var r: Array[Koylu] = []
	for k in y.koylular:
		if SaglikYoneticisi.hasta(k) and "hasta" in k.bayraklar and k.saglik > 0 and not KarantinaYoneticisi.aktif(k) and SaglikYoneticisi.temas_edebilir(y, k): r.append(k)
	return r

## Tedaviden sonra: işleyen Şifahane varken yataklar dolu ve açıkta bekleyen hasta kaldıysa
## bekleyenler ek sağlık, bütün köy moral kaybeder. Ölüm denetimi mevcut sağlık döngüsündedir.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	if y.son != &"": return
	var toplam := yatak(y)
	if toplam <= 0 or KarantinaYoneticisi.bos(y) > 0: return
	var bekleyen := bakimsiz(y)
	if bekleyen.is_empty(): return
	var adlar: Array[String] = []
	for k in bekleyen:
		k.saglik = maxi(0, k.saglik - int(AYAR.bakimsiz_saglik_kaybi))
		adlar.append(TranslationServer.translate(k.ad))
	for k in y.koylular:
		if not KervanKorumasi.disarida(y, k.id): k.moral = maxi(0, k.moral - int(AYAR.koy_moral_kaybi))
	olaylar.append({"anahtar": "sifahane_triyaj", "sifahane_triyaj": {"yatak": toplam, "adlar": adlar, "saglik": int(AYAR.bakimsiz_saglik_kaybi), "moral": int(AYAR.koy_moral_kaybi)}})

## Gece raporu satırı.
static func olay_metin(e: Dictionary) -> String:
	var d: Dictionary = e.sifahane_triyaj
	return "Şifahane dolu · %d yatağın hepsi dolu; açıkta bekleyen hastalar (%s) ek %d sağlık kaybetti, köyün morali −%d. Triyaj en ağır hastayı önce tedavi eder; yeni Şifahane, hekim veya bina seviyesi yatak açar." % [d.yatak, ", ".join(d.adlar), d.saglik, d.moral]
