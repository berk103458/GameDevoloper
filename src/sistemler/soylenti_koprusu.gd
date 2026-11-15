## SOY: söylenti ağını (SoylentiAgi) oturuma bağlayan ince adaptör.
## Ağ, oturumun tek dedikodu nesnesini (DIY-13) paylaşır; ikinci dedikodu kaydı açılmaz (SOY-48).
## Tanık, kapıda sırada duran ve sonra kabul edilip köylü olan kişidir (DIY-13 kural 2); taşıyan yoksa kayıt açılmaz.
class_name SoylentiKoprusu
extends RefCounted

const META := &"soylenti_agi"
const AG := preload("res://src/sistemler/soylenti_agi.gd")
const BEKLEYEN := &"soylenti_bekleyen"
const HUKUM := &"soylenti_hukum_satiri"


static func ag(o: Object) -> RefCounted:
	if o.has_meta(META):
		var mevcut: RefCounted = o.get_meta(META)
		bagla(o)
		return mevcut
	var yeni: RefCounted = AG.new(o.dedikodu)
	o.set_meta(META, yeni)
	bagla(o)
	return yeni


static func bagla(o: Object) -> void:
	if o != null and o.has_meta(META) and o.get("yonetim") is Object:
		(o.get("yonetim") as Object).set_meta(META, o.get_meta(META))


static func grev_esigi(o: Object, meslek: String = "") -> float:
	if o == null or not o.has_meta(META):
		return float(0)
	return float((o.get_meta(META) as Object).call("grev_olasilik_artisi", meslek))


## Salt okuma: ağ henüz kurulmadıysa oturuma yazmadan varsayılan kelimeyi verir.
static func guvenilirlik_kelimesi(o: Object, koylu_id: int) -> String:
	var a: RefCounted = o.get_meta(META) if o.has_meta(META) else AG.new(o.dedikodu)
	return a.guvenilirlik_kelimesi(str(koylu_id))


## Kapıdaki ağır olay o gece sıradakilerin gözü önünde olur; taşıyan çıkana dek bekler.
static func bekleyenler(o: Object) -> Array:
	return o.get_meta(BEKLEYEN, [])


## Kapı kararı: önce bu gelen sırada gördüğü haberi içeri taşır (SOY-03), sonra kendi kararı
## sıradakilere haber bırakır (SOY-04). Taşıyan kabul edilen köylüdür; kayıtta `kaynak` odur.
static func karar(o: Object, gelen: Gelen, karar_adi: StringName, ek: Dictionary) -> Array:
	var acilan: Array = []
	var liste := bekleyenler(o).duplicate(true)
	var kalan: Array = []
	var tasiyici := int(ek.get("koylu_id", -1)) if bool(ek.get("kaldi", false)) else -1
	for h in liste:
		if String(h.get("gelen", "")) == String(gelen.id):
			kalan.append(h)
		elif tasiyici >= 0:
			var r: Dictionary = ag(o).soylenti_ekle(String(h.olay_id), String(h.tur), str(tasiyici), true,
				{"gece": int(h.gece), "kisisel_kasa": String(h.tur) == "rusvet"})
			if bool(r.get("olur", false)):
				r.kayit["grup"] = String(h.get("grup", ""))
				acilan.append(r.kayit)
		else:
			kalan.append(h)
	var tur := ""
	if karar_adi == &"rusvet":
		tur = "rusvet"
	elif karar_adi == &"ret" and not gelen.kusurlu():
		tur = "haksiz_ret"
	elif karar_adi == &"kabul" and gelen.aile.size() > 1:
		tur = "aile_birlikte_alma"
	if not tur.is_empty():
		kalan.append({"olay_id": "kapi_%s_%d_%s" % [tur, int(o.gun), String(gelen.id)], "tur": tur, "gece": int(o.gun), "gelen": String(gelen.id),
			"grup": String(gelen.sinif) if GrupItibari.gecerli_grup_mu(gelen.sinif) else ""})
	o.set_meta(BEKLEYEN, kalan)
	return acilan


