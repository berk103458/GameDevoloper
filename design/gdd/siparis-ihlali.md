# Sipariş ihlali ve ceza faizi — TUC-07

## Overview
Vade sonrası ilk gün sözleşme ihlal olur; ilgili tüccar ticareti reddeder, köy Refahı düşer ve aynı sözleşme defterinde kamu kasasından ödenebilen ceza borcu oluşur.

## Player Fantasy
Oyuncu üretim sözünü tutamamanın sosyal ve ekonomik sonucunu görür; borcunu ödeyip tüccarla ilişkisini yeniden kurar.

## Detailed Rules
Vade günü dahil teslim mümkündür. Sonraki oyun gününde ihlal bir kez işlenir: ödülün %25'i yukarı yuvarlanmış borç, tüm yaşayan köylülerde Refah -3 ve ilgili tüccarda itibar -10 (en az sıfır). Tüccar en az sekiz gün ayrılır; süre dolsa da ödenmemiş borç ticareti engeller. Takvim aynı kayıtlı gün üzerinden sürer; diğer tüccarlar etkilenmez. Hayvan, uzman/genel ürün ve yeni sipariş yolları aynı engeli kullanır. Kamu kasasından kısmi/tam ödeme mümkündür; zorunlu otomatik tahsilat ve negatif kasa yoktur. Defter mevcut pazardan erişilir.

## Formulas
Yeni ceza = ceil(kabul edilen ödül × 0.25). Gece faizi = ceil(önceki borç × 0.10), günlük bileşik, üst sınır 1.000.000 akçe. Mevcut borcun gecikmiş faizi yeni ceza eklenmeden hesaplanır; yeni cezaya oluşturulma gününde geçmiş faiz yüklenmez. Terk = borç > 0 OR oyuncu günü < ihlal günü + 8. Ödeme = min(max(0, kamu akçesi), borç).

## Edge Cases
Aynı gün tekrar denetim Refah/itibar/borç/faiz çoğaltmaz. Tüccar başına tek borç kaydı farklı ihlallerin cezalarını toplar. Büyük gün sıçramasında faiz üst sınıra ulaşınca döngü durur. Borç sıfırlansa bile asgari terk süresi atlanamaz. Vadesi geçen sipariş sonradan teslim ödülü vermez. Eski kayıt boş borç defteridir; negatif/sonsuz/kesirli ceza alanları reddedilir. Borç, dönüş günü ve son faiz günü kayıtta korunur. Ödeme stok veya RNG değiştirmez.

## Dependencies
SiparisIhlali saf helper; KoyYonetimi gece geçişinde tek çağrı ve isteğe bağlı tuccar_cezasi alanı. Mevcut SiparisSozlesmeleri, GezginTuccarStogu, CelepHamdullah ve kervan_gunu yolları ince engel kontrolü yapar. SiparisIhlalPaneli aynı pazar satırını ve aynı sözleşme defterini genişletir; ikinci HUD/takvim yoktur.

## Tuning Knobs
data/siparis_ihlali.json ceza oranı, günlük faiz, borç üst sınırı, terk günleri, Refah ve itibar kaybı. Asset gerekmedi; mevcut etiket/düğmeler kullanılır, asset üretimi veya indirme yoktur.

## Acceptance Criteria
Vade sınırı, tek seferlik ihlal/Refah, bileşik faiz, eski/yeni borç sırası, tarih sıçraması, kayıt dönüşü ve gerçek gece geçişi testleri geçer. Gerçek pazar ticaret engeli, defterde okunabilir tüccar adı, kısmi/tam ödeme ve sonraki ziyaretin açılması doğrulanır. Stok/RNG korunur; eski teslim/taahhüt/tüccar/snapshot/iflas ve 20 gece kontrolleri geçer. Native defter görünümü ile ayna import/UI doğrulanır.
