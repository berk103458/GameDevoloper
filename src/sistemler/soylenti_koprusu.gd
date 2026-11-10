## SOY: söylenti ağını (SoylentiAgi) oturuma bağlayan ince adaptör.
## Ağ, oturumun tek dedikodu nesnesini (DIY-13) paylaşır; ikinci dedikodu kaydı açılmaz (SOY-48).
## Tanık, kapıda sırada duran ve sonra kabul edilip köylü olan kişidir (DIY-13 kural 2); taşıyan yoksa kayıt açılmaz.
class_name SoylentiKoprusu
extends RefCounted

const META := &"soylenti_agi"
const AG := preload("res://src/sistemler/soylenti_agi.gd")
const BEKLEYEN := &"soylenti_bekleyen"


static func ag(o: Object) -> RefCounted:
	if o.has_meta(META):
		return o.get_meta(META)
	var yeni: RefCounted = AG.new(o.dedikodu)
	o.set_meta(META, yeni)
	return yeni


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
	if not o.has_meta(META):
		return
	var a: RefCounted = ag(o)
	var y: KoyYonetimi = o.yonetim
	var once := int(a.bar_degisimi_toplam)
	var histeri_once := int(a.histeri_tetik_sayisi)
	var onceki_kamuoyu := {}
	for id in a.ag_kayitlari:
		if bool(a.ag_kayitlari[id].get("kamuoyu_oldu", false)):
			onceki_kamuoyu[id] = true
	var b := baglar(y)
	a.gece_ilerlet(int(o.gun), y.koylular.size(), b[0], b[1])
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
	return MeclisSesi.sikayet_metni(String(adlar.get(String(konu.tur), konu.tur)), k.ad)


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
			"olay": olay_metni(a, k), "kaynak": koylu.ad, "kademe": String(s.kademe), "dogrulandi": false})
	return satirlar


## Oyuncu dilinde olay: bozuk kopya biçim kalıbıyla, asıl kayıt tür kalıbıyla söylenir (SOY-44).
static func olay_metni(a: RefCounted, k: Dictionary) -> String:
	if k.has("bicim"):
		var bozuk: Dictionary = a.veri_yapilandirma.get("bozulma_kaliplari", {})
		return String(bozuk.get(String(k.bicim), "")).replace("{kaynak}", String(a.veri_yapilandirma.get("bozulma_faili", "")))
	return String(a.veri_yapilandirma.get("soylenti_kaliplari", {}).get(String(k.get("tur", "")), ""))


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
	if not o.has_meta(META) and bekleyenler(o).is_empty():
		return {}
	var v: Dictionary = ag(o).kayit_verisi_al()
	v["bekleyen"] = bekleyenler(o).duplicate(true)
	return v


## Eski kayıtta alan yoktur; ağ boş başlar, dedikodu kayıtları kaynaksız sayılır (SOY-42).
static func yukle(o: Object, v: Variant) -> bool:
	if not v is Dictionary or (v as Dictionary).is_empty():
		return false
	if not v.get("ag_kayitlari", {}) is Dictionary or not v.get("guvenilirlikler", {}) is Dictionary or not v.get("teftis_sorulari", []) is Array:
		return false
	ag(o).kayit_verisi_yukle(v)
	var b: Variant = v.get("bekleyen", [])
	if b is Array:
		o.set_meta(BEKLEYEN, (b as Array).filter(func(h: Variant) -> bool: return h is Dictionary and h.get("olay_id") is String and h.get("tur") is String))
	return true
