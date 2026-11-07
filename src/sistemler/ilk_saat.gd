## OGR-01: Ilk saat haritasi tek dosyada durur (`data/ogretici/ilk_saat.json`).
## Oyuncunun ilk alti gecede karsilasacagi kavramlarin `gece_min` ve `tetik` bilgisini okur.
## Listede olmayan ipucu cikmaz; gosterilen ipucu ikinci kez uretilmez.
class_name IlkSaat
extends RefCounted

const VERI_YOLU := "res://data/ogretici/ilk_saat.json"
const TEHDIT_YOLU := "res://data/tehdit_takvimi.json"
const AZAMI_IPUCU := 20

static func ipucu_metni(anahtar: String) -> String:
	var metin := TranslationServer.translate(anahtar)
	return GuvenliMetin.metin(anahtar) if metin == anahtar or metin.is_empty() else metin


static func koy_hizi_ipucunu_goster(ekran: Control, oturum: Oturum, ayarlar: Ayarlar) -> void:
	if oturum.gun != 0 or not preload("res://src/sistemler/acilis_senaryosu.gd").durum(oturum).get("kuruldu", false): return
	var kimlik := "koy_hizi"
	var kayit := oturum.ipucu_kaydi
	if not preload("res://src/sistemler/ipucu_anahtari.gd").gosterilir_mi(ayarlar, kayit, kimlik): return
	var serit := IpucuSeridi.new()
	serit.process_mode = Node.PROCESS_MODE_ALWAYS
	ekran.add_child(serit)
	serit.kapandi.connect(func(_id: String) -> void: serit.queue_free())
	if serit.goster(ipucu_metni("ogretici.koy.hiz"), kimlik):
		kayit.ipucu_ekle(kimlik)
	else:
		serit.queue_free()


var _veri: Dictionary = {}
var _kavramlar: Array[Dictionary] = []
var _gorulen: Dictionary = {}
var zar_gosterildi: bool = false
var perde: int = 1


func _init(yol: String = VERI_YOLU) -> void:
	yukle_dosya(yol)


func yukle_dosya(yol: String = VERI_YOLU) -> bool:
	_veri.clear()
	_kavramlar.clear()
	if not FileAccess.file_exists(yol):
		return false
	var metin := FileAccess.get_file_as_string(yol)
	var parsed: Variant = JSON.parse_string(metin)
	if not (parsed is Dictionary):
		return false
	_veri = parsed
	var ust_sinir := mini(AZAMI_IPUCU, maxi(1, int(_veri.get("azami_ipucu", AZAMI_IPUCU))))
	var ham_liste: Variant = _veri.get("kavramlar", [])
	if ham_liste is Array:
		for oge in ham_liste:
			if _kavramlar.size() >= ust_sinir:
				break
			if oge is Dictionary:
				var d: Dictionary = (oge as Dictionary).duplicate(true)
				if d.has("id") and d.has("gece_min") and d.has("tetik"):
					if not (d.get("atla_gecmis", null) is Array):
						d["atla_gecmis"] = []
					_kavramlar.append(d)
	return not _kavramlar.is_empty()


func sifirla() -> void:
	_gorulen.clear()
	zar_gosterildi = false
	perde = 1


func kavram_sayisi() -> int:
	return _kavramlar.size()


func kavramlar() -> Array[Dictionary]:
	return _kavramlar.duplicate(true)


## OGR-33: ilk_saat.json icindeki son_kilidi_gece degerini doner (varsayilan 6).
func son_kilidi_gece() -> int:
	return maxi(0, int(_veri.get("son_kilidi_gece", 6)))


## OGR-37: Verilen muhafiz gecmisi icin atlanmayan kavram kimliklerini doner.
func gecmis_icin_ipuclari(gecmis_id: String) -> Array[String]:
	var temiz := gecmis_id.strip_edges()
	var sonuc: Array[String] = []
	for k in _kavramlar:
		var atla: Variant = k.get("atla_gecmis", [])
		var atlanir := false
		if not temiz.is_empty() and atla is Array:
			for g in atla:
				if String(g) == temiz:
					atlanir = true
					break
		if not atlanir:
			sonuc.append(String(k.get("id", "")))
	return sonuc


## OGR-06: tehdit_baslangic BUG-18 sabitini (tehdit_takvimi.json) tek yerden okur; iki ayri sayi yoktur.
static func tehdit_baslangic_gunu(ozel_ayar: Dictionary = {}) -> int:
	if not ozel_ayar.is_empty() and ozel_ayar.has("tehdit_baslangic_gunu"):
		return maxi(0, int(ozel_ayar["tehdit_baslangic_gunu"]))
	return maxi(0, int(TehditTakvimi.AYAR.get("tehdit_baslangic_gunu", 14)))


## Verilen kavram kimliginin listede yer alip almadigini ve bu gecede acik olup olmadigini denetler.
func kavram_acik_mi(kavram_id: String, guncel_gece: int) -> bool:
	var temiz := kavram_id.strip_edges()
	for k in _kavramlar:
		if String(k.get("id", "")) == temiz:
			return guncel_gece >= int(k.get("gece_min", 0))
	return false


