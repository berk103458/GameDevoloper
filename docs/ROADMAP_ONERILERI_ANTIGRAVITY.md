# Yeni ROADMAP Madde Önerileri — Anlatı, Diyalog ve Karakter Derinleştirmesi

**Hazırlayan:** Antigravity  
**Tarih:** 4 Kasım 2026  
**Dal:** `feature/diyalog-yeniden-yazim`  
**Not:** Bu dosya bir öneri taslağıdır; Ahmet ve Muharrir onaylamadan ROADMAP dosyalarına doğrudan ekleme yapılmamıştır.

---

## 1. Giriş ve Gerekçe
Bu gece Görev 3'ten 9'a kadar gerçekleştirilen yeniden yazım ve derinleştirme süreciyle:
- 30 kapı ziyaretçisinin diyalogları insanlaştırıldı,
- Eş karakteri kapıda fısıldayan ve odada dertleşilen canlı bir karaktere dönüştürüldü,
- 11 köylüyle Parley üzerinden etkileşimli sohbetler ve 8 köy olayı kuruldu,
- 85 yer tutucu metin gerçek dönem diliyle dolduruldu.

Bu sağlam temel üzerinde oyunun anlatısını dünya çapında bir seviyeye taşıyacak, oyuncuda iz bırakacak ve açık kalan anlatı uçlarını bağlayacak 7 yeni madde önerisi aşağıda yapılandırılmıştır.

---

## 2. Madde Önerileri Listesi

### Öneri 1: ANL-DON-01 — Kabul Edilen ve Reddedilen Ziyaretçilerin Geri Dönüşü (Echo Visits)
- **Madde Kodu:** `ANL-DON-01`
- **Başlık:** Ziyaretçi Geri Dönüş Döngüsü ve İkinci Karşılaşmalar
- **Kısa Açıklama:**
  İlk 10-15 günde kapıdan içeri alınan veya geri çevrilen kritik ziyaretçilerin (Dursun, Turna, Lokman, Sungur, Banu Hatun) 5-10 gece sonra yeni bir durumla kapıya veya köy meydanına yeniden gelmesi.
  - *Örnek 1:* Geri çevrilen Sancak Çavuşu Sungur'un, divandan aldığı 'zorla arama' fermanıyla yanında 5 neferle dönmesi.
  - *Örnek 2:* Kabul edilen yeğen Dursun'un, ablası Turna ile fırında pişirdikleri ilk sıcak ekmeği gece nöbetindeki Muhafız'a getirmesi.
  - *Örnek 3:* Şarlatan Lokman'ın sattığı sahte merhem yüzünden köyde çıkan arbede.
- **Gerekçe:**
  Oyuncunun verdiği kararların sadece barlarda (moral/adalet) soyut sayılar olarak değil, yaşayan insanların yüzünde ve eylemlerinde geri döndüğünü kanıtlar. Kararların ağırlığını ikiye katlar.
- **Tahmini Boyut:** Kapsamlı (6 yeni kısa kapı sekansı + 3 köy içi yüzleşme)
- **Kod Gerekir mi?:** Hayır / Çok Az. Mevcut ziyaretçi havuzuna `ziyaretci_kosul` bayraklarıyla bağlanabilir.

---

### Öneri 2: ES-GECM-01 — Eşin Geçmişi, Evlilik Hikâyesi ve Gelecek Korkusu
- **Madde Kodu:** `ES-GECM-01`
- **Başlık:** Eşin Kişisel Anlatı Yayının (Arc) Genişletilmesi
- **Kısa Açıklama:**
  Oda sohbetinde (`koylu_muhabbet_es.ds`) eşin geçmişine ve iç dünyasına dair 3 yeni derin diyalog dalı açılması:
  1. *Eski Köyün Yangını:* Uç beyliğine gelmeden önceki memleketlerinin Tekfur akıncılarınca nasıl yakıldığı ve göç yolu çilesi.
  2. *Yetimler ve Çocuk:* Eşin, fırın çırağı Dursun ve Turna'ya analık etme arzusu ya da kış ortasında kendi evlatlarını kaybetme korkusu.
  3. *Muhafız'a Şifa ve Destek:* Gece nöbetinde donan Muhafız'a şifalı ıhlamur kaynatması, nöbet yorgunluğunu hafifleten eş desteği mekaniği.
