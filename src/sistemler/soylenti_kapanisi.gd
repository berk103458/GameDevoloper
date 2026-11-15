## SOY-SON-01: beş kritik söylentinin somut kapanışı (data/soylenti.json "kritik_soylentiler").
## Başlatıcı gece kartı (ör. ambarda_hirsizlik) uygulanınca söylenti ağa köyde yaşayan bir tanıkla girer;
## `kapanis_gecesi` gece sonra kapanış kartı rastgele havuzdan değil buradan, hesaplaşma olarak gelir.
## Seçim söylentiyi hükme bağlar (SoylentiAgi.soylenti_kapanisi_uygula). Metin yazılmaz; kart metinleri mevcuttur.
class_name SoylentiKapanisi
extends RefCounted


static var _veri: Dictionary = {}


static func _ayar() -> Dictionary:
	if _veri.is_empty():
		var v: Variant = JSON.parse_string(FileAccess.get_file_as_string(SoylentiAgi.SOYLENTI_VERI_YOLU))
		_veri = v if v is Dictionary else {}
	return _veri


## Kritik söylenti tablosu: anahtar -> {baslatan, kapanis}.
static func tablo() -> Dictionary:
	return _ayar().get("kritik_soylentiler", {})


## Olay bir kapanış kartıysa söylenti anahtarı; değilse boş.
static func kapanis_anahtari(olay_id: StringName) -> String:
	var t := tablo()
	for anahtar in t:
		if StringName(String(t[anahtar].get("kapanis", ""))) == olay_id:
			return String(anahtar)
	return ""


## Olay bir başlatıcı kartıysa söylenti anahtarı; değilse boş.
static func baslatan_anahtari(olay_id: StringName) -> String:
	var t := tablo()
	for anahtar in t:
		if StringName(String(t[anahtar].get("baslatan", ""))) == olay_id:
			return String(anahtar)
	return ""


## Kapanış kartları rastgele gece havuzuna girmez; yalnız söylenti olgunlaşınca gelir.
static func tanimli(olay: OlayVerisi) -> bool:
	return olay != null and not kapanis_anahtari(olay.id).is_empty()


## Söylentiyi köye taşıyan tanık: köyde yaşayan, muhafız olmayan ilk köylü. Yoksa söylenti açılmaz.
static func tanik(o: Oturum) -> String:
	for k in o.yonetim.koylular:
		if k.saglik > 0 and not MuhafizMaasi.aday(k, o.yonetim):
			return str(k.id)
	return ""


## Başlatıcı kart uygulanınca ilgili kritik söylenti ağa girer (bir kez).
static func baslat(o: Oturum, olay: OlayVerisi) -> bool:
	var anahtar := baslatan_anahtari(olay.id)
	if anahtar.is_empty():
		return false
	var a: SoylentiAgi = SoylentiKoprusu.ag(o)
	if a.ag_kayitlari.has(anahtar):
		return false
	var kim := tanik(o)
	if kim.is_empty():
		return false
	var r: Dictionary = a.soylenti_ekle(anahtar, String(a.veri_yapilandirma.get("kritik_tur", "kritik_soylenti")), kim, true, {"gece": int(o.gun), "kritik": true})
	return bool(r.get("olur", false))


## Bu gece sonu olgunlaşmış ilk kritik söylentinin kapanış kartı ya da null.
static func olay(o: Oturum) -> OlayVerisi:
	if not o.has_meta(SoylentiKoprusu.META):
		return null
	var a: SoylentiAgi = SoylentiKoprusu.ag(o)
	var bekle := int(a.veri_yapilandirma.get("kapanis_gecesi", 2))
	var t := tablo()
	for anahtar in t:
		var k: Dictionary = a.ag_kayitlari.get(anahtar, {})
		if k.is_empty() or not bool(k.get("kritik", false)) or bool(k.get("hukme_baglandi", false)):
			continue
		if int(o.gun) - int(k.get("gece", o.gun)) < bekle:
			continue
		var kart := o.katalog.olay(StringName(String(t[anahtar].kapanis)))
		if kart == null:
			continue
		o.gorulen_olaylar[kart.id] = true
		return kart
	return null


## Oturum.olay_uygula başında: başlatıcı söylenti açar, kapanış hükme bağlar. Kartın genel etkileri ayrıca uygulanır.
## Seçenek 0 "adalet" (söylenti sınandı), diğerleri "ceza" yoludur.
static func uygula(o: Oturum, olay: OlayVerisi, i: int) -> Dictionary:
	var anahtar := kapanis_anahtari(olay.id)
	if anahtar.is_empty():
		baslat(o, olay)
		return {}
	return (SoylentiKoprusu.ag(o) as SoylentiAgi).soylenti_kapanisi_uygula(anahtar, "adalet" if i == 0 else "ceza")
