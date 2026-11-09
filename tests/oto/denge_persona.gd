## DEN-54: köy odaklı olağan oyuncu, 5454 tohumu, 28 gerçek gece.
## Yatak doluyken kapıyı açmaz; mevcut API'lerle üretir, ticaret ve aş dağıtımı yapar.
## Terminalde durur. Kaynak ve nüfus normal oyuncu işlemleriyle değişir.
extends Node
const OYUNCU = preload("res://tests/oto/acilis_denge_kontrol.gd")

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	call_deferred("_calistir")

func _calistir() -> void:
	var kat := Katalog.new()
	if kat.yukle() != Katalog.Durum.HAZIR:
		get_tree().quit(1)
		return
	var sonuc := await kos(kat, 5454, true)
	var tablo: Dictionary = preload("res://src/sistemler/denge_tablosu.gd").oku()
	var aralik: Dictionary = tablo.get("iflas_aralik", {})
	if not sonuc.gecerli or not aralik.has_all(["alt", "ust"]) or not int(sonuc.iflas) in range(int(aralik.alt), int(aralik.ust) + 1):
		push_error("DEN-54: olağan persona veya iflas aralığı geçersiz: %s" % sonuc)
		await Ses.cik(1)
		return
	print("DENGE PERSONA: GEÇTİ")
	await Ses.cik()


## DEN-54 ve DEN-59 aynı normal gece hesabı ve oyuncu planını kullanır.
func kos(kat: Katalog, tohum: int, ayrinti: bool = false) -> Dictionary:
	var o := Oturum.new(kat, tohum)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(o, "olagan")
	# Persona, ölçtüğü üretim planının bilgilerini taşıyan başlangıç hanesini temsil eder.
	# Yapı kilidi, kademe, gerçek maliyet ve inşaat süresi yine üretim API'sinden geçer.
	if o.yonetim.koylular.is_empty(): return {"gecerli": false}
	preload("res://src/koy/yapi_bilgisi.gd").ekle(o.yonetim.koylular[0], PackedStringArray(["hizarhane", "degirmen", "firin"]))
	var oyuncu := OYUNCU.new()
	var y := o.yonetim
	var krizler := {"salgin": 0, "kitlik": 0, "isyan": 0, "kundak": 0, "zehir": 0}
	var salgin_once := false
	var indeks: Array[int] = [0]
	var iflas := 0
	var baslangic_gunu := y.gun
	var plan := {"plan": ["tarla", "odunluk", "hizarhane", "cadir", "kazi", "degirmen", "firin"]}
	for gece in 28:
		if not y.son.is_empty():
			break
		if y.nufus() < y.yatak_kapasitesi() and y.huzur() >= 40:
			oyuncu._gate(o, true, &"esnaf")
		var ilerledi := true
		while ilerledi and indeks[0] < plan.plan.size():
			ilerledi = oyuncu._adim(y, plan.plan[indeks[0]], indeks)
		for kisi in y.koylular:
			y.bosalt(kisi.id)
		var isler := ["tarla", "tarla", "degirmen", "degirmen", "firin", "firin", "odunluk", "hizarhane"]
		for tur in isler:
			if tur == "odunluk" and y.kaynaklar.miktar("tomruk") >= 6:
				continue
			if tur == "hizarhane" and y.kaynaklar.miktar("tomruk") < 2:
				continue
			var adaylar := y.bostakiler()
			adaylar.sort_custom(func(a: Koylu, b: Koylu) -> bool: return MeslekUyumu.carpan(a, tur) > MeslekUyumu.carpan(b, tur))
			for kisi in adaylar:
				if oyuncu._dene(y, kisi, tur):
					break
		for kisi in y.bostakiler():
			if y.kaynaklar.miktar("tas") < 6 and oyuncu._yatak_ata(y):
				continue
			if y.kaynaklar.miktar("odun") < 8 and GeciciIsler.neden(y, kisi, "dal_toplama").is_empty():
				GeciciIsler.ata(y, kisi.id, "dal_toplama")
			else:
				oyuncu._dene(y, kisi, "tarla")
		if y.kervan_gunu():
			if y.kaynaklar.miktar("gida") < y.nufus() * 4:
				y.kervandan_al("gida", y.nufus() * 2)
			if y.kaynaklar.miktar("odun") < y.nufus() * 7:
				y.kervandan_al("odun", y.nufus() * 2)
		if y.harac_bekliyor:
			y.harac_ode()
		if y.isyan_kalan >= 0 or y.huzur() < 40:
			y.as_dagit()
		var gece_gunu := y.gun
		var salgin_baslangic := _salgin(y)
		var rapor := o.gece_sonu()
		if y.gun != gece_gunu + 1: break
		var olaylar: Array = rapor.get("olaylar", [])
		var kitlik := olaylar.any(func(olay: Dictionary) -> bool: return olay.has("kitlik_isyani"))
		if kitlik: krizler.kitlik += 1
		for olay in olaylar:
			match olay.get("anahtar", ""):
				"koy.olay.iflas": iflas += 1
				"koy.olay.isyan_basladi":
					if not kitlik: krizler.isyan += 1
		var salgin_son := _salgin(y)
		if not salgin_once and (salgin_baslangic or salgin_son): krizler.salgin += 1
		salgin_once = salgin_son
		krizler.kundak += _uygulanan(AmbarKundaklamasi.durum(y), gece_gunu)
		krizler.zehir += _uygulanan(KuyuZehirleme.durum(y), gece_gunu)
		if ayrinti:
			print("DEN-54: gün=%d kişi=%d akçe=%d erzak=%d son=%s iflas=%d huzur=%d" % [y.gun, y.nufus(), y.akce, y.kaynaklar.miktar("gida"), y.son, iflas, y.huzur()])
			await get_tree().process_frame
	if ayrinti:
		print("DEN-54: plan=%d/%d yapılar=%s" % [indeks[0], plan.plan.size(), y.binalar.map(func(b: KoyBinasi) -> String: return b.tur + "/" + b.recete)])
	oyuncu.free()
	var geceler := y.gun - baslangic_gunu
	return {"tohum": tohum, "gece": geceler, "son": y.son, "plan": indeks[0], "iflas": iflas,
		"krizler": krizler, "plan_bitti": indeks[0] == plan.plan.size(),
		"gecerli": geceler == 28 and y.son.is_empty() and indeks[0] == plan.plan.size()}


func _salgin(y: KoyYonetimi) -> bool:
	return "salgin" in preload("res://src/koy/kriz_kenetlenmesi.gd").krizler(y)


func _uygulanan(durum: Dictionary, gun: int) -> int:
	var adet := 0
	for kisi in durum.kisiler.values():
		if int(kisi.get("uygulandi", -1)) == gun: adet += 1
	return adet
