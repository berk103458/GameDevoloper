## Bir oyun oturumu: günlük döngü (gündüz kapı → akşam köy → gece hesaplaşma), kuyruk, karar ve kayıt.
## Köyün kendisi `KoyYonetimi`'dir (design/gdd/koy-yonetimi.md); oturum kapı, olaylar ve karakter kadrosunu ona bağlar.
## Eski dört bar kalktı (kullanıcı kararı, 6 Ekim 2026): içerikteki bar etkileri `_bar_uygula` köprüsüyle yeni
## göstergelere çevrilir (Halk → moral, Soylular → adalet, Tüccarlar → akçe, Ordu → asayiş).
class_name Oturum
extends RefCounted

const KAYIT_SURUMU := 3
## Bar köprüsü: eski bir bar puanının yeni göstergedeki karşılığı.
const KOPRU_MORAL := 5
const KOPRU_ADALET := 5
const KOPRU_ASAYIS := 5

var katalog: Katalog
var ayarlar: OyunAyarlari
var koy: KoyNufusu
var kadro: KarakterKadrosu
## Köy yönetimi: ambar, köylüler, yapılar, ekonomi, gece çözümü, sonlar.
var yonetim: KoyYonetimi
var tohum: int = 0
var muhafiz_tecrubesi: int = 0
## HAR-02 optional tek gece uyarı defteri; kalan süre gerçek günden türetilir.
var mogol_oncusu: Dictionary = {}
## HAR-04 optional ferman/seçim makbuzu; tek OlayVerisi akışı.
var sancak_asker_talebi: Dictionary = {}
## HAR-05 optional yol görevi/ek ziyaret makbuzu; nüfus eski kuyruğa bağlıdır.
var goc_yolu_guvenligi: Dictionary = {}
var oba_ittifaki: Dictionary = {}
var haberci_agi: Dictionary = {}
var muhafiz_akce: int = 0
var muhafiz_esyalari: Array[Dictionary] = []
## EKO-14 optional transfer özeti; iki mevcut kasanın bakiyesi ayrı kalır.
var kasa_transferleri: Dictionary = {"son_zimmet": -1, "kurtarma_toplam": 0, "zimmet_toplam": 0}
## ODA-05 optional tek seçim/gece makbuzu; eski kayıtta boş yetenekler.
var muhafiz_yetenekleri: Dictionary = {"alinan": [], "son_harac_gece": -1, "harac_toplam": 0}
## ODA-07 optional tek teftiş sonucu; mevcut kasa/skor kopyalanıp işletilmez.
var sancak_teftisi: Dictionary = {}
## ODA-08 optional kişisel oda geliştirmeleri/yorgunluk; köy statı değildir.
var oda_gelisimi: Dictionary = {}
## ODA-09 optional kişisel vicdan/gece makbuzu; kanıt veya köy statı değildir.
var muhafiz_vicdani: Dictionary = {}
var yeni_binalar: Array[Dictionary] = []
## Olayların bıraktığı işaretler (kararların uzun vadeli izleri).
var bayraklar: Dictionary = {}
var gorulen_olaylar: Dictionary = {}
## Bir sonraki günün gelen sayısına ek (olaylardan).
var sonraki_gelen_ek: int = 0
var _rng: RandomNumberGenerator
var _rng_donus: RandomNumberGenerator
var _rng_ad: RandomNumberGenerator
## Heybe içeriği için ayrı akış (yalan ve eşyalar diğer çekilişleri kaydırmasın).
var _rng_heybe: RandomNumberGenerator
var _gemini: Array = []
var _gemini_sira: int = 0

## Tamamlanan gün sayısı (skor).
var gun: int:
	get:
		return yonetim.gun
	set(v):
		yonetim.gun = v
## 1 = karakol / iskân, 2 = Ağalık (Tekfur diplomasisi).
var perde: int:
	get:
		return 2 if yonetim.agalik else 1
## Kamu bakiyesi EKO-10 kapsamında negatif borç/açık taşıyabilir; kişisel kese ayrıdır.
var koy_akce: int:
	get:
		return yonetim.akce
	set(v):
		yonetim.akce = v
## Eski UI/köy API'si kamu kasasının takma adıdır.
var akce: int:
	get:
		return koy_akce
	set(v):
		koy_akce = v
## Ambardaki gıda (eski "ambar" alanı).
var ambar: int:
	get:
		return yonetim.kaynaklar.miktar("gida")
	set(v):
		yonetim.kaynaklar.stok["gida"] = maxi(0, v)
## Eski yapı seviyeleri (köy sahnesi görünümü için; sur köy yönetiminden).
var yapilar: Dictionary:
	get:
		return {&"pazar": _eski_yapi_seviyesi("pazar"), &"kervansaray": _eski_yapi_seviyesi("kervansaray"),
			&"sur": yonetim.sur_seviye, &"konak": _eski_yapi_seviyesi("konak")}


## Yeni oturum. `tohum` 0 ise rastgele seçilir.
func _init(katalog_: Katalog, tohum_: int = 0) -> void:
	katalog = katalog_
	ayarlar = katalog.ayarlar
	tohum = tohum_ if tohum_ != 0 else int(Time.get_unix_time_from_system()) ^ randi()
	_rng = RandomNumberGenerator.new()
	_rng.seed = tohum
	_rng_donus = RandomNumberGenerator.new()
	_rng_donus.seed = tohum + 1
	_rng_ad = RandomNumberGenerator.new()
	_rng_ad.seed = tohum + 2
	_rng_heybe = RandomNumberGenerator.new()
	_rng_heybe.seed = tohum + 3
	yonetim = KoyYonetimi.new(katalog.koy_ayarlari, katalog.binalar, tohum + 4)
	koy = KoyNufusu.new()
	kadro = KarakterKadrosu.new(katalog, _rng_donus, _rng_ad)



