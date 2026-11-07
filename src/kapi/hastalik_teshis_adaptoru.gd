## KRI-11: açık belirtiler → ziyaretin mevcut IpucuYoneticisi → KRI-02 karantinası.
## Sağlık teşhisi/enfeksiyon üretmez; gizli bayrak ve hikâye metni okunmaz.
extends RefCounted

const META := &"kapi_teshis_ipuclari"
const SONUC := &"kapi_teshis_sonuclandi"
const AYAR: Dictionary = preload("res://data/kapi_hastalik_teshisi.json").data

## Kaynak yalnız açık semptom bayraklarıdır; yaralı/hekim/CHR kimliği kanıt olmaz.
static func belirtiler(g: Gelen) -> Array[Dictionary]:
	var sonuc: Array[Dictionary] = []
	if g == null or DiplomatikHeyet.ilgilenir(g) or TuccarKapiGecisi.ilgilenir(g): return sonuc
	for bayrak in g.acik_bayraklar:
		if bayrak == "hasta" and String(g.id) in AYAR.bulasici_olmayan_hasta: continue
		if AYAR.belirtiler.has(bayrak): sonuc.append(AYAR.belirtiler[bayrak])
	return sonuc

static func _servis(g: Gelen) -> IpucuYoneticisi:
	var s := g.chr_sorgusu()
	if s != null: return s.get("_ipucu_servisi") as IpucuYoneticisi
	if not g.has_meta(META): g.set_meta(META, IpucuYoneticisi.new())
	return g.get_meta(META) as IpucuYoneticisi

## Keşfedilmiş sağlık ipuçları; diğer CHR kanıtları karantinayı tetiklemez.
static func kaydet(g: Gelen) -> Array[String]:
	var sonuc: Array[String] = []
	if g == null or belirtiler(g).is_empty(): return sonuc
	var s := _servis(g)
	for b in belirtiler(g):
		var id := String(b.ipucu)
		if s.var_mi(StringName(id)) and id not in sonuc: sonuc.append(id)
	return sonuc

## Debug snapshot optional alanı; yalnız hâlâ açık olan belirtiler geri kurulabilir.
static func yukle(g: Gelen, v: Variant) -> void:
	if g == null or not v is Array: return
	for b in belirtiler(g):
		if String(b.ipucu) in v: _servis(g).kaydet(StringName(b.ipucu))

## Portre veya heybe incelemesi aynı ziyaret servisinde tek Clue/sinyal üretir.
static func incele(g: Gelen, kaynak: String) -> String:
	if g == null or kaynak not in ["portre", "heybe"]: return ""
	var satirlar: Array[String] = []
	for b in belirtiler(g):
		if b.kaynak != kaynak: continue
		var ipucu := StringName(b.ipucu)
		if _servis(g).kaydet(ipucu):
			var sorgu := g.chr_sorgusu()
			if sorgu != null: sorgu.emit_signal("ipucu_bulundu", ipucu)
		if String(b.metin) not in satirlar: satirlar.append(String(b.metin))
	return " ".join(satirlar) if not satirlar.is_empty() else "Bu incelemede bulaşıcı hastalığı düşündüren açık belirti bulunmadı."

## İbre kesin teşhis vermez; gizli hasta ile sağlıklı ziyaretçinin metni aynıdır.
static func metin(g: Gelen) -> String:
	return "Teşhis ibresi: enfeksiyon şüphesi · kesin teşhis değil · kabulde karantina şartı" if not kaydet(g).is_empty() else "Teşhis ibresi: enfeksiyon şüphesi saptanmadı"

## TEK-04: yalnız aynı ibre satırını süz; yeni bulgu ve inceleme metni korunur.
## Kayıt ziyaret başında temizlenir; ayrı ziyaret kilidi/kayıt alanı tutulmaz.
static func kayit_metni(kayit: RichTextLabel, yazi: String) -> String:
	var bilinen := kayit.get_parsed_text().split("\n")
	var satirlar: Array[String] = []
	for satir in yazi.split("\n"):
		if satir.begins_with("Teşhis ibresi:"):
			if satir in bilinen: continue
			bilinen.append(satir)
		satirlar.append(satir)
	return "\n".join(satirlar)

