## TUC-07: aynı defterde ceza ödemesi ve aynı pazar durum satırında ayrılış.
class_name SiparisIhlalPaneli
extends RefCounted
## Ayrılan tüccarı takvimde konaklıyor gibi göstermez.
static func durum(e: KoyEkrani, l: Label) -> void:
 var d := GezginTuccarTakvimi.durum(e._y.gun, e._y.a.kervan_araligi)
 if d.aktif and SiparisIhlali.terk(e._y, d.tuccar.id): l.text = "%s sipariş ihlali nedeniyle ticareti reddediyor; defterden cezayı öde." % d.tuccar.ad
## Tüccar başına tek borç satırı; ödeme doğrudan model koşullarını tekrar kullanır.
static func ekle(e: KoyEkrani, ust: Control) -> void:
 var y := e._y
 for id in y.tuccar_cezasi:
  var t: String = id
  var c: Dictionary = y.tuccar_cezasi[t]
  if int(c.borc) == 0 and not SiparisIhlali.terk(y, t): continue
  var ad := t
  for uzman in GezginTuccarTakvimi.AYAR.uzmanlar:
   if uzman.id == t: ad = uzman.ad
  e._etiket(ust, "%s · Borç %d akçe · En erken dönüş %d. gün · gecelik faiz %d%%" % [ad, c.borc, c.donus, roundi(float(SiparisIhlali.AYAR.gecelik_faiz) * 100)], Tema.KUCUK_PX)
  var d := e._dugme("Ceza öde · %d akçe" % mini(maxi(0, y.akce), int(c.borc)), ust)
  d.name = "siparis_ceza_" + t
  d.disabled = int(c.borc) == 0 or y.akce <= 0
  d.pressed.connect(func() -> void:
   if SiparisIhlali.ode(y, t) > 0:
    e.hud.guncelle()
    SiparisSozlesmePaneli.ac(e))
