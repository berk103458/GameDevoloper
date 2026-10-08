# Soğuk hastalık baskısı — MEV-13

## Overview
Sert kış mevcut sağlık, olumsuz üretim bayrağı ve tek Şifahane günlük kontenjanını tetikler.

## Player Fantasy
Oyuncu sert kışta azalan iş gücünü sağlıklı cerrah/otacı ve erzakla destekler.

## Detailed Rules
Doğal kışın dördüncü gününden itibaren veya zorlanmış tipide gecede yüzde20 risk; en çok bir yeni yaşayan hasta. Üç gün kis_hastasi bayrağı mevcut olumsuz üretim çarpanını kullanır, eğitim/şifahane çalışan sağlıklılığına engeldir. Gecede5 sağlık kaybı; süre dolunca kendi hastalığı temizlenir. Genel hasta/ağır yaralı bayrakları temizlenmez. Gerçek gece üretimden önce hasta oluşur; yanık tedavisi sonrası kalan Şifahane kontenjanı kış hastalarına ayrılır. Hasta başına aynı ambardan2 gıda, +10 sağlık ve hastalık temizliği; doktor yoksa/uygunsuzsa/erzak yetersizse bekler. Doğal hastalık baskısı debug veba/kuyu kodunu tetiklemez veya yeniden yazmaz.

## Formulas
Sert=kış mevsim günü>=4 veya tipi. Risk20%, max1/gece. Üretim mevcut olumsuz bayrak çarpanı(varsayılan0.7). Kapasite=sağlıklı gerçek cerrah/otacı sayısı−aynı gün kullanılan yanık/kış hasta slotları. Kalan en az0; yeni günde sıfırlanan kullanım, personel/para yaratmaz.

## Edge Cases
Gecelik risk/sağlık makbuzu aynı gece tekrar zar/hasar yaratmaz. Optional kişi hastalığı ve günlük kontenjan kayıtla korunur; bozuk/eski alan boş kabul edilir, eksik hastalıkla yetim kis_hastasi açık bayrağı temizlenir. Yanık önceliği aynı doktorun çift kapasite yaratmasını önler. Genel hastalık, yaralanma veya death ayrı mevcut sağlık döngüsünde kalır. Sıcak havada mevcut hastalık süresi ilerler, yeni risk zarı yok.

## Dependencies
KisHastaligi; KoyYonetimi gece/tedavi/kayıt ince çağrıları, Koylu optional hastalık, Uretim mevcut bayrak listesi, CirakEgitimi sağlamlık, SifahaneKontenjani ve ZanaatKazalari slot bağlantısı. Köylü kartında aynı bilgi alanı; ikinci hasta/HUD/ekonomi yok.

## Tuning Knobs
Data/kis_hastaligi.json risk20/sert gün4/süre3/sağlık5/tedavi gıda2/iyileşme10. Asset gerekmedi, mevcut köylü/kart/Şifahane; G envanteri kontrol edildi.

## Acceptance Criteria
Sert kış risk, sağlık/verim/sağlamlık, tekrar/restore/gerçek gece; yanıkla ortak slot, kayıtla doluluk, tek gıda ücreti, yalnız kendi bayrağı/süre temizliği, eski kayıt ve sıcak risk yok. Gerçek mevcut köylü kartında hasta süresi/doluluk, native görüntü; şifahane/zanaat/kayıt/üretim/20 gece regresyonu.
