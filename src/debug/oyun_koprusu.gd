class_name OyunKoprusu
extends Node
## ADM-16: salt okunur oyuncu durumu + mevcut UI sinyalleri. Yönetici hileleri yok.

var ana: Ana
var _mesgul := false
var _son_kimligi := ""

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if is_instance_valid(ana):
		ana.child_entered_tree.connect(_ekran_izle)
		for c in ana.get_children(): _ekran_izle(c)

func _ekran_izle(c: Node) -> void:
	if c is KoyEkrani:
		c.oturum_bitti.connect(func(son: StringName) -> void: _son_kimligi = String(son))
	elif c is KapiEkrani:
		c.oturum_bitti.connect(func(_kirilan: int) -> void: _son_kimligi = "halk_kirildi")

static func port_oku(argumanlar: PackedStringArray, ortam: String) -> int:
	return preload("res://src/debug/kopru_portu.gd").oku(argumanlar, ortam)

static func bagla(kok: Ana) -> void:
	var p := port_oku(OS.get_cmdline_user_args(), OS.get_environment("BRIDGE_PORT"))
	if p == 0: return
	var kopru := OyunKoprusu.new()
	kopru.ana = kok
	kok.add_child(kopru)
	# Python tester normal oyuncunun kayıtlarını silmez. Yalnız açık köprü oturumunda.
	var klasor := OS.get_environment("BRIDGE_TESTER_DIR")
	if not klasor.is_empty():
		DirAccess.make_dir_recursive_absolute(klasor)
		kok.kayit = GuvenliKayit.new(klasor.path_join("savegame.json"))
		for c in kok.get_children():
			if c is AdminHud:
				c.anlik_goruntu.arac.slot = GuvenliKayit.new(klasor.path_join("snapshot.json"))
	var tcp := preload("res://bridge/godot/bridge.gd").new()
	tcp.handler = kopru
	kopru.add_child(tcp)
	tcp.start(p)

func run_command(cmd: String, args: Dictionary = {}) -> Dictionary:
	if cmd == "ping": return {"pong": true, "surum": 1}
	if cmd == "get_state": return get_state()
	if _mesgul: return hata("Önceki eylem tamamlanıyor; get_state ile bekleyin.")
	if not is_instance_valid(ana) or not is_instance_valid(ana._ekran): return hata("Ana ekran hazır değil.")
	if cmd == "quit":
		get_tree().create_timer(0.2).timeout.connect(func() -> void: Ses.cik())
		return {"ok": true}
	if cmd == "screenshot": return await _screenshot(args)
	if ana._kapi_yukleniyor: return hata("Ekran yükleniyor; get_state ile bekleyin.")
	_mesgul = true
	var sonuc: Dictionary
	match cmd:
		"yeni_oyun":
			if not _tam_sayi(args.get("tohum", 0)): sonuc = hata("tohum tam sayı olmalı.")
			elif ana._ust != null: sonuc = hata("Önce açık üst ekranı kapatın.")
			elif not ana._ekran is MenuEkrani and not _son_mu(): sonuc = hata("Yeni oyun yalnız menü/son ekranında başlatılır.")
			else:
				_son_kimligi = ""
				ana.yeni_oyun(int(args.get("tohum", 0)))
				sonuc = {"ok": true}
		"kapi_karar": sonuc = _kapi_karar(args)
		"soru_sor": sonuc = _soru(args)
		"koy_eylem": sonuc = _koy_eylem(args)
		"gece_bitir": sonuc = _gece_bitir()
		"devam": sonuc = _devam(args)
		"kaydet", "yukle": sonuc = await _kayit(cmd)
		_: sonuc = hata("Bilinmeyen komut: " + cmd)
	await get_tree().process_frame
	_mesgul = false
	return sonuc

static func hata(metin: String) -> Dictionary:
	return {"error": metin}

static func _tam_sayi(v: Variant) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and abs(float(v)) < 9007199254740992.0

static func dugmeler(kok: Node) -> Array[BaseButton]:
	var sonuc: Array[BaseButton] = []
	if not is_instance_valid(kok): return sonuc
	for c in kok.find_children("*", "BaseButton", true, false):
		if c.is_visible_in_tree() and not c.disabled and _canli(c): sonuc.append(c)
	return sonuc