## Tetik veya kavram kimligiyle ipucu gostermeyi dener.
## Listede olmayan ipucu cikmaz; `gece_min` gelmemisse veya daha once gorulduyse cikmaz.
## OMR-11: perde 2'de ipucu sistemi susar (`ilk_saat.json` kavramlarinin hicbiri perde 2'de tetiklenmez).
func tetikle(anahtar: String, guncel_gece: int, gecmis_id: String = "", perde_no: int = -1) -> Dictionary:
	var etkin_perde := perde_no if perde_no > 0 else perde
	if etkin_perde >= 2:
		return {"gosterildi": false, "sebep": "perde2_sustu"}
	var temiz := anahtar.strip_edges()
	if temiz.is_empty():
		return {"gosterildi": false, "sebep": "bos_anahtar"}
	var temiz_gecmis := gecmis_id.strip_edges()
	for k in _kavramlar:
		var id_str := String(k.get("id", ""))
		var tetik_str := String(k.get("tetik", ""))
		if temiz == id_str or temiz == tetik_str:
			if not temiz_gecmis.is_empty():
				var atla: Variant = k.get("atla_gecmis", [])
				if atla is Array:
					for g in atla:
						if String(g) == temiz_gecmis:
							return {"gosterildi": false, "sebep": "gecmis_atlandi", "id": id_str}
			if _gorulen.has(id_str):
				return {"gosterildi": false, "sebep": "zaten_goruldu", "id": id_str}
			if guncel_gece < int(k.get("gece_min", 0)):
				return {"gosterildi": false, "sebep": "gece_min_gelmedi", "id": id_str}
			_gorulen[id_str] = true
			if id_str == "zar":
				zar_gosterildi = true
			return {
				"gosterildi": true,
				"id": id_str,
				"tetik": tetik_str,
				"gece_min": int(k.get("gece_min", 0)),
			}
	return {"gosterildi": false, "sebep": "listede_yok"}


## OGR-03: Ikinci gece (gece >= 1) ilk zar atisinda ipucu bir kez doner ve `zar_gosterildi = true` yazilir.
func zar_ipucu_kontrol(guncel_gece: int) -> Dictionary:
	if guncel_gece < 1 or zar_gosterildi:
		return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": zar_gosterildi}
	var sonuc := tetikle("ilk_zar_atisi", guncel_gece)
	if not bool(sonuc.get("gosterildi", false)):
		return {"ipucu_sayisi": 0, "metin": "", "zar_gosterildi": zar_gosterildi}
	zar_gosterildi = true
	return {
		"ipucu_sayisi": 1,
		"metin": ipucu_metni("ogretici.zar.formul"),
		"zar_gosterildi": true,
	}


## OGR-21: Ilk insa denemesinde kaynak yetmezse kaynagin nereden geldigini (tas yatagi, oduncu) bir kez soyler.
## Yeterli kaynakla 0 doner; yetersiz kaynakla ilk denemede 1, sonraki denemelerde 0 doner.
func insa_kaynak_uyarisi(kaynak_yeterli: bool, eksik_kaynak: String = "tas") -> Dictionary:
	if kaynak_yeterli or _gorulen.has("insa_kaynak_uyarisi"):
		return {"ipucu_sayisi": 0, "metin": ""}
	_gorulen["insa_kaynak_uyarisi"] = true
	var norm := eksik_kaynak.strip_edges().to_lower()
	var kaynak_yeri := "taş yatağı ve oduncu"
	if norm == "tas":
		kaynak_yeri = "taş yatağı"
	elif norm == "odun":
		kaynak_yeri = "oduncu"
	return {
		"ipucu_sayisi": 1,
		"metin": ipucu_metni("ogretici.insa.kaynak") % kaynak_yeri,
		"kaynak_yeri": kaynak_yeri,
	}


## OGR-15: Heybe ilk kez gizli esya (`esya_gizli`) tasiyan kiside ipucu alir.
func heybe_gizli_esya_ipucu(esya_gizli_var: bool, guncel_gece: int = 2) -> Dictionary:
	if not esya_gizli_var or _gorulen.has("heybe_gizli_esya"):
		return {"ipucu_sayisi": 0, "metin": ""}
	_gorulen["heybe_gizli_esya"] = true
	tetikle("ilk_gizli_esya", maxi(2, guncel_gece))
	return {
		"ipucu_sayisi": 1,
		"metin": ipucu_metni("ogretici.heybe.gizli"),
	}


## OGR-16: Tansiyon gostergesi ilk kez "gergin" kademeye gecince tek satir ipucu: zar zorlasti.
func tansiyon_gergin_ipucu(kademe: String) -> Dictionary:
	var norm := kademe.strip_edges().to_lower()
	if norm != "gergin" or _gorulen.has("tansiyon_gergin"):
		return {"ipucu_sayisi": 0, "metin": ""}
	_gorulen["tansiyon_gergin"] = true
	return {
		"ipucu_sayisi": 1,
		"metin": ipucu_metni("ogretici.zar.gergin"),
	}


