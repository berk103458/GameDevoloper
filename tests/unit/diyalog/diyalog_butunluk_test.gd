# tests/unit/diyalog/diyalog_butunluk_test.gd
# Aşama D: Kapı ve Köy Diyalog Bütünlüğü, Kırık Referans ve Türkçe Karakter Doğrulama Testi
extends SceneTree

const KoyDiyalogYoneticisi = preload("res://src/diyalog/koy_diyalog_yoneticisi.gd")
const ParleyKoyAdaptoru = preload("res://src/diyalog/parley_koy_adaptoru.gd")

var hata_sayisi := 0

func dene(sart: bool, mesaj: String) -> void:
	if not sart:
		hata_sayisi += 1
		push_error("HATA: " + mesaj)
	else:
		print("  [OK] " + mesaj)


func _initialize() -> void:
	print("\n========================================================")
	print("--- [AŞAMA D: DİYALOG BÜTÜNLÜK VE DOĞRULAMA TESTİ] ---")
	print("========================================================\n")
	
	_test_kapi_diyaloglari_butunlugu()
	_test_parley_sekanslari_butunlugu()
	_test_turkce_karakter_butunlugu()
	await _test_adaptor_ve_yonetici_butunlugu()
	
	print("\n========================================================")
	if hata_sayisi == 0:
		print("--- [BÜTÜNLÜK TEST SONUCU: BAŞARILI (0 HATA)] ---")
	else:
		print("--- [BÜTÜNLÜK TEST SONUCU: BAŞARISIZ (%d HATA)] ---" % hata_sayisi)
	print("========================================================\n")
	
	quit(hata_sayisi)


func _test_kapi_diyaloglari_butunlugu() -> void:
	print("[1/4] Kapı Diyalogları Bütünlük Kontrolü (diyalog_01_20.json)...")
	var dosya_yolu := "res://data/diyalog/diyalog_01_20.json"
	dene(FileAccess.file_exists(dosya_yolu), "diyalog_01_20.json dosyası mevcut")
	
	var metin := FileAccess.get_file_as_string(dosya_yolu)
	var veri = JSON.parse_string(metin)
	dene(veri is Array, "diyalog_01_20.json geçerli bir JSON dizisi")
	if not (veri is Array):
		return
		
	var diyaloglar: Array = veri
	dene(diyaloglar.size() == 30, "Tam 30 adet kapı diyaloğu mevcut (Bulunan: %d)" % diyaloglar.size())
	
	for i in range(diyaloglar.size()):
		var d = diyaloglar[i]
		var id: String = str(d.get("id", "tanimsiz_%d" % i))
		var beklenen_id := "diyalog_%02d" % (i + 1)
		dene(id == beklenen_id, "Diyalog ID sirasi dogru: %s" % id)
		
		dene(d.has("sahne") and not str(d.sahne).is_empty(), "%s: 'sahne' metni mevcut ve dolu" % id)
		dene(d.has("sorular") and d.sorular is Array and not d.sorular.is_empty(), "%s: 'sorular' dizisi mevcut ve dolu" % id)
		dene(d.has("secenekler") and d.secenekler is Array, "%s: 'secenekler' dizisi mevcut" % id)
		dene(d.has("esik") and d.esik is Array, "%s: 'esik' dizisi mevcut" % id)
		dene(d.has("yanitlar") and d.yanitlar is Dictionary, "%s: 'yanitlar' sözlüğü mevcut" % id)
		
		if d.secenekler is Array and d.esik is Array:
			dene(d.secenekler.size() == d.esik.size(), "%s: seçenekler sayısı eşik sayısına eşit (%d == %d)" % [id, d.secenekler.size(), d.esik.size()])
			
		if d.secenekler is Array and d.yanitlar is Dictionary:
			for sec in d.secenekler:
				var sec_str: String = str(sec)
				dene(d.yanitlar.has(sec_str), "%s: '%s' seçeneğinin yanıtı yanitlar sözlüğünde mevcut" % [id, sec_str])
				if d.yanitlar.has(sec_str):
					dene(not str(d.yanitlar[sec_str]).is_empty(), "%s: '%s' yanıt metni boş değil" % [id, sec_str])
					
		if d.yanitlar is Dictionary:
			dene(d.yanitlar.has("kabul"), "%s: 'kabul' yanıtı mevcut" % id)
			dene(d.yanitlar.has("ret"), "%s: 'ret' yanıtı mevcut" % id)
			
			if d.yanitlar.has("kabul"):
				var kabul_metni: String = str(d.yanitlar["kabul"])
				var kervan_reg := RegEx.create_from_string("(?i)kervanla (birlikte )?çık|kervan toplanırsa|çıkar giderim|yoluma koyulurum|ilk kervanla")
				dene(kervan_reg.search(kabul_metni) == null, "%s: 'kabul' metni yerleşimci temasına uygun (kervanla kaçış yok)" % id)
				
		if id == "diyalog_08":
			var ret_idx: int = d.secenekler.find("ret")
			if ret_idx != -1 and d.esik is Array and ret_idx < d.esik.size():
				dene(int(d.esik[ret_idx]) == 0, "diyalog_08 ret eşiği 0 kuralına uygun")


