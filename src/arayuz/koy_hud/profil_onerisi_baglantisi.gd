## AYR-41: Köy günü boyunca kare hızını örnekler; gece raporunda ProfilOnerisi'ne verir.
## Üç gece ortalaması eşiğin altındaysa rapora bir kez "Düşük profil?" satırı düşer; profil değişmez.
class_name ProfilOnerisiBaglantisi
extends Node

const AD := &"ProfilOnerisiOlcer"
const META := &"profil_onerisi"
const SATIR := &"profil_onerisi"

var _ekran: Node
var _toplam := 0.0
var _sayi := 0


static func kur(ekran: Node) -> ProfilOnerisiBaglantisi:
	var olcer := ProfilOnerisiBaglantisi.new()
	olcer.name = AD
	olcer._ekran = ekran
	ekran.add_child(olcer)
	return olcer


static func oneri(oturum: Object) -> ProfilOnerisi:
	if not oturum.has_meta(META):
		oturum.set_meta(META, ProfilOnerisi.new())
	return oturum.get_meta(META)


func _process(_delta: float) -> void:
	var kilit: Variant = _ekran.get("_gece_kilidi")
	if kilit != null and kilit.kilitli():
		return
	ornek_ekle(float(PerformansSeridi.oku().get("fps", 0.0)))


func ornek_ekle(fps: float) -> void:
	if fps > 0.0:
		_toplam += fps
		_sayi += 1


func ortalama() -> float:
	return _toplam / float(_sayi) if _sayi > 0 else 0.0


## Gece rapor kartına çağrılır; satır eklendiyse onu döndürür.
static func gece(ekran: Node, kart: VBoxContainer) -> Label:
	var olcer := ekran.get_node_or_null(NodePath(String(AD))) as ProfilOnerisiBaglantisi
	var oturum: Object = ekran.get("oturum")
	if olcer == null or oturum == null or olcer._sayi == 0:
		return null
	var anahtar := oneri(oturum).gece_ekle(olcer.ortalama())
	olcer._toplam = 0.0
	olcer._sayi = 0
	var ayarlar: Variant = ekran.get("ayarlar")
	if anahtar == "" or (ayarlar != null and ayarlar.al(&"grafik_profili") == &"dusuk"):
		return null
	var satir := Label.new()
	satir.name = SATIR
	satir.text = ekran.tr(anahtar)
	satir.add_theme_font_size_override("font_size", Tema.KUCUK_PX)
	kart.add_child(satir)
	return satir
