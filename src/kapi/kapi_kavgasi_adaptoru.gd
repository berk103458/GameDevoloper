## CAT-01: mevcut karar, yatak, nöbet ve Dedikodu sistemlerine ince köprü.
extends RefCounted

const META := &"cat01_kapi_kavgasi"
const BARINAK = preload("res://src/kapi/barinak_uyarisi.gd")
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(KapiKavgasi.VERI_YOLU))

var kavga := KapiKavgasi.new()
var son: Dictionary = {}
var _oturum: WeakRef
var _kuyruk: Array[Gelen] = []

static func al(o: Oturum) -> RefCounted:
	if not o.has_meta(META):
		var a := new()
		a._oturum = weakref(o)
		o.set_meta(META, a)
		o.yonetim.nobet_degisti.connect(a.nobet_degisti)
	return o.get_meta(META)

## Eşleme ziyaret hazırlandıktan sonra yapılır; isim ve sınıfa göre tip uydurulmaz.
static func tip_ata(g: Gelen, zengin_esigi: int) -> void:
	if not g.kavga_tip.is_empty(): return
	var alanlar := {
		"giris_anahtari": g.giris_anahtari,
		"sinif": String(g.sinif),
		"aile_ac": str(g.aile.size() > 1 and g.heybe != null and not g.zengin(zengin_esigi)),
	}
	for esleme: Dictionary in AYAR.get("tip_eslemeleri", []):
		if alanlar.get(esleme.alan, "") == esleme.deger:
			g.kavga_tip = String(esleme.tip)
			return

static func kuyruk_hazirla(o: Oturum, kuyruk: Array[Gelen]) -> void:
	for g in kuyruk: tip_ata(g, o.ayarlar.zengin_esigi)
	tanik_hazirla(o, kuyruk)

## Gerçek ekran kalan sırayı verir; motor kuyruğu da aynı kuralı kullanır.
static func tanik_hazirla(o: Oturum, kuyruk: Array[Gelen]) -> void:
	al(o)._kuyruk = kuyruk.duplicate()

static func ret(o: Oturum, g: Gelen, karar: StringName, ek: Dictionary) -> void:
	var a = al(o)
	a.nobet_degisti()
	var neden := "siradan_ret"
	if not BARINAK.yeter_mi(o.yonetim, maxi(1, g.aile.size())):
		neden = "yer_yoklugu"
	elif g.kusurlu() or karar == &"elkoy" or ChrKararMatrisi.matris_anahtari(g.chr_sorgusu(), karar) == &"zorunlu_ret":
		neden = "sert_ret"
	var kimlik := String(g.id) if not String(g.id).is_empty() else "figur_%d" % g.get_instance_id()
	var tanik := ""
	for diger: Gelen in a._kuyruk:
		if diger == g: continue
		tanik = String(diger.id) if not String(diger.id).is_empty() else "figur_%d" % diger.get_instance_id()
		break
	var baglam := {
		"kisi_id": kimlik, "gun": o.gun, "tip": g.kavga_tip,
		"neden": neden, "asker_sayisi": o.yonetim.muhafiz_sayisi(),
		"mekan": String(o.get_meta(&"cat01_mekan", "kapi")),
		"heyet_aktif": DiplomatikHeyet.ilgilenir(g) or DiplomatikHeyet.gecis_engeli(o, g) or DiplomatikHeyet.kilitli(o, a._kuyruk),
		"tanik": tanik,
	}
	a.son = a.kavga.ret_degerlendir(baglam, o.dedikodu)
	a.son["ret_nedeni"] = neden
	ek.merge(a.son, true)
	# Aynı karar sözlüğü ayrılış sinyalinde de güncellenir.
	a.son = ek

func nobet_degisti() -> void:
	var o = _oturum.get_ref()
	if o == null or o.yonetim.muhafiz_sayisi() > 0 or kavga.aktif_kavga().is_empty(): return
	son.merge(kavga.asker_ayrildi(o.dedikodu), true)

static func sonuc_yaz(ekran: Node, sonuc: Dictionary) -> void:
	match String(sonuc.get("durum", "")):
		"kavga_acik": ekran._yaz("[b]%s[/b]" % KapiKavgasi.YER_TUTUCU_CANLANDIRMA.metin)
		"tehdit_edip_gitti": ekran._yaz("[i]Geri çevrilen kişi tehdit edip gitti.[/i]")
		"kacti": ekran._yaz("[i]Asker ayrılınca kapıdaki arbede bitti; kişi kaçtı.[/i]")
