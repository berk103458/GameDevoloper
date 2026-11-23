## Bütün CHR kayıtlarını normal gece kuyruğundan alır ve kararları bağımsız oturumlarda yürütür.
extends Node

var _kat := Katalog.new()
var _hatalar: Array[String] = []
var _kol_sayisi := 0
var _teklifsiz_rusvet: Array[String] = []


func _ready() -> void:
	TranslationServer.set_locale("tr")
	GuvenliMetin.kur()
	_dene(_kat.yukle() == Katalog.Durum.HAZIR, "Karakter kataloğu hazır.")
	var ids: Array[StringName] = []
	for dosya in DirAccess.get_files_at("res://data/chr_runtime"):
		if dosya.begins_with("CHR_") and dosya.ends_with(".tres"):
			ids.append(StringName(dosya.get_basename().to_lower()))
	ids.sort()
	_dene(ids.size() == 30, "Otuz CHR kaydı kapsamda.")
	for id in ids:
		var beklenen := _kat.karakter(id)
		if not _dene(beklenen != null, "%s normal katalogda." % id):
			continue
		var tohum := _tohum_ara(id)
		if not _dene(tohum > 0, "%s normal gece kuyruğuna düşebiliyor." % id):
			continue
		for karar: StringName in [&"kabul", &"ret", &"rusvet"]:
			_dali_oyna(id, tohum, karar)
		await get_tree().process_frame
	_dene(_kol_sayisi == ids.size() * 3, "Bütün ziyaretçilerin üç kararı tamamlandı.")
	_dene(GuvenliMetin.eksikler.is_empty(), "Sorgu replikleri ve seçenekler CSV tablosunda.")
	print("CHR_KADRO_OZET ", JSON.stringify({"karakter": ids.size(), "dal": _kol_sayisi,
		"teklifsiz_rusvet": _teklifsiz_rusvet, "hatalar": _hatalar}))
	print("CHR KADRO: GEÇTİ" if _hatalar.is_empty() else "CHR KADRO: KALDI")
	get_tree().quit(0 if _hatalar.is_empty() else 1)


func _oturum(id: StringName, tohum: int) -> Oturum:
	var o := Oturum.new(_kat, tohum)
	o.gun = int(TehditTakvimi.AYAR.tehdit_baslangic_gunu)
	var y := o.yonetim
	# Oturmuş bir köyün doğal koşulları. Her profil için rakipsiz kalana kadar
	# diğer insanların kapıdan kalıcı ayrıldığı bir kayıt durumu hazırlanır.
	for kayit_id in o.kadro.durumlar:
		if kayit_id != id:
			o.kadro.durumlar[kayit_id]["durum"] = &"kalici_ayrildi"
	for i in Omurga.yerlesme_ust_sinir() + 1:
		var koylu := y.kabul({"ad": "Denetim köylüsü %d" % i, "sinif": "ciftci"})
		koylu.moral = 30
		koylu.refah = 30
		koylu.saglik = 30
	y.asayis_riski = 20 if id == &"chr_007" else 80
	var gida := y.kaynaklar.miktar("gida")
	if gida > 12:
		y.kaynaklar.azalt("gida", gida - 12)
	return o


func _ziyaretci(o: Oturum, id: StringName) -> Gelen:
	for g in o.gece_kuyrugu():
		if g.id == id:
			return g
	return null


func _tohum_ara(id: StringName) -> int:
	for tohum in range(1, 65):
		var o := _oturum(id, tohum)
		if _ziyaretci(o, id) != null:
			return tohum
	return 0


