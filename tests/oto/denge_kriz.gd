## DEN-60: mevcut KRI-10, gerçek gece düğmesi ve tek rapor; kriz motoru değildir.
extends Node
const F = preload("res://tests/oto/kriz_kenetlenmesi_kontrol.gd")
const KENET = preload("res://src/koy/kriz_kenetlenmesi.gd")
const PERSONA = preload("res://tests/oto/denge_persona.gd")
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _ready() -> void:
	call_deferred("_calistir")
func _calistir() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var ana := F.TestAna.new()
	add_child(ana)
	ana.kayit = GuvenliKayit.new("user://kalfa_den60_kriz.json")
	var y := ana.oturum.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 1000
	y.a.isyan_esigi = -1
	y.kaynaklar = Kaynaklar.new(1000,{"gida":150,"su":100,"odun":100})
	y.akce = 200
	var k := y.kabul({"ad":"İki krizden çıkan komşu"})
	k.moral = 85
	y.isyan_kalan = 3
	dene(SaglikYoneticisi.enfekte(y,k,"humma"),"Mevcut salgın kaydı kurulur")
	k.bayrak_ac("hasta")
	# Fixture süresi sınırdadır; iyileşmeyi mevcut gece hesabı yapar.
	k.enfeksiyon.bitis = y.gun
	dene(KENET.krizler(y).size() == 2,"DEN-60 aynı gecenin başında tam iki mevcut kriz")
	ana._koye_git()
	await get_tree().process_frame
	var e := ana._ekran as KoyEkrani
	var gun := y.gun
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	dene(y.gun == gun + 1 and y.isyan_kalan == -1 and not SaglikYoneticisi.hasta(k),"DEN-60 iki kriz tek gerçek gece hesabında kapanır")
	var baslik := tr("koy.rapor.baslik") % (gun + 1)
	var baslik_sayisi := 0
	var kriz_sayisi := 0
	for l in e.find_children("*","Label",true,false):
		if l.text == baslik: baslik_sayisi += 1
		if l.text.begins_with("Toplumsal kenetlenme"):
			kriz_sayisi += 1
			dene(l.text.contains("İsyan/kıtlık") and l.text.contains("Salgın"),"DEN-60 aynı rapor iki kriz kimliğini gösterir")
	dene(baslik_sayisi == 1 and kriz_sayisi == 1,"DEN-60 iki kriz, tek rapor başlığı ve tek birleşik kriz satırı")
	var once := ana.oturum.kaydet()
	DengeOlcumu.olustur(ana.oturum,{})
	dene(ana.oturum.kaydet() == once,"DEN-60 ölçüm ikinci gece/ödül üretmez")
	_kitlik(ana.katalog)
	_teshissiz(ana.katalog)
	await _kriz_araligi()
	ana.queue_free()
	await get_tree().process_frame
	print("DENGE KRİZ: GEÇTİ" if hata == 0 else "DENGE KRİZ: KALDI")
	await Ses.cik(hata)

func _kriz_araligi() -> void:
	var kat := Katalog.new()
	if kat.yukle() != Katalog.Durum.HAZIR:
		dene(false, "DEN-59 katalog yüklenmedi")
		return
	var tablo: Dictionary = preload("res://src/sistemler/denge_tablosu.gd").oku()
	var aralik: Dictionary = tablo.get("kriz_aralik", {})
	if not aralik.has_all(["alt", "ust"]):
		dene(false, "DEN-59 kriz aralığı eksik")
		return
	var persona := PERSONA.new()
	var gecerli := 0
	var aralikta := 0
	for tohum in range(5454, 5474):
		var sonuc := await persona.kos(kat, tohum)
		if sonuc.get("gece", 0) == 28 and sonuc.get("plan_bitti", false):
			gecerli += 1
			var toplam := 0
			for adet in sonuc.krizler.values(): toplam += int(adet)
			sonuc.toplam = toplam
			if toplam >= int(aralik.alt) and toplam <= int(aralik.ust): aralikta += 1
		print("DEN-59: ", JSON.stringify(sonuc))
		await get_tree().process_frame
	persona.free()
	print("DEN-59: %d/20 tam koşu, %d/20 aralıkta" % [gecerli, aralikta])
	dene(aralikta >= 16, "DEN-59: 20 tohumun en az 16 tanesi 28 geceyi aralıkta bitirir")


