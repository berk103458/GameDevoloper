## ODA-06: aynı yetenek kaydından heybe inceleme ve mevcut isyan eşiği uzantısı.
class_name MuhafizAdaletYetenekleri
extends RefCounted
const ETKIN:=&"muhafiz_gonul_bagi"

## Hazır CHR panelinin aynı nişan eylemini kullanır; yük/görsel iz otomatik bulunmaz.
static func chr_incele(o: Oturum,panel: Control) -> void:
 if o!=null and MuhafizYetenekleri.var_mi(o,"keskin_bakis"): panel.call("_nesne_incele",1)

## Eski heybenin mevcut keşif API'si; seçim/el koyma/para işlemi yapılmaz.
static func heybe_incele(o: Oturum,h: Heybe) -> bool:
 if h==null or not MuhafizYetenekleri.var_mi(o,"keskin_bakis"): return false
 return not h.astar_yokla().is_empty()

## Yalnız türetilmiş runtime işareti; kayıt alanı/ikinci sahiplik motoru değildir.
static func bagla(o: Oturum) -> void:
 var a:=MuhafizYetenekleri.AYAR
 var t:=MuhafizTerazisi.durum(o)
 o.yonetim.set_meta(ETKIN,MuhafizYetenekleri.var_mi(o,"gonul_bagi") and int(t.yozlasma)<=int(a.gonul_yozlasma_azami))

## Gece içindeki adalet değişimini işlem anında denetler; aynı isyan sayacı/RNG sürer.
static func isyan_esigi(y: KoyYonetimi,taban: int) -> int:
 var a:=MuhafizYetenekleri.AYAR
 if bool(y.get_meta(ETKIN,false)) and y.adalet>=int(a.gonul_adalet): return mini(taban,int(a.gonul_isyan_esigi))
 return taban
