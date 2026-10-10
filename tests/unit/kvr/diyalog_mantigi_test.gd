## SYS-17: diyalog_01_20 mantığı — diyalog_08'de Ret; kabul yanıtı yerleşik köylü gibi konuşur (sabah gitmez).
extends SceneTree
var hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)

func _initialize() -> void:
	var d: Array = JSON.parse_string(FileAccess.get_file_as_string("res://data/diyalog/diyalog_01_20.json"))
	dene(d.size() == 20, "20 diyalog")
	var gitme := RegEx.create_from_string("(?i)kervanla (birlikte )?çık|kervan toplanırsa|çıkar giderim|yoluma koyulurum|ilk kervanla")
	for x in d:
		dene(x.secenekler.size() == x.esik.size(), "Seçenek/eşik uyumu: " + x.id)
		for s in x.secenekler: dene(x.yanitlar.has(s), "Her seçeneğin yanıtı var: %s %s" % [x.id, s])
		dene(gitme.search(String(x.yanitlar.get("kabul", ""))) == null, "Kabul yanıtı köyden gitmeyi söylemez: " + x.id)
	var d8: Dictionary = d[7]
	dene(d8.id == "diyalog_08" and "ret" in d8.secenekler and int(d8.esik[d8.secenekler.find("ret")]) == 0, "diyalog_08 baştan Ret içerir")
	# Gerçek Oturum: 8. hazır diyalog kapıda Ret seçeneğiyle gelir (1. perde).
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1717)
	var g: Gelen
	for i in 8: g = o._figur_gelen()
	dene(g != null and "ret" in g.secenekler, "Kapıda diyalog_08 Ret seçeneği")
	var sonuc := o.karar_ver(g, &"ret")
	dene(not sonuc.get("engellendi", false), "Ret kararı uygulanır")
	print("DIYALOG MANTIGI: GEÇTİ" if hata == 0 else "DIYALOG MANTIGI: KALDI")
	quit(hata)
