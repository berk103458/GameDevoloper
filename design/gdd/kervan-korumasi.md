# Kervan koruması kiralama — TUC-15

## Overview
Mevcut gezgin ziyareti, hazır kışladan bir etkin muhafızı üç oyun günlüğüne kiralar. Peşinat köy kasasına gider, güvenlik geçici azalır.

## Player Fantasy
Oyuncu kısa vadeli kamu geliri için köy nöbet hattından bir kişiyi kervana gönderir.

## Detailed Rules
Bir ziyaret en fazla bir muhafız kiralar: 12 kamu akçesi, üç gün, kişisel keseye gelir yok. Hazır kışlaya atanmış yetişkin, borçsuz, uyanık ve kişisel isyanda olmayan nöbetçi gerekir. Kapı bekleme/ret ve tüccar borç ambargosu aşılamaz. Kışla yuvası, kişi/nüfus, mevcut tüketim ve bordro korunur; ayrı kervan nüfusu/ekonomisi kurulmaz. Görevde atama/boşa çıkarma yapılamaz. Süre bitince aynı atama otomatik kullanılabilir; yaş, sağlık, borç ve yorgunluk gibi mevcut etkinlik koşulları yine geçerlidir.

## Formulas
Dönüş = mevcut gun + sure_gun; dışarıda = başlangıç ≤ gun < dönüş. Kamu += 12 bir kez. Etkin yerel muhafız hesabından kiralık kişi çıkar; savunma, husumet ve asayiş sönümü bu mevcut sayıyı kullanır. Gösterge Güvenlik = clamp(100 - asayiş riski - dışarıdaki kişi ×5, 0, 100). Son terim dönüşte kalkar; gerçek asayişte geçen gecelerin etkisi korunur, yapay geri ödeme/ters risk işlemi yoktur.

## Edge Cases
İkinci tıklama, ikinci kişi/aynı ziyaret, borçlu/uyuyan/çocuk/normal muhafız görevi, bitmemiş kışla, yanlış kişi, bitmiş oyun veya kasa taşması değişiklik yapmaz. Nüfustan silinmiş kişi aktif sayılmaz fakat ziyaret peşinatı makbuzu korunur. Eski kayıt boş alanla uyumludur; makbuz kimlik/uzman/tarih/sayı doğrulamasıyla yüklenir. Bordro ve yorgunluk mevcut modelden sürer. Atama değiştirilmeden döndüğü için ikinci görev geri yükleme sistemi gerekmez.

## Dependencies
KervanKorumasi, KervanKorumaGorseli, KervanKorumaPaneli yeni helperlardır. KoyYonetimi isteğe bağlı makbuz loader/save ve atama/etkinlikte ince çağrılar; StatEnjektoru/Oturum göstergesi aynı geçici hesabı kullanır. koy_halk_hareketi içinde yalnız tek helper çağrısı vardır: dışarıdaki figür görünmez ve yerel devriye çizmez, dönüşte mevcut rota politikası yeniden kullanılır. Aynı pazar kartında durum ve kiralama satırları; ikinci HUD yoktur.

## Tuning Knobs
data/kervan_korumasi.json süre, peşinat, ziyaret sınırı ve geçici Güvenlik bedelini belirler. Mevcut figür kullanılır; kervan yolculuğu bu görev makbuzuyla temsil edilir. Asset gerekmedi; G tablosunda yeni ihtiyaç yok, üretim/indirme yapılmaz.

## Acceptance Criteria
Gerçek düğme tek kamu peşinatı, etkin nöbetçi azalması, görünmez yerel figür ve 90→85 geçici Güvenlik üretir. Dönüş günü aynı kişi/kışla görünür ve eski nöbet hesabına katılır. Unit model, tek ziyaret, kayıt, yeniden atama engeli, tarih ve makbuzu sınar. Muhafız/maaş/devriye/yorgunluk/atama/stat/kayıt/ticaret ve 20 gece regresyonları geçer.
