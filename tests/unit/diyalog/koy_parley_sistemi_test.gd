# Aşama C: Köy Parley Diyalog Sistemi ve Adaptör Testi
extends SceneTree

const KoyDiyalogYoneticisi = preload("res://src/diyalog/koy_diyalog_yoneticisi.gd")
const ParleyKoyAdaptoru = preload("res://src/diyalog/parley_koy_adaptoru.gd")
const KoyluMoralFact = preload("res://src/diyalog/facts/koylu_moral_fact.gd")
const KoyHavadisFact = preload("res://src/diyalog/facts/koy_havadis_fact.gd")
const KoyMoralAction = preload("res://src/diyalog/actions/koy_moral_action.gd")
const KoyAkceAction = preload("res://src/diyalog/actions/koy_akce_action.gd")

var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error("HATA: " + ad)
	else:
		print("  [OK] " + ad)


func _initialize() -> void:
	print("--- [KÖY PARLEY SİSTEMİ TESTİ BAŞLADI] ---")
	
	# 1. Dosya ve AST yükleme testleri
	var dosyalar := [
		"res://data/parley/koy/koylu_muhabbet_genel.ds",
		"res://data/parley/koy/koylu_muhabbet_yusuf.ds",
		"res://data/parley/koy/sekans_degirmen_kitlik.ds",
		"res://data/parley/koy/sekans_meydan_atesi.ds"
	]
	
	for yol in dosyalar:
		var ast = KoyDiyalogYoneticisi.sekans_yukle(yol)
		dene(ast != null, "AST yuklendi: " + yol)
		dene(not ast.nodes.is_empty(), "Düğümler mevcut: " + yol)
		dene(not ast.edges.is_empty(), "Bağlantılar mevcut: " + yol)
	
	# 2. ParleyKoyAdaptoru Testi
	var k := Koylu.new()
	k.id = 5
	k.ad = "Yusuf"
	k.sinif = &"ciftci"
	k.moral = 75
	k.refah = 40
	k.saglik = 90
	
	var ctx_dict := ParleyKoyAdaptoru.baglam_olustur(k, null)
	dene(ctx_dict["koylu_id"] == 5, "Baglam: koylu_id dogru")
	dene(ctx_dict["ad"] == "Yusuf", "Baglam: ad dogru")
	dene(ctx_dict["moral"] == 75, "Baglam: moral dogru")
	
	# Etki uygulama testi
	ctx_dict["uygulanan_etkiler"] = [
		{"tur": "moral", "delta": -10},
		{"tur": "sadakat", "delta": 15}
	]
	ParleyKoyAdaptoru.etkileri_uygula(ctx_dict, k, null)
	dene(k.moral == 65, "Etkileri uygula: moral 75 -> 65 oldu")
	dene(k.sadakat == 75, "Etkileri uygula: sadakat 60 + 15 -> 75 oldu")
	
	# 3. Facts ve Actions Testi
	var p_ctx := ParleyContext.new()
	p_ctx.p_data = {
		"moral": 70,
		"havadisler": ["harami"],
		"uygulanan_etkiler": []
	}
	
	var fact_moral = KoyluMoralFact.new()
	dene(fact_moral.evaluate(p_ctx, ["iyi"]) == true, "KoyluMoralFact: 70 moral 'iyi' olarak dogrulandi")
	dene(fact_moral.evaluate(p_ctx, ["dusuk"]) == false, "KoyluMoralFact: 70 moral 'dusuk' degil")
	
	var fact_havadis = KoyHavadisFact.new()
	dene(fact_havadis.evaluate(p_ctx, ["harami"]) == true, "KoyHavadisFact: 'harami' havadisi mevcut")
	dene(fact_havadis.evaluate(p_ctx, ["kitlik"]) == false, "KoyHavadisFact: 'kitlik' havadisi yok")
	
	var act_moral = KoyMoralAction.new()
	act_moral.run(p_ctx, ["5"])
	dene(int(p_ctx.p_data["moral"]) == 75, "KoyMoralAction: moral 70 + 5 -> 75 oldu")
	
	var act_akce = KoyAkceAction.new()
	act_akce.run(p_ctx, ["10"])
	var etkiler: Array = p_ctx.p_data["uygulanan_etkiler"]
	dene(etkiler.size() == 2, "KoyAkceAction: uygulanan etkiler listesine eklendi")
	
	# 4. Türkçe Karakter Doğrulaması (.ds içinden)
	var ast_genel = KoyDiyalogYoneticisi.sekans_yukle("res://data/parley/koy/koylu_muhabbet_genel.ds")
	var metin_tamami := ""
	for n in ast_genel.nodes:
		if n is ParleyDialogueNodeAst:
			metin_tamami += (n as ParleyDialogueNodeAst).text + " "
		elif n is ParleyDialogueOptionNodeAst:
			metin_tamami += (n as ParleyDialogueOptionNodeAst).text + " "
			
	var arananlar := ["ç", "ğ", "ı", "İ", "ö", "ş", "ü"]
	for harf in arananlar:
		dene(metin_tamami.contains(harf), "Türkçe karakter korundu: " + harf)
	
	# 5. Uçtan uca diyalog koşu testi (KoyDiyalogYoneticisi)
	await _test_koy_yoneticisi_akisi()


func _test_koy_yoneticisi_akisi() -> void:
	var k := Koylu.new()
	k.id = 1
	k.ad = "Hasan"
	k.moral = 65
	
	var dy = KoyDiyalogYoneticisi.new()
	var test_durumu := {
		"replik_sayisi": 0,
		"secenekler": []
	}
	
	dy.replik_geldi.connect(func(konusan: String, metin: String, secenekler: Array) -> void:
		test_durumu["replik_sayisi"] += 1
		test_durumu["secenekler"] = secenekler
		print("  Replik [%s]: %s (Seçenek: %d adet)" % [konusan, metin, secenekler.size()])
	)
	
	dy.muhabbet_baslat(k, null)
	await create_timer(0.2).timeout
	
	dene(test_durumu["replik_sayisi"] > 0, "KoyDiyalogYoneticisi ilk repligi verdi")
	dene(not test_durumu["secenekler"].is_empty(), "İlk replik sonrasi secenekler sunuldu")
	
	# İlk seçeneği seç: "Hal hatır nasıldır?"
	if not test_durumu["secenekler"].is_empty():
		var secilen: ParleyNodeAst = test_durumu["secenekler"][0]
		dy.secenek_sec(secilen)
		await create_timer(0.2).timeout
		dene(test_durumu["replik_sayisi"] >= 2, "Secenek sonrasi cevap repligi alindi")
	
	dy.bitir()
	dene(not dy.calisiyor, "Diyalog basariyla sonlandi")
	
	print("--- [KÖY PARLEY SİSTEMİ TEST SONUCU: " + ("GEÇTİ (0 hata)" if hata == 0 else "KALDI (%d hata)" % hata) + "] ---")
	quit(hata)
