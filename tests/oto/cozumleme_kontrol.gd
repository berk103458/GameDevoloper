extends Node
const F = preload("res://tests/oto/atama_duraklat_kontrol.gd")
const C = preload("res://src/koy/cozumleme.gd")
const D = preload("res://src/koy/usta_defterleri.gd")
const G = preload("res://src/sistemler/muhafiz_gecmisi.gd")
const A = preload("res://src/sistemler/acilis_senaryosu.gd")
const K = preload("res://src/sistemler/kapi_acilis_olayi.gd")
const ID := "usta_defteri_marangoz"
var hata := 0
var asil: Dictionary
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _ready() -> void:
	call_deferred("_calistir")
func kart(e: KoyEkrani, tur: String) -> YapiKarti:
	for c in e._yapi_satiri.get_children():
		if c is YapiKarti and c.get_meta("yapi_turu","") == tur: return c
	return null
func _calistir() -> void:
	# Proje yalnız Türkçe paketi yükler; kontrol diğer dil kaynağını açıkça ekler.
	var ingilizce := load("res://data/metin/metinler.en.translation") as Translation
	TranslationServer.add_translation(ingilizce)
	TranslationServer.set_locale("en")
	dene(preload("res://src/arayuz/koy_hud/cozumleme_paneli.gd")._t("baslat") == "Study","Yeni kontrol mevcut İngilizce çevirisini korur")
	TranslationServer.set_locale("tr")
	TranslationServer.remove_translation(ingilizce)
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var yedek := preload("res://src/arayuz/koy_hud/cozumleme_paneli.gd")._t("olmayan_test_anahtari",[1])
	dene(not yedek.is_empty() and not yedek.begins_with(GuvenliMetin.YOK),"Eksik yeni metin güvenli nötr sebep verir, biçimlendirme çökmez")
	asil = D.AYAR.duplicate(true)
	var ana := F.TestAna.new()
	add_child(ana)
	ana.kayit = GuvenliKayit.new("user://kalfa_yap05_ui_test.json")
	var o := ana.oturum
	dene(G.sec(o,"medrese_talebesi"),"Gerçek başlangıç geçmişi")
	A.kur(o)
	K.baslat(o)
	K.ulak_bitir(o)
	var aile := K.kuyruk(o)
	dene(not aile.is_empty() and not o.karar_ver(aile[0],&"ret").get("engellendi",false),"Gerçek ilk aile kararı geceyi açar")
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.kaynaklar = Kaynaklar.new(10000,{"gida":1000,"su":1000,"odun":1000,"tas":100,"kereste":100,"alet":100})
	y.akce = 1000
	var kisi := y.kabul({"ad":"İnceleyen kişi","sinif":"esnaf"})
	kisi.ev = int(A.durum(o).ev_id)
	D.ekle(o,ID)
	ana._koye_git()
	await get_tree().process_frame
	var e := ana._ekran as KoyEkrani
	e._kategori = "hizmet"
	e._yenile()
	await get_tree().process_frame
	var sec := kart(e,"cozumleme_odasi")
	dene(sec != null and not sec.disabled,"Mevcut geçmiş bilgisi gerçek K1 oda kartını açar")
	if sec == null:
		await _bitir(ana)
		return
	sec.pressed.emit()
	dene(e.kip == "insa","Gerçek kart inşa kipini seçer")
	var hucre := Vector2i(-1,-1)
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			if y.yerlesim("cozumleme_odasi",Vector2i(cx,cy)).olur:
				hucre = Vector2i(cx,cy)
				break
		if hucre.x >= 0: break
	e._imlec = hucre
	e._tikla()
	var oda: KoyBinasi
	for b in y.binalar:
		if b.tur == "cozumleme_odasi": oda = b
	dene(oda != null,"Normal yerleştirme yolu gerçek odayı kurar")
	if oda == null:
		await _bitir(ana)
		return
	for gece in 4:
		if oda.hazir(): break
		dene(not o.gece_sonu().get("engellendi",false),"İnşaat için gerçek gece")
	dene(oda.hazir(),"Oda gerçek işgücü ile tamamlanır")
	e._yenile()
	await get_tree().process_frame
	var kutu := e.sahne3b.find_child("CozumlemeOdaYerTutucu",true,false) as MeshInstance3D
	dene(kutu != null and kutu.mesh is BoxMesh and kutu.material_override is StandardMaterial3D and kutu.material_override.albedo_texture == null,"Oda gerçek sahnede düz renk kutudur")
	e._kip_sec("")
	e._imlec = oda.hucre
	e._tikla()
	var ata: Button
	for d in e._bilgi_icerik.find_children("*","Button",true,false):
		if d.text.begins_with(kisi.ad + "  ·"): ata = d
	dene(ata != null,"Mevcut yapı kartı çalışan ataması")
	if ata == null:
		await _bitir(ana)
		return
	ata.pressed.emit()
	await get_tree().process_frame
	dene(kisi.is_yeri == oda.id,"Gerçek atama düğmesi araştırmacıyı bağlar")
	var baslat := e.find_child("cozumleme_baslat_" + ID,true,false) as Button
	dene(baslat != null and not baslat.disabled,"Mevcut kart araştırma başlatmasını gösterir")
	if baslat == null:
		await _bitir(ana)
		return
	ana._duraklat()
	await get_tree().process_frame
	var foto := o.kaydet()
	baslat.pressed.emit()
	dene(o.kaydet() == foto,"Duraklatılan menüde araştırma/para değişmez")
	ana._ust_kapat()
	await get_tree().process_frame
	var kasa := y.akce
	baslat.pressed.emit()
	await get_tree().process_frame
	dene(C.durum(y).aktif.defter == ID and y.akce == kasa - int(D.AYAR.cozumleme.kamu_bedel),"Gerçek başlatma düğmesi tek kamu bedeli alır")
	var durum := e.find_child("cozumleme_durum",true,false) as Label
	dene(durum != null and durum.text.contains(D.AYAR.defterler[ID].ad),"İlerleme mevcut kartta görünür")
	D.AYAR.defterler["ikinci_defter"] = D.AYAR.defterler[ID].duplicate(true)
	D.AYAR.defterler.ikinci_defter.ad = "İkinci defter"
	D.ekle(o,"ikinci_defter")
	e._bilgi_goster()
	await get_tree().process_frame
	var sirala := e.find_child("cozumleme_baslat_ikinci_defter",true,false) as Button
	dene(sirala != null and not sirala.disabled,"İkinci defter için sıra düğmesi")
	if sirala != null: sirala.pressed.emit()
	await get_tree().process_frame
	var kuyruk := e.find_child("cozumleme_kuyruk",true,false) as Label
	dene(C.durum(y).kuyruk.size() == 1 and kuyruk != null and kuyruk.text.contains("1"),"Gerçek sıra düğmesi tek kuyruğu gösterir")
	o.gece_sonu()
	dene(C.durum(y).aktif.ilerleme == 1.0,"Oyuncu incelemesinde ilk gerçek gün")
	e._kip_sec("yik")
	e._imlec = oda.hucre
	e._tikla()
	dene(y.bina(oda.id) == null,"Gerçek oyuncu yıkımı odayı kaldırır")
	o.gece_sonu()
	dene(C.durum(y).aktif.ilerleme == 1.0,"Yıkımdan sonraki gerçek gece ilerlemeyi korur")
	e._kategori = "hizmet"
	e._yenile()
	await get_tree().process_frame
	sec = kart(e,"cozumleme_odasi")
	sec.pressed.emit()
	e._imlec = hucre
	e._tikla()
	for b in y.binalar:
		if b.tur == "cozumleme_odasi": oda = b
	for gece in 4:
		if oda.hazir(): break
		o.gece_sonu()
	e._yenile()
	e._kip_sec("")
	e._imlec = oda.hucre
	e._tikla()
	await get_tree().process_frame
	ata = null
	for d in e._bilgi_icerik.find_children("*","Button",true,false):
		if d.text.begins_with(kisi.ad + "  ·"): ata = d
	dene(ata != null,"Yeni odanın mevcut kartında aynı işçi tekrar atanır")
	if ata == null:
		await _bitir(ana)
		return
	ata.pressed.emit()
	await get_tree().process_frame
	var devam := e.find_child("cozumleme_devam",true,false) as Button
	dene(devam != null and not devam.disabled,"Etkin eski iş yeni odada devam ettirilebilir")
	if devam == null:
		await _bitir(ana)
		return
	kasa = y.akce
	devam.pressed.emit()
	await get_tree().process_frame
	var bagla := e.find_child("cozumleme_bagla_ikinci_defter",true,false) as Button
	dene(bagla != null and not bagla.disabled,"Sıradaki defter de yeni odaya bağlanabilir")
	if bagla != null: bagla.pressed.emit()
	await get_tree().process_frame
	dene(C.durum(y).aktif.ilerleme == 1.0 and int(C.durum(y).aktif.oda) == oda.id and int(C.durum(y).kuyruk[0].oda) == oda.id and y.akce == kasa,"Gerçek devam/bağlama ilerlemeyi korur ve yeniden bedel almaz")
	for gece in int(D.AYAR.defterler[ID].arastirma.sure_gun): o.gece_sonu()
	e._bilgi_goster()
	await get_tree().process_frame
	dene(ID in C.durum(y).tamamlanan and YapiKilidi.durum(y,"hizarhane").acik,"Oyuncu yoluyla çözümleme biter ve bilgi açılır")
	await _bitir(ana)
func _bitir(ana: Ana) -> void:
	ana.queue_free()
	await get_tree().process_frame
	D.AYAR = asil
	print("ÇÖZÜMLEME UI: GEÇTİ" if hata == 0 else "ÇÖZÜMLEME UI: KALDI")
	await Ses.cik(hata)