## Komşu: aynı evde oturanlar; evi olmayanlar ortak kampta aynı ateşin başındadır. İş arkadaşı: aynı yapıda çalışanlar.
static func baglar(y: KoyYonetimi) -> Array[Dictionary]:
	var evler := {}
	var isler := {}
	for k in y.koylular:
		evler[k.ev] = evler.get(k.ev, []) + [str(k.id)]
		if k.is_yeri >= 0:
			isler[k.is_yeri] = isler.get(k.is_yeri, []) + [str(k.id)]
	var komsu := {}
	var ark := {}
	for k in y.koylular:
		var id := str(k.id)
		komsu[id] = (evler.get(k.ev, []) as Array).filter(func(x: String) -> bool: return x != id)
		ark[id] = (isler.get(k.is_yeri, []) as Array).filter(func(x: String) -> bool: return x != id) if k.is_yeri >= 0 else []
	return [komsu, ark]


## Gece: ağ yayılır; kamuoyu olan konu halkın moralini bir kez düşürür ve raporda görünür.
static func gece(o: Object, r: Dictionary) -> void:
	if o.has_meta(BEKLEYEN):
		o.remove_meta(BEKLEYEN)
	if o.has_meta(HUKUM):
		if r.get("olaylar") is Array:
			r.olaylar.append({"anahtar": "Çınar altında hüküm: %s", "deger": [String(o.get_meta(HUKUM))]})
		o.remove_meta(HUKUM)
	var yeni_kazalar: Array[Dictionary] = []
	if o.get("yonetim") is KoyYonetimi:
		var ky := o.get("yonetim") as KoyYonetimi
		for k in ky.koylular:
			if k.is_kazasi.get("tur") == "yaralanma" and int(k.is_kazasi.get("kalan", 0)) == IsKazalari.YARALI_GECE:
				var b := ky.bina(k.is_yeri)
				yeni_kazalar.append({"id": k.id, "meslek": b.tur if b != null else ""})
	if not o.has_meta(META) and yeni_kazalar.is_empty():
		return
	var a: RefCounted = ag(o)
	for kz in yeni_kazalar:
		a.soylenti_ekle("is_kazasi_%d_%d" % [int(o.gun), int(kz.id)], "is_kazasi", str(int(kz.id)), true,
			{"gece": int(o.gun), "meslek": String(kz.meslek)})
	var y: KoyYonetimi = o.yonetim
	var once := int(a.bar_degisimi_toplam)
	var histeri_once := int(a.histeri_tetik_sayisi)
	var onceki_kamuoyu := {}
	for id in a.ag_kayitlari:
		if bool(a.ag_kayitlari[id].get("kamuoyu_oldu", false)):
			onceki_kamuoyu[id] = true
	var b := baglar(y)
	a.gece_ilerlet(int(o.gun), y.koylular.size(), b[0], b[1])
	for hh in a.yanlis_hedef_husumetleri_al():
		y.husumet.soylenti_husumeti_ekle(String(hh.kaynak), String(hh.hedef), int(hh.artis))
	var fark := int(a.bar_degisimi_toplam) - once
	if fark != 0:
		o._herkese_moral(fark * o.KOPRU_MORAL)
	grup_yaz(o, a)
	var histeri := FisiltiGazetesi.HISTERI.soylenti_tetigi(y, int(a.histeri_tetik_sayisi) - histeri_once)
	if not r.get("olaylar") is Array:
		return
	if histeri:
		r.olaylar.append({"anahtar": "Yanlış bir söylenti köyün diline düştü; histeri %d/3.", "deger": [FisiltiGazetesi.HISTERI.durum(y).vaka.seviye]})
	var kaliplar: Dictionary = a.veri_yapilandirma.get("soylenti_kaliplari", {})
	for id in a.ag_kayitlari:
		var k: Dictionary = a.ag_kayitlari[id]
		if bool(k.get("kamuoyu_oldu", false)) and not onceki_kamuoyu.has(id):
			if int(y.gun) > int(o.gun):
				k["etki_gunu"] = int(y.gun)
			var satir := String(kaliplar.get(String(k.get("tur", "")), ""))
			if not satir.is_empty():
				r.olaylar.append({"anahtar": "Köy bunu konuşuyor: %s", "deger": [satir], "soylenti": id})