static func _canli(n: Node) -> bool:
	while n != null:
		if n.is_queued_for_deletion(): return false
		n = n.get_parent()
	return true

static func _dugme_metni(b: BaseButton) -> String:
	return (b as Button).text if b is Button else b.tooltip_text

static func metinler(kok: Node) -> PackedStringArray:
	var sonuc := PackedStringArray()
	if not is_instance_valid(kok): return sonuc
	for c in kok.find_children("*", "", true, false):
		if c is Control and (not c.is_visible_in_tree() or not _canli(c)): continue
		if c is RichTextLabel: sonuc.append(c.get_parsed_text())
		elif c is Label: sonuc.append(c.text)
	return sonuc

func _son_mu() -> bool:
	return ana._ekran is BilgiEkrani and not ana._ekran is MenuEkrani and ana._ekran.sayi >= 0

func _secim_koku() -> Node:
	if ana._ust != null: return ana._ust
	var e := ana._ekran
	if e is KoyEkrani:
		if e.mini_oyun != null: return e.mini_oyun
		return e._ust_kart
	if e is KapiEkrani:
		if e._heybe_paneli != null: return e._heybe_paneli
		if e.has_node("ChrInceleme"):
			var panel := e.get_node("ChrInceleme")
			return panel.get_node("EsyaDetayKarti") if panel.has_node("EsyaDetayKarti") else panel
		return e._secenekler
	return e

func get_state() -> Dictionary:
	if not is_instance_valid(ana) or not is_instance_valid(ana._ekran): return {"ekran": "menu", "hazir": false}
	var e := ana._ekran
	var faz := "menu"
	if e is KapiEkrani: faz = "kapi"
	elif e is KoyEkrani: faz = "rapor" if e._ust_kart != null or e.mini_oyun != null else "koy"
	elif _son_mu(): faz = "son"
	elif e is BilgiEkrani and not e is MenuEkrani: faz = "rapor"
	var r := {"ekran": faz, "faz": faz, "hazir": not ana._kapi_yukleniyor, "mesgul": _mesgul, "secenekler": [], "rapor_satirlari": []}
	var kok := _secim_koku()
	var bs := dugmeler(kok)
	for i in bs.size(): r.secenekler.append({"indeks": i, "metin": _dugme_metni(bs[i])})
	r["panel_metni"] = metinler(kok)
	if faz == "rapor": r.rapor_satirlari = metinler(kok)
	var o := ana.oturum
	if o == null: return r
	var kanca = preload("res://src/debug/ilk_saat_kancasi.gd")
	r["ILKSAAT"] = kanca.satirlar(o)
	r["ILKSAAT_ARACLAR"] = kanca.araclar(o)
	var barlar := {}
	for i in 4: barlar[["halk", "soylular", "tuccarlar", "ordu"][i]] = o.gosterge(i)
	r.merge({"gun": o.gun, "gece": o.gosterilen_gece(), "tamamlanan_gece": o.gun, "perde": o.perde,
		"tohum": str(o.tohum), "barlar": barlar, "akce": {"koy": o.koy_akce, "muhafiz": o.muhafiz_akce},
		"erzak": o.ambar, "ambar": o.yonetim.kaynaklar.stok.duplicate(),
		"rusvet_keseleri": {"kisisel_akce": o.muhafiz_akce, "alinan_rusvet_sayisi": int(o.bayraklar.get(&"rusvet_sayisi", 0))}})
	if e is KapiEkrani:
		r["evre"] = String(e.evre)
		r["eylemler"] = []
		var eylem_bs := dugmeler(e._eylemler)
		for i in eylem_bs.size(): r.eylemler.append({"indeks": i, "metin": _dugme_metni(eylem_bs[i])})
		r["hazir"] = r.hazir and e.evre in [&"sohbet", &"karar", &"sira", &"is"]
		r["kisi"] = _kisi(e)
	if e is KoyEkrani: r["koy"] = _koy_durumu(e)
	if e is KoyEkrani and e.has_node("KapiAcilisSunumu"): r["hazir"] = false
	if faz == "son":
		var kimlik := _son_kimligi if not _son_kimligi.is_empty() else o.yonetim.son
		if kimlik.is_empty(): kimlik = "halk_kirildi"
		var nihai: String = preload("res://src/sistemler/nihai_son.gd").son(o, StringName(kimlik))
		r["son"] = {"kimlik": nihai if not nihai.is_empty() else kimlik, "baslik": e.baslik, "metin": e.metin}
	return r

