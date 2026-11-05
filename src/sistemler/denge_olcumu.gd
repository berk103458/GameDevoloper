## DEN-05, DEN-06, DEN-22: Denge ölçümü ve geliştirme günlüğü.
## Gece hesabını ikinci kez çalıştırmaz; gece_sonu() raporunu salt-okunur okur.
## Oyuncu arayüzüne (HUD) denge sayısı yansıtılmaz; geliştirme günlüğünde tutulur (DEN-06).
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

	return rapor


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
