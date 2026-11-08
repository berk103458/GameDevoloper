## KRI-07: mevcut kriz API'leri üzerinde gizli oy, tek karar makbuzu.
class_name CinarAltiMeclisi
extends RefCounted

const META := &"cinar_alti_meclisi"
static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/ayarlar/denge.json"))
## DEN-01: meclis bekleme aralığı denge tablosundan okunur; kodda sabit değildir.
static func bekleme() -> int: return int(AYAR.kriz_araligi.meclis_bekleme_gun)
const TUR := ["kitlik", "salgin", "kuyu", "yas"]
const AD := {"kitlik": "Kıtlık isyanı", "salgin": "Salgın belirtileri", "kuyu": "Kirli kuyu", "yas": "Köy yası"}
const SECENEK := {"as": "Ambarı aç, aş dağıt", "vergi": "Bu hafta vergiyi kaldır", "karantina": "Belirtili köylüler için karantinayı genişlet", "kirec": "Kuyuyu 2 kireçle dezenfekte et", "toren": "Cenaze töreni düzenle", "toplu_mezar": "Ücretsiz toplu mezar"}

static func _tam(v: Variant, alt: int, ust: int = 1000000000) -> bool:
	return (v is int or v is float) and is_finite(float(v)) and float(v) == floor(float(v)) and float(v) >= alt and float(v) <= ust

## Kayıtta kişi, kimlik, gizli eğilim veya tekil oy tutulmaz.
static func oku(v: Variant) -> Dictionary:
	var bos := {"son_gun": -1, "izler": {}, "oylama": {}}
	if not v is Dictionary or not _tam(v.get("son_gun"), -1) or not v.get("izler") is Dictionary: return bos
	var izler := {}
	for tur in TUR:
		if not v.izler.has(tur): continue
		var i: Variant = v.izler[tur]
		if not i is Dictionary or not _tam(i.get("sira"), 1) or not _tam(i.get("iz"), -1) or not i.get("aktif") is bool or not i.get("toplandi") is bool: return bos
		izler[tur] = {"sira": int(i.sira), "iz": int(i.iz), "aktif": i.aktif, "toplandi": i.toplandi}
	var d := {"son_gun": int(v.son_gun), "izler": izler, "oylama": {}}
	if _tam(v.get("haftalik_gun"), 0): d.haftalik_gun = int(v.haftalik_gun)
	var o: Variant = v.get("oylama", {})
	if not o is Dictionary: return bos
	if o.is_empty(): return d
	if o.get("tur") not in TUR or not _tam(o.get("sira"), 1) or not _tam(o.get("gun"), 0) or o.get("karar") not in ["", "uygulandi", "reddedildi", "suresi_doldu"]: return bos
	if not o.get("secenekler") is Array or o.secenekler.size() < 2 or o.secenekler.size() > 3 or not o.get("oylar") is Array or o.oylar.size() != o.secenekler.size(): return bos
	var secenekler: Array[String] = []
	var oylar: Array[int] = []
	var toplam := 0
	for idx in o.secenekler.size():
		var s: Variant = o.secenekler[idx]
		if not s is String or not SECENEK.has(s) or s in secenekler or not _tam(o.oylar[idx], 0, 1000000): return bos
		secenekler.append(s)
		oylar.append(int(o.oylar[idx]))
		toplam += int(o.oylar[idx])
	if toplam <= 0 or not _tam(o.get("kazanan"), 0, secenekler.size() - 1) or not _tam(o.get("katilim"), 1, 1000000) or toplam != int(o.katilim): return bos
	var kazanan := 0
	for idx in oylar.size():
		if oylar[idx] > oylar[kazanan]: kazanan = idx
	if kazanan != int(o.kazanan) or int(o.gun) != d.son_gun or not izler.has(o.tur) or int(izler[o.tur].sira) < int(o.sira): return bos
	if o.karar == "" and (not izler[o.tur].toplandi or int(izler[o.tur].sira) != int(o.sira)): return bos
	var izinli: Array = ["as", "vergi"]
	if o.tur == "salgin": izinli = ["karantina", "as"]
	if o.tur == "kuyu": izinli = ["kirec", "as"]
	if o.tur == "yas" and "toren" in secenekler: izinli = ["toren", "toplu_mezar", "as"]
	if secenekler != izinli: return bos
	d.oylama = {"tur": String(o.tur), "sira": int(o.sira), "gun": int(o.gun), "secenekler": secenekler, "oylar": oylar, "kazanan": kazanan, "katilim": toplam, "karar": String(o.karar)}
	return d

