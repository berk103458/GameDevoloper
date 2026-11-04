# KVR-SES-01: Kod ve Sistem Notu

## Kod Gerekir mi?
- **ÇOK AZ (1-2 Satırlık İnce Adaptör).**
- `src/arayuz/kapi_ekrani.gd` içinde `_ziyaretci_acilis_metni_goster()` çağrılırken:
  ```gdscript
  var hava = Oturum.hava_durumu if "hava_durumu" in Oturum else "acik"
  var on_ek = HavaReplikleri.on_ek_getir(hava)
  replik_etiketi.text = on_ek + " " + asil_replik
  ```
- **Kimin İşi?:** Kod eklemesi Cursor (arayüz/kapı ekranı). Replik ve metinler Antigravity.
