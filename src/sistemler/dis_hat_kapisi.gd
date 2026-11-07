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
