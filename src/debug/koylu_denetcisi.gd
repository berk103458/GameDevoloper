class_name KoyluDenetcisi
extends RefCounted

static func satirlar(o: Oturum, hareket: KoyHalkHareketi = null) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	if o == null: return sonuc
	var y := o.yonetim
	for k in y.koylular:
		var r := {"id": k.id, "ad": k.ad, "stat": k.stat, "zanaat_turu": k.zanaat_turu, "bina": "Muhafız" if k.is_yeri == KoyYonetimi.MUHAFIZ else "Boşta",
			"eylem": hareket.eylem(k.id) if is_instance_valid(hareket) else "Sahne yok", "carpan": 0.0, "uretim": {}, "bonus": {}, "engel": "Üretim işi yok", "pasif_ozellikler": k.pasif_ozellikler.duplicate(true)}
		var b := y.bina(k.is_yeri)
		r["egitim"] = CirakEgitimi.metin(k)
		r["is_kazasi"] = IsKazalari.metin(k) + "\n" + ZanaatKazalari.metin(k) + "\n" + NobetYorgunlugu.metin(k, y)
		r["kaza_riski"] = IsKazalari.risk(k, y)
		r["memnuniyet"] = IsMemnuniyeti.metin(k, y) + "\n" + MeslekGrevi.metin(k, y)
		r["toplumsal_bag"] = KanDavasi.metin(k, y)
		r["yas_rolu"] = YasRolleri.metin(k, y)
		r["gizli_egilim"] = GizliEgilimler.debug_metin(k)
		if b != null:
			r["meslek_carpani"] = MeslekUyumu.carpan(k, b.tur)
			r["alet_riski"] = MeslekUyumu.alet_riski(k, b.tur)
			r["bina"] = "#%d %s (S%d)" % [b.id, b.tur, b.seviye]
			var veri := y.katalog.veri(b.tur)
			var recete: Dictionary = y.katalog.receteler(b.tur).get(b.recete, {})
			var c := Uretim.koylu_carpani(k, String(veri.get("uzmanlik", "")), y.a, b.tur) * YasRolleri.carpan(y, b) * DemirZinciri.carpan(y, b.tur)
			r["carpan"] = Uretim.gunluk(1.0, k.stat, c) * b.uretim_carpani()
			r["engel"] = "Brüt potansiyel"
			if not b.hazir(): r["engel"] = "İnşaat"
			elif y.isyan_kalan >= 0: r["engel"] = "İsyan"
			elif KanDavasi.engel(y, b.id): r["engel"] = "Kan davası / üretim durmuş"
			elif y.kis_mi() and bool(veri.get("kis_durur", false)): r["engel"] = "Kış / soğuk"
			elif recete.is_empty(): r["engel"] = "Reçete yok"
			elif not y.kaynaklar.yeterli(recete.get("girdi", {})): r["engel"] = "Girdi eksik"
			elif y.kaynaklar.toplam() >= y.kaynaklar.kapasite: r["engel"] = "Ambar dolu"
			elif MeslekGrevi.aktif(k, y): r["engel"] = "Meslek grevi / üretim durmuş"
			elif ZanaatKazalari.durur(k): r["engel"] = "Zanaat kazası / üretim durmuş"
			elif IsMemnuniyeti.isyanci(k, y): r["engel"] = "Kişisel isyan / iş reddi"
			if not YasRolleri.fiziksel(k, b.tur):
				r["carpan"] = 0.0
				r["alet_riski"] = 0.0
				r["engel"] = "Danışman / kendi üretimi yok" if YasRolleri.danisman(k, b.tur) else "Yaş grubu / ağır iş yasak"
			for tur in recete.get("uretim", {}):
				var miktar := float(recete["uretim"][tur]) * float(r["carpan"])
				r["uretim"][tur] = miktar
				if k.moral > y.a.kritik_moral: r["bonus"][tur] = roundi(miktar * y.a.kritik_bonus)
		sonuc.append(r)
	return sonuc