static func durum(y: KoyYonetimi) -> Dictionary:
	return oku(y.get_meta(META, {}))

## Salgın çağrısı ve oy etkilenmesi yalnız açılmış belirtilerden türetilir.
static func belirtili(k: Koylu) -> bool:
	return SaglikYoneticisi.hasta(k) and "hasta" in k.bayraklar

static func _krizler(y: KoyYonetimi) -> Dictionary:
	var r := {}
	# Erzak gelince KRI-06 sayacı sıfırlanır, mevcut isyan ise sürer.
	# Aş oyu için erzak tedarik edilebilir; kriz isyan bitince kapanır.
	var iz: Dictionary = durum(y).izler.get("kitlik", {})
	if y.isyan_kalan >= 0 and (KitlikIsyani.durum(y).tetiklendi or iz.get("aktif", false)): r.kitlik = -1
	for k in y.koylular:
		if k.saglik > 0 and belirtili(k) and not KervanKorumasi.disarida(y, k.id):
			r.salgin = -1
			break
	if KuyuKirliligi.kirli(y): r.kuyu = int(KuyuKirliligi.durum(y).baslangic)
	var yas := CenazeYasi.durum(y)
	if not yas.is_empty() and y.gun <= int(yas.bitis): r.yas = int(yas.olum_gecesi)
	return r

## Süren salgında hasta sayısının değişmesi yeni kriz değildir. Yeni kuyu/yas
## başlangıcı veya kapanıp yeniden başlayan kriz yeni bir dönemdir.
static func esitle(y: KoyYonetimi) -> void:
	var d := durum(y)
	var krizler := _krizler(y)
	for tur in TUR:
		var i: Dictionary = d.izler.get(tur, {"sira": 0, "iz": -1, "aktif": false, "toplandi": false})
		if krizler.has(tur):
			if not i.aktif or int(i.iz) != int(krizler[tur]):
				i.sira = mini(1000000000, int(i.sira) + 1)
				i.toplandi = false
				i.iz = int(krizler[tur])
			i.aktif = true
		else: i.aktif = false
		if int(i.sira) > 0: d.izler[tur] = i
	if not d.oylama.is_empty() and d.oylama.karar == "":
		var o: Dictionary = d.oylama
		var i: Dictionary = d.izler.get(o.tur, {})
		if y.son != "" or not i.get("aktif", false) or int(i.get("sira", -1)) != int(o.sira) or y.gun < int(o.gun) or y.gun >= int(o.gun) + bekleme(): d.oylama.karar = "suresi_doldu"
	y.set_meta(META, d)

static func yukle(y: KoyYonetimi, v: Variant) -> void:
	var d := oku(v)
	if int(d.son_gun) > y.gun: d = oku({})
	if int(d.get("haftalik_gun", -1)) > y.gun: d.erase("haftalik_gun")
	y.set_meta(META, d)
	# Yükleme yeni kriz gözlemi üretmez; save/load birebir kalır.
	# Gece/HUD/karar kapısı dönem ve süreyi işlemden önce doğrular.

## Karantinadakiler temsil yoluyla oy verir; meclis fiziksel temas oluşturmaz.
static func secmenler(y: KoyYonetimi) -> Array[Koylu]:
	var r: Array[Koylu] = []
	for k in y.koylular:
		if k.yas_grubu != &"cocuk" and k.saglik > 0 and not DivanHukmu.zindanda(k) and not KervanKorumasi.disarida(y, k.id): r.append(k)
	r.sort_custom(func(a: Koylu, b: Koylu) -> bool: return a.id < b.id)
	return r

static func secenekler(y: KoyYonetimi, tur: String) -> Array[String]:
	match tur:
		"salgin": return ["karantina", "as"]
		"kuyu": return ["kirec", "as"]
		"yas":
			if CenazeYasi.bekliyor(y): return ["toren", "toplu_mezar", "as"]
	return ["as", "vergi"]

