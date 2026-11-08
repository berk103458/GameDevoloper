# gdlint: disable=max-line-length
## MCL-01 … MCL-09: Çınar meclisinin sesi ve kararları.
## Krizli gecede konuşmacı listesi, karar şikayeti, usta/eş sözü, oy hesaplama.
class_name MeclisSesi
extends RefCounted

const EN_COK := 3

## Kriz KRI-07'nin kendi kapısından okunur; ikinci kriz motoru açılmaz.
static func kriz_var_mi(y: KoyYonetimi) -> bool:
	return not CinarAltiMeclisi._krizler(y).is_empty()

## Konuşan adları: krizsiz gecede boştur. Krizli gecede köy kaydındaki yaşayan
## adaylar kimlik sırasıyla en çok üçe kadar listelenir.
static func konusanlar(y: KoyYonetimi, adaylar: Array = []) -> Array[String]:
	var adlar: Array[String] = []
	if not kriz_var_mi(y): return adlar
	var kimlikler: Array[int] = []
	if adaylar.is_empty():
		for k in y.koylular: kimlikler.append(k.id)
	else:
		for id in adaylar: kimlikler.append(int(id))
	kimlikler.sort()
	for id in kimlikler:
		if adlar.size() >= EN_COK: break
		var k := y.koylu(id)
		if k == null or k.saglik <= 0: continue
		# Kapıdan içeri alınmamış kurucu hane çınar altında konuşmaz.
		if k.bayrak_var("acl01_muhafiz") or k.bayrak_var("acl01_es"): continue
		adlar.append(k.ad)
	return adlar

## Adlı kimse yoksa oylama adsız tek satırla açılır.
static func adsiz_mi(y: KoyYonetimi, adaylar: Array = []) -> bool:
	return kriz_var_mi(y) and konusanlar(y, adaylar).is_empty()

## MCL-02: Şikâyet, bir kararın adını taşır.
static func sikayet_metni(karar_adi: String, konusmaci: String) -> String:
	return "%s: 'Kapıda verdiğin %s kararı köylünün canını yaktı!'" % [konusmaci, karar_adi]

## MCL-03: Eş veya usta söz isterse üç ağzın dışında bir satır alır.
static func usta_veya_es_sozu(rol: String, ad: String) -> Dictionary:
	return {
		"rol": rol,
		"ad": ad,
		"satir": "%s %s: 'Çınarın gölgesinde hak konuşulsun, fitne dağılsın.'" % [rol.capitalize(), ad]
	}

## MCL-04: Oy, duran bir değere yazar (adalet, moral veya asayiş).
static func oyu_uygula(degerler: Dictionary, oy_sonucu: String) -> void:
	match oy_sonucu:
		"kabul":
			degerler["adalet"] = int(degerler.get("adalet", 50)) + 3
		"ret":
			degerler["moral"] = int(degerler.get("moral", 50)) - 2
		"ertele":
			degerler["asayis"] = int(degerler.get("asayis", 50)) - 1

## MCL-05 / OMR-44: Meclis her gece açılmaz. Perde 2'de hafta_basi gecelerinde meclis açılır ve dış hat konusu konuşulur.
## Aynı gecede köy şikâyeti ile dış hat konusu birlikte açılmaz; dış hat varsa konuşulan konu odur.
static func meclis_acik_mi(gun: int, kriz_var: bool, perde: int = 1, mevsim_gun: int = 7, _dis_hat_var: bool = false) -> bool:
	if perde >= 2:
		if Takvim.hafta_basi(gun, mevsim_gun):
			return true
	if not kriz_var:
		return false
	# Her gece açılmaz; kriz varken en çok 2 günde bir açılır
	return (gun % 2 == 1)

static func meclis_konusu(_y: KoyYonetimi, dis_hat_konusu: String = "") -> String:
	if not dis_hat_konusu.is_empty():
		return dis_hat_konusu
	return "koy_sikayeti"

## OMR-44: normal oyun takvimindeki hafta başı, ikinci perdede dış hatlara ayrılır.
static func haftalik_mi(y: KoyYonetimi) -> bool:
	return y.agalik and KoyYonetimi.PERDE_GECISI.baslangic(y) >= 0 and y.son == "" and Takvim.hafta_basi(y.gun, y.a.mevsim_gun)


static func dis_hat_konusu(o: Oturum) -> String:
	var haberler: Array = HaberciAgi.oku(o.haberci_agi).bekleyen
	for hat in Omurga.hat_onceligi():
		for haber in haberler:
			if haber.kaynak == hat and int(haber.gun) <= o.gun: return haber.metin
	return TranslationServer.translate("koy.meclis.haftalik.bos")


## MCL-06: Uygula ve reddet, konuşulan adı söyler.
static func karar_metni(uygula: bool, konusulan_ad: String) -> String:
	if uygula:
		return "Divan hükmü: %s dinlendi, haklı bulundu ve talep uygulandı." % konusulan_ad
	return "Divan hükmü: %s dinlendi amma beylik düzeni gereği talep reddedildi." % konusulan_ad

## MCL-07: En ağır kararın sahibi önce konuşur.
static func agirlik_sirala(kararlar: Array) -> Array:
	var sirali := kararlar.duplicate(true)
	sirali.sort_custom(func(a, b): return int(a.get("agirlik", 0)) > int(b.get("agirlik", 0)))
	return sirali

## MCL-08: Köyde olmayan kişi çınarın altında duramaz.
static func koyde_mi(y: KoyYonetimi, id: int) -> bool:
	var k := y.koylu(id)
	return (k != null and k.saglik > 0)

## MCL-09: Meclis savaş, bina ve son açamaz.
static func eylem_yasak_mi(eylem_turu: String) -> bool:
	return eylem_turu in ["savas", "bina", "son"]
