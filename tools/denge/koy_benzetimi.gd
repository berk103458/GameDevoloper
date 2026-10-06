## Köy yönetimi benzetimi: basit bir oyuncu stratejisiyle 56 gün oynar, gün gün gıda/odun/akçe/huzur izini basar.
## Gözlem verir, hüküm vermez. Çalıştırma:
##   godot --headless --path . -s tools/denge/koy_benzetimi.gd     (ortam: TOHUMLAR="1,2,3", GUN=56, GELEN=2)
extends SceneTree


func _init() -> void:
	var a: KoyAyarlari = load("res://data/ayarlar/koy.tres")
	var k := BinaKatalogu.new()
	var tohumlar := (OS.get_environment("TOHUMLAR") if OS.get_environment("TOHUMLAR") != "" else "1,2,3").split(",")
	var gun_say := int(OS.get_environment("GUN")) if OS.get_environment("GUN") != "" else 56
	var gelen := int(OS.get_environment("GELEN")) if OS.get_environment("GELEN") != "" else 2
	for t in tohumlar:
		_oyna(a, k, int(t), gun_say, gelen)
	quit(0)


func _oyna(a: KoyAyarlari, kat: BinaKatalogu, tohum: int, gun_say: int, gelen: int) -> void:
	var y := KoyYonetimi.new(a, kat, tohum)
	var rng := RandomNumberGenerator.new()
	rng.seed = tohum
	var iz: PackedStringArray = []
	for g in gun_say:
		# Kapı: günde `gelen` kişi; %20'si reddedilir.
		for i in gelen:
			if rng.randf() < 0.2:
				y.ret("r", rng.randf() < 0.5)
				continue
			var s: StringName = [&"ciftci", &"ciftci", &"esnaf", &"asker"][rng.randi_range(0, 3)]
			y.kabul({"ad": "k", "sinif": s, "stat": rng.randi_range(3, 8)})
		_insa_et(y, kat, a)
		_ata(y, kat)
		# Fazla odun ve taşı tezgâhta sat.
		if y.kaynaklar.miktar("odun") > 40:
			y.tezgah_sat("odun", y.kaynaklar.miktar("odun") - 40)
		# Kervan günü: kış yaklaşırken ya da kışta akçeyle tahıl al.
		if y.kervan_gunu() and (y.gun % 28) >= 14:
			var gerek := y.nufus() * 9 - y.kaynaklar.miktar("gida")
			var alinabilir := mini(gerek, mini(y.kaynaklar.bos_yer(), int((y.akce - a.rezerv) / 0.5)))
			if alinabilir > 0:
				y.kervandan_al("gida", alinabilir)
		if y.isyan_kalan >= 0:
			y.as_dagit()
		if y.harac_bekliyor and not y.harac_ode():
			y.harac_reddet()
		if y.akce > a.rezerv + 3 and y.sur_seviye < 2:
			y.sur_taksit_ode()
		var r := y.gece()
		if g % 4 == 3 or r["son"] != "":
			iz.append("%d:n%d g%d o%d a%d h%d" % [g, y.nufus(), y.kaynaklar.miktar("gida"), y.kaynaklar.miktar("odun"), y.akce, y.huzur()])
		if r["son"] != "":
			break
	var say := {}
	for b in y.binalar:
		say[b.tur] = int(say.get(b.tur, 0)) + 1
	print("  yapılar ", say, " boşta ", y.bostakiler().size(), " yatak ", y.yatak_kapasitesi())
	print("tohum %d son=%s gün=%d nüfus=%d yapı=%d sur=%d husumet=%d | %s" % [tohum, y.son if y.son != "" else "-", y.gun, y.nufus(), y.binalar.size(), y.sur_seviye, y.husumet.puan, " ".join(iz)])


func _yer(y: KoyYonetimi, tur: String) -> Vector2i:
	for yy in y.izgara.boyut.y:
		for xx in y.izgara.boyut.x:
			if y.yerlesim(tur, Vector2i(xx, yy))["olur"]:
				return Vector2i(xx, yy)
	return Vector2i(-1, -1)


func _insa_et(y: KoyYonetimi, kat: BinaKatalogu, a: KoyAyarlari) -> void:
	var istek: Array[String] = []
	if y.yatak_kapasitesi() < y.nufus():
		istek.append("kulube" if y.kaynaklar.miktar("kereste") >= 4 else "cadir")
	var say := {}
	for b in y.binalar:
		say[b.tur] = int(say.get(b.tur, 0)) + 1
	if int(say.get("tarla", 0)) * 3 < y.nufus() * 6 / 10 + 1:
		istek.append("tarla")
	if int(say.get("hizarhane", 0)) < 1 + y.nufus() / 10:
		istek.append("hizarhane")
	if int(say.get("avci", 0)) < 1 + y.nufus() / 12:
		istek.append("avci")
	if int(say.get("tas_ocagi", 0)) < 1 and y.nufus() > 6:
		istek.append("tas_ocagi")
	if y.kaynaklar.toplam() > y.kaynaklar.kapasite * 8 / 10:
		istek.append("ambar")
	for t in istek:
		var h := _yer(y, t)
		if h.x >= 0:
			y.bina_kur(t, h)
		else:
			# Yer yoksa patikayı meydandan dışa doğru birkaç hücre uzat (çapraz yol ağı).
			var m := y.izgara.meydan
			var orta := m.position + m.size / 2
			var eklenen := 0
			for r in range(1, 12):
				for d in [Vector2i(r, 0), Vector2i(-r, 0), Vector2i(0, -r)]:
					for kol in [-4, 0, 4]:
						var yh: Vector2i = orta + d + (Vector2i(0, kol) if d.y == 0 else Vector2i(kol, 0))
						if y.yol_kur(yh):
							eklenen += 1
					if eklenen >= 6:
						return


func _ata(y: KoyYonetimi, kat: BinaKatalogu) -> void:
	var oncelik := ["tarla", "avci", "hizarhane", "tas_ocagi"]
	for k in y.bostakiler():
		for tur in oncelik:
			var atandi := false
			for b in y.binalar:
				if b.tur == tur and y.ata(k.id, b.id):
					atandi = true
					break
			if atandi:
				break
