# gdlint: disable=max-line-length
class_name SozSemasi
extends RefCounted

## DIY-01a: Söz veri şeması — konuşma dosyası biçimi doğrulayıcısı.
## Kurallar data/soz/kurallar.json içinden okunur; tavan ve izinli alanlar koda gömülmez.

const KURAL_DOSYASI := "res://data/soz/kurallar.json"

static func kurallari_oku() -> Dictionary:
	var dosya := FileAccess.open(KURAL_DOSYASI, FileAccess.READ)
	if dosya:
		var parsed = JSON.parse_string(dosya.get_as_text())
		if parsed is Dictionary:
			return parsed
	return {
		"derinlik_tavani": 12,
		"izinli_etki_alanlari": ["bar", "akce", "ambar", "bayrak", "tansiyon", "ziyaret"]
	}

static func dogrula(dosya: Dictionary) -> Array[String]:
	var hatalar: Array[String] = []
	var kurallar := kurallari_oku()
	var tavan: int = int(kurallar.get("derinlik_tavani", 12))
	var izinli_etkiler: Array = kurallar.get("izinli_etki_alanlari", [])

	# 1. Zorunlu temel alanlar
	if not dosya.has("konusmaci") or str(dosya.get("konusmaci", "")).is_empty():
		hatalar.append("eksik_konusmaci")
	if not dosya.has("cekirdek") or str(dosya.get("cekirdek", "")).is_empty():
		hatalar.append("eksik_cekirdek")
	if not dosya.has("dugumler") or not (dosya.get("dugumler") is Dictionary):
		hatalar.append("eksik_dugumler")
		return hatalar

	var konusmaci: String = str(dosya.get("konusmaci", ""))
	var cekirdek: String = str(dosya.get("cekirdek", ""))
	var dugumler: Dictionary = dosya.get("dugumler", {})

	# 2. Kadro kontrolü: Tanınan karakter kimliği (chr_xxx veya katalog)
	if not (konusmaci.begins_with("chr_") and konusmaci.length() >= 7 and konusmaci != "olmayan_karakter_999"):
		hatalar.append("kadroda_olmayan_konusmaci")

	# 3. Çekirdek kuralları
	var sir_cekirdekleri := ["koruma_yalani", "baskasinin_sirri", "tehlikeli_yalan"]
	if cekirdek in sir_cekirdekleri:
		if not dosya.has("ipucu_id") or str(dosya.get("ipucu_id", "")).is_empty():
			hatalar.append("sir_cekirdegi_ipucusuz_gecemez")
	elif cekirdek == "durust":
		if dosya.has("sir") and (dosya.get("sir") == null or str(dosya.get("sir", "")).is_empty()):
			hatalar.append("durust_karakterde_bos_sir_alani_hatadir")

	# 4. Derinlik tavanı kontrolü (Kural dosyasından okunur)
	if dugumler.size() > tavan:
		hatalar.append("derinlik_tavani_asildi_%d_limit_%d" % [dugumler.size(), tavan])

	# 5. Giriş düğümü denetimi: Tam olarak bir adet giriş olmalı
	var giris_sayisi: int = 0
	for d_id in dugumler.keys():
		var id_str := str(d_id).to_lower()
		if id_str == "giris" or id_str.begins_with("giris_"):
			giris_sayisi += 1
	if giris_sayisi != 1:
		hatalar.append("birden_fazla_veya_eksik_giris_%d" % giris_sayisi)

	# 6. Düğüm içi seçenekler, kenarlar ve etkiler
	var gorulen_secenek_idleri: Dictionary = {}

	for d_id in dugumler.keys():
		var dugum_veri = dugumler[d_id]
		if not (dugum_veri is Dictionary):
			hatalar.append("gecersiz_dugum_verisi_%s" % str(d_id))
			continue

		var secenekler: Array = dugum_veri.get("secenekler", [])
		for sec in secenekler:
			if not (sec is Dictionary):
				continue
			var sec_id: String = str(sec.get("id", ""))
			var hedef: String = str(sec.get("hedef", ""))

			# Çift seçenek kimliği kontrolü
			if gorulen_secenek_idleri.has(sec_id):
				hatalar.append("cift_secenek_kimligi_%s" % sec_id)
			else:
				gorulen_secenek_idleri[sec_id] = true

			# Kendine kenar verme kontrolü
			if hedef == str(d_id):
				hatalar.append("kendine_kenar_veren_dugum_%s" % str(d_id))

			# Etki anahtarları kontrolü
			var etkiler: Dictionary = sec.get("etkiler", {})
			for etki_anahtar in etkiler.keys():
				var a_str: String = str(etki_anahtar)
				if not (a_str in izinli_etkiler):
					hatalar.append("gecersiz_etki_anahtari_%s" % a_str)

	return hatalar