## Gösterilen gece numarası (1'den).
func gosterilen_gece() -> int:
	return gun + 1



## Bu gecenin varış listesi.
func gece_kuyrugu() -> Array[Gelen]:
	koy.bu_gece_girenler = []
	var sayi := ayarlar.gece_basina_gelen if perde == 1 else ayarlar.perde2_gece_basina_gelen
	sayi = maxi(1, sayi + sonraki_gelen_ek)
	sonraki_gelen_ek = 0
	var uygun := preload("res://src/sistemler/tehdit_takvimi.gd").adaylar(gun, kadro.uygunlar(gun))
	var sonuc: Array[Gelen] = []
	for i in sayi:
		if not uygun.is_empty() and _rng.randf() < ayarlar.adli_olasiligi:
			var id: StringName = uygun.pop_at(GuvenlikKafileDengesi.adli_indeks(self, uygun))
			kadro.iste(id, gun)
			sonuc.append(_adli_gelen(id))
		else:
			sonuc.append(_figur_gelen())
	GocYoluGuvenligi.ziyaret(self, sonuc)
	for g in sonuc:
		g.heybe = heybe_uret(g.sinif)
		if g.secenekler.has("kabul") and not g.zengin(ayarlar.zengin_esigi) and not g.secenekler.has("harc"):
			g.secenekler.insert(g.secenekler.find("kabul") + 1, "harc")
			g.etkiler[&"harc"] = g.etkiler.get(&"kabul", PackedInt32Array())
	TuccarKapiGecisi.ekle(self, sonuc)
	DiplomatikHeyet.ekle(self, sonuc)
	return sonuc



## Bir gelenin heybesi: söylediği akçe, sınıfına göre 1–2 eşya; yalancının astarında akçe ve
## bazen değerli bir eşya (design/gdd/heybe-ve-rusvet.md, F1–F3).
func heybe_uret(sinif: StringName) -> Heybe:
	var h := Heybe.new()
	var a := ayarlar
	var beyan := _rng_heybe.randi_range(a.beyan_akce_min, a.beyan_akce_max)
	h.ekle("akce", "akce", 1, beyan, false)
	var adaylar: Array[int] = []
	var degerliler: Array[int] = []
	for i in a.esya_idleri.size():
		if a.esya_idleri[i] == "akce":
			continue
		if a.esya_gizli[i] == 1:
			degerliler.append(i)
			continue
		var kim := a.esya_siniflari[i]
		if kim == "*" or String(sinif) in kim.split(","):
			adaylar.append(i)
	for n in _rng_heybe.randi_range(1, 2):
		if adaylar.is_empty():
			break
		var i: int = adaylar.pop_at(_rng_heybe.randi_range(0, adaylar.size() - 1))
		h.ekle(a.esya_idleri[i], a.esya_turleri[i], a.esya_degerleri[i], 1, false)
	h.teklif = maxi(1, ceili(beyan * a.teklif_orani))
	if _rng_heybe.randf() < a.yalan_olasiligi:
		h.ekle("akce", "akce", 1, _rng_heybe.randi_range(a.gizli_akce_min, a.gizli_akce_max), true)
		if not degerliler.is_empty() and _rng_heybe.randf() < a.gizli_esya_olasiligi:
			var i: int = degerliler[_rng_heybe.randi_range(0, degerliler.size() - 1)]
			h.ekle(a.esya_idleri[i], a.esya_turleri[i], a.esya_degerleri[i], 1, true)
	return h



## Sohbet açıldı (adlı karakterde ziyaret sayılır).
func ziyaret_basladi(gelen: Gelen) -> void:
	if gelen.adli:
		kadro.ziyaret_basladi(gelen.id, gun)


