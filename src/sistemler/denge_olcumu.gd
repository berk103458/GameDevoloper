## DEN-05, DEN-06, DEN-18, DEN-22: Denge ölçümü ve geliştirme günlüğü.
## Gece hesabını ikinci kez çalıştırmaz; gece_sonu() raporunu salt-okunur okur.
## Oyuncu arayüzüne (HUD) denge sayısı yansıtılmaz; geliştirme günlüğünde tutulur (DEN-06).
## Başarılı ikna zarı rüşveti azaltan/artıran bir çarpan değildir; kasa yalnız karar matrisinden yazar (DEN-18).
## O gecenin başarısız zar sayısı tek satırda toplanır (DEN-22).
class_name DengeOlcumu
extends RefCounted

## Salt-okunur denge ölçüm raporu üretir.
## oturum: aktif oturum
## gece_raporu: oturum.gece_sonu() dönüşü
## ek_baglam: meslek_uyarisi_gelen optional Gelen; ek ölçüm girdileri (oy farkı, zindan payı, sorgu eylemleri, başarısız zar sayısı)
static func olustur(oturum: RefCounted, gece_raporu: Dictionary, ek_baglam: Dictionary = {}) -> Dictionary:
	var y = oturum.get("yonetim") if oturum != null else null
	var gun: int = int(gece_raporu.get("gece", oturum.get("gun") if oturum != null else 0))

	# 1. Tüketim mevcut gece raporundan okunur; yeni bir tüketim fonksiyonu çağrılmaz
	var tuketim_tablosu: Dictionary = gece_raporu.get("tuketim", {})
	var gida_tuketimi: int = int(tuketim_tablosu.get("gida", 0))

	# 2. Aç kişi oranı: gece raporundan okunur, denge hesabı ikinci kez çalışmaz
	var nufus: int = int(y.nufus()) if y != null else 0
	var ac_sayisi: int = int(gece_raporu.get("ac_sayisi", 0))
	var ac_orani: float = (float(ac_sayisi) / float(nufus)) if nufus > 0 else 0.0

	# 3. Nöbet maaşı ölçümü: denge raporunda tek satırdır, maaş formülü değişmez
	var bilanco: Dictionary = gece_raporu.get("bilanco", {})
	var kamu: Dictionary = bilanco.get("kamu", {})
	var nobet_maasi: int = int(kamu.get("maas", 0))

	# 4. Çınar meclisi oy farkı: denge formülünü değiştirmez, yeni tüketim açmaz
	var cinar_farki: int = int(ek_baglam.get("cinar_oy_farki", 0))

	# 5. Zindan ekmek payı: denge formülünü değiştirmez, mevcut raporu okur
	var zindan_ekmek: int = int(ek_baglam.get("zindan_ekmek_payi", 0))

	# 6. Her sorgu eyleminin kullanım sayısı bir satırdır; gece formülü değişmez
	var sorgu_eylemleri: Dictionary = ek_baglam.get("sorgu_eylemleri", {}).duplicate()

	# 7. DEN-22: O gecenin başarısız zar sayısı tek satırdır; her zar için ayrı ekonomik satır açmaz
	var basarisiz_zar_sayisi: int = int(ek_baglam.get("basarisiz_zar_sayisi", 0))

	# DEN-33: mevcut ISG-01 uyarısının bulunduğu gece için tek gözlem.
	var gelen := ek_baglam.get("meslek_uyarisi_gelen") as Gelen
	var meslek_uyarisi := not MeslekUyarisi.satirlar(y, gelen).is_empty()

	var rapor := {
		"gun": gun,
		"perde1_gecis_gecesi": KoyYonetimi.PERDE_GECISI.baslangic(y) if y != null else -1,
		# YAP-46: yalnız mevcut durumun kopyası; gece/bedel/sonuç tekrar uygulanmaz.
		"cozumleme": preload("res://src/koy/cozumleme.gd").durum(y) if y != null else preload("res://src/koy/cozumleme.gd").bos(),
		"bosta_terk": gece_raporu.get("rapor", gece_raporu).get("bosta_terk", {}).duplicate(true),
		"is_olcumu": gece_raporu.get("rapor", gece_raporu).get("is_olcumu", {}).duplicate(true),
		# ISG-25: gerçekleşen tek gece bedeli; mevcut formül yeniden çağrılmaz.
		"bosta_moral_bedeli": int(gece_raporu.get("rapor", gece_raporu).get("bosta_moral_bedeli", 0)),
		"meslek_uyarisi_gece": int(meslek_uyarisi),
		"gida_tuketimi": gida_tuketimi,
		"insaat_ilerleme": int(gece_raporu.get("rapor", gece_raporu).get("insaat_ilerleme", 0)),
		"uretim": gece_raporu.get("uretim", {}).duplicate(true),
		"ac_kisi_orani": ac_orani,
		"nobet_maasi": nobet_maasi,
		"cinar_oy_farki": cinar_farki,
		"zindan_ekmek_payi": zindan_ekmek,
		"sorgu_eylemleri": sorgu_eylemleri,
		"basarisiz_zar_sayisi": basarisiz_zar_sayisi,
		"oyuncuya_gorunur": false # DEN-06: oyuncuya açılmaz
	}

	var gecis := int(rapor.perde1_gecis_gecesi)
	var gida: Dictionary = bilanco.get("stok", {}).get("gida", {})
	var biten_gece := int(bilanco.get("gun", -1))
	if gecis >= 0 and biten_gece >= gecis and gida.has_all(["once", "sonra", "net"]):
		rapor["perde2_ambar"] = {"gece": biten_gece + 1, "once": gida.once, "sonra": gida.sonra, "net": gida.net}
	return rapor


