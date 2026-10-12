## BUG-22: açılış ekonomisi dengesi — beş farklı açılış sırası 20 gece kilitlenmeden geçer.
## Kilit tanımı (madde): "taş ocağı kurulamıyor ve kurtarıcı da bitti".
## Çalıştırma: DUMAN_TESTI_ACILIS=1 godot --headless --path . tests/oto/acilis_denge_kontrol.tscn
## Sayı enjektörü yoktur; her gece gerçek KoyYonetimi.gece() (Oturum.gece_sonu) üzerinden ilerler.
extends Node

const ACILIS := preload("res://src/sistemler/acilis_senaryosu.gd")
const GECE := 20
const AZAMI_KURULUM := 10

## Beş açılış sırası (madde Kabul). Adımlar: yapı türü, "kazi" (yatağa işçi),
## "kazi_bitir" (20 taş çıkana kadar bekle), "bekle" (yalnız başlangıç evi).
const SIRALAR: Array[Dictionary] = [
	{"ad": "1_hizar_iki_cadir_tarla_ocak", "plan": ["hizarhane", "cadir", "cadir", "tarla", "tas_ocagi"]},
	{"ad": "2_once_tarla_yatak_ocak", "plan": ["tarla", "kazi", "tas_ocagi"]},
	{"ad": "3_bes_gece_ev_sonra_ocak", "plan": ["bekle", "bekle", "bekle", "bekle", "bekle", "tas_ocagi"]},
	{"ad": "4_cadir_cadir_odun_once", "plan": ["cadir", "cadir", "hizarhane", "tarla", "tas_ocagi"]},
	{"ad": "5_yatak_biter_ocak", "plan": ["kazi_bitir", "tas_ocagi"]},
]

var _hata := 0
var _rapor: Array[Dictionary] = []


func _ready() -> void:
	get_tree().create_timer(600.0).timeout.connect(func() -> void: get_tree().quit(1))
	call_deferred("_calistir")


