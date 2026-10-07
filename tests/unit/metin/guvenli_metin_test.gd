## BUG-07 / SYS-12: eksik ya da bozuk metin anahtarı oyunu kilitlememeli.
##   godot --headless --path . -s tests/unit/metin/guvenli_metin_test.gd
extends SceneTree

var _hata := 0


func _initialize() -> void:
	call_deferred("_calistir")


func _kontrol(kosul: bool, ad: String) -> void:
	print(("  ok   " if kosul else "  HATA ") + ad)
	if not kosul:
		_hata += 1


func _calistir() -> void:
	TranslationServer.set_locale("tr")
	var gm: Variant = load("res://src/sistemler/guvenli_metin.gd")
	gm.sifirla()
	# Gerçek tablo: tüm katalog anahtarları var, oyun kilitlenmeden HAZIR açılır.
	var k: Variant = load("res://src/cekirdek/katalog.gd").new()
	_kontrol(k.yukle() == 1, "Gerçek katalog HAZIR")
	_kontrol(k.uyarilar.is_empty(), "Gerçek tabloda eksik anahtar uyarısı yok: %s" % [k.uyarilar])
	_kontrol(not gm.eksik_mi("arayuz.menu.yeni") and gm.eksik_mi("arayuz.yok.boyle"), "eksik_mi tabloyu doğru okur")

	# Sarmalayıcı: var olan metin aynı, düz metin dokunulmaz, eksik anahtar güvenli işaret.
	var once := tr("arayuz.menu.yeni")
	gm.kur()
	gm.kur()
	_kontrol(tr("arayuz.menu.yeni") == once and once != "arayuz.menu.yeni", "Var olan anahtar aynı metni verir")
	_kontrol(tr("Merhaba dünya") == "Merhaba dünya" and tr("v4.7") == "v4.7" and tr("ui_cursor.png") == "ui_cursor.png", "Düz metin/sürüm/dosya adı çevrilmez")
	_kontrol(tr("arayuz.yok.boyle") == "[KEY_NOT_FOUND] arayuz.yok.boyle", "Eksik anahtar [KEY_NOT_FOUND] gösterir")
	_kontrol("arayuz.yok.boyle" in gm.eksikler, "Eksik anahtar listelenir")
	var l := Label.new()
	l.text = "koy.yok.etiket"
	root.add_child(l)
	_kontrol(l.get("text") == "koy.yok.etiket", "Etiket kaynağı bozulmaz")
	l.queue_free()

	# Katalog: eksik anahtar artık HATALI (kilit) değil, uyarı.
	var tablo: Translation = TranslationServer.get_translation_object("tr")
	_kontrol(tablo != null and tablo.get_script() != null, "Sarmalayıcı kurulu")

	# Bozuk CSV senaryoları (hoşgörülü okuyucu).
	var r: Dictionary = gm.csv_coz("keys,tr\na.b,\"Bir, iki\"\nc.d,\"kapanmayan\ne.f,Sağlam\n")
	_kontrol(r.metinler.get("a.b") == "Bir, iki" and r.metinler.get("e.f") == "Sağlam", "Kapanmamış tırnak sonraki satırları yutmaz")
	_kontrol(r.metinler.get("c.d") == "kapanmayan" and not r.uyarilar.is_empty(), "Kapanmamış tırnak uyarı üretir")
	r = gm.csv_coz("\uFEFFkeys,tr\nsohbet.x,\"Birinci\nikinci\"\nsohbet.y,\"\"\"Alıntı\"\"\"\n")
	_kontrol(r.metinler.get("sohbet.x") == "Birinci\nikinci" and r.metinler.get("sohbet.y") == "\"Alıntı\"" and r.uyarilar.is_empty(), "Geçerli çok satırlı ve kaçışlı alan")
	r = gm.csv_coz("keys,tr\nsadece.anahtar\n,yetim\nbos.metin,\nfazla.sutun,a,b\nayni.x,1\nayni.x,2\n")
	_kontrol(not r.metinler.has("sadece.anahtar") and not r.metinler.has("bos.metin"), "Eksik sütun ve boş metin atlanır")
	_kontrol(r.metinler.get("fazla.sutun") == "a" and r.metinler.get("ayni.x") == "2", "Fazla sütun/mükerrer çökmeden okunur")
	_kontrol(r.uyarilar.size() >= 5, "Her bozuk satır için uyarı: %d" % r.uyarilar.size())
	r = gm.csv_coz("id,en\nx.y,z\n")
	_kontrol(r.metinler.is_empty() and r.uyarilar.size() == 1, "Bozuk başlık güvenle reddedilir")
	r = gm.csv_coz("")
	_kontrol(r.metinler.is_empty(), "Boş dosya çökertmez")

	# Ham CSV yedeği: içe aktarılmış tabloda olmayan ama CSV'de olan anahtar.
	_kontrol(gm.metin("arayuz.menu.yeni") == once, "metin() tablo yolunu kullanır")
	_kontrol(gm.metin("hic.yok.anahtar").begins_with("[KEY_NOT_FOUND]"), "metin() eksikte güvenli işaret")

	# Biçim dizgesinde eksik anahtar: hata günlüğü olabilir ama akış durmaz.
	var akis_devam := false
	var _s: String = tr("anlati.yok.bicim")
	akis_devam = true
	_kontrol(akis_devam and _s.begins_with("[KEY_NOT_FOUND]"), "Eksik biçim anahtarında akış sürer")

	gm.kaldir()
	_kontrol(TranslationServer.get_translation_object("tr") != null and tr("arayuz.menu.yeni") == once, "kaldir() asıl tabloyu geri koyar")

	print("GÜVENLİ METİN: " + ("GEÇTİ" if _hata == 0 else "KALDI (%d)" % _hata))
	quit(1 if _hata else 0)
