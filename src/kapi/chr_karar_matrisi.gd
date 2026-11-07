## KOP-10: Adlı CHR ziyaretinde karar etkisi ve görünür düğmeler karar_matrisi satırından gelir.
## Adsız figürlerde sınıf şablonu (diyalog_01_20.json / sablon) ve ±1 titremesi korunur.
## Rüşvet akçesi kişisel kasada (muhafiz_akce) kalır; kamu kasasına ikinci kez yazılmaz.
class_name ChrKararMatrisi
extends RefCounted


## Oturum karar anahtarını (`kabul`, `harc`, `ret`, `elkoy`, `rusvet`, `kisla`)
## CHR `karar_matrisi` içindeki satır kimliğine (`kabul`, `gonullu_ret`, `zorunlu_ret`, `rusvet`, `kisla`) eşler.
static func matris_anahtari(sorgu: RefCounted, karar: StringName) -> StringName:
	var k := String(karar)
	if k == "harc" or k == "kabul":
		return &"kabul"
	if k == "ret" or k == "elkoy":
		if sorgu != null and bool(sorgu.bayraklar.get("Flag_Kilitlendi", false)):
			return &"zorunlu_ret"
		return &"gonullu_ret"
	if k == "zorunlu_ret":
		return &"zorunlu_ret"
	if k == "gonullu_ret":
		return &"gonullu_ret"
	if k == "rusvet":
		return &"rusvet"
	if k == "kisla":
		return &"kisla"
	return karar


## Karar düğmesi karakterin `karar_matrisi` içinde tanımlı mı?
## Matriste olmayan bir karar düğmesi kapıda görünmez.
static func matriste_var_mi(sorgu: RefCounted, karar: StringName) -> bool:
	if sorgu == null or sorgu.karakter == null:
		return true
	var matris: Dictionary = sorgu.karakter.karar_matrisi
	if matris.is_empty():
		return true
	var k := String(karar)
	if k == "kabul" or k == "harc":
		return matris.get("kabul") is Dictionary
	if k == "ret" or k == "elkoy":
		if bool(sorgu.bayraklar.get("Flag_Kilitlendi", false)):
			return matris.get("zorunlu_ret") is Dictionary or matris.get("ret") is Dictionary
		return matris.get("gonullu_ret") is Dictionary or matris.get("zorunlu_ret") is Dictionary or matris.get("ret") is Dictionary
	return matris.get(k) is Dictionary


## Kapıda gösterilecek karar listesini `karar_matrisi` içinde tanımlı olanlarla süzer.
static func gorunen_secenekler(sorgu: RefCounted, secenekler: PackedStringArray) -> PackedStringArray:
	if sorgu == null or sorgu.karakter == null:
		return secenekler
	var sonuc := PackedStringArray()
	for s in secenekler:
		if matriste_var_mi(sorgu, StringName(s)):
			sonuc.append(s)
	return sonuc


## Verilen karar ve sorgu bayrakları (`Flag_Sir_Tamamen_Cozuldu` vb.) için
## seçilen varyantın veya düz satırın `-4…+4` aralığına sıkıştırılmış 5 stat etkisini döner.
static func secilen_stat_etkisi(sorgu: RefCounted, karar: StringName) -> Dictionary:
	if sorgu == null or sorgu.karakter == null:
		return {}
	var m_karar := matris_anahtari(sorgu, karar)
	var veri: Dictionary = sorgu.karakter.karar_verisi(m_karar)
	if veri.is_empty() and (karar == &"ret" or karar == &"elkoy"):
		veri = sorgu.karakter.karar_verisi(&"ret")
	var varyantlar: Array = veri.get("varyantlar", [])
	for v in varyantlar:
		if not v is Dictionary:
			continue
		var kosullar: Variant = v.get("kosullar", {})
		if kosullar is Dictionary and not kosullar.is_empty():
			if _kosullar_tutar_mi(sorgu.bayraklar, kosullar):
				return preload("res://src/sistemler/chr_runtime_sinirlari.gd").statlar(v.get("stat_etkisi", {}))
	return preload("res://src/sistemler/chr_runtime_sinirlari.gd").statlar(veri.get("stat_etkisi", {}))


static func _kosullar_tutar_mi(bayraklar: Dictionary, kosullar: Dictionary) -> bool:
	for k in kosullar:
		if bool(bayraklar.get(String(k), false)) != bool(kosullar[k]):
			return false
	return true


## Adlı CHR ziyaretinde `karar_matrisi` stat etkisini köy durumuna bir kez uygular.
## Sınıf şablonu (`_bar_uygula`) bu ziyarette çalıştırılmaz.
static func uygula(oturum: Oturum, sorgu: RefCounted, karar: StringName) -> Dictionary:
	var statlar := secilen_stat_etkisi(sorgu, karar)
	if oturum == null or oturum.yonetim == null:
		return statlar
	var y := oturum.yonetim
	if statlar.has("Erzak"):
		var delta_erzak := int(statlar["Erzak"])
		if delta_erzak > 0:
			y.kaynaklar.ekle("gida", delta_erzak)
		elif delta_erzak < 0:
			y.kaynaklar.azalt("gida", absi(delta_erzak))
	if statlar.has("Guvenlik"):
		var delta_guv := int(statlar["Guvenlik"])
		y.asayis_riski = clampi(y.asayis_riski - delta_guv, 0, 100)
	if statlar.has("Refah"):
		var delta_refah := int(statlar["Refah"])
		if delta_refah != 0:
			EkonomikRefah.degistir(y, delta_refah)
	if statlar.has("Moral"):
		var delta_moral := int(statlar["Moral"])
		if delta_moral != 0:
			for k in y.koylular:
				k.moral = clampi(k.moral + delta_moral, 0, 100)
	if statlar.has("Saglik"):
		var delta_saglik := int(statlar["Saglik"])
		if delta_saglik != 0:
			for k in y.koylular:
				k.saglik = clampi(k.saglik + delta_saglik, 0, 100)
	return statlar
