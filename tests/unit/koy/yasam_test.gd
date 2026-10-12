## YSM-01: köylü başına açlık sayacı, yorgunluk (UZM-14 kaydı) ve moral (UZM-06) kaydı.
## Kabul iddialarının her biri bir dene(...) satırıdır.
extends SceneTree
const YASAM = preload("res://src/koy/yasam_barlari.gd")
var hata := 0
var kat: Katalog

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

## Dört tok başlangıçlı köylü, isyan kapalı, verilen erzak stoğu.
func hazir(gida: int, tohum: int = 1212) -> KoyYonetimi:
	var y := Oturum.new(kat, tohum).yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 1000
	y.a.isyan_esigi = -1
	y.kaynaklar = Kaynaklar.new(1000, {"gida": gida, "odun": 100, "su": 100})
	y.akce = 200
	for i in 4:
		var k := y.kabul({"ad": "Komşu %d" % i})
		k.saglik = 90
		k.moral = 70
	return y

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	_aclik_sayaci()
	_pay_eko09()
	_uc_deger()
	_olu_bar()
	_eski_kayit()
	_kri12_dokunulmaz()
	_koy_barlari()
	_kayit_koku()
	_kayit_yeniden_uygulamaz()
	_ikiz_tohum()
	_kapi_ve_kart()
	_oyuncu_ve_moral()
	_dosya_taramasi()
	print("YASAM: %s (%d hata)" % ["GEÇTİ" if hata == 0 else "KALDI", hata])
	quit(hata)

func _aclik_sayaci() -> void:
	var y := hazir(0)
	y.gece()
	for k in y.koylular:
		dene(k.aclik == 1, "Aç geceden sonra açlık sayacı 1 (kişi %d)" % k.id)
	y.kaynaklar.ekle("gida", 100)
	y.gece()
	for k in y.koylular:
		dene(k.aclik == 0, "Pay gelince sayaç 0'a döner (kişi %d)" % k.id)
	var k0 := y.koylular[0]
	var once := k0.aclik
	YASAM.metin(k0, y)
	YASAM.oku(k0, y)
	dene(k0.aclik == once, "Kart okuması sayacı değiştirmez")

func _pay_eko09() -> void:
	var tam := hazir(4)
	tam.gece()
	for k in tam.koylular:
		dene(k.aclik == 0, "EKO-09 tam payı kimseyi aç bırakmaz")
	var eksik := hazir(3)
	eksik.gece()
	var ac := 0
	for k in eksik.koylular:
		if k.aclik == 1: ac += 1
	dene(ac == 1, "Bir eksik erzak tam bir kişiyi aç bırakır (EKO-09 kişi başı 1)")

func _uc_deger() -> void:
	var y := hazir(100)
	var k := y.koylular[0]
	var d := YASAM.oku(k, y)
	dene(d.size() == 3, "Yüzen kartta çizilen yaşam değeri 3")
	dene(d.has("aclik") and d.has("yorgunluk") and d.has("moral"), "Üç değer: açlık, yorgunluk, moral")
	dene(not d.has("ortalama"), "Köy ortalaması çubuğu açılmaz")
	dene(YASAM.DEGERLER.size() == 3, "DEGERLER üç değerdir")
	dene(YASAM.metin(k, y).contains("Açlık"), "Kart satırı açlığı yazar")

func _olu_bar() -> void:
	var y := hazir(100)
	var k := y.koylular[0]
	k.saglik = 0
	dene(YASAM.oku(k, y).is_empty(), "Ölü kişide bar çizilmez (oku boş)")
	dene(YASAM.metin(k, y).is_empty(), "Ölü kişide satır boş")
	dene(YASAM.oku(null, y).is_empty(), "Geçersiz kişide bar çizilmez")

func _eski_kayit() -> void:
	var y := hazir(0)
	y.gece()
	var v := y.kaydet()
	for p in v.koylular:
		p.erase("aclik")
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, v)
	for k in geri.koylular:
		dene(k.aclik == 0, "Eski kayıtta açlık 0'dan başlar (kişi %d)" % k.id)
	geri.kaynaklar = Kaynaklar.new(1000, {"gida": 0, "odun": 100, "su": 100})
	geri.gece()
	for k in geri.koylular:
		dene(k.aclik == 1, "Eski kayıt sonraki aç gecede 1'e dolar (kişi %d)" % k.id)

