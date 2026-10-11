extends SceneTree

## Gerçek planlayıcı + ANI-13; yalnız pahalı sahne dekorunun kurulumu atlanır.
class TestSahne extends KoyYonetimSahnesi:
	func _ready() -> void:
		add_child(_yapilar)
		add_child(_halk)

var hata := 0
var kontrol_sayisi := 0
var disarida := 0
var cakisma := 0

func _initialize() -> void:
	call_deferred("_kos")

func _kos() -> void:
	for tohum in range(1, 21):
		var s := _kur(tohum)
		var y := s.yonetim
		var h := s.halk_hareketi
		var once := JSON.stringify(y.kaydet())
		var noktalar := {}
		for k in y.koylular:
			var b := y.bina(k.is_yeri)
			var n := TarlaIsNoktalari.nokta(s, k)
			_kontrol(not n.is_empty(), "Atanmış çiftçinin iş noktası var")
			if n.is_empty(): continue
			_kontrol(h.rotaci.gecilir(n.hucre) and y.izgara.dolu.get(n.hucre) == b.id, "Tarla yalnız gezinmede açık, yerleşimde dolu")
			h._durum[k.id].sulama_i = 1
			h._planla(k.id)
			var d: Dictionary = h._durum[k.id]
			_kontrol(d.is and d.tarla_hedef and not d.yol.is_empty(), "Gerçek çalışma aşaması tarla içine yol planlar")
			_var(h, k.id)
			var p: Vector3 = h.modeller[k.id].position
			if not _icinde(s, b, p): disarida += 1
			if noktalar.has(p): cakisma += 1
			noktalar[p] = true
			_kontrol(p.is_equal_approx(n.konum), "Gerçek varış deterministik iş noktasıdır")
			_kontrol(not _icinde(s, y.bina(y.koylular[0].is_yeri if b.id != y.koylular[0].is_yeri else y.koylular[-1].is_yeri), p), "Birden çok tarlada çiftçi kendi tarlasındadır")
		_kontrol(JSON.stringify(y.kaydet()) == once, "Plan ve varış ekonomi/RNG/kaydı değiştirmez")
		var diger := _kur(tohum)
		for k in y.koylular:
			_kontrol(TarlaIsNoktalari.nokta(s, k) == TarlaIsNoktalari.nokta(diger, diger.yonetim.koylu(k.id)), "Aynı tohum/kişi aynı nokta")
		diger.free()
		if tohum == 1:
			await _navigasyon(s)
			_diger_asamalar(s)
			_tarlasiz(s)
		s.free()
	_kontrol(disarida == 0, "20 denemede tarla dışında 0 çalışan")
	_kontrol(cakisma == 0, "20 denemede aynı koordinatta 0 çiftçi")
	print("TARLA İŞ NOKTALARI: %s (%d kontrol; 20 deneme; dışarıda=%d; çakışma=%d)" % ["GEÇTİ" if hata == 0 else "KALDI", kontrol_sayisi, disarida, cakisma])
	quit(hata)

func _kur(tohum: int) -> TestSahne:
	var y := KoyYonetimi.new(KoyAyarlari.new(), BinaKatalogu.new(), tohum)
	y.akce = 10000
	y.kaynaklar.kapasite = 10000
	for tur in ["odun", "tas", "kereste"]: y.kaynaklar.ekle(tur, 500)
	var s := TestSahne.new()
	s.yonetim = y
	s.set_process(false)
	root.add_child(s)
	var ev := _bina(y, "cadir")
	for tur in ["tarla", "bostan"]:
		var b := _bina(y, tur)
		_kontrol(b != null, "Gerçek tarla/bostan kurulumu")
		if b == null: continue
		for i in 2:
			var k := y.kabul({"ad": "Çiftçi", "sinif": "ciftci", "stat": 5})
			_kontrol(y.ata(k.id, b.id), "Gerçek çiftçi ataması")
			k.ev = ev.id
	var h := KoyHalkHareketi.new()
	h.sahne = s
	h.set_process(false)
	s.add_child(h)
	s.halk_hareketi = h
	h.rotaci.kur(TarlaIsNoktalari.gezinme_izgarasi(y), float(h._ayar.zemin_maliyeti))
	for k in y.koylular:
		var f := KarakterModel.new()
		s.add_child(f)
		f.position = s.alan_merkezi(y.a.meydan.position, Vector2i.ONE)
		h.modeller[k.id] = f
		h._durum[k.id] = {"yol": [], "adim": 0, "bekle": 0.0, "dinlen": false, "is": false, "devriye_i": k.id}
	return s

