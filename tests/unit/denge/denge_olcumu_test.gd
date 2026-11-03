## DEN-05: Ölçüm raporu gece hesabını ikinci kez çalıştırmaz birim testi.
## Çalıştırma: godot --headless --path . -s tests/unit/denge/denge_olcumu_test.gd
extends SceneTree

const DENGE_OLCUMU = preload("res://src/sistemler/denge_olcumu.gd")

var _hata := 0

func dene(v: bool, ad: String) -> void:
	if not v:
		_hata += 1
		push_error("HATA: %s" % ad)
		print("FAIL: %s" % ad)
	else:
		print("PASS: %s" % ad)

func _initialize() -> void:
	var k := Katalog.new()
	if k.yukle() == Katalog.Durum.HAZIR:
		var oturum := Oturum.new(k, 555)

		# 1. Gece sonu çağrılır (tüketim fonksiyonu bu akışta bir kez çalışır)
		var bina := KoyBinasi.new()
		bina.id = 99
		bina.tur = "tarla"
		bina.insa_kalan = 3
		oturum.yonetim.binalar.append(bina)
		var gece_raporu := oturum.gece_sonu()
		dene(gece_raporu.has("olaylar") or gece_raporu.has("rapor"), "Gece sonu raporu üretildi")

		# 2. Denge ölçümü oluşturulur: gece_sonu() ikinci kez çağrılmaz
		var gun_once: int = oturum.gun
		var ambar_once: int = oturum.ambar
		var ek_baglam := {
			"cinar_oy_farki": 3,
			"zindan_ekmek_payi": 2,
			"sorgu_eylemleri": {"soru": 4, "heybe": 1, "bak": 2},
			"basarisiz_zar_sayisi": 1
		}
		gece_raporu["uretim"] = {"odun": 7}
		gece_raporu["esyalar"] = ["usta_defteri"]
		var olcum := DENGE_OLCUMU.olustur(oturum, gece_raporu, ek_baglam)
		dene(bina.insa_kalan < 3 and olcum.insaat_ilerleme == 3 - bina.insa_kalan, "YAP-70: gercek insaat ilerlemesi")
		dene(not olcum.keys().any(func(anahtar: Variant) -> bool: return str(anahtar).contains("esya")), "YAP-54: esya icin zorunlu olcum yok")
		dene(olcum.uretim == gece_raporu.uretim, "ISG-43: uretim farki sifir")
		olcum.uretim["odun"] = 0
		dene(gece_raporu.uretim.odun == 7, "ISG-43: kaynak rapor korunur")

		# 3. Kabul: Tüketim ikinci kez çalışmaz, gün ve ambar değişmez
		dene(oturum.gun == gun_once, "Denge ölçümü oturum gününü ilerletmez (ikinci gece_sonu yok)")
		dene(oturum.ambar == ambar_once, "Denge ölçümü tüketim fonksiyonunu ikinci kez çalıştırmaz (ambar sabit)")

		# 4. Ek şart: Nöbet maaşı ölçümü denge raporunun bir satırıdır; maaş formülü bu satırda değişmez
		dene(olcum.has("nobet_maasi"), "Nöbet maaşı ölçümü raporda bir satırdır")

		# 5. Ek şart: Çınar meclisi oy farkı denge formülünü değiştirmez, yeni tüketim açmaz
		dene(olcum.get("cinar_oy_farki") == 3, "Çınar meclisi oy farkı raporda bir satırdır")
		dene(oturum.ambar == ambar_once, "Çınar oy farkı ambar tüketimini değiştirmedi")

		# 6. Ek şart: Zindan ekmek payı denge formülünü değiştirmez; ölçüm mevcut gece raporunu okur
		dene(olcum.get("zindan_ekmek_payi") == 2, "Zindan ekmek payı raporda yer alır")

		# 7. Ek şart: Ölçüm raporunda her sorgu eyleminin kullanım sayısı bir satırdır; gece formülü değişmez
		dene(olcum.has("sorgu_eylemleri"), "Sorgu eylemleri raporda bir satırdır")
		var eylemler: Dictionary = olcum["sorgu_eylemleri"]
		dene(eylemler.get("soru") == 4 and eylemler.get("heybe") == 1, "Sorgu eylemi sayıları doğru kaydedildi")

		# 8. Ek şart: Aç kişi oranı gece ölçümüne bir satır eklenir; denge hesabı ikinci kez çalışmaz
		dene(olcum.has("ac_kisi_orani"), "Aç kişi oranı ölçüme satır olarak eklendi")
		dene(olcum.get("ac_kisi_orani") >= 0.0, "Aç kişi oranı geçerli bir değer")
	else:
		push_error("Katalog yüklenemedi")
		_hata += 1

	print("DENGE OLCUMU TEST: %s (%d hata)" % ["GEÇTİ" if _hata == 0 else "KALDI", _hata])
	quit(_hata)