func _calistir() -> void:
	var katalog := Katalog.new()
	if katalog.yukle() != Katalog.Durum.HAZIR:
		push_error("Katalog yüklenemedi")
		get_tree().quit(1)
		return
	_tablo_kontrolleri(katalog)
	_acilis_evi_bedava(katalog)
	_eski_kayit_stoku(katalog)
	for i in SIRALAR.size():
		var r := _oyna(katalog, SIRALAR[i], 4200 + i * 7)
		_rapor.append(r)
		print("SIRA %s | gece=%d son=%s ocak_gece=%d kilit=%s stok(odun=%d tas=%d alet=%d) kurtarici=%d" % [
			r.sira, r.gece, r.son, r.ocak_gece, r.kilit, r.odun, r.tas, r.alet, r.kurtarici])
		if not r.kilit_satirlari.is_empty():
			print("   kilit geceleri: ", r.kilit_satirlari)
		_kontrol(not bool(r.kilit), "Sıra %s hiç kilitlenmez" % r.sira)
		_kontrol(int(r.ocak_gece) > 0 and int(r.ocak_gece) <= AZAMI_KURULUM,
			"Sıra %s %d gün içinde taş ocağını kurar (gece=%d)" % [r.sira, AZAMI_KURULUM, r.ocak_gece])
		await get_tree().process_frame
	await get_tree().process_frame
	print("AÇILIŞ DENGE: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	get_tree().quit(0 if _hata == 0 else 1)


## Tablo yalnız duran kaynak türlerini kullanır (Kural 4: yeni kaynak türü yok).
func _tablo_kontrolleri(k: Katalog) -> void:
	var baslangic: Dictionary = k.koy_ayarlari.baslangic_kaynak
	_kontrol(int(baslangic.get("odun", 0)) > 0 and int(baslangic.get("tas", 0)) > 0, "Başlangıç tablosu odun ve taş satırı taşır")
	for tur in baslangic:
		_kontrol(tur in Kaynaklar.TURLER, "Başlangıç stoku yeni kaynak türü eklemez: " + str(tur))
	_kontrol(FileAccess.get_file_as_string("res://data/ayarlar/koy.tres").contains("baslangic_kaynak"),
		"Başlangıç stoku veri dosyası koy.tres içinde tanımlıdır (koda gömülü değil)")


## ACL-01: yeni oyun tek hazır ev, iki kişi, yatak 4; evin maliyeti tekrar kesilmez.
func _acilis_evi_bedava(k: Katalog) -> void:
	var o := Oturum.new(k, 7)
	var once := o.yonetim.kaynaklar.stok.duplicate()
	ACILIS.kur(o)
	_kontrol(o.yonetim.binalar.size() == 1, "ACL-01 yeni oyun tek hazır evle başlar")
	_kontrol(o.yonetim.nufus() == 2 and o.yonetim.yatak_kapasitesi() == 4, "ACL-01 nüfus 2, yatak 4")
	_kontrol(o.yonetim.kaynaklar.stok == once, "ACL-01 evinin maliyeti stoktan tekrar kesilmez")
	o.yonetim = null
	o.koy = null
	o.kadro = null


## Eski kayıt yüklemesi başlangıç stokunu değiştirmez (Kural 2).
func _eski_kayit_stoku(k: Katalog) -> void:
	var y := KoyYonetimi.new(k.koy_ayarlari, k.binalar, 99)
	y.kaynaklar.stok["odun"] = 3
	y.kaynaklar.stok["tas"] = 1
	var geri := KoyYonetimi.kayittan(k.koy_ayarlari, k.binalar, y.kaydet())
	_kontrol(geri != null and geri.kaynaklar.miktar("odun") == 3 and geri.kaynaklar.miktar("tas") == 1,
		"Eski kayıt stoku (odun 3, tas 1) yüklemede değişmez")
	var yeni := KoyYonetimi.new(k.koy_ayarlari, k.binalar, 99)
	_kontrol(yeni.kaynaklar.miktar("odun") == int(k.koy_ayarlari.baslangic_kaynak["odun"])
		and yeni.kaynaklar.miktar("tas") == int(k.koy_ayarlari.baslangic_kaynak["tas"]),
		"Yeni oyun stoku baslangic_kaynak tablosundan gelir")


func _oyna(katalog: Katalog, sira: Dictionary, tohum: int) -> Dictionary:
	var o := Oturum.new(katalog, tohum)
	ACILIS.kur(o)
	var y := o.yonetim
	var idx: Array[int] = [0]
	var kilit_geceleri: Array[int] = []
	var gecen := 0
	var ocak_gece := 0
	for i in GECE:
		_gate(o)
		_gece_adim(o, y, sira, idx)
		o.gece_sonu()
		gecen += 1
		if ocak_gece == 0 and _ocak(y):
			ocak_gece = gecen
		if _kilit(y):
			kilit_geceleri.append(y.gun)
	var rapor := {"sira": sira.ad, "gece": gecen, "son": y.son, "ocak_gece": ocak_gece,
		"kilit": not kilit_geceleri.is_empty(), "kilit_satirlari": kilit_geceleri,
		"odun": y.kaynaklar.miktar("odun"), "tas": y.kaynaklar.miktar("tas"), "alet": y.kaynaklar.miktar("alet"),
		"kurtarici": y.tas_yatagi.kurtarici_sayisi if y.tas_yatagi != null else -1}
	o.yonetim = null
	o.koy = null
	o.kadro = null
	return rapor


func _gece_adim(o: Oturum, y: KoyYonetimi, sira: Dictionary, idx: Array[int]) -> void:
	var ilerledi := true
	while ilerledi and idx[0] < sira.plan.size():
		var adim: String = sira.plan[idx[0]]
		if adim == "bekle":
			idx[0] += 1
			break
		ilerledi = _adim(y, adim, idx)
	# Plan tamamlanana kadar genel inşa yok: sıra birebir uygulanır ("yalnız başlangıç evi" dâhil).
	if idx[0] >= sira.plan.size():
		_genel(y)
	_ata(y)
	_post(y)


func _adim(y: KoyYonetimi, adim: String, idx: Array[int]) -> bool:
	if adim == "kazi":
		if not _yatak_ata(y):
			return false
		idx[0] += 1
		return true
	if adim == "kazi_bitir":
		if y.tas_yatagi == null or y.tas_yatagi.kalan <= 0:
			idx[0] += 1
			return true
		_yatak_ata(y)
		return false
	if _kur(y, adim):
		idx[0] += 1
		return true
	return false


func _gate(o: Oturum) -> void:
	for g in o.gece_kuyrugu():
		var chr := g.chr_sorgusu()
		if chr != null:
			chr.obje_incele(1)
			chr.obje_incele(2)
			chr.gorsel_incele()
			if chr.secenek_sec(2):
				chr.secenek_sec(0)
				chr.secenek_sec(0)
		var karar: StringName = &"ret" if g.tehlikeli else &"kabul"
		if not String(karar) in g.secenekler:
			karar = StringName(g.secenekler[0])
		o.karar_ver(g, karar)


## Plan bittikten sonraki genel oyuncu: odun zinciri (orman kampı → hızarhane), sonra gıda ve barınak.
func _genel(y: KoyYonetimi) -> void:
	var say := _say(y)
	if int(say.get("odunluk", 0)) < 1 and y.kaynaklar.miktar("odun") >= 6 and y.kaynaklar.miktar("tas") >= 2:
		_kur(y, "odunluk")
	if int(say.get("hizarhane", 0)) < 1 and int(say.get("odunluk", 0)) > 0:
		_kur(y, "hizarhane")
	if y.yatak_kapasitesi() < y.nufus() + 2:
		_kur(y, "cadir")
	if y.kaynaklar.miktar("gida") < y.nufus() * 4 + 6:
		if int(say.get("tarla", 0)) * 3 < y.nufus() * 6 / 10 + 1:
			_kur(y, "tarla")
		if int(say.get("avci", 0)) < 1 and y.nufus() > 3:
			_kur(y, "avci")


## Boşta kalanları odun kıtlığında zincire, rahatlıkta gıdaya yazar.
func _ata(y: KoyYonetimi) -> void:
	var kisitli := y.kaynaklar.miktar("odun") < 12
	for k in y.bostakiler():
		if kisitli and (_dene(y, k, "odunluk") or _dene(y, k, "hizarhane")):
			continue
		if _dene(y, k, "tarla") or _dene(y, k, "avci"):
			continue
		if _dene(y, k, "odunluk") or _dene(y, k, "hizarhane") or _dene(y, k, "tas_ocagi"):
			continue


func _post(y: KoyYonetimi) -> void:
	if y.isyan_kalan >= 0:
		y.as_dagit()
	if y.harac_bekliyor and not y.harac_ode():
		y.harac_reddet()
	if y.kaynaklar.miktar("odun") > 40:
		y.tezgah_sat("odun", 20)


func _yatak_ata(y: KoyYonetimi) -> bool:
	if y.tas_yatagi == null or y.tas_yatagi.kalan <= 0:
		return true
	if not y.calisanlar(TasYatagi.IS_YERI).is_empty():
		return true
	for k in y.bostakiler():
		if TasYatagi.ata(y, k.id):
			return true
	return false


func _kur(y: KoyYonetimi, tur: String) -> bool:
	var m := y.katalog.maliyet(tur)
	if not y.kaynaklar.yeterli(y._malzeme(m)) or y.akce < int(m.get("akce", 0)):
		return false
	for cy in y.izgara.boyut.y:
		for cx in y.izgara.boyut.x:
			var h := Vector2i(cx, cy)
			if y.yerlesim(tur, h)["olur"]:
				return bool(y.bina_kur(tur, h)["olur"])
	return false


func _dene(y: KoyYonetimi, k: Koylu, tur: String) -> bool:
	for b in y.binalar:
		if b.tur == tur and y.ata(k.id, b.id):
			return true
	return false


func _say(y: KoyYonetimi) -> Dictionary:
	var s := {}
	for b in y.binalar:
		s[b.tur] = int(s.get(b.tur, 0)) + 1
	return s


func _ocak(y: KoyYonetimi) -> bool:
	for b in y.binalar:
		if b.tur == "tas_ocagi":
			return true
	return false


## Kilit: taş ocağı yok + kurtarıcı bitti (sayaç azami ve yatak tükendi) + ocak kurulamıyor.
func _kilit(y: KoyYonetimi) -> bool:
	if String(y.son) != "":
		return false
	if _ocak(y):
		return false
	if y.tas_yatagi == null:
		return true
	if y.tas_yatagi.kalan > 0:
		return false
	if y.tas_yatagi.kurtarici_sayisi < int(TasYatagi.AYAR["kurtarici_azami"]):
		return false
	return not KaynakKurtarici.ocak_kurulabilir(y)


func _kontrol(olur: bool, metin: String) -> void:
	if not olur:
		_hata += 1
		push_error(metin)