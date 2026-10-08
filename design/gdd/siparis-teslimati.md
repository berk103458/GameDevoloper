# Sipariş teslimatı ve itibar — TUC-06

## Overview
Tek sözleşme defterinde tam ürün teslimi kamu kasasına ödül ve ilgili tüccara itibar verir. Sonraki ziyaret mevcut sınırlı stok sisteminde sadakat ürününü açar.

## Player Fantasy
Oyuncu üretim taahhüdünü yerine getirerek güvenilir tedarikçi olur ve tüccarın sakladığı küçük stoğa erişir.

## Detailed Rules
Bekleyen sipariş tam ambardan vade günü dahil teslim edilir; tüccarın aynı gün köyde olması gerekmez. Teslim edilen miktar düşer, sözleşmede kabul edilmiş ödül kamu kasasına eklenir, durum teslim olur ve tarih kaydedilir. Aynı sipariş ikinci ödeme vermez. Başarı ilgili tüccara +10 itibar (üst 100) verir. İlk 10 itibar başarı gününü kaydeder; o günün varışı sadakat stoğu açmaz. Daha sonraki aynı tüccar varışlarında sadakat ürünü açıktır: Celep buğday, Nalbur/Silah tüccarı cevher, Aktar kürk. Bunlar mevcut ambar türleridir; yeni nadir model/kalite envanteri oluşturulmaz. Sadakat stoğu ziyaret başına iki adettir.

## Formulas
Teslim edilebilir = bekliyor AND oyuncu günü ≤ vade AND ambar miktarı ≥ sipariş adedi. İtibar = min(100, puan + 10). Sadakat açık = puan ≥ 10 AND varış günü > ilk eşik başarı günü. Sınırlı ürün kalan miktarı mevcut GezginTuccarStogu formülüyle hesaplanır.

## Edge Cases
Eksik ürün/geç teslim/başarısız işlem kayıt ve kasa değiştirmez. İtibar tüccara özgüdür, başka uzmanın stoğunu açmaz. Yeniden yükleme teslim tarihi, puan, eşik tarihi ve alınan sadakat miktarını korur. Aynı ziyarette tekrar başarılı sipariş önceden kazanılmış erişimi kapatmaz. Eski kayıt alanları boş itibar varsayar; bozuk/sonsuz değerler sınırlandırılır. İhlal/faiz TUC-07 kapsamındadır.

## Dependencies
SiparisTeslimati yeni saf işlem/itibar helperı; mevcut SiparisSozlesmeleri defteri ve Kaynaklar/KoyYonetimi kamu kasası. SiparisTeslimPaneli aynı deftere tek çağrı; GezginTuccarStogu ürün/loader/ad yolu sadakat verisini birleştirir. PazarKartKaydirma mevcut pazar/defter kartının içeriğini kaydırır; başlık/kapanış düğmesi sabittir. Çekirdekte yalnız ince bağlantılar bulunur.

## Tuning Knobs
data/siparis_teslimati.json itibar artışı/eşiği/üst sınır ve uzman sadakat stok/fiyatları. Mevcut ambar ürünleri/ikonları kullanılır; asset gerekmedi. Yeni asset, CSV veya ikinci HUD üretilmez.

## Acceptance Criteria
Gerçek teslim UI sinyali, tam stok düşümü ve kamu ödülü; eksik/vade/çift ödeme engelleri. Tüccara özgü itibar, sonraki ziyaret sadakat alımı ve sınırlı miktar; kayıttan dönüşte tekrar satın alma/ödül yok. Kaydırma dışında sabit kapanış, native pazar/defter ve ayna import/UI; eski sözleşme/tüccar/snapshot/20 gece testleri geçer.