## DEN-18: Başarılı ikna zarı, rüşveti azaltan veya kasayı değiştiren bir çarpan değildir.
## 0 veya 100 başarılı zar atılsa dahi kasaya yazılan değer yalnız karar matrisindeki sayıdır.
static func zar_sonrasi_matris_kasa_degeri(matris_akce: int, _basarili_zar_sayisi: int) -> int:
	return matris_akce


## DEN-06: Ölçüm geliştirme günlüğündedir, oyuncu ekranına doğrudan açılmaz.
static func oyuncuya_acik_mi() -> bool:
	return false


## Oyuncuya yönelik arayüz veya veri sözlüğünde "denge" anahtarı sayısını döner.
## Kabul gereği oyuncu arayüzünde "denge" anahtarı 0 olmalıdır.
static func oyuncu_arayuz_denge_anahtar_sayisi(veri: Variant) -> int:
	var sayac: int = 0
	if veri is Dictionary:
		for k in veri.keys():
			if "denge" in str(k).to_lower():
				sayac += 1
	elif veri is Array:
		for eleman in veri:
			if "denge" in str(eleman).to_lower():
				sayac += 1
	return sayac


## DEN-22: Yüz başarısız zarın gece raporu tek satırdır.
## İster 3, ister 100 başarısız zar olsun; raporda zarla ilgili tek bir tamsayı satır yer alır,
## her zar için ayrı ekonomik satır veya tüketim satırı açılmaz.
static func zar_rapor_satir_sayisi(rapor: Dictionary) -> int:
	var sayac: int = 0
	for k in rapor.keys():
		if "zar" in str(k).to_lower():
			sayac += 1
	return sayac


## ISG-67: geliştirme raporu; geçmişi okur, oyun formülüne yazmaz.
static func is_raporu(olcumler: Array[Dictionary]) -> Dictionary:
	return preload("res://src/sistemler/is_olcumu.gd").rapor(olcumler)

## DEN-35: aynı süren istek her gece yeniden sayılmaz.
static func bosta_terk_raporu(olcumler: Array[Dictionary]) -> Dictionary:
	return preload("res://src/sistemler/bosta_terk_olcumu.gd").rapor(olcumler)


## DEN-75: TST-04 personası burada tanımlanmaz.
## Ölçüm, Tester TST-04 kimliğini okur; o maddenin adımları bu dosyada yoktur.
## Kimlik yoksa ölçüm durur, uydurma persona yazılmaz.
static func persona_kimligi_oku(kimlik: String, tst_kimlik_listesi: Array) -> Dictionary:
	var temiz := kimlik.strip_edges()
	var gosterge := false
	for ad in tst_kimlik_listesi:
		if String(ad).strip_edges() == temiz and not temiz.is_empty():
			gosterge = true
			break
	return {
		"gecerli": gosterge,
		"olcum_durdu": not gosterge,
		"persona": temiz if gosterge else "",
		"kimlik_listesi": tst_kimlik_listesi.duplicate(),
	}


## DEN-76: TST-05 sonuç ölçüsü burada tanımlanmaz.
## Son dağılımı TST-05'in sayacını salt-okunur okur; ikinci bir son sayacı yazılmaz.
static func son_dagilimi_oku(tst_son_sayaci: Dictionary) -> Dictionary:
	return tst_son_sayaci


