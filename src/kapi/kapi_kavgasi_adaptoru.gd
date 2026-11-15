## CAT-01: mevcut karar, yatak, nöbet ve Dedikodu sistemlerine ince köprü.
extends RefCounted

const META := &"cat01_kapi_kavgasi"
const BARINAK = preload("res://src/kapi/barinak_uyarisi.gd")
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(KapiKavgasi.VERI_YOLU))

var kavga := KapiKavgasi.new()
var son: Dictionary = {}
var _oturum: WeakRef
var _kuyruk: Array[Gelen] = []
var panel_acik := false
var gelen: Gelen

static func al(o: Oturum) -> RefCounted:
	if not o.has_meta(META):
		var a := new()
		a._oturum = weakref(o)
		o.set_meta(META, a)
		o.yonetim.nobet_degisti.connect(a.nobet_degisti)
	return o.get_meta(META)

## Eşleme ziyaret hazırlandıktan sonra yapılır; isim ve sınıfa göre tip uydurulmaz.
static func tip_ata(g: Gelen, zengin_esigi: int) -> void:
	if not g.kavga_tip.is_empty(): return
	var alanlar := {
		"giris_anahtari": g.giris_anahtari,
		"sinif": String(g.sinif),
		"aile_ac": str(g.aile.size() > 1 and g.heybe != null and not g.zengin(zengin_esigi)),
	}
	for esleme: Dictionary in AYAR.get("tip_eslemeleri", []):
		if alanlar.get(esleme.alan, "") == esleme.deger:
			g.kavga_tip = String(esleme.tip)
			return

static func kuyruk_hazirla(o: Oturum, kuyruk: Array[Gelen]) -> void:
	for g in kuyruk: tip_ata(g, o.ayarlar.zengin_esigi)
	tanik_hazirla(o, kuyruk)

## Gerçek ekran kalan sırayı verir; motor kuyruğu da aynı kuralı kullanır.
static func tanik_hazirla(o: Oturum, kuyruk: Array[Gelen]) -> void:
	al(o)._kuyruk = kuyruk.duplicate()

static func ret(o: Oturum, g: Gelen, karar: StringName, ek: Dictionary) -> void:
	var a = al(o)
	a.nobet_degisti()
	a.gelen = g
	var neden := "siradan_ret"
	if not BARINAK.yeter_mi(o.yonetim, maxi(1, g.aile.size())):
		neden = "yer_yoklugu"
	elif g.kusurlu() or karar == &"elkoy" or ChrKararMatrisi.matris_anahtari(g.chr_sorgusu(), karar) == &"zorunlu_ret":
		neden = "sert_ret"
	var kimlik := String(g.id) if not String(g.id).is_empty() else "figur_%d" % g.get_instance_id()
	var tanik := ""
	for diger: Gelen in a._kuyruk:
		if diger == g: continue
		tanik = String(diger.id) if not String(diger.id).is_empty() else "figur_%d" % diger.get_instance_id()
		break
	var baglam := {
		"kisi_id": kimlik, "gun": o.gun, "tip": g.kavga_tip,
		"neden": neden, "asker_sayisi": o.yonetim.muhafiz_sayisi(),
		"mekan": String(o.get_meta(&"cat01_mekan", "kapi")),
		"heyet_aktif": DiplomatikHeyet.ilgilenir(g) or DiplomatikHeyet.gecis_engeli(o, g) or DiplomatikHeyet.kilitli(o, a._kuyruk),
		"tanik": tanik,
	}
	a.son = a.kavga.ret_degerlendir(baglam, o.dedikodu)
	a.son["ret_nedeni"] = neden
	ek.merge(a.son, true)
	# Aynı karar sözlüğü ayrılış sinyalinde de güncellenir.
	a.son = ek

func nobet_degisti() -> void:
	var o = _oturum.get_ref()
	if o == null or o.yonetim.muhafiz_sayisi() > 0 or kavga.aktif_kavga().is_empty(): return
	if panel_acik: return # CAT-02 panelinde yalnız asker seçeneği kapanır.
	son.merge(kavga.asker_ayrildi(o.dedikodu), true)

static func sonuc_yaz(ekran: Node, sonuc: Dictionary) -> void:
	match String(sonuc.get("durum", "")):
		"kavga_acik": ekran._yaz("[b]%s[/b]" % TranslationServer.translate(KapiKavgasi.YER_TUTUCU_CANLANDIRMA.metin))
		"tehdit_edip_gitti": ekran._yaz("[i]%s[/i]" % TranslationServer.translate("anlati.kavga.tehdit"))
		"kacti": ekran._yaz("[i]%s[/i]" % TranslationServer.translate("anlati.kavga.kacti"))

## CAT-02: bakiye, açık söz ve nöbet daima gerçek oturumdan okunur.
static func baglam(o: Oturum) -> Dictionary:
	var a = al(o)
	var b: Dictionary = a.kavga.aktif_kavga()
	b.merge({"muhafiz_akce": o.muhafiz_akce, "asker_sayisi": o.yonetim.muhafiz_sayisi(),
		"acik_soz_sayisi": o.soz_kaydi.sozler.acik_sayisi()}, true)
	var beceri := 0
	for k in o.yonetim.koylular:
		if k.is_yeri == -2: beceri = maxi(beceri, k.stat)
	b["asker_becerisi"] = beceri
	return b