func _test_parley_sekanslari_butunlugu() -> void:
	print("\n[2/4] Köy Parley Sekansları Ağaç ve Referans Kontrolü (.ds)...")
	var ds_dosyalari := [
		"res://data/parley/koy/koylu_muhabbet_genel.ds",
		"res://data/parley/koy/koylu_muhabbet_yusuf.ds",
		"res://data/parley/koy/koylu_muhabbet_miraen.ds",
		"res://data/parley/koy/koylu_muhabbet_karaca_usta.ds",
		"res://data/parley/koy/koylu_muhabbet_ayse_baci.ds",
		"res://data/parley/koy/koylu_muhabbet_aydogdu.ds",
		"res://data/parley/koy/koylu_muhabbet_saruca_hatun.ds",
		"res://data/parley/koy/koylu_muhabbet_thessra.ds",
		"res://data/parley/koy/koylu_muhabbet_sorhan.ds",
		"res://data/parley/koy/koylu_muhabbet_hasan_celebi.ds",
		"res://data/parley/koy/koylu_muhabbet_nogay.ds",
		"res://data/parley/koy/koylu_muhabbet_es.ds",
		"res://data/parley/koy/sekans_degirmen_kitlik.ds",
		"res://data/parley/koy/sekans_meydan_atesi.ds",
		"res://data/parley/koy/sekans_demirhane_pusat.ds",
		"res://data/parley/koy/sekans_kuyu_hastalik.ds",
		"res://data/parley/koy/sekans_nobet_harami.ds",
		"res://data/parley/koy/sekans_pazar_fiskos.ds"
	]
	
	for ds_yolu in ds_dosyalari:
		dene(FileAccess.file_exists(ds_yolu), "Parley dosyası mevcut: %s" % ds_yolu)
		var ast: ParleyDialogueSequenceAst = KoyDiyalogYoneticisi.sekans_yukle(ds_yolu)
		dene(ast != null, "AST başarıyla derlendi: %s" % ds_yolu)
		if not ast:
			continue
			
		dene(not ast.nodes.is_empty(), "%s: Düğümler mevcut (%d adet)" % [ds_yolu.get_file(), ast.nodes.size()])
		dene(not ast.edges.is_empty(), "%s: Kenarlar (bağlantılar) mevcut (%d adet)" % [ds_yolu.get_file(), ast.edges.size()])
		
		# 1. Kırık Bağlantı (Dangling Edge) Kontrolü
		var node_ids := {}
		var start_node_id := ""
		for node in ast.nodes:
			node_ids[node.id] = node
			if node is ParleyStartNodeAst:
				start_node_id = node.id
				
		dene(not start_node_id.is_empty(), "%s: START düğümü mevcut (%s)" % [ds_yolu.get_file(), start_node_id])
		
		var kirik_baglanti := false
		for edge in ast.edges:
			if not node_ids.has(edge.from_node):
				push_error("KIRIK BAĞLANTI (from_node): %s -> %s" % [edge.from_node, edge.to_node])
				kirik_baglanti = true
			if not node_ids.has(edge.to_node):
				push_error("KIRIK BAĞLANTI (to_node): %s -> %s" % [edge.from_node, edge.to_node])
				kirik_baglanti = true
		dene(not kirik_baglanti, "%s: Sıfır kırık bağlantı (tüm from_node ve to_node'lar kayıtlı)" % ds_yolu.get_file())
		
		# 2. Ulaşılamayan Düğüm (Unreachable Node) Kontrolü (BFS ile)
		if not start_node_id.is_empty():
			var ziyaret_edilen := {}
			var kuyruk := [start_node_id]
			ziyaret_edilen[start_node_id] = true
			
			while not kuyruk.is_empty():
				var mevcut_id: String = kuyruk.pop_front()
				for edge in ast.edges:
					if edge.from_node == mevcut_id and not ziyaret_edilen.has(edge.to_node):
						ziyaret_edilen[edge.to_node] = true
						kuyruk.append(edge.to_node)
						
			var yetim_dugumler: Array[String] = []
			for nid in node_ids.keys():
				if not ziyaret_edilen.has(nid):
					yetim_dugumler.append(nid)
			dene(yetim_dugumler.is_empty(), "%s: Tüm düğümlere START'tan erişilebiliyor (Yetim düğüm yok: %s)" % [ds_yolu.get_file(), str(yetim_dugumler)])
			
		# 3. Fact ve Action Script Referanslarının Varlığı Kontrolü
		for node in ast.nodes:
			if node is ParleyConditionNodeAst:
				var cnode: ParleyConditionNodeAst = node
				for cond in cnode.conditions:
					var fref: String = str(cond.get("fact_ref", ""))
					dene(ResourceLoader.exists(fref), "%s: Fact referansı diskte mevcut (%s)" % [ds_yolu.get_file(), fref])
			elif node is ParleyActionNodeAst:
				var anode: ParleyActionNodeAst = node
				var aref: String = anode.action_script_ref
				dene(ResourceLoader.exists(aref), "%s: Action referansı diskte mevcut (%s)" % [ds_yolu.get_file(), aref])


