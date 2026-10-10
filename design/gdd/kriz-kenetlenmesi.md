# Krizden çıkış ve toplumsal kenetlenme — KRI-10

## Overview
Kesintisiz kriz dönemi tamamen atlatıldığında yerel yaşayan halka bir kez Sadakat ve ekonomik Refah kazandırılır. Mevcut KoyYonetimi gece döngüsü, hastalık/kuyu/isyan/yas ve kişi puanları genişletilir; ikinci kriz motoru, stat veya panel oluşturulmaz.

## Player Fantasy
Kuyuyu temizlemek, hastaları tedavi etmek ve açlığı gidermek birlikte sonuç verir: hayatta kalan halk yönetimine daha çok güvenir, hayat standardı toparlanır. Gece raporu hangi açık krizlerin atlatıldığını ve gerçek toplam kazanımı gösterir.

## Detailed Rules
- Gece başında ve sonunda kamuya açık krizler gözlemlenir: mevcut `isyan_kalan >= 0` (KRI-06 kıtlık dahil), yerel yaşayan belirtili enfeksiyon, kirli kuyu, aktif köy yası. Değişen vaka sayısı veya örtüşen başka kriz aynı döneme eklenir.
- Gece başı fotoğrafı bu gecede iyileşen son hasta veya biten isyanı kaçırmaz. İlk kez ileri günde açılan legacy kayıt da izlenir. HUD okuması ve kaydı yüklemek gözlem/bonus üretmez.
- Gece sonunda bütün açık krizler bitmiş, yerel yaşayan herkes tok ve enfeksiyonsuz, erzak >0 ve bekleyen haksız söylenti kararı yoksa dönem kapanır. Gizli enfeksiyon yalnız kapanışı erteler; dönem başlatmaz, kişisi/türü açıklanmaz. Karantinaya alma, dezenfeksiyon veya bütün halkın ölmesi tek başına iyileşme değildir.
- Yaşayan yerel halka kişi başına Sadakat +8, Refah +10 uygulanır; çocuk/yaşlı ve karantina dahil, zindan/dış görev hariç. Tek mevcut `Koylu.sadakat` ve `Koylu.refah` alanları kullanılır; mevcut ekonomik Refah ortalaması, köylü kartı ve kayıt bu alanları okur.
- Ödüller arasında en az 7 gece günü farkı vardır. Bekleme süresinde atlatılan yeni kriz kapanır, ertelenmiş bonus biriktirmez. Bekleme doldu diye krizsiz halk tekrar ödüllendirilmez. Bir sonraki bağımsız kriz yeni dönem açabilir.
- Terminal denetimden sonra bonus kapısı çalışır: kayıp veya zaferle oyun kapanmışsa ödül verilmez. Aynı gece tekrar çağrı ve JSON restore son-gece/dönem makbuzuyla kilitlidir.
- Rapor gerçek toplam değişimi ve kişi başına tavanı gösterir; tavan100'de +8/+10 vaat edilmiş gerçek kazanç gibi sunulmaz. Örtüşen krizler ayrı ayrı çarpan oluşturmaz. RNG, stok, kamu/kişisel kasa, moral, adalet ve Güvenlik doğrudan değişmez.

## Formulas
`S' = clamp(S + sadakat, 0, 100)`; `R' = clamp(R + refah, EkonomikRefah.AYAR.alt, EkonomikRefah.AYAR.ust)`. Rapor toplamları `Σ(S'−S)` ve `Σ(R'−R)` yalnız uygun yerel yaşayan kişileri kapsar. Ödül izni: `son_bonus < 0` veya `gun−son_bonus >= bekleme_gun`. Sadakat üst sınırı mevcut kişi puanı sözleşmesidir; Refah sınırları mevcut `data/koy/refah.json` dosyasındadır.

## Edge Cases
- Optional kayıt alanı yok/bozuksa geçmiş uydurulmaz. NaN, Inf, kesirli/gelecek günler, bilinmeyen/tekrarlı kriz türleri, boş tür listesine aktif başlangıç veya son-bonustan önce başlayan aktif dönem reddedilir. JSON tam sayı float değerleri kabul edilir. Yükleme puanları değiştirmez.
- Kriz sürerken hasta sayısı azalması, kireçleme veya isyanın yatışması diğer krizleri kapatmaz. Yeniden kirlenme mevcut dönemle birleşir. Son hastanın ölümü mevcut cenaze yası/terminal kapısında kalır.
- Boş köy, yalnız tutuklu/dış görevli halk veya erzak yokluğu bonus üretmez. Gerçek tüketim bütün yerel açlıkları kapatmalı, kalan erzak pozitif olmalıdır.
- Açık histeri kararı temel kriz bitse bile kendiliğinden yok sayılmaz. Gizli casus/CHR/kimlik karar girdisi değildir.

## Dependencies
`src/koy/kriz_kenetlenmesi.gd` preload helper; KoyYonetimi gece başı/terminal sonrası bitiş ve optional save/load adaptörleri; SaglikYoneticisi, KuyuKirliligi, CenazeYasi, FisiltiGazetesi.HISTERI, DivanHukmu, KervanKorumasi, EkonomikRefah. IflasYoneticisi olay metni adaptörü mevcut köy raporuna bağlar. Autoload/KoyEkrani statik bağımlılığı, CSV veya KAYIT_SURUMU değişikliği yok. Asset gerekmedi; mevcut rapor/köylü kartı yeterli, G envanterinde yeni asset ihtiyacı yok.

## Tuning Knobs
`data/koy/kriz_kenetlenmesi.json`: `sadakat=8`, `refah=10`, `bekleme_gun=7`. İlk değerler çınar meclisi sadakat +4 etkisinden büyük bir dönem kapanış ödülü verir; Refah +10 ekonomik yaşam standardında belirgin fakat tavanlıdır. Haftalık bekleme yapay kuyu kirlet/temizle döngüsünde gece başına ödül toplamayı engeller. Denge veridedir, kodda sabit değildir.

## Acceptance Criteria
`tests/unit/kvr/kriz_kenetlenmesi_test.gd`: krizsiz/süren/biten dönem, örtüşme, açlık/erzak/kuluçka kapıları, cooldown/yeni dönem, gerçek toplam/tavan, karantina/çocuk/zindan/dış görev, boş/terminal model, bozuk/legacy/ileri gün JSON, RNG/kasa/stok, gerçek son hasta iyileşmesi ve ölümü. `tests/oto/kriz_kenetlenmesi_kontrol.tscn`: gerçek gece düğmesi → tifo/kuyu → pazar dezenfeksiyonu → devam eden salgın → güvenli kayıt → gerçek doğal iyileşme/gece raporu → aynı restore sonucu → sabah/köylü kartı → tekrar ödülsüz gece. Birim otomatik keşifte, akış sanity sahne listesinde; tam sanity ve 20 gece duman hatasız olmalıdır.