static func sec(o: Oturum, secenek: String, test_baglami: Dictionary = {}) -> Dictionary:
	var a = al(o)
	var b := baglam(o)
	# Test enjeksiyonları bakiye/asker/söz sınırlarını geçersiz kılamaz.
	for k in ["zar_atis", "zorla_alt_sonuc", "donus_gun_ek", "kalp", "romans"]:
		if test_baglami.has(k): b[k] = test_baglami[k]
	if a.kavga.aktif_kavga().is_empty(): return {"olur": false}
	if secenek in ["askerle_karsilik", "sozle_yatistirma"] and not b.has("zar_atis"):
		b["zar_atis"] = SorguZari.at(o._rng, SorguZari.TUR_D6)
	if secenek == "akceyle_erteleme" and not b.has("donus_gun_ek"):
		b["donus_gun_ek"] = o._rng.randi_range(int(AYAR.erteleme_donus_gun_araligi[0]), int(AYAR.erteleme_donus_gun_araligi[1]))
	var r: Dictionary = a.kavga.secenek_uygula(secenek, b, o.kadro, o.dedikodu,
		func(_kayit: Dictionary) -> void:
			# BUG-20'nin kalıcı ölüm makbuzu, gece mevcut nüfus/cenaze hattında tüketilir.
			var rapor := SiraOlayiSonucu.durum(o.yonetim)
			rapor.append({"sonuc": "olum", "ad": o.tr_gelen(a.gelen), "kisi": o.tr_gelen(a.gelen)})
			o.yonetim.set_meta(SiraOlayiSonucu.RAPOR, rapor))
	if not r.get("olur", false): return r
	a.panel_acik = false
	if secenek == "akceyle_erteleme":
		o.muhafiz_akce -= int(r.harcanan_muhafiz_akce)
		var kim := "cat02_%s_%d" % [String(b.kisi_id), o.gun]
		o.soz_kaydi.sozler.ekle(kim, String(b.kisi_id), o.gun, "yarin_gel", false)
		var sozler := o.soz_kaydi.sozler.kaydet()
		sozler[-1].merge({"donus_gun": r.donus_gun, "grup": grup(o, a.gelen), "cat02": true})
		o.soz_kaydi.sozler.yukle(sozler)
		var g: Gelen = a.gelen
		if g.adli and o.kadro.durumlar.has(g.id):
			o.kadro.durumlar[g.id]["durum"] = &"donebilir"
			o.kadro.durumlar[g.id]["donus"] = int(r.donus_gun)
		var figur := {}
		for alan in ["ad_anahtari", "giris_anahtari", "sinif", "portre", "stat", "kavga_tip", "tehlikeli", "aile", "aile_id", "acik_bayraklar", "gizli_bayraklar"]:
			figur[alan] = g.get(alan)
		o.gecikmeli_kuyruk.append({"hedef_sistem": "spawn", "alan": "yarin_gel", "deger": String(b.kisi_id),
			"chr_id": String(b.kisi_id), "karar": "yarin_gel", "tur_offset": int(r.donus_gun) - o.gun,
			"hedef_gun": int(r.donus_gun), "eklenme_gunu": o.gun, "cat02_soz": kim,
			"cat02_figur": figur if not g.adli else {}, "spawned": false, "uygulandi": false})
	a.son.merge(r, true)
	a.son["durum"] = "kavga_bitti"
	a.son["secenekler_acik"] = false
	a.son["sahne_acildi"] = false
	return r

static func grup(o: Oturum, g: Gelen) -> String:
	var veri = o.katalog.karakter(g.id) if g.adli else null
	var ham: Variant = veri.sinif if veri != null else String(g.sinif)
	var sonuc := GrupItibari.norm_grup(ham)
	return sonuc if GrupItibari.gecerli_grup_mu(sonuc) else GrupItibari.VARSAYILAN_GRUP

## Mevcut VerilenSoz kaydı kapanır; yeni söz motoru kurulmaz.
static func sozleri_kapat(o: Oturum, g: Gelen = null, karar: StringName = &"") -> void:
	var satirlar := o.soz_kaydi.sozler.kaydet()
	for s in satirlar:
		if not s.get("cat02", false) or s.get("tutuldu", false) or not String(s.get("sonuc", "")).is_empty(): continue
		if String(o.kadro.durumlar.get(StringName(s.kisi), {}).get("durum", "")) == "oldu":
			s["sonuc"] = "kisi_oldu"
			continue
		var donus := g != null and String(g.id) == String(s.kisi) and o.gun >= int(s.donus_gun)
		if not donus and o.gun <= int(s.donus_gun): continue
		s["tutuldu"] = donus and karar not in [&"ret", &"elkoy"]
		s["sonuc"] = "tutuldu" if s.tutuldu else "tutulmadi"
		if s.sonuc == "tutulmadi": al(o).kavga.erteleme_sozu_tutulmadi(o.grup_itibari, String(s.grup))
	o.soz_kaydi.sozler.yukle(satirlar)
