## OMR-35: aynı tohum ve kararlar, kesintisiz ve kayıttan devam eden tempo günlüğü.
extends Node

const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const KAPI = preload("res://src/sistemler/kapi_acilis_olayi.gd")
const DIS_HAT = preload("res://src/sistemler/dis_hat_kapisi.gd")


func _ready() -> void:
	var katalog := Katalog.new()
	katalog.yukle()
	var ilk := _kos(katalog, false)
	var ikiz := _kos(katalog, true)
	var beklenen := ["kurulus", "yerlesme", "oturma", "dalga_1", "dalga_2", "dalga_3"]
	var gorulen := ilk.map(func(satir: Dictionary) -> String: return satir.evre)
	var tamam := gorulen == beklenen and ilk == ikiz
	print("OMURGA TEMPO İKİZİ: %s" % ("GEÇTİ" if tamam else "KALDI"))
	print("Kesintisiz: ", JSON.stringify(ilk))
	print("Yüklemeli: ", JSON.stringify(ikiz))
	get_tree().quit(0 if tamam else 1)


func _kos(katalog: Katalog, yuklemeli: bool) -> Array[Dictionary]:
	var o := Oturum.new(katalog, 3535)
	ACILIS.kur(o)
	# Tempo testinde açlık ve evsizlik dönem geçişini maskelemesin.
	o.yonetim.binalar[0].seviye = 40
	o.yonetim.akce = 100
	var ambar := KoyBinasi.new()
	ambar.tur = "ambar"
	ambar.hucre = Vector2i(0, 4)
	ambar.id = o.yonetim._sonraki_id
	ambar.seviye = 25
	o.yonetim._sonraki_id += 1
	o.yonetim.binalar.append(ambar)
	o.yonetim.izgara.yerlestir(ambar.id, ambar.hucreler(o.yonetim.katalog))
	o.yonetim._ambar_kapasitesi()
	o.yonetim.kaynaklar.ekle("bugday", 60)
	KAPI.baslat(o)
	KAPI.ulak_bitir(o)
	var once := ""
	var gunluk: Array[Dictionary] = []
	for _adim in range(40):
		var y := o.yonetim
		var evre := "dalga_%d" % DIS_HAT.dalga(y) if y.agalik else String(Omurga.donem(y))
		if evre != once:
			gunluk.append({"gece": o.gun, "evre": evre})
			once = evre
		if evre == "dalga_3": return gunluk
		var bir_kisi_alindi := false
		for gelen in o.gece_kuyrugu():
			if not y.agalik and not bir_kisi_alindi and not gelen.tehlikeli and gelen.secenekler.has("kabul"):
				o.ziyaret_basladi(gelen)
				bir_kisi_alindi = o.karar_ver(gelen, &"kabul").get("kaldi", false)
		y.kaynaklar.ekle("gida", 150)
		y.kaynaklar.ekle("su", 150)
		if y.huzur() < 70: y.as_dagit()
		TekfurHaracHeyeti.ode(y)
		var sonuc := o.gece_sonu()
		if not String(sonuc.get("son", "")).is_empty() or sonuc.get("engellendi", false):
			print("Tempo koşusu erken bitti: gece %d, nüfus %d, son %s, engellendi %s" % [o.gun, y.nufus(), sonuc.get("son", ""), sonuc.get("engellendi", false)])
			break
		if yuklemeli and (o.gun == 4 or sonuc.perde_degisti):
			var anlik: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
			o = Oturum.kayittan(katalog, anlik)
			if o == null: break
	return gunluk
