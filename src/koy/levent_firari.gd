## KRI-09: ağır krizde adsız leventler; mevcut isyan/savunma genişletmesi.
## Global sınıf/autoload bağımlılığı yok; KoyYonetimi ince preload adaptörüdür.
extends RefCounted

const META := &"levent_firari"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/levent_firari.json"))

## Optional kayıt yalnız doğrulanmış dönem makbuzunu taşır.
static func oku(v: Variant) -> Dictionary:
	var bos := {"son_gece": -1, "kriz": false, "firar_edildi": false}
	if not v is Dictionary or not v.get("kriz") is bool or not v.get("firar_edildi") is bool: return bos
	var n: Variant = v.get("son_gece")
	if (not n is int and not n is float) or not is_finite(float(n)) or float(n) != floor(float(n)) or float(n) < -1 or float(n) > 1000000000: return bos
	if (not v.kriz and v.firar_edildi) or (int(n) == -1 and (v.kriz or v.firar_edildi)): return bos
	return {"son_gece": int(n), "kriz": v.kriz, "firar_edildi": v.firar_edildi}

## Salt okunur; HUD/kayıt okuması yeni kriz veya aday yaratmaz.
static func durum(y: KoyYonetimi) -> Dictionary:
	return oku(y.get_meta(META, {}))

## Legacy ve gelecek tarih güvenli; yükleme firar çalıştırmaz.
static func yukle(y: KoyYonetimi, v: Variant) -> void:
	var d := oku(v)
	if int(d.son_gece) > y.gun: d = oku({})
	y.set_meta(META, d)

## Gizli kuluçka/kimlik kriz ya da firar hedefi üretmez.
static func kriz(y: KoyYonetimi) -> String:
	if KitlikIsyani.durum(y).tetiklendi and y.isyan_kalan >= 0: return "kıtlık isyanı"
	for k in y.koylular:
		if "hasta" in k.bayraklar and SaglikYoneticisi.hasta(k) and not KervanKorumasi.disarida(y, k.id): return "salgın"
	if KuyuKirliligi.kirli(y): return "kirli kuyu"
	if y.isyan_kalan >= 0: return "isyan"
	return ""

## Meslek/grup açık veridir. Adlı hikâye kişisi, çocuk, tutuklu, dış görev ve
## karantinadaki kişi korunur. Çiftçi nöbete atanmakla levent olmaz.
static func aday(y: KoyYonetimi, k: Koylu) -> bool:
	return k.adli_id == &"" and (k.sinif == &"asker" or k.zanaat_turu == ZanaatTuru.Tur.ASKER) and k.yas_grubu == &"yetiskin" and k.saglik > 0 and k.sadakat <= int(AYAR.sadakat_esigi) and (k.moral <= int(AYAR.moral_esigi) or k.ac or MuhafizMaasi.borclu(k, y)) and not DivanHukmu.zindanda(k) and not KervanKorumasi.disarida(y, k.id) and not KarantinaYoneticisi.aktif(k)

## Gerçek gece _isyan sonrasında; aynı gecede/kriz boyunca tek sınırlı dalga.
## Eski rastgele isyan firarı ve kıtlık yağması ayrı makbuz olarak korunur.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	var d := durum(y)
	if y.son != "" or y.gun <= int(d.son_gece): return
	var neden := kriz(y)
	d.son_gece = y.gun
	d.kriz = not neden.is_empty()
	if not d.kriz: d.firar_edildi = false
	y.set_meta(META, d)
	if not d.kriz or d.firar_edildi: return
	var adaylar: Array[Koylu] = []
	for k in y.koylular:
		if aday(y, k): adaylar.append(k)
	adaylar.sort_custom(func(a: Koylu, b: Koylu) -> bool:
		if a.sadakat != b.sadakat: return a.sadakat < b.sadakat
		if a.moral != b.moral: return a.moral < b.moral
		return a.id < b.id)
	if adaylar.is_empty(): return
	var once := KervanKorumasi.guvenlik(y)
	var risk_once := y.asayis_riski
	var adlar: Array[String] = []
	for k in adaylar.slice(0, int(AYAR.azami_firar)):
		SavunmaKonuslanmasi.ata(y, k.id, "")
		y.koylular.erase(k)
		adlar.append(TranslationServer.translate(k.ad))
	y.asayis_riski = mini(100, y.asayis_riski + adlar.size() * int(AYAR.asayis_kaybi))
	d.firar_edildi = true
	y.set_meta(META, d)
	olaylar.append({"anahtar": "levent_firari", "levent_firari": {"sebep": neden, "adlar": adlar, "asayis_kaybi": y.asayis_riski - risk_once, "guvenlik_once": once, "guvenlik_sonra": KervanKorumasi.guvenlik(y)}})

## Mevcut gece raporuna açık isimler ve gerçekten değişen tek Güvenlik değeri.
static func olay_metin(e: Dictionary) -> String:
	var d: Dictionary = e.levent_firari
	return "Levent firarı · %s: %s köyü terk etti. Nöbet hattı zayıfladı; Güvenlik %d → %d/100 (asayiş riski +%d). Aynı kriz boyunca yeni firar dalgası olmaz; erzak, maaş ve moral desteği ayrılmayı önler." % [d.sebep, ", ".join(d.adlar), d.guvenlik_once, d.guvenlik_sonra, d.asayis_kaybi]
