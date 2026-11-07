## OMR-05: Üç dalgada gerçek gece, haber ve mevcut talep işlemleri.
extends SceneTree

const KAPI = preload("res://src/sistemler/dis_hat_kapisi.gd")
var _hata := 0

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()
	var o := Oturum.new(kat, 305)
	var y := o.yonetim
	y.a = y.a.duplicate(true)
	y.a.harac_araligi = 4
	y.agalik = true
	y.set_meta(&"perde2_baslangic", 15)
	var ev := KoyBinasi.new()
	ev.id = 1
	ev.tur = "kulube"
	y.binalar.append(ev)
	y.kaynaklar.stok.gida = 80
	y.kaynaklar.stok.bugday = 60
	y.akce = 80
	o.gun = 15
	_dene(not ObaIttifaki.uygun(o, "alp"), "Birinci dalgada oba talebi açılmaz")
	var ilk: Array = ZamanMakinesi.ilerlet(o, 1, 305).gece.rapor.olaylar
	_dene(_hatlar(ilk).size() == 4 and _hatlar(ilk).has("tekfur"), "Birinci dalgada dört hat ve Tekfur haberi")
	_dene(not y.harac_bekliyor and not _anahtar_var(ilk, "koy.olay.harac"), "Birinci dalgada takvim denk gelse de Tekfur talebi sıfır")
	_dene(HaberciAgi.oku(o.haberci_agi).bekleyen.any(func(h: Dictionary) -> bool: return h.kaynak == "tekfur"), "Tekfur haberi mevcut haberci kuyruğunda")
	o.gun = 19
	_dene(ObaIttifaki.uygun(o, "alp") and ObaIttifaki.takas(o, "alp").ok, "İkinci dalgada gerçek oba anlaşması")
	var ikinci: Array = ZamanMakinesi.ilerlet(o, 1, 305).gece.rapor.olaylar
	_dene(y.harac_bekliyor and _anahtar_var(ikinci, "koy.olay.harac"), "İkinci dalgada mevcut Tekfur takvimi talep açar")
	_dene(int(SancakAskerTalebi.oku(o.sancak_asker_talebi).gun) == 20, "Sekiz artı on iki gecede ferman açılır")
	_dene(not _anahtar_var(ikinci, "koy.olay.tekfur_baskini"), "İkinci dalga baskın sonucu üretmez")
	_dene(TekfurHaracHeyeti.ode(y), "Mevcut haraç ödemesi işlenebilir")
	o.gun = 23
	var ucuncu: Array = ZamanMakinesi.ilerlet(o, 1, 305).gece.rapor.olaylar
	_dene(_hatlar(ucuncu).size() == 4 and _anahtar_var(ucuncu, "koy.olay.dis_hat.oba.ittifak"), "Üçüncü dalga gerçek ittifak sonucunu bildirir")
	_dene(not y.harac_bekliyor and not ObaIttifaki.uygun(o, "alp") and not _anahtar_var(ucuncu, "koy.olay.harac"), "Üçüncü dalga yeni talepleri açmaz")
	var tekrar: Array = ZamanMakinesi.ilerlet(o, 1, 305).gece.rapor.olaylar
	_dene(_hatlar(tekrar).is_empty(), "Sonuç bir kez yazılır")
	var mogol := Oturum.new(kat, 306)
	mogol.yonetim.agalik = true
	mogol.yonetim.set_meta(&"perde2_baslangic", 21)
	mogol.gun = 24
	var mogol_haberi: Array = ZamanMakinesi.ilerlet(mogol, 1, 306).gece.rapor.olaylar
	_dene(_anahtar_var(mogol_haberi, "koy.olay.mogol_oncusu"), "Moğol uyarısı birinci dalgada kendi takviminde")
	var kuyruk: Array[Gelen] = []
	DiplomatikHeyet.ekle(mogol, kuyruk)
	_dene(kuyruk.any(func(g: Gelen) -> bool: return DiplomatikHeyet.bilet(g).get("tur") == "mogol"), "Mevcut Moğol heyeti ikinci dalgada açılır")
	mogol.gun = 29
	var mogol_sonucu: Array = ZamanMakinesi.ilerlet(mogol, 1, 306).gece.rapor.olaylar
	_dene(_anahtar_var(mogol_sonucu, "koy.olay.mogol_oncusu") and not _anahtar_var(mogol_sonucu, "koy.olay.dis_hat.mogol.sinirda"), "Takvimli varış üçüncü dalgada tek satır")
	print("DIŞ HAT DALGALARI: %s" % ("GEÇTİ" if _hata == 0 else "KALDI"))
	quit(0 if _hata == 0 else 1)

func _hatlar(olaylar: Array) -> Array:
	return olaylar.filter(func(e: Dictionary) -> bool: return e.has("dis_hat_haberi")).map(func(e: Dictionary) -> String: return e.dis_hat_haberi)

func _anahtar_var(olaylar: Array, anahtar: String) -> bool:
	return olaylar.any(func(e: Dictionary) -> bool: return e.get("anahtar") == anahtar)

func _dene(kosul: bool, mesaj: String) -> void:
	if kosul: return
	_hata += 1
	push_error(mesaj)
