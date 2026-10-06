extends SceneTree

var hata := 0

func _initialize() -> void:
	for n in range(1, 31):
		var k := load("res://data/chr_runtime/CHR_%03d.tres" % n) as KarakterVerisi
		_kontrol(k != null and k.dogrula(), "Derlenmiş CHR geçerli: %03d" % n)
		if n in [22, 24, 26, 28, 30]:
			_kontrol(k.baslangic_tansiyonu == 1, "Ahmet kararı: kaynak başlangıç 1 kalır")
	var kaynak := load("res://data/chr_runtime/CHR_001.tres") as KarakterVerisi
	var bozuk := kaynak.duplicate(true) as KarakterVerisi
	bozuk.entity_id = &""
	_kontrol(not bozuk.dogrula(), "Eksik kimlik reddedilir")
	bozuk = kaynak.duplicate(true)
	bozuk.baslangic_tansiyonu = 4
	_kontrol(not bozuk.dogrula(), "Başlangıç 4 reddedilir; runtime 0–10 ile karıştırılmaz")
	bozuk = kaynak.duplicate(true)
	bozuk.karar_matrisi["kabul"] = {"stat_etkisi": {"Moral": "4"}}
	_kontrol(not bozuk.dogrula(), "Bozuk karar stat tipi reddedilir")
	bozuk = kaynak.duplicate(true)
	bozuk.karar_matrisi["kabul"]["varyantlar"] = [{"stat_etkisi": {"Moral": "4"}}]
	_kontrol(not bozuk.dogrula(), "Bozuk koşullu karar statı da reddedilir")
	var yol := "res://data/chr_runtime/CHR_001.tres"
	bozuk.take_over_path(yol)
	var gelen := Gelen.new()
	gelen.id = &"chr_001"
	gelen.adli = true
	_kontrol(gelen.chr_sorgusu() == null, "Yükleme adaptörü geçersiz CHR profiliyle sorgu başlatmaz")
	kaynak.take_over_path(yol)
	_kontrol(kaynak.dogrula() and kaynak.karar_matrisi["kabul"]["stat_etkisi"] is Dictionary, "Doğrulama kaynak profili değiştirmez")
	print("CHR DOĞRULAMA: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
