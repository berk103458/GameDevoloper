## Bir oyun oturumu: gün döngüsü, kuyruk, karar, gece sonu çözümü ve kayıt.
## Kurallar: design/gdd/oyun-durumu-ve-gun-dongusu.md ve karakter-kadrosu.md;
## Barlar, Karar ve savunma için prototipte sınanan geçici kurallar (Open Questions).
class_name Oturum
extends RefCounted

const KAYIT_SURUMU := 1

var katalog: Katalog
var ayarlar: OyunAyarlari
var barlar: Barlar
var koy: KoyNufusu
var kadro: KarakterKadrosu
## Tamamlanan gece sayısı = skor.
var gun: int = 0
## 1 = kapı ve köy, 2 = ağalık ve savunma.
var perde: int = 1
var perde2_gece: int = 0
var rusvet_hakki: int = 3
var tohum: int = 0
var _rng: RandomNumberGenerator
var _rng_donus: RandomNumberGenerator
var _rng_ad: RandomNumberGenerator


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
	barlar = Barlar.new(ayarlar.bar_anahtarlari.size(), ayarlar.bar_baslangic, ayarlar.bar_azami)
	koy = KoyNufusu.new()
	kadro = KarakterKadrosu.new(katalog, _rng_donus, _rng_ad)
	rusvet_hakki = ayarlar.rusvet_hakki


## Gösterilen gece numarası (1'den).
func gosterilen_gece() -> int:
	return gun + 1


## Bu gecenin varış listesi.
func gece_kuyrugu() -> Array[Gelen]:
	koy.bu_gece_girenler = []
	var sayi := ayarlar.gece_basina_gelen if perde == 1 else ayarlar.perde2_gece_basina_gelen
	var uygun := kadro.uygunlar(gun)
	var sonuc: Array[Gelen] = []
	for i in sayi:
		if not uygun.is_empty() and _rng.randf() < ayarlar.adli_olasiligi:
			var id: StringName = uygun.pop_at(_rng.randi_range(0, uygun.size() - 1))
			kadro.iste(id, gun)
			sonuc.append(_adli_gelen(id))
		else:
			sonuc.append(_figur_gelen())
	return sonuc


## Sohbet açıldı (adlı karakterde ziyaret sayılır).
func ziyaret_basladi(gelen: Gelen) -> void:
	if gelen.adli:
		kadro.ziyaret_basladi(gelen.id, gun)


## Karar uygulanır. Döner: {kaldi, kirilan (-1), rusvet_harcandi (bar indeksi ya da -1)}.
func karar_ver(gelen: Gelen, karar: StringName) -> Dictionary:
	barlar.uygula(gelen.etkiler.get(karar, PackedInt32Array()))
	var kaldi := karar != &"ret"
	if kaldi:
		var sinif: StringName = &"asker" if karar == &"kisla" else gelen.sinif
		koy.ekle(sinif, gelen.id if gelen.adli else &"", gelen.portre if gelen.adli else "")
	if gelen.adli:
		kadro.sonuc(gelen.id, kaldi, karar, gun)
	var sonuc := _bar_cozumu()
	sonuc["kaldi"] = kaldi
	return sonuc


## Gece sonu çözümü (GDD 1 sırası: baskılar → bar → son → köy oturdu → sayaç → kayıt).
## Döner: {olaylar: PackedStringArray (çeviri anahtarı), kirilan, rusvet_harcandi, son: StringName, perde_degisti: bool}
func gece_sonu() -> Dictionary:
	var olaylar := PackedStringArray()
	var toplam := koy.toplam()
	if perde == 1:
		if toplam > 0 and koy.sayi(&"ciftci") * ayarlar.gida_carpani < toplam:
			barlar.ekle(0, -1)
			olaylar.append("anlati.baski.gida")
		if gun >= ayarlar.ordu_baski_gecesi and koy.sayi(&"asker") * 2 < gun:
			barlar.ekle(3, -1)
			olaylar.append("anlati.baski.ordu")
		if gun >= ayarlar.tuccar_baski_gecesi and koy.sayi(&"esnaf") == 0:
			barlar.ekle(2, -1)
			olaylar.append("anlati.baski.tuccar")
	else:
		var saldiri := ayarlar.saldiri_taban + perde2_gece / ayarlar.saldiri_artis_araligi
		var savunma := koy.sayi(&"asker") / ayarlar.savunma_bolen
		if saldiri > savunma:
			barlar.ekle(3, -1)
			barlar.ekle(0, -1)
			olaylar.append("anlati.saldiri.agir")
		else:
			olaylar.append("anlati.saldiri.puskurtuldu")
		if toplam > 0 and koy.sayi(&"ciftci") * ayarlar.gida_carpani < toplam:
			barlar.ekle(0, -1)
			olaylar.append("anlati.baski.gida")
	if (gun + 1) % ayarlar.vergi_araligi == 0:
		barlar.ekle(1, -1)
		olaylar.append("anlati.baski.vergi")
	var sonuc := _bar_cozumu()
	sonuc["olaylar"] = olaylar
	sonuc["son"] = &""
	sonuc["perde_degisti"] = false
	if sonuc["kirilan"] >= 0:
		sonuc["son"] = &"kirildi"
		return sonuc
	gun += 1
	kadro.gece_bitti()
	if perde == 2:
		perde2_gece += 1
		if perde2_gece >= ayarlar.perde2_hedef_gece:
			sonuc["son"] = &"tutundu"
	elif koy.toplam() >= ayarlar.oturma_esigi:
		perde = 2
		sonuc["perde_degisti"] = true
	return sonuc


