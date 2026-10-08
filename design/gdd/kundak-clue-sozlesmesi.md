# Kundaklama Clue/Flag tetik sözleşmesi — CAS-13

## Overview
CAS04'ün tek gerçek yangın fiili CHR001/006 kaynak nişan/yük/görsel Clue kimlikleri ve dört mevcut Flag snapshotuna bağlandı.

## Player Fantasy
Kapıda bulunan katranlı bez/fitil yumağını yapı güvenliğiyle ilişkilendirip malzemeyi tek başına suçüstü sanmamak.

## Detailed Rules
data/ambar_kundaklamasi.json kaynak Unicode Clue adlarını birebir tutar. Ortak SabotajClueSozlesmesi compiled CHR üç alanıyla doğrular; yanlış kaynak kimliğinde fiil güvenli reddedilir. Kabul snapshotu dört bool kaynak Flag'i aynı makbuza ekler; KuyuZehirleme.oku yalnız ortak biçim doğrulayıcısıdır, zehir etkisi çağrılmaz.

Mevcut tam/yol çözümü güvene alma sonucunu korur; kimlik tek başına veya yalnız bulunan Clue kundaklamayı otomatik önlemez. Gerçek keşif tek DivanKanit kaydıdır; ayrı kart/ID deposu yok. Aynı ambar/değirmen bina bilgi kartında toplam bulunan yük ipucu sayısı ve gözlem olmadığı notu gösterilir; fail, gizli hedef veya uygulanacak gece açıklanmaz.

## Formulas
CAS04 kaynak karar/tur/hedef bina/stat ve tek yangın makbuzu değişmez. Aynı rezerv10su söndürme ve iadesiz bina kaybı akışı; normal bina hasar alanı/ikinci yangın hesabı yok. CHR001 rüşvet odun çürümesi yangın sayılmaz. Yeni kaynak doğrulama ve Flag kontrolü yeni zarar/RNG üretmez.

## Edge Cases
Eski rawFlag eksik kaydı mevcut cozuldu/kararıyla çalışır; stringtrue geçerli bool değildir. Tam JSON bayrak snapshotu korunur. Hazır kaynak bina yoksa mevcut bekleme devam eder. Kaynak olmayan veya nişan/yük/görsel uyumsuz kişi güvenli reddedilir. Görünür malzeme sayısı yalnız gerçekten bulunan Clue; bulunmamış/foreign kimlik görünmez. Fiil/yangın tek başına fail gözlemi değildir, CAS02/CAS06 şartları korunur.

## Dependencies
Mevcut SabotajClueSozlesmesi CAS12 helperi tekrar kullanılır. AmbarKundaklamasi kabul/gece dar bağlantıları, mevcut ortak kaynak makbuzu. Yeni KundakClueBilgisi mevcut KoyEkrani bina kartına tek çağrı; çift HUD ve koy_halk_hareketi mantığı yok. CHR/CSV/KAP01 değişmez.

## Tuning Knobs
data/ambar_kundaklamasi.json clue_sozlesmesi kaynak kimlik tablosu; mevcut azami100/iki profil/yangın sözcükleri. Asset gerekmedi, G kontrol edildi; üretim/indirme yok.

## Acceptance Criteria
İki kaynak × gizli/yük/yol/tam/kimlik: kaynak üçClue, dörtFlag readonly/tam JSON, gerçek keşif ayrı; doğru mevcut tek su/fiil veya engel. Yeni zar/fail gözlemi yok. Eski CAS04 kaynak tur/hedef/rüşvet/rezerv/iadesiz bina testleri; native bina ipucu etiketi ve gerçek söndürme raporu, ilgili CAS/kayıt/gece ve iki ds kopyası.