- **Gerekçe:**
  Eş karakteri şu an köy olaylarını ve ziyaretçileri yorumlamakta çok başarılı; ancak kendi kişisel hikâyesi açıldığında oyuncu ile duygusal bağı çok daha kuvvetlenecektir.
- **Tahmini Boyut:** Orta (1 yeni Parley alt dalı, yaklaşık 40 düğüm)
- **Kod Gerekir mi?:** Hayır. Yalnızca Parley `.ds` dosyası ve metin eklentisi.

---

### Öneri 3: ANL-EPI-01 — 30. Gün / Kış Sonu Kişisel Epilog Ekranı
- **Madde Kodu:** `ANL-EPI-01`
- **Başlık:** Bireysel Karakter Sonları ve Kader Raporu (Epilog)
- **Kısa Açıklama:**
  Oyun sonuna ulaşıldığında (Ağalık kışını tamamlama veya erken çöküş), yalnızca genel kazanma/kaybetme ekranı yerine; oyuncunun kapıda kabul ettiği, reddettiği veya zindana attığı her karakterin akıbetini gösteren kısa epilog kartları:
  - *"Turna ve Dursun: Köyün fırınını devraldılar, ilkbaharda dükkânın kapısına Hamza dayılarının yüzüğünü astılar."*
  - *"Lokman: Kış ortasında sahte afyon satarken Karaca Usta tarafından kovuldu, dağ yolunda donarak can verdi."*
  - *"Banu Hatun: Süvarileriyle Tekfur'un öncü akınını savuşturdu, baharda obasına döndü."*
- **Gerekçe:**
  Rol yapma ve anlatı ağırlıklı oyunların (Fallout, Papers Please) en büyük tatmin kaynağıdır. Oyuncunun her sorguda harcadığı vaktin boşa gitmediğini hissettirir.
- **Tahmini Boyut:** Orta (Metin şablonları + arayüz kart gösterimi adaptörü)
- **Kod Gerekir mi?:** Evet (Basit bir sonuç metni oluşturucu adaptörü: `sonuc_epilog_olusturucu.gd`).

---

### Öneri 4: SOY-SON-01 — Dedikodu ve Söylenti Ağının Somut Olaylara Kapanışı
- **Madde Kodu:** `SOY-SON-01`
- **Başlık:** Söylenti Ağının Doğrulama ve Çözülme Döngüsü
- **Kısa Açıklama:**
  `soylenti_agi.gd` içinde yayılan söylentilerin (ör. "Değirmenci un çalıyor", "Kuyuya harami zehir atmış", "Tekfur'un altın yüklü arabası devrilmiş") 2-3 gün sonra bir sonuca bağlanması:
  - Ya bir köy içi olayına dönüşür (Değirmenci Çınaraltında hesap verir),
  - Ya kapıya bir şüpheli getirir (Zehir şişesiyle yakalanan seyyar satıcı),
  - Ya da dedikodunun asılsız olduğu anlaşılıp köylülerin birbirine özür borçlanması yaşanır.
- **Gerekçe:**
  Şu an fısıltılar atmosfer katıyor fakat bazen havada kalabiliyor. Söylentinin sonuca bağlanması yaşayan bir ekosistem hissi yaratır.
- **Tahmini Boyut:** Orta (5 yeni dedikodu çözüm sekansı)
- **Kod Gerekir mi?:** Hayır. Var olan olay ve bayrak sistemiyle çalışır.

---

### Öneri 5: KVR-SES-01 — Kapı Nöbetinde Dinamik Hava ve Ayaz Replikleri
- **Madde Kodu:** `KVR-SES-01`
- **Başlık:** Ayaz, Fırtına ve Gece Vaktine Bağlı Replik Varyasyonları
- **Kısa Açıklama:**
  Mevsim ve hava durumu sistemine bağlı olarak, kapıya gelen kişinin ve Muhafız'ın açılış sözlerine dinamik hava durumu satırlarının eklenmesi:
  - Tipi varken: Ziyaretçinin dişlerinin birbirine vurması (`[titreyerek] "A-ağam... dondum... nefesim buz tuttu..."`),
  - Yağmurlu gecede: Çamurlu çizmeler, cübbesinden sular süzülen derviş,
  - Fırtınada: Kapı kulelerindeki meşalelerin cızırdayıp sönmesiyle gelişen kısa diyalog anları.
