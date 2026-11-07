## OGR-54: İpucu tercihi dışında eşit iki oturumun gerçek kayıt noktaları.
extends Node

const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const KAPI = preload("res://src/sistemler/kapi_acilis_olayi.gd")
const OGRETICI = preload("res://src/arayuz/kapi_acilis_ogretici.gd")
const GECE := 6
var _katalog: Katalog

func _ready() -> void:
	call_deferred("_dene")

func _dene() -> void:
	TranslationServer.set_locale("tr")
	_katalog = Katalog.new()
	_katalog.yukle()
	var acik := await _kos(true)
	var kapali := await _kos(false)
	var tamam := acik.size() == GECE + 1 and kapali.size() == GECE + 1
	for i in mini(acik.size(), kapali.size()):
		if acik[i] == kapali[i]: continue
		tamam = false
		var farklar: PackedStringArray = []
		for alan in acik[i].keys():
			if acik[i][alan] != kapali[i].get(alan): farklar.append(alan)
		push_error("İpucu ikizi, gece %d, farklı kayıt alanları: %s" % [i, ", ".join(farklar)])
	if not tamam: push_error("İpucu açık ve kapalı kayıt ikizi eşleşmedi")
	print("İPUCU KAYIT İKİZİ: %s" % ("GEÇTİ" if tamam else "KALDI"))
	get_tree().quit(0 if tamam else 1)

func _kos(ipuclari: bool) -> Array[Dictionary]:
	var o := Oturum.new(_katalog, 1401)
	ACILIS.kur(o)
	var a := Ayarlar.new()
	a.degerler[&"ipuclari"] = ipuclari
	var yuzey := Control.new()
	yuzey.theme = Tema.olustur(a)
	add_child(yuzey)
	var koy := _koy_ekrani(yuzey, o, a)
	IlkSaat.koy_hizi_ipucunu_goster(koy, o, a)
	var hiz_ipucu := koy.get_node_or_null("IpucuSeridi") as Control
	var hiz_goruldu := hiz_ipucu != null and hiz_ipucu.is_visible_in_tree()
	KAPI.baslat(o)
	KAPI.ulak_bitir(o)
	var kapi := KapiEkrani.new()
	kapi.oturum = o
	kapi.ayarlar = a
	yuzey.add_child(kapi)
	OGRETICI.kur(kapi)
	var kapi_ipucu := kapi.get_node_or_null("AcilisOgretici") as Control
	var kapi_goruldu := kapi_ipucu != null and kapi_ipucu.is_visible_in_tree()
	kapi.free()
	var anlik := DurumAnlikGoruntusu.new()
	anlik.slot = GuvenliKayit.new("user://ogr54_%d_%s.json" % [OS.get_process_id(), ipuclari])
	var noktalar: Array[Dictionary] = []
	if hiz_goruldu == ipuclari and kapi_goruldu == ipuclari and o.ipucu_kaydi.goruldu_mu("koy_hizi") == ipuclari:
		for gun in range(GECE + 1):
			if o.gun != gun or not anlik.al(o).ok: break
			var kayit := anlik.slot.oku()
			if kayit.is_empty(): break
			# Kendi görülme kaydı oyuncu tercihine bağlıdır. Diğer bütün alanlar eşit olmalı.
			kayit.erase("ogretici")
			noktalar.append(kayit)
			if gun == GECE: break
			if gun == 2:
				var yukleme := anlik.oku(_katalog)
				if not yukleme.ok: break
				koy.free()
				o = yukleme.oturum
				koy = _koy_ekrani(yuzey, o, a)
			if gun == 0:
				var kuyruk := KAPI.kuyruk(o)
				if kuyruk.is_empty(): break
				o.ziyaret_basladi(kuyruk[0])
				if not o.karar_ver(kuyruk[0], &"kabul").get("kaldi", false): break
			if o.gece_sonu().get("engellendi", false): break
			koy.hud.guncelle()
			await get_tree().process_frame
	anlik.slot.sil()
	yuzey.free()
	await get_tree().process_frame
	return noktalar

func _koy_ekrani(yuzey: Control, o: Oturum, a: Ayarlar) -> KoyEkrani:
	var koy := KoyEkrani.new()
	koy.oturum = o
	koy.ayarlar = a
	yuzey.add_child(koy)
	return koy
