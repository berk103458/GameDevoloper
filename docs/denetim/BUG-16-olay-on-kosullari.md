# BUG-16 olay ön koşul taraması (Kalfa)

11 Ekim 2026. Başlık ve açılış metnindeki mevcut bina adları denetlenir. Pazar = mevcut atölye, kervansaray = mevcut ambar adaptörü; samanlık = ambar deposu, tezgâh = atölye, harman yeri = tarla. Yeni bina sistemi yok. Kayseri Ahi ocağı dış yer/gelecek önerisidir; köy binası koşulu değildir. Seçeneklerdeki ambar sayısı kaynak birimidir.

Tanınmayan koşul içerik doğrulama hatasıdır; runtime kartı kapatır. Hazır olmayan bina yeterli değildir. Yaş ve nüfus mevcut köylü kaydından okunur. Aynı denetim her seçimde yeniden yapılır; RNG çekmez. Asset gerekmedi.

| Kart | Koşullar | Denetim |
| --- | --- | --- |
| ahi_haber.tres | `{"bayrak": ["ahi_ocagi"]}` | Geçti |
| aydogdu_oba.tres | `{"koyde": ["aydogdu"], "gece_min": 2}` | Geçti |
| ayse_tezgah.tres | `{"koyde": ["ayse_baci"], "bina_var": ["atolye"]}` | Geçti |
| bebek.tres | `{"nufus_min": 6, "gece_min": 4, "yas_grubu": "yetiskin"}` | Geçti |
| bey_daveti.tres | `{"bar_min": {"1": 7}, "gece_min": 5}` | Geçti |
| dervis.tres | `{"gece_min": 2}` | Geçti |
| dugun.tres | `{"nufus_min": 6, "yas_grubu": "yetiskin"}` | Geçti |
| ertugrul_haberi.tres | `{"perde": 2, "gece_min": 2}` | Geçti |
| harman.tres | `{"sinif_min": {"ciftci": 3}, "gece_min": 3, "bina_var": ["tarla"]}` | Geçti |
| hasan_defter.tres | `{"koyde": ["hasan_celebi"]}` | Geçti |
| hirsizlik.tres | `{"sinif_min": {"esnaf": 2}, "bina_var": ["pazar"]}` | Geçti |
| kacak_koylu.tres | `{"perde": 2, "nufus_min": 8}` | Geçti |
| karaca_ocak.tres | `{"koyde": ["karaca_usta"], "yapi_min": {"pazar": 1}}` | Geçti |
| kervan.tres | `{"yapi_min": {"kervansaray": 1}}` | Geçti |
| kitlik.tres | `{"ambar_max": 2, "nufus_min": 4, "bina_var": ["ambar"]}` | Geçti |
| kurt.tres | `{"gece_min": 3, "bina_var": ["agil"]}` | Geçti |
| miraen_cavus.tres | `{"koyde": ["miraen"], "gece_min": 3}` | Geçti |
| mogol_duman.tres | `{"gece_min": 4, "gece_max": 12}` | Geçti |
| nogay_haber.tres | `{"koyde": ["nogay"], "gece_min": 4}` | Geçti |
| okculuk.tres | `{"sinif_min": {"asker": 2}, "gece_min": 2, "bina_var": ["muhafiz_kislasi"], "yas_grubu": "yetiskin"}` | Geçti |
| pazar_gunu.tres | `{"yapi_min": {"pazar": 1}, "gece_min": 2}` | Geçti |
| salgin.tres | `{"nufus_min": 7, "cocuk_var": true, "yas_grubu": "yasli"}` | Geçti |
| saruca_tohum.tres | `{"koyde": ["saruca_hatun"], "gece_min": 3, "bina_var": ["ambar"]}` | Geçti |
| sorhan_damga.tres | `{"koyde": ["sorhan"], "gece_min": 2}` | Geçti |
| sur_catlak.tres | `{"perde": 2, "bina_var": ["sur"]}` | Geçti |
| tarla_cekirge.tres | `{"tarla_ekili_min": 1, "gece_min": 3}` | Geçti |
| tarla_don.tres | `{"tarla_ekili_min": 1, "gece_min": 4}` | Geçti |
| tarla_kuraklik.tres | `{"tarla_ekili_min": 1, "gece_min": 2}` | Geçti |
| tarla_yagmur.tres | `{"tarla_ekili_min": 1}` | Geçti |
| tekfur_elcisi.tres | `{"perde": 2}` | Geçti |
| thessra_afyon.tres | `{"koyde": ["thessra"], "gece_min": 3, "bina_var": ["degirmen"]}` | Geçti |
| vergi_tahsildari.tres | `{"gece_min": 3, "perde": 1}` | Geçti |
| yangin.tres | `{"nufus_min": 5, "gece_min": 2, "bina_var": ["ambar"]}` | Geçti |
| yusuf_keci.tres | `{"koyde": ["yusuf"], "gece_min": 2}` | Geçti |
