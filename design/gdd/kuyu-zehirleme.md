# Kuyu zehirleme ve sabah tespiti — CAS-03

## Overview
CHR002/009 kabul/rüşvet gecikmeli zehir sonucu aynı gerçek kuyu akışı, köylü sağlığı ve ortak stoklarda bir kez uygulanır.

## Player Fantasy
Kapıda açığa çıkarılan sırla zehri önlemek; sabah belirtilerini suçüstü kanıtından ayırmak.

## Detailed Rules
Kapı kararında CHR sorgusunun Flag_Yol_Sirri_Acik veya Flag_Sir_Tamamen_Cozuldu snapshotu zehri önler; kışla kararı saldırmaz. Bu önleme, kaynakta yol sırrına bağlı kuyu olayını ve kabulde gizli sır varyantını aynı zehir paketi olarak uzlaştırır. Ret edilen kişi köyde bulunmaz. Eski snapshot yoksa açık sabotajci/casus biliniyorsa önlenmiş kabul edilir.

Kaynak data/chr_runtime/CHR_002.tres ve CHR_009.tres gecikmeli_etkiler içinden karar eşleşen negatif Saglik sonucu alınır; tur_offset/stat_etkisi adları ve CHR/CSV değişmez. Kabul tur3; rüşvet tur4, giriş gecesi tur1. Aynı kaynaktaki koşulsuz tur3/4 zehir anlatımları ayrı zarar sayılmaz. Diğer söylenti/ret/spawn sonuçları bu dar adaptörün dışında. Genel gecikmeli olay motoru kurulmaz.

Sağlık, açlık, gerçek kış hastalığı, açık hasta/ağır yaralı, uyku, nöbet ve dış koruma engelleri mevcut görevi korur. CHR002 eski gizli hasta etiketi yeni kaynakta banotu deri nişanıdır; yalnız bu eski gizli etiket fiili sonsuza kadar engellemez. Gerçek hastalıklar atlanır. Hazır kuyu/su arkı/Şifahane veya mevcut meydan kuyusu hedef seçilir. Engel varsa ilk sonraki uygun gece kaynak sonucu bir kez uygulanır.

Gerçek SuDengesi gece raporundaki taze akışı içen ilk N yaşayan yerel kişide kaynak sağlık kaybı; önce ayrılmış ambar suyu yeni zehre maruz kalmaz. Moral/güvenlik/gıda kaybı aynı mevcut değerlerde bir kez. Bu madde zehirlenme kaynaklı toplu belirti tespitidir; bulaşıcı hastalık/ikinci tedavi sistemi değildir. Sabah raporu ve aynı su tooltipi kişi sayısını verir, fail adını açmaz. CAS01 gerçek zehirleme fiili gözlenmemiş kayıt, CAS02 nöbet gözlemi gerçek kanıta çevirebilir.

## Formulas
Tur = gece gun − giris_gunu + 1. KVR runtime sınırı stat −4…4: kaynak −5 sağlık burada −4 olur, kaynak Resource değiştirilmez. İçen sayı min(nüfus, ceil(taze / kişi su ihtiyacı)); yerel yaşayanlar. Sağlık/moral/güvenlik 0…100; gıda gerçek mevcut miktarla sınırlı. Yeni RNG yok; her kişi/admission bir zehir makbuzu, her gece tek helper makbuzu.

## Edge Cases
Eski optional kayıt güvenli; bozuk kimlik/karar/bool elenir. JSON restore/gece tekrar/stat uygulama tekrar yok. Sır çözümü ve kışla nöbeti korunur. Rezervden içenlerde yeni sağlık etkisi yok. Su akışı sıfırsa gözlenen belirti sayısı sıfır; zehir fiili kaydı hâlâ gerçek. Ölüm mevcut sağlık fazında çözülür. Gizli kayıt UI'ye kişi adı sızdırmaz; niyet suç değildir. CAS02 gözlem ikinci zarar vermez.

## Dependencies
KuyuZehirleme yeni helper; Oturum kabul sonrası tek snapshot bağlantısı. KoyYonetimi su raporu sonrası/sağlık öncesi tek çağrı ve optional save/load. CasusGeceTakibi.hedef aynı hedef seçimi, zehirleme fiil türü uzantısı; CasusDevriyesi gerçek fiil etiketi. SuDengesi aynı kart tipine tek ek; yeni HUD/asset yok.

## Tuning Knobs
Data/kuyu_zehirleme.json profiller ve azami_kayit. Tur/stat CHR kaynak Resource'larından, runtime sınırı mevcut sözleşmeden. Asset gerekmedi; mevcut kuyu/rapor/tooltip. Envanter G kontrol edildi; üretim/indirme yok.

## Acceptance Criteria
Gerçek kapı kabulü ve eski gizli nişan; erken gece etkisiz, tur3 ve rüşvet tur4, iki kaynak profil, sır/tam çözüm önleme, rezerv/taze ayrımı, masum etkilenmesi fail ilanı değildir. Tek gece/JSON/tek saldırı, gerçek su+sağlık gece hooku, gerçek suçüstü gözlem ikinci zarar yok. Native/headless gerçek sabah kartı ve iki ds kopyası; ilgili CAS/CHR/kayıt/kriz/su/sağlık/nöbet/20 gece regresyonu.