func _dali_oyna(id: StringName, tohum: int, karar: StringName) -> void:
	var o := _oturum(id, tohum)
	var g := _ziyaretci(o, id)
	if not _dene(g != null, "%s/%s gece sırasında." % [id, karar]):
		return
	var sorgu := g.chr_sorgusu() as ChrSorgusu
	if not _dene(sorgu != null, "%s/%s CHR kaynağı kullanılabilir." % [id, karar]):
		return
	o.ziyaret_basladi(g)
	var motor := g.kapi_sozu()
	_sorgu_satiri(motor, sorgu)
	for hedef in [&"1.1", &"1.2"]:
		var dugum := sorgu.karakter.diyalog_dugumu(sorgu.dugum_id)
		var secenek: Dictionary = dugum.secenekler[0]
		var anahtar := String(secenek.metin_anahtari)
		_dene(not SozMotoru.kapi_metni(anahtar).is_empty(), "%s sorgu seçeneği çözüldü." % id)
		_dene(motor.kapi_chr_secim("chr_soru", anahtar, sorgu.secenek_sec.bind(0)) and sorgu.dugum_id == hedef,
			"%s/%s takip sorusu %s düğümüne gitti." % [id, karar, hedef])
		_sorgu_satiri(motor, sorgu)

	var once := _koy(o)
	var beklenen := ChrKararMatrisi.secilen_stat_etkisi(sorgu, karar)
	var teklif := sorgu.karakter.karar_verisi(&"rusvet")
	if karar == &"rusvet" and int(teklif.get("muhafiz_akce", 0)) <= 0 and (teklif.get("esyalar", []) as Array).is_empty():
		_teklifsiz_rusvet.append(String(id))
	var sonuc := o.karar_ver(g, karar)
	var sonra := _koy(o)
	var iz := motor.kapi_izi
	var koylu := o.yonetim.koylu(int(sonuc.get("koylu_id", -1)))
	var kalir := karar != &"ret"
	_dene(not sonuc.get("engellendi", false) and iz.kaynak == "chr" and iz.karar == String(karar),
		"%s/%s kararı Söz motorunda tamamlandı." % [id, karar])
	_dene(GelenAkisi.kapi_cikisi_yapildi_mi(o, id), "%s/%s sonraki ziyaret için kapıdan çıktı." % [id, karar])
	_dene(sonra.nufus == once.nufus + int(kalir) and (not kalir or (koylu != null and koylu.adli_id == id)),
		"%s/%s doğru iş gücü sonucu." % [id, karar])
	_dene(sonra.ret == once.ret + int(not kalir), "%s/%s doğru ret sayacı." % [id, karar])
	_dene(sonra.gida == maxi(0, once.gida + int(beklenen.get("Erzak", 0))), "%s/%s doğru gıda sonucu." % [id, karar])
	if karar == &"rusvet":
		_dene(sonra.muhafiz_akce - once.muhafiz_akce == int(teklif.get("muhafiz_akce", 0)), "%s rüşvet akçesi doğru kesede." % id)
		_dene(sonra.esya - once.esya == (teklif.get("esyalar", []) as Array).size(), "%s rüşvet eşyası mevcut veriden." % id)
	_kol_sayisi += 1
	print("CHR_KADRO_DAL ", JSON.stringify({"chr": String(id), "tohum": tohum, "karar": String(karar),
		"once": once, "sonra": sonra, "karar_verisi": beklenen, "koylu_id": sonuc.get("koylu_id", -1), "iz": iz}))


func _sorgu_satiri(motor: SozMotoru, sorgu: ChrSorgusu) -> void:
	var dugum := sorgu.karakter.diyalog_dugumu(sorgu.dugum_id)
	var replik := String(dugum.replik_anahtari)
	var metin := motor.kapi_satir(replik)
	_dene(not metin.is_empty() and "[KEY_NOT_FOUND]" not in metin, "Sorgu satırı motor üzerinden gösterildi: " + replik)


func _koy(o: Oturum) -> Dictionary:
	return {"nufus": o.yonetim.nufus(), "ret": o.yonetim.ret_sayisi, "gida": o.yonetim.kaynaklar.miktar("gida"),
		"muhafiz_akce": o.muhafiz_akce, "esya": o.muhafiz_esyalari.size(), "asayis": o.yonetim.asayis_riski}


func _dene(kosul: bool, mesaj: String) -> bool:
	if not kosul:
		_hatalar.append(mesaj)
		push_error(mesaj)
	return kosul
