## Köyde yaşayan bir kişi (design/gdd/koy-yonetimi.md, 1, 8, 11).
## Bayraklar kapıdaki sorguda açığa çıkanlardır; `gizli_bayraklar` bilinmeyen gerçeklerdir (casus, hasta …),
## köyde olay olarak ortaya çıkar ya da köy içi sorguyla açılır.
class_name Koylu
extends RefCounted

var id: int = 0
## Ad metni ya da çeviri anahtarı.
var ad: String = ""
## Adlı karakterse kimliği (`chr_007`); figürse boş.
var adli_id: StringName = &""
## `ciftci`, `esnaf`, `asker`.
var sinif: StringName = &"ciftci"
var portre: String = ""
## Zanaat yeteneği 1–10 (formül F4).
var stat: int = 5
## UZM-01: birincil meslek; `stat` beceri, `sinif` eski grup olarak kalır.
var zanaat_turu: int = ZanaatTuru.Tur.BELIRSIZ
var pasif_ozellikler: Dictionary = PasifOzellikler.cift(&"", &"ciftci")
var egitim: Dictionary = {}
var gelisim: Dictionary = {}
var grev: Dictionary = {}
var yorgunluk: Dictionary = {}
var is_kazasi: Dictionary = {}
var zanaat_kazasi: Dictionary = {}
var kis_hastaligi: Dictionary = {}
var enfeksiyon: Dictionary = {}
var toplumsal_bag: Dictionary = {"grup": "", "dusman_gruplar": []}
var yas_grubu: StringName = &"yetiskin"
var gizli_egilim: Dictionary = {"tur": "yok", "calinan": 0, "son_gece": 0, "yakalanma": false}
## Açık bayraklar: `usta_ciftci`, `somurulmus`, `tembel` …
var bayraklar: PackedStringArray = []
var gizli_bayraklar: PackedStringArray = []
## Kamu kasasından ayrı ekonomik yaşam standardı (0–100).
var refah: int = EkonomikRefah.baslangic()
var moral: int = 60
var saglik: int = 100
var sadakat: int = 60
## Çalıştığı yapının kimliği (-1 = boşta); `muhafiz` görevindeyse -2.
var is_yeri: int = -1
## Kışın donan yapıdan kaydırıldıysa eski iş yeri; baharda geri döner (-1 = yok).
var kis_oncesi_is: int = -1
## Kaldığı barınağın kimliği (-1 = evsiz).
var ev: int = -1
## Dün aç kaldı mı (bugünkü verim düşer).
var ac: bool = false
## Kabul edildiği gün.
var giris_gunu: int = 0


func bayrak_var(b: String) -> bool:
	return b in bayraklar


func bayrak_ekle(b: String) -> void:
	if not bayrak_var(b):
		bayraklar.append(b)


## Gizli bir gerçeği açığa çıkarır (gizliyse taşır, değilse ekler).
func bayrak_ac(b: String) -> void:
	var i := gizli_bayraklar.find(b)
	if i >= 0:
		gizli_bayraklar.remove_at(i)
	bayrak_ekle(b)


## Usta mı: açık bir `usta_*` bayrağı var ya da yeteneği 7 ve üstü.
func usta_mi() -> bool:
	if stat >= 7 or KoyluGelisimYoneticisi.usta(self):
		return true
	for b in bayraklar:
		if b.begins_with("usta_"):
			return true
	return false


func kaydet() -> Dictionary:
	return {"enfeksiyon": enfeksiyon.duplicate(true), "id": id, "ad": ad, "adli_id": String(adli_id), "sinif": String(sinif), "portre": portre, "stat": stat, "zanaat_turu": ZanaatTuru.anahtar(zanaat_turu),
		"bayraklar": Array(bayraklar), "gizli": Array(gizli_bayraklar), "moral": moral, "refah": refah, "saglik": saglik,
		"sadakat": sadakat, "is_yeri": is_yeri, "kis_oncesi": kis_oncesi_is, "ev": ev, "ac": ac, "giris": giris_gunu,
		"pasif_ozellikler": pasif_ozellikler.duplicate(true), "egitim": egitim.duplicate(true), "gelisim": gelisim.duplicate(true), "grev": grev.duplicate(true), "yorgunluk": yorgunluk.duplicate(true), "is_kazasi": is_kazasi.duplicate(true), "zanaat_kazasi": zanaat_kazasi.duplicate(true), "kis_hastaligi": kis_hastaligi.duplicate(true), "toplumsal_bag": toplumsal_bag.duplicate(true), "yas_grubu": String(yas_grubu), "gizli_egilim": gizli_egilim.duplicate(true), "divan_kanit": DivanKanit.durum(self)}


static func kayittan(v: Dictionary) -> Koylu:
	var k := Koylu.new()
	k.id = int(v.get("id", 0))
	k.ad = String(v.get("ad", ""))
	k.adli_id = StringName(v.get("adli_id", ""))
	k.sinif = StringName(v.get("sinif", "ciftci"))
	k.portre = String(v.get("portre", ""))
	k.stat = int(v.get("stat", 5))
	k.zanaat_turu = ZanaatTuru.oku(v.get("zanaat_turu"), ZanaatTuru.coz(k.adli_id, k.sinif))
	k.pasif_ozellikler = PasifOzellikler.oku(v.get("pasif_ozellikler"), PasifOzellikler.cift(k.adli_id, k.sinif, k.id))
	k.egitim = CirakEgitimi.oku(v.get("egitim"))
	k.gelisim = KoyluGelisimYoneticisi.oku(v.get("gelisim"))
	k.grev = MeslekGrevi.oku(v.get("grev"))
	k.yorgunluk = NobetYorgunlugu.oku(v.get("yorgunluk"))
	k.is_kazasi = IsKazalari.oku(v.get("is_kazasi"))
	k.zanaat_kazasi = ZanaatKazalari.oku(v.get("zanaat_kazasi"))
	k.kis_hastaligi = KisHastaligi.oku(v.get("kis_hastaligi"))
	k.enfeksiyon = SaglikYoneticisi.oku(v.get("enfeksiyon"))
	k.toplumsal_bag = KanDavasi.oku(v.get("toplumsal_bag"), KanDavasi.kaynak(k.adli_id))
	k.yas_grubu = YasRolleri.oku(v.get("yas_grubu"), k.adli_id)
	k.bayraklar = PackedStringArray(v.get("bayraklar", []))
	k.gizli_bayraklar = PackedStringArray(v.get("gizli", []))
	if SaglikYoneticisi.hasta(k) and "hasta" not in k.bayraklar + k.gizli_bayraklar: k.gizli_bayraklar.append("hasta")
	if k.kis_hastaligi.is_empty(): k.bayraklar.erase(KisHastaligi.FLAG)
	else: k.bayrak_ekle(KisHastaligi.FLAG)
	k.gizli_egilim = GizliEgilimler.oku(v.get("gizli_egilim"), k)
	k.refah = EkonomikRefah.yukle(v.get("refah"))
	k.moral = int(v.get("moral", 60))
	k.saglik = int(v.get("saglik", 100))
	k.sadakat = int(v.get("sadakat", 60))
	k.is_yeri = int(v.get("is_yeri", -1))
	k.kis_oncesi_is = int(v.get("kis_oncesi", -1))
	k.ev = int(v.get("ev", -1))
	k.ac = bool(v.get("ac", false))
	k.giris_gunu = int(v.get("giris", 0))
	k.set_meta(DivanKanit.META, DivanKanit.oku(k,v.get("divan_kanit",{})))
	return k
