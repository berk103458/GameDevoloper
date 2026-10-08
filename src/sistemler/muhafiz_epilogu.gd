## ODA-10: mevcut terminal, terazi ve kişisel kasa üzerinden saf muhafız kaderi.
class_name MuhafizEpilogu
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/muhafiz_epilogu.json"))

## Köy sonucundan bağımsız dal; gerçek azil/idam hükmü her zaman önceliklidir.
static func durum(o: Oturum,son: StringName) -> Dictionary:
 if o==null or son not in [&"zafer",&"isyan",&"tekfur",&"halk_kirildi",SancakTeftisi.SON_AZIL,SancakTeftisi.SON_IDAM]: return {}
 var t:=MuhafizTerazisi.durum(o)
 var dal:="evine_donus"
 if son==SancakTeftisi.SON_IDAM: dal="idam"
 elif son==SancakTeftisi.SON_AZIL: dal="azil"
 elif int(t.yozlasma)>=int(AYAR.kacak_yoz):
  dal="venedik_kacagi" if o.muhafiz_akce>=int(AYAR.kacak_akce) else "parasiz_surgun"
 elif int(t.adalet)>=int(AYAR.kahraman_adalet) and int(t.yozlasma)<=int(AYAR.kahraman_yoz_azami): dal="adil_kahraman"
 var d: Dictionary=AYAR.dallar[dal].duplicate(true)
 d.dal=dal
 return d

## Var olan köy anlatısına tek epilogue ekler; ikinci son/para işlemi/kayıt yok.
static func metin(o: Oturum,son: StringName,eski: String) -> String:
 var d:=durum(o,son)
 if d.is_empty(): return eski
 return eski+"\n\nMuhafızın kaderi — "+String(d.baslik)+"\n"+String(d.metin)
