# Ekran zemin hükmü (GRV-01)

Hüküm, ROADMAP Bölüm 43 tablosunun sağ sütunundan çıkar. `sahne` 3B duruyorsa, `eksik` düz renkse, `tema` kabuk düzlemiyse. İkinci liste yoktur.

| Ekran | Dosya | Zemin bugün | Hüküm |
|---|---|---|---|
| Kök / geçiş | `src/arayuz/ana.gd` | sahne yok, çocuk ekran | eksik |
| Menü | `menu_ekrani.gd`, `menu_satiri.gd`, `menu_susu.gd` | 3B gece + ColorRect | sahne |
| Ayarlar | `ayarlar_ekrani.gd`, `grafik_ayarlari_paneli.gd` | yalnız ColorRect GECE | eksik |
| Yükleme | `varlik_yukleme_paneli.gd` | düz renk, Kabuk zemini | eksik |
| Bilgi, son, duraklat, perde | `bilgi_ekrani.gd` | 3d_kapi / 3d_koy / duraklatta kabuk zemini | sahne |
| Kapı | `kapi_ekrani.gd`, `hud.gd`, `hud_islem_kapisi.gd` | 3B kapı | sahne |
| Kapı parçaları | `chr_diyalog_paneli.gd` ve kapı üstü paneller | kapı sahnesinin üstü | sahne |
| Köy | `koy_ekrani.gd` ve köylü kartı | 3B köy | sahne |
| Harita | `harita_ekrani.gd` | ARY-03 harita | tema |
| Divan | `src/kapi/divan_ekrani.gd` ve panelleri | ayrı ekran | tema |
| Muhafız odası | `muhafiz_odasi_ekrani.gd` ve `oda_*` | oda sahnesi | sahne |
| Mini oyun | `mini_oyun.gd`, `harman_oyunu.gd`, `okculuk_oyunu.gd` | oyun kadrajı | tema |
| Köy HUD | `src/arayuz/koy_hud/*.gd` | köyün üstü | sahne |
| Tema | `tema.gd`, `renkler.gd`, `kabuk.gd` | kaynak | tema |

Gece raporu ayrı ekran değildir. `gece_raporu_ekrani.tscn` yoktur.