## OGR-17: Dort bar (`bar.halk`, `bar.soylular`, `bar.tuccarlar`, `bar.ordu`) ilk kez degisince
## hangi kararin hangi bari oynattigi anahtariyla tek satirda soylenir.
func bar_degisim_ipucu(bar_anahtari: String, delta: int, guncel_gece: int = 1) -> Dictionary:
	var temiz := bar_anahtari.strip_edges()
	if delta == 0 or temiz.is_empty() or _gorulen.has("bar_ilk_degisim"):
		return {"ipucu_sayisi": 0, "metin": "", "bar_anahtari": ""}
	var tam_anahtar := temiz if temiz.begins_with("bar.") else "bar." + temiz
	_gorulen["bar_ilk_degisim"] = true
	tetikle("ilk_bar_degisimi", maxi(1, guncel_gece))
	var yon := "yükseldi" if delta > 0 else "geriledi"
	return {
		"ipucu_sayisi": 1,
		"bar_anahtari": tam_anahtar,
		"metin": ipucu_metni("ogretici.bar.degisim") % [tam_anahtar, yon],
	}


## OGR-18: Kabul siniri (barinak kapasitesi) ilk kez dolunca ipucu; karari engellemez.
func barinak_dolu_ipucu(bos_yatak: int) -> Dictionary:
	if bos_yatak > 0 or _gorulen.has("barinak_ilk_dolu"):
		return {"ipucu_sayisi": 0, "metin": "", "engeller": false}
	_gorulen["barinak_ilk_dolu"] = true
	return {
		"ipucu_sayisi": 1,
		"metin": ipucu_metni("ogretici.barinak.dolu"),
		"engeller": false,
	}


## OGR-20: Kaynak gostergesi ilk kez bir kaynak dusunce tuketim satiri tek satirla soylenir.
func kaynak_eksilis_ipucu(tuketim_miktari: int, kaynak_adi: String = "erzak") -> Dictionary:
	if tuketim_miktari <= 0 or _gorulen.has("kaynak_ilk_eksilis"):
		return {"ipucu_sayisi": 0, "metin": ""}
	_gorulen["kaynak_ilk_eksilis"] = true
	var temiz_ad := kaynak_adi.strip_edges()
	if temiz_ad.is_empty():
		temiz_ad = "erzak"
	return {
		"ipucu_sayisi": 1,
		"metin": ipucu_metni("ogretici.kaynak.eksi") % [temiz_ad, tuketim_miktari],
	}


## OGR-32: Ambar `ambar_yedek_gece` (varsayilan 1) altina ilk inince ipucu ve renk uyarisi.
func kitlik_esigi_ipucu(ambar_gece: float, ambar_yedek_gece: float = 1.0) -> Dictionary:
	if ambar_gece >= ambar_yedek_gece or _gorulen.has("kitlik_ilk_yaklasma"):
		return {"ipucu_sayisi": 0, "metin": "", "renk_uyarisi": false}
	_gorulen["kitlik_ilk_yaklasma"] = true
	return {
		"ipucu_sayisi": 1,
		"metin": ipucu_metni("ogretici.ambar.esik"),
		"renk_uyarisi": true,
	}


## OGR-34: Iflas esiginden iki gece once (orn. esik 3 ise ilk eksi kasada, kalan <= 2 gece) tek satir uyari.
func iflas_uyarisi_ipucu(eksi_kasa_gece_sayisi: int, iflas_esigi_gece: int = 3) -> Dictionary:
	var kalan := iflas_esigi_gece - eksi_kasa_gece_sayisi
	if eksi_kasa_gece_sayisi <= 0 or kalan > 2 or kalan <= 0 or _gorulen.has("iflas_ilk_uyari"):
		return {"ipucu_sayisi": 0, "metin": ""}
	_gorulen["iflas_ilk_uyari"] = true
	return {
		"ipucu_sayisi": 1,
		"kalan_gece": kalan,
		"metin": ipucu_metni("ogretici.kasa.iflas") % kalan,
	}


func gorulen_ipuclari() -> Array[String]:
	var sonuc: Array[String] = []
	for k in _gorulen.keys():
		sonuc.append(String(k))
	return sonuc


## OGR-04: Ilk kabul edilen kisi koye girmeden once koy ekrani dugmesi pasiftir.
static func koy_acik(kabul_sayisi: int) -> bool:
	return kabul_sayisi > 0


func kaydet() -> Dictionary:
	return {
		"gorulen": gorulen_ipuclari(),
		"zar_gosterildi": zar_gosterildi,
	}


func yukle(veri: Dictionary) -> bool:
	_gorulen.clear()
	zar_gosterildi = bool(veri.get("zar_gosterildi", false))
	var ham_gorulen: Variant = veri.get("gorulen", [])
	if ham_gorulen is Array:
		for g in ham_gorulen:
			var s := String(g).strip_edges()
			if not s.is_empty():
				_gorulen[s] = true
	return true