## Karar öncesi atomik kilit: tüm kabul yolları/klavye/debug aynı kurala uyar.
static func neden(o: RefCounted, g: Gelen, karar: StringName) -> String:
	if g == null or String(karar) not in AYAR.kabul_kararlari or belirtiler(g).is_empty(): return ""
	if g.has_meta(SONUC): return "Bu ziyaretçinin karantina kabulü tamamlandı"
	if kaydet(g).is_empty(): return "Önce yüz veya heybedeki hastalık belirtilerini incele"
	var y: KoyYonetimi = o.get("yonetim")
	if y.son != &"": return "Oturum tamamlandı"
	if KarantinaYoneticisi.bos(y) <= 0: return "İşler Şifahane karantina kontenjanı yok"
	if y.kaynaklar.miktar("gida") < KarantinaYoneticisi.GIRIS_GIDA: return "Karantina için 1 erzak gerekli"
	return ""

## Aynı kabulde mevcut Şifahane izolasyonu; enfeksiyon, RNG ve atama değiştirilmez.
static func kabul(o: RefCounted, g: Gelen, k: Koylu, sonuc: Dictionary) -> void:
	if kaydet(g).is_empty(): return
	var y: KoyYonetimi = o.get("yonetim")
	if KarantinaYoneticisi.al(y, k.id):
		g.set_meta(SONUC, true)
		sonuc["karantina"] = true

## Mevcut karar satırının açıklaması/engeli; önceki CHR panik kilidi korunur.
static func kilit(b: Button, o: RefCounted, g: Gelen, karar: StringName) -> void:
	if String(karar) not in AYAR.kabul_kararlari or belirtiler(g).is_empty(): return
	var sebep := neden(o, g, karar)
	if not b.disabled:
		b.disabled = not sebep.is_empty()
		b.set("alt_yazi", sebep if not sebep.is_empty() else "Kabulde 2 gün karantina · 1 erzak, kişisel moral −2")
		b.tooltip_text = String(b.get("alt_yazi"))

## Sohbet/karar eylemlerine tek inceleme satırı; statik ekran/autoload tipi yok.
static func eylem(e: Node, g: Gelen, kap: Container) -> void:
	var eski := kap.get_node_or_null("HastalikIncele")
	if eski != null:
		if not eski.is_queued_for_deletion(): return
		kap.remove_child(eski)
	var b := Button.new()
	b.name = "HastalikIncele"
	b.text = "Yüz ve hastalık belirtilerini incele"
	b.custom_minimum_size.y = 58
	kap.add_child(b)
	b.pressed.connect(func() -> void:
		if e.get("_gelen") != g: return
		var yazi := incele(g, "portre")
		if g.heybe == null: yazi += "\n" + incele(g, "heybe")
		e.call("_yaz", yazi + "\n" + metin(g))
		e.call("_karar_goster" if e.get("evre") == &"karar" else "_sohbet_goster")
	)

## Mevcut heybe incelemesine küçük yazılı belirti bağlantısı; tek değişim noktası.
static func heybe_bagla(panel: Control, e: Node, g: Gelen) -> void:
	var b := Button.new()
	b.name = "HastalikHeybeIncele"
	b.text = "Öksürük bezini / hastalık izlerini incele"
	b.position = Vector2(48, 850)
	b.size = Vector2(600, 58)
	panel.add_child(b)
	var etiket := Label.new()
	etiket.name = "HastalikIbre"
	etiket.position = Vector2(48, 914)
	etiket.size = Vector2(600, 64)
	etiket.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	etiket.add_theme_font_size_override("font_size", Kabuk.KUCUK)
	etiket.text = metin(g)
	panel.add_child(etiket)
	b.pressed.connect(func() -> void:
		if e.get("_gelen") != g: return
		var yazi := incele(g, "heybe")
		etiket.text = yazi + "\n" + metin(g)
		e.call("_yaz", etiket.text)
	)

## CHR'nin portre/yük düğmelerine bağlanır; var olan ipucu ve metin akışı korunur.
static func chr_bagla(panel: Control, e: Node, g: Gelen) -> void:
	var portre := panel.find_child("GorselIz", true, false) as BaseButton
	if portre != null:
		portre.pressed.connect(func() -> void: _chr_incele(panel, e, g, "portre"))
	var kutu := panel.get_child(0)
	(kutu.get_child(2) as Button).pressed.connect(func() -> void: _chr_incele(panel, e, g, "heybe"))
	var etiket := Label.new()
	etiket.name = "HastalikIbre"
	etiket.text = metin(g)
	etiket.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	etiket.add_theme_font_size_override("font_size", Kabuk.KUCUK)
	kutu.add_child(etiket)

static func _chr_incele(panel: Control, e: Node, g: Gelen, kaynak: String) -> void:
	if e.get("_gelen") != g: return
	e.call("_yaz", incele(g, kaynak) + "\n" + metin(g))
	(panel.find_child("HastalikIbre", true, false) as Label).text = metin(g)
	if e.get("evre") == &"karar": e.call("_karar_goster")