func _kisi(k: KapiEkrani) -> Dictionary:
	if k._gelen == null: return {}
	var g := k._gelen
	var kararlar: Array[String] = []
	if k.evre == &"karar":
		for i in k._karar_dugmeleri.size():
			var b := k._karar_dugmeleri[i]
			if b.is_visible_in_tree() and not b.disabled: kararlar.append(k._karar_anahtarlari[i])
	var kalan := maxi(0, mini(g.soru_siniri(ana.oturum.ayarlar.azami_soru), g.sorular.size()) - k._sorulan.size())
	if g.chr_sorgusu() != null: kalan = -1 # CHR bir soru kotası değil dallanan diyalog ağacı kullanır.
	return {"ad": k._ad.text, "sinif": k._sinif.text, "gorunen_ipuclari": metinler(k._secenekler),
		"konusma": k._kayit.get_parsed_text(), "kalan_soru_hakki": kalan, "kararlar": kararlar,
		"sorular": get_sorular(k), "sirada": k._kuyruk.size()}

func get_sorular(k: KapiEkrani) -> Array:
	var sonuc: Array = []
	if k.evre != &"sohbet": return sonuc
	var bs := dugmeler(k._secenekler)
	for i in bs.size(): sonuc.append({"indeks": i, "metin": _dugme_metni(bs[i])})
	return sonuc

func _koy_durumu(k: KoyEkrani) -> Dictionary:
	var y := k.oturum.yonetim
	var r := {"nufus": y.nufus(), "yatak": y.yatak_kapasitesi(), "binalar": [], "bosta": [], "kurulabilir": []}
	for b in y.binalar:
		r.binalar.append({"id": b.id, "tur": b.tur, "hucre": [b.hucre.x, b.hucre.y], "hazir": b.hazir(),
			"slot": y.katalog.slot(b.tur), "calisan": y.calisanlar(b.id).size(), "yatak": b.yatak(y.katalog)})
	for kisi in y.bostakiler():
		var atamalar: Array[int] = []
		for b in y.binalar:
			if b.hazir() and y.katalog.slot(b.tur) > y.calisanlar(b.id).size() and YasRolleri.atanabilir(kisi, b.tur) and not KarantinaYoneticisi.aktif(kisi) and not KervanKorumasi.disarida(y, kisi.id):
				atamalar.append(b.id)
		r.bosta.append({"id": kisi.id, "ad": kisi.ad, "sinif": String(kisi.sinif), "atanabilir_binalar": atamalar})
	for kategori in KoyEkrani.KATEGORILER:
		for tur in y.katalog.kategoridekiler(kategori):
			if not y.katalog.veri(tur).get("kurulabilir", true): continue
			var uygun: Array = []
			# Salt okunur yerleşim önizlemesi; ilk 16 yasal hücre karar için yeterli.
			for yy in y.izgara.boyut.y:
				for xx in y.izgara.boyut.x:
					if uygun.size() < 16 and y.yerlesim(tur, Vector2i(xx, yy))["olur"]: uygun.append([xx, yy])
			r.kurulabilir.append({"tur": tur, "maliyet": y.katalog.maliyet(tur).duplicate(), "hucreler": uygun})
	return r

func _kapi_karar(args: Dictionary) -> Dictionary:
	if not ana._ekran is KapiEkrani or ana._ust != null: return hata("Kapı karar ekranı gerekli.")
	var k := ana._ekran as KapiEkrani
	var karar: Variant = args.get("karar")
	if not karar is String or karar not in ["kabul", "ret", "rusvet", "kisla", "harc", "elkoy"]: return hata("Geçersiz karar.")
	if k.evre != &"karar" or k._heybe_paneli != null or k.has_node("ChrInceleme"): return hata("Önce sohbet/incelemeyi UI seçenekleriyle tamamlayın.")
	for i in k._karar_anahtarlari.size():
		if k._karar_anahtarlari[i] == karar:
			var b := k._karar_dugmeleri[i]
			if b.disabled or not b.is_visible_in_tree(): return hata("Karar kilitli veya henüz görünmüyor.")
			b.pressed.emit()
			b.pressed.emit()
			return {"ok": true, "karar": karar}
	return hata("Bu kişi için karar seçeneği yok.")

