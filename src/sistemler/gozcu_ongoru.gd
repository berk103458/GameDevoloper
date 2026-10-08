## HAR-06: aynı runtime'ın izole ertesi gece öngörüsü; kaynak kuyruğuna yazmaz.
class_name GozcuOngoru
extends RefCounted
## Dönen yalnız public isim/sınıf kopyalarıdır; olay kararları değişirse kesin varış iddiası yoktur.
static func durum(o: Oturum) -> Dictionary:
	var d := {"aktif":false,"gun":o.gun+1,"adaylar":[],"not":String(GozcuKulesi.AYAR.kapali)}
	if not GozcuKulesi.aktif(o.yonetim): return d
	d.aktif=true
	d.not=String(GozcuKulesi.AYAR.not)
	var z:=Oturum.kayittan(o.katalog,JSON.parse_string(JSON.stringify(o.kaydet())))
	# Oyun/bina Resource ayarları izole edilir; katalog salt okunur paylaşılır.
	z.ayarlar=o.ayarlar.duplicate(true)
	z.yonetim.a=o.yonetim.a.duplicate(true)
	z.gece_sonu()
	if z.yonetim.son!="":
		d.not=String(GozcuKulesi.AYAR.belirsiz)+" "+String(GozcuKulesi.AYAR.not)
		return d
	for g in z.gece_kuyrugu().slice(0,int(GozcuKulesi.AYAR.azami_aday)):
		d.adaylar.append({"ad":z.tr_gelen(g),"sinif":z.tr_ad(g.sinif)})
	return d
## Mevcut Hisar bilgi alanı; okuma ekonomik durum veya kaynak RNG'ye yazmaz.
static func metin(o: Oturum) -> String:
	var d:=durum(o)
	if not d.aktif: return String(d.not)
	var satirlar:=PackedStringArray([String(GozcuKulesi.AYAR.baslik)%(int(d.gun)+1)])
	for a in d.adaylar: satirlar.append("%s · %s"%[a.ad,a.sinif])
	satirlar.append(String(d.not))
	return "\n".join(satirlar)