- **Gerekçe:**
  Görsel asset üretilmeden, yalnızca metin ve ses tasarımıyla oyuncuya dondurucu Anadolu kışını iliklerine kadar hissettirir.
- **Tahmini Boyut:** Küçük (Açılış repliklerine durumsal ön ekler)
- **Kod Gerekir mi?:** Çok Az (Diyalog motoruna 1 satırlık hava kontrolü adaptörü).

---

### Öneri 6: MECLIS-ARA-01 — Çınar Meclisi İnteraktif Dava Sistemi
- **Madde Kodu:** `MECLIS-ARA-01`
- **Başlık:** Köy İçi İhtilaflarda Muhafız'ın Kadı/Hakem Rolü
- **Kısa Açıklama:**
  Haftada bir veya büyük krizlerden sonra Çınaraltında köylülerin Muhafız'ın önüne getirdiği davalar (Karaca Usta ile Yusuf'un alet kavgası, Ayşe Bacı'nın çalınan tavuk davası, yabancı bir tüccarın dolandırılma iddiası).
  - Oyuncu iki tarafı dinler, delilleri tartar, adalet veya akçe odaklı hüküm verir.
- **Gerekçe:**
  Muhafız'ın sadece kapıda nöbet tutan bir bekçi değil, köyün asayiş ve nizamından sorumlu gerçek bir uç beyi vekili olduğunu hissettirir.
- **Tahmini Boyut:** Kapsamlı (4 interaktif meclis davası)
- **Kod Gerekir mi?:** Hayır. Parley üzerinden meclis sahnesinde çalıştırılabilir.

---

### Öneri 7: SES-DIL-01 — Seslendirme Hazırlığı İçin Vurgu ve Reji Notları
- **Madde Kodu:** `SES-DIL-01`
- **Başlık:** Karakter Kartlarına ve Repliklere Seslendirmen Reji Notları Eklenmesi
- **Kısa Açıklama:**
  İleride oyuna profesyonel veya AI destekli seslendirme (voice acting) eklendiğinde seslendirmenlere kılavuzluk edecek; her repliğin duygu durumu, ses tonu, nefes alışları ve duraklama sürelerini içeren reji kılavuzunun hazırlanması (`docs/SESLENDIRME_REJI_KILAVUZU.md`).
- **Gerekçe:**
  Dönem dili (13. yy Anadolu Türkçesi) doğru tonlama ve vurgu olmadan düz okunursa yapay durabilir. Reji notları gelecekteki seslendirme kalitesini güvenceye alır.
- **Tahmini Boyut:** Küçük
- **Kod Gerekir mi?:** Hayır (Yalnızca dokümantasyon).

---

## 3. Özet Karşılaştırma Tablosu

| Madde Kodu | Başlık | Öncelik | Boyut | Kod Değişikliği | Temel Kazanım |
|---|---|---|---|---|---|
| `ANL-DON-01` | Ziyaretçi Geri Dönüş Döngüsü | Yüksek | Kapsamlı | Hayır (Bayraklarla) | Kararların uzun vadeli somut etkisi |
| `ES-GECM-01` | Eşin Geçmişi ve Çocuk Korkusu | Yüksek | Orta | Hayır (Parley) | Güçlü duygusal bağ ve derinlik |
| `ANL-EPI-01` | Kış Sonu Kişisel Epilog Ekranı | Yüksek | Orta | Az (Sonuç Adaptörü) | Kusursuz oyun sonu tatmini |
| `SOY-SON-01` | Söylentilerin Olaylara Kapanışı | Orta | Orta | Hayır (Mevcut Olaylar) | Yaşayan ve tutarlı dedikodu ekosistemi |
| `KVR-SES-01` | Dinamik Ayaz ve Fırtına Replikleri | Orta | Küçük | Az (Hava Adaptörü) | Sert kış atmosferi ve imersiyon |
| `MECLIS-ARA-01`| Çınar Meclisi İnteraktif Davaları | Orta | Kapsamlı | Hayır (Parley Meclis) | Köy idaresinde kadı/hakemlik rolü |
| `SES-DIL-01` | Seslendirmen Reji Kılavuzu | Düşük | Küçük | Hayır (Doküman) | Gelecekteki seslendirme standardı |

---
*Bu liste Ahmet'in incelemesine sunulmuştur. Onaylanan maddeler ROADMAP_2.md'ye yeni görevler olarak eklenebilir.*
