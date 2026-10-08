## TUC-12: mevcut kapı karar satırlarında açık çift kasa bilgisi.
class_name TuccarKapiPaneli
extends RefCounted
## Mevcut karar düğmesinde tüccara uygun başlık.
static func etiket(secim: String) -> String:
 return {"harc": "Resmi geçiş bacını al", "rusvet": "Kişisel rüşvetle hızlı giriş", "ret": "Tüccarı geri çevir"}.get(secim, secim)
## Karar alt satırı resmi/kişisel hedefi tahsilattan önce açıklar.
static func alt(g: Gelen, secim: String) -> String:
 if not TuccarKapiGecisi.ilgilenir(g): return ""
 if secim == "harc": return "%d akçe → köy kasası; resmi geçiş kaydı." % int(TuccarKapiGecisi.AYAR.bac)
 if secim == "rusvet": return "%d akçe → kişisel kese; hızlı pazar girişi, Adalet %d, risk +%d." % [int(TuccarKapiGecisi.AYAR.rusvet), int(TuccarKapiGecisi.AYAR.rusvet_adalet), int(TuccarKapiGecisi.AYAR.rusvet_asayis)]
 return "Tüccarı geri çevir; bu konaklamanın ticareti açılmaz."
## Tüccar bir köylü gibi deftere yazılmaz; diğer karar replikleri korunur.
static func sonuc(e: KapiEkrani, g: Gelen, s: Dictionary) -> bool:
 if not TuccarKapiGecisi.ilgilenir(g): return false
 e._yaz("Tüccarın kapı işlemi engellendi." if s.get("engellendi", false) else ("%s doğrudan pazara geçti. %s" % [g.ad_anahtari, "Kişisel kese" if e.oturum.yonetim.tuccar_girisi.karar == "rusvet" else "Resmi köy bacı"] if s.kaldi else "%s bu konaklama boyunca geri çevrildi." % g.ad_anahtari))
 return true
