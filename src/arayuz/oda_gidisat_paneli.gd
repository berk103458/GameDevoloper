## OMR-13 ve OMR-14: Perde 2'de muhafiz odasinda alti son gostergesini (kademe sozcuguyle)
## ve dalga 2'den itibaren yaklasilan nihai sonun basligini gosterir. Perde 1'de gizlidir.
class_name OdaGidisatPaneli
extends RefCounted

const NihaiSonSinifi = preload("res://src/sistemler/nihai_son.gd")
const OmurgaSinifi = preload("res://src/sistemler/omurga.gd")
const OyuncuIziSinifi = preload("res://src/sistemler/oyuncu_izi.gd")

const GOSTERGE_SIRASI := ["huzur", "adalet", "refah", "guvenlik", "nufus", "yozlasma"]
const KADEME_METNI := {
	"dusuk": "düşük",
	"orta": "orta",
	"yuksek": "yüksek",
}


static func kademe_sozcugu(deger: int) -> String:
	var kod := NihaiSonSinifi._kademe(deger)
	return String(KADEME_METNI.get(kod, "orta"))


## OMR-13: Perde 2'de alti gosterge satiri doner (sayi yok, yalniz kademe sozcugu); Perde 1'de bos dizi.
static func gosterge_satirlari(o: Oturum) -> PackedStringArray:
	var sonuc := PackedStringArray()
	if o == null or o.perde < 2:
		return sonuc
	var g := NihaiSonSinifi.gostergeler(o)
	var tanimlar: Dictionary = NihaiSonSinifi.AYAR.get("gostergeler", {})
	for anahtar in GOSTERGE_SIRASI:
		var ad := String(tanimlar.get(anahtar, {}).get("ad", anahtar))
		var sozcuk := kademe_sozcugu(int(g.get(anahtar, 0)))
		sonuc.append("%s: %s" % [ad, sozcuk])
	return sonuc


## OMR-14: Verilen son kimligi icin `nihai_sonlar.json sonlar[n].baslik` adini tasiyan tek cumle doner.
static func gidisat_cumlesi_son_icin(son_id: String) -> String:
	var sonlar: Dictionary = NihaiSonSinifi.AYAR.get("sonlar", {})
	if not sonlar.has(son_id):
		return ""
	var baslik := String(sonlar[son_id].get("baslik", ""))
	if baslik.is_empty():
		return ""
	return "şu an gidişat: %s" % baslik


## OMR-14: Perde 2 dalga 2'den itibaren yaklasilan sonun cumlesini doner; oncesinde bos string.
static func gidisat_cumlesi(o: Oturum) -> String:
	if o == null or o.perde < 2:
		return ""
	var hedef := o.ayarlar.perde2_hedef_gece if o.ayarlar != null else 12
	if OmurgaSinifi.dalga(o.yonetim, hedef) < 2:
		return ""
	var secilen := NihaiSonSinifi.son(o, &"zafer")
	return gidisat_cumlesi_son_icin(secilen)


## OMR-48: İkinci oyunda oda gidişat paneli alınmamış sonları soluk gösterir; koşul metni yazmaz.
static func alinmamis_son_satirlari(iz: OyuncuIzi) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	if iz == null or not iz.ilk_oyun_bitti:
		return sonuc
	var sonlar: Dictionary = NihaiSonSinifi.AYAR.get("sonlar", {})
	var alinanlar := iz.alinan_sonlar_listesi()
	for son_id: String in OyuncuIziSinifi.BES_SON:
		var baslik := String(sonlar.get(son_id, {}).get("baslik", son_id))
		var alindi: bool = alinanlar.has(son_id)
		sonuc.append({
			"id": son_id,
			"baslik": baslik,
			"soluk": not alindi,
			"kosul_metni": "",
		})
	return sonuc


static func kur(e: Control, v: VBoxContainer, iz: OyuncuIzi = null) -> void:
	if e == null or v == null or e.oturum == null or e.oturum.perde < 2:
		return
	var kutu := VBoxContainer.new()
	kutu.name = "oda_gidisat"
	kutu.add_theme_constant_override("separation", 4)
	for satir in gosterge_satirlari(e.oturum):
		var l := Label.new()
		l.text = satir
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		kutu.add_child(l)
	var cumle := gidisat_cumlesi(e.oturum)
	if not cumle.is_empty():
		var c := Label.new()
		c.name = "oda_gidisat_son"
		c.text = cumle
		c.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		kutu.add_child(c)
	var etkin_iz := iz
	if etkin_iz == null and e.has_meta(&"oyuncu_izi"):
		etkin_iz = e.get_meta(&"oyuncu_izi") as OyuncuIzi
	for kayit in alinmamis_son_satirlari(etkin_iz):
		if bool(kayit.get("soluk", false)):
			var s := Label.new()
			s.name = "alinmamis_" + String(kayit.get("id", ""))
			s.text = String(kayit.get("baslik", ""))
			s.modulate = Color(1.0, 1.0, 1.0, 0.45)
			kutu.add_child(s)
	v.add_child(kutu)
