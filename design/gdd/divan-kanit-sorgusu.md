# Divanda kanıt sunma ve sorgulama — CAS-06

## Overview
Kapı ziyaretinde gerçekten keşfedilmiş Clue kimlikleri tek köylü devam kaydında kalır; mevcut divanda sunulur ve fiil sorgulanır.

## Player Fantasy
Kapıda bulunan nişan/yük/fiziksel izi suçüstü tutanağıyla eşleştirip kişinin gerçek fiili kabul etmesini sağlamak.

## Detailed Rules
IpucuYoneticisi ve ChrSorgusu değiştirilmez. Oturum gerçek kabul sonrası DivanKanit.devral yalnız bulunan kaynak Clue kimliklerini köylü metadata'sında devam ettirir; açıklama ve kart verisi kopyalanmaz. Koylu optional save/load aynı kaydı saklar. Bulunmamış ipucu kaynakta tanımlı diye keşfedilmiş sayılamaz. Sahte/başka kişinin ipucu, false kayıt, tekrar kimlik elenir. Sunulan listesi bulunanların altkümesidir; ikinci kez sunma etkisiz.

Mevcut divan adayları yalnız gözlenen gerçek CAS fiilleridir. Basit nişan/yük/fiziksel iz sun düğmeleri aynı divan listesindedir; tooltip aynı CHR açıklamasıdır. Kaynağın obje_1/obje_2/gorsel_hata_ipucu alanları aynen kullanılır. Kaynak Clue Unicode/ID ve SYS09 CSV anahtarları değiştirilmez. Sorgu gerçek fiil + yeterli sunulan kanıt ile itiraf makbuzu yazar; stok, sağlık, akçe, kaynak sorgu, RNG veya ceza değiştirmez. İtiraf aynı fiili kabul anlamındadır; gizli niyete veya kapıdaki bütün persona sırlarına otomatik hüküm değildir.

## Formulas
Denge varsayımı: en az2 bağımsız kaynak Clue, bunlardan biri obje_2 yük kanıtı ve CAS kaynak profilinde yaşayan kişi + gerçek gözlenmiş fiil. Yeni zar/tecrübe hesabı yok. Aynı itiraf ve sunma tekrar uygulanmaz. Masum CHR003 gibi CAS profili dışındaki kişi iki normal eşya sunarak otomatik suç itirafına zorlanamaz.

## Edge Cases
Eski köylü kaydında boş ipuçları; bozuk/foreign/tekrar ID, sunulan keşfedilmemiş ID, geçersiz itiraf elenir. Kaynak olmayan figürde boş sorgu. JSON sonrasında bulunmuş/sunulmuş/itiraf aynı; sorgu kaydının mutable kopyası canlı kaydı değiştirmez. Ölmüş/ayrılmış/gözlenmemiş kişinin sunma/sorgusu reddedilir. CAS geçmişi mevcut sınırlı kaynak, itiraf ise geçerli yeterli kaynak ipucuyla kalıcı makbuzdur; sonradan hüküm CAS07 sorumluluğunda. Kaynak Resource ve kapı sorgusu readonly kalır.

## Dependencies
Src/kapi/divan_kanit.gd dar köprü CAS06 için erken oluşturuldu; ROADMAP CAS11'in ayrı sözleşme/entegrasyon denetimi hâlâ açık, kapanmış sayılmaz. Yeni DivanSorguPaneli mevcut DivanEkrani listesinde bir helper çağrısı. Oturum kabul ve Koylu optional kayıt ince adaptörleri. IpucuYoneticisi tek ziyaret keşif kaynağı; DivanOturumu/CasusGeceTakibi tek gerçek fiil kaynağı. KAP01 ve CSV değiştirilmez; ikinci kanıt kartı deposu yok.

## Tuning Knobs
Data/divan_sorgusu.json gerekli_ipucu2. Kaynak clue/ad/description mevcut CHR resource, profil CasusGeceTakibi.AYAR. Asset gerekmedi; mevcut divan masa/sıralar ve düğmeler. Envanter G kontrol edildi, üretim/indirme yok.

## Acceptance Criteria
Gerçek kapı iki inceleme/tekrar inceleme/kabul → aynı iki Clue devamı; bulunmamış/foreign/tekrar reddi; gözlemsiz ve tek kanıt sorgusu reddi; yük+iki kanıt gerçek itiraf, tekrar etkisiz, masum itiraf yok. JSON/source immutable/kasa/stok/RNG koruması. Native/headless mevcut divanda gerçek sun/sorgula düğmeleri, scene/pause/pose restore; iki ds kopyası ve CAS/CHR/kayıt/gece/20 gece regresyonu.
