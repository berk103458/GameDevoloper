extends SceneTree

var hata := 0

func _initialize() -> void:
	var bos := ChrSorgusu.new(null)
	_kontrol(bos.karakter != null and bos.tansiyon == 2 and bos.bayraklar.size() == 4, "Null kaynak güvenli boş profil")
	_kontrol(not bos.secenek_sec(0) and not bos.replik_baslat() and bos.obje_incele(1).is_empty(), "Boş profil eylemleri güvenle sonuçlanır")
	var k := KarakterVerisi.new()
	k.sorgu_bayraklari = {"Flag_Kilitlendi": "yanlis"}
	k.karar_matrisi = {"rusvet": "bozuk", "kabul": {"varyantlar": 3, "muhafiz_akce": "3", "esyalar": 55}}
	k.diyalog_dugumleri = {"00": {"secenekler": "bozuk", "gecisler": [null, {"hedef": {}}], "bayraklar": [null, 33]}, "1": 44,
		"2": {"secenekler": [null, {"metin_anahtari": 4, "hedef": {}, "tansiyon_delta": "3", "gerekli_ipuclari": 55}]}}
	k.obje_1 = {"uretilen_ipucu": 123, "aciklama": {}}
	k.animasyon_anahtarlari = {"Idle": 123}
	k.metinler = {"kotu": {}}
	var s := ChrSorgusu.new(k)
	_kontrol(s.bayraklar.size() == 4 and not s.bayraklar["Flag_Kilitlendi"], "Eksik/bozuk bayraklar güvenli bool")
	_kontrol(k.karar_verisi(&"rusvet").get("stat_etkisi", {}).is_empty() and k.karar_verisi(&"kabul")["varyantlar"].is_empty(), "Bozuk karar ve varyant alanları güvenle okunur")
	_kontrol(k.diyalog_dugumu(&"1")["secenekler"].is_empty() and not s.secenek_sec(0), "Bozuk düğüm/seçenek dizisi boş okunur")
	_kontrol(not s.devam_et() and k.karar_verisi(&"kabul")["muhafiz_akce"] == 0 and k.karar_verisi(&"kabul")["esyalar"].is_empty(), "Bozuk geçiş/karar alanı eylem üretmez")
	var secenek: Dictionary = k.diyalog_dugumu(&"2")["secenekler"][0]
	_kontrol(secenek["tansiyon_delta"] == 0 and secenek["gerekli_ipuclari"].is_empty(), "Bozuk seçenek alanları varsayılanı alır")
	_kontrol(s.obje_incele(1).is_empty() and s.ipuclari.is_empty() and s.metin(&"kotu") == "kotu", "Bozuk metin/nesne ipucu üretmez")
	_kontrol(k.tansiyon_animasyonu(2) == &"Idle" and k.diyalog_dugumleri["2"]["secenekler"][1]["tansiyon_delta"] == "3", "Animasyon fallback kaynak verisini değiştirmez")
	print("CHR FALLBACK: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
