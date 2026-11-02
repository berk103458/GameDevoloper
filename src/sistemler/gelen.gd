## Kapıya gelen bir kişi (adlı karakter ya da figür örneği) — bir ziyaretin verisi.
class_name Gelen
extends RefCounted

var aile: Array[Dictionary] = []
var aile_id: String = ""

var adli: bool = false
## KAP adaptörü: yalnız CHR kaynağı olan adlı ziyaretçiye eklenir.
var _chr_sorgusu: RefCounted
var _chr_kontrol_edildi := false

func chr_sorgusu() -> RefCounted:
	if not _chr_kontrol_edildi:
		_chr_kontrol_edildi = true
		var yol := "res://data/chr_runtime/%s.tres" % String(id).to_upper()
		if adli and String(id).begins_with("chr_") and ResourceLoader.exists(yol):
			var kaynak := load(yol) as KarakterVerisi
			if kaynak != null and kaynak.dogrula():
				_chr_sorgusu = preload("res://src/sistemler/chr_sorgusu.gd").new(kaynak)
	return _chr_sorgusu
## Adlı karakterin kimliği; figürde boş.
var id: StringName = &""
var ad_anahtari: String = ""
var sinif: StringName = &"ciftci"
## Portre kökü (`char_<portre>_neutral_card.png`).
var portre: String = ""
var giris_anahtari: String = ""
## [soru_anahtari, cevap_anahtari] çiftleri.
var sorular: Array[PackedStringArray] = []
## Her sorunun üst sorusunun `sorular` içindeki indeksi; -1 = kök. Üst sorulunca takip açılır.
var soru_ust: PackedInt32Array = PackedInt32Array()
## Açılış sözü: kapıya varınca kendini ve hikâyesini anlatır (anahtar ya da düz metin).
var acilis: String = ""
var secenekler: PackedStringArray = []
## Karar -> bar etkisi.
var etkiler: Dictionary = {}
## Gemini diyalogunda kararın ziyaretçiye ait cevabı.
var yanitlar: Dictionary = {}
## Bu kadar soru sorulunca karar düğmesi açılır. Boşsa hepsi açık.
var esikler: PackedInt32Array = PackedInt32Array()
## Heybesi: söylediği ve astarda sakladığı (Oturum.heybe_uret).
var heybe: Heybe
## Bu gelene sorulabilecek en çok soru; 0 = genel ayar.
var azami_soru: int = 0
## Kötü niyetli mi: retteki tepki öfke, değilse yıkılma (panik).
var tehlikeli: bool = false
## Zanaat yeteneği 1–10 (köyde üretim formülü).
var stat: int = 5
## Sorgu ağacında soru → bayrak: o soru sorulup cevabı alınınca açılan gerçek (`soru_bayraklari[i]`, boş = yok;
## birden çok bayrak virgülle ayrılır).
var soru_bayraklari: PackedStringArray = []
## Kapıda açılmayan gerçekler köye gizli taşınır (casus, hırsız, hasta …).
var gizli_bayraklar: PackedStringArray = []
## Kapıda sorguyla açılan bayraklar (KapiEkrani doldurur).
var acik_bayraklar: PackedStringArray = []


## Yoksul değil mi: heybesinde söylediği akçe zenginlik eşiğinde ya da üstünde.
func zengin(esik: int) -> bool:
	return heybe != null and heybe.beyan_akce() >= esik


## Kusurlu mu: kötü niyetli, yalanı yakalanmış ya da sorguda suçlu bir bayrağı açılmış. Böyle birinin reddi
## gerekçeli sayılır (husumet +1), değilse haksızdır (+3).
func kusurlu() -> bool:
	if tehlikeli or (chr_sorgusu() == null and heybe != null and heybe.yalan_var()):
		return true
	for b in acik_bayraklar:
		if b in ["casus_suphesi", "hirsiz", "hasta", "sabotajci"]:
			return true
	return false


## i. soru sorulunca açılan bayrağı kaydeder (koşullu kilit: yalnız o dal sorulursa).
func soru_soruldu(i: int) -> void:
	if i < soru_bayraklari.size() and soru_bayraklari[i] != "":
		for b in soru_bayraklari[i].split(",", false):
			if not b in acik_bayraklar:
				acik_bayraklar.append(b)


## Sorulabilecek soru sınırı: gelenin kendi sınırı, yoksa genel ayar.
func soru_siniri(genel: int) -> int:
	return azami_soru if azami_soru > 0 else genel
