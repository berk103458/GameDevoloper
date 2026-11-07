## ODA-07: tek gece makbuzu, gerçek kişisel kasa ve mevcut yozlaşmayla sancak teftişi.
class_name SancakTeftisi
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/sancak_teftisi.json"))
const SON_AZIL:=&"muhafiz_azil"
const SON_IDAM:=&"muhafiz_idam"

## Optional makbuz güvenli okunur; eski kayıt teftişsiz başlar, sahte sonuç terminal üretmez.
static func oku(v: Variant) -> Dictionary:
 var d: Dictionary={"son_gece":-1,"sonuc":"","bulundu":false,"yozlasma":0,"akce":0,"esya":0,"zar":-1}
 if not v is Dictionary: return d
 for key in ["son_gece","yozlasma","akce","esya"]:
  var n: Variant=v.get(key)
  if (n is int or n is float) and is_finite(float(n)) and floor(float(n))==float(n) and float(n)>=(-1 if key=="son_gece" else 0) and float(n)<=1000000000: d[key]=int(n)
 if v.get("sonuc","") in ["temiz","bulunamadi",String(SON_AZIL),String(SON_IDAM)]: d.sonuc=v.sonuc
 d.bulundu=v.get("bulundu") is bool and v.bulundu
 if v.get("ulak_bildirdi", false) == true: d.ulak_bildirdi=true
 var zar: Variant=v.get("zar")
 if (zar is int or zar is float) and is_finite(float(zar)) and floor(float(zar))==float(zar) and float(zar)>=0 and float(zar)<int(AYAR.zar_cozunurlugu): d.zar=int(zar)
 return d

## Kasa kapağı/oda açık mı okunmaz; tek gerçek bakiye ve pozitif eşya kayıtları sayılır.
static func kasa(o: Oturum) -> Dictionary:
 var n:=0
 for e in o.muhafiz_esyalari:
  if int(e.get("adet",0))>0: n+=1
 return {"akce":maxi(0,o.muhafiz_akce),"esya":n}

## Biten gece insan sayımıyla değerlendirilir; kamu parasının varlığı suç değildir.
static func gece(o: Oturum,r: Dictionary) -> void:
 var gece_no:=int(r.gun)+1
 var d:=oku(o.sancak_teftisi)
 if o.yonetim.son!="" or gece_no<int(AYAR.ilk_gece) or (gece_no-int(AYAR.ilk_gece))%int(AYAR.aralik)!=0 or gece_no<=int(d.son_gece): return
 var k:=kasa(o)
 var yoz:=int(MuhafizTerazisi.durum(o).yozlasma)
 d={"son_gece":gece_no,"sonuc":"temiz","bulundu":false,"yozlasma":yoz,"akce":mini(int(k.akce),1000000000),"esya":mini(int(k.esya),1000000000),"zar":-1}
 if yoz>=int(AYAR.yozlasma_esigi) and (int(k.akce)>0 or int(k.esya)>0):
  d.zar=o._rng.randi_range(0,int(AYAR.zar_cozunurlugu)-1)
  d.bulundu=int(d.zar)<int(round(float(AYAR.bulma_olasiligi)*int(AYAR.zar_cozunurlugu)))
  d.sonuc=String(SON_IDAM if yoz>=int(AYAR.idam_esigi) else SON_AZIL) if d.bulundu else "bulunamadi"
  if d.bulundu:
   o.yonetim.son=String(d.sonuc)
   r.son=o.yonetim.son
 o.sancak_teftisi=d
 r.olaylar.append({"anahtar":&"koy.olay.sancak_teftisi","deger":[],"sancak_teftisi":d.duplicate(true)})

## Aynı sabah kartının olay metni; içerik ikinci kasaya veya Clue'a dönüştürülmez.
static func olay_metin(d: Dictionary) -> String:
 match String(d.sonuc):
  "temiz": return TranslationServer.translate("koy.sancak.temiz")
  "bulunamadi": return TranslationServer.translate("koy.sancak.bulunamadi")
  String(SON_IDAM): return TranslationServer.translate("koy.sancak.idam")
  _: return TranslationServer.translate("koy.sancak.azil")

## Mevcut Ana/BilgiEkrani son yüzeyine özel başlık; diğer sonlar eski çeviriyi korur.
static func son_metni(son: StringName) -> Dictionary:
 if son==SON_AZIL: return {"baslik":TranslationServer.translate("koy.sancak.son_azil_baslik"),"metin":TranslationServer.translate("koy.sancak.son_azil_metin")}
 if son==SON_IDAM: return {"baslik":TranslationServer.translate("koy.sancak.son_idam_baslik"),"metin":TranslationServer.translate("koy.sancak.son_idam_metin")}
 return {"baslik":TranslationServer.translate("arayuz.son."+String(son)),"metin":TranslationServer.translate("arayuz.son.%s_metin"%son)}

## Oda içindeki tek bilgilendirme satırı; alım/arama veya ek kayıt işlemi yok.
static func tip(o: Oturum) -> String:
 var n:=int(AYAR.ilk_gece)
 var son:=maxi(o.gun,int(oku(o.sancak_teftisi).son_gece))
 if n<=son: n+=(floori(float(son-n)/int(AYAR.aralik))+1)*int(AYAR.aralik)
 return TranslationServer.translate("koy.sancak.tip")%[n,int(AYAR.yozlasma_esigi),int(round(float(AYAR.bulma_olasiligi)*100)),int(AYAR.idam_esigi)]