func _test_turkce_karakter_butunlugu() -> void:
	print("\n[3/4] Türkçe Karakter (ç, ğ, ı, İ, ö, ş, ü) Bütünlük Kontrolü...")
	var test_harfleri := ["ç", "ğ", "ı", "İ", "ö", "ş", "ü", "Ç", "Ğ", "Ö", "Ş", "Ü"]
	
	# Kapı diyalogları metni
	var kapi_metni := FileAccess.get_file_as_string("res://data/diyalog/diyalog_01_20.json")
	for harf in ["ç", "ğ", "ı", "İ", "ö", "ş", "ü"]:
		dene(kapi_metni.contains(harf), "Kapı diyaloglarında Türkçe karakter korundu: '%s'" % harf)
		
	# Köy Parley metinleri
	var ds_dosyalari := [
		"res://data/parley/koy/koylu_muhabbet_genel.ds",
		"res://data/parley/koy/koylu_muhabbet_yusuf.ds",
		"res://data/parley/koy/koylu_muhabbet_miraen.ds",
		"res://data/parley/koy/koylu_muhabbet_karaca_usta.ds",
		"res://data/parley/koy/koylu_muhabbet_ayse_baci.ds",
		"res://data/parley/koy/koylu_muhabbet_aydogdu.ds",
		"res://data/parley/koy/koylu_muhabbet_saruca_hatun.ds",
		"res://data/parley/koy/koylu_muhabbet_thessra.ds",
		"res://data/parley/koy/koylu_muhabbet_sorhan.ds",
		"res://data/parley/koy/koylu_muhabbet_hasan_celebi.ds",
		"res://data/parley/koy/koylu_muhabbet_nogay.ds",
		"res://data/parley/koy/sekans_degirmen_kitlik.ds",
		"res://data/parley/koy/sekans_meydan_atesi.ds",
		"res://data/parley/koy/sekans_demirhane_pusat.ds",
		"res://data/parley/koy/sekans_kuyu_hastalik.ds",
		"res://data/parley/koy/sekans_nobet_harami.ds",
		"res://data/parley/koy/sekans_pazar_fiskos.ds"
	]
	var parley_toplam_metin := ""
	for ds in ds_dosyalari:
		parley_toplam_metin += FileAccess.get_file_as_string(ds) + " "
		
	for harf in ["ç", "ğ", "ı", "İ", "ö", "ş", "ü"]:
		dene(parley_toplam_metin.contains(harf), "Köy Parley dosyalarında Türkçe karakter korundu: '%s'" % harf)


