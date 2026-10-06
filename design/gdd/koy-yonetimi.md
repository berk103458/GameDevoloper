# Köy Yönetimi (2. Aşama)

> **Status**: In Design — çekirdek (Aşama A) uygulandı
> **Kaynak**: kullanıcının "Oyun Geliştirme Planı: 2. Aşama" belgesi (20 başlık), 6 Ekim 2026
> **Kod**: `src/koy/` · Ayarlar: `data/ayarlar/koy.tres` (`KoyAyarlari`) · Yapılar: `data/koy/binalar.json`
> **Test**: `tests/unit/koy_yonetimi/koy_yonetimi_test.gd` · Denge: `tools/denge/koy_benzetimi.gd`

## Overview

Kapı Muhafızı'nın ikinci aşaması: kapıda içeri alınan herkes köyün iş gücü olur. Oyuncu gündüz kapıda sorgular,
akşam köyü yönetir (yapı kurar, iş atar, ticaret yapar), gece hesaplaşma olur (tüketim, husumet, isyan). Köy 18
nüfusa ulaşınca muhafız "Ağa" olur ve komşu Tekfur haraç ister; haraç ödenir ya da reddedilip baskın savuşturulur.

## Kullanıcı kararları (6 Ekim 2026)

1. **Kapı gündüz** (plan 14.1): kapı sahnesi gündüz ışığına geçer; gece görünümü yalnız gece olaylarında.
2. **Plan, dört barın yerine geçer**: Halk/Soylular/Tüccarlar/Ordu kalkar; göstergeler moral/huzur, adalet,
   asayiş riski, husumet. "Halk Kırıldı" sonu plandaki tetikleyicilerle çalışır; 2. perde = Ağalık aşaması.
3. **Aşamalı uygulama**: A çekirdek simülasyon → B oturum ve kapı entegrasyonu → C köy arayüzü → D köy yaşamı ve cila.

## Player Fantasy

Kapıda verdiğin her karar köyde bir yüz, bir iş, bir kin olarak geri döner. Kimi aldığın kadar kimi geri
çevirdiğin de köyü kurar ya da yıkar.

## Detailed Rules

### Günlük döngü (14)
1. **Gündüz — kapı**: gelenler sorgulanır, bayraklar açılır, kabul/ret. Kabul edilen boşta iş gücüne yazılır (2.2).
2. **Akşam — köy**: yapı kur/yık, yol döşe, iş ata, reçete seç, tezgâhta sat, kervan gününde alım-satım, sur taksiti.
3. **Gece — hesaplaşma** (`KoyYonetimi.gece()`), sırasıyla:
   iltimas denetimi → kış kaydırması / bahar dönüşü → üretim (isyanda yok) → inşaat → barındırma → tüketim →
   sağlık ve moral → akçe (maaş, haftalık vergi) → husumet olayları → asayiş sönümü → isyan → aşamalar (Ağalık,
   haraç, Tekfur) → son denetimi → rapor kartı.

### Kapı kararları (2, 3)
- **Haksız harç** (2.3): yoksuldan `harc_akce` alınır; kişiye `somurulmus`, sadakati %30 düşer, köy adaleti azalır.
- **Rüşvetle şüpheli kabul** (2.4): akçe kasaya, `asayis_riski` artar.
- **Zengin iltiması** (2.5): aynı gün zengin alınıp usta haksız reddedilirse herkesin morali düşer.
- **Ret** (3.1): gerekçeli ret +1, haksız ret +3 husumet; haksız reddedilen usta Tekfur'a geçer (3.5) ve o
  zanaatın kervan malı pahalanır.

### Ambar ve takvim (4)
- Tek ortak ambar; toplam stok kapasiteyi geçemez, dolunca üretim durur (yapı "ambar dolu" bekler).
- Her mevsim 7 gün; 22–28. günler (indeks 21–27) kış. Kışın `kis_durur` yapılar (tarla) durur, çalışanları
  kışın çalışan boş yuvalara kayar, baharda eski işlerine döner (8.5).
- Kişi başı 1 gıda; kışın hane başı +1 odun. Odun yetmezse herkes `soguk_saglik` kaybeder. Gıda yetmezse en son
  gelenler aç kalır: sağlık ve moral kaybı, ertesi gün verim yarı.

### Akçe (5)
- **Tezgâh**: kervan fiyatının %60'ı, günde en çok 4 akçe.
- **Kervan**: 3 günde bir; tam fiyatla alır; demir, alet ve kışlık tahıl satar.
- **Haftalık vergi**: hafta başı işçi 1, usta 3 akçe. **Muhafız**: günde 1 akçe (haftada 7).
- **Rezerv**: son 5 akçe savunma ve lüks harcamalara kilitli.
- **Sur taksiti**: sur seviyesinin bedeli 4 taksitte ödenir; son taksitte sur yükselir (Tester A "sur tuzağı").

### Izgara ve yapılar (6, 7)
- 24×24 hücre (1 hücre = 2 m), ortada 4×4 meydan; kapıdan meydana bir patika ile başlanır.
- Yapı boş hücrelere oturur ve bir kenarı meydana bağlı bir yola ya da meydana değmelidir (6.3).
- Yol yalnız bağlı bir yola komşu boş hücreye döşenir.
- Kurulum malzemeyi düşer, iskele `insa_gun` sürer; boştaki her 3 köylü bir gün kısaltır (6.4).
- Yıkım: harcananın %50'si geri, çalışanlar boşa, oturanlar evsiz kalır (6.5).
- Katalog: çadır, kulübe, tarla, hızarhane (odun / kereste), taş ocağı, avcı kulübesi (gıda + kürk), atölye
  (alet / yakacak), ambar (+100 kapasite).

