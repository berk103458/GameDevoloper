## OMR-05: Dış hatların Perde 2 zaman kapısı. Yeni sayaç veya karar durumu tutmaz.
extends RefCounted

const PERDE = preload("res://src/koy/perde_gecisi.gd")
const HABER := 1
const TALEP := 2
const SONUC := 3

static func dalga(y: KoyYonetimi, ofset: int = 0) -> int:
	if not y.agalik or PERDE.baslangic(y) < 0: return 0
	return Omurga.dalga(PERDE.gece(y) + ofset, y.perde2_hedef)

static func izin(y: KoyYonetimi, evre: int, ofset: int = 0) -> bool:
	var sira := dalga(y, ofset)
	return sira == 0 or sira == evre

static func rapora_ekle(o: Oturum, r: Dictionary) -> void:
	var y := o.yonetim
	var tamamlanan := PERDE.gece(y)
	if not y.agalik or tamamlanan < 1: return
	if tamamlanan == 1:
		for hat in ["mogol", "tekfur", "oba", "sancak"]:
			_ekle(r, hat, "haber")
	elif dalga(y, -1) == SONUC and dalga(y, -2) != SONUC:
		var ferman := SancakAskerTalebi.oku(o.sancak_asker_talebi)
		_ekle(r, "mogol", "sinirda" if MogolOncusu.durum(o).sinirda else "uzakta")
		_ekle(r, "tekfur", "baski" if y.tekfur_baski > 0 else "baski_yok")
		_ekle(r, "oba", "ittifak" if ObaIttifaki.muttefik(o) else "ittifak_yok")
		var sancak := "bekliyor" if ferman.bekliyor else ("gonderildi" if not ferman.gonderilen.is_empty() else "gonderilmedi")
		_ekle(r, "sancak", sancak)

static func _ekle(r: Dictionary, hat: String, durum: String) -> void:
	if hat == "mogol" and r.olaylar.any(func(e: Dictionary) -> bool: return e.has("mogol_oncusu")): return
	r.olaylar.append({"anahtar": "koy.olay.dis_hat.%s.%s" % [hat, durum], "dis_hat_haberi": hat})

## OMR-39: Sahte haber hat kapatmaz. Omurga yalnız `haberci_agi` kaynaklı doğrulanmış haberi okur; DIY-13 dedikodu bayrağı dış hat kapısını tetiklemez veya kapatmaz.
static func dogrulanmis_haber_var_mi(o: Oturum, hat: String) -> bool:
	if o == null or not (o.haberci_agi is Dictionary): return false
	var bekleyen: Variant = o.haberci_agi.get("bekleyen", [])
	if bekleyen is Array:
		for kayit in bekleyen:
			if kayit is Dictionary and String(kayit.get("hat", kayit.get("kaynak", ""))) == hat:
				return true
	var kaynaklar: Variant = o.haberci_agi.get("kaynaklar", {})
	if kaynaklar is Dictionary and kaynaklar.has(hat):
		return bool(kaynaklar[hat])
	return false

## OMR-19: Moğol hattı üç adımdır: duman (dalga 1), haber (dalga 2), öncü (dalga 3). Adım atlanırsa sonraki tetiklenmez.
static func mogol_adim_izin(o: Oturum, adim: int) -> bool:
	if o == null or o.yonetim == null or not o.yonetim.agalik: return false
	var sira := dalga(o.yonetim)
	if adim == 1:
		return sira == HABER
	if adim == 2:
		return sira == TALEP and bool(o.bayraklar.get("mogol_duman", false))
	if adim == 3:
		return sira == SONUC and bool(o.bayraklar.get("mogol_duman", false)) and bool(o.bayraklar.get("nogay_haber", false))
	return false

static func mogol_adim_tamamla(o: Oturum, adim: int) -> bool:
	if not mogol_adim_izin(o, adim): return false
	if adim == 1:
		o.bayraklar["mogol_duman"] = true
	elif adim == 2:
		o.bayraklar["nogay_haber"] = true
	elif adim == 3:
		o.bayraklar["mogol_oncusu"] = true
	return true

## OMR-20: Tekfur hattı: elçi (dalga 1), haraç (dalga 2), heyet (dalga 3). Elçi gelmeden haraç talebi 0.
static func tekfur_elci_geldi_mi(o: Oturum) -> bool:
	return o != null and bool(o.bayraklar.get("tekfur_elcisi_geldi", false))

static func tekfur_harac_izin(o: Oturum) -> bool:
	if o == null or o.yonetim == null or not o.yonetim.agalik: return false
	return dalga(o.yonetim) == TALEP and tekfur_elci_geldi_mi(o)

