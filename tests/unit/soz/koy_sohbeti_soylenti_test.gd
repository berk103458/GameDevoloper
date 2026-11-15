# gdlint: disable=max-line-length
extends SceneTree

const ParleyKoyAdaptoru = preload("res://src/diyalog/parley_koy_adaptoru.gd")
const KoyDiyalogYoneticisi = preload("res://src/diyalog/koy_diyalog_yoneticisi.gd")
const KoyHavadisFact = preload("res://src/diyalog/facts/koy_havadis_fact.gd")

var _hatalar: Array[String] = []


func _dogrula(kosul: bool, mesaj: String) -> void:
	if not kosul:
		_hatalar.append(mesaj)


func _initialize() -> void:
	_kos()


func _kos() -> void:
	var onceki_dil := TranslationServer.get_locale()
	TranslationServer.set_locale("tr")

	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 11)
	var k1 := o.yonetim.kabul({"ad": "Mehmet", "sinif": &"ciftci"})
	var k3 := o.yonetim.kabul({"ad": "Ahmet", "sinif": &"ciftci"})
	var k2 := o.yonetim.kabul({"ad": "Tarik", "sinif": &"esnaf"})
	var k4 := o.yonetim.kabul({"ad": "Hasan", "sinif": &"esnaf"})

	# 1. Ağ yokken Parley bağlamı ağ kurmaz ve canlı söylenti boştur.
	var bos_baglam := ParleyKoyAdaptoru.baglam_olustur(k1, o.yonetim)
	_dogrula(not o.has_meta(SoylentiKoprusu.META) and not o.yonetim.has_meta(SoylentiKoprusu.META), "Sohbet bağlamı SoylentiAgi kurmamalı")
	_dogrula(String(bos_baglam.get("canli_soylenti", "")).is_empty(), "Ağ yokken canlı söylenti boş olmalı")
	_dogrula(not (bos_baglam.get("havadisler", []) as Array).has("soylenti"), "Ağ yokken havadisler içinde söylenti olmamalı")

	# 2. Canlı söylenti açılınca (dedikodu iki kez yazılmadan) Parley bağlamı ve sohbet okur.
	var ag := SoylentiKoprusu.ag(o)
	ag.soylenti_ekle("olay_rusvet_sohbet", "rusvet", str(k1.id), true, {"gece": o.gun})
	ag.gece_ilerlet(o.gun, 10, {str(k1.id): [str(k2.id), str(k3.id), str(k4.id)]})
	var dedikodu_sayisi_once: int = o.dedikodu.kayitlar().size()

	var b1 := ParleyKoyAdaptoru.baglam_olustur(k1, o.yonetim)
	var b2 := ParleyKoyAdaptoru.baglam_olustur(k2, o.yonetim)
	var b3 := ParleyKoyAdaptoru.baglam_olustur(k3, o.yonetim)
	var b4 := ParleyKoyAdaptoru.baglam_olustur(k4, o.yonetim)
	var s1 := String(b1.get("canli_soylenti", ""))
	var s2 := String(b2.get("canli_soylenti", ""))
	var s3 := String(b3.get("canli_soylenti", ""))
	var s4 := String(b4.get("canli_soylenti", ""))

	_dogrula(not s1.is_empty() and not s2.is_empty() and not s3.is_empty(), "Canlı söylenti sohbette boş olmamalı")
	_dogrula(s1 != s2, "İki köylü (çiftçi vs esnaf) aynı söylentiyi farklı söylemeli")
	_dogrula(s1 != s3, "Aynı sınıftan iki köylü de DNY-02 gereği farklı satır söylemeli")
	_dogrula((b1.get("havadisler", []) as Array).has("soylenti"), "Canlı söylenti varken havadisler soylenti içermeli")

	var fact := KoyHavadisFact.new()
	var ctx := ParleyContext.new()
	ctx.p_data = b1
	_dogrula(fact.evaluate(ctx, ["soylenti"]), "KoyHavadisFact soylenti koşulunu true okumalı")
	ctx.free()

	# 3. Gerçek Parley muhabbet akışında havadis seçeneği canlı söylentiyi iki köylüde farklı satırla basar.
	var satir_k1 := await _muhabbet_havadisi_al(k1, o.yonetim)
	var satir_k2 := await _muhabbet_havadisi_al(k2, o.yonetim)
	var satir_k4 := await _muhabbet_havadisi_al(k4, o.yonetim, "opt_karar")
	_dogrula(not satir_k1.is_empty() and not satir_k2.is_empty() and not satir_k4.is_empty(), "Muhabbette havadis/karar repliği gelmeli")
	_dogrula(satir_k1.contains(s1) and satir_k2.contains(s2) and satir_k4.contains(s4), "Muhabbet repliği köylünün kendi söylenti satırını kullanmalı")
	_dogrula(satir_k1 != satir_k2 and satir_k1 != satir_k4, "Sohbette iki köylünün söylediği canlı söylenti satırı farklı olmalı")
	_dogrula(o.dedikodu.kayitlar().size() == dedikodu_sayisi_once, "Sohbet ikinci dedikodu kaydı açmamalı")

	TranslationServer.set_locale(onceki_dil)

	if not _hatalar.is_empty():
		for h in _hatalar:
			push_error(h)
		quit(1)
		return

	print("TEST PASS: SOY-46 koy_sohbeti_soylenti_test")
	quit(0)


func _muhabbet_havadisi_al(k: Koylu, y: KoyYonetimi, hedef_id: String = "opt_havadis") -> String:
	var dy = KoyDiyalogYoneticisi.new()
	var sonuc := {"havadis_secenegi": null, "replik": ""}
	dy.replik_geldi.connect(func(_konusan: String, metin: String, secenekler: Array) -> void:
		if not secenekler.is_empty():
			for s in secenekler:
				if String(s.id).contains(hedef_id) or String(s.text).contains("havadis"):
					sonuc.havadis_secenegi = s
		else:
			sonuc.replik = metin
	)
	if not dy.muhabbet_baslat(k, y):
		return ""
	for _i in 10:
		await process_frame
		if sonuc.havadis_secenegi != null:
			break
	if sonuc.havadis_secenegi == null:
		dy.bitir()
		return ""
	dy.secenek_sec(sonuc.havadis_secenegi)
	for _i in 10:
		await process_frame
		if not String(sonuc.replik).is_empty():
			break
	dy.bitir()
	return String(sonuc.replik)
