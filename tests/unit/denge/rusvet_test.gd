extends SceneTree

func _initialize() -> void:
	var kat := Katalog.new()
	if kat.yukle() != Katalog.Durum.HAZIR:
		push_error("Katalog yüklenemedi")
		quit(1)
		return
	var o := Oturum.new(kat, 4343)
	var bina := KoyBinasi.new()
	bina.id = 90
	bina.tur = "bez_evi"
	o.yonetim.binalar.append(bina)
	var esnaf := o.yonetim.kabul({"ad": "Çalışan esnaf", "sinif": "esnaf"})
	esnaf.is_yeri = bina.id
	var harac_once := JSON.stringify(o.kaydet())
	for tekrar in 20:
		var harac := MuhafizYetenekleri.harac(o)
		if int(harac.akce) != 0 or int(harac.kisi) != 0:
			push_error("DEN-46: yetenek kapalıyken haraç sıfır olmalı")
			quit(1)
			return
	if JSON.stringify(o.kaydet()) != harac_once:
		push_error("DEN-46: kapalı haraç kasa, moral veya gece makbuzu yazmamalı")
		quit(1)
		return
	var once := MuhafizTerazisi.durum(o)
	var g := Gelen.new()
	g.id = &"den43_rusvet"
	o.karar_ver(g, &"rusvet")
	var sonra := MuhafizTerazisi.durum(o)
	var agirlik := float(MuhafizTerazisi.AYAR.rusvet_agirlik)
	if int(sonra.rusvet) != int(once.rusvet) + 1 or int(sonra.yozlasma) != int(once.yozlasma) + int(agirlik):
		push_error("DEN-43: tek rüşvet mevcut skoru tek kez artırmalı")
		quit(1)
		return
	var kayit := JSON.stringify(o.kaydet())
	for tekrar in 20:
		MuhafizTerazisi.durum(o)
		DengeOlcumu.olustur(o, {})
	if JSON.stringify(o.kaydet()) != kayit:
		push_error("DEN-43: skor gözlemi ikinci kez yazmamalı")
		quit(1)
		return
	print("RÜŞVET ÖLÇÜMÜ: GEÇTİ")
	quit()