## Temel ihtiyaç, yönetim güveni ve aynı grubun açık sıkıntısı. Grup isimleri
## puanlanmaz; yalnız KanDavasi'nin tanımladığı bağın eşitliği kullanılır.
static func puan(y: KoyYonetimi, k: Koylu, tur: String, secim: String) -> int:
	var ihtiyac := (100 - clampi(k.moral, 0, 100)) / 5
	var guven := clampi(k.sadakat, 0, 100) / 10 + y.adalet / 20
	guven -= preload("res://src/koy/batil_inanc_histerisi.gd").oy_cezasi(y, k)
	var grup_ac := 0
	var grup_hasta := 0
	var grup := String(k.toplumsal_bag.get("grup", ""))
	for diger in secmenler(y):
		if grup.is_empty() or grup != String(diger.toplumsal_bag.get("grup", "")): continue
		if diger.ac: grup_ac += 1
		if belirtili(diger): grup_hasta += 1
	match secim:
		"as": return 12 + ihtiyac + (25 if k.ac else 0) + mini(12, grup_ac * 4)
		"vergi": return 16 + (100 - clampi(k.sadakat, 0, 100)) / 5 + ihtiyac / 2
		"karantina": return 12 + guven + (20 if belirtili(k) else 0) + mini(12, grup_hasta * 4)
		"kirec": return 26 + guven + (10 if k.saglik < 70 else 0) + mini(12, grup_hasta * 4)
		"toren": return 20 + guven + ihtiyac + (6 if tur == "yas" else 0)
		"toplu_mezar": return 12 + (100 - clampi(k.sadakat, 0, 100)) / 10 + (18 if k.ac else 0)
	return 0

static func haftalik_bekliyor(y: KoyYonetimi) -> bool:
	return MeclisSesi.haftalik_mi(y) and int(durum(y).get("haftalik_gun", -1)) != y.gun


static func haftalik_bitir(y: KoyYonetimi, gun: int) -> bool:
	if y.gun != gun or not haftalik_bekliyor(y): return false
	var d := durum(y)
	d.haftalik_gun = gun
	y.set_meta(META, d)
	return true


static func toplanma_nedeni(y: KoyYonetimi, tur: String) -> String:
	if y.son != "": return "Oyun sona erdi"
	if MeclisSesi.haftalik_mi(y): return TranslationServer.translate("koy.meclis.haftalik.sikayet")
	if not _krizler(y).has(tur): return "Bu kriz artık aktif değil"
	if secmenler(y).is_empty(): return "Oy verebilecek köylü yok"
	var d := durum(y)
	if not d.oylama.is_empty() and d.oylama.karar == "": return "Önce bekleyen meclis kararını tamamla"
	if d.izler.get(tur, {}).get("toplandi", false): return "Bu kriz için meclis zaten toplandı"
	if int(d.son_gun) >= 0 and y.gun < int(d.son_gun) + bekleme(): return "Meclis için %d gün bekle" % (int(d.son_gun) + bekleme() - y.gun)
	return ""

static func topla(y: KoyYonetimi, tur: String) -> bool:
	esitle(y)
	if not toplanma_nedeni(y, tur).is_empty(): return false
	var d := durum(y)
	var secimler := secenekler(y, tur)
	var oylar: Array[int] = []
	for _s in secimler: oylar.append(0)
	var secmen := secmenler(y)
	for k in secmen:
		var en := 0
		for idx in range(1, secimler.size()):
			if puan(y, k, tur, secimler[idx]) > puan(y, k, tur, secimler[en]): en = idx
		oylar[en] += 1
	var kazanan := 0
	for idx in oylar.size():
		if oylar[idx] > oylar[kazanan]: kazanan = idx
	d.son_gun = y.gun
	d.izler[tur].toplandi = true
	d.oylama = {"tur": tur, "sira": d.izler[tur].sira, "gun": y.gun, "secenekler": secimler, "oylar": oylar, "katilim": secmen.size(), "kazanan": kazanan, "karar": ""}
	y.set_meta(META, d)
	return true

static func _karantina_adaylari(y: KoyYonetimi) -> Array[Koylu]:
	var r: Array[Koylu] = []
	for k in secmenler(y):
		# Çalışan hekimi izolasyona alıp aynı işlemde kontenjanı kapatmayız.
		var b := y.bina(k.is_yeri)
		if b != null and b.tur == "sifahane" and Sifahane.hekim_calismaya_uygun(y, k, b): continue
		if belirtili(k) and not KarantinaYoneticisi.aktif(k): r.append(k)
	return r.slice(0, mini(KarantinaYoneticisi.bos(y), y.kaynaklar.miktar("gida")))

