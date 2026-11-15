## ACL-02: Eş — oynanabilir ama sıradan köylü değil (birim testi).
extends SceneTree

const AcilisSenaryosu = preload("res://src/sistemler/acilis_senaryosu.gd")
const HaneEsi = preload("res://src/koy/hane_esi.gd")
const NihaiSon = preload("res://src/sistemler/nihai_son.gd")

var hata := 0

func dene(kosul: bool, mesaj: String) -> void:
	if not kosul:
		hata += 1
		push_error("KALDI: " + mesaj)

func _initialize() -> void:
	var kat := Katalog.new()
	kat.yukle()

	# 1. Temel kurulum: ACL-01 ile eş kurulur, 6 meslek vardır; okuryazar geçmiş yoksa kâtip kapalıdır.
	var o := Oturum.new(kat, 1402)
	AcilisSenaryosu.kur(o, "olagan")
	var y := o.yonetim
	var es := HaneEsi.es_bul(y)
	dene(es != null and HaneEsi.es_mi(es), "ACL-02: Açılışta eş bulunur")

	var temel_meslekler := HaneEsi.meslekler(o, es)
	var adlar: Array[String] = []
	for m in temel_meslekler:
		adlar.append(String(m.id))
	for beklenen in ["dokumaci", "ebe", "firinci", "bostanci", "sutcu", "yun_egirici"]:
		dene(beklenen in adlar, "ACL-02: Temel meslek listede: " + beklenen)
	dene(temel_meslekler.size() == 6 and not ("katip" in adlar), "ACL-02: Okuryazar geçmiş yokken 6 meslek vardır, kâtip yoktur")
	dene(not HaneEsi.meslek_sec(y, "katip", o).ok, "ACL-02: Okuryazar geçmiş yokken kâtip seçilemez")

	# 2. Yasak meslekler (demirci, taşçı, oduncu, asker, madenci) 0 kez kabul edilir.
	for yasak in ["demirci", "tasci", "oduncu", "asker", "madenci", "uydurma_meslek"]:
		var r := HaneEsi.meslek_sec(y, yasak, o)
		dene(not bool(r.ok), "ACL-02: Liste dışı meslek reddedilir: " + yasak)

	# 3. Okuryazar geçmiş (medrese_talebesi) varken kâtiplik açılır.
	var ok_o := Oturum.new(kat, 1403)
	AcilisSenaryosu.kur(ok_o, "olagan")
	ok_o.yonetim.set_meta(&"muhafiz_gecmisi", "medrese_talebesi")
	var ok_es := HaneEsi.es_bul(ok_o.yonetim)
	var ok_liste := HaneEsi.meslekler(ok_o, ok_es)
	var ok_idleri: Array[String] = []
	for m in ok_liste:
		ok_idleri.append(String(m.id))
	dene(ok_liste.size() == 7 and "katip" in ok_idleri, "ACL-02: Okuryazar geçmişte kâtiplik açılır")
	dene(bool(HaneEsi.meslek_sec(ok_o.yonetim, "katip", ok_o).ok), "ACL-02: Kâtiplik okuryazar geçmişte seçilebilir")

	# 4. Meslek değişince 1 gün verimsiz çalışır; ikinci değişiklikte gün 1'de kalır, 2 olmaz.
	y.kaynaklar = Kaynaklar.new(1000, {"gida": 500, "odun": 200})
	var r1 := HaneEsi.meslek_sec(y, "firinci", o)
	dene(bool(r1.ok) and int(r1.verimsiz_kalan) == 1, "ACL-02: İlk meslek değişimi 1 gün verimsiz yapar")
	var r2 := HaneEsi.meslek_sec(y, "ebe", o)
	dene(bool(r2.ok) and int(r2.verimsiz_kalan) == 1 and int(HaneEsi.durum(y).verimsiz_kalan) == 1, "ACL-02: Süre dolmadan ikinci değişimde verimsiz gün 1'de kalır, 2 olmaz")
	dene(HaneEsi.verim_carpani(y) < 1.0 and int(HaneEsi.cikti_al(y).miktar) < 1, "ACL-02: Değişim gününde çıktı düşüktür")
	y.gece()
	dene(int(HaneEsi.durum(y).verimsiz_kalan) == 0 and is_equal_approx(HaneEsi.verim_carpani(y), 1.0) and int(HaneEsi.cikti_al(y).miktar) == 1, "ACL-02: Ertesi gün tam verime döner")

	# 5. Arabuluculuk her meslekte açıktır ve morale yazılır; kalp alanı yoktur.
	var koylu := y.kabul({"ad": "Köylü Ali", "sinif": "ciftci", "stat": 5})
	koylu.moral = 40
	for mes in ["dokumaci", "ebe", "firinci", "bostanci", "sutcu", "yun_egirici"]:
		HaneEsi.meslek_sec(y, mes, o)
		y.gun += 1
		var once_moral := koylu.moral
		var ar := HaneEsi.arabuluculuk_yap(y, koylu.id)
		dene(bool(ar.ok) and koylu.moral > once_moral, "ACL-02: Arabuluculuk her meslekte çalışır: " + mes)
	var kayit_json := JSON.stringify(o.kaydet())
	dene(not kayit_json.contains("\"kalp\""), "ACL-02: Kayıtta kalp alanı yazılmaz")

	# 6. Debug konsolundan demirci yazılırsa kayıt reddeder.
	var bozuk_kayit := o.kaydet()
	var ky_veri: Dictionary = bozuk_kayit["koy_yonetimi"]
	ky_veri["hane_esi"] = {"meslek": "demirci", "verimsiz_kalan": 5}
	for kv in ky_veri["koylular"]:
		if String(HaneEsi.AYAR.bayrak) in kv.get("bayraklar", []):
			kv["sinif"] = "demirci"
	var yuklenen := Oturum.kayittan(kat, JSON.parse_string(JSON.stringify(bozuk_kayit)))
	dene(String(HaneEsi.durum(yuklenen.yonetim).meslek) != "demirci" and HaneEsi.meslek_gecerli_mi(HaneEsi.durum(yuklenen.yonetim).meslek, yuklenen), "ACL-02: Debug/bozuk demirci kaydı reddedilir")

	# 7. Kışla, kervan, sürgün ve divan kapalıdır; sürgün denemesinde hane uyarısı çıkar ve köy kaydı silinmez.
	dene(not HaneEsi.izinli_mi(es, "kisla") and not HaneEsi.izinli_mi(es, "kervan") and not HaneEsi.izinli_mi(es, "surgun") and not HaneEsi.izinli_mi(es, "divan"), "ACL-02: Dört eylem eşte kapalıdır")
	dene(not y.muhafiz_ata(es.id), "ACL-02: Eş muhafız/kışlaya atanamaz")
	dene(not KervanKorumasi.aday(y, es.id), "ACL-02: Eş kervan korumasına aday olamaz")
	var nufus_once := y.koylular.size()
	dene(not y.surgun(es.id) and y.koylular.size() == nufus_once and not String(y.get_meta(HaneEsi.UYARI_META, "")).is_empty(), "ACL-02: Eş sürgün edilemez, uyarı çıkar ve kaydı silinmez")
	y.set_meta(DivanHukmu.META, {str(es.id): {"gun": y.gun, "karar": "surgun", "adli_id": ""}})
	var sb := SabahDefteri.sabah(y, 1, "", "dag_yolu")
	dene(int(sb.nufus_deltasi) == 0 and y.koylular.size() == nufus_once and not String(sb.get("uyari", "")).is_empty(), "ACL-02: SabahDefteri sürgün yolunda hane uyarısı verir, silmez")
	y.gun = 10
	o.gun = 10
	CasusGeceTakibi.kaydet(y, es, "ambar", -1, "hirsizlik", "gida", 1, true)
	dene(not (es.id in DivanOturumu.adaylar(y)) and not DivanHukmu.uygun(o, es.id, "zindan"), "ACL-02: Eş divana girmez ve hüküm verilmez")

	# 8. Eşin kimliği kapı kuyruğunda 0 kez görünür.
	for g_gun in range(1, 8):
		o.gun = g_gun
		var kuyruk := o.gece_kuyrugu()
		for g in kuyruk:
			dene(not HaneEsi.gelen_es_mi(g, o), "ACL-02: Eş kapı kuyruğuna yazılmaz")

	# 9. Eşin ölümünde yeni son yazılmaz, akşam sohbeti susar, duran epilog ağır yas olarak açılır.
	es.saglik = 0
	y.gece()
	dene(y.son == "", "ACL-02: Eş ölümünde yeni son yazılmaz")
	dene(not y.hane.es_hayatta and y.hane.yas_donemi, "ACL-02: Eş ölünce yas dönemi başlar")
	o.aksam_sohbeti_ekle("aileyi_bolmek")
	dene(o.aksam_sohbeti_hazirla().is_empty(), "ACL-02: Eş ölünce akşam sohbeti açılmaz")
	dene(HaneEsi.agir_yas_var_mi(o) and NihaiSon.epilog(o).contains("Ağır yas"), "ACL-02: Duran epilog ağır yas satırını içerir")

	print("HANE EŞİ: GEÇTİ" if hata == 0 else "HANE EŞİ: KALDI")
	quit(hata)
