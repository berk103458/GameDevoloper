# Yaz su dengesi ve kıvılcım — MEV-07

## Overview
Su rezervi mevcut ortak ambarın yeni türüdür; yeni envanter/HUD yok. Meydan kuyusunun günlük akışı ve rezerv aynı gece ihtiyacını karşılar. Kuru ot kıvılcımı mevcut iadesiz yapı kaybını kullanır.

## Player Fantasy
Oyuncu yaz öncesi mevcut pazardan kuyu suyu ayırır; susuzluğu ve yakın çatılara sıçrayan kıvılcımı yönetir.

## Detailed Rules
Normal iklim kişi başı 1 su; yaz veya kuraklıkta 2. Meydan kuyusu günlük 20 taze su sağlar. Oyuncu mevcut pazarda 1 kamu akçesiyle 10 suyu ortak ambara ayırabilir, gün başına toplam 20'yi aşamaz. Ayrılan su aynı gün kuyunun kalan akışından düşer; gece çift arz yaratılmaz. İhtiyaç önce kalan taze akıştan, sonra depodan karşılanır; yalnız eksik kalan en yeni köylüler -3 sağlık alır. Ölüm/iyileşme mevcut fazdadır. Eski kayıt sıfır su rezervi, tam doğal kuyu akışıyla açılır.

Yaz/kuraklıkta mevcut meydan ateşine 10 hücre içinde hazır yanabilir bir yapı varsa gecede tek %5 kıvılcım riski. Yağmur/kar fırtınası riski kapatır. 10 su rezervi varsa yangın söndürülür; yoksa ilk uygun yapı mevcut iadesiz API ile kaldırılır. Yatak/depo/görev/ızgara bağları aynı mevcut yoluyla temizlenir; yeni hasar sayacı yoktur. Yangın kontrolü gecenin tüketiminden önce, su tüketimi mevcut gıda/yakacak hesabından sonra çözülür.

## Formulas
İhtiyaç = nüfus × kisi_su × (yaz/kuraklık ? yaz_carpani : 1). Kuyu kalan = kuyu_gunluk - bugün ayrılan. Depo kullanımı = min(depo,max(0,ihtiyaç-taze)). Susuz kişi = ceil(eksik/kişi ihtiyacı). Kıvılcımda mevcut RNG randi_range(1,100)<=kivilcim_yuzde.

## Edge Cases
Dolu ambar, yetersiz kamu parası, günlük kuyu limiti veya bitmiş oyun doldurmayı atomik reddeder; kişisel para değişmez. Doldurma/günlük tüketim/kıvılcım makbuzları kayıtta kalır. Aynı gece sağlık/su/RNG tekrar işlemez. Su mevcut ambar kapasite/taşma sınırına dahildir. Örtüşen yaz+kuraklık çarpanı 4 değil 2'dir. Taze akış depoya biriktirilmez; yalnız oyuncunun ayırdığı su stoktur. Arz ve risk sabitleri denge varsayımıdır; kirli kuyu etkisi MEV-06 kendi mevcut sağlık etkisini sürdürür.

## Dependencies
SuDengesi ve YazYanginRiski yeni helper; KoyYonetimi gece/kayıt ince çağrıları. Kaynaklar su türü ve AmbarBakimi taşma sırası; mevcut Hud kaynak şeridi ve SuRezervPaneli mevcut pazara tek düğme. Mevcut ateş konumu AtesBasiRutini verisinden türetilir; ikinci ateş kurulmaz. CSV/CHR değişmedi.

## Tuning Knobs
Data/yaz_su_yangin.json kuyu/kişi/çarpan/sağlık/parti/bedel/yangın/yakınlık/söndürme/türler. G MEV07-SU ikonu mavi ColorRect yer tutucudur. Asset üretimi/indirme yok; mevcut ateş/kuyu yeterlidir.

## Acceptance Criteria
Yaz ×2, eksik kişi sağlık, günlük tek arz, kamu tahsilatı, ambar/limit ret, eski kayıt/restore, yağışta risk yok, rezervle söndürme ve iadesiz yangın kaybı test edilir. Gerçek pazarda iki parti sonrası disabled düğme, aynı HUD rezervi, gerçek gecede tek tüketim ve normal sağlık/kayıt/20 gece regresyonları geçer.
