## OGR-25: bekleyen üst HUD panelleri sahne ağacının dışında tutulur.
extends RefCounted

const ACILIS = preload("res://src/sistemler/acilis_senaryosu.gd")
const AYAR: Dictionary = preload("res://data/ogretici/ilk_saat.json").data.hud_katmanlari
var _oturum: Oturum
var _ayarlar: Ayarlar
var _paneller: Array[Dictionary] = []

func kur(oturum: Oturum, ayarlar: Ayarlar) -> void:
	_oturum = oturum
	_ayarlar = ayarlar

func koy_hudu() -> bool:
	return _oturum != null

func acik(dosya: String, parca: String = "ana", zorunlu: bool = false) -> bool:
	if zorunlu or _oturum == null or not ACILIS.durum(_oturum).get("kuruldu", false): return true
	if _ayarlar != null and not _ayarlar.degerler.get(&"kademeli_hud", AyarlarEk.VARSAYILAN[&"kademeli_hud"]): return true
	if dosya == "muhafiz_odasi_baglantisi.gd":
		return (int(SancakTeftisi.oku(_oturum.sancak_teftisi).son_gece) >= 0
			or int(MuhafizTerazisi.durum(_oturum).yozlasma) > 0
			or not DivanHaksizligi.durum(_oturum.yonetim).is_empty())
	if dosya == "harita_baglantisi.gd":
		var ilk_haber := int(HaberciAgi.oku(_oturum.haberci_agi).ilk_haber_gunu)
		return (_oturum.gorulen_olaylar.has(&"kervan")
			or not TuccarKapiGecisi.oku(_oturum.yonetim.tuccar_girisi).is_empty()
			or (ilk_haber > 0 and ilk_haber <= _oturum.gun))
	return _oturum.gun >= int(AYAR.get(dosya, {}).get(parca, 0))

func izle(panel: Control, dosya: String, parca: String = "ana") -> void:
	var kimlik := dosya + ":" + parca
	panel.set_meta(&"hud_katmani", kimlik)
	_paneller.append({"panel": panel, "ebeveyn": panel.get_parent(), "sira": panel.get_index(), "dosya": dosya, "parca": parca, "kimlik": kimlik})

func guncelle(zorunlular: PackedStringArray = []) -> void:
	for d in _paneller:
		if d.panel.get_parent() != null and not acik(d.dosya, d.parca, d.kimlik in zorunlular):
			d.ebeveyn.remove_child(d.panel)
	for d in _paneller:
		if d.panel.get_parent() != null or not acik(d.dosya, d.parca, d.kimlik in zorunlular): continue
		var sira: int = d.sira
		for diger in _paneller:
			if diger.ebeveyn == d.ebeveyn and diger.sira < d.sira and diger.panel.get_parent() == null:
				sira -= 1
		d.ebeveyn.add_child(d.panel)
		d.ebeveyn.move_child(d.panel, sira)

static func gecici_kaldir(ebeveyn: Node, ad: String) -> void:
	var panel := ebeveyn.get_node_or_null(ad)
	if panel == null: return
	ebeveyn.remove_child(panel)
	panel.queue_free()

func temizle() -> void:
	for d in _paneller:
		if is_instance_valid(d.panel) and d.panel.get_parent() == null: d.panel.free()
	_paneller.clear()
