extends SceneTree
var hata := 0
func _initialize() -> void:
	var k := load("res://data/chr_runtime/CHR_001.tres") as KarakterVerisi
	var kaynak := k.sorgu_bayraklari.duplicate(true)
	var s := ChrSorgusu.new(k)
	var diger := ChrSorgusu.new(k)
	_kontrol(BayrakDenetcisi.degistir(s, "Flag_Kimlik_Cozuldu", true)["ok"] and s.bayraklar["Flag_Kimlik_Cozuldu"], "Tanımlı flag açılır")
	_kontrol(not diger.bayraklar["Flag_Kimlik_Cozuldu"] and k.sorgu_bayraklari == kaynak, "Kaynak ve diğer ziyaret etkilenmez")
	_kontrol(BayrakDenetcisi.degistir(s, "Flag_Kimlik_Cozuldu", false)["ok"] and not s.bayraklar["Flag_Kimlik_Cozuldu"], "Normal flag kapatılır")
	var once := s.bayraklar.duplicate()
	_kontrol(not BayrakDenetcisi.degistir(s, "Flag_Uydurma", true)["ok"] and not BayrakDenetcisi.degistir(s, "Clue_X", true)["ok"] and s.bayraklar == once, "Yabancı flag ve Clue düzenlemesi reddedilir")
	s.bayraklar["Flag_Kilitlendi"] = true
	_kontrol(not BayrakDenetcisi.degistir(s, "Flag_Kilitlendi", false)["ok"] and not s.karar_acik(&"kabul"), "KAP-08 kalıcı panik kilidi korunur")
	print("BAYRAK DENETÇİSİ: GEÇTİ" if hata == 0 else "BAYRAK DENETÇİSİ: KALDI")
	quit(hata)
func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		hata += 1
		push_error(metin)
