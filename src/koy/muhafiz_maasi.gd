## EKO-07: kamu maaşı, kayıtlı borç ve maaş ödenmezse nöbet hattı bozulması.
class_name MuhafizMaasi
extends RefCounted
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/muhafiz_maasi.json"))
## CHR kışla hedefini gerçek kurulabilir savunma türüyle genişletir.
static func ekle(turler: Dictionary) -> void:
	turler["muhafiz_kislasi"] = AYAR.kisla.duplicate(true)
## Eski muhafız görevi ve hazır kışla çalışanı aynı nöbetçi sözleşmesini kullanır.
static func aday(k: Koylu, y: KoyYonetimi) -> bool:
	return IsKazalari.nobet(k, y)
## Ödenmemiş borç, yeniden atanmış olsa da etkin savunmayı engeller.
static func borclu(k: Koylu, y: KoyYonetimi) -> bool:
	return int(y.maas_durumu.get(str(k.id), {}).get("borc", 0)) > 0
## Gece bordrosu: cari ücret ve eski borç birlikte kamu kasasından; kişisel kasaya dokunmaz.
static func ode(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	var adaylar: Array[Koylu] = []
	var bedel := 0
	for k in y.koylular:
		if not aday(k, y): continue
		var d: Dictionary = y.maas_durumu.get(str(k.id), {})
		if int(d.get("son_gece", -1)) == y.gun: continue
		adaylar.append(k)
		bedel += y.a.muhafiz_maas + int(d.get("borc", 0))
	if adaylar.is_empty(): return
	var odendi := y.akce >= bedel
	if odendi: y.akce -= bedel
	for k in adaylar:
		var d: Dictionary = y.maas_durumu.get(str(k.id), {"borc": 0, "rusvet_akce": 0, "son_gece": 0}).duplicate()
		d.son_gece = y.gun
		if odendi:
			d.borc = 0
		else:
			d.borc = mini(1000000000, int(d.borc) + y.a.muhafiz_maas)
			k.moral = maxi(0, k.moral - int(AYAR.moral_kaybi))
			y.asayis_riski = mini(100, y.asayis_riski + int(AYAR.asayis_kaybi))
			# Ödenmeyen nöbet hattında rüşvet karşılığı usulsüz geçiş; kamu/oyuncu kasası değil.
			if y._rng.randf() < float(AYAR.rusvet_riski):
				d.rusvet_akce = mini(1000000000, int(d.rusvet_akce) + int(AYAR.rusvet_akce))
				y.asayis_riski = mini(100, y.asayis_riski + int(AYAR.rusvet_asayis))
				olaylar.append({"anahtar": "Ödenmeyen nöbet hattında rüşvet karşılığı usulsüz geçiş şüphesi; asayiş bozuldu.", "deger": []})
			k.is_yeri = KoyYonetimi.BOSTA
		y.maas_durumu[str(k.id)] = d
	if not odendi: olaylar.append({"anahtar": "koy.olay.maas_yok"})
## Optional JSON bordro alanı; geçersiz kayıtlar ayrı ayrı reddedilir.
static func oku(v: Variant) -> Dictionary:
	var r := {}
	if not v is Dictionary: return r
	for id in v:
		if not String(id).is_valid_int() or int(String(id)) <= 0 or not v[id] is Dictionary: continue
		var d: Dictionary = v[id]
		var gecerli := true
		for alan in ["borc", "rusvet_akce", "son_gece"]:
			var n: Variant = d.get(alan)
			if (not n is int and not n is float) or not is_finite(float(n)) or floor(float(n)) != float(n) or float(n) < 0 or float(n) > 1000000000: gecerli = false
		if gecerli: r[String(id)] = {"borc": int(d.borc), "rusvet_akce": int(d.rusvet_akce), "son_gece": int(d.son_gece)}
	return r
## Oyuncuya açık bordro bilgisi; gizli rüşvet miktarı gösterilmez.
static func metin(y: KoyYonetimi) -> String:
	var borc := 0
	for k in y.koylular: borc += int(y.maas_durumu.get(str(k.id), {}).get("borc", 0))
	return "Gece maaşı: %d · borç: %d akçe\nBorçlu nöbetçi savunmaya katılmaz.\nYeniden atayıp maaş ve borcu ödeyin." % [y.muhafiz_sayisi() * y.a.muhafiz_maas, borc]
