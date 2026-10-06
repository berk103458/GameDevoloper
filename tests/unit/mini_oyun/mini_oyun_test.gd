## Köy mini oyunları: zamanlama kuralları ve olay ödülü (design/gdd/koy-mini-oyunlari.md). Düz betik:
##   godot --headless --path . -s tests/unit/mini_oyun/mini_oyun_test.gd   (çıkış 0 = geçti)
extends SceneTree

var _hata := 0


func _init() -> void:
	# Okçuluk: merkez 2, halka 1, dışı 0 (sınır değerleri bilerek).
	_esit("ok merkez", Zamanlama.ok_puani(Vector2(0.1, 0.0), 0.15, 0.4), 2)
	_esit("ok merkez sınırı", Zamanlama.ok_puani(Vector2(0.25, 0.0), 0.25, 0.5), 2)
	_esit("ok halka", Zamanlama.ok_puani(Vector2(0.0, 0.3), 0.15, 0.4), 1)
	_esit("ok dışı", Zamanlama.ok_puani(Vector2(0.5, 0.0), 0.15, 0.4), 0)
	_esit("nişangâh t=0", Zamanlama.nisangah(0.0, 0.5).x, 0.0)
	# Harman: en yakın vurulmamış vuruş; tolerans dışı −1; aynı vuruş iki kez sayılmaz.
	var v := Zamanlama.vuruslar(1.0, 0.75, 4)
	_esit("vuruş zamanları", Array(v), [1.0, 1.75, 2.5, 3.25])
	var vuruldu: Array[bool] = [false, false, false, false]
	_esit("isabet", Zamanlama.vurus_isabeti(1.8, v, vuruldu, 0.16), 1)
	vuruldu[1] = true
	_esit("vurulmuş sayılmaz", Zamanlama.vurus_isabeti(1.8, v, vuruldu, 0.16), -1)
	_esit("tolerans dışı", Zamanlama.vurus_isabeti(2.2, v, vuruldu, 0.16), -1)
	# Olay ödülü: puan başına ödül, eşiği geçince başarı etkisi.
	var k := Katalog.new()
	if k.yukle() != Katalog.Durum.HAZIR:
		print("katalog yüklenemedi: ", k.hatalar)
		quit(1)
		return
	var olay := OlayVerisi.new()
	olay.metin_anahtari = "olay.deneme.metin"
	olay.secenek_etkileri = [{"oyun": "harman", "oyun_odul": {"ambar": 1}, "oyun_esik": 3, "oyun_basari": {"bar": [1, 0, 0, 0]}}]
	var o := Oturum.new(k, 5)
	var tanik := o.yonetim.kabul({"ad": "tanık"})
	var ambar := o.ambar
	var moral := tanik.moral
	var s := o.olay_uygula(olay, 0, 2)
	_esit("ödül: puan başına ambar", o.ambar, ambar + 2)
	_esit("ödül: eşik altı başarı yok", tanik.moral, moral)
	_esit("ödül: puan raporda", s["oyun_puan"], 2)
	_esit("ödül: eşik altı sonucu", s["sonuc_anahtari"], "olay.deneme.sonuc1_az")
	o = Oturum.new(k, 5)
	tanik = o.yonetim.kabul({"ad": "tanık"})
	s = o.olay_uygula(olay, 0, 3)
	_esit("ödül: eşikte başarı (Halk → moral köprüsü)", tanik.moral, moral + Oturum.KOPRU_MORAL)
	_esit("ödül: eşikte sonucu", s["sonuc_anahtari"], "olay.deneme.sonuc1")
	# Katalogdaki mini oyunlu olaylar tanınan türleri anar.
	var turler := 0
	for ol: OlayVerisi in k.olaylar():
		for e: Dictionary in ol.secenek_etkileri:
			if e.has("oyun"):
				turler += 1
				_esit("tür %s" % ol.id, String(e["oyun"]) in ["okculuk", "harman"], true)
	_esit("mini oyunlu olay var", turler >= 2, true)
	print("MINI OYUN TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(1 if _hata > 0 else 0)


func _esit(ad: String, gercek: Variant, beklenen: Variant) -> void:
	if gercek != beklenen:
		_hata += 1
		print("  KALDI %s: %s != %s" % [ad, gercek, beklenen])
