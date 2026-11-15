## AYR-52: altı sekme, anahtar gidiş-dönüş, dosya ve üç yuva.
extends Node

const YOL := "user://oto_ayarlar_kontrol.cfg"
const KOK := "user://oto_ayar_yuva/"
const Sekmeler = preload("res://src/arayuz/ayarlar/ayar_sekmeleri.gd")
const Yuva = preload("res://src/sistemler/kayit_yuvalari.gd")

var hata := 0


func _ready() -> void:
	_temizle()
	_kontrol(Sekmeler.sekme_sayisi() == 6, "altı sekme")
	for yol in Sekmeler.betikler():
		var betik := load(yol) as GDScript
		_kontrol(betik != null, "sekme yüklenir " + yol)
		var sayfa: Control = betik.new()
		_kontrol(sayfa != null, "sekme örneği " + yol)
		sayfa.free()
	var a := Ayarlar.new(YOL)
	a.yukle()
	AyarlarEk.bagla(a)
	var once: Dictionary = a.degerler.duplicate(true)
	for anahtar in AyarlarEk.VARSAYILAN:
		var liste: Array = AyarlarEk.GECERLI[anahtar]
		var simdiki: Variant = a.al(anahtar)
		var diger: Variant = liste[0] if simdiki != liste[0] else liste[1]
		_kontrol(AyarlarEk.ayarla(a, anahtar, diger), "anahtar değişir " + String(anahtar))
		_kontrol(AyarlarEk.ayarla(a, anahtar, simdiki), "anahtar geri alınır " + String(anahtar))
	a.yaz()
	var b := Ayarlar.new(YOL)
	b.yukle()
	AyarlarEk.bagla(b)
	var esit := true
	for anahtar in AyarlarEk.VARSAYILAN:
		if b.al(anahtar) != once[anahtar]:
			esit = false
	_kontrol(esit, "dosya yazılıp okununca değerler eşit")
	AyarlarEk.ayarla(b, &"zorluk", &"siki")
	b.ayarla(&"ses_ana", 2)
	b.degerler[&"surum"] = 9
	b.degerler[&"ileri_ayar"] = "korunur"
	b.varsayilana_don()
	_kontrol(b.al(&"zorluk") == &"olagan" and b.al(&"ses_ana") == 8, "sıfırlama sonrası yeni oyun zorluğu ve ses varsayılan")
	_kontrol(b.al(&"surum") == 9 and b.al(&"ileri_ayar") == "korunur", "sıfırlama ileri sürüm alanlarını korur")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(KOK))
	var yuvalar := Yuva.new(KOK)
	for n in [1, 2, 3]:
		_kontrol(yuvalar.yaz(n, {"surum": Oturum.KAYIT_SURUMU, "gun": n, "nufus": n + 3, "perde": 1}), "yuva yazılır %d" % n)
		var okunan := yuvalar.oku(n)
		_kontrol(int(okunan.get("gun", -1)) == n, "yuva okunur %d" % n)
	var ana_ornek: Ana = preload("res://src/arayuz/ana.gd").new()
	ana_ornek.ayarlar = a
	ana_ornek._odak_sesini_kur()
	var odak_dugum := ana_ornek.get_node_or_null("OdakSesi") as OdakSesi
	_kontrol(odak_dugum != null, "AYR-22: Ana sahnesinde OdakSesi çocuğu kurulmalı")
	a.ayarla(&"ses_ana", 8)
	ana_ornek._notification(Node.NOTIFICATION_APPLICATION_FOCUS_OUT)
	_kontrol(int(a.al(&"ses_ana")) == 0, "AYR-22: Ana odak kaybedince ses_ana 0 olur")
	ana_ornek._notification(Node.NOTIFICATION_APPLICATION_FOCUS_IN)
	_kontrol(int(a.al(&"ses_ana")) == 8, "AYR-22: Ana odak dönünce ses_ana eski değere döner")
	var ana_yuva := Yuva.new(KOK, false)
	ana_ornek.yuvalar = ana_yuva
	ana_ornek.yuva_sec(2)
	_kontrol(ana_ornek.kayit.yol == ana_yuva.yuva_yolu(2), "AYR-28: yuva_sec(2) Ana.kayit yolunu yuva 2'ye bağlar")
	var kat := Katalog.new()
	kat.yukle()
	ana_ornek.oturum = Oturum.new(kat, 77)
	ana_ornek._kayit_yaz()
	var yuva2_veri := ana_ornek.kayit.oku()
	_kontrol(int(yuva2_veri.get("yuva", 0)) == 2 and ana_yuva.var_mi(2), "AYR-32: kayıt dosyasına seçili yuva (2) yazılır")
	ana_ornek.free()
	_temizle()
	print("AYARLAR KONTROL: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	get_tree().quit(hata)


func _temizle() -> void:
	if FileAccess.file_exists(YOL):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(YOL))


func _kontrol(olur: bool, mesaj: String) -> void:
	if not olur:
		hata += 1
		push_error(mesaj)
