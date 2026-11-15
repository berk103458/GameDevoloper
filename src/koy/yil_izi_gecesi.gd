## YIL-01 … YIL-10 oyun bağı: gece raporuna yılın yüzünün mevsim satırı ve yıl kapanış sayımı.
## Bağlam yalnız duran kayıtlardan okunur (MEV-06 bent, MEV-08 şenlik, ev, iş yeri); hiçbirine yazılmaz.
class_name YilIziGecesi
extends RefCounted

const KAPANIS := "Yıl kapandı; %s yıl boyu %d mevsim sözü bıraktı."


static func kisi(y: KoyYonetimi) -> Koylu:
	var kim := String(YilIzi.durum(y).kisi)
	if kim == "":
		return null
	for k in y.koylular:
		if String(k.adli_id) == kim:
			return k
	return null


static func tarlada(y: KoyYonetimi, k: Koylu) -> bool:
	if k == null:
		return false
	if k.bayrak_var("tarla"):
		return true
	for id in [k.is_yeri, k.kis_oncesi_is]:
		var b := y.bina(int(id))
		if b != null and b.tur == "tarla":
			return true
	return false


static func baglam(y: KoyYonetimi, k: Koylu) -> Dictionary:
	var tak := MevsimYoneticisi.durum(y)
	var senlik := HasatSenligi.son_yil(y) == int(tak.yil)
	return {"senlik": senlik, "ambar_dolu": senlik, "yatak": k != null and k.ev >= 0, "tarla": tarlada(y, k), "taskin": bool(IlkbaharTaskini.durum(y).hasar)}


static func gece(y: KoyYonetimi, olaylar: Array) -> void:
	if y.son != "":
		return
	YilIzi.sec(y, y.gun)
	var k := kisi(y)
	if k != null:
		var d := YilIzi.durum(y)
		d.maske = SevilenYuz.maske_kisa_adi(k) if k.bayrak_var(SevilenYuz.MASKE_BAYRAGI) else k.ad
		d.gercek = k.ad
		d.ad_bayragi = not k.bayrak_var(SevilenYuz.MASKE_BAYRAGI) or k.bayrak_var(SevilenYuz.KIMLIK_BAYRAGI) or k.bayrak_var("acl01_es")
		y.set_meta(YilIzi.META, d)
		var gecmis: Variant = d.slotlar.get(String(MevsimYoneticisi.durum(y).ad) + "_satir")
		var once := String(gecmis.get("anahtar", "")) if gecmis is Dictionary else ""
		var s := YilIzi.satir(y, baglam(y, k))
		if String(s.anahtar) != "" and String(s.anahtar) != once:
			olaylar.append({"anahtar": "%s: %s", "deger": [String(s.ad), TranslationServer.translate(String(s.anahtar))]})
	var ad := YilIzi.gorunen_ad(y)
	var son := YilIzi.kapanis(y, String(y.son))
	if int(son.sayi) > 0 and ad != "":
		olaylar.append({"anahtar": KAPANIS, "deger": [ad, int(son.sayi)]})