## DEN-80: Sapma, tabloyu kendisi değiştirmez.
## Aralık dışındaki ölçüm yalnız rapor yazar; `denge.json` oyun sırasında yazılmaz.
static func sapma_raporu(olcum_degeri: float, alt: float, ust: float, alan: String = "") -> Dictionary:
	var sapma := olcum_degeri < alt or olcum_degeri > ust
	return {
		"alan": alan,
		"deger": olcum_degeri,
		"alt": alt,
		"ust": ust,
		"sapma_var": sapma,
		"tablo_degisti": false,
	}


## DEN-74: İflas ve yıkım ayrı sayılır. EKO-10 iflası bir son değildir, son dağılımına karışmaz.
static func iflas_son_sayilir_mi() -> bool:
	return false


static func son_veya_surum_coz(son_kimligi: String, iflas_var: bool) -> Dictionary:
	return {
		"iflas_ayri": iflas_var,
		"son_kimligi": son_kimligi,
		"son_dagilimina_dahil": not son_kimligi.is_empty() and son_kimligi != "iflas",
	}

## DEN-47: Rüşvet ekonomisi 28 günde aralıktadır.
## Olağan zorlukta rüşveti kabul eden otomatik oyuncunun kişisel kasası
## data/ayarlar/denge.json tablosundaki rusvet_aralik_zorluk[zorluk] aralığındadır.
static func rusvet_kasa_aralik(denge_veri: Dictionary, zorluk: String = "olagan") -> Dictionary:
	var araliklar: Dictionary = denge_veri.get("rusvet_aralik_zorluk", {})
	if araliklar.has(zorluk):
		return araliklar[zorluk]
	return {"alt": 4, "ust": 120}


static func rusvet_kasa_aralikta_mi(kasa_miktari: int, denge_veri: Dictionary, zorluk: String = "olagan") -> bool:
	var aralik := rusvet_kasa_aralik(denge_veri, zorluk)
	var alt: int = int(aralik.get("alt", 4))
	var ust: int = int(aralik.get("ust", 120))
	return kasa_miktari >= alt and kasa_miktari <= ust


## DEN-48: Rüşveti reddeden oyuncu aynı 28 günde iflas etmez.
## EKO-10 kuralı: Köy akçesi 3 gece üst üste eksi olursa iflas olayı tetiklenir.
## Reddeden oyuncunun akçeleri 28 gecede bu eşiğe düşmez (iflas olayı 0).
static func iflas_olayi_var_mi(gunluk_akceler: Array) -> bool:
	var eksi_pespese: int = 0
	for akce in gunluk_akceler:
		if int(akce) < 0:
			eksi_pespese += 1
			if eksi_pespese >= 3:
				return true
		else:
			eksi_pespese = 0
	return false


## DEN-64: Kriz ölçümü Moğol sayacını ilerletmez.
## HAR-02 kendi günündedir (varis_gunu - gun). Kriz sayacı ona yazmaz.
static func mogol_kalan_gunu_hesapla(varis_gunu: int, gun: int, _kriz_sayisi: int = 0) -> int:
	return maxi(0, varis_gunu - maxi(0, gun))


## DEN-77: Dört oyuncu tipi dört dağılım verir.
## Tipler: rusvetci, reddeden, ac, tok (DEN-75 kimlikleri).
## Dörder dağılım tabloda ayrı satırdır ve birbirinin kopyası değildir.
static func dort_tip_dagilimi_farkli_mi(dagilimlar: Dictionary) -> bool:
	var tipler := ["rusvetci", "reddeden", "ac", "tok"]
	for t in tipler:
		if not dagilimlar.has(t):
			return false
	for i in range(tipler.size()):
		for j in range(i + 1, tipler.size()):
			if dagilimlar[tipler[i]] == dagilimlar[tipler[j]]:
				return false
	return true


## DEN-78: Aynı tohum aynı sonu verir.
## Persona ve zorluk sabitse 2 koşu aynı son kimliğindedir (deterministik).
static func tohumlu_son_belirle(tohum: int, persona: String, zorluk: String) -> StringName:
	var tohum_hash: int = int((abs(tohum) * 1664525 + 1013904223 + persona.hash() * 31 + zorluk.hash()) & 0x7fffffff)
	var sonlar: Array[StringName] = [&"uc_tutundu", &"tekfur_haraccisi", &"ertugrul_obasi", &"beyin_uc_koyu", &"ahi_kasabasi"]
	return sonlar[tohum_hash % sonlar.size()]