## SOY-14: kamuoyu olan konu, kapıdaki kişinin grubunu anıyorsa (sınıfı altı gruptan biriyse) grup itibarına
## kararın deltasıyla bir kez yazılır; bozuk kopya ve ikinci gece yeniden yazmaz.
static func grup_yaz(o: Object, a: RefCounted) -> void:
	for id in a.ag_kayitlari:
		var k: Dictionary = a.ag_kayitlari[id]
		var grup := String(k.get("grup", ""))
		if grup.is_empty() or not bool(k.get("kamuoyu_oldu", false)) or bool(k.get("grup_yazildi", false)):
			continue
		k["grup_yazildi"] = true
		var tur := String(k.get("tur", ""))
		o.grup_itibari.karar_uygula(grup, "kabul" if tur in a.veri_yapilandirma.get("iyi_olaylar", []) else tur if tur == "rusvet" else "ret", false)


## SOY-33: canlı kamuoyu konusu çınar meclisine şikâyet olarak gelir; ağzı, haberi içeri taşıyan köylüdür.
## Kaynak köyde yaşamıyorsa satır basılmaz (SOY-45).
static func meclis_sikayeti(o: Object) -> String:
	if o == null or not o.has_meta(META):
		return ""
	var a: RefCounted = ag(o)
	var konu: Dictionary = a.meclis_sikayeti_sec()
	if konu.is_empty() or not String(konu.kaynak).is_valid_int():
		return ""
	var k: Koylu = o.yonetim.koylu(int(konu.kaynak))
	if k == null or k.saglik <= 0:
		return ""
	var adlar: Dictionary = a.veri_yapilandirma.get("meclis_karar_adlari", {})
	if not adlar.has(String(konu.tur)):
		return "%s: '%s'" % [k.ad, olay_metni(a, a.ag_kayitlari[konu.olay_id])]
	return MeclisSesi.sikayet_metni(String(adlar[String(konu.tur)]), k.ad)


## SOY-21/07/11: meclis şikâyeti dinler ve konuyu hükme bağlar. Asıl kayıt ve bütün bozuk kopyaları kapanır,
## kamuoyu söner; doğru çıkan asılın kaynağı +1, yanlış çıkan her kopyanın bozanı −1. Sabaha tek satır düşer.
static func hukme_bagla(o: Object) -> String:
	if meclis_sikayeti(o).is_empty():
		return ""
	var a: RefCounted = ag(o)
	var konu: Dictionary = a.meclis_sikayeti_sec()
	var asil := String(a.ag_kayitlari[konu.olay_id].get("asil", konu.olay_id))
	for id in a.ag_kayitlari.keys():
		var k: Dictionary = a.ag_kayitlari[id]
		if id != asil and String(k.get("asil", "")) != asil:
			continue
		a.divan_hukmu_ver(id)
		if bool(k.get("dogru", true)):
			a.dogru_soylenti_dogrulandi(id)
		else:
			a.yanlis_soylenti_dogrulandi(id)
	var satir := olay_metni(a, a.ag_kayitlari.get(asil, {}))
	o.set_meta(HUKUM, satir)
	return satir


## SOY-18/19: muhafız meclis önünde konuyu "doğru" ya da "yalan" diye niteler; nitelik kayda muhafız düğümü olarak girer.
## Kayıtla uyan nitelik muhafızın güvenilirliğini +1, uymayan −1 yapar. Doğru bir konuyu yalanlamak, şikâyeti getiren
## köylünün tanıklığında "muhafızın yalanı" DIY-13 kaydı açar; tanık köyde yoksa kayıt açılmaz.
const MUHAFIZ := "muhafiz"