## Karar uygulanır (design/gdd/koy-yonetimi.md, 2–3). Döner: {kaldi, kirilan (-1), rusvet_harcandi (-1),
## alinan, alinan_akce, alinan_ambar, gasp, durust_arandi, harc, koylu_id}.
## Kararlar: `kabul`, `harc` (yoksuldan zorla geçiş akçesi), `rusvet` (teklifini alıp içeri), `kisla` (asker, muhafız),
## `ret`, `elkoy` (astardan çıkanlara el konur, geri çevrilir; yalnız yalan yakalanınca).
func karar_ver(gelen: Gelen, karar: StringName, _is_yeri: StringName = &"") -> Dictionary:
	if DiplomatikHeyet.ilgilenir(gelen): return DiplomatikHeyet.karar(self, gelen, karar)
	if TuccarKapiGecisi.ilgilenir(gelen): return TuccarKapiGecisi.karar(self, gelen, karar)
	var sorgu := gelen.chr_sorgusu()
	if sorgu != null and not sorgu.karar_acik(karar):
		return {"engellendi": true, "kaldi": false, "kirilan": -1}
	if not preload("res://src/kapi/hastalik_teshis_adaptoru.gd").neden(self, gelen, karar).is_empty(): return {"engellendi": true, "kaldi": false, "kirilan": -1}
	if sorgu != null and sorgu.bayraklar["Flag_Sir_Tamamen_Cozuldu"]:
		for bayrak in gelen.gizli_bayraklar:
			if not bayrak in gelen.acik_bayraklar:
				gelen.acik_bayraklar.append(bayrak)
	var h := gelen.heybe
	var ek := {"kirilan": -1, "rusvet_harcandi": -1, "alinan": [], "alinan_akce": 0, "alinan_ambar": 0, "gasp": false,
		"durust_arandi": false, "harc": karar == &"harc", "koylu_id": -1}
	var bar_etkisi: PackedInt32Array = gelen.etkiler.get(&"ret" if karar == &"elkoy" else karar, PackedInt32Array()).duplicate()
	# Eski rüşvet satırındaki Tüccarlar katkısı kamuya para üretemez.
	if karar == &"rusvet" and bar_etkisi.size() > 2:
		bar_etkisi[2] = 0
	_bar_uygula(bar_etkisi)
	var rusvet_akce := 0
	if h != null:
		if karar == &"rusvet" and not h.alinan_var():
			h.teklifi_sec()
		elif karar == &"elkoy":
			h.saklananlari_sec()
		if karar == &"rusvet" or karar == &"elkoy":
			var d := h.alinan_dagilim()
			rusvet_akce = d["akce"]
			if karar == &"elkoy":
				ambar += d["ambar"]
			ek["alinan_akce"] = d["akce"]
			ek["alinan_ambar"] = d["ambar"]
			for e in h.esyalar:
				if int(e["alinan"]) > 0:
					ek["alinan"].append({"id": e["id"], "adet": e["alinan"]})
			if h.gasp() > 0:
				yonetim.adalet = maxi(0, yonetim.adalet - ayarlar.gasp_halk_cezasi * KOPRU_ADALET)
				ek["gasp"] = true
		if h.astar_yoklandi and not h.yalan_var():
			_herkese_moral(-ayarlar.durust_arama_cezasi * KOPRU_MORAL)
			ek["durust_arandi"] = true
	elif karar == &"rusvet":
		rusvet_akce = ayarlar.rusvet_akce
	if karar == &"rusvet":
		bayraklar[&"rusvet_sayisi"] = int(bayraklar.get(&"rusvet_sayisi", 0)) + 1
		var kisisel := preload("res://src/sistemler/cift_kasa_dagitimi.gd").kisisel_rusvet(gelen, ayarlar.rusvet_akce)
		kisisel = MuhafizYetenekleri.rusvet(self, kisisel)
		muhafiz_akce += int(kisisel["akce"])
		muhafiz_esyalari.append_array(kisisel["esyalar"])
		ek["muhafiz_akce"] = kisisel["akce"]
		ek["muhafiz_esyalari"] = kisisel["esyalar"]
		if sorgu != null:
			ek["alinan_akce"] = kisisel["akce"]
			ek["alinan_ambar"] = 0
			ek["alinan"] = []
	var kaldi := karar != &"ret" and karar != &"elkoy"
	if kaldi:
		var sinif: StringName = &"asker" if karar == &"kisla" else gelen.sinif
		var k := yonetim.kabul({"ad": tr_gelen(gelen), "adli_id": gelen.id if gelen.adli else &"", "sinif": sinif,
			"portre": "soldier_01" if karar == &"kisla" and not gelen.adli else gelen.portre, "stat": gelen.stat,
			"bayraklar": gelen.acik_bayraklar + _uzmanlik_bayragi(gelen), "gizli": _gizliler(gelen)},
			karar == &"harc", rusvet_akce if (karar == &"rusvet" and gelen.kusurlu()) else 0,
			gelen.zengin(ayarlar.zengin_esigi), false)
		if karar == &"kisla":
			yonetim.muhafiz_ata(k.id)
		ek["koylu_id"] = k.id
		KuyuZehirleme.kabul(yonetim, k, gelen, karar)
		AmbarKundaklamasi.kabul(yonetim, k, gelen, karar)
		DivanKanit.devral(k, gelen)
		preload("res://src/kapi/hastalik_teshis_adaptoru.gd").kabul(self, gelen, k, ek)
	else:
		akce += rusvet_akce
		yonetim.ret(tr_gelen(gelen), not gelen.kusurlu(), _usta_uzmanlik(gelen))
	_koy_esitle()
	if gelen.adli:
		kadro.sonuc(gelen.id, kaldi, &"kabul" if karar == &"harc" else karar, gun)
	ek["kaldi"] = kaldi
	muhafiz_tecrubesi += 1
	MuhafizOdaGelisimi.karar(self)
	MuhafizVicdani.karar(self, gelen, karar)
	return ek


