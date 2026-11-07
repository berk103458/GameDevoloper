## ISG-67: otuz gerçek gece; ölçüm salt okunur ve formül ayarlamaz.
extends SceneTree
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 6767)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 100000
	y.a.evsiz_moral = 0
	y.a.isyan_esigi = -1
	y.akce = 100000
	y.kaynaklar = Kaynaklar.new(100000, {"gida": 10000, "su": 10000, "odun": 10000})
	for id in [77, 78]:
		var b := KoyBinasi.new()
		b.id = id
		b.tur = "odunluk"
		b.hucre = Vector2i(2 if id == 77 else 6, 2)
		y.binalar.append(b)
	var a := y.kabul({"ad": "Çalışan", "sinif": "esnaf"})
	var bosta := y.kabul({"ad": "Boşta", "sinif": "esnaf"})
	var cocuk := y.kabul({"ad": "Çocuk"})
	cocuk.yas_grubu = &"cocuk"
	var es := y.kabul({"ad": "Eş"})
	es.bayrak_ekle("acl01_es")
	dene(y.ata(a.id, 77), "Gerçek başlangıç ataması")
	var olcumler: Array[Dictionary] = []
	for gun in 30:
		if gun == 15: dene(y.ata(bosta.id, 78), "İkinci yarıda ikinci kişi çalışır")
		var r := y.gece()
		dene(y.son.is_empty() and y.gun == gun + 1, "Ölçüm gerçek geceyi tamamlar")
		var once := o.kaydet()
		var olcum := DengeOlcumu.olustur(o, r)
		olcumler.append(olcum)
		dene(o.kaydet() == once, "Günlük DEN gözlemi kayıt/RNG değiştirmez")
		var is_ := olcum.get("is_olcumu", {}) as Dictionary
		dene(is_.get("isgucu", -1) == 2 - int(KisHastaligi.hasta(a)) - int(KisHastaligi.hasta(bosta)) and is_.get("bosta", -1) == (1 if gun < 15 else 0), "Çocuk/eş hariç yetişkin sayımı gece fotoğrafındadır")
	var foto := o.kaydet()
	var rapor := DengeOlcumu.is_raporu(olcumler)
	dene(rapor.get("hazir", false) and rapor.get("gun", 0) == 30, "Otuz gece tek rapor üretir")
	dene(is_equal_approx(float(rapor.get("bosta_orani", -1)), 15.0 / 54.0), "Hastalıklı günler hariç kişi-gün oranı 15/54")
	dene(not rapor.get("bantta", true), "Yüzde25 üstündeki ölçüm bant dışındadır")
	dene(DengeOlcumu.is_raporu(olcumler) == rapor and o.kaydet() == foto, "Tekrarlanan otuz günlük rapor salt okunur")
	dene(not DengeOlcumu.is_raporu(olcumler.slice(0, 29)).get("hazir", true), "Eksik pencere hazır değildir")
	var sinir: Array[Dictionary] = []
	for gun in 30: sinir.append({"is_olcumu": {"gun": gun, "bosta": 1, "isgucu": 4}})
	var sifir := sinir.duplicate(true)
	for satir in sifir: satir.is_olcumu.bosta = 0
	dene(DengeOlcumu.is_raporu(sifir).get("bantta", false), "Sıfır boşta oranı alt sınırda dahildir")
	var uzayan := sinir.duplicate(true)
	uzayan.append({"is_olcumu": {"gun": 30, "bosta": 1, "isgucu": 4}})
	uzayan.reverse()
	var kayan := DengeOlcumu.is_raporu(uzayan)
	dene(kayan.get("ilk_gun", -1) == 1 and kayan.get("son_gun", -1) == 30 and kayan.get("bosta_kisi_gun", -1) == 30, "Sırasız uzun geçmişte yalnız son otuz gece sayılır")
	var sinir_foto := sinir.duplicate(true)
	dene(DengeOlcumu.is_raporu(sinir).get("bantta", false), "Tam yüzde25 üst sınırı dahil")
	sinir.append(sinir[0].duplicate(true))
	dene(DengeOlcumu.is_raporu(sinir).get("bosta_kisi_gun", -1) == 30, "Aynı fotoğraf ikinci kişi-gün yazmaz")
	var cakisik := sinir.duplicate(true)
	cakisik[0].is_olcumu.bosta = 2
	dene(not DengeOlcumu.is_raporu(cakisik).get("hazir", true), "Çelişen aynı gece reddedilir")
	var kesik := sinir_foto.duplicate(true)
	kesik[4].is_olcumu.gun = 31
	dene(not DengeOlcumu.is_raporu(kesik).get("hazir", true), "Otuz satırda eksik gece pencereyi tamamlamaz")
	for v in [null, {}, {"gun": 0, "bosta": true, "isgucu": 2}, {"gun": 0, "bosta": 3, "isgucu": 2}, {"gun": 0.5, "bosta": 1, "isgucu": 2}]:
		var bozuk: Array[Dictionary] = [{"is_olcumu": v}]
		dene(not DengeOlcumu.is_raporu(bozuk).get("hazir", true), "Bozuk ölçüm hazır sayılmaz")
	var bos: Array[Dictionary] = []
	for gun in 30: bos.append({"is_olcumu": {"gun": gun, "bosta": 0, "isgucu": 0}})
	var bos_rapor := DengeOlcumu.is_raporu(bos)
	dene(bos_rapor.get("hazir", false) and not bos_rapor.get("olculebilir", true) and not bos_rapor.get("bantta", true), "İşgücü olmayan pencere denge kabulü vermez")
	dene(sinir_foto == sinir.slice(0, 30), "Toplayıcı girdi fotoğraflarını değiştirmez")
	print("İŞ ÖLÇÜMÜ: GEÇTİ" if hata == 0 else "İŞ ÖLÇÜMÜ: KALDI")
	quit(hata)
