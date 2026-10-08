## ODA-04: mevcut makbuzlardan hesaplanan tek adalet/yozlaşma terazisi; kişisel bakiye suç sayılmaz.
class_name MuhafizTerazisi
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/muhafiz_terazisi.json"))

## Saf görünüm; rüşvet sayısı, zimmet toplamı ve onarılmamış haksızlık makbuzları kaynak kalır.
static func durum(o: Oturum) -> Dictionary:
 var rusvet:=_sayi(o.bayraklar.get(&"rusvet_sayisi",0))
 var zimmet:=int(KasaTransferi.oku(o.kasa_transferleri).zimmet_toplam)
 var haksizlik:=0
 var makbuz:=DivanHaksizligi.durum(o.yonetim)
 for k in makbuz:
  if not makbuz[k].odendi: haksizlik+=1
 var yoz:=clampi(int(rusvet*float(AYAR.rusvet_agirlik)+zimmet*float(AYAR.zimmet_agirlik)+haksizlik*float(AYAR.haksizlik_agirlik)),0,100)
 var adalet:=clampi(o.yonetim.adalet,0,100)
 var denge:=clampi(int(round(float(AYAR.denge_merkez)+(adalet-yoz)*float(AYAR.denge_carpan))),0,100)
 var unvan:="Kararsız muhafız"
 if denge>=int(AYAR.adil_esik): unvan="Adil muhafız"
 elif denge<=int(AYAR.yoz_esik): unvan="Yozlaşmış derebeyi"
 return {"adalet":adalet,"yozlasma":yoz,"denge":denge,"unvan":unvan,"rusvet":rusvet,"zimmet":zimmet,"haksizlik":haksizlik}

static func _sayi(v: Variant) -> int:
 if not (v is int or v is float) or not is_finite(float(v)) or float(v)<0 or floor(float(v))!=float(v): return 0
 return int(minf(float(v),1000000000.0))