static func nitele(o: Object, dogru_der: bool) -> String:
	if meclis_sikayeti(o).is_empty():
		return ""
	var a: RefCounted = ag(o)
	var konu: Dictionary = a.meclis_sikayeti_sec()
	var k: Dictionary = a.ag_kayitlari[konu.olay_id]
	if k.has("muhafiz_dugumu"):
		return ""
	k["muhafiz_dugumu"] = {"nitelik": "dogru" if dogru_der else "yalan", "gece": int(o.gun)}
	var dogru := bool(k.get("dogru", true))
	var adim := int(a._ayar("dogrulama_guvenilirlik_degisimi"))
	a.guvenilirlik_degistir(MUHAFIZ, adim if dogru_der == dogru else -adim)
	if dogru and not dogru_der:
		a.soylenti_ekle("%s_yalan" % konu.olay_id, "muhafizin_yalani", String(konu.kaynak), true, {"gece": int(o.gun)})
	return "Muhafız meclis önünde bu söze \"%s\" dedi." % ("doğru" if dogru_der else "yalan")


## SOY-22: kamuoyu olmuş tanıklı rüşvet teftiş gecesinde müfettişin sorusu olur; her olay bir kez sorulur.
static func teftis(o: Object, d: Dictionary) -> void:
	if not o.has_meta(META):
		return
	var a: RefCounted = ag(o)
	if a.teftis_sorulari.is_empty():
		return
	d["soylenti_sorusu"] = a.teftis_sorulari.size()
	a.teftis_sorulari.clear()


## SOY-29: defterin Söylenti sayfası canlı ağ kayıtlarıdır; olay oyuncu dilinde, kaynak köydeki adıyla.
static func defter_satirlari(o: Object) -> Array:
	var satirlar: Array = []
	if o == null or not o.has_meta(META):
		return satirlar
	var a: RefCounted = ag(o)
	for s in a.soylenti_sayfasi_al(o.yonetim.koylular.size()):
		var k: Dictionary = a.ag_kayitlari.get(s.olay, {})
		var kaynak := String(s.kaynak)
		var koylu: Koylu = o.yonetim.koylu(int(kaynak)) if kaynak.is_valid_int() else null
		if koylu == null or koylu.saglik <= 0:
			continue
		satirlar.append({"id": "soy:" + String(s.olay), "kisi": kaynak, "ad": koylu.ad, "gece": int(k.get("gece", -1)),
			"olay": olay_metni(a, k), "kaynak": koylu.ad, "kademe": String(s.kademe), "dogrulandi": bool(k.get("hukme_baglandi", false))})
	return satirlar


## Oyuncu dilinde olay: bozuk kopya biçim kalıbıyla, asıl kayıt tür kalıbıyla söylenir (SOY-44).
static func olay_metni(a: RefCounted, k: Dictionary) -> String:
	if bool(k.get("kritik", false)):
		# SOY-SON-01: kritik söylenti, kapanış kartının mevcut başlığıyla anılır; yeni metin yok.
		var kart := String((a.veri_yapilandirma.get("kritik_soylentiler", {}) as Dictionary).get(String(k.get("olay_id", "")), {}).get("kapanis", ""))
		var anahtar := "olay.%s.baslik" % kart
		var cevrilen := TranslationServer.translate(anahtar)
		return "" if kart.is_empty() or cevrilen == anahtar else cevrilen
	if k.has("bicim"):
		var bozuk: Dictionary = a.veri_yapilandirma.get("bozulma_kaliplari", {})
		return String(bozuk.get(String(k.bicim), "")).replace("{kaynak}", String(a.veri_yapilandirma.get("bozulma_faili", "")))
	var ozel := String(k.get("satir", "")).strip_edges()
	if not ozel.is_empty():
		return ozel
	return String(a.veri_yapilandirma.get("soylenti_kaliplari", {}).get(String(k.get("tur", "")), ""))