func _bina(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var cell := Vector2i(cx, cy)
			if y.yerlesim(tur, cell).olur:
				var b := y.bina(y.bina_kur(tur, cell).id)
				if b != null: b.insa_kalan = 0
				return b
	return null

func _var(h: KoyHalkHareketi, id: int) -> void:
	var f: KarakterModel = h.modeller[id]
	var d: Dictionary = h._durum[id]
	while int(d.adim) < d.yol.size():
		f.yurumeyi_durdur()
		f.position = d.yol[d.adim]
		h._process(0.0)
	f.yurumeyi_durdur()

func _icinde(s: KoyYonetimSahnesi, b: KoyBinasi, p: Vector3) -> bool:
	var c := s.hucre_kosesi(b.hucre)
	var boy := b.boyut(s.yonetim.katalog)
	return p.x > c.x and p.x < c.x + boy.x * s.HUCRE and p.z > c.z and p.z < c.z + boy.y * s.HUCRE

func _navigasyon(s: TestSahne) -> void:
	var h := s.halk_hareketi
	KoyZeminNavigasyonu.yenile(h)
	var k := s.yonetim.koylular[0]
	var hedef := TarlaIsNoktalari.nokta(s, k)
	h._planla(k.id)
	_kontrol(not h._durum[k.id].yol.is_empty(), "Yeni tarla: nav sync beklerken güncel A* yolu aynı karede içeride")
	var n := h.get_node("zemin_navigasyonu") as KoyZeminNavigasyonu
	for i in 120:
		if n.hazir(): break
		await physics_frame
	_kontrol(n.hazir(), "ANI-13 tek bölgesi senkronize olur")
	var nav := NavigationServer3D.map_get_path(n.get_navigation_map(), s.alan_merkezi(s.yonetim.a.meydan.position, Vector2i.ONE), hedef.konum, true, n.navigation_layers)
	_kontrol(not nav.is_empty() and nav[-1].is_equal_approx(hedef.konum), "Gerçek NavigationServer3D tarla içindeki noktaya ulaşır")
	_kontrol(h.find_children("*", "NavigationRegion3D", false, false).size() == 1, "Yeni navigasyon ağı yok: tek ANI-13 bölgesi")

func _diger_asamalar(s: TestSahne) -> void:
	var h := s.halk_hareketi
	var y := s.yonetim
	var k := y.koylular[0]
	var d: Dictionary = h._durum[k.id]
	for i in [0, 2]:
		d.sulama_i = i
		h._planla(k.id)
		_kontrol(not d.tarla_hedef and not d.is and not d.yol.is_empty(), "Kuyu/dinlenme aşaması korunur")
		_kontrol(not _icinde(s, y.bina(k.is_yeri), d.yol[-1]), "Kuyu ve mola tarla dışındadır")
	d.sulama_i = 1
	d.dinlen = false
	h._planla(k.id)
	var once: Vector3 = d.yol[-1]
	y.gun = 15 # Sonbahar; MEV-08 mevcut moral etkisi iş noktası seçmez.
	var olaylar: Array[Dictionary] = []
	HasatSenligi.uygula(y, true, olaylar)
	_kontrol(not olaylar.is_empty(), "Gerçek hasat şenliği uygulanır")
	h._planla(k.id)
	_kontrol(d.yol[-1].is_equal_approx(once), "Hasat şenliği iş noktasını değiştirmez")
	h.faz(&"gece")
	h._bekleyen.clear()
	h._planla(k.id)
	_kontrol(not d.tarla_hedef and not d.is and not d.yol.is_empty(), "Gece ev rotası korunur")
	for b in y.binalar:
		if TarlaIsNoktalari.tarla(b): _kontrol(not _icinde(s, b, d.yol[-1]), "Uyku noktası hiçbir tarla değildir")
	h.faz_adi = &"gunduz"
	d.dinlen = false
	d.sulama_i = 1
	h._planla(k.id)
	_var(h, k.id)

func _tarlasiz(s: TestSahne) -> void:
	var h := s.halk_hareketi
	var y := s.yonetim
	var k := y.koylular[0]
	var d: Dictionary = h._durum[k.id]
	var once: Vector3 = d.tarla_noktasi
	_kontrol(y.bina_yik(k.is_yeri), "Tarla gerçek API ile kaldırılır")
	h.rotaci.kur(TarlaIsNoktalari.gezinme_izgarasi(y), float(h._ayar.zemin_maliyeti))
	h._planla(k.id)
	_kontrol(not d.is and d.tarla_uyarildi and d.yol[-1].is_equal_approx(once), "Tarla yok: uyarı, iş iptali ve eski nokta korunur")
	_var(h, k.id)
	_kontrol(h.modeller[k.id].position.is_equal_approx(once) and not once.is_equal_approx(Vector3.ZERO), "Tarla yokken orijine taşınmaz")
	d.erase("tarla_noktasi")
	d.erase("tarla_hucresi")
	k.is_yeri = 999999
	var p: Vector3 = h.modeller[k.id].position
	h._planla(k.id)
	_kontrol(not d.is and d.yol[-1].is_equal_approx(p), "Eski noktası olmayan geçersiz atama mevcut konumu korur")

func _kontrol(v: bool, ad: String) -> void:
	kontrol_sayisi += 1
	if not v:
		hata += 1
		push_error(ad)