static func islem_nedeni(y: KoyYonetimi, secim: String) -> String:
	match secim:
		"as": return "Aş için %d erzak gerekli" % (y.nufus() * y.a.as_dagit_gida) if y.kaynaklar.miktar("gida") < y.nufus() * y.a.as_dagit_gida else ""
		"vergi": return "Vergi zaten kaldırılmış" if y.vergi_muaf else ""
		"karantina": return "Belirtili aday, işler Şifahane kontenjanı ve erzak gerekli" if _karantina_adaylari(y).is_empty() else ""
		"kirec": return KuyuKirliligi.neden(y)
		"toren", "toplu_mezar": return CenazeYasi.neden(y, int(CenazeYasi.durum(y).get("olum_gecesi", -1)), secim)
	return "Geçersiz seçenek"

static func bedel_metni(y: KoyYonetimi, secim: String) -> String:
	match secim:
		"as": return "%d erzak · mevcut aş moral etkisi" % (y.nufus() * y.a.as_dagit_gida)
		"vergi": return "Bu haftanın mevcut vergi muafiyeti · ücretsiz"
		"karantina": return "Mevcut boş yatak kadar, en fazla %d belirtili aday · kişi başına 1 erzak/2 gün · çalışan hekim hariç" % KarantinaYoneticisi.bos(y)
		"kirec": return "2 kireç · hastaları iyileştirmez"
		"toren": return "%d erzak + %d kamu akçesi · yeni yas yarıya iner" % [CenazeYasi.bedel(y), CenazeYasi.bedel(y)]
		"toplu_mezar": return "Ücretsiz · tam yas; salgın cenazesinde kuyu kirlenebilir"
	return ""

static func karar_nedeni(y: KoyYonetimi, gun: int, tur: String, sira: int, uygula: bool) -> String:
	var o: Dictionary = durum(y).oylama
	if o.is_empty() or o.karar != "" or o.gun != gun or o.tur != tur or o.sira != sira: return "Bu oylama artık karar beklemiyor"
	if y.son != "" or y.gun < gun or y.gun >= gun + bekleme() or not _krizler(y).has(tur): return "Kriz veya meclis süresi sona erdi"
	var i: Dictionary = durum(y).izler.get(tur, {})
	if not i.get("aktif", false) or int(i.get("sira", -1)) != sira or int(i.get("iz", -2)) != int(_krizler(y)[tur]): return "Kriz dönemi değişti"
	return islem_nedeni(y, o.secenekler[o.kazanan]) if uygula else ""

## Tam bedel kontrolünden sonra mevcut API; başarısızlıkta ödül/ceza yok.
static func karar(y: KoyYonetimi, gun: int, tur: String, sira: int, uygula: bool) -> bool:
	esitle(y)
	if not karar_nedeni(y, gun, tur, sira, uygula).is_empty(): return false
	var d := durum(y)
	var secim: String = d.oylama.secenekler[d.oylama.kazanan]
	if uygula:
		match secim:
			"as":
				if not y.as_dagit(): return false
			"vergi": y.vergi_sifirla()
			"kirec":
				if not KuyuKirliligi.kirecle(y): return false
			"toren", "toplu_mezar":
				if not CenazeYasi.sec(y, int(CenazeYasi.durum(y).olum_gecesi), secim): return false
			"karantina":
				var adaylar := _karantina_adaylari(y)
				for k in adaylar:
					if not KarantinaYoneticisi.neden(y, k).is_empty(): return false
				for k in adaylar:
					if not KarantinaYoneticisi.al(y, k.id): return false
	for k in y.koylular:
		k.sadakat = clampi(k.sadakat + (4 if uygula else -6), 0, 100)
		if uygula: k.moral = mini(100, k.moral + 3)
	if not uygula: y.adalet = maxi(0, y.adalet - 5)
	d.oylama.karar = "uygulandi" if uygula else "reddedildi"
	y.set_meta(META, d)
	esitle(y)
	return true

static func ozet(o: Dictionary) -> String:
	if o.is_empty(): return ""
	var satir := PackedStringArray(["%s · %d oy · eşitlikte listedeki ilk seçenek" % [AD[o.tur], o.katilim]])
	for idx in o.secenekler.size(): satir.append("%s: %d oy (%%%d)%s" % [SECENEK[o.secenekler[idx]], o.oylar[idx], roundi(100.0 * int(o.oylar[idx]) / int(o.katilim)), " · Halkın kararı" if idx == int(o.kazanan) else ""])
	return "\n".join(satir)
