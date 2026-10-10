## BUG-0011: gerçek hafta başı gecesi → rapor/HUD/bilanço/kayıt kapanışları.
extends Node
class KaydedilenOturum extends Oturum:
	var son_rapor: Dictionary = {}
	func olay_sec() -> OlayVerisi: return null
	func gece_sonu() -> Dictionary:
		son_rapor = super.gece_sonu()
		return son_rapor
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _ready() -> void:
	get_tree().create_timer(60.0).timeout.connect(func() -> void: get_tree().quit(1))
	var kat := Katalog.new()
	kat.yukle()
	var o := KaydedilenOturum.new(kat, 1111)
	var y := o.yonetim
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 200, "su": 200, "odun": 100})
	y.akce = 100
	y.gun = 1
	while not Takvim.hafta_basi(y.gun + 1, y.a.mevsim_gun): y.gun += 1
	var hasta := y.kabul({"ad": "Hasta"})
	SaglikYoneticisi.enfekte(y, hasta, "humma")
	hasta.bayrak_ac("hasta")
	hasta.moral = 50
	o.bayraklar[&"baci_tezgah"] = true
	o.bayraklar[&"dervis"] = true
	var kontrol := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(o.kaydet())))
	kontrol.bayraklar.clear()
	var eski := kontrol.gece_sonu()
	var e := KoyEkrani.new()
	e.oturum = o
	e.ayarlar = Ayarlar.new("user://unused_kapanis.cfg")
	add_child(e)
	await get_tree().process_frame
	e._gece_dugmesi.pressed.emit()
	await get_tree().process_frame
	var s := o.son_rapor
	dene(s.rapor.akce == eski.rapor.akce + 2 and s.rapor.huzur == eski.rapor.huzur + 2, "Gerçek kira/dua kapanışa dahil")
	var akce := e._ust_kart.find_child("gece_akce", true, false) as Label
	var huzur := e._ust_kart.find_child("gece_huzur", true, false) as Label
	dene(akce != null and akce.text == tr("koy.rapor.akce") % [100, y.akce], "Gerçek rapor akçe etiketi güncel")
	dene(huzur != null and huzur.text == tr("koy.rapor.huzur") % y.huzur(), "Gerçek rapor Huzur etiketi güncel")
	dene(e.hud._huzur_bar.value == s.rapor.huzur and e.hud._akce._miktar.text == str(y.akce), "HUD aynı kapanışları gösterir")
	dene(s.bilanco.kamu.sonra == y.akce and s.rapor.akce == y.akce, "Bilanço aynı kasa kapanışı")
	var kayit := GuvenliKayit.new("user://test_kapanis.json")
	dene(kayit.yaz(o.kaydet()), "Gerçek kayıt yazıldı")
	var geri := Oturum.kayittan(kat, kayit.oku())
	dene(geri.akce == s.rapor.akce and geri.yonetim.huzur() == s.rapor.huzur, "Kayıt rapor/HUD ile eşit")
	kayit.sil()
	e.queue_free()
	for i in 3: await get_tree().process_frame
	print("ATIL BAYRAK KAPANIS UI: GEÇTİ" if hata == 0 else "ATIL BAYRAK KAPANIS UI: KALDI")
	await Ses.cik(hata)
