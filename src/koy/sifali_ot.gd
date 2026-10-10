## KRI-15: salgında boştaki vasıfsız köylü şifalı ot toplar. Ot = mevcut "afyon" stoğu, yani
## KRI-03 ilaç reçetesinin (1 afyon + 1 su) girdisi; ikinci kaynak/üretim yolu yoktur. RNG yok.
extends RefCounted

static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/koy/sifali_ot.json"))

## Belirtisi açık (kamuya görünen) salgın; gizli kuluçka toplamayı başlatmaz.
static func salgin(y: KoyYonetimi) -> bool:
	for k in y.koylular:
		if SaglikYoneticisi.hasta(k) and "hasta" in k.bayraklar and SaglikYoneticisi.temas_edebilir(y, k): return true
	return false

## Boşta, vasıfsız (usta olmayan), sağlam yetişkin; hasta/karantina/zindan/dış görev hariç.
static func toplayicilar(y: KoyYonetimi) -> Array[Koylu]:
	var r: Array[Koylu] = []
	if not salgin(y): return r
	for k in y.koylular:
		if r.size() >= int(AYAR.azami_toplayici): break
		if k.is_yeri == KoyYonetimi.BOSTA and not k.usta_mi() and k.yas_grubu == &"yetiskin" and not SaglikYoneticisi.hasta(k) and SaglikYoneticisi.temas_edebilir(y, k) and CirakEgitimi.saglam(k): r.append(k)
	return r

## Üretimden önce: toplanan ot aynı gece Şifahane ilaç reçetesine girebilir.
static func gece(y: KoyYonetimi, olaylar: Array[Dictionary]) -> void:
	if y.son != &"" or y.isyan_kalan >= 0: return
	var t := toplayicilar(y)
	if t.is_empty(): return
	var eklenen := y.kaynaklar.ekle("afyon", t.size() * int(AYAR.kisi_basina_ot))
	var adlar: Array[String] = []
	for k in t: adlar.append(TranslationServer.translate(k.ad))
	olaylar.append({"anahtar": "sifali_ot", "sifali_ot": {"adlar": adlar, "ot": eklenen}})

static func olay_metin(e: Dictionary) -> String:
	var d: Dictionary = e.sifali_ot
	if int(d.ot) <= 0: return "Şifalı ot · %s ot topladı ama ambarda yer yok." % ", ".join(d.adlar)
	return "Şifalı ot · salgın sürerken boştaki %s kırdan %d şifalı ot (afyon) topladı; Şifahane ilaç reçetesine (1 afyon + 1 su) girer." % [", ".join(d.adlar), d.ot]
