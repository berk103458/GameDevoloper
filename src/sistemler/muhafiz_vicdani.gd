## ODA-09: gerçek haksız ret/ölüm sonuçları; vicdan rüyası kanıt/gerçek kimlik değildir.
class_name MuhafizVicdani
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/muhafiz_vicdani.json"))
## Eski/bozuk optional sayaçlar güvenli varsayılanla okunur; kişisel yük köy statı değildir.
static func oku(v: Variant) -> Dictionary:
 var d: Dictionary={"haksiz_ret":0,"olum":0,"yuk":0,"son_gece":-1,"son_kabus":-1}
 if not v is Dictionary: return d
 for key in d:
  var n: Variant=v.get(key)
  if (n is int or n is float) and is_finite(float(n)) and floor(float(n))==float(n) and float(n)>=(-1 if key in ["son_gece","son_kabus"] else 0) and float(n)<=(int(AYAR.yuk_azami) if key=="yuk" else 1000000000): d[key]=int(n)
 return d
## KRI-08 gibi gerçekleşmiş haksızlık: aynı vicdan yükü, ayrı sayaç yok.
static func haksizlik(o,miktar: int) -> void:
 var d:=oku(o.muhafiz_vicdani)
 d.haksiz_ret=mini(1000000000,int(d.haksiz_ret)+1)
 d.yuk=clampi(int(d.yuk)+maxi(0,miktar),0,int(AYAR.yuk_azami))
 o.muhafiz_vicdani=d
## Mevcut ret işleminin aynı kusurlu() ölçütü; engellenmiş karar bu çağrıya ulaşmaz.
static func karar(o: Oturum,g: Gelen,karar_: StringName) -> void:
 if o.yonetim.son!="" or karar_ not in [&"ret",&"elkoy"] or g.kusurlu(): return
 var d:=oku(o.muhafiz_vicdani)
 d.haksiz_ret=mini(1000000000,int(d.haksiz_ret)+1)
 d.yuk=mini(int(AYAR.yuk_azami),int(d.yuk)+int(AYAR.ret_yuk))
 o.muhafiz_vicdani=d
## Gerçek gece ölüm dizisi; neden isnadı veya Clue üretmez, aynı gece tekrar etkisizdir.
static func gece(o: Oturum,r: Dictionary) -> void:
 var d:=oku(o.muhafiz_vicdani)
 var no:=int(r.gun)+1
 if no<=int(d.son_gece): return
 var olen: int=r.olenler.size()
 d.olum=mini(1000000000,int(d.olum)+olen)
 d.yuk=clampi(int(d.yuk)+olen*int(AYAR.olum_yuk)-int(AYAR.gece_sonum),0,int(AYAR.yuk_azami))
 d.son_gece=no
 if int(d.yuk)>=int(AYAR.kabus_esigi) and o.yonetim.son=="":
  d.son_kabus=no
  MuhafizOdaGelisimi.yor(o,int(AYAR.kabus_yorgunluk))
  r.olaylar.append({"anahtar":&"koy.olay.muhafiz_kabus","deger":[],"muhafiz_kabus":{"yuk":d.yuk,"yorgunluk":int(AYAR.kabus_yorgunluk)}})
 o.muhafiz_vicdani=d
## Yalnız bu gece sonrası gün; eski kayıt rüyası yeni günlere taşmaz.
static func aktif(o: Oturum) -> bool:
 return o.yonetim.son=="" and int(oku(o.muhafiz_vicdani).son_kabus)==o.gun
## Aynı sabah raporunda insan metni; rüya suç isnadı değildir.
static func olay_metin(d: Dictionary) -> String:
 return "Gece kabusu: kapı dışında kalanların ve köyde kaybedilenlerin sesleri. Vicdan yükü %d; muhafız yorgunluğu +%d. Bu bir rüya, yeni kanıt veya kimlik bilgisi değil."%[int(d.yuk),int(d.yorgunluk)]
