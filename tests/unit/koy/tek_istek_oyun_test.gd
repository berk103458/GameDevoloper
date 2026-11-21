extends Node
const I = preload("res://src/koy/tek_istek.gd")
var hata := 0
var kontrol := 0
func dene(v: bool, ad: String) -> void:
	kontrol += 1
	if not v:
		hata += 1
		push_error(ad)
func _ready() -> void:
	call_deferred("calistir")
func calistir() -> void:
	get_tree().create_timer(60).timeout.connect(func() -> void: get_tree().quit(1))
	if await oyun() != true: hata += 1
	print("TEK ISTEK OYUN: %s (%d kontrol, %d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", kontrol, hata])
	get_tree().quit(1 if hata > 0 else 0)
func kisi(o: Oturum, id: StringName) -> Koylu:
	var g := o._adli_gelen(id)
	o.kadro.ziyaret_basladi(id, o.gun)
	var r := o.karar_ver(g, &"kabul")
	dene(r.get("kaldi", false), "Gerçek kapı kabulü: " + String(id))
	return o.yonetim.koylu(int(r.get("koylu_id", -1)))
func oyun() -> bool:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 42)
	var k := kisi(o, &"chr_002")
	if k == null: return false
	dene(k.zanaat_turu == ZanaatTuru.Tur.CIFTCI, "Gerçek çiftçi")
	var kapi := KapiEkrani.new()
	kapi.oturum = o
	kapi.ayarlar = Ayarlar.new()
	add_child(kapi)
	kapi._gelen = o._adli_gelen(&"chr_001")
	kapi._sohbet_goster()
	await get_tree().process_frame
	dene(kapi._karar_dugmeleri.is_empty(), "Gerçek kapıda sohbet karar düğmelerini açmamış")
	var kapi_evre := kapi.evre
	var giris := o.gun
	var binalar := o.yonetim.binalar.duplicate()
	o.yonetim.binalar.clear()
	var e := KoyEkrani.new()
	e.oturum = o
	e.ayarlar = Ayarlar.new()
	add_child(e)
	await get_tree().process_frame
	e._hiz_sec(0)
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	dene(e.find_child("tek_istek", true, false) == null, "Yerleşme günü pencere açılmaz")
	o.yonetim.gun = giris + 1
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	dene(e.find_child("tek_istek", true, false) == null and o.yonetim.binalar.is_empty(), "Şart bina yokken istek/bina açılmaz")
	var b := KoyBinasi.new()
	b.id = 900
	b.tur = "ambar"
	b.hucre = Vector2i(10, 10)
	b.insa_kalan = 1
	o.yonetim.binalar.append(b)
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	dene(e.find_child("tek_istek", true, false) == null, "Bitmemiş bina yetmez")
	b.insa_kalan = 0
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	var satir := e.find_child("tek_istek", true, false) as Label
	dene(satir != null and satir.text == TranslationServer.translate("koy.istek.bir_cuval_tohum"), "Gerçek kartta tek istek cümlesi")
	dene(I.durum(o, k).konusma == 1, "Bir kez konuşuldu")
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	dene(I.durum(o, k).konusma == 1 and e.find_children("tek_istek", "Label", true, false).size() == 1, "Kartı tekrar açmak ikinci istek üretmez")
	var k2 := kisi(o, &"chr_011")
	if k2 == null: return false
	o.yonetim.gun += 1
	KoyluKarti.ac(e, k2.id)
	await get_tree().process_frame
	dene(e.find_child("tek_istek", true, false) == null and I.durum(o, k2).konusma == 0, "Başka kişi aynı anda ikinci istek söylemez")
	dene(kapi._karar_dugmeleri.is_empty() and kapi.evre == kapi_evre, "İstek gerçek kapının kabul/ret düğmesini açmaz")
	var bekleyen := &"chr_001"
	o.kadro.ziyaret_basladi(bekleyen, o.gun)
	o.kadro.durumlar[&"es"] = {"es": {"son_konu": "rusvet_almak", "gun": o.gun}}
	var veri := o.kaydet()
	var yuklenen := Oturum.kayittan(kat, veri)
	dene(yuklenen != null, "Eş hafızası bulunan kadro açılır")
	if yuklenen == null: return false
	dene(KisiHafizasi.es_hafizasi_oku(yuklenen.kadro, &"es") == {"son_konu": "rusvet_almak", "gun": o.gun}, "Eş hafızası korunur")
	dene(not yuklenen.kadro.durumlar[bekleyen].has("tek_istek") and yuklenen.kadro.kaydet() == veri.kadro, "Henüz isteği olmayan ziyaretçi aynı durumla yüklenir")
	var yk := yuklenen.yonetim.koylu(k.id)
	dene(I.konus(yuklenen, yk).konusma == 1, "Yükleme aynı konuşmayı çoğaltmaz")
	veri.kadro["chr_002"].erase("tek_istek")
	var eski := Oturum.kayittan(kat, veri)
	var ek := eski.yonetim.koylu(k.id)
	dene(I.konus(eski, ek).get("durum") == "eski_kayit", "Eksik alan eski kayıtta yeni istek olmaz")
	dene(I.metin(I.durum(eski, ek), I.tanim(ek)).is_empty(), "Eski kayıt kartında uydurma istek satırı yok")
	I.kabul(eski, eski._adli_gelen(&"chr_002"), true)
	dene(I.durum(eski, ek).get("durum") == "eski_kayit", "Eski kayıt tekrar kabulde de kopya üretmez")
	# Son günün gece sonu kancası, açık kartın satırını değiştirir.
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	o.yonetim.binalar.append_array(binalar)
	o.yonetim.gun = giris + 3
	var gece := o.gece_sonu()
	dene(not gece.get("engellendi", false), "Gerçek gece hesaplaşması çalıştı")
	preload("res://src/arayuz/koy_hud/tek_istek_karti.gd").yenile(e)
	satir = e.find_child("tek_istek", true, false) as Label
	dene(I.durum(o, k).durum == "suresi_doldu" and satir.text == TranslationServer.translate("koy.istek.suresi_doldu"), "Süre bitince mevcut kart satırı değişir")
	dene(not e.find_child("istek_tut", true, false).visible, "Süresi bitenin cevap düğmeleri kapanır")
	KoyluKarti.ac(e, k.id)
	await get_tree().process_frame
	dene(I.durum(o, k).konusma == 1, "Süre sonrası ikinci istek yok")
	# Kaynak yokken gerçek kart düğmesi bedelsiz başarı vermez.
	KoyluKarti.ac(e, k2.id)
	await get_tree().process_frame
	o.yonetim.kaynaklar.stok["bugday"] = 0
	var stok := o.yonetim.kaynaklar.kaydet()
	(e.find_child("istek_tut", true, false) as Button).pressed.emit()
	await get_tree().process_frame
	dene(I.durum(o, k2).durum == "kaynak_yok" and o.yonetim.kaynaklar.kaydet() == stok, "Eksik stok kapanır; bedelsiz tamamlanmaz")
	dene(not I.yanit(o, k2, true), "Kapalı isteğe ikinci cevap yok")
	var k3 := kisi(o, &"chr_013")
	if k3 == null: return false
	o.yonetim.gun += 1
	k3.yas_grubu = &"cocuk"
	KoyluKarti.ac(e, k3.id)
	await get_tree().process_frame
	dene(e.find_child("tek_istek", true, false) == null and I.durum(o, k3).durum == "kapandi", "Çocuk istek sahibi olmaz")
	var k4 := kisi(o, &"chr_020")
	if k4 == null: return false
	o.yonetim.gun += 1
	KoyluKarti.ac(e, k4.id)
	await get_tree().process_frame
	var husumet := o.yonetim.husumet.puan
	var retler := o.yonetim.husumet.reddedilenler.size()
	(e.find_child("istek_birak", true, false) as Button).pressed.emit()
	await get_tree().process_frame
	dene(I.durum(o, k4).durum == "reddedildi", "Karttan isteğe ret")
	dene(o.yonetim.husumet.puan == husumet and o.yonetim.husumet.reddedilenler.size() == retler + 1, "Ret mevcut husumet kaydında; ceza artışı yok")
	dene(not o.kadro.durumlar[k4.adli_id].has("verilen_soz"), "İstek borç veya söz yazmaz")
	dene(e.find_child("gorev_listesi", true, false) == null and e.find_child("istek_bari", true, false) == null and e.find_child("KapiEkrani", true, false) == null, "Görev düğümü/istek barı/kapı ekranı yok")
	# Ayrı gerçek oturumda başarılı harcama, ölüm, temelli ayrılış ve veda.
	var o2 := Oturum.new(kat, 43)
	var ka := kisi(o2, &"chr_002")
	var kb := kisi(o2, &"chr_011")
	var kc := kisi(o2, &"chr_013")
	var kd := kisi(o2, &"chr_020")
	if ka == null or kb == null or kc == null or kd == null: return false
	o2.yonetim.binalar.append(b)
	o2.yonetim.gun += 1
	I.konus(o2, ka)
	o2.yonetim.kaynaklar.stok["bugday"] = 5
	dene(I.yanit(o2, ka, true) and o2.yonetim.kaynaklar.miktar("bugday") == 3, "Başarı gerçek buğday harcar")
	dene(not I.yanit(o2, ka, true) and o2.yonetim.kaynaklar.miktar("bugday") == 3, "Çift cevap ikinci kez harcamaz")
	I.konus(o2, kb)
	kb.saglik = 0
	I.ilerlet(o2)
	dene(I.durum(o2, kb).durum == "kapandi", "Süre öncesi ölüm kapatır")
	I.konus(o2, kc)
	o2.kadro.durumlar[kc.adli_id].durum = &"kalici_ayrildi"
	I.ilerlet(o2)
	dene(I.durum(o2, kc).durum == "kapandi", "Temelli ayrılış kapatır")
	I.konus(o2, kd)
	SevilenYuz.new().veda_et(String(kd.adli_id), o2)
	dene(I.durum(o2, kd).durum == "kapandi", "SEV-07 veda API kapatır")
	var son := Oturum.kayittan(kat, o2.kaydet())
	var yeni := Oturum.kayittan(kat, Oturum.new(kat, 44).kaydet())
	var yeni_kisi := kisi(yeni, &"chr_002")
	if yeni_kisi == null: return false
	dene(I.durum(yeni, yeni_kisi).durum == "hazir", "Henüz gelmemiş kişi yükleme sonrası ilk isteğini korur")
	dene(I.konus(son, son.yonetim.koylu(ka.id)).durum == "tutuldu", "Tamamlanan istek yüklemede açılmaz")
	dene(I.konus(son, son.yonetim.koylu(kd.id)).durum == "kapandi", "Kapanan istek yüklemede açılmaz")
	kapi.queue_free()
	e.queue_free()
	await get_tree().process_frame
	return true
