# Kuyu zehri Clue/Flag tetik sözleşmesi — CAS-12

## Overview
CAS03'ün tek gerçek zehir fiili, CHR002/009 kaynak nişan/yük/görsel Clue kimlikleri ve mevcut dört Flag snapshotuyla açık sözleşmeye bağlandı.

## Player Fantasy
Kapıdaki banotu veya zehirli kına izini kuyu raporuyla ilişkilendirmek; ipucunu otomatik suçüstü sanmamak.

## Detailed Rules
data/kuyu_zehirleme.json kaynakta geçen aynı Unicode Clue adlarını tutar. Helper bunları compiled CHR obje_1/obje_2/gorsel_hata_ipucu ile birebir doğrular; uyumsuz kaynakla zehir fiili çalışmaz. Bu liste keşif deposu değildir. Gerçek bulunan kimlikler tek DivanKanit optional kaydından okunur; bulunmamış malzeme ipucu uydurulmaz.

Gerçek kabulde mevcut zehir kişi makbuzu dört kaynak bool Flag'i saklar: Flag_Yol_Sirri_Acik, Flag_Kimlik_Cozuldu, Flag_Sir_Tamamen_Cozuldu, Flag_Kilitlendi. İsimler değişmez; ikinci KAP sorgusu yok. Tam çözüm/yol sırrı CAS03'teki güvene alma sonucunu korur; kimlik tek başına ve yalnız keşfedilmiş Clue zehri otomatik durdurmaz. Eski cozuldu/karar makbuzu çalışır. String true gerçek Flag sayılmaz.

## Formulas
Mevcut kaynak karar/tur/stat, fiziksel uygunluk, gerçek kuyu taze su ve tek uygulanmış makbuz CAS03'ten değişmez. Yeni yalnız kaynak Clue eşleşmesi ve çözüm Flag kontrolü; ikinci hasar/RNG yok. Kuyu kartında bulunan yük sayısı kaynakta doğrulanmış mevcut kişi Clue devamından okunur.

## Edge Cases
Kaynak olmayan kişi veya yanlış nişan/yük/görsel adı güvenli reddedilir. Bozuk bayrak değeri false, eski eksik rawFlags cozuldu kararıyla uyumlu. JSON rawFlags korur; kabul snapshotu kapı bayrağı/Resource'u değiştirmez. Tespit/bulunan malzeme tek başına fail gözlemi değildir; CAS02 suçüstü ve CAS06 itiraf şartları korunur. Kilitli sorgu kendi KAP karar menüsünde kalır, helper onu yeniden açmaz.

## Dependencies
SabotajClueSozlesmesi yeni dar helper, KuyuZehirleme mevcut kabul/oku/gece/tip bağlantıları. DivanKanit tek bulunan Clue kaynağı; ChrSozlesmesi.BAYRAKLAR tek Flag isim kaynağı. Aynı SuDengesi/kuyu kartı tooltipi, ikinci panel yok. CSV/CHR/KAP01/koy_halk_hareketi değişmez.

## Tuning Knobs
data/kuyu_zehirleme.json clue_sozlesmesi kaynak kimlik tablosu; mevcut azami100/iki profil. Tam/yol güvene alma önceki CAS03 denge kararıdır. Asset gerekmedi, G kontrol edildi; üretim/indirme yok.

## Acceptance Criteria
İki kaynak × gizli/yük keşfi/yol/tam/kimlik durumları: birebir rawFlags readonly/JSON, gerçek keşif görünürlüğü, doğru tek zehir veya engel. Sağlık96/source4 sınırı, gözlenmemiş fail ve RNG koruma; stringtrue/eski/rawFlag/yanlışClue reddi. Eski CAS03 birim ve native gerçek sabah raporu, ilgili CAS/kayıt/gece ve iki ds kopyası.
