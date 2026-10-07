# Çift kasa kurtarma ve zimmet — EKO-14

## Overview
İki mevcut kasa arasında açıkça seçilen, atomik ve kayıtta izlenen transfer. Yeni kasa veya ekonomi döngüsü kurulmaz.

## Player Fantasy
Muhafız köyü kişisel birikimiyle kurtarabilir veya kamu parasını sosyal bedel karşılığında cebine indirebilir.

## Detailed Rules
Kurtarma yalnız kamu akçesi negatifken, en çok gerçek açık ve kişisel bakiye kadar yapılır. Her iki bakiye birlikte değişir; sosyal ödül yoktur. Böylece zimmet/kurtarma tekrarı bedelsiz moral çiftliği kurmaz. Kamu iflas serisi sonraki gece gerçek kapanış bakiyesine göre değerlendirilir.
Zimmet günde bir kez, en çok 10 akçe, kamu bakiyesini negatife düşürmeden yapılır. Adalet −5, yaşayan köylülerin morali −3, asayiş riski +5 (0–100 sınırları). Boş köyde adalet ve asayiş bedeli yine vardır. İki yön toplam para yaratmaz. Oyun sonundan sonra işlem yoktur.
Mevcut pazar kartında kamu/kişisel bakiye, açığı kurtarma ve 5/10 zimmet düğmeleri bulunur. Tooltip gerçek bedeli işlemden önce açıklar. Model her basışta koşulları yeniden denetler. Gecelik maaş/iflas, kapı rüşvetleri, kişisel eşya ve CSV değiştirilmez.

## Formulas
Kurtarma: kamu += N; kişisel -= N. Zimmet: kamu -= N; kişisel += N. N pozitif tam sayı. Toplam kapanış = toplam açılış. Sosyal cezalar dış JSON'dan okunur, sınırlanır.

## Edge Cases
Başarısız transfer bütün durum ve RNG'yi korur. Aynı gün zimmet kayıttan sonra da engellenir. Eski kayıtta geçmiş uydurulmaz; bozuk optional tarih/toplam güvenli varsayılana döner. Bakım ve stok bozulması transferle değişmez. Kaynak birikim alanları 1 milyarla sınırlıdır; limitte işlem reddedilir.

## Dependencies
KasaTransferi, Oturum mevcut kamu/kişisel erişimcileri ve optional kasa_transferleri kaydı; KasaTransferPaneli, mevcut pazar/Hud; EKO-10 iflas.

## Tuning Knobs
`data/koy/kasa_transferi.json`: günlük zimmet azami, sosyal bedeller, düğme miktarları. Bunlar belgelenmiş otonom denge varsayımıdır.

## Acceptance Criteria
Birim testinde iki yön, para korunumu, atomik ret, bozuk/eski JSON, aynı gün/restore, sonraki gün, RNG ve oyun sonu. Gerçek pazar düğmeleri/HUD/bedel/native görsel. Headless import, tam birim ve UI regresyonları, izole 20 gece ve iki yerel kopya doğrulanır; sonra ROADMAP/commit/push.
