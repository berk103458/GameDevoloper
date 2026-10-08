# Clue → Divan tek devam sözleşmesi — CAS-11 / CAS-15

## Overview
CAS06'da eklenen DivanKanit köprüsü artık tüm30 CHR için doğrulanmış kalıcı devam sözleşmesidir; ikinci kart, keşif veya suç deposu yok.

## Player Fantasy
Kapıda gerçekten bulduğun izlerin köy duruşmasına aynı kimlik ve açıklamayla gelmesi.

## Detailed Rules
IpucuYoneticisi/ChrSorgusu ziyaretin tek keşif kaynağıdır. Kabulde aynı adlı kişi için bulunan true Clue kimlikleri DivanKanit optional Koylu metadata'sına devam eder. Bu metadata yalnız bulunan/sunulan kimlikler ve geçerli itiraf makbuzudur; açıklama/source Resource kopyası değildir. Kaynak üç obje_1/obje_2/gorsel_hata_ipucu alanından okunur; CHR/CSV adları değiştirilmez.

Köprü tekrar çağrılınca zaten sunulmuş/itiraf edilmiş ilerleme silinmez. Başka kişinin ziyareti köylü kaydını sıfırlamaz veya yabancı Clue taşımaz. Kaynak açıklamalar readonly; mutasyon kopya üzerine yapılır. Sunulan kimlikler bulunanların altkümesidir. Gerçek gözlenen fiil yoksa itiraf yapılamaz; CAS10 imzasız iddiası bu sözleşmeyi aşamaz.

### CAS-15: sahiplik ve örtüşme

| Aşama | Yetkili kayıt / gerçek dosya | Sınır |
| --- | --- | --- |
| Kapıda keşif | `src/kapi/ipucu_yoneticisi.gd`, mevcut `ChrSorgusu.ipuclari` | Ziyaret başına gerçek true Clue kimlikleri; kopya okuma keşif üretmez. |
| Kabul bağlantısı | `src/sistemler/oturum.gd`, `DivanKanit.devral(k, gelen)` | Aynı kabul edilmiş CHR kişisine bir kez devam; tekrar birleşim idempotenttir. Retten hayali köylü oluşmaz. |
| Köylüde kalıcılık | `src/koy/koylu.gd`, optional `divan_kanit` | Yalnız geçerli bulunan/sunulan kimlikler ve itiraf; ziyaret tamamlandığında keşfin devam kaydıdır, paralel keşif deposu değildir. |
| Açıklama kaynağı | `src/kapi/divan_kanit.gd`, `KarakterVerisi` | CHR obje_1/obje_2/görsel alanları readonly; açıklama, bayrak veya Resource kopyası saklanmaz. |
| Divanda kart ve sunma | `src/kapi/divan_sorgu_paneli.gd`, `src/kapi/divan_kanit_karti.gd` | Aynı listedeki UI düğümleri; düğüm metadata'sı yalnız kart kimliğidir, oyun kayıt deposu değildir. |
| Gerçek gözlem | `src/koy/casus_gece_takibi.gd`, `DivanOturumu.izler` | Fiil tutanağı keşiften ayrıdır. İmzasız pusula veya gizli niyet gerçek gözlem sayılmaz. |
| Sabotaj önleme | `src/kapi/sabotaj_clue_sozlesmesi.gd` | CAS12/13 kendi işleminin dört bayrak snapshotunu tutar; yeni keşif listesi oluşturmaz. Bulunan yük aynı DivanKanit'ten okunur. |

Kapıdaki Clue kimlikleri yeniden adlandırılmaz; SYS-09 CSV başlık/tanım anahtarıyla aynı şey değildir. KAP-02/03 PR #9 ile Cursor tarafından kapanmıştır; CAS15 heybe/tansiyon/diyalog motoruna yazmaz. Hukukta kanıt sunumu yeni suç veya haksız hüküm itirafı yaratmaz. Eski kayıtta optional alanın yokluğu boş keşiftir; JSON dönüşünde foreign kimlikler ayıklanır. Ayrı `divan_clue`, ikinci IpucuYoneticisi veya açıklama kopyası eklemek bu sözleşmeye aykırıdır.

## Formulas
Bulunan = önceki geçerli bulunan ∪ aynı ziyaretin true kaynak Clue kimlikleri. Sunulan ⊆ bulunan. Geçerli itiraf CAS06 en az2 kaynak kanıt/yük ve ilgili CAS profil sözleşmesi; eylem ayrıca gerçek gözlenen fiil gerektirir. Yeni zar, hasar veya kasa etkisi yok.

## Edge Cases
Eksik eski köylü kaydı boş keşiftir. Sahte CHR/path, bozuk/foreign/nonstring/tekrar kimlik elenir. JSON bütün Oturum döngüsünde birebir kimlik/ilerleme korunur. Ret için köylü oluşmadığından kalıcı devam yok; figürde CHR keşfi uydurulmaz. Sonradan hüküm/onarım için kaynak kanıt değişmez. Kaynak belge ve kapı bayrakları divan köprüsüyle değiştirilmez.

## Dependencies
src/kapi/divan_kanit.gd hedef taslaktan gerçek festive helperine geçti; CAS06'da erken bağlandı, CAS11 bu sözleşme denetimi ve tekrar/foreign korumasıdır. Oturum kabul tek çağrı, Koylu kaydet/kayittan optional key, aynı DivanSorguPaneli. CAS14 kart sunumu aynı DivanSorguPaneli içinde DivanKanitKarti helperiyle genişletildi. CAS15 bu tek sözleşmenin aşağıdaki sahiplik ve örtüşme notudur; ikinci motor yazılmaz.

## Tuning Knobs
data/divan_sorgusu.json CAS06 eşiği, mevcut CHR resource ID/açıklamaları. Yeni tuning/CSV/asset dosyası yok; asset gerekmedi, G kontrol edildi. Asset üretimi/indirme yok.

## Acceptance Criteria
30CHR gerçek kapı üç inceleme/kabul → kaynakta bulunan true kimliklerin birebir devamı; kaynak/bayrak readonly; tam Oturum JSON. Gözlemsiz/foreign reddi, eski kayıt/bozuk kimlik, kasa/stok/zar. Tekrar ve foreign ziyaret sunulan/itiraf ilerlemesini korur; mevcut divan native/headless ve ilgili CAS/kayıt/gece kontrolleri.
