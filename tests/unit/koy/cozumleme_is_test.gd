## YAP-05 iş/kuyruk/kayıt sözleşmesi; gece/sonuç kabulü ayrıca genişletilir.
extends SceneTree
const C = preload("res://src/koy/cozumleme.gd")
const D = preload("res://src/koy/usta_defterleri.gd")
const ID := "usta_defteri_marangoz"
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat,5051)
	var y := o.yonetim
	y.akce = 20
	var k := y.kabul({"ad":"İnceleyen","sinif":"esnaf"})
	D.ekle(o,ID)
	var once := o.kaydet()
	dene(not C.baslat(o,ID,99,k.id).ok and o.kaydet() == once,"Odasız başlatma ve tahsilat sıfır")
	var b := KoyBinasi.new()
	b.id = 99
	b.tur = "cozumleme_odasi"
	y.binalar.append(b)
	dene(y.ata(k.id,b.id),"Mevcut atama ile oda çalışanı")
	k.yas_grubu = &"cocuk"
	once = o.kaydet()
	dene(not C.baslat(o,ID,b.id,k.id).ok and o.kaydet() == once,"Çocuk çalışma/ücret başlatamaz")
	k.yas_grubu = &"yetiskin"
	y.akce = 1
	once = o.kaydet()
	dene(not C.baslat(o,ID,b.id,k.id).ok and o.kaydet() == once,"Bedel yetmezse mutasyon yok")
	y.akce = 20
	dene(C.baslat(o,ID,b.id,k.id).ok and y.akce == 18,"Tek kamu bedeliyle ilk iş başlar")
	once = o.kaydet()
	dene(not C.baslat(o,ID,b.id,k.id).ok and o.kaydet() == once,"Aynı iş tekrar para almaz")
	var asil := D.AYAR.duplicate(true)
	D.AYAR.defterler["ikinci_defter"] = D.AYAR.defterler[ID].duplicate(true)
	D.ekle(o,"ikinci_defter")
	var r := C.baslat(o,"ikinci_defter",b.id,k.id)
	dene(not r.ok and r.kuyrukta and C.durum(y).aktif.defter == ID and C.durum(y).kuyruk.size() == 1 and y.akce == 18,"İkinci aynı gün başlamaz, ücretsiz sırada bekler")
	var v: Dictionary = JSON.parse_string(JSON.stringify(o.kaydet()))
	var geri := Oturum.kayittan(kat,v)
	dene(geri != null and C.durum(geri.yonetim) == C.durum(y) and geri.yonetim.akce == 18,"Gerçek JSON etkin iş/kuyruk/bedeli korur")
	v.koy_yonetimi.erase("cozumleme")
	var eski := Oturum.kayittan(kat,v)
	dene(eski != null and C.durum(eski.yonetim).aktif.is_empty() and C.durum(eski.yonetim).kuyruk.is_empty(),"Eski kayıt iş uydurmadan açılır")
	var foto := C.durum(y)
	foto.aktif.ilerleme = 1.5
	C.yukle(y,foto)
	y.bosalt(k.id)
	once = C.durum(y)
	dene(not C.isci_degistir(o,ID,b.id,k.id) and C.durum(y) == once,"Görevden alınan kişi ilerlemeyi silemez/başlatamaz")
	dene(y.ata(k.id,b.id) and C.isci_degistir(o,ID,b.id,k.id) and C.durum(y).aktif.ilerleme == 1.5 and y.akce == 18,"İşçi dönünce aynı ilerleme ve tahsilat0")
	for bozuk in [null,{}, {"surum":true}, {"surum":2}]:
		dene(C.oku(bozuk).aktif.is_empty(),"Eksik/gelecek/bozuk alt kayıt iş yaratmaz")
	for alan in ["ilerleme","baslangic","isci"]:
		var bozuk := C.durum(y)
		bozuk.aktif[alan] = true
		dene(C.oku(bozuk).aktif.is_empty(),"Bozuk iş alanı iş/ödül yaratmaz: " + alan)
	var gelecek := C.durum(y)
	gelecek.aktif.baslangic = 10
	dene(C.oku(gelecek).aktif.is_empty(),"Başlangıç ve tek tahsilat makbuzu çelişemez")
	D.AYAR = asil
	print("ÇÖZÜMLEME İŞ: GEÇTİ" if hata == 0 else "ÇÖZÜMLEME İŞ: KALDI")
	quit(hata)