## Gece hesaplaşması (Faz 3). Döner: {olaylar: [{anahtar, deger}], kirilan (-1), rusvet_harcandi (-1),
## son: StringName ("" | halk_kirildi | isyan | tekfur | zafer), perde_degisti (Ağalık bu gece), olay, rapor}.
## bilanco: kamu/kişisel açılış-kapanış, gerçek vergi/maaş ve tüm stokların mutabakatı (EKO-15).
func gece_sonu() -> Dictionary:
	var bilanco_once := GeceBilancosu.fotograf(self)
	var agalik_once := yonetim.agalik
	MuhafizOdaGelisimi.gece(self)
	var harac := MuhafizYetenekleri.harac(self)
	MuhafizAdaletYetenekleri.bagla(self)
	yonetim.perde2_hedef = ayarlar.perde2_hedef_gece
	var r := yonetim.gece()
	MuhafizYetenekleri.rapora_ekle(r, harac)
	MuhafizVicdani.gece(self, r)
	SancakTeftisi.gece(self, r)
	MogolOncusu.gece(self, r)
	SancakAskerTalebi.gece(self, r)
	HaberciAgi.gece(self, r)
	preload("res://src/sistemler/atil_bayraklar.gd").gece(self, r)
	KoyYonetimi.PERDE_GECISI.denetle(yonetim, r, ayarlar.perde2_hedef_gece)
	_koy_esitle()
	kadro.gece_bitti()
	var sonuc := {"olaylar": r["olaylar"], "kirilan": -1, "rusvet_harcandi": -1, "son": StringName(r["son"]),
		"perde_degisti": not agalik_once and yonetim.agalik, "olay": null, "rapor": r}
	if r["son"] == "" and not sonuc["perde_degisti"]:
		sonuc["olay"] = olay_sec()
	sonuc["bilanco"] = GeceBilancosu.olustur(self, bilanco_once, r)
	return sonuc


## Eski bar etkisini yeni göstergelere çevirir: [Halk, Soylular, Tüccarlar, Ordu] → moral, adalet, akçe, asayiş.
func _bar_uygula(etki: PackedInt32Array) -> void:
	if etki.size() > 0 and etki[0] != 0:
		_herkese_moral(etki[0] * KOPRU_MORAL)
	if etki.size() > 1 and etki[1] != 0:
		yonetim.adalet = clampi(yonetim.adalet + etki[1] * KOPRU_ADALET, 0, 100)
	if etki.size() > 2 and etki[2] != 0:
		akce += etki[2]
	if etki.size() > 3 and etki[3] != 0:
		yonetim.asayis_riski = clampi(yonetim.asayis_riski - etki[3] * KOPRU_ASAYIS, 0, 100)


## Eski bar koşulları için 0–10 gösterge: 0 huzur, 1 adalet, 2 akçe, 3 güvenlik (100 − asayiş riski).
func gosterge(i: int) -> int:
	match i:
		0:
			return yonetim.huzur() / 10
		1:
			return yonetim.adalet / 10
		2:
			return clampi(akce / 5, 0, 10)
		3:
			return KervanKorumasi.guvenlik(yonetim) / 10
	return 0


func _herkese_moral(m: int) -> void:
	for k in yonetim.koylular:
		k.moral = clampi(k.moral + m, 0, 100)


## Köy nüfusu (sınıf sayıları ve adlılar) köy yönetiminden yeniden kurulur.
func _koy_esitle() -> void:
	for s in koy.sayilar:
		koy.sayilar[s] = 0
	koy.adlilar.clear()
	for k in yonetim.koylular:
		koy.sayilar[k.sinif] = int(koy.sayilar.get(k.sinif, 0)) + 1
		if k.adli_id != &"":
			koy.adlilar.append(k.adli_id)
	koy.degisti.emit()


func _sinif_cikar(sinif: StringName) -> void:
	for i in range(yonetim.koylular.size() - 1, -1, -1):
		if yonetim.koylular[i].sinif == sinif:
			yonetim.koylular.remove_at(i)
			return


func _yapi_sayisi(tur: String) -> int:
	var n := 0
	for b in yonetim.binalar:
		if b.tur == tur and b.hazir():
			n += 1
	return n


## Olay koşullarındaki eski yapılar: pazar ≈ atölye, kervansaray ≈ ambar, konak ≈ Ağalık.
func _eski_yapi_seviyesi(ad: String) -> int:
	match ad:
		"pazar":
			return mini(_yapi_sayisi("atolye"), 3)
		"kervansaray":
			return mini(_yapi_sayisi("ambar"), 3)
		"konak":
			return 1 if yonetim.agalik else 0
		"sur":
			return yonetim.sur_seviye
	return 0


## Usta gelenin uzmanlık bayrağı (kapıda görülen el, alet: stat 7 ve üstü). Karakter sayfası ustalığı gizli
## bayrak olarak veriyorsa sınıftan türetilmez: o ustalık ancak sorguda açılırsa köyde işe yarar.
func _uzmanlik_bayragi(g: Gelen) -> PackedStringArray:
	for b in g.gizli_bayraklar + g.acik_bayraklar:
		if b.begins_with("usta_"):
			return PackedStringArray()
	var u := _usta_uzmanlik(g)
	return PackedStringArray(["usta_" + u]) if u != "" else PackedStringArray()


func _usta_uzmanlik(g: Gelen) -> String:
	if g.stat < 7:
		return ""
	# UZM-01 gerçek zanaatı olan CHR, eski üçlü sınıftan usta sayılmaz (otacı Dudu "usta_demirci" olmaz).
	var kimlik := String(g.id).to_lower()
	if ZanaatTuru.CHR.has(kimlik):
		return {ZanaatTuru.Tur.CERRAH: "cerrah", ZanaatTuru.Tur.OTACI: "cerrah", ZanaatTuru.Tur.DEMIRCI: "demirci", ZanaatTuru.Tur.CIFTCI: "ciftci", ZanaatTuru.Tur.COBAN: "coban"}.get(ZanaatTuru.CHR[kimlik], "")
	return {&"ciftci": "ciftci", &"esnaf": "demirci", &"asker": "avci"}.get(g.sinif, "")


