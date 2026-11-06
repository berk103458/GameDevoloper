## DEN-60: mevcut KRI-10, gerçek gece düğmesi ve tek rapor; kriz motoru değildir.
extends Node
const F = preload("res://tests/oto/kriz_kenetlenmesi_kontrol.gd")
const KENET = preload("res://src/koy/kriz_kenetlenmesi.gd")
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
	ana.queue_free()
	await get_tree().process_frame
	print("DENGE KRİZ: GEÇTİ" if hata == 0 else "DENGE KRİZ: KALDI")
	await Ses.cik(hata)
