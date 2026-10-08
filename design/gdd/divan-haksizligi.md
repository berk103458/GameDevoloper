# Haksız yargı ve tazminat — CAS-10

## Overview
Arşivlenmiş imzasız iddia ayrı kanıtsız divan davası olur. Suç gözlemi olmadan zindana atma haksızlık yaratır; kamu tazminatı ve tahliye bunu kısmen onarır.

## Player Fantasy
Söylentiyle hüküm vermenin toplumsal bedelini görmek ve kasadan gerçek ödeme yaparak mağduru serbest bırakmak.

## Detailed Rules
Gerçek fiil listesi boş kalır; iddia için gözlem/itiraf uydurulmaz. Kanıtsız dava yalnız zindan seçeneğine izin verir, sürgün/infaz kapalıdır. Ekranda haksızlık ve sosyal bedel önceden yazılır. Kapıda bulunmuş Clue olsa bile gözlenen fiil olmadan CAS06 itirafı yapılamaz. Hukuki masumiyet burada kanıtsızlık anlamındadır; gizli persona biliniyor diye suçlu varsayılmaz.

Asıl DivanHukmu tek hüküm kaydı korunur. Ayrı onarım makbuzu ilk haksızlık günü ve ödeme durumudur. Aynı mevcut divanda haksız tutuklu onarım adayıdır; kasa yetmiyorsa tazmin düğmesi kapalı ve borç görünür. Tam kamu ödeme ve tahliye tek atomik işlem; kişisel muhafız kesesi korunur. Ödeme makbuzu aynı kişiye ödemenin kaydıdır, yeni şahıs cüzdanı kurulmaz. Ayrılan aile geri yaratılmaz.

## Formulas
Denge varsayımı ilk haksızlık moral−20, adalet−15; CAS07 normal zindan moral−2 ayrıca korunur. Tazminat10 kamu akçesi tam ödeme, onarım moral+5/adalet+5. Mevcut 0–100 sınırları; RNG/stok yok. Yetersiz kasa ile kısmi/ücretsiz ödeme yapılmaz.

## Edge Cases
Aile yalnız data kaynağında şecere ile doğrulanan chr_001/chr_004 kardeş çiftidir. Aynı ev/fraksiyon/soyadı aile sayılmaz; köyde olmayan aile üretilmez. Yaşayan yerel ve tutuklu olmayan kardeş gönüllü ayrılır; kadro kalıcı ayrıldı olur, ikinci husumet cezası eklenmez. Diğer kaynak aile üyeleri runtime kimliğiyle doğrulanınca veri tablosuna eklenebilir. Gerçek gözlenen fiil zindanında haksızlık/tazmin hakkı yok. Ölü/terminal/tekrar ödeme reddi; JSON ödeme bayrağı kişiyi yeniden hapsetmez ve asıl hüküm tekrar edilemez.

## Dependencies
DivanHaksizligi yeni helper/onarım makbuzu, mevcut FisiltiGazetesi arşiv seçimi ve DivanHukmu tek hükmü. DivanOturumu aynı aday listesinde ayrı iddia/onarım; DivanHaksizlikPaneli aynı scroll listesinde dar bağlantı. KoyYonetimi optional kayıt; CAS06 sorgu gerçek fiil koruması güçlendirildi. Yeni aile motoru/çift HUD/koy_halk_hareketi mantığı yok.

## Tuning Knobs
data/divan_haksizligi.json sosyal delta, tam10 tazminat, doğrulanmış kaynak kardeş çiftleri. Asset gerekmedi; aynı divan düğmeleri ve CAS07 kutu, G kontrol edildi. Asset üretimi/indirme yok.

## Acceptance Criteria
Arşiv iddiası boş fiil listesi; yalnız zindan, gerçek Clue olsa da sahte itiraf yok. Doğrulanmış kardeş ayrılışı/komşunun korunması; tek sosyal delta, kasa/stok/kese/RNG. Eksik kasa reddi, kamu ödeme/tahliye ve JSON, tekrar hüküm/ödeme reddi, gerçek fiil için tazmin yok. Native/headless iddia uyarısı, kapalı kararlar ve kasa/tahliye/görünürlük; ilgili CAS/kayıt/gece regresyon ve iki ds kopyası.
