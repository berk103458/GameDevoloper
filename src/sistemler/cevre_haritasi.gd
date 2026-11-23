## HAR-01: şematik çevre noktaları ve mevcut köy durumunun saf görünümü.
class_name CevreHaritasi
extends RefCounted
static var AYAR: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/cevre_haritasi.json"))
static var MANZARA: Dictionary=JSON.parse_string(FileAccess.get_file_as_string("res://data/cevre_manzara.json")) if FileAccess.file_exists("res://data/cevre_manzara.json") else {}
const MAP_KOK := "res://assets/art/map/"
## Harita yerleşimi dışarıya kopya verilir; konumlar gerçek coğrafi mesafe değildir.
static func bolgeler() -> Array:
 return AYAR.bolgeler.duplicate(true)
## Yalnız mevcut sayaçlar okunur; diplomasi/tehdit olayı veya kuyruk oluşturulmaz.
static func bilgi(o: Oturum,id: String) -> Dictionary:
 if o==null: return {}
 for b in AYAR.bolgeler:
  if String(b.id)!=id: continue
  var s:=String(b.metin)
  if id=="hisar": s+="\n\nGün: %d · Nüfus: %d\n\n"%[o.gosterilen_gece(),o.yonetim.nufus()]+MogolOncusu.metin(o)+"\n\n"+GozcuOngoru.metin(o)
  elif id=="tekfur": s+="\n\nTekfur baskısı: %d\nSavuşturulan baskın: %d"%[o.yonetim.tekfur_baski,o.yonetim.savusturulan]
  elif id=="goc_yolu": s+="\n\n"+GocYoluGuvenligi.tip(o)
  return {"ad":String(b.ad),"metin":s}
 return {}
static func kayit(id: String) -> Dictionary:
 for b in AYAR.bolgeler:
  if String(b.id)==id: return b
 return {}
static func katmanlar() -> Dictionary:
 return (AYAR.get("katmanlar", {}) as Dictionary).duplicate(true)
static func rotalar() -> Array:
 var k: Variant=AYAR.get("rotalar", [])
 return k.duplicate(true) if k is Array else []
static func yakinlastirma() -> Dictionary:
 var k: Variant=AYAR.get("yakinlastirma", {})
 return k.duplicate(true) if k is Dictionary else {"min":0.85,"varsayilan":1.0,"max":1.85,"adim":0.15}
## Salt okunur bölge görünümü; oturuma yazılmaz.
static func bolge_durumu(o: Oturum,id: String) -> Dictionary:
 var b:=kayit(id)
 if b.is_empty() or o==null: return {}
 var bilgi_d:=bilgi(o,id)
 var olaylar:=_olaylar(o,id)
 var tehlike:=_tehlike(o,id,olaylar)
 var kes:=kesfedildi_mi(o,id)
 var muhur:=_muhur(o,id,olaylar,tehlike,kes)
 var d: Dictionary={
  "ad":String(b.ad),
  "metin":String(bilgi_d.get("metin", b.metin)),
  "tooltip":String(b.get("tooltip_ozet", b.ad)),
  "durum":"tehlike" if tehlike else "normal",
  "olaylar":olaylar,
  "muhur":muhur,
  "kesfedildi":kes,
  "tur":String(b.get("tur", id)),
  "ikon_normal":String(b.get("ikon_normal", "")),
  "ikon_secili":String(b.get("ikon_secili", "")),
  "ikon_tehlike":String(b.get("ikon_tehlike", "")),
  "manzara":manzara(o,id)
 }
 return d
static func kesfedildi_mi(o: Oturum,id: String) -> bool:
 var b:=kayit(id)
 if b.is_empty(): return false
 if bool(b.get("kesfedildi_varsayilan", true)): return true
 if o==null or o.yonetim==null: return false
 return GozcuKulesi.aktif(o.yonetim)
static func mevsim_katmani(o: Oturum) -> String:
 var ad:="ilkbahar"
 if o!=null and o.yonetim!=null:
  ad=String(MevsimYoneticisi.durum(o.yonetim).get("ad", "ilkbahar"))
 var yol: Variant=(AYAR.get("katmanlar", {}) as Dictionary).get("mevsimler", {})
 if yol is Dictionary: return String((yol as Dictionary).get(ad, ""))
 return ""
static func yol_kapali(o: Oturum) -> bool:
 if o==null: return false
 var d:=DunyaZamani.durum(o)
 var etkiler: Variant=d.get("etkiler", {})
 if etkiler is Dictionary and (etkiler as Dictionary).has("ticaret_yolunun_kapanmasi"): return true
 return DunyaZamani.isaret_var_mi(o, "ticaret_yolunun_kapanmasi")
static func kopru_yikik_mi(o: Oturum) -> bool:
 return yol_kapali(o)
## Aktif olay veya mevsim varyantı; yoksa bölge temeli. Oturuma yazılmaz.
static func manzara(o: Oturum,id: String) -> String:
 var b:=kayit(id)
 var temel:=String(b.get("manzara_gorsel", ""))
 if temel.is_empty() and MANZARA.get("temel") is Dictionary:
  temel=String((MANZARA.temel as Dictionary).get(id, ""))
 if o==null: return temel
 var anahtarlar:=_manzara_anahtarlari(o,id)
 var varyantlar: Variant=MANZARA.get("varyantlar", [])
 if varyantlar is Array:
  for v in varyantlar:
   if not v is Dictionary: continue
   if String(v.get("bolge", ""))!=id: continue
   var tetik: Variant=v.get("tetik", [])
   if tetik is Array:
    for t in tetik:
     if String(t) in anahtarlar:
      return String(v.get("dosya", temel))
 return temel
