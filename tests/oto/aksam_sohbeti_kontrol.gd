## ACL-03: Gerçek KoyEkrani içinde gece raporundan önce AksamSohbetiPaneli tetik/atlama kontrolü.
extends Node

var _hata := 0


func _ready() -> void:
	get_tree().create_timer(20.0).timeout.connect(func() -> void: get_tree().quit(1))
	var katalog := Katalog.new()
	katalog.yukle()

	# 1. Ağır kararda gece raporu öncesi AksamSohbetiKart açılır, Atla ek moral/bar etkisi olmadan geceyi ilerletir
	var ekran := KoyEkrani.new()
	ekran.oturum = Oturum.new(katalog, 6101)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(ekran.oturum)
	ekran.oturum.gun = 1
	ekran.oturum.yonetim.gun = 1
	ekran.oturum.aksam_sohbeti_ekle("aileyi_bolmek", 1)
	ekran.ayarlar = Ayarlar.new()
	ekran.theme = Tema.olustur(ekran.ayarlar)
	add_child(ekran)

	var es_id := int(preload("res://src/sistemler/acilis_senaryosu.gd").durum(ekran.oturum).get("es_id", -1))
	var es := ekran.oturum.yonetim.koylu(es_id)
	var kontrol_o := Oturum.new(katalog, 6101)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(kontrol_o)
	kontrol_o.gun = 1
	kontrol_o.yonetim.gun = 1
	kontrol_o.gece_sonu()
	var es_kontrol := kontrol_o.yonetim.koylu(es_id)
	var gun_once := ekran.oturum.gun

	ekran._geceye_gec()
	_dene(ekran._ust_kart != null and ekran._ust_kart.name == "AksamSohbetiKart", "Gece raporundan önce AksamSohbetiKart açılmalı")
	_dene(ekran.oturum.gun == gun_once, "Akşam sohbeti açıkken henüz gece_sonu çalışmamalı")
	var atla_btn := ekran._ust_kart.find_child("AksamAtla", true, false) as Button
	_dene(atla_btn != null, "AksamAtla düğmesi bulunmalı")
	if atla_btn != null:
		atla_btn.pressed.emit()
	_dene(ekran.oturum.gun == gun_once + 1, "Atla sonrası gece_sonu çalışıp gün artmalı")
	if es != null and es_kontrol != null:
		_dene(es.moral == es_kontrol.moral, "Atla eş moralini ek değiştirmemeli")
	_dene(ekran.oturum.yonetim.adalet == kontrol_o.yonetim.adalet, "Atla adalet barını değiştirmemeli")
	ekran.queue_free()
	await get_tree().process_frame

	# 2. Meclis gecesinde AksamSohbetiKart açılmaz (haftalık meclis / kriz meclisi)
	var ekran2 := KoyEkrani.new()
	ekran2.oturum = Oturum.new(katalog, 6102)
	preload("res://src/sistemler/acilis_senaryosu.gd").kur(ekran2.oturum)
	var haftalik_gun := int(ekran2.oturum.yonetim.a.mevsim_gun) - 1
	ekran2.oturum.gun = haftalik_gun
	ekran2.oturum.yonetim.gun = haftalik_gun
	ekran2.oturum.aksam_sohbeti_ekle("rusvet_almak", 1)
	var md := CinarAltiMeclisi.durum(ekran2.oturum.yonetim)
	md["son_gun"] = haftalik_gun
	ekran2.oturum.yonetim.set_meta(CinarAltiMeclisi.META, md)
	ekran2.ayarlar = Ayarlar.new()
	ekran2.theme = Tema.olustur(ekran2.ayarlar)
	add_child(ekran2)
	_dene(not AksamSohbetiPaneli.ac(ekran2, func() -> void: pass), "Meclis gecesinde AksamSohbetiPaneli açılmamalı")
	ekran2.queue_free()
	await get_tree().process_frame

	print("AKSAM SOHBETI UI: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	get_tree().quit(1 if _hata > 0 else 0)


func _dene(ok: bool, msg: String) -> void:
	if not ok:
		_hata += 1
		push_error(msg)
