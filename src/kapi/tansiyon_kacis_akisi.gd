## ZAR-03: tansiyon eşiği aşılınca kapı ziyaretini "kaçtı" kararıyla kapatır.
## Oturum.karar_ver çağrılmaz: kabul, ret, rüşvet ve kışla yazılmaz, ret sayacı ve kasa değişmez (DEN-19).
## Tanık varsa kaçış dedikoduya yazılır; satır metni `dedikodu.kacis` anahtarıdır, tanımlı değilse yazılmaz.
extends RefCounted

const METIN_ANAHTARI := "dedikodu.kacis"
const KARAR_ANAHTARI := "arayuz.kapi.karar_kacti"


static func uygula(o: Oturum, g: Gelen, tanik: Gelen = null) -> Dictionary:
	var sonuc := TansiyonKacisAdaptoru.uygula(o, g)
	sonuc["dedikodu_yazildi"] = false
	var satir := TranslationServer.translate(METIN_ANAHTARI)
	if tanik != null and satir != METIN_ANAHTARI and not satir.is_empty():
		var r: Dictionary = o.dedikodu.olay_kaydet("kacis_%s_%d" % [String(g.id), o.gun], "kacis", o.gun, String(tanik.id), 1,
			{"satir": satir, "hedef_id": String(g.id)})
		sonuc["dedikodu_yazildi"] = bool(r.get("olur", false))
	sonuc["kacis_hafiza"] = g.adli
	return sonuc


## Panik kilidi (8–10) beceri seçeneklerini kapattığı için kaçış çoğunlukla çelişki, yemin ya da söylenti
## artışıyla gelir; her artış ChrSorgusu.tansiyon_artir üzerinden geçer ve bu sinyal ziyareti kapatır.
static func bagla(ekran: Control, sorgu: ChrSorgusu) -> void:
	if not ekran is KapiEkrani:
		return
	if sorgu.has_meta(&"kacis_bagli"):
		return
	sorgu.set_meta(&"kacis_bagli", true)
	sorgu.tansiyon_degisti.connect(func(_t: int) -> void:
		if sorgu.kacti() and is_instance_valid(ekran) and ekran.get("_gelen") != null and ekran.get("_gelen").chr_sorgusu() == sorgu:
			(func() -> void: ekranda(ekran as KapiEkrani)).call_deferred())


## Kapı ekranında: karar satırı, hatırlanma notu ve gelenin uzaklaşması; ardından sıradaki.
static func ekranda(ekran: KapiEkrani) -> void:
	if ekran.evre == &"sonuc" or ekran._gelen == null:
		return
	ekran.evre = &"sonuc"
	ekran._temizle()
	ekran._bolum.text = ""
	var g := ekran._gelen
	var sonuc := uygula(ekran.oturum, g, ekran._kuyruk[0] if not ekran._kuyruk.is_empty() else null)
	var karar := ekran.tr(KARAR_ANAHTARI)
	ekran._yaz("[b]%s:[/b] %s — %s" % [ekran.tr("arayuz.kapi.karar"), ekran.tr(g.ad_anahtari), SorguZari.KARAR_KACTI_TR if karar == KARAR_ANAHTARI else karar])
	ekran.hatirlanma_notunu_bildir({"hafiza": false, "dedikodu": bool(sonuc.dedikodu_yazildi), "kacis_hafiza": bool(sonuc.kacis_hafiza)})
	ekran.set_meta(&"sonuclanan_gelen", g)
	ekran._adim_sesi(8)
	ekran.hud.guncelle()
	ekran._daralt(false)
	await ekran.sahne.gelen_git(false, true)
	ekran._siradaki()