func _soru(args: Dictionary) -> Dictionary:
	if not ana._ekran is KapiEkrani or ana._ust != null: return hata("Kapı sohbeti gerekli.")
	var k := ana._ekran as KapiEkrani
	if k.evre != &"sohbet" or k._heybe_paneli != null or k.has_node("ChrInceleme"): return hata("Sohbet şu anda açık değil.")
	return _bas(k._secenekler, args)

func _bas(kok: Node, args: Dictionary) -> Dictionary:
	var i: Variant = args.get("indeks", 0)
	if not _tam_sayi(i): return hata("indeks tam sayı olmalı.")
	var bs := dugmeler(kok)
	if int(i) < 0 or int(i) >= bs.size(): return hata("Görünür ve etkin seçenek bulunamadı; get_state okuyun.")
	bs[int(i)].pressed.emit()
	return {"ok": true}

func _devam(args: Dictionary) -> Dictionary:
	if ana._ekran is KoyEkrani and ana._ekran.mini_oyun != null:
		ana._ekran.mini_oyun.bas()
		return {"ok": true, "mini_oyun": true}
	if ana._ekran is KapiEkrani and args.get("alan", "secenek") == "eylem":
		var k := ana._ekran as KapiEkrani
		if ana._ust != null or k._heybe_paneli != null or k.has_node("ChrInceleme"): return hata("Açık paneli önce kapatın.")
		return _bas(k._eylemler, args)
	return _bas(_secim_koku(), args)

func _gece_bitir() -> Dictionary:
	if not ana._ekran is KoyEkrani or ana._ust != null: return hata("Köy ekranı gerekli.")
	var k := ana._ekran as KoyEkrani
	if k._ust_kart != null or k.mini_oyun != null or k._gece_dugmesi.disabled or k.has_node("KapiAcilisSunumu"): return hata("Önce açık kartı tamamlayın; gece zaten çözülmüş olabilir.")
	var gun := k.oturum.gun
	k._gece_dugmesi.pressed.emit()
	if k.has_node("KapiAcilisSunumu"): return {"ok": true, "acilis": true}
	if k._ust_kart != null and k.oturum.gun == gun:
		return {"ok": true, "karar_bekliyor": true}
	return {"ok": true} if k.oturum.gun == gun + 1 else hata("Gece geçişi bekleyen meclis/cenaze nedeniyle kilitli.")