static func _dunya_etkin(o: Oturum,oid: String) -> bool:
 if o==null: return false
 var d:=DunyaZamani.durum(o)
 var etkiler: Variant=d.get("etkiler", {})
 if etkiler is Dictionary and (etkiler as Dictionary).has(oid): return true
 var uygulanan: Variant=d.get("etki_uygulananlar", [])
 if uygulanan is Array and oid in uygulanan: return true
 return DunyaZamani.isaret_var_mi(o, oid)
static func _mogol_durum(o: Oturum) -> Dictionary:
 var ay:=MogolOncusu._ayar()
 if not (ay is Dictionary) or not ay.has("varis_gunu"):
  return {"kalan":999,"sinirda":false,"ad":""}
 return MogolOncusu.durum(o)
static func _olaylar(o: Oturum,id: String) -> Array:
 var a: Array=[]
 var y:=o.yonetim
 var tur:=String(kayit(id).get("tur", id))
 if id=="mogol" or id=="hisar":
  var md: Dictionary=_mogol_durum(o)
  var kalan:=int(md.get("kalan", 999))
  var sinirda:=bool(md.get("sinirda", false))
  if kalan<=5 or sinirda:
   _ekle(a, "mogol_akin")
 if id=="tekfur":
  if y.harac_bekliyor or int(y.tekfur_baski)>0: _ekle(a, "heyet")
 if id=="karaboran" or id=="goc_yolu":
  if y.husumet.puan>=y.a.sizma_esigi: _ekle(a, "pusu")
 if id=="goc_yolu":
  if int(GocYoluGuvenligi.oku(o.goc_yolu_guvenligi).bekleyen)>0 and not yol_kapali(o): _ekle(a, "kervan")
 if id=="hisar" or id=="koy":
  if _yangin(y): _ekle(a, "yangin")
  if bool(IlkbaharTaskini.durum(y).get("hasar", false)): _ekle(a, "taskin")
  if _kurt_bu_gece(y): _ekle(a, "baskin")
  if _hastalik(y): _ekle(a, "salgin")
  if _dunya_etkin(o, "salgin_dalgasi"): _ekle(a, "salgin")
  if _dunya_etkin(o, "kitlik_yili"): _ekle(a, "kitlik")
 var haber:=HaberciAgi.oku(o.haberci_agi)
 if haber.get("bekleyen") is Array:
  for h in haber.bekleyen:
   if not h is Dictionary: continue
   var kaynak:=String(h.get("kaynak", ""))
   if (kaynak=="mogol" and (id=="mogol" or id=="hisar")) or (kaynak=="tekfur" and id=="tekfur") or (kaynak=="cete" and (id=="karaboran" or id=="hisar")):
    _ekle(a, "ulak")
 return a
static func _tehlike(o: Oturum,id: String,olaylar: Array) -> bool:
 var y:=o.yonetim
 if id=="mogol":
  var md: Dictionary=_mogol_durum(o)
  return int(md.get("kalan", 999))<=5 or bool(md.get("sinirda", false))
 if id=="hisar":
  var md2: Dictionary=_mogol_durum(o)
  if bool(md2.get("sinirda", false)): return true
 if id=="tekfur":
  return y.harac_bekliyor or int(y.tekfur_baski)>0
 if id=="karaboran" or id=="goc_yolu":
  if y.husumet.puan>=y.a.sizma_esigi: return true
  if id=="goc_yolu" and yol_kapali(o): return true
 if "yangin" in olaylar or "taskin" in olaylar or "baskin" in olaylar or "mogol_akin" in olaylar or "pusu" in olaylar:
  return true
 return false
static func _muhur(o: Oturum,id: String,olaylar: Array,tehlike: bool,kes: bool) -> String:
 if id=="goc_yolu" and yol_kapali(o): return "kapali_yol"
 if id=="tekfur" and (o.yonetim.harac_bekliyor or int(o.yonetim.tekfur_baski)>0): return "harac"
 if tehlike: return "tehlike"
 if id=="oba" and ObaIttifaki.muttefik(o): return "guvenli"
 if id=="goc_yolu" and "kervan" in olaylar: return "guvenli"
 var b:=kayit(id)
 if kes and not bool(b.get("kesfedildi_varsayilan", true)): return "kesfedildi"
 return ""
static func _yangin(y: KoyYonetimi) -> bool:
 var su:=SuDengesi.durum(y)
 if int(su.get("yangin_gun", -1))==y.gun: return true
 var ambar:=AmbarKundaklamasi.durum(y)
 return int(ambar.get("son_gece", -1))==y.gun
static func _kurt_bu_gece(y: KoyYonetimi) -> bool:
 return KurtBaskini.oku(y.get_meta(KurtBaskini.META, -1))==y.gun
static func _hastalik(y: KoyYonetimi) -> bool:
 for k in y.koylular:
  if KisHastaligi.hasta(k): return true
 return false
static func _manzara_anahtarlari(o: Oturum,id: String) -> Array:
 var a:=_olaylar(o,id).duplicate()
 var y:=o.yonetim
 if y==null: return a
 var hava:=String(IklimDeneyi.hava(y))
 var mevsim_ad:=String(MevsimYoneticisi.durum(y).get("ad", ""))
 if id=="hisar":
  if hava=="kuraklik" or _dunya_etkin(o, "kitlik_yili"): _ekle(a, "kuraklik")
  if hava=="yagmur": _ekle(a, "yagmur")
  if hava=="kar_firtinasi" or mevsim_ad=="kis": _ekle(a, "kar")
 if id=="goc_yolu" and String(GocYoluGuvenligi.oku(o.goc_yolu_guvenligi).get("sonuc", ""))=="basarisiz":
  _ekle(a, "pusu")
 return a
static func _ekle(a: Array,k: String) -> void:
 if not k in a: a.append(k)
