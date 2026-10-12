## ACL-05: barınak (yatak) kapasitesi kabul sınırı.
## Yatak sayısı koda gömülmez; `KoyYonetimi.yatak_kapasitesi()` üzerinden bina verisinden okunur.
## Bu dosya akçe yazmaz ve ikinci bir uyku/barınma hesabı açmaz; yalnız açıkta kalan kişiyi gösterir.
extends RefCounted

const SATIR := "arayuz.kapi.yatak_satiri"
const UYARI := "arayuz.kapi.yatak_uyari"


## Hazır barınma yapılarındaki toplam yatak (bina verisinden; .gd sabiti yok).
static func toplam(y: KoyYonetimi) -> int:
	return y.yatak_kapasitesi()


## Yatağı olan kişi sayısı; muhafız ve eş de birer kişidir (kendi evlerinde sayılır).
static func dolu(y: KoyYonetimi) -> int:
	var n := 0
	for k in y.koylular:
		if k.ev >= 0:
			n += 1
	return n


## Açıkta kalan kişi sayısı (yatağı olmayan). Zindandaki kişi açıkta sayılmaz.
static func acikta(y: KoyYonetimi) -> int:
	var n := 0
	for k in y.koylular:
		if k.ev < 0 and not DivanHukmu.zindanda(k):
			n += 1
	return n


## Gelen kişi(ler) için boş yatak var mı. `kisi` en az 1'dir (aile boyu KAP-17'de buraya gelir).
static func yeter_mi(y: KoyYonetimi, kisi: int = 1) -> bool:
	return toplam(y) - dolu(y) >= maxi(1, kisi)


## "Yatak: dolu/toplam" satırı; oyuncunun gördüğü metin CSV anahtarından gelir.
static func satir(y: KoyYonetimi) -> String:
	return TranslationServer.translate(SATIR) % [dolu(y), toplam(y)]


## Karar panelinin barınak satırı: yatak yetmezse altına uyarı eklenir; kabul düğmesi kapanmaz.
static func metin(y: KoyYonetimi, kisi: int = 1) -> String:
	if yeter_mi(y, kisi):
		return satir(y)
	return "%s\n%s" % [satir(y), TranslationServer.translate(UYARI)]
