## Köylülerin görsel iş/dinlenme/ev rutini. Kalıcı simülasyonu değiştirmez.
class_name KoyHalkHareketi
extends Node

var sahne: KoyYonetimSahnesi
var modeller: Dictionary = {}
var rotaci := KoyRotasi.new()
var faz_adi: StringName = &"gunduz"
var _ayar: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy_hareket.json"))
var _durum: Dictionary = {}
var _bekleyen: Array[int] = []

## Salt okunur debug gözlemi; rota/animasyon veya kalıcı model ilerletilmez.
func eylem(id: int) -> String:
	if not modeller.has(id): return "Sahne sınırı dışında"
	if _bekleyen.has(id): return "Rota bekliyor"
	var d: Dictionary = _durum.get(id, {})
	if d.is_empty(): return "Durum yok"
	if int(d.adim) < d.yol.size(): return "Yürüyor"
	var k := sahne.yonetim.koylu(id)
	if d.get("siginma", false): return "Yağmurdan saçak altında korunuyor"
	if d.get("sinsi", false): return "Tenhada bekliyor"
	if d.get("ates_basi", false): return "Ateş başında ısınıyor"
	if d.get("degirmenci", false): return String(d.get("degirmenci_ad", "Öğütme bekliyor"))
	if d.get("coban", false): return String(d.get("coban_ad", "Sürü yolu kapalı"))
	if d.get("oduncu", false): return String(d.get("oduncu_ad", "Tomruk yolu kapalı"))
	if d.get("sulama", false): return String(d.get("sulama_ad", "Sulama bekliyor"))
	if d.get("devriye", false): return String(d.get("devriye_ad", "Nöbette"))
	if faz_adi == &"gece": return "Ev önünde" if k != null and k.ev >= 0 else "Meydanda"
	if faz_adi != &"gunduz": return "Meydanda"
	if d.dinlen: return "Dinleniyor"
	if d.is: return "Çalışıyor"
	return "Nöbette" if k != null and k.is_yeri == KoyYonetimi.MUHAFIZ else "Boşta"

## Mevcut modelleri korur, ayrılan köylüleri siler, değişen atama ve engellere yeni rota kurar.
func yenile() -> void:
	rotaci.kur(sahne.yonetim.izgara, float(_ayar.zemin_maliyeti))
	var kalan := {}
	for k in sahne.yonetim.koylular.slice(0, KoyYonetimSahnesi.AZAMI_KOYLU):
		kalan[k.id] = true
		if not modeller.has(k.id):
			var f := Dunya3B.karakter(Dunya3B.karakter_adi(k.adli_id, k.portre, k.sinif))
			sahne._halk.add_child(f)
			f.set_meta("koylu_id", k.id)
			var m := sahne.yonetim.a.meydan
			var h := rotaci.yakin(m.position + Vector2i(k.id % m.size.x, (k.id / m.size.x) % m.size.y))
			f.position = _konum(h)
			modeller[k.id] = f
			_durum[k.id] = {"yol": [], "adim": 0, "bekle": 0.0, "dinlen": false, "is": false, "bak": f.position, "devriye_i": k.id, "devriye": false}
		_iste(k.id)
	for id in modeller.keys():
		if not kalan.has(id):
			modeller[id].queue_free()
			modeller.erase(id)
			_durum.erase(id)
	MuhafizDonanimi.yenile(self)
	CobanSurusu.yenile(self)

## Gece eve; akşam meydana; gündüz iş ve kısa dinlenme döngüsüne geçer.
func faz(ad: StringName) -> void:
	faz_adi = ad
	for id in modeller:
		_durum[id].dinlen = false
		_iste(id)
	MuhafizDonanimi.yenile(self)
	CobanSurusu.yenile(self)

func _iste(id: int) -> void:
	if not _bekleyen.has(id):
		_bekleyen.append(id)
	var f: KarakterModel = modeller[id]
	f.yurumeyi_durdur()
	f.calis(&"")
	_durum[id].yol = []
	_durum[id].bekle = 0.0

