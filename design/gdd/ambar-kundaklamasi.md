# Ambar kundaklaması ve suyla söndürme — CAS-04

## Overview
CHR001/006 kaynak kundaklama sonuçları mevcut tek yangın, su rezervi ve iadesiz bina çıkarma API'sine bağlanır.

## Player Fantasy
Kapıda kundakçının sırrını çözmek veya önceden su ayırarak erzak yapısını kurtarmak.

## Detailed Rules
Kapıdaki yol sırrı/tam çözüm snapshotu ve kışla kararı saldırıyı önler. Kaynak CHR gecikmeli_etkiler karar/tur_offset/hedef_bina/stat_etkisi değişmez: CHR001 kabul tur4 Erzak Ambarı, CHR006 kabul tur3 Değirmen, CHR006 rüşvet tur4 Değirmen. CHR001 rüşvetindeki Odunluk çürümesi yangın değildir; bu adaptör onu uydurma yangına dönüştürmez. Genel koşulsuz haber/kimlik söylentileri ikinci zarar sayılmaz.

Yaşayan sağlıklı/tok/uyanık yerel kişi, nöbet ve dış koruma hariç; hazır kaynak hedefinin en küçük kimliği seçilir. İnşaat/yıkılmış/başka tür bina hedef değildir. Hedef yoksa ilk sonraki uygun gece beklenir. Her kişi/admission en çok bir fiil; gecede tek makbuz. Yangın üretimden önce aynı rezervi tüketir, gece su tüketim bilançosunda yer alır. Fresh kuyu akışı bedelsiz yangın rezervi sayılamaz.

YazYanginRiski.sondur tek ortak sonuçtur: yeterli ambar suyu aynı yangını söndürür ve kaynak stat zararları önlenir; yetersizse rezerv kısmen harcanmaz, mevcut bina_el_koy ile yapı iadesiz kaybedilir. İşçiler/ev/kış öncesi iş/ızgara/artık/ambar kapasitesi aynı mevcut çıkarma kodunda temizlenir. Normal binaya hasar alanı eklenmez. Söndürülmeyen kaynak Erzak/Guvenlik/Moral/Refah delta mevcut gerçek stok/köylü statlarına uygulanır.

CAS01 gerçek kundaklama fiili, söndürüldüğünde kayıp0, gizli kayda geçer. CAS02 mevcut devriye gerçek fiili gözleyebilir; niyet veya sabah bina kaybı tek başına fail kanıtı değildir. Rapor aynı gece kartında; ikinci HUD veya yangın aktörü yok.

## Formulas
Tur = gun − giris_gunu + 1. Söndürme suyu mevcut data/yaz_su_yangin.json:10. KVR runtime stat sınırı −4…4; gıda gerçek ambardaki miktarla sınırlı. Sağlık değişmez; moral/refah/güvenlik0…100. Yeni kundaklama RNG yok; kaynak tur sonucudur, mevcut yaz kıvılcımı zarı korunur.

## Edge Cases
Eski optional kapı kaydı ve bozuk JSON güvenli; aynı validasyon biçimi CAS03 kayıt okuyucusuyla paylaşılır, zehir fiili uygulanmaz. Kopya durum/restore/tekrar gece/sonraki gece aynı kişide ikinci yangın yok. Maaş/uyku/uzak görev korunur. Birden fazla kundakçı ortak sonlu rezervi sırayla paylaşır. Yanan bina bedel iadesi üretmez; kapasite kaybı mevcut ambar taşmasını kullanır. Yağışın kıvılcım engeli mevcut yaz motorunda; kasıtlı kaynak kundaklama tüm mevsimlerde olabilir.

## Dependencies
AmbarKundaklamasi yeni dosya; KoyYonetimi gece su hesabında tek çağrı, optional save/load; Oturum kabul sonrası tek snapshot. CasusGeceTakibi ortak kapı/kaynak sorgusu ve kundaklama fiil uzantısı. KuyuZehirleme aynı sorgu yardımcılarına ince delege eder. YazYanginRiski mevcut sonuç bloğu ortak sondur API'sine çıkarılır; mevcut mevsim/RNG koşulları korunur.

## Tuning Knobs
Data/ambar_kundaklamasi.json profiller, kaynak yangin_sozcukleri, azami_kayit. CHR tur/target/stat kaynak veride. Su tüketimi ortak yaz_su_yangin.json. Asset gerekmedi; mevcut bina/rapor ve meşale kullanılır, yeni yangın VFX/kova/klip yapılmadı. Envanter G kontrol edildi; üretim/indirme yok.

## Acceptance Criteria
İki gerçek kaynak hedef ve farklı tur, hazır/inşaat, su10 ve eksik9, önleme/tam çözüm/kışla; kaynak çürüme yangın değildir. Iadesiz bina/işçi/ev/ızgara temizliği, stok ve kasa, JSON ve tek fiil/RNG koruması. Gerçek gece su bilançosu, native/headless aynı gece raporu; mevcut yaz yangını, kuyu/CHR/CAS/kriz/kayıt/gece/20 gece regresyonu.