## Kapıda açılmayan gizli gerçekler köye taşınır.
func _gizliler(g: Gelen) -> PackedStringArray:
	var s := PackedStringArray()
	for b in g.gizli_bayraklar:
		if not b in g.acik_bayraklar:
			s.append(b)
	return s


## Gelenin köydeki adı (çeviri anahtarı çevrilmiş).
func tr_gelen(g: Gelen) -> String:
	return TranslationServer.translate(g.ad_anahtari)


func tr_ad(sinif: StringName) -> String:
	return TranslationServer.translate("arayuz.sinif." + String(sinif))


# ─── Olaylar ─────────────────────────────────────────────────────────────


## Bu gece sonu için uygun bir olay (ağırlıklı rastgele) ya da null.
func olay_sec() -> OlayVerisi:
	var taskin := IlkbaharTaskini.olay(self)
	if taskin != null: return taskin
	var tutanak := CasusDevriyesi.olay(self)
	if tutanak != null: return tutanak
	var pusula := FisiltiGazetesi.olay(self)
	if pusula != null: return pusula
	var ferman := SancakAskerTalebi.olay(self)
	if ferman != null: return ferman
	var haber := HaberciAgi.olay(self)
	if haber != null: return haber
	if _rng.randf() >= ayarlar.olay_olasiligi:
		return null
	var adaylar: Array[OlayVerisi] = []
	var toplam_agirlik := 0.0
	for o in katalog.olaylar():
		if o.tek_sefer and gorulen_olaylar.has(o.id):
			continue
		if not _kosul_tutar(o.kosullar):
			continue
		adaylar.append(o)
		toplam_agirlik += o.agirlik
	if adaylar.is_empty():
		return null
	var r := _rng.randf() * toplam_agirlik
	for o in adaylar:
		r -= o.agirlik
		if r <= 0.0:
			gorulen_olaylar[o.id] = true
			return o
	gorulen_olaylar[adaylar[-1].id] = true
	return adaylar[-1]



## İki gelen arasında kuyrukta bir olay (ağırlıklı rastgele) ya da null. `kuyruk`: sırada bekleyen sayısı.
func sira_olayi_sec(kuyruk: int) -> OlayVerisi:
	if kuyruk <= 0 or _rng.randf() >= ayarlar.sira_olay_olasiligi:
		return null
	var adaylar: Array[OlayVerisi] = []
	var toplam := 0.0
	for o in katalog.sira_olaylari():
		if kuyruk < int(o.kosullar.get("kuyruk_min", 1)):
			continue
		adaylar.append(o)
		toplam += o.agirlik
	if adaylar.is_empty():
		return null
	var r := _rng.randf() * toplam
	for o in adaylar:
		r -= o.agirlik
		if r <= 0.0:
			return o
	return adaylar[-1]



## Bir seçeneğin gereklilikleri karşılanıyor mu.
func secenek_olur(olay: OlayVerisi, i: int) -> bool:
	if HaberciAgi.tanimli(olay): return HaberciAgi.uygun(self, olay, i)
	if SancakAskerTalebi.tanimli(olay): return SancakAskerTalebi.uygun(self, olay, i)
	if IlkbaharTaskini.tanimli(olay): return IlkbaharTaskini.uygun(self, olay, i)
	if CasusDevriyesi.tanimli(olay): return CasusDevriyesi.uygun(self, olay, i)
	if FisiltiGazetesi.tanimli(olay): return FisiltiGazetesi.uygun(self, olay, i)
	var e: Dictionary = olay.secenek_etkileri[i]
	var g: Dictionary = e.get("gerekli", {})
	if akce < int(g.get("akce", 0)) or ambar < int(g.get("ambar", 0)):
		return false
	for id in g.get("koyde", []):
		if kadro.durumlar.get(StringName(id), {}).get("durum") != &"koyde":
			return false
	var gs: Dictionary = g.get("sinif", {})
	for s in gs:
		if koy.sayi(StringName(s)) < int(gs[s]):
			return false
	return true



