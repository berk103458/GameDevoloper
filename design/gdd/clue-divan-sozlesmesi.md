# Clue → Divan tek devam sözleşmesi — CAS-11

## Overview
CAS06'da eklenen DivanKanit köprüsü artık tüm30 CHR için doğrulanmış kalıcı devam sözleşmesidir; ikinci kart, keşif veya suç deposu yok.

## Player Fantasy
Kapıda gerçekten bulduğun izlerin köy duruşmasına aynı kimlik ve açıklamayla gelmesi.

## Detailed Rules
IpucuYoneticisi/ChrSorgusu ziyaretin tek keşif kaynağıdır. Kabulde aynı adlı kişi için bulunan true Clue kimlikleri DivanKanit optional Koylu metadata'sına devam eder. Bu metadata yalnız bulunan/sunulan kimlikler ve geçerli itiraf makbuzudur; açıklama/source Resource kopyası değildir. Kaynak üç obje_1/obje_2/gorsel_hata_ipucu alanından okunur; CHR/CSV adları değiştirilmez.

Köprü tekrar çağrılınca zaten sunulmuş/itiraf edilmiş ilerleme silinmez. Başka kişinin ziyareti köylü kaydını sıfırlamaz veya yabancı Clue taşımaz. Kaynak açıklamalar readonly; mutasyon kopya üzerine yapılır. Sunulan kimlikler bulunanların altkümesidir. Gerçek gözlenen fiil yoksa itiraf yapılamaz; CAS10 imzasız iddiası bu sözleşmeyi aşamaz.

## Formulas
Bulunan = önceki geçerli bulunan ∪ aynı ziyaretin true kaynak Clue kimlikleri. Sunulan ⊆ bulunan. Geçerli itiraf CAS06 en az2 kaynak kanıt/yük ve ilgili CAS profil sözleşmesi; eylem ayrıca gerçek gözlenen fiil gerektirir. Yeni zar, hasar veya kasa etkisi yok.

## Edge Cases
Eksik eski köylü kaydı boş keşiftir. Sahte CHR/path, bozuk/foreign/nonstring/tekrar kimlik elenir. JSON bütün Oturum döngüsünde birebir kimlik/ilerleme korunur. Ret için köylü oluşmadığından kalıcı devam yok; figürde CHR keşfi uydurulmaz. Sonradan hüküm/onarım için kaynak kanıt değişmez. Kaynak belge ve kapı bayrakları divan köprüsüyle değiştirilmez.

## Dependencies
src/kapi/divan_kanit.gd hedef taslaktan gerçek festive helperine geçti; CAS06'da erken bağlandı, CAS11 bu sözleşme denetimi ve tekrar/foreign korumasıdır. Oturum kabul tek çağrı, Koylu kaydet/kayittan optional key, aynı DivanSorguPaneli. CAS14 kart sunum genişletmesi/CAS15 örtüşme notu ayrı açık maddeler.

## Tuning Knobs
data/divan_sorgusu.json CAS06 eşiği, mevcut CHR resource ID/açıklamaları. Yeni tuning/CSV/asset dosyası yok; asset gerekmedi, G kontrol edildi. Asset üretimi/indirme yok.

## Acceptance Criteria
30CHR gerçek kapı üç inceleme/kabul → kaynakta bulunan true kimliklerin birebir devamı; kaynak/bayrak readonly; tam Oturum JSON. Gözlemsiz/foreign reddi, eski kayıt/bozuk kimlik, kasa/stok/zar. Tekrar ve foreign ziyaret sunulan/itiraf ilerlemesini korur; mevcut divan native/headless ve ilgili CAS/kayıt/gece kontrolleri.