func _kri12_dokunulmaz() -> void:
	var a := hazir(0, 777)
	var b := hazir(0, 777)
	for k in a.koylular:
		YASAM.oku(k, a)
		YASAM.metin(k, a)
	a.gece()
	b.gece()
	for i in a.koylular.size():
		dene(a.koylular[i].saglik == b.koylular[i].saglik, "Bar çizmek KRI-12 sağlık düşüşünü değiştirmez")
	dene(a._rng.state == b._rng.state, "Bar çizmek RNG akışını değiştirmez")

func _koy_barlari() -> void:
	var b := Barlar.new(4, 5, 10)
	dene(b.degerler.size() == 4, "barlar.gd dört bar olarak kalır")
	var y := hazir(0)
	var k := y.koylular[0]
	k.moral = 0
	k.aclik = 9
	k.yorgunluk = {"son_gece": y.gun - 1}
	var d := YASAM.oku(k, y)
	dene(b.degerler[0] == 5 and b.degerler[3] == 5, "Kişi morali halk/ordu/soylu/tüccar barına yazılmaz")
	dene(not d.has("halk") and not d.has("ordu") and not d.has("soylu") and not d.has("tuccar"), "Kişi değeri köy barı anahtarı taşımaz")

func _kayit_koku() -> void:
	var y := hazir(0)
	y.gece()
	var v := y.kaydet()
	dene(not v.has("yasam") and not v.has("yasam_json"), "Ayrı yasam.json kökü yazılmaz")
	for p in v.koylular:
		dene(p.has("aclik"), "Açlık üç değerin kişi kaydında tutulur (kişi %s)" % str(p.get("id", -1)))
	dene(not FileAccess.file_exists("res://data/koy/yasam.json"), "data/koy/yasam.json kökü yok")

func _kayit_yeniden_uygulamaz() -> void:
	var y := hazir(0)
	y.gece()
	var v := y.kaydet()
	var geri := KoyYonetimi.kayittan(y.a, y.katalog, v)
	for i in y.koylular.size():
		dene(geri.koylular[i].aclik == y.koylular[i].aclik, "Yükleme açlık artışını ikinci kez uygulamaz")
		dene(geri.koylular[i].yorgunluk == y.koylular[i].yorgunluk, "Yükleme yorgunluk kaydını ikinci kez uygulamaz")

func _ikiz_tohum() -> void:
	var a := hazir(0, 909)
	var b := hazir(0, 909)
	a.gece()
	b.gece()
	for i in a.koylular.size():
		dene(a.koylular[i].aclik == b.koylular[i].aclik, "İkiz tohum aynı açlık artışını yazar")
		dene(a.koylular[i].yorgunluk == b.koylular[i].yorgunluk, "İkiz tohum aynı yorgunluk kaydını yazar")

func _kapi_ve_kart() -> void:
	var y := hazir(0)
	y.gece()
	var once := y.koylular[0].aclik
	var yeni := y.kabul({"ad": "Kapıdan gelen"})
	dene(y.koylular[0].aclik == once, "Kapı kabulü açlık sayacını o anda değiştirmez")
	dene(yeni.aclik == 0, "Yeni köylü açlık 0'dan başlar")
	var k0 := y.koylular[0]
	var s := k0.aclik
	YASAM.metin(k0, y)
	dene(k0.aclik == s, "Olay/kart okuması açlık sayacına yazmaz")

func _oyuncu_ve_moral() -> void:
	var y := hazir(100, 555)
	var adlar: Array = []
	for p in y.get_property_list():
		adlar.append(p.name)
	dene(not ("aclik" in adlar), "Oyuncunun açlık alanı yoktur")
	var k := y.koylular[0]
	k.yorgunluk = {"son_gece": y.gun - 1}
	dene(bool(YASAM.oku(k, y).yorgunluk), "Yorgunluk UZM-14 gece vardiyası kaydından okunur")
	var idler: Array = []
	for x in y.koylular: idler.append(x.id)
	for x in y.koylular: x.moral = 0
	y.gece()
	for id in idler:
		dene(y.koylu(id) != null, "Moral 0 kişiyi köyden kaçırmaz (kişi %d)" % id)

func _dosya_taramasi() -> void:
	var t := FileAccess.get_file_as_string("res://src/koy/yasam_barlari.gd")
	dene(not t.is_empty(), "yasam_barlari.gd okunur")
	dene(not t.contains("koy_sahnesi"), "yasam_barlari.gd koy_sahnesi import etmez")
	dene(not t.contains("harita"), "yasam_barlari.gd ikinci harita açmaz")
	dene(not t.contains("kalp"), "yasam_barlari.gd kalp alanı yazmaz")
	dene(not t.contains("hediye"), "yasam_barlari.gd hediye moral sayısını doldurmaz")