## Seçeneği uygular. Döner: {kirilan, rusvet_harcandi, sonuc_anahtari}.
## `puan`: seçenek bir mini oyun açtıysa (`oyun`) alınan puan; ödül `oyun_odul` × puan, puan ≥ `oyun_esik`
## ise `oyun_basari` etkisi de uygulanır (design/gdd/koy-mini-oyunlari.md). −1 = oyun oynanmadı.
func olay_uygula(olay: OlayVerisi, i: int, puan: int = -1) -> Dictionary:
	if HaberciAgi.tanimli(olay): return HaberciAgi.uygula(self, olay, i)
	if SancakAskerTalebi.tanimli(olay): return SancakAskerTalebi.uygula(self, olay, i)
	if IlkbaharTaskini.tanimli(olay): return IlkbaharTaskini.uygula(self, olay, i)
	if CasusDevriyesi.tanimli(olay): return CasusDevriyesi.uygula(self, olay, i)
	if FisiltiGazetesi.tanimli(olay): return FisiltiGazetesi.uygula(self, olay, i)
	var e: Dictionary = olay.secenek_etkileri[i]
	if puan >= 0 and e.has("oyun"):
		var odul: Dictionary = e.get("oyun_odul", {})
		akce += int(odul.get("akce", 0)) * puan
		ambar += int(odul.get("ambar", 0)) * puan
		if puan >= int(e.get("oyun_esik", 9999)):
			var b: Dictionary = e.get("oyun_basari", {})
			if b.has("bar"):
				_bar_uygula(PackedInt32Array(b["bar"]))
	var g: Dictionary = e.get("gerekli", {})
	akce -= int(g.get("akce", 0))
	ambar -= int(g.get("ambar", 0))
	if e.has("bar"):
		_bar_uygula(PackedInt32Array(e["bar"]))
	akce += int(e.get("akce", 0))
	ambar = maxi(0, ambar + int(e.get("ambar", 0)))
	sonraki_gelen_ek += int(e.get("sonraki_gelen", 0))
	var nufus: Dictionary = e.get("nufus", {})
	for sinif in nufus:
		var n := int(nufus[sinif])
		for k in absi(n):
			if n > 0:
				yonetim.kabul({"ad": tr_ad(StringName(sinif)), "sinif": sinif, "stat": _rng.randi_range(3, 7)})
			else:
				_sinif_cikar(StringName(sinif))
	if e.has("bayrak"):
		bayraklar[StringName(e["bayrak"])] = true
	if e.has("ayril"):
		var id := StringName(e["ayril"])
		if kadro.durumlar.has(id) and kadro.durumlar[id]["durum"] == &"koyde":
			kadro.durumlar[id]["durum"] = &"kalici_ayrildi"
			for k in yonetim.koylular:
				if k.adli_id == id:
					yonetim.koylular.erase(k)
					break
	_koy_esitle()
	var sonuc := {"kirilan": -1, "rusvet_harcandi": -1}
	sonuc["sonuc_anahtari"] = "%s.sonuc%d" % [olay.metin_anahtari.trim_suffix(".metin"), i + 1]
	sonuc["oyun_puan"] = puan
	if puan >= 0 and e.has("oyun") and puan < int(e.get("oyun_esik", 0)):
		sonuc["sonuc_anahtari"] += "_az"
	return sonuc



func _kosul_tutar(k: Dictionary) -> bool:
	if not preload("res://src/sistemler/olay_on_kosulu.gd").uygun(self, k): return false
	if gun < int(k.get("gece_min", 0)) or gun > int(k.get("gece_max", 9999)):
		return false
	if k.has("perde") and perde != int(k["perde"]):
		return false
	for id in k.get("koyde", []):
		if kadro.durumlar.get(StringName(id), {}).get("durum") != &"koyde":
			return false
	for id in k.get("ayrildi", []):
		if not kadro.durumlar.get(StringName(id), {}).get("durum") in [&"kalici_ayrildi", &"donebilir"]:
			return false
	for b in k.get("bayrak", []):
		if not bayraklar.has(StringName(b)):
			return false
	for b in k.get("bayrak_yok", []):
		if bayraklar.has(StringName(b)):
			return false
	if koy.toplam() < int(k.get("nufus_min", 0)):
		return false
	if _yapi_sayisi("tarla") < int(k.get("tarla_ekili_min", 0)):
		return false
	var sm: Dictionary = k.get("sinif_min", {})
	for s in sm:
		if koy.sayi(StringName(s)) < int(sm[s]):
			return false
	if ambar > int(k.get("ambar_max", 9999)) or akce < int(k.get("akce_min", 0)):
		return false
	var ym: Dictionary = k.get("yapi_min", {})
	for y in ym:
		if _eski_yapi_seviyesi(String(y)) < int(ym[y]):
			return false
	var bm: Dictionary = k.get("bar_max", {})
	for i in bm:
		if gosterge(int(i)) > int(bm[i]):
			return false
	var bmin: Dictionary = k.get("bar_min", {})
	for i in bmin:
		if gosterge(int(i)) < int(bmin[i]):
			return false
	if k.has("sans") and _rng.randf() >= float(k["sans"]):
		return false
	return true



func _adli_gelen(id: StringName) -> Gelen:
	var k := katalog.karakter(id)
	var s := katalog.sohbet(k.sohbet_id)
	var g := Gelen.new()
	g.adli = true
	g.id = id
	g.ad_anahtari = k.ad_anahtari
	g.sinif = k.sinif
	g.portre = k.portre
	var ziyaret := int(kadro.durumlar[id]["ziyaret"]) + 1
	g.giris_anahtari = s.giris(ziyaret)
	g.acilis = s.acilis(ziyaret)
	var yerel := {}
	for i in s.sorular(ziyaret):
		yerel[i] = g.sorular.size()
		g.sorular.append(PackedStringArray([s.soru_anahtarlari[i], s.cevap_anahtarlari[i]]))
	for i in s.sorular(ziyaret):
		g.soru_ust.append(int(yerel.get(s.ust(i), -1)))
	g.secenekler = _perde_secenekleri(k.karar_secenekleri)
	for karar in g.secenekler:
		g.etkiler[StringName(karar)] = k.etki(karar)
	g.azami_soru = k.azami_soru
	g.tehlikeli = k.tehlikeli
	g.stat = k.zanaat if k.zanaat > 0 else 4 + int(String(id).hash() % 4)
	g.gizli_bayraklar = k.gizli_bayraklar.duplicate()
	if g.tehlikeli and g.gizli_bayraklar.is_empty():
		g.gizli_bayraklar.append("casus_suphesi")
	g.soru_bayraklari = s.soru_bayraklari_ziyaret(ziyaret)
	return g



