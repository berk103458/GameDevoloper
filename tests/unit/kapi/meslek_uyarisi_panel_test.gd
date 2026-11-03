extends Node
const U = preload("res://src/kapi/meslek_uyarisi.gd")
class TestKapi extends KapiEkrani:
	func _ready() -> void: pass
	func _daralt(_dar: bool) -> void: pass
	func _sirayla_goster(_d: Array[Button]) -> void: pass
var hata := 0
func dene(v: bool,ad: String) -> void:
	if not v:
		hata+=1
		push_error(ad)
func _ready() -> void: call_deferred("_calistir")
func _calistir() -> void:
	GuvenliMetin.kur()
	var e := TestKapi.new(); add_child(e)
	e.ayarlar=Ayarlar.new()
	var kat := Katalog.new(); kat.yukle()
	e.oturum=Oturum.new(kat,2011)
	for alan in ["_secenekler","_eylemler"]:
		var v := VBoxContainer.new(); e.add_child(v); e.set(alan,v)
	for alan in ["_bolum","_bilgi"]:
		var l := Label.new(); e.add_child(l); e.set(alan,l)
	e._gelen=Gelen.new(); e._gelen.id=&"chr_028"; e._gelen.adli=true
	e._gelen.secenekler=PackedStringArray(["kabul","ret"])
	e._karar_goster()
	await get_tree().process_frame
	var labels := _uyarilar(e)
	dene(labels.size()==1 and labels[0].text.contains("Kumaşçı"),"Gerçek karar panelinde tek meslek uyarısı")
	var kabul := e._karar_anahtarlari.find("kabul")
	dene(kabul>=0 and not e._karar_dugmeleri[kabul].disabled,"Uyarı kabul düğmesini kapatmaz")
	var once := JSON.stringify(e.oturum.kaydet())
	e._karar_goster()
	await get_tree().process_frame
	dene(_uyarilar(e).size()==1,"Panel yenilenince satır çoğalmaz")
	dene(JSON.stringify(e.oturum.kaydet())==once,"Karar paneli kayda uyarı yazmaz")
	var b := KoyBinasi.new(); b.id=1; b.tur="bez_evi"; e.oturum.yonetim.binalar.append(b)
	e._karar_goster()
	await get_tree().process_frame
	dene(_uyarilar(e).is_empty(),"Yapı bitince paneldeki satır kalkar")
	e.queue_free()
	await get_tree().process_frame
	print("MESLEK UYARISI PANEL: GEÇTİ" if hata==0 else "MESLEK UYARISI PANEL: KALDI")
	await Ses.cik(hata)
func _uyarilar(e: KapiEkrani) -> Array[Node]:
	return e._secenekler.get_children().filter(func(n: Node) -> bool: return n.has_meta(U.ISARET) and not n.is_queued_for_deletion())