func _test_adaptor_ve_yonetici_butunlugu() -> void:
	print("\n[4/4] Adaptör ve Diyalog Yöneticisi Uçtan Uca Doğrulama Kontrolü...")
	
	# ParleyKoyAdaptoru boş/null koruması testi
	var bos_baglam = ParleyKoyAdaptoru.baglam_olustur(null, null)
	dene(bos_baglam is Dictionary and bos_baglam.has("moral"), "Adaptor null koylu ve yonetim ile guvenli calisiyor")
	
	ParleyKoyAdaptoru.etkileri_uygula(bos_baglam, null, null)
	dene(true, "Adaptor etkileri_uygula null nesnelerle guvenli sonlandi")
	
	# KoyDiyalogYoneticisi orkestrasyonu testi
	var dy = KoyDiyalogYoneticisi.new()
	var sonuc_durumu := {
		"replik_adeti": 0,
		"son_konusan": "",
		"secenek_mevcut": false
	}
	
	dy.replik_geldi.connect(func(konusan: String, metin: String, secenekler: Array) -> void:
		sonuc_durumu["replik_adeti"] += 1
		sonuc_durumu["son_konusan"] = konusan
		sonuc_durumu["secenek_mevcut"] = not secenekler.is_empty()
	)
	
	# Yusuf özel sekansını koştur
	var yusuf := Koylu.new()
	yusuf.id = 2
	yusuf.ad = "Yusuf"
	yusuf.moral = 80
	
	var basladi = dy.muhabbet_baslat(yusuf, null)
	dene(basladi, "Yusuf özel muhabbeti basariyla baslatildi")
	await create_timer(0.2).timeout
	
	dene(sonuc_durumu["replik_adeti"] > 0, "Yusuf muhabbeti ilk repligi verdi (Adet: %d)" % sonuc_durumu["replik_adeti"])
	dene(sonuc_durumu["son_konusan"] == "Yusuf", "Konuşan karakter ismi doğru: %s" % sonuc_durumu["son_konusan"])
	dene(sonuc_durumu["secenek_mevcut"], "Yusuf muhabbetinde secenekler sunuldu")
	
	dy.bitir()
	dene(not dy.calisiyor, "Yusuf muhabbeti duzgun kapatildi")
	
	# Miraen adlı köylü muhabbeti testi
	var miraen := Koylu.new()
	miraen.id = 3
	miraen.ad = "Miraen"
	miraen.adli_id = &"miraen"
	sonuc_durumu["replik_adeti"] = 0
	var miraen_ok = dy.muhabbet_baslat(miraen, null)
	dene(miraen_ok, "Miraen adlı köylü muhabbeti baslatildi")
	await create_timer(0.2).timeout
	dene(sonuc_durumu["son_konusan"] == "Miraen", "Miraen muhabbeti doğru karakteri verdi")
	dy.bitir()
	
	# Karaca Usta adlı köylü muhabbeti testi
	var karaca := Koylu.new()
	karaca.id = 4
	karaca.ad = "Karaca Usta"
	karaca.adli_id = &"karaca_usta"
	sonuc_durumu["replik_adeti"] = 0
	var karaca_ok = dy.muhabbet_baslat(karaca, null)
	dene(karaca_ok, "Karaca Usta adlı köylü muhabbeti baslatildi")
	await create_timer(0.2).timeout
	dene(sonuc_durumu["son_konusan"] == "Karaca Usta", "Karaca Usta muhabbeti doğru karakteri verdi")
	dy.bitir()
	
	# Sekans koşturma testi (sekans_degirmen_kitlik)
	var sekans_ok = dy.sekans_baslat("sekans_degirmen_kitlik", null)
	dene(sekans_ok, "Ortam sekansı (sekans_degirmen_kitlik) baslatildi")
	await create_timer(0.2).timeout
	dene(sonuc_durumu["replik_adeti"] >= 2, "Ortam sekansı replik üretti")
	dy.bitir()
	dene(not dy.calisiyor, "Ortam sekansı duzgun kapatildi")
	
	# Eş muhabbeti testi
	var es := Koylu.new()
	es.id = 5
	es.ad = "Eş"
	es.bayrak_ekle(&"acl01_es")
	sonuc_durumu["replik_adeti"] = 0
	var es_ok = dy.muhabbet_baslat(es, null)
	dene(es_ok, "Eş adlı köylü muhabbeti baslatildi")
	await create_timer(0.2).timeout
	dene(sonuc_durumu["son_konusan"] == "Eş", "Eş muhabbeti doğru karakteri verdi")
	dy.bitir()

	# Yeni sekans koşturma testi (sekans_demirhane_pusat)
	var sekans2_ok = dy.sekans_baslat("sekans_demirhane_pusat", null)
	dene(sekans2_ok, "Yeni ortam sekansı (sekans_demirhane_pusat) baslatildi")
	await create_timer(0.2).timeout
	dy.bitir()
