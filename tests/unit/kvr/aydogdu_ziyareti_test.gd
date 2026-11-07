## OMR-21: Gerçek kapı kuyruğunda tanışma, kayıt dönüşü ve oba kararı.
extends SceneTree

const AYDOGDU = preload("res://src/sistemler/aydogdu_ziyareti.gd")
var _hata := 0

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o: Oturum
	var ilk: Gelen
	for tohum in range(1, 100):
		o = Oturum.new(kat, tohum)
		o.gun = 3
		o.ayarlar = o.ayarlar.duplicate(true)
		o.ayarlar.adli_olasiligi = 1.0
		for id in o.kadro.durumlar:
			if id != AYDOGDU.ID: o.kadro.durumlar[id].istendi = true
		ilk = _aydogdu(o.gece_kuyrugu())
		if ilk != null: break
	_dene(ilk != null and not AYDOGDU.ilgilenir(ilk) and ilk.acilis == "sohbet.aydogdu.acilis1", "İlk gerçek kuyrukta tanışma")
	if ilk == null:
		_bitir()
		return
	o.ziyaret_basladi(ilk)
	_dene(o.karar_ver(ilk, &"kabul").get("kaldi", false), "İlk gelişin mevcut kabulü")
	o.kadro.gece_bitti()
	o.gun = 6
	_dene(_aydogdu(o.gece_kuyrugu()) == null and not OzelOlay.aday(o, AYDOGDU.OLAY), "Dört geceden önce ikinci ziyaret veya rastgele oba kartı yok")
	o = Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	_dene(o != null, "İlk ziyaret mevcut JSON kaydından yüklenir")
	if o == null:
		_bitir()
		return
	o.gun = 7
	var ikinci := _aydogdu(o.gece_kuyrugu())
	_dene(ikinci != null and AYDOGDU.ilgilenir(ikinci) and ikinci.acilis == "sohbet.aydogdu.acilis2", "Dördüncü gecede ikinci kuyruk ve ittifak sözü")
	if ikinci == null:
		_bitir()
		return
	_dene(o.kadro.durumlar[AYDOGDU.ID].ziyaret == 1 and _aydogdu(o.gece_kuyrugu()) == null, "Kişi hafızası ilk ziyareti tanır ve aynı gece aday tek")
	o.ziyaret_basladi(ikinci)
	var yedek := KapiAnlikGoruntusu.gelen_yukle(JSON.parse_string(JSON.stringify(KapiAnlikGoruntusu.gelen_kaydet(ikinci))), kat)
	_dene(AYDOGDU.ilgilenir(yedek), "Açık ikinci ziyaret kapı anlık görüntüsünde kalır")
	if yedek == null:
		_bitir()
		return
	var once := o.yonetim.nufus()
	var sonuc := o.karar_ver(yedek, &"kabul")
	_dene(sonuc.get("oba_ziyareti", false) and ObaIttifaki.muttefik(o), "İkinci karar mevcut oba ittifakını kurar")
	_dene(o.yonetim.nufus() == once + 4 and o.yonetim.koylular.filter(func(k: Koylu) -> bool: return k.adli_id == AYDOGDU.ID).size() == 1, "Mevcut olay etkileri uygulanır, Aydoğdu ikinci kez köylü olmaz")
	_dene(o.karar_ver(yedek, &"kabul").engellendi and o.yonetim.nufus() == once + 4, "İkinci karar yinelenemez")
	o.gun = 12
	_dene(_aydogdu(o.gece_kuyrugu()) == null and o.kadro.durumlar[AYDOGDU.ID].ziyaret == 2, "Üçüncü geliş yok")
	_bitir()

func _aydogdu(kuyruk: Array[Gelen]) -> Gelen:
	for g in kuyruk:
		if g.id == AYDOGDU.ID: return g
	return null

func _dene(kosul: bool, mesaj: String) -> void:
	if kosul: return
	_hata += 1
	push_error(mesaj)

func _bitir() -> void:
	print("AYDOĞDU İKİ ZİYARET: %s" % ("GEÇTİ" if _hata == 0 else "KALDI"))
	quit(0 if _hata == 0 else 1)