static func tekfur_heyet_izin(o: Oturum) -> bool:
	if o == null or o.yonetim == null or not o.yonetim.agalik: return false
	return dalga(o.yonetim) == SONUC and tekfur_elci_geldi_mi(o) and bool(o.bayraklar.get("tekfur_harac_istendi", false))

static func tekfur_adim_tamamla(o: Oturum, adim: int) -> bool:
	if o == null or o.yonetim == null or not o.yonetim.agalik: return false
	if adim == 1 and dalga(o.yonetim) == HABER:
		o.bayraklar["tekfur_elcisi_geldi"] = true
		return true
	if adim == 2 and tekfur_harac_izin(o):
		o.bayraklar["tekfur_harac_istendi"] = true
		return true
	if adim == 3 and tekfur_heyet_izin(o):
		o.bayraklar["tekfur_heyeti_geldi"] = true
		return true
	return false

## OMR-23: Ahi hattı: tezgâhtan kasabaya. TEZ teslim sayısı >= 1 değilse dalga 2'de ahi gelmez.
static func tez_teslim_sayisi(y: KoyYonetimi) -> int:
	if y == null: return 0
	var isler := TezgahtaGun.isler(y)
	var toplam := 0
	for anahtar in isler:
		var kayit: Variant = isler[anahtar]
		if kayit is Dictionary:
			toplam += maxi(0, int((kayit as Dictionary).get("teslim", 0)))
	return toplam

static func ahi_gelebilir_mi(o: Oturum) -> bool:
	if o == null or o.yonetim == null or not o.yonetim.agalik: return false
	if dalga(o.yonetim) != TALEP: return false
	return tez_teslim_sayisi(o.yonetim) >= 1

## OMR-24: Bir gecede en çok bir dış hat yüzü gelir; öncelik `data/omurga.json` sırasıyladır. Model kapıda kalır.
static func gece_yuzu_sec(aday_hatlar: Array) -> Array[String]:
	var oncelik: Array = Omurga.hat_onceligi()
	for hat in oncelik:
		var h := String(hat)
		if aday_hatlar.has(h):
			return [h]
	for hat in aday_hatlar:
		var h := String(hat)
		if not h.is_empty():
			return [h]
	return []

static func yuz_konumu(_hat: String) -> String:
	return "kapi"

## OMR-25 & OMR-29: Üç karar ve tutulmayan sözler dış hatları bayrakla kapatır/büker (yeni sayaç yok).
static func karar_uygula(o: Oturum, karar: String) -> String:
	if o == null: return ""
	match karar:
		"tekfur_elci_red":
			o.bayraklar["turkmen_husumet"] = true
			o.bayraklar["soz_tekfur_tutuldu"] = false
			o.bayraklar["hat_tekfur_kapali"] = true
			if o.yonetim != null:
				o.yonetim.tekfur_baski += 1
			return "turkmen_husumet"
		"mogol_oncu_kabul":
			o.bayraklar["rusvet_esik"] = true
			o.bayraklar["mogol_haracci_yolu"] = true
			return "rusvet_esik"
		"ulak_aldat":
			o.bayraklar["miraen_asayis"] = true
			o.bayraklar["soz_sancak_tutuldu"] = false
			o.bayraklar["hat_sancak_kapali"] = true
			return "miraen_asayis"
	return ""

static func soz_kontrol_et(o: Oturum, hat: String, tutuldu: bool) -> String:
	if o == null: return ""
	var kosullar: Dictionary = Omurga.veri().get("hat_kosullari", {})
	var bayrak := String(kosullar.get(hat, "soz_%s_tutuldu" % hat))
	o.bayraklar[bayrak] = tutuldu
	if not tutuldu:
		o.bayraklar["hat_%s_kapali" % hat] = true
	return bayrak

static func hat_kapali_mi(o: Oturum, hat: String) -> bool:
	if o == null: return false
	if bool(o.bayraklar.get("hat_%s_kapali" % hat, false)):
		return true
	var kosullar: Dictionary = Omurga.veri().get("hat_kosullari", {})
	var soz_bayrak := String(kosullar.get(hat, ""))
	if not soz_bayrak.is_empty() and o.bayraklar.has(soz_bayrak) and not bool(o.bayraklar[soz_bayrak]):
		return true
	return false

## OMR-32: Perde 2'nin her dalgasında en az bir dış hat yüzü gelir; hiçbiri uygun değilse ulak gelir.
static func dalga_yuzu_sec(o: Oturum, _dalga_no: int, uygun_hatlar: Array = []) -> String:
	var acik_adaylar: Array[String] = []
	for hat in uygun_hatlar:
		var h := String(hat)
		if not hat_kapali_mi(o, h):
			acik_adaylar.append(h)
	var secilen := gece_yuzu_sec(acik_adaylar)
	var esleme: Dictionary = Omurga.yuz_eslemesi()
	if not secilen.is_empty():
		var h := secilen[0]
		return String(esleme.get(h, h))
	return String(esleme.get("sancak", "sancak_cavusu"))

