## KRI-08: masum bir komşuya yönelen kanıtsız toplumsal kriz. Suç/Clue üretmez.
## Global sınıf eklenmez; ince adaptörler preload ile kullanır.
extends RefCounted

const META := &"batil_inanc_histerisi"
const SECIMLER := ["koru", "gercek", "goz_yum", "surgun"]
const SONUCLAR := ["", "koru", "gercek", "goz_yum", "surgun", "dagildi"]

static func _tam(v: Variant, alt: int, ust: int = 1000000000) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and float(v) >= alt and float(v) <= ust

static func oku(v: Variant) -> Dictionary:
	var bos := {"son_gece": -1, "kriz": false, "vaka": {}, "iade": {}}
	if not v is Dictionary or not _tam(v.get("son_gece"), -1) or not v.get("kriz") is bool or not v.get("vaka") is Dictionary or not v.get("iade") is Dictionary: return bos
	var d := {"son_gece": int(v.son_gece), "kriz": v.kriz, "vaka": {}, "iade": {}}
	var x: Dictionary = v.vaka
	if not x.is_empty():
		if not _tam(x.get("gun"), 0) or not _tam(x.get("hedef"), 1) or not _tam(x.get("seviye"), 1, 3) or not _tam(x.get("karar_gun"), -1) or x.get("sebep") not in ["kuyu", "salgin", "kitlik"] or x.get("karar") not in SONUCLAR: return bos
		if int(x.gun) > d.son_gece or (x.karar == "" and x.karar_gun != -1) or (x.karar != "" and int(x.karar_gun) < int(x.gun)): return bos
		d.vaka = {"gun": int(x.gun), "hedef": int(x.hedef), "seviye": int(x.seviye), "sebep": String(x.sebep), "karar": String(x.karar), "karar_gun": int(x.karar_gun)}
	for id in v.iade:
		if d.vaka.is_empty() or d.vaka.karar != "koru" or not id is String or not id.is_valid_int() or str(int(id)) != id or not _tam(int(id), 1) or not _tam(v.iade[id], 1, 4): return bos
		d.iade[id] = int(v.iade[id])
	return d

static func durum(y: KoyYonetimi) -> Dictionary:
	return oku(y.get_meta(META, {}))

static func yukle(y: KoyYonetimi, v: Variant) -> void:
	var d := oku(v)
	if int(d.son_gece) > y.gun or (not d.vaka.is_empty() and int(d.vaka.karar_gun) > y.gun): d = oku({})
	y.set_meta(META, d)

## Yalnız kamuya açık meslek/bayrak. Ad, CHR, sır, gizli eğilim ve grup
## düşmanlığı hedef puanı değildir. Kadın/cinsiyet alanı olmayan kişiye uydurulmaz.
static func onyargi(k: Koylu) -> bool:
	return k.zanaat_turu in [ZanaatTuru.Tur.OTACI, ZanaatTuru.Tur.CERRAH] or "yabanci" in k.bayraklar

static func yerel(y: KoyYonetimi, k: Koylu) -> bool:
	return k != null and k.saglik > 0 and k.yas_grubu != &"cocuk" and not DivanHukmu.zindanda(k) and not KervanKorumasi.disarida(y, k.id)

static func kriz(y: KoyYonetimi) -> String:
	if KuyuKirliligi.kirli(y): return "kuyu"
	var yas := CenazeYasi.durum(y)
	if not yas.is_empty() and yas.salgin and y.gun <= int(yas.bitis): return "salgin"
	if KitlikIsyani.durum(y).tetiklendi and y.isyan_kalan >= 0: return "kitlik"
	return ""

static func bekliyor(y: KoyYonetimi) -> bool:
	var x: Dictionary = durum(y).vaka
	return y.son == "" and not x.is_empty() and x.karar == "" and yerel(y, y.koylu(int(x.hedef)))

static func gercek_gosterilebilir(y: KoyYonetimi) -> bool:
	var x: Dictionary = durum(y).vaka
	if x.is_empty(): return false
	match x.sebep:
		"kuyu": return not KuyuKirliligi.kirli(y)
		"kitlik": return y.kaynaklar.miktar("gida") > 0 and y.isyan_kalan < 0
		"salgin":
			for k in y.koylular:
				if yerel(y, k) and SaglikYoneticisi.hasta(k) and "hasta" in k.bayraklar: return false
			return true
	return false

## Koruma kararının kısa moral bedeli: yalnız gerçekten kesilen miktar iade.
static func kaldir(y: KoyYonetimi) -> void:
	var d := durum(y)
	if d.iade.is_empty() or y.gun <= int(d.son_gece): return
	for id in d.iade:
		var k := y.koylu(int(id))
		if k != null: k.moral = mini(100, k.moral + int(d.iade[id]))
	d.iade.clear()
	y.set_meta(META, d)

## Aynı krizde tek vaka; önlem sonrası aynı gece yeniden hedefleme yok.
## Sessizce atlanan kart hasar üretmez; risk üç gecede yükselir, çözüm açık kalır.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	var d := durum(y)
	if y.son != "" or y.gun <= int(d.son_gece): return
	var neden := kriz(y)
	var yeni: bool = not d.kriz and not neden.is_empty()
	d.kriz = not neden.is_empty()
	d.son_gece = y.gun
	var x: Dictionary = d.vaka
	if not x.is_empty() and x.karar == "":
		if not yerel(y, y.koylu(int(x.hedef))):
			x.karar = "dagildi"
			x.karar_gun = y.gun
		else:
			x.seviye = mini(3, int(x.seviye) + 1) if not neden.is_empty() else maxi(1, int(x.seviye) - 1)
	elif yeni and d.iade.is_empty():
		var adaylar: Array[Koylu] = []
		for k in y.koylular:
			if yerel(y, k) and onyargi(k): adaylar.append(k)
		adaylar.sort_custom(func(a: Koylu, b: Koylu) -> bool: return a.id < b.id)
		if not adaylar.is_empty():
			x = {"gun": y.gun, "hedef": adaylar[0].id, "seviye": 1, "sebep": neden, "karar": "", "karar_gun": -1}
	d.vaka = x
	y.set_meta(META, d)
	if bekliyor(y): olaylar.append({"anahtar": "Haksız söylenti yayılıyor: masum bir komşu hedef alındı. Histeri %d/3; koruma ve gerçek sebebi açıklama gerekli.", "deger": [x.seviye]})