## SOY-25: Kapı ziyaretçisinin söylediği dış dünya söylentisini ağa yazar; aynı olayda iki farklı kaynak çelişirse defteri açar.
static func dis_soylenti_kaydet(o: Object, gelen: Gelen, olay_id: String, metin: String, dogru: bool = true) -> Dictionary:
	if o == null or olay_id.strip_edges().is_empty():
		return {}
	var tanik := String(gelen.id) if gelen != null else "ziyaretci"
	var a: RefCounted = ag(o)
	var sonuc: Dictionary = a.call("soylenti_ekle", olay_id, "dunya_haberi", tanik, dogru, {
		"gece": int(o.get("gun")) if o.get("gun") != null else 1,
		"satir": metin,
		"dis_soylenti": true,
		"olay": olay_id,
	})
	var satirlar_dizi: Array = a.call("olay_satirlari", olay_id)
	var farkli_dogruluk := false
	if satirlar_dizi.size() >= 2:
		var ilk_dogru := bool((satirlar_dizi[0] as Dictionary).get("dogru", true))
		for s in satirlar_dizi:
			if bool((s as Dictionary).get("dogru", true)) != ilk_dogru:
				farkli_dogruluk = true
				break
	if farkli_dogruluk and o is Oturum:
		preload("res://src/kapi/defter_tanitimi.gd").celiski_kaydet(o as Oturum)
	return sonuc


## SOY-39: denge ölçümü için salt okuma — canlı (hükme bağlanmamış) kayıt, kamuoyu ve yanlış sayısı.
static func olcum(o: Object) -> Dictionary:
	var r := {"canli": 0, "kamuoyu": 0, "yanlis": 0, "yanlis_orani": float(0)}
	if o == null or not o.has_meta(META):
		return r
	var a: RefCounted = o.get_meta(META)
	for id in a.ag_kayitlari:
		var k: Dictionary = a.ag_kayitlari[id]
		if bool(k.get("hukme_baglandi", false)):
			continue
		r.canli += 1
		r.kamuoyu += int(bool(k.get("kamuoyu_oldu", false)))
		r.yanlis += int(not bool(k.get("dogru", true)))
	r.yanlis_orani = float(r.yanlis) / float(r.canli) if r.canli > 0 else float(0)
	return r


## SOY-30: canlı kamuoyu konusu köy HUD'unda tek satırdır; konu yoksa boştur.
static func kamuoyu_satiri(o: Object) -> String:
	if o == null or not o.has_meta(META):
		return ""
	var a: RefCounted = ag(o)
	var konu: Dictionary = a.meclis_sikayeti_sec()
	if konu.is_empty():
		return ""
	var kaliplar: Dictionary = a.veri_yapilandirma.get("soylenti_kaliplari", {})
	var satir := String(kaliplar.get(String(konu.tur), ""))
	return "" if satir.is_empty() else "Köy konuşuyor: " + satir


static func kaydet(o: Object) -> Dictionary:
	if not o.has_meta(META) and bekleyenler(o).is_empty() and not o.has_meta(HUKUM):
		return {}
	var v: Dictionary = ag(o).kayit_verisi_al()
	v["bekleyen"] = bekleyenler(o).duplicate(true)
	if o.has_meta(HUKUM):
		v["hukum_satiri"] = String(o.get_meta(HUKUM))
	return v


## Eski kayıtta alan yoktur; ağ boş başlar, dedikodu kayıtları kaynaksız sayılır (SOY-42).
static func yukle(o: Object, v: Variant) -> bool:
	if not v is Dictionary or (v as Dictionary).is_empty():
		return false
	if not v.get("ag_kayitlari", {}) is Dictionary or not v.get("guvenilirlikler", {}) is Dictionary or not v.get("teftis_sorulari", []) is Array:
		return false
	ag(o).kayit_verisi_yukle(v)
	bagla(o)
	if v.get("hukum_satiri") is String:
		o.set_meta(HUKUM, v.hukum_satiri)
	var b: Variant = v.get("bekleyen", [])
	if b is Array:
		o.set_meta(BEKLEYEN, (b as Array).filter(func(h: Variant) -> bool: return h is Dictionary and h.get("olay_id") is String and h.get("tur") is String))
	return true