func _kitlik(kat: Katalog) -> void:
	var o := Oturum.new(kat,6161)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.isyan_esigi = -1
	y.a.ambar_taban_kapasite = 1000
	y.kaynaklar = Kaynaklar.new(1000,{"gida":0,"su":100,"odun":100})
	var k := y.kabul({"ad":"Kıtlık ölçüm komşusu"})
	k.moral = 85
	var ilk := o.gece_sonu()
	dene(y.kaynaklar.miktar("gida") == 0 and KitlikIsyani.durum(y).kitlik_gece_sayisi == 1 and not KitlikIsyani.durum(y).tetiklendi,"DEN-61 ilk gerçek sıfır erzak gecesi isyan başlatmaz")
	dene(ilk.olaylar.filter(func(e: Dictionary) -> bool: return e.has("kitlik_isyani")).is_empty(),"DEN-61 birinci gece kıtlık isyanı satırı0")
	kat.koy_ayarlari = y.a.duplicate(true)
	var geri := Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
	dene(geri != null,"DEN-61 birinci gece gerçek JSON ile yüklenir")
	if geri == null: return
	var ikinci := o.gece_sonu()
	var yuklu := geri.gece_sonu()
	dene(KitlikIsyani.durum(y).kitlik_gece_sayisi == 2 and KitlikIsyani.durum(y).tetiklendi,"DEN-61 ikinci gerçek sıfır erzak gecesi isyan başlatır")
	dene(ikinci.olaylar.filter(func(e: Dictionary) -> bool: return e.has("kitlik_isyani")).size() == 1,"DEN-61 ikinci gece tek gerçek kıtlık isyanı satırı")
	dene(KitlikIsyani.durum(geri.yonetim) == KitlikIsyani.durum(y) and yuklu.olaylar == ikinci.olaylar,"DEN-61 yükleme aynı ikinci geceyi verir, eşik bir geceye inmez")

func _teshissiz(kat: Katalog) -> void:
	var o := Oturum.new(kat,6262)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 10000
	y.a.isyan_esigi = -1
	y.kaynaklar = Kaynaklar.new(10000,{"gida":1000,"su":1000,"odun":1000,"tas":100})
	y.akce = 1000
	var k := y.kabul({"ad":"Teşhissiz sağlıklı çiftçi","sinif":"ciftci"})
	k.moral = 85
	var ev := _kur_k0(y,"cadir")
	var tarla := _kur_k0(y,"tarla")
	dene(ev != null and tarla != null,"DEN-62 gerçek K0 barınak ve iş kurulabilir")
	if ev == null or tarla == null: return
	k.ev = ev.id
	dene(y.ata(k.id,tarla.id),"DEN-62 yaşayan işçiyle28 gece ölçülür")
	var g := Gelen.new()
	dene(preload("res://src/kapi/hastalik_teshis_adaptoru.gd").kaydet(g).is_empty(),"DEN-62 açık belirti/teşhis kaydı yok")
	kat.koy_ayarlari = y.a.duplicate(true)
	var v: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	var geri := Oturum.kayittan(kat,v)
	dene(geri != null,"DEN-62 teşhissiz gerçek JSON açılır")
	if geri == null: return
	o = geri
	var salgin_gece := 0
	for gece in 28:
		o.gece_sonu()
		dene(o.gun == gece + 1 and o.yonetim.son.is_empty() and o.yonetim.nufus() == 1,"DEN-62 gerçek gece ve yaşayan nüfus korunur: " + str(gece + 1))
		if "salgin" in KENET.krizler(o.yonetim): salgin_gece += 1
		for kisi in o.yonetim.koylular:
			dene(not SaglikYoneticisi.hasta(kisi),"DEN-62 bulaşıcı enfeksiyon kendiliğinden oluşmaz")
		if gece == 13:
			geri = Oturum.kayittan(kat,JSON.parse_string(JSON.stringify(o.kaydet())))
			dene(geri != null,"DEN-62 orta gece kaydı devam eder")
			if geri == null: return
			o = geri
	dene(salgin_gece == 0 and o.gun == 28,"DEN-62 teşhissiz28 gerçek gecede salgın0")
	var hasta := o.yonetim.kabul({"ad":"Pozitif sağlık kontrolü","bayraklar":["humma"]})
	dene(SaglikYoneticisi.hasta(hasta),"DEN-62 sağlık yöneticisi kapatılmadı; gerçek hastalık kaynağı hâlâ çalışır")

func _kur_k0(y: KoyYonetimi, tur: String) -> KoyBinasi:
	for cy in y.a.izgara_boyut.y:
		for cx in y.a.izgara_boyut.x:
			var hucre := Vector2i(cx,cy)
			if not y.yerlesim(tur,hucre).olur: continue
			var b := y.bina(int(y.bina_kur(tur,hucre).id))
			if b != null: b.insa_kalan = 0
			return b
	return null
