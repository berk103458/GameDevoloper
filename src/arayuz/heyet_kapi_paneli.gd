## HAR-12: aynı karar satırı/sonuç metni; ikinci HUD veya CSV yok.
class_name HeyetKapiPaneli
extends RefCounted
## Mevcut kabul simgesi dinleme; haraç aynı kamu kaynağını gösterir.
static func etiket(k: String) -> String:
 return String(DiplomatikHeyet.AYAR.ode if k=="harc" else DiplomatikHeyet.AYAR.dinle)
## İki kasa ayrımı ve dinlemenin krizi çözmediği açıkça belirtilir.
static func alt(o: Oturum,k: String) -> String:
 return "%d kamu akçesi + %d buğday; kişisel kese kullanılmaz."%[o.yonetim.a.harac_akce,o.yonetim.a.harac_gida] if k=="harc" else String(DiplomatikHeyet.AYAR.dinle_alt)
## Aynı gerçek düğmenin canlı kaynak kilidi; generic kabul davranışı oluşturmaz.
static func kilit(b: Button,o: Oturum,g: Gelen,k: String) -> void:
 if DiplomatikHeyet.ilgilenir(g): b.disabled=not DiplomatikHeyet.karar_olur(o,g,StringName(k))
## Aynı sonuç defteri; heyet köye yeni kişi diye yazılmaz.
static func sonuc(e: KapiEkrani,g: Gelen,s: Dictionary) -> bool:
 if not DiplomatikHeyet.ilgilenir(g): return false
 e._yaz(String(DiplomatikHeyet.AYAR.sonuc_ret if s.engellendi else (DiplomatikHeyet.AYAR.sonuc_ode if s.odendi else DiplomatikHeyet.AYAR.sonuc_dinle)))
 return true
