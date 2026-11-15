## SYS-20: beş nihai son + epilog matrisi. Mevcut "zafer" (SYS-19 12 gece / 3 baskın) sonu
## köyün gidişatına göre beş sondan birine ayrılır; bütün sonlara 5 gösterge + yozlaşma epilogu
## eklenir. Kayıp sonları (isyan/tekfur/halk_kirildi/azil/idam) başlık/metnini korur. RNG yok.
extends RefCounted

static var AYAR: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/nihai_sonlar.json"))

## 0..100 göstergeler (köyün son hali) + muhafız yozlaşması.
static func gostergeler(o: Oturum) -> Dictionary:
	var y := o.yonetim
	var hedef := maxi(1, y.a.agalik_nufus)
	return {"huzur": clampi(y.huzur(), 0, 100), "adalet": clampi(y.adalet, 0, 100), "refah": clampi(EkonomikRefah.oku(y), 0, 100),
		"guvenlik": clampi(KervanKorumasi.guvenlik(y), 0, 100), "nufus": clampi(int(round(100.0 * y.nufus() / (hedef * 1.5))), 0, 100),
		"yozlasma": clampi(int(MuhafizTerazisi.durum(o).yozlasma), 0, 100)}

## Yalnız zafer için: öncelik sırasıyla beş sondan biri.
static func son(o: Oturum, s: StringName) -> String:
	if o == null or preload("res://src/sistemler/son_kilidi.gd").kilitli_mi(o): return ""
	if s != &"zafer": return ""
	var dis_hat := preload("res://src/sistemler/dis_hat_kapisi.gd")
	var y := o.yonetim
	var g := gostergeler(o)
	var e: Dictionary = AYAR.esik
	var dk := DunyaZamani.kararlar_oku(o)
	var harac_karari := String(dk.get("tekfur_haraci", "bekliyor"))
	var oba_karari := String(dk.get("turkmen_ittifaki", "bekliyor"))
	var haraca_boyun := y.agalik and harac_karari != "ret" and y.tekfur_baski == 0 and y.savusturulan == 0 and (KoyYonetimi.PERDE_GECISI.gece(y) >= y.a.harac_araligi or harac_karari == "kabul")
	if int(g.yozlasma) >= int(e.yozlasma) or (haraca_boyun and not dis_hat.hat_kapali_mi(o, "tekfur")): return "tekfur_haraccisi"
	if not dis_hat.hat_kapali_mi(o, "oba") and oba_karari != "ret" and (ObaIttifaki.muttefik(o) or oba_karari == "kabul"): return "ertugrul_obasi"
	if not dis_hat.hat_kapali_mi(o, "sancak") and (SancakAskerTalebi.oku(o.sancak_asker_talebi).levent_gonderildi or (int(g.guvenlik) >= int(e.guvenlik_bey) and y.etkin_muhafiz_sayisi() >= int(e.muhafiz_bey))): return "beyin_uc_koyu"
	if not dis_hat.hat_kapali_mi(o, "ahi") and int(g.refah) >= int(e.refah_ahi) and int(g.adalet) >= int(e.adalet_ahi): return "ahi_kasabasi"
	return "uc_tutundu"

static func _kademe(v: int) -> String:
	return "yuksek" if v >= int(AYAR.esik.yuksek) else ("dusuk" if v <= int(AYAR.esik.dusuk) else "orta")

## Epilog matrisi: her gösterge için değer + kademeye göre tek cümle.
static func epilog(o: Oturum) -> String:
	var g := gostergeler(o)
	var satirlar: Array[String] = ["Epilog"]
	for ad in ["huzur", "adalet", "refah", "guvenlik", "nufus", "yozlasma"]:
		var m: Dictionary = AYAR.gostergeler[ad]
		satirlar.append("%s %d/100 — %s" % [m.ad, int(g[ad]), m[_kademe(int(g[ad]))]])
	var agir_yas := HaneEsi.agir_yas_satiri(o)
	if not agir_yas.is_empty():
		satirlar.append(agir_yas)
	return "\n".join(satirlar)

## Ana._son_goster adaptörü: mevcut {baslik, metin} sözleşmesi korunur.
static func son_metni(o: Oturum, s: StringName, eski: Dictionary) -> Dictionary:
	if o == null: return eski
	var r := eski.duplicate()
	var n := son(o, s)
	if not n.is_empty():
		r.baslik = String(AYAR.sonlar[n].baslik)
		r.metin = String(AYAR.sonlar[n].metin)
	r.metin = String(r.metin) + "\n\n" + epilog(o)
	r["nihai"] = n
	return r
