extends Node
const I = preload("res://src/koy/kisisel_iz.gd")
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
	print("KISISEL IZ OYUN: %s (%d kontrol, %d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", kontrol, hata])
	get_tree().quit(1 if hata > 0 else 0)
func oyun() -> bool:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 42)
	var g := o._adli_gelen(&"chr_017")
	g.chr_sorgusu().bayraklar["Flag_Sir_Tamamen_Cozuldu"] = true
	var r := o.karar_ver(g, &"kabul")
	dene(r.get("kaldi", false), "Gerçek Fadime kabulü")
	var k := o.yonetim.koylu(int(r.get("koylu_id", -1)))
	if k == null: return false
	var b := KoyBinasi.new()
	b.id = 900
	b.tur = "agil"
	b.hucre = Vector2i(10, 10)
	o.yonetim.binalar.append(b)
	dene(k.zanaat_turu == ZanaatTuru.Tur.COBAN, "Kabul edilen Fadime gerçek çoban mesleğinde")
	k.is_yeri = KoyYonetimi.BOSTA
	var e := KoyEkrani.new()
	e.oturum = o
	e.ayarlar = Ayarlar.new()
	add_child(e)
	await get_tree().process_frame
	e._hiz_sec(0)
	I.yenile(e)
	var grup := e.sahne3b.get_node("kisisel_izler")
	dene(grup.get_child_count() == 1, "Gerçek köyde tek iz")
	var n := grup.get_child(0) as MeshInstance3D
	dene(n.get_meta("clue") == "Clue_CHR017_Kurdele" and n.get_meta("bina") == b.id and n.mesh is BoxMesh, "Kurdele ağıl kutusuna bağlı")
	dene(n.position == e.sahne3b.alan_merkezi(b.hucre + Vector2i(b.boyut(o.yonetim.katalog).x, 0), Vector2i.ONE) + Vector3(0, 0.2, 0), "Kutu yapı modelinin dışında zeminin üstünde")
	dene(k.is_yeri == KoyYonetimi.BOSTA, "İz otomatik işçi yazmaz")
	var once := o.yonetim.kaydet().duplicate(true)
	I.yenile(e)
	dene(o.yonetim.kaydet() == once and grup.get_child_count() == 1, "Üretim ve atama değişmez; ikinci iz yok")
	KoyluKarti.ac(e, k.id)
	dene(e.find_child("kisisel_iz", true, false).text == TranslationServer.translate("arayuz.koy.iz_kurdele"), "Gerçek kartta sayı yerine kelime")
	# İş binası yoksa yalnız mevcut ev kullanılır, bina veya işçi üretilmez.
	o.yonetim.binalar.erase(b)
	var ev := KoyBinasi.new()
	ev.id = 901
	ev.tur = "ev"
	ev.hucre = Vector2i(12, 10)
	o.yonetim.binalar.append(ev)
	k.ev = ev.id
	I.yenile(e)
	dene(n.get_meta("bina") == ev.id and o.yonetim.binalar.has(ev) and not o.yonetim.binalar.has(b), "İş binası yokken ev yanında; ağıl kendiliğinden kurulmaz")
	o.yonetim.binalar.append(b)
	k.is_yeri = b.id
	I.yenile(e)
	dene(n.get_meta("bina") == b.id, "Kişinin gerçek iş binası öncelikli")
	var oturum_kaydi := o.kaydet()
	var yuklenen := Oturum.kayittan(kat, oturum_kaydi)
	dene(yuklenen != null and yuklenen.kadro.durumlar[k.adli_id].get("kisisel_iz") == "Clue_CHR017_Kurdele", "Gerçek oturum kaydı izi taşır")
	oturum_kaydi.kadro["chr_017"].erase("kisisel_iz")
	var eski := Oturum.kayittan(kat, oturum_kaydi)
	dene(eski != null and not eski.kadro.durumlar[k.adli_id].has("kisisel_iz"), "Eski oturum kaydı yeni iz üretmez")
	var kayit := o.kadro.kaydet()
	dene(kayit["chr_017"].kisisel_iz == "Clue_CHR017_Kurdele" and o.kadro.yukle(kayit), "Kadro kayıt gidiş dönüşü")
	kayit["chr_017"].erase("kisisel_iz")
	o.kadro.yukle(kayit)
	I.yenile(e)
	dene(grup.get_child_count() == 0, "Eski kayıtta alan yoksa izsiz")
	o.kadro.durumlar[k.adli_id]["kisisel_iz"] = "Clue_CHR017_Kurdele"
	o.kadro.durumlar[k.adli_id]["durum"] = &"kalici_ayrildi"
	I.yenile(e)
	dene(grup.get_child_count() == 0 and not o.kadro.durumlar[k.adli_id].has("kisisel_iz"), "Temelli ayrılış izi siler")
	o.kadro.durumlar[k.adli_id]["durum"] = &"koyde"
	o.kadro.durumlar[k.adli_id]["kisisel_iz"] = "Clue_CHR017_Kurdele"
	k.saglik = 0
	I.yenile(e)
	dene(grup.get_child_count() == 0, "Ölüm izi siler")
	k.saglik = 100
	o.kadro.durumlar[k.adli_id]["kisisel_iz"] = "Clue_CHR017_Kurdele"
	o.muhafiz_esyalari.append({"id": "Clue_CHR017_Kurdele", "adet": 1, "edinim": "rusvet"})
	I.yenile(e)
	dene(grup.get_child_count() == 0, "Aynı eşya odada ise köyde ikinci kopya yok")
	o.kadro.durumlar[k.adli_id]["kisisel_iz"] = "Clue_CHR017_Kurdele"
	o.yonetim.koylular.erase(k)
	I.yenile(e)
	dene(not o.kadro.durumlar[k.adli_id].has("kisisel_iz"), "Köy listesinden düşen kişinin izi kayıttan kalkar")
	var yuz := SevilenYuz.new()
	yuz.kisisel_iz_birak("chr_017", "Clue_CHR017_Kurdele")
	yuz.veda_et("chr_017")
	dene(yuz.kisisel_izler.is_empty(), "Mevcut SEV-07 veda API'si izi siler")
	var o2 := Oturum.new(kat, 43)
	var g2 := o2._adli_gelen(&"chr_017")
	g2.chr_sorgusu().bayraklar["Flag_Sir_Tamamen_Cozuldu"] = true
	o2.karar_ver(g2, &"rusvet")
	dene(o2.muhafiz_esyalari.size() == 2 and not o2.kadro.durumlar[g2.id].has("kisisel_iz"), "Gerçek rüşvet yalnız odaya")
	# Gönüllü kabul eşyası aynı karar tablosundan gelir; kaynak resource kopyası kullanılır.
	var g3 := o2._adli_gelen(&"chr_004")
	var s = g3.chr_sorgusu()
	s.karakter = s.karakter.duplicate(true)
	s.karakter.karar_matrisi["kabul"] = {"esyalar": ["Bir lokma ekmek"], "stat_etkisi": {}}
	o2.karar_ver(g3, &"kabul")
	dene(not o2.kadro.durumlar[g3.id].has("kisisel_iz"), "Sır çözülmediyse iz yok")
	dene(o2.muhafiz_esyalari.back().get("edinim") == "gonullu", "Gerçek kabul yolu gönüllü lokmayı rafa taşır")
	var oda := MuhafizOdasiEkrani.new()
	oda.oturum = o2
	add_child(oda)
	await get_tree().process_frame
	dene(oda.find_child("oda_esya_0", true, false).find_child("esya_adi", true, false).text.contains(TranslationServer.translate("arayuz.oda.etiket_eksi")), "Gerçek oda sergisinde ekşi etiket")
	dene(oda.find_child("oda_esya_2", true, false).find_child("esya_adi", true, false).text.contains(TranslationServer.translate("arayuz.oda.etiket_sicak")), "Aynı rafta sıcak etiket")
	dene(oda.oda.get_node("kisisel_esya_sergisi").get_child_count() == 3, "Oda kadrajında aynı serginin kutuları")
	oda.queue_free()
	e.queue_free()
	await get_tree().process_frame
	return true