## Kırılan bar varsa önce rüşvet hakkı harcanır.
func _bar_cozumu() -> Dictionary:
	var sonuc := {"kirilan": -1, "rusvet_harcandi": -1}
	var i := barlar.kirilan()
	while i >= 0:
		if rusvet_hakki > 0:
			rusvet_hakki -= 1
			barlar.ayarla(i, ayarlar.rusvet_kurtarma)
			sonuc["rusvet_harcandi"] = i
			i = barlar.kirilan()
		else:
			sonuc["kirilan"] = i
			break
	return sonuc


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
	for i in s.sorular(ziyaret):
		g.sorular.append(PackedStringArray([s.soru_anahtarlari[i], s.cevap_anahtarlari[i]]))
	g.secenekler = _perde_secenekleri(k.karar_secenekleri)
	for karar in g.secenekler:
		g.etkiler[StringName(karar)] = k.etki(karar)
	return g


func _figur_gelen() -> Gelen:
	var siniflar := Katalog.SINIFLAR
	var sablon := katalog.sinif(siniflar[_rng.randi_range(0, siniflar.size() - 1)])
	var ornek := kadro.figur_ornegi(sablon)
	var cesit: int = ornek["cesit"]
	var g := Gelen.new()
	g.ad_anahtari = ornek["ad_anahtari"]
	g.sinif = sablon.sinif
	g.portre = sablon.portreler[cesit]
	g.giris_anahtari = sablon.giris_anahtarlari[cesit]
	for i in sablon.soru_anahtarlari.size():
		if sablon.soru_cesidi[i] == cesit:
			g.sorular.append(PackedStringArray([sablon.soru_anahtarlari[i], sablon.cevap_anahtarlari[i]]))
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


## Gece sonu kaydı için sözlük.
func kaydet() -> Dictionary:
	return {"surum": KAYIT_SURUMU, "tohum": str(tohum), "gun": gun, "perde": perde, "perde2_gece": perde2_gece,
		"rusvet_hakki": rusvet_hakki, "barlar": Array(barlar.degerler),
		"koy": {"asker": koy.sayi(&"asker"), "esnaf": koy.sayi(&"esnaf"), "ciftci": koy.sayi(&"ciftci")},
		"koy_adlilar": koy.adlilar.map(func(x): return String(x)),
		"kadro": kadro.kaydet(),
		"rng": [str(_rng.state), str(_rng_donus.state), str(_rng_ad.state)]}
	# 64 bit sayılar JSON'da float'a döner; metin olarak saklanır.


## Kayıttan oturum kurar; geçersizse null.
static func kayittan(katalog_: Katalog, veri: Dictionary) -> Oturum:
	if int(veri.get("surum", 0)) != KAYIT_SURUMU:
		push_error("Kayıt sürümü uyuşmuyor")
		return null
	var gun_: float = veri.get("gun", -1)
	var perde_: int = int(veri.get("perde", 0))
	if gun_ < 0 or gun_ != floorf(gun_) or not perde_ in [1, 2]:
		push_error("Kayıt geçersiz: gün/perde")
		return null
	var o := Oturum.new(katalog_, String(veri["tohum"]).to_int())
	o.gun = int(gun_)
	o.perde = perde_
	o.perde2_gece = int(veri.get("perde2_gece", 0))
	o.rusvet_hakki = int(veri.get("rusvet_hakki", 0))
	var b: Array = veri.get("barlar", [])
	for i in mini(b.size(), o.barlar.degerler.size()):
		o.barlar.degerler[i] = int(b[i])
	var k: Dictionary = veri.get("koy", {})
	for s in [&"asker", &"esnaf", &"ciftci"]:
		o.koy.sayilar[s] = int(k.get(String(s), 0))
	for a in veri.get("koy_adlilar", []):
		o.koy.adlilar.append(StringName(a))
	if not o.kadro.yukle(veri.get("kadro", {})):
		return null
	var r: Array = veri.get("rng", [])
	if r.size() == 3:
		o._rng.state = String(r[0]).to_int()
		o._rng_donus.state = String(r[1]).to_int()
		o._rng_ad.state = String(r[2]).to_int()
	return o
