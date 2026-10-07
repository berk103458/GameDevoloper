## Debug seçiminde katalog kimliği kullanılır; ziyaret/karar normal kapı akışındadır.
class_name NpcCagirma
extends RefCounted

static func kimlikler(o: Oturum) -> Array[StringName]:
	var sonuc: Array[StringName] = []
	if o != null:
		for k in o.katalog.karakterler():
			sonuc.append(k.id)
	return sonuc

static func uygun(ana: Node) -> bool:
	if not KapiAtlamaAdaptoru.uygun(ana):
		return false
	var ekran: Node = ana.get("_ekran")
	return ekran.get("evre") in [&"sohbet", &"karar"] and ekran.get("_heybe_paneli") == null and not ekran.get_meta(&"admin_npc_yukleniyor", false)

static func cagir(ana: Node, id: StringName) -> Dictionary:
	if not uygun(ana):
		return {"ok": false, "neden": "Hazır kapı sorgusu gerekli; geçiş/heybe sırasında çağrı yapılamaz."}
	var o: Oturum = ana.get("oturum")
	if id not in kimlikler(o):
		return {"ok": false, "neden": "Karakter katalogda bulunamadı."}
	var ekran: Node = ana.get("_ekran")
	var aktif: Gelen = ekran.get("_gelen")
	if aktif != null and aktif.id == id:
		return {"ok": false, "neden": "Seçili karakter zaten kapıda."}
	var kuyruk: Array[Gelen] = ekran.get("_kuyruk")
	var gelen: Gelen
	for g in kuyruk:
		if g.id == id:
			gelen = g
			break
	var zaten := gelen != null
	if gelen == null:
		gelen = o._adli_gelen(id)
	ekran.set_meta(&"admin_npc_yukleniyor", true)
	var model: String = ekran.call("_model_adi", gelen)
	var kaynak := await VarlikYuklemePaneli.hazirla(ekran, GirisVarliklari.karakterler([model]))
	if not is_instance_valid(ekran):
		kaynak.bosalt()
		return {"ok": false, "neden": "Kapı sahnesi kapandı."}
	if not is_instance_valid(ana) or ana.get("_ekran") != ekran or ekran.get("_gelen") != aktif:
		ekran.set_meta(&"admin_npc_yukleniyor", false)
		await VarlikYuklemePaneli.bitir(ekran, kaynak)
		return {"ok": false, "neden": "Sorgu değişti; çağrı iptal edildi."}
	if zaten:
		kuyruk.erase(gelen)
	kuyruk.push_front(gelen)
	var adlar: Array[String] = []
	for g in kuyruk:
		adlar.append(ekran.call("_model_adi", g))
	# Aktif kapı modeli korunur; sıradaki model anında kuyruğun önünde görünür.
	ekran.get("sahne").call("kuyruk_doldur", adlar)
	ekran.call("_bilgi_yaz")
	await VarlikYuklemePaneli.bitir(ekran, kaynak)
	if is_instance_valid(ekran):
		ekran.set_meta(&"admin_npc_yukleniyor", false)
	return {"ok": true, "id": String(id), "tasindi": zaten}
