## TUC-01: saf takvimi mevcut pazar paneline bağlar.
class_name GezginTuccarPazarAdaptoru
extends RefCounted

## Mevcut pazar paneline tek durum satırı ekler; alım/satım API'sini değiştirmez.
static func pazar(e: KoyEkrani, kok: VBoxContainer) -> Label:
 var d := GezginTuccarTakvimi.durum(e._y.gun, e._y.a.kervan_araligi)
 var metin := "%s · %s · pazarda %d gün daha" % [d.tuccar.ad, d.tuccar.uzmanlik, d.kalan] if d.aktif else "Sonraki gezgin: %s · %d. gün" % [d.sonraki_tuccar.ad, d.sonraki_gun]
 var l := e._etiket(kok, metin, Tema.KUCUK_PX)
 if TuccarKapiGecisi.engel(e._y): l.text = "%s · %s" % [d.tuccar.ad, "kapı kararı bekleniyor" if e._y.tuccar_girisi.karar == "bekliyor" else "bu konaklamada geri çevrildi"]
 l.name = "gezgin_tuccar_durumu"
 l.add_theme_color_override("font_color", Renkler.SOGUK_MAVI)
 SiparisIhlalPaneli.durum(e, l)
 SiparisSozlesmePaneli.kapi(e, kok, l)
 KervanKorumaPaneli.ekle(e, kok)
 GocYoluPaneli.ekle(e, kok)
 ObaIttifakPaneli.ekle(e, kok)
 return l
