## SOY-08/29/30/33: kapıdan giren söylenti kamuoyu olunca gerçek köy HUD'unda tek satır olur, defterde görünür ve çınar meclisini açar;
## şikâyet satırı kararın adını ve haberi taşıyan köylünün adını taşır.
extends Node
class OlaysizOturum extends Oturum:
	func olay_sec() -> OlayVerisi: return null
class TestAna extends Ana:
	func _ready() -> void:
		set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		ayarlar = Ayarlar.new("user://unused_soy33.cfg")
		katalog = Katalog.new()
		katalog.yukle()
		oturum = OlaysizOturum.new(katalog, 3112)
		kayit = GuvenliKayit.new("user://test_soy33_ui.json")
		theme = Tema.olustur(ayarlar)
var hata := 0


func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := TestAna.new()
	add_child(ana)
	var o := ana.oturum
	o.gun = 5
	o.yonetim.gun = 5
	o.karar_ver(_gelen("yolcu_a"), &"ret")
	var tasiyan := -1
	for i in 15:
		var r := o.karar_ver(_gelen("koylu_%d" % i), &"kabul")
		if i == 0: tasiyan = int(r.get("koylu_id", -1))
	o.gece_sonu()
	ana._koye_git()
	await get_tree().process_frame
	var e: KoyEkrani = ana._ekran
	var bos := Oturum.new(ana.katalog, 1)
	dene_bos(bos)
	var b := e.hud.find_child("cinar_meclisi", true, false) as Button
	_kontrol(b == null or not b.visible, "Kamuoyu yokken meclis düğmesi görünmez")
	_kontrol(e.hud.find_child("kamuoyu_seridi", true, false) == null, "Kamuoyu yokken HUD satırı yok")
	o.gece_sonu()
	ana._koye_git()
	await get_tree().process_frame
	e = ana._ekran
	var serit := e.hud.find_child("kamuoyu_seridi", true, false) as Button
	_kontrol(serit != null and serit.visible and serit.text.contains("Garip bir yolcunun"), "Kamuoyu HUD'da tek satır")
	_kontrol(e.hud.find_children("kamuoyu_seridi", "", true, false).size() == 1, "Satır bir kez")
	if serit != null: serit.pressed.emit()
	await get_tree().process_frame
	var defter := e.get_node_or_null("HafizaDefteriEkrani") as HafizaDefteriEkrani
	_kontrol(defter != null and defter._sayfalar[defter.sayfa] == "soylenti", "Satır defteri Söylenti sayfasında açar")
	if defter != null:
		var sayfa: Array = defter.defter.oku(defter.kaynak).soylenti
		_kontrol(sayfa.size() == SoylentiKoprusu.ag(o).ag_kayitlari.size() and sayfa.size() == 1, "Sayfa ağ kaydıyla eşit")
		_kontrol(_metin(defter).contains("Garip bir yolcunun") and _metin(defter).contains(o.yonetim.koylu(tasiyan).ad), "Satır olayı ve kaynağı gösterir")
		defter.kapat()
		await get_tree().process_frame
	KoyluKarti.ac(e, tasiyan)
	var soz := e._ust_kart.find_child("soz_guvenilirligi", true, false) as Label if e._ust_kart != null else null
	_kontrol(soz != null and soz.text == "Sözü: konuşkan", "Kartta güvenilirlik kelimesi")
	e._kart_kapat()
	SoylentiKoprusu.ag(o).guvenilirlik_degistir(str(tasiyan), 1)
	KoyluKarti.ac(e, tasiyan)
	soz = e._ust_kart.find_child("soz_guvenilirligi", true, false) as Label if e._ust_kart != null else null
	_kontrol(soz != null and soz.text == "Sözü: ağzı sıkı" and not RegEx.create_from_string("[0-9]").search(soz.text), "Kelime değişir, sayı yok")
	var sor := e._ust_kart.find_child("ne_duydun", true, false) as Button if e._ust_kart != null else null
	_kontrol(sor != null and e._ust_kart.find_child("ne_duydun_cevabi", true, false) == null, "Duyan köylüde Ne duydun? dalı var, cevap basılmadan yok")
	if sor != null: sor.pressed.emit()
	var cevap := e._ust_kart.find_child("ne_duydun_cevabi", true, false) as Label if e._ust_kart != null else null
	_kontrol(cevap != null and cevap.text.begins_with(o.yonetim.koylu(tasiyan).ad + ":") and cevap.text.contains("Garip bir yolcunun") and sor.disabled, "Köylü duyduğunu kendi ağzından söyler")
	var sus := e._ust_kart.find_child("bunu_konusma", true, false) as Button if e._ust_kart != null else null
	_kontrol(sus != null and not sus.disabled, "Cevaptan sonra Bunu konuşma seçeneği")
	if sus != null: sus.pressed.emit()
	_kontrol(sus != null and sus.disabled and sus.text.ends_with("başını salladı."), "Susturma sonucu oyuncuya söylenmez")
	e._kart_kapat()
	var duymayan := -1
	for k in o.yonetim.koylular:
		if NeDuydun.kayit(o, k).is_empty(): duymayan = k.id
	_kontrol(duymayan > 0, "Köyde henüz duymayan biri var")
	KoyluKarti.ac(e, duymayan)
	_kontrol(e._ust_kart != null and e._ust_kart.find_child("ne_duydun", true, false) == null, "Duymayan köylüde dal yok")
	e._kart_kapat()
	await get_tree().process_frame
	b = e.hud.find_child("cinar_meclisi", true, false) as Button
	_kontrol(b != null and b.visible and not b.disabled, "Kamuoyu konusu meclisi açar")
	if b != null and not b.disabled: b.pressed.emit()
	await get_tree().process_frame
	var satir := e._ust_kart.find_child("meclis_soylenti_sikayeti", true, false) as Label if e._ust_kart != null else null
	var ad := o.yonetim.koylu(tasiyan).ad
	_kontrol(satir != null and satir.text.contains("ret kararı") and satir.text.begins_with(ad + ":"), "Şikâyet kararı ve taşıyanın adını taşır")
	var nitele := e._ust_kart.find_child("meclis_soylenti_nitele_yalan", true, false) as Button if e._ust_kart != null else null
	_kontrol(nitele != null and e._ust_kart.find_child("meclis_soylenti_nitele_dogru", true, false) != null, "Muhafızın iki nitelik seçeneği")
	if nitele != null: nitele.pressed.emit()
	var nl := e._ust_kart.find_child("meclis_soylenti_niteleme", true, false) as Label if e._ust_kart != null else null
	_kontrol(nl != null and nl.text.contains("yalan") and nitele.disabled and SoylentiKoprusu.ag(o).guvenilirlik_al(SoylentiKoprusu.MUHAFIZ) == 1, "Nitelik kartta, muhafız −1")
	var hukum := e._ust_kart.find_child("meclis_soylenti_hukum", true, false) as Button if e._ust_kart != null else null
	_kontrol(hukum != null and not hukum.disabled, "Şikâyetin altında hüküm kararı")
	if hukum != null: hukum.pressed.emit()
	var sonuc := e._ust_kart.find_child("meclis_soylenti_sonucu", true, false) as Label if e._ust_kart != null else null
	_kontrol(sonuc != null and sonuc.text.contains("Garip bir yolcunun") and hukum.disabled, "Hüküm kartta yazılır")
	_kontrol(SoylentiKoprusu.kamuoyu_satiri(o).is_empty(), "Hükümden sonra kamuoyu söner")
	var dava_dugmesi := e._ust_kart.find_child("meclis_davasi_ac", true, false) as Button if e._ust_kart != null else null
	_kontrol(dava_dugmesi != null, "MECLIS-ARA-01: Çınar meclisinde dava açma düğmesi var")
	if dava_dugmesi != null:
		dava_dugmesi.pressed.emit()
		for _f in 4:
			await get_tree().process_frame
		var dpanel := e.get_node_or_null("MeclisDavaPaneli") as KoyDiyalogPaneli
		var dy := KoyDiyalogYoneticisi.aktif_yonetici
		_kontrol(dpanel != null and dy != null and dy.ast != null and dy.ast.title == "meclis_davalari", "MECLIS-ARA-01: meclis_davalari.ds sahnesi açıldı")
		_kontrol(dy != null and dy.son_secenekler.size() == 4, "MECLIS-ARA-01: 4 dava seçeneği sunuldu")
		if dy != null and dy.son_secenekler.size() >= 1:
			dy.secenek_sec(dy.son_secenekler[0])
			for _f in 4:
				await get_tree().process_frame
			_kontrol(dy.son_secenekler.size() == 2, "MECLIS-ARA-01: dava hüküm seçenekleri açıldı")
			if dy.son_secenekler.size() >= 1:
				dy.secenek_sec(dy.son_secenekler[0])
				for _f in 4:
					await get_tree().process_frame
		if dpanel != null and is_instance_valid(dpanel):
			dpanel._kapat()
			await get_tree().process_frame
	print("SÖYLENTİ MECLİS UI: GEÇTİ" if hata == 0 else "SÖYLENTİ MECLİS UI: KALDI (%d hata)" % hata)
	ana.kayit.sil()
	await Ses.cik(hata)


func _gelen(id: String) -> Gelen:
	var g := Gelen.new()
	g.id = StringName(id)
	g.ad_anahtari = "test"
	g.sinif = &"koylu"
	return g


func dene_bos(bos: Oturum) -> void:
	var k := bos.yonetim.kabul({"ad": "Kart"})
	_kontrol(KoyluKartiVerisi.soz_guvenilirligi(bos, k) == "Sözü: konuşkan" and not bos.has_meta(SoylentiKoprusu.META), "Kart okuması ağ kurmaz")


func _metin(n: Node) -> String:
	if n == null: return ""
	var r: String = n.text if n is Label or n is Button else ""
	for c in n.get_children(): r += " " + _metin(c)
	return r


func _kontrol(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