### İş ve moral (8, 11)
- Yuvalar 1–3; köylü yalnız hazır yapıya atanır. Muhafız en çok 2.
- Moral 0–100: tok +2, aç −15, evsiz −8, asayiş riski > 50 ise −4, adalet < 30 ise −3. Huzur = moral ortalaması.
- **İsyan**: huzur ≤ `isyan_esigi` (10) olunca 3 günlük sayaç; isyanda üretim durur, her gece bir köylü erzak
  çalıp kaçar. Çıkış: aş dağıt, haftanın vergisini sıfırla, elebaşını sür. Sayaç biterse son: isyan.
  *Plan "moral 0" diyor; ortalamanın 0 olması herkesin 0 olması demek olduğundan eşik ayar değeri, 10.*
- **Kritik bonus** (11.5): morali 80 üstü çalışan %20 fazla üretir; ambar doluysa fazlası tezgâh fiyatından akçe olur.

### Aşamalar ve son (15, 16)
- 18 nüfus: Ağalık. Sonra her 7 günde Tekfur haraç ister (`harac_akce`, `harac_gida`); cevapsız haraç
  reddedilmiş sayılır. Her ret bir baskın getirir: Tekfur gücü `2 + 2 × ret` ≥ savunma (`sur × 2 + muhafız +
  asker / 2`) ise son: Tekfur. 3 baskı savuşturulursa son: zafer.
- **Emniyet kilidi**: nüfus < 3 sonu, köy en az bir kez 5 nüfusa ulaşmış **ve** 4. gün geçmişse işler.
- **Kayıt**: `user://savegame.json`; önce `.tmp`'ye yazılıp doğrulanır, eski kayıt `.bak` olur; ana kayıt bozuksa
  yedek yüklenir (13).

## Formulas

- **F1 Tüketim**: `gida = nüfus × gida_kisi`; kışın `odun = hane × kis_odun_hane` (hane = dolu barınak + evsizler 1).
- **F2 Tezgâh**: `akçe = min(⌊adet × fiyat × 0.6⌋, 4 − bugün_kazanılan)`; satılan = `⌈akçe / (fiyat × 0.6)⌉`.
- **F3 Vergi**: `Σ (usta ? 3 : 1)`; usta = `usta_*` bayrağı ya da stat ≥ 7.
- **F4 Üretim**: `Günlük = Temel × (0.5 + Stat / 10) × Bileşik × (aç ? 0.5 : 1)`; artık ondalık yapı başına birikir.
- **F5 Bileşik çarpan**: `clamp(Π çarpan, 0.4, 1.5)`; yapının uzmanlığına uyan `usta_*` 1.3, `tembel`/`agir_yarali`/`hasta` 0.7.
- **F6 Husumet**: ret +1/+3, gece −1; ≥ 10: %40 baskın, ≥ 5: %25 sızma; her muhafız zarı 0.1 düşürür.
- **F7 Sur taksiti**: `⌈sur_bedel[seviye] / 4⌉`.

Örnek (F4): stat 8 usta çiftçi, tarla temel 2 → `2 × 1.3 × 1.3 = 3.38` gıda/gün.

## Edge Cases
- Ambar dolu: üretim ambara sığdığı kadar, yapı "ambar dolu" bekler.
- Reçete girdisi yok: yapı "girdi" bekler, o gece üretmez.
- Isyanda köy boşalırsa son denetimi nüfus kuralına düşer.
- Kayıt bozuk ve yedek yok: boş sözlük, yeni oyun.
- Kışın tarlası olmayan çiftçi boşta kalır; boştakiler inşaatı hızlandırır.

## Dependencies
Kapı ekranı ve sohbetler (bayraklar, Aşama B), karakter sayfaları (`karakterler/CHR_*.md` → stat, gizli bayrak),
köy sahnesi (ızgaradan yerleşim, Aşama C), ses (Aşama D).

## Tuning Knobs
Tümü `KoyAyarlari` (`data/ayarlar/koy.tres`) ve `data/koy/binalar.json`. Denge `tools/denge/koy_benzetimi.gd` ile
ölçülür: ilk sürümde tarla aletsiz kurulur (alet kilidi gıdayı 11. günde sıfırlıyordu) ve kervan kışlık tahıl
satar (kışın akçe gıdaya dönebilsin diye).

## Acceptance Criteria
Hepsi `tests/unit/koy_yonetimi/koy_yonetimi_test.gd` içinde:
- Takvim: 21–27 kış, 7 hafta başı; ambar kapasitesi; F4–F5 sınırlar dahil.
- Izgara: yol yanına kurulur, yoldan uzak/üst üste/sınır dışı kurulmaz; kopuk yol döşenmez.
- İnşa: boştakiler iskeleyi kısaltır; hazır olmayana atama yok; yuva sınırı; yıkım iadesi; girdi yok bekleme.
- Tezgâh tavanı; kervan tam fiyat; haftalık vergi (usta 3); muhafız maaşı.
- Harç (sömürülmüş, sadakat, adalet), rüşvet asayişi, iltimas moral cezası, usta Tekfur'a geçer.
- Husumet sönümü ve eşikleri, muhafız zarı; sur taksitleri ve rezerv kilidi.
- Açlık, kış soğuğu, kış kaydırması ve bahar dönüşü; isyan sonu ve isyandan çıkış.
- Emniyet kilidi; Ağalık, haraç, Tekfur yenilgisi; kayıt geri yükleme ve bozuk kayıtta yedek.
