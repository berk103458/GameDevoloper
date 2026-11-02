extends SceneTree
const ON = preload("res://src/sistemler/olay_on_kosulu.gd")
var denetci = ON.new()
var hata := 0
func dene(v: bool, ad: String) -> void:
	if not v:
		hata += 1
		push_error(ad)
func _initialize() -> void:
	if not denetci.has_method("hane_sayisi"):
		dene(false, "Yaşayan hane katmanı henüz yok")
		quit(hata)
		return
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 1519)
	for i in 3:
		var k := o.yonetim.kabul({"ad":"Kişi %d" % i})
		k.hane_id = 1
	o._koy_esitle()
	o.ayarlar.olay_olasiligi = 1.0
	for gun in 30:
		o.gun = gun
		var secilen := o.olay_sec()
		dene(secilen == null or secilen.id not in [&"bebek", &"dugun"], "Üç kişilik köyde çocuk/düğün yok")
	dene(int(denetci.call("hane_sayisi", o, false)) == 1, "Kişi sayısı hane sayısı değildir")
	dene(not o._kosul_tutar({"yetiskin_hane_min":2}), "Tek yetişkin hane düğün koşulunu geçmez")
	for i in range(2, 14):
		var k := o.yonetim.kabul({"ad":"Hane %d" % i})
		k.hane_id = i
	o._koy_esitle()
	dene(int(denetci.call("hane_sayisi", o, false)) == 13 and String(denetci.call("katman", o)) == "buyuk", "13 yaşayan hane üst katmandır")
	var sinir := Oturum.new(kat, 19)
	for i in 13:
		var k := sinir.yonetim.kabul({"ad":"Sınır %d" % i})
		k.hane_id = i + 1
		if i + 1 in [5, 6, 12, 13]:
			var beklenen := "kucuk" if i + 1 == 5 else ("buyuk" if i + 1 == 13 else "orta")
			dene(String(denetci.call("katman", sinir)) == beklenen, "5/6/12/13 sınırları")
	dene(not sinir._kosul_tutar({"cocuk_var":true}), "Üst katman çocuk koşulunu aşamaz")
	sinir.yonetim.koylular[0].yas_grubu = &"cocuk"
	dene(sinir._kosul_tutar({"cocuk_var":true}) and sinir._kosul_tutar({"yetiskin_hane_min":2}), "Canlı çocuk ve iki ayrı yetişkin hanesi okunur")
	sinir.yonetim.koylular[0].saglik = 0
	dene(not sinir._kosul_tutar({"cocuk_var":true}), "Ölü çocuk koşulu sağlamaz")
	var tum := {}
	for kart in kat.olaylar(): tum[String(kart.id)] = true
	var havuz: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/olaylar/nufus_katmanlari.json"))
	dene(havuz.listeler.buyuk.size() == tum.size(), "Üst liste tüm dosya havuzunu kapsar")
	for id in havuz.listeler.buyuk: dene(tum.has(id), "Katman listesinde hayali olay yok")
	var goruldu := false
	for gun in range(30, 60):
		o.gun = gun
		var secilen := o.olay_sec()
		if secilen != null:
			goruldu = true
			dene(bool(denetci.call("havuzda", o, secilen.id)), "Mevcut seçici üst havuzdan seçer")
	dene(goruldu, "Üst katmanda en az bir gerçek seçim")
	for i in range(1, o.yonetim.koylular.size()): o.yonetim.koylular[i].saglik = 0
	dene(String(denetci.call("katman", o)) == "kucuk", "Ölü haneler sayılmaz; yeni seçim alt katmana döner")
	dene(not ON.dogrula({"yetiskin_hane_min": -1}).is_empty(), "Bozuk yetişkin hane eşiği reddedilir")
	print("NÜFUS KATMANI: GEÇTİ" if hata == 0 else "NÜFUS KATMANI: KALDI")
	quit(hata)