func _process(delta: float) -> void:
	for i in mini(int(_ayar.kare_basina_rota), _bekleyen.size()):
		var id: int = _bekleyen.pop_front()
		if modeller.has(id):
			_planla(id)
	for id in modeller:
		if _bekleyen.has(id):
			continue
		var d: Dictionary = _durum[id]
		var f: KarakterModel = modeller[id]
		if SinsiGeceRutini.guncelle(self, id, delta): continue
		if d.adim < d.yol.size():
			var hedef: Vector3 = d.yol[d.adim]
			if f.position.distance_to(hedef) <= float(_ayar.varis_mesafesi):
				d.adim += 1
				if d.adim < d.yol.size():
					_adim(id)
				else:
					OduncuRutini.varis(f, d.get("oduncu", false) and int(d.get("oduncu_i", 0)) == 0)
					SulamaRutini.varis(f, d.get("sulama", false) and int(d.get("sulama_i", 0)) == 1)
					f.bak(d.bak)
					f.calis(&"isin" if d.get("ates_basi", false) else (StringName(d.get("zanaat_hareket", "calis")) if d.is else &""))
		elif d.get("oduncu", false):
			d.bekle += delta
			if d.bekle >= float(OduncuRutini.AYAR.sureler[d.oduncu_i]):
				d.oduncu_i = (int(d.oduncu_i) + 1) % 3
				_iste(id)
		elif d.get("sulama", false):
			d.bekle += delta
			if d.bekle >= float(SulamaRutini.AYAR.sureler[d.sulama_i]):
				d.sulama_i = (int(d.sulama_i) + 1) % 3
				_iste(id)
		elif d.get("devriye", false):
			d.bekle += delta
			if d.bekle >= float(MuhafizDevriyesi.AYAR.durak_suresi):
				d.devriye_i += 1
				_iste(id)
		elif d.get("degirmenci", false):
			d.bekle += delta
			if d.bekle >= float(DegirmenHareketi.AYAR.sureler[d.degirmenci_i]):
				d.degirmenci_i = (int(d.degirmenci_i) + 1) % 3
				_iste(id)
		elif d.get("coban", false):
			continue
		elif faz_adi == &"gunduz":
			d.bekle += delta
			var sure := float(_ayar.dinlenme_suresi if d.dinlen else _ayar.calisma_suresi)
			if d.bekle >= sure:
				d.dinlen = not d.dinlen
				_iste(id)