## Sıradaki hazır diyalog (data/diyalog). Her biri oyun başına bir kez gelir; bitince boş döner
## ve adsız gelenler sınıf şablonlarına düşer (aynı kişi ikinci kez kapıya gelmez).
func _gemini_al() -> Dictionary:
	if _gemini.is_empty():
		var metin := FileAccess.get_file_as_string("res://data/diyalog/diyalog_01_20.json")
		var ayris = JSON.parse_string(metin)
		if ayris is Array:
			_gemini = ayris
	if _gemini_sira >= _gemini.size():
		return {}
	var d: Dictionary = _gemini[_gemini_sira]
	_gemini_sira += 1
	return d



func _figur_gelen() -> Gelen:
	var d := _gemini_al()
	if d.is_empty():
		return _figur_sablon()
	var sablon := katalog.sinif(StringName(String(d["sinif"])))
	var ornek := kadro.figur_ornegi(sablon)
	var g := Gelen.new()
	g.ad_anahtari = ornek["ad_anahtari"]
	g.sinif = sablon.sinif
	g.portre = sablon.portreler[0]
	g.giris_anahtari = String(d["sahne"])
	g.acilis = String(d.get("acilis", ""))
	_json_sorular(g, d["sorular"], -1)
	var tum: Array = []
	for i in d["secenekler"].size():
		tum.append({"k": String(d["secenekler"][i]), "e": int(d["esik"][i])})
	if perde != 1:
		var sade: Array = []
		for o in tum:
			if o["k"] == "kabul" or o["k"] == "ret":
				sade.append(o)
		tum = sade
	g.secenekler = PackedStringArray()
	g.esikler = PackedInt32Array()
	for o in tum:
		g.secenekler.append(o["k"])
		g.esikler.append(int(o["e"]))
	g.yanitlar = d["yanitlar"]
	g.stat = _rng.randi_range(3, 7)
	for karar in g.secenekler:
		var etki := sablon.etki(karar).duplicate()
		if karar == "kabul":
			etki[_rng.randi_range(0, etki.size() - 1)] += 1 if _rng.randf() < 0.5 else -1
		g.etkiler[StringName(karar)] = etki
	return g



## JSON diyalogdaki soru ağacını düzler: [soru, cevap, [takipler]].
func _json_sorular(g: Gelen, liste: Array, ust: int) -> void:
	for cift in liste:
		var i := g.sorular.size()
		g.sorular.append(PackedStringArray([String(cift[0]), String(cift[1])]))
		g.soru_ust.append(ust)
		if cift.size() > 2 and cift[2] is Array:
			_json_sorular(g, cift[2], i)



func _figur_sablon() -> Gelen:
	var sablon := katalog.sinif(GuvenlikKafileDengesi.sinif_sec(self))
	var ornek := kadro.figur_ornegi(sablon)
	var cesit: int = ornek["cesit"]
	var g := Gelen.new()
	g.ad_anahtari = ornek["ad_anahtari"]
	g.sinif = sablon.sinif
	g.portre = sablon.portreler[cesit]
	g.giris_anahtari = sablon.giris_anahtarlari[cesit]
	if cesit < sablon.acilis_anahtarlari.size():
		g.acilis = sablon.acilis_anahtarlari[cesit]
	var yerel := {}
	for i in sablon.soru_anahtarlari.size():
		if sablon.soru_cesidi[i] == cesit:
			yerel[i] = g.sorular.size()
			g.sorular.append(PackedStringArray([sablon.soru_anahtarlari[i], sablon.cevap_anahtarlari[i]]))
			var u: int = sablon.soru_ust[i] if i < sablon.soru_ust.size() else -1
			g.soru_ust.append(int(yerel.get(u, -1)))
	g.stat = _rng.randi_range(3, 7)
	g.secenekler = _perde_secenekleri(sablon.karar_secenekleri)
	for karar in g.secenekler:
		var etki := sablon.etki(karar).duplicate()
		# Figürlerde gizli küçük fark: kabulün bir bara ek etkisi.
		if karar == "kabul":
			etki[_rng.randi_range(0, etki.size() - 1)] += 1 if _rng.randf() < 0.5 else -1
		g.etkiler[StringName(karar)] = etki
	return g



## İkinci perdede kapı sade bir süzgeçtir: yalnız kabul ve ret.
func _perde_secenekleri(secenekler: PackedStringArray) -> PackedStringArray:
	if perde == 1:
		return secenekler
	return PackedStringArray(["kabul", "ret"])


