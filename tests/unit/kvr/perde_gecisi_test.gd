## SYS-19: nüfus 18 → "Köy oturdu" (perde 2); gün sayacı sıfırlanmaz; 2. perde 12 gece sonra biter; kayıt kalıcı.
extends SceneTree
const PERDE = preload("res://src/koy/perde_gecisi.gd")
var hata := 0
var kat: Katalog

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func hazir(nufus: int) -> Oturum:
	var o := Oturum.new(kat, 1919)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.ambar_taban_kapasite = 100000
	y.a.isyan_esigi = -1
	y.a.harac_araligi = 100000
	kat.koy_ayarlari = y.a
	y.kaynaklar = Kaynaklar.new(100000, {"gida": 20000, "odun": 2000, "su": 2000})
	y.akce = 5000
	for i in nufus:
		var k := y.kabul({"ad": "Köylü %d" % i})
		k.moral = 90
	return o

func _initialize() -> void:
	kat = Katalog.new()
	kat.yukle()
	var o := hazir(17)
	var s := o.gece_sonu()
	dene(o.perde == 1 and not s.perde_degisti and PERDE.baslangic(o.yonetim) == -1, "17 nüfusta 1. perde sürer")
	o.yonetim.kabul({"ad": "On sekizinci"})
	var gun_once := o.yonetim.gun
	s = o.gece_sonu()
	dene(s.perde_degisti and o.perde == 2, "18 nüfusta Köy oturdu (perde 2)")
	dene(o.yonetim.gun == gun_once + 1, "Gün sayacı sıfırlanmadı")
	dene(PERDE.baslangic(o.yonetim) == o.yonetim.gun and PERDE.gece(o.yonetim) == 0, "2. perde sayacı geçişte 0")
	dene(s.olaylar.filter(func(e: Dictionary) -> bool: return e.has("perde_gecisi")).size() == 1, "Geçiş rapor satırı")
	# Kayıt ortasında kalıcılık.
	var geri := Oturum.kayittan(kat, o.kaydet())
	dene(PERDE.baslangic(geri.yonetim) == PERDE.baslangic(o.yonetim) and geri.perde == 2, "Başlangıç kayıtta")
	var n := 0
	while o.yonetim.son == "" and n < 40:
		s = o.gece_sonu()
		n += 1
	dene(n == o.ayarlar.perde2_hedef_gece, "2. perde tam %d gece sürdü (%d)" % [o.ayarlar.perde2_hedef_gece, n])
	dene(String(s.son) == "zafer" and s.olaylar.filter(func(e: Dictionary) -> bool: return e.has("perde_gecisi") and e.perde_gecisi.tur == "bitti").size() == 1, "Hedefte son")
	dene(o.ayarlar.perde2_hedef_gece == 12, "Oyun ayarı 12 gece")
	# Legacy: agalik açık, alan yok → yükleme günü başlar, anında bitmez.
	var l := hazir(18)
	l.yonetim.agalik = true
	l.yonetim.gun = 30
	var v := l.kaydet()
	v.koy_yonetimi.erase("perde2_baslangic")
	var lg := Oturum.kayittan(kat, v)
	dene(PERDE.baslangic(lg.yonetim) == 30 and lg.gece_sonu().son == &"", "Legacy kayıt anında bitmez")
	# Bozuk/ileri tarih.
	v.koy_yonetimi["perde2_baslangic"] = 99999
	dene(PERDE.baslangic(Oturum.kayittan(kat, v).yonetim) == 30, "İleri tarih reddedilir")
	print("PERDE GECISI: GEÇTİ" if hata == 0 else "PERDE GECISI: KALDI")
	quit(hata)