static func uc_dalga_yuzleri(o: Oturum, dalga_adaylari: Array = [[], [], []]) -> Array[String]:
	var sonuc: Array[String] = []
	for i in 3:
		var adaylar: Array = dalga_adaylari[i] if i < dalga_adaylari.size() and dalga_adaylari[i] is Array else []
		sonuc.append(dalga_yuzu_sec(o, i + 1, adaylar))
	return sonuc

## OMR-36 & OMR-37: Haber dış hat yüzünden 1-2 gece önce düşer; ziyaretçi ağzından duyulduysa yazılı satır 0.
static func insandan_duyuldu_mu(o: Oturum, hat: String) -> bool:
	if o == null: return false
	if bool(o.bayraklar.get("sozluk_haber_%s" % hat, false)) or bool(o.bayraklar.get("insandan_haber_%s" % hat, false)):
		return true
	return false

static func oncu_haber_gecesi(yuz_gecesi: int, ofset: int = 1) -> int:
	return yuz_gecesi - clampi(ofset, 1, 2)

static func oncu_haber_planla(o: Oturum, hat: String, yuz_gecesi: int, ofset: int = 1) -> Dictionary:
	var haber_gecesi := oncu_haber_gecesi(yuz_gecesi, ofset)
	if insandan_duyuldu_mu(o, hat):
		return {"hat": hat, "yuz_gecesi": yuz_gecesi, "haber_gecesi": haber_gecesi, "yazili_satir": 0}
	var d := HaberciAgi.oku(o.haberci_agi if o != null else {})
	var kaynaklar: Dictionary = HaberciAgi.AYAR.get("kaynaklar", {})
	if kaynaklar.has(hat) and haber_gecesi >= 1:
		var anahtar := "koy.olay.dis_hat.%s.haber" % hat
		var metin := TranslationServer.translate(anahtar)
		if metin.is_empty():
			metin = anahtar
		HaberciAgi._ekle(d.bekleyen, {"kaynak": hat, "gun": haber_gecesi, "metin": metin})
		if int(d.ilk_haber_gunu) < 0 or haber_gecesi < int(d.ilk_haber_gunu):
			d.ilk_haber_gunu = haber_gecesi
		if int(d.son_gece) < haber_gecesi:
			d.son_gece = haber_gecesi
		if o != null:
			o.haberci_agi = d
		return {"hat": hat, "yuz_gecesi": yuz_gecesi, "haber_gecesi": haber_gecesi, "yazili_satir": 1}
	return {"hat": hat, "yuz_gecesi": yuz_gecesi, "haber_gecesi": haber_gecesi, "yazili_satir": 0}

## OMR-49: Muhafızın geçmişi hat yüzlerinin ilk cümlesini değiştirir (5 yüz x 4 geçmiş).
static func hat_selami(hat_veya_yuz: String, gecmis_id: String) -> String:
	var yol := "res://data/soz/hat_selamlari.json"
	if not FileAccess.file_exists(yol): return ""
	var veri: Variant = JSON.parse_string(FileAccess.get_file_as_string(yol))
	if not (veri is Dictionary): return ""
	var dict: Dictionary = veri
	var hat := hat_veya_yuz.to_lower()
	if not dict.has(hat):
		for h in dict.keys():
			var eslesme := String(Omurga.yuz_eslemesi().get(h, ""))
			if eslesme == hat:
				hat = h
				break
	if not dict.has(hat): return ""
	var selamlari: Dictionary = dict[hat]
	return String(selamlari.get(gecmis_id, selamlari.get("eski_levent", "")))

## OMR-50: Oyun tohumu (RNG) hat yüzlerinin geliş gecesini dalga içinde kaydırır; dalga dışına çıkaramaz.
static func tohumlu_yuz_gecesi(tohum: int, dalga_no: int, hedef_gece: int = 12) -> int:
	var sinirlar := Omurga.dalga_sinirlari(hedef_gece)
	var baslangic := 0
	var bitis := int(sinirlar.dalga_1_bitis) - 1
	if dalga_no == 2:
		baslangic = int(sinirlar.dalga_1_bitis)
		bitis = int(sinirlar.dalga_2_bitis) - 1
	elif dalga_no == 3:
		baslangic = int(sinirlar.dalga_2_bitis)
		bitis = int(sinirlar.hedef_gece) - 1
	var aralik: int = maxi(1, bitis - baslangic + 1)
	var rng: int = int((abs(tohum) * 1103515245 + 12345 + dalga_no * 31) & 0x7fffffff)
	var ofset: int = rng % aralik
	return baslangic + ofset


