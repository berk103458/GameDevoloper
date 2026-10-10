## BUG-0014: gerçek gönderim → yeni/ret ferman → kayıt/ikinci Ana → gerçek zafer/UI.
extends Node
const NIHAI = preload("res://src/sistemler/nihai_son.gd")
class TestAna extends Ana:
	func _ready() -> void:
		ayarlar = Ayarlar.new("user://unused_levent_final.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = Oturum.new(katalog, 1414)
		kayit = GuvenliKayit.new("user://test_levent_final.json")
		theme = Tema.olustur(ayarlar)
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _ready() -> void:
	get_tree().create_timer(90.0).timeout.connect(func() -> void: get_tree().quit(1))
	for reddet in [false, true]:
		var ana := TestAna.new()
		add_child(ana)
		var o := ana.oturum
		var y := o.yonetim
		y.a = y.a.duplicate(true)
		y.a.ambar_taban_kapasite = 10000
		y.a.harac_araligi = 100000
		y.a.isyan_esigi = -1
		ana.katalog.koy_ayarlari = y.a
		y.kaynaklar = Kaynaklar.new(10000, {"gida": 1000, "su": 1000, "odun": 1000})
		y.akce = 1000
		for i in 6:
			var k := y.kabul({"ad": "Levent %d" % i})
			k.saglik = 100
			k.moral = 80
		y.gun = 7
		o.gece_sonu()
		dene(o.olay_uygula(SancakAskerTalebi.olay(o), 0).ok and y.nufus() == 4, "Gerçek 8. gece fermanı iki kişi gönderdi")
		y.agalik = true
		y.gun = 19
		y.asayis_riski = 60
		y.set_meta(KoyYonetimi.PERDE_GECISI.META, 9 if reddet else 8)
		if reddet:
			var ara := o.gece_sonu()
			dene(ara.son == &"" and y.gun == 20, "İkinci ferman zaferden önce açıldı")
			dene(o.olay_uygula(SancakAskerTalebi.olay(o), 2).ok, "İkinci ferman gerçekten reddedildi")
		ana._koye_git()
		await get_tree().process_frame
		var ikinci := TestAna.new()
		add_child(ikinci)
		ikinci.katalog = ana.katalog
		ikinci.kayit = ana.kayit
		ikinci.devam_et()
		await get_tree().process_frame
		dene(ikinci._ekran is KoyEkrani, "Gerçek ikinci Ana köy fazına devam")
		var son := ikinci.oturum.gece_sonu()
		dene(son.son == &"zafer", "Gerçek 12. perde gecesi zafer")
		if not reddet:
			dene(ikinci.oturum.sancak_asker_talebi.bekliyor and ikinci.oturum.sancak_asker_talebi.secim == -1, "Final gecesinde yeni ferman açıldı")
		dene(NIHAI.gostergeler(ikinci.oturum).guvenlik < 70 and ikinci.oturum.yonetim.etkin_muhafiz_sayisi() < 3, "Bey yedek güvenlik koşulu sağlanmıyor")
		dene(NIHAI.son(ikinci.oturum, son.son) == "beyin_uc_koyu", "Kalıcı gönderim Bey yolunu korur")
		ikinci._son_goster(son.son)
		await get_tree().process_frame
		dene(metin(ikinci._ekran).contains("Beyin Uç Köyü"), "Gerçek son ekranında Bey başlığı")
		ana.kayit.sil()
		ana.queue_free()
		ikinci.queue_free()
		for i in 3: await get_tree().process_frame
	print("LEVENT FINAL UI: GEÇTİ" if hata == 0 else "LEVENT FINAL UI: KALDI")
	await Ses.cik(hata)

func metin(n: Node) -> String:
	var r: String = n.text if n is Label else ""
	for c in n.get_children(): r += " " + metin(c)
	return r