## Gün sonu kaydı için sözlük (oturum + köy yönetimi).
func kaydet() -> Dictionary:
	return {"surum": KAYIT_SURUMU, "tohum": str(tohum), "sonraki_gelen_ek": sonraki_gelen_ek,
		"faz": preload("res://src/sistemler/oturum_fazi.gd").durum(self),
		"bayraklar": bayraklar.keys().map(func(x): return String(x)),
		"rusvet_sayisi": int(bayraklar.get(&"rusvet_sayisi", 0)),
		"gorulen_olaylar": gorulen_olaylar.keys().map(func(x): return String(x)),
		"kadro": kadro.kaydet(),
		"diyalog_sira": _gemini_sira,
		"muhafiz_tecrubesi": muhafiz_tecrubesi,
		"muhafiz_akce": muhafiz_akce, "muhafiz_esyalari": muhafiz_esyalari.duplicate(true),
		"kasa_transferleri": kasa_transferleri.duplicate(true),
		"muhafiz_vicdani": MuhafizVicdani.oku(muhafiz_vicdani),
		"oda_gelisimi": MuhafizOdaGelisimi.oku(oda_gelisimi),
		"sancak_teftisi": SancakTeftisi.oku(sancak_teftisi),
		"mogol_oncusu": MogolOncusu.oku(mogol_oncusu),
		"sancak_asker_talebi": SancakAskerTalebi.oku(sancak_asker_talebi),
		"goc_yolu_guvenligi": GocYoluGuvenligi.oku(goc_yolu_guvenligi),
		"pusu_ticaret_akisi": preload("res://src/koy/ticaret/pusu_ticaret_akisi.gd").durum(self),
		"oba_ittifaki": ObaIttifaki.oku(oba_ittifaki),
		"haberci_agi": HaberciAgi.oku(haberci_agi), "diplomatik_heyet": DiplomatikHeyet.durum(self),
		"muhafiz_yetenekleri": MuhafizYetenekleri.oku(muhafiz_yetenekleri),
		"mevsim": yonetim.mevsim(), "yeni_binalar": yeni_binalar.duplicate(true),
		"koy_yonetimi": yonetim.kaydet(),
		"rng": [str(_rng.state), str(_rng_donus.state), str(_rng_ad.state), str(_rng_heybe.state)]}
	# 64 bit sayılar JSON'da float'a döner; metin olarak saklanır.


## Kayıttan oturum kurar; geçersizse null.
static func kayittan(katalog_: Katalog, veri: Dictionary) -> Oturum:
	veri = preload("res://src/sistemler/kayit_gocu.gd").uygula(veri, katalog_.koy_ayarlari.mevsim_gun)
	if veri.is_empty():
		push_error("Kayıt sürümü uyuşmuyor")
		return null
	var o := Oturum.new(katalog_, String(veri["tohum"]).to_int())
	preload("res://src/sistemler/oturum_fazi.gd").ayarla(o, preload("res://src/sistemler/oturum_fazi.gd").oku(veri.get("faz")))
	o.yonetim = KoyYonetimi.kayittan(katalog_.koy_ayarlari, katalog_.binalar, veri["koy_yonetimi"])
	o.sonraki_gelen_ek = int(veri.get("sonraki_gelen_ek", 0))
	for b in veri.get("bayraklar", []):
		o.bayraklar[StringName(b)] = true
	if int(veri.get("rusvet_sayisi", 0)) > 0:
		o.bayraklar[&"rusvet_sayisi"] = int(veri["rusvet_sayisi"])
	for g in veri.get("gorulen_olaylar", []):
		o.gorulen_olaylar[StringName(g)] = true
	if not o.kadro.yukle(veri.get("kadro", {})):
		return null
	var r: Array = veri.get("rng", [])
	if r.size() >= 4:
		o._rng.state = String(r[0]).to_int()
		o._rng_donus.state = String(r[1]).to_int()
		o._rng_ad.state = String(r[2]).to_int()
		o._rng_heybe.state = String(r[3]).to_int()
	o._gemini_sira = preload("res://src/sistemler/diyalog_sirasi.gd").oku(veri.get("diyalog_sira"))
	o.muhafiz_tecrubesi = maxi(0, int(veri.get("muhafiz_tecrubesi", 0)))
	o.muhafiz_akce = maxi(0, int(veri.get("muhafiz_akce", 0)))
	o.kasa_transferleri = KasaTransferi.oku(veri.get("kasa_transferleri"))
	o.muhafiz_vicdani = MuhafizVicdani.oku(veri.get("muhafiz_vicdani"))
	o.oda_gelisimi = MuhafizOdaGelisimi.oku(veri.get("oda_gelisimi"))
	o.sancak_teftisi = SancakTeftisi.oku(veri.get("sancak_teftisi"))
	o.mogol_oncusu = MogolOncusu.oku(veri.get("mogol_oncusu"))
	o.sancak_asker_talebi = SancakAskerTalebi.oku(veri.get("sancak_asker_talebi"))
	o.goc_yolu_guvenligi = GocYoluGuvenligi.oku(veri.get("goc_yolu_guvenligi"))
	o.set_meta(&"har14_ticaret_akisi", preload("res://src/koy/ticaret/pusu_ticaret_akisi.gd").oku(veri.get("pusu_ticaret_akisi")))
	o.oba_ittifaki = ObaIttifaki.oku(veri.get("oba_ittifaki"))
	o.haberci_agi = HaberciAgi.oku(veri.get("haberci_agi"))
	o.set_meta(DiplomatikHeyet.META, DiplomatikHeyet.oku(veri.get("diplomatik_heyet")))
	o.muhafiz_yetenekleri = MuhafizYetenekleri.oku(veri.get("muhafiz_yetenekleri"))
	MuhafizAdaletYetenekleri.bagla(o)
	o.muhafiz_esyalari = preload("res://src/sistemler/cift_kasa_dagitimi.gd").esyalari_yukle(veri.get("muhafiz_esyalari", []))
	o.yeni_binalar.assign(veri.get("yeni_binalar", []))
	o._koy_esitle()
	return o