## Gerçek kabul sonucunu aynı konuşma kaydında görünür kılar.
static func sonuc_yaz(e: Node, sonuc: Dictionary) -> void:
	if sonuc.get("karantina", false): e.call("_yaz", "Enfeksiyon şüphesiyle Şifahanede 2 gün karantina başladı; temas ve çalışma engelli.")


## KOP-03: DYL-02 yüz ve eller bölgesi KRI-11 belirtilerini (ateş, kanlı öksürük, irin) aynı kayda yazar.
## Ayrı teşhis düğmesi yoktur (0). Belirti satırı yokken veya ışık kapalıysa enfeksiyon ipucu yazılmaz.
static func teshis_dugmesi_sayisi() -> int:
	return 0

static func bakis_belirtisi_isle(g: Variant, bolge: String, bolge_verisi: Dictionary, satir: String, isik_var: bool = true) -> String:
	if not isik_var:
		return ""
	if bolge not in ["yuz", "eller"]:
		return ""
	var temiz_satir := satir.strip_edges()
	if temiz_satir.is_empty():
		return ""
	var ipucu := _belirti_ipucu_coz(g, bolge_verisi, temiz_satir)
	if ipucu.is_empty():
		return ""
	if g is Gelen:
		var gelen_kisi := g as Gelen
		var bayrak := _ipucu_bayragi(ipucu)
		if not bayrak.is_empty() and bayrak not in gelen_kisi.acik_bayraklar:
			var yeni_bayraklar := PackedStringArray(gelen_kisi.acik_bayraklar)
			yeni_bayraklar.append(bayrak)
			gelen_kisi.acik_bayraklar = yeni_bayraklar
		if _servis(gelen_kisi).kaydet(StringName(ipucu)):
			var sorgu := gelen_kisi.chr_sorgusu()
			if sorgu != null:
				sorgu.emit_signal("ipucu_bulundu", StringName(ipucu))
	return ipucu

static func _belirti_ipucu_coz(g: Variant, bolge_verisi: Dictionary, satir: String) -> String:
	var belirti_key := String(bolge_verisi.get("belirti", "")).strip_edges()
	if not belirti_key.is_empty() and AYAR.belirtiler.has(belirti_key):
		return String(AYAR.belirtiler[belirti_key].ipucu)
	var acik_ipucu := String(bolge_verisi.get("ipucu", "")).strip_edges()
	if acik_ipucu in ["Clue_Enfeksiyon_Ates", "Clue_Enfeksiyon_KanliOksuruk", "Clue_Enfeksiyon_Irin"]:
		if _satirda_belirti_var_mi(satir):
			return acik_ipucu
		return ""
	var kucuk := satir.to_lower()
	if (kucuk.find("kanlı öksürük") >= 0 or kucuk.find("kanli oksuruk") >= 0 or (kucuk.find("öksür") >= 0 and kucuk.find("kan") >= 0)):
		return "Clue_Enfeksiyon_KanliOksuruk"
	if kucuk.find("irin") >= 0:
		return "Clue_Enfeksiyon_Irin"
	if kucuk.find("ateş") >= 0 or kucuk.find("ates") >= 0 or kucuk.find("humma") >= 0:
		return "Clue_Enfeksiyon_Ates"
	if g is Gelen:
		var b_list := belirtiler(g as Gelen)
		if not b_list.is_empty() and _satirda_belirti_var_mi(satir):
			return String(b_list[0].ipucu)
	return ""

static func _satirda_belirti_var_mi(satir: String) -> bool:
	var kucuk := satir.to_lower()
	return kucuk.find("ateş") >= 0 or kucuk.find("ates") >= 0 or kucuk.find("irin") >= 0 or kucuk.find("öksür") >= 0 or kucuk.find("oksur") >= 0 or kucuk.find("humma") >= 0 or kucuk.find("veba") >= 0

static func _ipucu_bayragi(ipucu: String) -> String:
	match ipucu:
		"Clue_Enfeksiyon_Ates":
			return "belirti_ates"
		"Clue_Enfeksiyon_KanliOksuruk":
			return "belirti_kanli_oksuruk"
		"Clue_Enfeksiyon_Irin":
			return "belirti_irin"
		_:
			return ""

## KOP-03 Uç durum: Karakter kaçarsa (ZAR-03) ipucu kişi hafızasında kalır, karantina açılmaz.
static func kacista_hafizaya_yaz(g: Gelen, hafiza: Dictionary) -> Dictionary:
	var bulunanlar := kaydet(g) if g != null else []
	if not bulunanlar.is_empty():
		hafiza["enfeksiyon_ipuclari"] = bulunanlar.duplicate()
	hafiza["karantina_acildi"] = false
	return hafiza