func _planla(id: int) -> void:
	var f: KarakterModel = modeller[id]
	var d: Dictionary = _durum[id]
	var k: Koylu
	for aday in sahne.yonetim.koylular:
		if aday.id == id:
			k = aday
			break
	if k == null:
		return
	var orta := Vector2(sahne.yonetim.a.meydan.position) + Vector2(sahne.yonetim.a.meydan.size) / 2.0
	var ham := Vector2i(floori(f.position.x / sahne.HUCRE + orta.x), floori(f.position.z / sahne.HUCRE + orta.y))
	var bas := rotaci.yakin(ham)
	if bas.x < 0:
		return
	if not rotaci.gecilir(ham):
		f.position = _konum(bas)
	var m := sahne.yonetim.a.meydan
	var son := rotaci.yakin(m.position + Vector2i(id % m.size.x, (id / m.size.x) % m.size.y))
	var b := sahne.yonetim.bina(k.ev if faz_adi == &"gece" else k.is_yeri)
	d.is = false
	d.bak = sahne.alan_merkezi(m.position, m.size)
	if b != null and b.hazir() and (faz_adi == &"gece" or (faz_adi == &"gunduz" and not d.dinlen)):
		son = rotaci.bina_duragi(bas, Rect2i(b.hucre, b.boyut(sahne.yonetim.katalog)), id)
		d.bak = sahne.alan_merkezi(b.hucre, b.boyut(sahne.yonetim.katalog))
		d.is = faz_adi == &"gunduz"
	elif k.is_yeri == KoyYonetimi.MUHAFIZ and faz_adi == &"gunduz" and not d.dinlen:
		son = rotaci.yakin(Vector2i(m.position.x + m.size.x / 2, sahne.yonetim.a.izgara_boyut.y - 1))
		d.bak = _konum(son) + Vector3.FORWARD * -sahne.HUCRE
	d.devriye = MuhafizMaasi.aday(k, sahne.yonetim)
	if d.devriye:
		var nobet := MuhafizDevriyesi.hedef(sahne.yonetim, rotaci, bas, int(d.devriye_i))
		d.is = false
		d.dinlen = false
		son = bas if nobet.is_empty() else nobet.son
		d.bak = _konum(son) + Vector3.FORWARD * -sahne.HUCRE
		d.devriye_ad = "Nöbette" if nobet.is_empty() else nobet.ad
		if not nobet.is_empty(): d.devriye_i = nobet.sira
	d.sulama = SulamaRutini.aday(sahne.yonetim, k, faz_adi)
	if d.sulama:
		d.sulama_i = int(d.get("sulama_i", 0))
		var su := SulamaRutini.hedef(self, k, bas, d.sulama_i)
		d.is = not su.is_empty() and d.sulama_i == 1
		d.dinlen = d.sulama_i == 2
		son = bas if su.is_empty() else su.son
		d.bak = f.position if su.is_empty() else su.bak
		d.sulama_ad = "Sulama yolu kapalı" if su.is_empty() else su.ad
	else:
		d.sulama_i = 0
	SulamaRutini.esya(f, d.sulama, int(d.sulama_i))
	d.oduncu = OduncuRutini.aday(sahne.yonetim, k, faz_adi)
	if d.oduncu:
		d.oduncu_i = int(d.get("oduncu_i", 0))
		var odun := OduncuRutini.hedef(self, k, bas, d.oduncu_i)
		d.is = not odun.is_empty() and d.oduncu_i == 0
		d.dinlen = d.oduncu_i == 2
		son = bas if odun.is_empty() else odun.son
		d.bak = f.position if odun.is_empty() else odun.bak
		d.oduncu_ad = "Tomruk yolu kapalı" if odun.is_empty() else odun.ad
	else:
		d.oduncu_i = 0
	OduncuRutini.esya(f, sahne.yonetim, id, d.oduncu, int(d.oduncu_i))
	d.coban = CobanSurusu.hazir(sahne.yonetim.bina(k.is_yeri))
	if d.coban:
		var suru := CobanSurusu.hedef(self, k, bas)
		son = bas if suru.is_empty() else suru.son
		d.is = false
		d.dinlen = true
		d.bak = _konum(son)
		d.coban_ad = "Sürü yolu kapalı" if suru.is_empty() else suru.ad
	d.degirmenci = DegirmenHareketi.aday(sahne.yonetim, k, faz_adi)
	var tasiyor := false
	if d.degirmenci:
		d.degirmenci_i = int(d.get("degirmenci_i", 0))
		var un := DegirmenHareketi.hedef(self, k, bas, d.degirmenci_i)
		son = bas if un.is_empty() else un.son
		d.degirmenci_ad = "Öğütme yolu kapalı" if un.is_empty() else un.ad
		d.is = not un.is_empty() and un.calisiyor and d.degirmenci_i == 0
		d.dinlen = not d.is
		tasiyor = not un.is_empty() and un.calisiyor and d.degirmenci_i == 1
		d.bak = sahne.alan_merkezi(b.hucre, b.boyut(sahne.yonetim.katalog))
	else:
		d.degirmenci_i = 0
	DegirmenHareketi.esya(f, d.degirmenci, tasiyor)
	d.zanaat = ZanaatTezgahi.aday(sahne.yonetim, k, faz_adi)
	d.zanaat_hareket = "calis"
	var alet_turu := ""
	if d.zanaat:
		var z := sahne.yonetim.bina(k.is_yeri)
		var tezgah := ZanaatTezgahi.hedef(self, k, bas)
		d.is = not d.dinlen and not tezgah.is_empty() and ZanaatTezgahi.aktif(sahne.yonetim, k)
		if d.is:
			son = tezgah.son
			d.bak = tezgah.bak
			d.zanaat_hareket = ZanaatTezgahi.AYAR.turler[z.tur]
			alet_turu = z.tur
	if faz_adi == &"gunduz" and b != null and ZanaatTezgahi.AYAR.turler.has(b.tur) and not d.zanaat: d.is = false
	ZanaatTezgahi.esya(f, alet_turu)
	d.ates_basi = false
	if AtesBasiRutini.aday(sahne.yonetim, k, faz_adi):
		var ates := AtesBasiRutini.hedef(self, k, bas)
		if not ates.is_empty():
			son = ates.son
			d.bak = ates.bak
			d.ates_basi = true
			d.is = false
	d.siginma = false
	var hava := KarakterHavaTepkisi.hedef(self, k, bas)
	if not hava.is_empty():
		son = hava.son
		d.bak = hava.bak
		d.siginma = true
		d.is = false
		d.ates_basi = false
		d.oduncu = false
		d.sulama = false
		d.degirmenci = false
		d.coban = false
		d.zanaat = false
		OduncuRutini.esya(f, sahne.yonetim, id, false, 0)
		SulamaRutini.esya(f, false, 0)
		DegirmenHareketi.esya(f, false, false)
		ZanaatTezgahi.esya(f, "")
	son = SinsiGeceRutini.planla(self, k, bas, son)
	if f.duzeltici() != null: f.duzeltici().hava_egimi = KarakterHavaTepkisi.egim(sahne.yonetim)
	var hucreler := rotaci.yol(bas, son)
	if hucreler.is_empty():
		d.is = false
	d.yol = []
	for h in hucreler:
		d.yol.append(_konum(h))
	if not d.yol.is_empty() and not d.ates_basi:
		# Küçük, hücre içinde kalan durak farkı: aynı durakta üst üste binmeyi azaltır.
		d.yol[-1] += Vector3((id % 3 - 1) * float(_ayar.durak_araligi), 0, ((id / 3) % 3 - 1) * float(_ayar.durak_araligi))
	d.adim = 0
	if d.coban: CobanSurusu.plan(self, k, d.yol)
	if not d.yol.is_empty():
		_adim(id)

func _adim(id: int) -> void:
	var fark := sin(float(id) * 2.4) * float(_ayar.hiz_farki)
	modeller[id].yuru(_durum[id].yol[_durum[id].adim], float(_ayar.yurume_hizi) * (1.0 + fark) * KarakterHavaTepkisi.hiz(sahne.yonetim) * SinsiGeceRutini.hiz(_durum[id]))

func _konum(h: Vector2i) -> Vector3:
	return sahne.alan_merkezi(h, Vector2i.ONE)