## Histeri gerçek çözüme güveni aşındırır; hedefin kendi/toplumsal grubunun
## oyunu önyargı lehine zorlamaz. Meclise sürgün seçeneği eklenmez.
static func oy_cezasi(y: KoyYonetimi, k: Koylu) -> int:
	if not bekliyor(y): return 0
	var x: Dictionary = durum(y).vaka
	var hedef := y.koylu(int(x.hedef))
	if k == hedef: return 0
	var grup := String(k.toplumsal_bag.get("grup", ""))
	if not grup.is_empty() and grup == String(hedef.toplumsal_bag.get("grup", "")): return 0
	return int(x.seviye) * 8

static func metin(y: KoyYonetimi) -> String:
	var x: Dictionary = durum(y).vaka
	if x.is_empty(): return ""
	var k := y.koylu(int(x.hedef))
	var ad := k.ad if k != null else "Köyden ayrılan komşu"
	return "%s haksız bir söylentinin hedefi. Histeri %d/3. Bazı köylüler felaketten onu sorumlu tutuyor; bu batıl iddia dayanaksızdır. Hedef bu krizin masum mağdurudur; söylenti kanıt değildir.\nGerçek neden: %s. Koru veya gerçek sebebi göster; göz yumma ve sürgün haksızlıktır, hekim ayrılırsa Şifahane kapasitesi kaybolur." % [ad, x.seviye, {"kuyu": "kirli kuyu suyu", "salgin": "salgın ve kayıplar", "kitlik": "erzak kıtlığı"}[x.sebep]]

static func olay(o) -> OlayVerisi:
	var y: KoyYonetimi = o.yonetim
	if not bekliyor(y): return null
	var d := durum(y)
	var e := OlayVerisi.new()
	e.id = StringName("kri08_%d_%d_%d_%d" % [d.vaka.gun, d.vaka.hedef, d.son_gece, d.vaka.seviye])
	e.baslik_anahtari = "Haksız söylenti · batıl inanç histerisi"
	e.metin_anahtari = metin(y)
	e.secenek_anahtarlari = PackedStringArray(["Koru · adalet +8; kısa moral −4", "Gerçek sebebi göster · kriz çözülmeli / kuyu temizlenmeli", "Göz yum · masum komşu güvenliğini yitirip ayrılır; adalet −25, vicdan yükü +50", "Sürgün et · masuma haksızlık; adalet −25, vicdan yükü +50"])
	e.secenek_etkileri = [{}, {}, {}, {}]
	return e

static func tanimli(e: OlayVerisi) -> bool:
	return e != null and String(e.id).begins_with("kri08_")

static func uygun(o, e: OlayVerisi, idx: int) -> bool:
	var g := olay(o)
	return idx >= 0 and idx < SECIMLER.size() and tanimli(e) and g != null and g.id == e.id and (idx != 1 or gercek_gosterilebilir(o.yonetim))

static func uygula(o, e: OlayVerisi, idx: int) -> Dictionary:
	var r := {"ok": false, "kirilan": -1, "rusvet_harcandi": -1, "oyun_puan": -1, "sonuc_anahtari": "Söylenti kararı güncel değil veya gerçek neden henüz giderilmedi."}
	if not uygun(o, e, idx): return r
	var y: KoyYonetimi = o.yonetim
	var d := durum(y)
	var k := y.koylu(int(d.vaka.hedef))
	var secim: String = SECIMLER[idx]
	d.vaka.karar = secim
	d.vaka.karar_gun = y.gun
	if secim == "koru":
		for kisi in y.koylular:
			var miktar := mini(4, kisi.moral)
			if miktar > 0: d.iade[str(kisi.id)] = miktar
			kisi.moral -= miktar
		y.adalet = mini(100, y.adalet + 8)
		r.sonuc_anahtari = "Muhafızın adalet kararı masum komşuyu korudu; söylenti bastırıldı. Adalet +8, kısa moral −4 (ertesi gece iade)."
	elif secim == "gercek":
		r.sonuc_anahtari = "Krizin gerçek sebebi ve alınan önlem açıklandı; masum komşuya yönelik histeri söndü. Suç isnadı yapılmadı."
	else:
		# Mevcut sürgün/nüfus/hekim API'si; ayrı kapasite sayacı veya hüküm yok.
		if not y.surgun(k.id): return r
		if o.kadro.durumlar.has(k.adli_id): o.kadro.durumlar[k.adli_id]["durum"] = &"kalici_ayrildi"
		DivanHaksizligi.kaydet(y, k.id)
		y.adalet = maxi(0, y.adalet - 25)
		y._herkese_moral(-8)
		MuhafizVicdani.haksizlik(o, 50)
		r.sonuc_anahtari = "Masum komşu %s. Kriz çözülmedi; haksızlık adaleti −25, morali −8 düşürdü, vicdan yükünü +50 artırdı. Ayrılan hekimin hizmeti kayboldu." % ("korunmadığı için köyden ayrıldı" if secim == "goz_yum" else "haksız yere sürüldü")
	y.set_meta(META, d)
	o._koy_esitle()
	r.ok = true
	return r
