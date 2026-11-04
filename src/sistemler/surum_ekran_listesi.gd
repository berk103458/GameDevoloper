## SRM-19, SRM-20: surum kontrolunun gezdigi on bir oyuncu ekrani.
class_name SurumEkranListesi
extends RefCounted

const KIMLIKLER: Array[String] = [
	"menu", "ayarlar", "yukleme", "kapi", "heybe", "koy", "harita", "divan", "oda", "gece_karti", "son",
]
const BOYUTLAR: Array[Vector2i] = [
	Vector2i(1280, 720), Vector2i(1600, 900), Vector2i(1920, 1080),
]


static func boyut_uygula(boyut: Vector2i) -> Vector2i:
	if DisplayServer.get_name() != "headless":
		DisplayServer.window_set_size(boyut)
	return boyut


static func ac(kimlik: String, oturum: Oturum, ayarlar: Ayarlar) -> Node:
	match kimlik:
		"menu":
			var menu := MenuEkrani.new()
			menu.ayarlar = ayarlar
			menu.baslik = TranslationServer.translate("arayuz.menu.baslik")
			menu.ust_satir = TranslationServer.translate("arayuz.menu.ust")
			menu.dugmeler = PackedStringArray(["a", "b", "c", "d"])
			menu.surum_metni = SurumKimligi.metin()
			return menu
		"ayarlar":
			var ayar_ekrani := AyarlarEkrani.new()
			ayar_ekrani.ayarlar = ayarlar
			return ayar_ekrani
		"yukleme":
			return VarlikYuklemePaneli.new()
		"kapi":
			var kapi := KapiEkrani.new()
			kapi.oturum = oturum
			kapi.ayarlar = ayarlar
			return kapi
		"heybe":
			var heybe := HeybePaneli.new()
			heybe.heybe = Heybe.new()
			heybe.ayarlar = ayarlar
			heybe.gelen_adi = "gelen"
			return heybe
		"koy":
			var koy := KoyEkrani.new()
			koy.oturum = oturum
			koy.ayarlar = ayarlar
			return koy
		"harita":
			var harita := HaritaEkrani.new()
			harita.oturum = oturum
			harita.ayarlar = ayarlar
			return harita
		"divan":
			var divan := DivanEkrani.new()
			divan.oturum = oturum
			return divan
		"oda":
			var oda := MuhafizOdasiEkrani.new()
			oda.oturum = oturum
			return oda
		"gece_karti":
			return _bilgi(ayarlar, oturum, TranslationServer.translate("arayuz.perde.baslik"), TranslationServer.translate("arayuz.perde.metin"))
		"son":
			var y := oturum.yonetim
			var metin := TranslationServer.translate("arayuz.son.istatistik") % [y.gun, y.kabul_sayisi, y.ret_sayisi, y.nufus()]
			return _bilgi(ayarlar, oturum, TranslationServer.translate("arayuz.perde.baslik"), metin)
		_:
			return Control.new()


static func _bilgi(ayarlar: Ayarlar, oturum: Oturum, baslik: String, metin: String) -> BilgiEkrani:
	var e := BilgiEkrani.new()
	e.ayarlar = ayarlar
	e.oturum = oturum
	e.baslik = baslik
	e.metin = metin
	e.arka_plan = ""
	e.dugmeler = PackedStringArray(["tamam"])
	return e