func _koy_eylem(args: Dictionary) -> Dictionary:
	if not ana._ekran is KoyEkrani or ana._ust != null: return hata("Köy yönetimi gerekli.")
	var k := ana._ekran as KoyEkrani
	if k._ust_kart != null or k.mini_oyun != null or k._gece_dugmesi.disabled or k.has_node("KapiAcilisSunumu"): return hata("Açık kart/gece kilidi varken köy eylemi yapılamaz.")
	var y := k.oturum.yonetim
	match args.get("tur", ""):
		"insa":
			var tur: Variant = args.get("bina")
			var h: Variant = args.get("hucre")
			var yon: Variant = args.get("yon", 0)
			if not tur is String or not y.katalog.var_mi(tur) or y.katalog.kategori(tur) not in KoyEkrani.KATEGORILER or not y.katalog.veri(tur).get("kurulabilir", true): return hata("UI kataloğunda kurulabilir bina türü gerekli.")
			if not h is Array or h.size() != 2 or not _tam_sayi(h[0]) or not _tam_sayi(h[1]) or not _tam_sayi(yon) or int(yon) not in [0, 1]: return hata("hucre [x,y] tam sayıları ve yon 0|1 gerekli.")
			if int(h[0]) < 0 or int(h[1]) < 0 or int(h[0]) >= y.izgara.boyut.x or int(h[1]) >= y.izgara.boyut.y: return hata("Hücre köy ızgarasının dışında.")
			var yer := Vector2i(int(h[0]), int(h[1]))
			var uygun := y.yerlesim(tur, yer, int(yon))
			if not uygun["olur"]: return hata("İnşa yapılamaz: " + String(uygun["neden"]))
			k._kip_sec("insa", tur)
			k._imlec = yer
			k._yon = int(yon)
			k._tikla()
			return {"ok": true}
		"ata", "kaldir":
			if args.tur == "kaldir" and not args.has("koylu"):
				if not _tam_sayi(args.get("bina")): return hata("bina kimliği tam sayı olmalı.")
				var hedef := y.bina(int(args.bina))
				if hedef == null: return hata("Bina bulunamadı.")
				k._secili_bina = hedef.id
				k._bilgi_goster()
				for dugme in dugmeler(k._bilgi_icerik):
					if dugme is Button and dugme.text == tr("koy.arac.yik"):
						var id := hedef.id
						dugme.pressed.emit()
						return {"ok": true} if y.bina(id) == null else hata("Bina kaldırılamadı.")
				return hata("Bina kaldırma düğmesi UI'da mevcut değil.")
			if not _tam_sayi(args.get("koylu")) or not _tam_sayi(args.get("bina")): return hata("koylu ve bina kimlikleri tam sayı olmalı.")
			var kisi := y.koylu(int(args.koylu))
			var b := y.bina(int(args.bina))
			if kisi == null or b == null: return hata("Köylü/bina bulunamadı.")
			if args.tur == "ata" and not kisi in y.bostakiler(): return hata("Atama için boşta köylü gerekli.")
			if args.tur == "kaldir" and kisi.is_yeri != b.id: return hata("Köylü bu binada çalışmıyor.")
			k._secili_bina = b.id
			k._bilgi_goster()
			var bs := dugmeler(k._bilgi_icerik)
			for dugme in bs:
				if not dugme is Button: continue
				if args.tur == "ata" and dugme.text.begins_with(kisi.ad + "  ·"):
					dugme.pressed.emit()
					return {"ok": true} if kisi.is_yeri == b.id else hata("Oyuncu ataması reddedildi (yaş/karantina/kapasite).")
				if args.tur == "kaldir" and dugme.text == tr("koy.bilgi.cikar"):
					# Aynı adlı düğmelerden doğru çalışanın satırını seç.
					var yazilar := metinler(dugme.get_parent().get_parent())
					if not yazilar.is_empty() and yazilar[0].begins_with(kisi.ad + "  ·"):
						dugme.pressed.emit()
						return {"ok": true} if kisi.is_yeri == KoyYonetimi.BOSTA else hata("Çalışan çıkarılamadı.")
			return hata("Bu atama/çıkarma düğmesi UI'da mevcut değil.")
	return hata("tur insa|ata|kaldir olmalı.")

func _kayit(cmd: String) -> Dictionary:
	for c in ana.get_children():
		if c is AdminHud:
			var p: AnlikGoruntuPaneli = c.anlik_goruntu
			p.yenile()
			var b: Button = p.kaydet if cmd == "kaydet" else p.geri
			if b.disabled: return hata("Kayıt için canlı kapı/köy, yükleme için mevcut kayıt noktası ve kapalı kartlar gerekli.")
			if cmd == "kaydet": p._al()
			else:
				var eski := ana.oturum
				await p._don()
				if p.son_rapor.get("ok", false):
					preload("res://src/debug/ilk_saat_kancasi.gd").aktar(eski, ana.oturum)
			return {"ok": true} if p.son_rapor.get("ok", false) else hata(p.son_rapor.get("neden", "Kayıt işlemi başarısız."))
	return hata("Kayıt UI bağlantısı bulunamadı.")

func _screenshot(args: Dictionary) -> Dictionary:
	if DisplayServer.get_name() == "headless": return hata("screenshot için pencereli oyun gerekli.")
	var yol: Variant = args.get("yol", "work/tester/screenshot.png")
	if not yol is String or yol.is_empty() or not yol.ends_with(".png"): return hata("yol bir PNG dosyası olmalı.")
	var tam := ProjectSettings.globalize_path(yol if yol.is_absolute_path() or yol.begins_with("user://") else "res://" + yol)
	if DirAccess.make_dir_recursive_absolute(tam.get_base_dir()) != OK: return hata("Görüntü klasörü açılamadı.")
	await RenderingServer.frame_post_draw
	var resim := get_viewport().get_texture().get_image()
	if resim == null or resim.is_empty(): return hata("Viewport görüntüsü hazır değil.")
	var err := resim.save_png(tam)
	return {"ok": true, "yol": tam, "boyut": [resim.get_width(), resim.get_height()]} if err == OK else hata("PNG yazılamadı: %d" % err)
