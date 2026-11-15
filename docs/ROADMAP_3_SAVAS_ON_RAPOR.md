# ROADMAP 3 — Savaş Ön Raporu

> Hazırlayan: Cursor (15 Kasım 2026). Durum: **ön rapor**. ROADMAP_3 dosyası değildir, madde sahipliği açmaz.
> Hedef okur: Antigravity (Google ajanları), Ahmet, Berk, Muharrir, Usta.
> Yöntem: yüzeysel araştırma. Önce repo taraması, sonra kısa ilham notları. Derin tarih araştırması yapılmadı.
> Kural hatırlatması: Bu rapor kod, asset ve ROADMAP_2 değişikliği içermez. ROADMAP_3'e geçerken AGENTS.md kuralları aynen geçerlidir: genişletme, yeniden yazma değil; asset üretme yasağı, yer tutucu kutu ve envanter; veriye dayalı sayılar; Türkçe commit ve imza.

---

## 0. Amaç ve kapsam

ROADMAP_3 yalnızca **savaş** konusunu kapsar. Üç eksen var:

1. **Mekanikler:** Kapıda kavga, baskın, kuşatma, akın, saldırı ve savunma, yaralanma, ölüm, moral, ganimet ve savaşın köye etkisi.
2. **Karakterler:** Savaşa girebilecek dost ve düşman tipleri ile rolleri.
3. **Motor:** Sıra tabanlı savaş motoru. Tur yapısı, inisiyatif, aksiyon puanı, ızgara, zar bağı, yapay zekâ ve arayüz akışı.

Tasarım ilkesi: Oyun **ciddi ve gerçekçi** kalır. Savaş az olur ve pahalıdır. Her ölüm köyde bir hane, bir cenaze ve bir söylenti olarak iz bırakır. Savaş ayrı bir oyun gibi değil, kapı ve köy yönetiminin bir sonucu gibi hissettirmelidir.

---

## 1. Mevcut durum özeti

### 1.1 Repoda savaşla ilgili olanlar

| Alan | Dosya / veri | Ne yapıyor | Eksik |
|---|---|---|---|
| Kapıda kavga tetikleme (CAT-01) | `src/kapi/kapi_kavgasi.gd`, `data/kapi_kavgasi.json` | Sert ret veya yer yokluğu durumunda, genç erkek, aç aile reisi ya da asker kaçağı tipi kavga isteği doğurur. Kavga yalnız kapıda ve en az 1 asker varken açılır. | Kavga tek bir zar sonucudur. Konum, tur ve birden fazla katılımcı yoktur. |
| Dört kavga seçeneği (CAT-02) | aynı dosya; `kapi_kavgasi_paneli.gd` | Askerle karşılık, akçeyle erteleme, sözle yatıştırma ve reddetme. Karşılık tek zar atar. Sonuç tablosu şöyledir: kritik başarı → kaçtı, başarı → yaralanma, başarısız → kin, kritik başarısız → ölüm. | "Askerle karşılık" sıra tabanlı savaşa açılan doğal kapıdır, ama şu an tek atışla biter. |
| Yaralı tedavisi (CAT-03) | `src/koy/hekim_ilac.gd` adaptörü, KRI-03 | Hekim ve şifahane varsa yaralı iyileşir. Yabancıyı tedavi edip göndermek grup itibarına +1 yazar. | Yara derecesi yok (hafif, ağır, sakat). Kalıcı iz yok. |
| Sıranın korkusu (CAT-04) | `src/kapi/siddet_korkusu.gd` | Şiddet, sıradakilerin tansiyonunu artırır. Eşiği aşanlar tablodaki olasılıkla ayrılır. | — (savaş sonrası toplumsal etkiye örnek olarak kullanılabilir) |
| Görünür zar (ZAR-01..06) | `src/kapi/sorgu_zari.gd`, `data/chr_runtime/sorgu_kurallari.tres` | d6 ve d12 kullanılır. Kural `zar >= gerekli`. Tavan her zaman başarı, 1 her zaman başarısızdır. Tansiyon kademeleri, değiştiriciler ve `basari_olasiligi` vardır. | Savaşta kullanılmak üzere genelleştirilmemiştir. Sorgu bağlamına bağlıdır. |
| Husumet → sızma / baskın | `src/koy/husumet.gd`, `husumet_baskini.gd`, `koy_yonetimi.gd:_husumet` | Retler husumet biriktirir. Eşik aşılınca gece zarı atılır: sızma (ganimet kaybı) ya da baskın (stok kaybı, 2 kişiye yaralanma zarı, sosyal sonuç). Muhafız sayısı zar olasılığını düşürür. | Baskın tamamen soyuttur. Oyuncu müdahale etmez. |
| Karaboran intikamı (CAS-08) | `src/kapi/karaboran_intikami.gd` | CHR_004 zindana atılırsa 3 gece sonra aynı husumet baskını tetiklenir. | Aynı soyut çözüm. |
| Tekfur baskını | `koy_yonetimi.gd:_asamalar`, `tekfur_gucu()`, `savunma_gucu()` | Haraç reddedilince baskı artar. `tekfur_gucu > savunma_gucu` ise oyun SON_TEKFUR ile biter. Belirli sayıda baskın savuşturulursa zafer gelir. | Tek sayı karşılaştırmasıdır. Kuşatma, kayıp ve taktik yoktur. Oyunun en önemli savaşı en zayıf mekaniktir. |
| Savunma gücü | `koy_yonetimi.gd:savunma_gucu()` | Sur gücü + etkin muhafız + yetişkin asker sayısının yarısı. Karantinadaki, uyuyan ve isyancı askerler sayılmaz. | Silah, zırh ve moral hesaba katılmaz. |
| Taktik konuşlanma (HAR-10 / HAR-15) | `src/koy/savunma_konuslanmasi.gd`, `savunma_guvenligi.gd`, `data/savunma_konuslanmasi.json` | Gerçek kişiler rollere atanır: kapı mızraklısı (2), sur okçusu (4), devriye. Rol payı Güvenlik değerine katkı verir. Konumlar mevcut A* ızgara hücreleridir. | Konuşlanma yalnızca bir sayıya yansır. Savaş anında bu konumlar kullanılmaz. **ROADMAP_3 için hazır bir başlangıç kurulumu sağlar.** |
| Kurt baskını (MEV-10) | `src/koy/kurt_baskini.gd` | Kış gecesi ağıl baskını. Muhafız ağılı korur, yoksa yemle uzaklaştırılır. | Hayvan düşman şablonu için örnek. |
| Kıtlık isyanı / ambar yağması (KRI-06, KRI-14) | `kitlik_isyani.gd`, `kitlik_nobeti.gd` | İç karışıklık, ambar kapısı hasarı, moral kaybı. | İç çatışma, savaş dışı kalmalı mı? (Açık soru 7.6) |
| Moğol öncüsü (HAR-02) | `src/sistemler/mogol_oncusu.gd`, `data/mogol_oncusu.json` | Geri sayım ve uyarı. Koddaki not açık: "savaş/para/zar eklenmez." | Sayaç dolunca ne olacağı tanımlanmamış. **ROADMAP_3'ün en büyük boşluğu.** |
| Sancak asker talebi (HAR-04) | `src/sistemler/sancak_asker_talebi.gd` | Fermanla gerçek köylüler orduya gönderilir ve köyden düşer. | Gidenlerin akıbeti (dönüş, ölüm, ganimet) yok. |
| Çete anlaşması (HAR-08) | `src/koy/cete_anlasmasi.gd` | Aylık rüşvet karşılığında dokunulmazlık. | — |
| Pusu temizliği (HAR-05, HAR-14) | `data/pusu_ticaret_akisi.json` | Başarılı pusu temizliği tüccar akışını artırır. | Pusunun kendisi oynanmıyor. Dış sefer için doğal bir aday. |
| Tehdit takvimi (BUG-18, OMR-42) | `src/sistemler/tehdit_takvimi.gd` | Nüfus 14'ün altındayken kurt dışındaki baskınlar gelmez. "Nüfus 18 öncesi savaş yok." | ROADMAP_3 bu kapıyı korumalı. |
| Okçuluk mini oyunu | `src/arayuz/okculuk_oyunu.gd` | Ayrı bir beceri oyunu. | Sur okçusu becerisine bağlanabilir (Açık soru 7.9). |
| Sınıflar ve karakterler | `data/siniflar/asker.tres`, `data/karakterler/*.tres`, `karakterler/CHR_*.md` | Üç sınıf var: asker, çiftçi, esnaf. Adlı askerler: aydogdu, nogay, miraen. CHR_021..024 asker kaçağı ya da eski asker. | Savaş istatistiği yok (saldırı, savunma, inisiyatif, can/yara, moral, ekipman). |
| Donanım | `data/muhafiz_donanimi.json` | Kılıç ve mızrak yer tutucu parçaları (yalnız görsel kutular). | Silah ve zırh istatistiği yok. |
| Gruplar | `data/gruplar.json` | Türkmen, Rum, Ahi, Köylü, Tüccar, Asker; itibar ve karar deltaları. | Savaş sonuçları itibara yazılmıyor. |
| Dünya olayları (DNY-01..04) | `data/dunya/zaman_cizelgesi.json` | Moğol ilerleyişi ve diğer olaylar; haber ve rapor metinleri hazır, kod Kalfa'yı bekliyor. | Savaşa giriş tetikleyicisi olarak kullanılabilir. |

### 1.2 ROADMAP_2 notları

- ROADMAP_2 durumu (15 Kasım): 941 `[x]`, 29 `[/]`, 108 `[ ]`.
- `ROADMAP_2.md:808` "Yeni maddeler CAT-05 … CAT-84" diyor, ama bu maddeler hiç yazılmamış. ROADMAP_3 bu boşluğu kapatmalı. ID karışmasın diye CAT dizisini uzatmak yerine yeni **SVS** önekini öneriyorum (Açık soru 7.1).
- ROADMAP_2 birçok yerde açıkça "yeni savaş yok" diyor: Bölüm 26 nöbet devri, YAP-56 usta defterleri ("Yeni savaş … açılmaz"), MCL-09 ("Meclis savaş … açamaz"), HAR-02. Bunlar ROADMAP_2'nin sınırlarıdır. ROADMAP_3 bu sınırları bilinçli olarak açar, ama ROADMAP_2 maddelerinin kabul testlerini bozmamalıdır.

### 1.3 Kısa sonuç

Savaş verisinin ve sonuç zincirinin iskeleti hazır: kim asker, kim yaralı, kim öldü, cenaze, söylenti, itibar, güvenlik ve konuşlanma. Eksik olan **savaş anının kendisi**. Şu an her çatışma bir zar ya da bir sayı karşılaştırmasıyla bitiyor. ROADMAP_3'ün ana işi bu anları oynanır kılmak. Bunu yaparken mevcut formüller (`savunma_gucu`, `SorguZari`, `HusumetBaskini`) silinmemeli, **otomatik çözüm** yolu olarak kalmalı.

---

## 2. İlham notları (yüzeysel)

### 2.1 Dönemin uç savaşı (13.–14. yy Anadolu)

- **Küçük ölçek:** Uç savaşının çoğu meydan muharebesi değildi. Akın, baskın, pusu, sürü ve köle kaçırma, kervan vurma ve kısa süreli kuşatmalardan oluşurdu. Bir köy için tipik tehdit 10–40 kişilik bir gruptur.
- **Hafif atlı okçu (akıncı, Türkmen):** Vur-kaç yapar, sahte ricat uygular ve okla yıpratır. Yakın dövüşten kaçar, ganimet ve esir peşindedir. Yaya ve sur savunmasına karşı zayıftır.
- **Tekfur askeri ve Rum milisi:** Daha ağır zırhlı (zırh gömleği, kalkan) yaya ve az sayıda atlıdan oluşur. Sur ve kale savunmasında güçlüdür, açık arazide yavaştır.
- **Eşkıya / harami:** Asıl amacı öldürmek değil, mal almaktır. Moralleri bozulunca hemen dağılırlar. Gece ve sis severler. Köyde içeriden yardımcıları olur (CHR_004 ve CHR_009 bunun örneği).
- **Köylü milis:** Orak, balta, sopa ve sapan kullanır. Moral düşüktür ama evini korurken direnç artar.
- **Kuşatma:** Küçük bir köyde gerçek kuşatma makinesi beklenmez. Kapıyı yakmak ya da kırmak, suru tırmanmak, kuyuyu ve ambarı hedef almak, aç bırakmak ve pazarlık gerçekçi araçlardır.
- **Savaş sonu:** Fidye, esir değişimi, haraç anlaşması, ganimet paylaşımı ve kan davası. Bunlar mevcut grup itibarı ve söz sistemine doğal olarak bağlanır.
- **Dönem uyarısı:** Repodaki dünya kitabı oyunu Kösedağ (1243) sonrasına, Selçuklu ucuna koyuyor. İstekte ise "14. yy Osmanlı uç beyliği" geçiyor. Bu fark karakter adlarını (akıncı, sipahi, tımar) ve düşman türünü (Moğol mu, Bizans mı ağırlıklı) değiştirir. **Karar gerekiyor (Açık soru 7.2).**

### 2.2 Sıra tabanlı oyunlardan alınacaklar

| Oyun | Alınacak | Alınmayacak |
|---|---|---|
| **Battle Brothers** | Altıgen ızgara, aksiyon puanı ve yorgunluk birlikte; ön ve arka sıra; moral durumları (kararlı → sarsılmış → bozgun); kalıcı yara ve sakatlık; ölümün kalıcı olması; silaha göre farklı yetenekler. | Paralı asker şirketi yönetimi, sınırsız asker alma. |
| **Darkest Dungeon** | Stres veya moralin ayrı bir kaynak olması; savaş sonrası kamp ve iyileşme ekonomisi; kahramanların kalıcı travmaları. | Sabit 4'lü sıra düzeni, fantastik düşmanlar. |
| **XCOM** | İki eylemli basit tur (hareket + eylem); siper ve görüş; isabet olasılığının açıkça gösterilmesi; düşman sırasının görünmesi. | Bilimkurgu ekipman ağacı, %95 ıskalama şakası (zar şeffaf olmalı). |
| **Mount & Blade** | Savaş öncesi karar: savaş, pazarlık, kaç, rüşvet ver, adam bırak; otomatik çözüm seçeneği; esir ve fidye; birlik moralinin komutana bağlı olması. | Gerçek zamanlı savaş. |
| **Into the Breach** | Düşman niyetinin bir tur önceden görünmesi; küçük harita, az birim, her hamlenin önemli olması. | Bulmaca hissi. |

### 2.3 Bu oyuna çeviri

- Savaş **nadir, küçük ve ağır** olsun. Tipik çatışmada 3–12 birim olsun.
- Kararların çoğu savaştan **önce** verilsin: konuşlanma, pazarlık, rüşvet, kapıyı kapatma, kaçış.
- Zar **görünür** olsun ve ZAR-01 diliyle aynı olsun: d6/d12, `zar >= gerekli`, sözcükle yazılan sonuç.
- **Can puanı yerine yara basamakları** olsun (Açık soru 7.4). Gerçekçilik hedefine daha uygun.
- Savaş sonrası her şey mevcut sistemlere akmalı: cenaze (KRI-05), şifahane (KRI-03, KRI-13), söylenti (DIY-13), grup itibarı, hane, yetimler (KAP-18).

---

## 3. Mekanik listesi

Her mekanik için önerilen yön yazıldı. Detay ROADMAP_3 maddelerinde açılacak.

### 3.1 Çatışma türleri (ölçek basamakları)

| # | Tür | Yer | Tipik boyut | Tetikleyici (mevcut) | Önerilen çözüm |
|---|---|---|---|---|---|
| M1 | **Kapı arbedesi** | Kapı önü (küçük arena) | 1–3'e 1–3 | CAT-01 / CAT-02 "askerle karşılık" | Sıra tabanlı kısa savaş. İstenirse eski tek zar otomatik çözüm olarak kalır. |
| M2 | **Gece baskını / sızma** | Köy (mevcut ızgara) | 3–8 eşkıyaya karşı nöbetçiler | `Husumet.gece` → `baskin`, CAS-08 | Gece görüşü kısıtlı sıra tabanlı savaş. Hedef ambar ya da ağıl. Otomatik çözüm `HusumetBaskini.uygula` olarak kalır. |
| M3 | **Tekfur baskını / kapı kuşatması** | Sur + kapı + iç avlu | 8–20'ye karşı köy savunması | `tekfur_baski > savusturulan` | Çok aşamalı savunma: yaklaşma, kapı ve sur, gedik, iç avlu. Başlangıç dizilişi HAR-10 konuşlanmasından gelir. Otomatik çözüm `tekfur_gucu > savunma_gucu`. |
| M4 | **Moğol akın kolu** | Köy + çevre | Büyük öncü kol | HAR-02 sayacının dolması | Doğrudan savaş yerine karar düğümü olabilir: kaç, saklan, haraç ver, savun (Açık soru 7.7). |
| M5 | **Dış sefer / pusu temizliği** | Harita düğümü (dağ yolu, geçit) | 3–8 seçilmiş köylü | HAR-05, HAR-14 | Oyuncunun başlattığı küçük saldırı. Ganimet ve tüccar akışı ödülü vardır. |
| M6 | **Kervan koruma** | Yol | 2–6 muhafız | `kervan_korumasi.json` | Savunma senaryosu. Kervanı kaçırmak kazanma koşuludur. |
| M7 | **Hayvan saldırısı** | Ağıl | Kurt sürüsü | MEV-10 | Mevcut soyut kalabilir. İstenirse M2'nin hafif bir türü olur. |
| M8 | **İç kargaşa** | Ambar, meydan | Köylüler | KRI-06, KRI-14 | **Önerim: savaş motoruna sokulmasın.** Kendi halkına kılıç çekmek ayrı bir ahlak kararıdır (Açık soru 7.6). |

### 3.2 Savaş öncesi

- **M9 Savaş kararı ekranı:** Savaş, pazarlık, rüşvet (akçe ya da erzak), kapıyı kapatıp bekle, kaç / sakla, otomatik çöz. Mount & Blade benzeri. Pazarlık mevcut söz sistemi ve zar ile yapılır.
- **M10 Keşif ve erken uyarı:** Gözcü kulesi (HAR-06, HAR-13) düşman sayısını ve türünü önceden gösterir. Kule yoksa sayı "bilinmiyor" görünür.
- **M11 Konuşlanma:** HAR-10 rolleri (kapı mızraklısı, sur okçusu, devriye) savaşın başlangıç konumlarına dönüşür. Oyuncu savaş başında sınırlı bir yeniden diziliş yapabilir.
- **M12 Silahlanma:** Köyün silah stoğu (silah karaborsası, demirci) birimlere dağıtılır. Silahı olmayan köylü alet kullanır.

### 3.3 Savaş anı

- **M13 Saldırı ve savunma zarı:** Saldırı d12, gerekli değer = hedefin savunması + mesafe + siper + yorgunluk + moral. Kural ZAR-01 ile aynıdır. Hasar ve yara d6 ile ya da tabloyla belirlenir.
- **M14 Yakın dövüş ve menzil:** Kılıç / balta, mızrak (2 hücre, karşılama saldırısı), yay (menzil, sur bonusu), sapan / taş (köylü). Kalkan savunmaya ekler.
- **M15 Siper ve yükseklik:** Sur, kapı, çit, ev duvarı ve ağaç siper sağlar. Sur yüksekliği okçuya bonus verir.
- **M16 Kapı ve sur hasarı:** `sur_hasar` ve kapı hasarı savaş içinde değişir ve savaştan sonra da kalır. Onarım mevcut taş ve kereste bedeline bağlanır (KRI-06 onarım modeli).
- **M17 Yangın:** Saldırgan kapıyı ya da ambarı yakabilir. Mevcut kundak ve yangın akışlarına bağlanır (`yaz_su_yangin.json`, ambar kundaklaması).
- **M18 Moral:** Birim başına moral basamakları: kararlı, tedirgin, sarsılmış, bozgun. Komutan (muhafız ya da çavuş) yakınlığı, ölen dost, sayısal üstünlük ve evini savunma moral değiştirir. Bozgundaki birim kaçar. Eşkıya erken bozulur.
- **M19 Yorgunluk:** Her eylem yorar. Mevcut nöbet yorgunluğu (UZM-14) savaşa yorgun başlamak anlamına gelir.
- **M20 Görüş ve gece:** Gece savaşında görüş kısalır. Meşale ve muhafız ışığı (`muhafiz_donanimi.json` ışık değerleri) görüşü açar.
- **M21 Teslim ve esir:** Bozgundaki ya da ağır yaralı düşman teslim olabilir. Esir zindana gider (mevcut divan ve zindan akışı). Fidye ya da hüküm divana düşer.
- **M22 Geri çekilme:** Oyuncu da harita kenarından çekilebilir. Kaçan birim ganimet bırakır, moral kaybeder.

### 3.4 Savaş sonrası

- **M23 Yara basamakları:** Sağlam, hafif yara, ağır yara, ölümcül (o gece hekim yoksa ölür), sakat (kalıcı: iş gücü düşer, asker olamaz). CAT-03 ve KRI-03 tedavi akışı genişletilir.
- **M24 Ölüm:** Mevcut nüfus ve cenaze akışına tek çağrı yapılır (CAT-02 kuralı korunur). Hane reisi ölürse hane, eş, yetim ve miras etkileri devreye girer.
- **M25 Ganimet:** Düşmandan silah, zırh, at, akçe, defter (YAP-56) ve esir. Paylaşım kararı (beye pay, köye pay, muhafıza pay) mevcut kasa ve vergi ile adalet / yozlaşma terazisine bağlanır.
- **M26 Köye etkisi:** Moral (zafer +, kayıp −), Güvenlik, husumet puanı, grup itibarı (Rum, Türkmen, Asker), söylenti, kervan ve tüccar akışı, göç (kapıya savaştan kaçanlar gelir: KAP-18 yetim kafilesi).
- **M27 Kan davası ve intikam:** Öldürülen eşkıyanın çetesi husumet kazanır. Öldürülen tekfur askeri tekfur baskısını artırır.
- **M28 Hafıza defteri ve gece raporu:** Savaş özeti mevcut gece raporuna ve hafıza defterine yazılır. Ayrı bir rapor sahnesi açılmaz (GRV-12 kuralı).

---

## 4. Karakter listesi

İstatistik önerisi: tüm birimler aynı şablonu kullanır. Değerler veride tutulur. Önerilen alanlar:

`saldiri`, `savunma`, `menzil_becerisi`, `inisiyatif`, `dayaniklilik` (yara eşiği), `moral_tabani`, `yorgunluk_tavani`, `ekipman` (silah, kalkan, zırh), `rol_etiketleri`.

### 4.1 Dost (köy tarafı)

| Tip | Kaynak (mevcut) | Rol | Not |
|---|---|---|---|
| **Muhafız (oyuncu karakteri)** | `Oturum`, muhafız yetenekleri | Komutan, yakın dövüş | Moral aurası, emir (bir müttefike ek eylem). Ölümü oyunun sonu mu, yoksa ağır yara mı? (Açık soru 7.5) |
| **Çavuş / nöbet başı** | Yeni rol etiketi (mevcut asker sınıfından) | Ast komutan | Muhafız yokken moral kaynağı. CHR_023'teki "çavuş Bedri" adı dünyada var. |
| **Kapı mızraklısı** | HAR-10 `kapi` rolü | Kapıyı tutan, karşılama saldırısı | Başlangıç konumu kapıdır. |
| **Sur okçusu** | HAR-10 `sur` rolü | Menzilli, yüksekten atış | Okçuluk mini oyununa bağlanabilir. |
| **Devriye askeri** | HAR-10 `devriye` | Hareketli yedek | |
| **Adlı askerler** | `aydogdu`, `nogay`, `miraen` (sinif=asker) | Özel yetenekli birim | Kişisel geçmiş ve yemin sistemine bağlanır. |
| **Eski asker / kaçak köylü** | CHR_021 Cemil (levent kaçağı), CHR_022 Bayram (davulcu), CHR_023 Necip (keşif eri), CHR_024 Fehmi (cebe yamağı) | Kabul edilmişse savaşa katılabilir | Davulcu moral, keşif eri görüş, cebeci silah onarımı verir. Kaçak olarak tanınma riski. |
| **Köylü milis** | çiftçi / esnaf sınıfı yetişkinler | Zayıf, çok sayıda | Silah stoğuna bağlı. Kadın ve çocuk savaşmaz (öneri, Açık soru 7.8). |
| **Hekim** | CHR_008, şifahane | Savaş içinde tedavi | Cephe dışında durur, yaralıyı stabilize eder. |
| **Türkmen bey adamı / oba atlısı** | HAR-07 Ertuğrul obası ittifakı, `oba_ittifaki.gd` | Müttefik takviye | İttifak varsa savaşa birkaç atlı okçu gönderir. |
| **Bey / sancak askeri** | HAR-04 sancak, Taşlık Hisar | Takviye ya da talepçi | Büyük tehditte yardım gelebilir, karşılığında borç veya ferman doğar. |
| **Akıncı** | Dönem kararına bağlı | Dış seferde müttefik | 14. yy Osmanlı ucu seçilirse güçlü bir figürdür (Açık soru 7.2). |

### 4.2 Düşman

| Tip | Kaynak (mevcut) | Rol / davranış | Not |
|---|---|---|---|
| **Kızıl Karga harami** | CHR_001, 004, 005, 006 (`Kızıl Karga Dağ Haramileri`), Karaboran | Gece baskını, ganimet odaklı | Erken bozulur. İçeriden casus desteği alır (CHR_004, CHR_009). |
| **Çete reisi (Karaboran)** | `karaboran_intikami.gd` | Lider, moral kaynağı | Öldürülürse çete dağılır, ama kan davası doğar. |
| **Eşkıya okçusu / sapancı** | yeni şablon | Menzilli taciz | |
| **Tekfur askeri (yaya)** | `tekfur_gucu`, HAR-03 | Zırhlı, yavaş, kapı kırıcı | Kalkan duvarı. |
| **Tekfur atlısı / kontaratos** | yeni şablon | Az sayıda, şok saldırısı | |
| **Rum milisi** | `gruplar.json: rum` | Zayıf yaya | Öldürülmesi Rum itibarını düşürür. |
| **Moğol öncü atlısı** | HAR-02, DNY-01 | Atlı okçu, vur-kaç | Doğrudan savaşmak çok pahalı olmalı. |
| **Asker kaçağı (kapıda)** | CAT-01 tipi `asker_kacagi` | Tek kişi, umutsuz | Kapı arbedesi. |
| **Aç aile reisi / genç erkek** | CAT-01 tipleri | Silahsız ya da sopa | Öldürmek çok ağır sosyal ceza doğurur. Yatıştırma hep açık kalır. |
| **Kurt sürüsü** | MEV-10 | Hayvan YZ'si | İsteğe bağlı. |
| **Asi Türkmen beyi adamları** | Türkmen kin bayrağı (`turkmen_kin`, SYS-18) | Otlak kavgası, sürü baskını | Türkmen itibarı ve ittifakla çelişir. Duruma göre dost ya da düşman olur. |

### 4.3 Tarafsız ya da değişken

- **Tüccar kervanı**, **derviş**, **sığınmacı**: Savaş alanında korunacak sivil birimdir. Sivil ölümü ağır itibar cezası doğurur.
- **Ahi kardeşleri**: Esnaf milisi olarak katılabilir (Ahi itibarına bağlı).

---

## 5. Motor taslağı (sıra tabanlı)

### 5.1 Mimari ilke

- **Yeni dosyalar + ince adaptör.** Önerilen klasör: `src/savas/` (motor), `src/arayuz/savas/` (arayüz), `data/savas/` (birim, silah, harita ve tablo verisi), `tests/unit/savas/`.
- Korumalı çekirdek dosyalara (`koy_yonetimi.gd`, `oturum.gd`, `koy_ekrani.gd`, `hud.gd`) yalnızca tek satırlık adaptör çağrısı eklenir.
- Motor **sahneden bağımsız saf mantık** olmalı (RefCounted). Headless testler savaşı arayüz açmadan, deterministik RNG ile koşabilmeli. Bu, mevcut `_rng.state` kayıt düzenine uyar.
- Her çatışma iki yoldan çözülebilir: **oynanır savaş** ya da **otomatik çözüm**. Otomatik çözüm mevcut formülleri kullanır, böylece eski testler bozulmaz. Önerim, otomatik çözümün oynanır savaşla aynı motoru "YZ'ye karşı YZ" olarak koşması. İkinci bir formül yazılmamalı (Açık soru 7.10).

### 5.2 Izgara ve konum

- **Seçenek A — kare ızgara:** Köydeki mevcut A* ve `izgara.gd` hücreleriyle aynıdır. HAR-10 konumları doğrudan kullanılır. Basit ve uyumludur.
- **Seçenek B — altıgen ızgara:** Battle Brothers hissi verir, ama köy ızgarasıyla çeviri katmanı gerektirir.
- **Önerim:** Seçenek A, kare ızgara ve 8 yön. Köy savaşları köy sahnesinde, kapı savaşı küçük sabit bir kapı arenasında yapılır. Yeni harita üretilmez, mevcut sahne kullanılır.
- Hücre özellikleri: geçilebilirlik, siper (yok, yarım, tam), yükseklik (zemin, sur), yanıcılık, kapı (sağlamlık).

### 5.3 Tur yapısı

- **Tur = bir raunt.** Her birim bir kez hareket eder.
- **İnisiyatif:** Raunt başında birim başına `inisiyatif + d6`. Sıra, ekranın üstündeki tur şeridinde görünür. Eşitlikte dost önce gelir (öneri).
- **Aksiyon modeli:** İki seçenek var.
  - **(a) XCOM tipi 2 eylem:** Hareket + eylem ya da iki hareket. Basit ve okunaklı.
  - **(b) Battle Brothers tipi AP:** Ör. 9 AP; hareket hücre başına, saldırı silaha göre. Daha derin, ama arayüzü daha ağır.
  - **Önerim:** (a) 2 eylem + yorgunluk. Ciddi ama sade bir oyun için yeterli, testi de kolay (Açık soru 7.3).
- **Bekle / nöbet tut:** Eylemi sonraya bırakmak (overwatch). Menzile giren ilk düşmana atış ya da mızrak karşılaması.
- **Raunt sonu:** Moral kontrolü, kanama, yangın yayılması, takviye girişi ve kazanma koşulu kontrolü.

### 5.4 Zar sistemiyle ilişki

- `SorguZari` genelleştirilir ya da yanına **`SavasZari`** adaptörü yazılır. Aynı kural kaynağını ve dili kullanır: d6/d12, `zar >= gerekli`, tavan her zaman başarı, 1 her zaman başarısız, sonuç sözcükle yazılır (`ZAR_BASARILI` vb.).
- **İsabet:** d12 ≥ `hedef_savunma + mesafe_eki + siper_eki + moral_eki + yorgunluk_eki − saldiri`.
- **Yara:** d6 + silah gücü − zırh, sonuç yara basamağı tablosuna gider. Tablo veridedir (`data/savas/yara_tablosu.json`).
- **Moral:** d6 ≥ moral eşiği; değiştiriciler veridedir.
- Arayüz isabet olasılığını `basari_olasiligi` ile gösterir. İkinci bir hesap yolu yazılmaz (ZAR kuralı).
- RNG oturum RNG'sinden türetilir, kayıtla tekrarlanabilir.

### 5.5 Yapay zekâ

- **Fayda tabanlı (utility) basit YZ.** Her birim, olası eylemleri puanlayıp en iyisini seçer. Puan ağırlıkları düşman türüne göre veridedir.
- **Davranış profilleri:**
  - **Harami:** Hedef ganimet hücresidir (ambar, ağıl). Zayıf hedefi seçer, moral düşünce kaçar.
  - **Tekfur yayası:** Kapıya ilerler, kalkan duvarını korur, gedik açar.
  - **Atlı okçu:** Mesafe korur, vurup çekilir.
  - **Köylü milis (dost YZ'si, otomatik çözümde):** Savunur, mevzisini bırakmaz.
  - **Çaresiz tek kişi (kapı):** Kaçış yolu arar, sıkışınca saldırır.
- **Niyet gösterimi (Into the Breach):** İsteğe bağlı. Düşmanın bir sonraki hedefinin çizgiyle gösterilmesi. Gözcü kulesi ya da keşif eri varsa açılabilir.
- **Zorluk:** YZ hile yapmaz. Zorluk birim sayısı ve donanımla ayarlanır.

### 5.6 Arayüz akışı

1. **Tetik:** Kapıda kavga, gece olayı ya da harita olayı.
2. **Savaş kararı paneli (M9):** Düşman özeti (gözcüye göre kesin ya da belirsiz), seçenekler, otomatik çözüm tahmini.
3. **Konuşlanma (M11):** HAR-10 dizilişi gelir. Sınırlı yeniden diziliş yapılabilir.
4. **Savaş ekranı:**
   - Üstte tur sırası şeridi.
   - Altta seçili birim kartı: yara, moral, yorgunluk, ekipman.
   - Eylem çubuğu: hareket, saldır, nöbet tut, kalkan, bandaj, emir, çekil. Klavye ve gamepad girdisi Bölüm 45 ile uyumlu olmalı.
   - Hedef üzerine gelince isabet olasılığı ve gerekli zar değeri görünür.
   - Zar atışı mevcut görünür zar kadrajıyla yapılır.
   - Sol altta savaş günlüğü.
5. **Savaş sonu özeti:** Kayıplar, yaralılar, esirler, ganimet ve paylaşım kararı.
6. **Gece raporu ve hafıza defteri** satırları (ayrı sahne yok).

- Tema: Bölüm 43 tema anahtarları. Yeni doku üretilmez. Birimler kutu ve kapsül yer tutucularıyla, isim etiketiyle gösterilir. Assetler envantere yazılır.
- Erişilebilirlik: Sonuç renkle değil sözcükle yazılır. Okuma puntosu GRV-13'e uyar. Savaş hızı ayarlanabilir.

### 5.7 Kayıt

- **Önerim:** Savaş ortasında kayıt yok. Savaş başlamadan önce otomatik kayıt alınır. Oyun savaş sırasında kapanırsa savaş başlangıcından devam edilir. Bu, `GuvenliKayit` ve `KAYIT_SURUMU` göç yükünü küçük tutar (Açık soru 7.11).
- Savaş sonucu mevcut alanlara yazılır: nüfus, sağlık, `sur_hasar`, kaynaklar, husumet, itibar. Yeni kayıt alanı gerekirse SYS-14 adım göçüyle eklenir.

### 5.8 Test

- Saf mantık birim testleri: isabet formülü, yara tablosu, moral eşiği, inisiyatif sırası, kazanma ve kaybetme.
- Sabit tohumlu senaryo testleri: "3 harami / 2 muhafız" gibi senaryolar `senaryo_kosucusu.gd` ile koşulur.
- Otomatik çözüm ile eski formüllerin aynı yönde sonuç verdiğini gösteren denge testi.
- `otomatik_oyuncu.gd` 20 gece koşusunda savaşın otomatik çözümle kilitlenmeden geçtiğinin kontrolü.

---

## 6. ROADMAP_2 ile bağlantılar

| ROADMAP_2 / ROADMAP_1 maddesi | Bağlantı |
|---|---|
| CAT-01..04 | Kapı arbedesinin tetiği ve sonuç tablosu. "Askerle karşılık" seçeneği oynanır savaşa açılır, eski zar otomatik çözüm olarak kalır. "Beşinci seçenek yok" kuralı korunur: savaş, karşılık seçeneğinin içidir. |
| ZAR-01..06 | Savaş zarının dili ve kuralları. |
| CAT-03, KRI-03, KRI-13 | Yara tedavisi, şifahane yatak kapasitesi ve triyaj. |
| KRI-05, CAT-02 kural 5 | Ölüm → cenaze ve yas (`cenaze_yasi.gd`). |
| HAR-10, HAR-15 | Konuşlanma → başlangıç dizilişi; Güvenlik formülü. |
| HAR-02, DNY-01..04 | Moğol akını ve dünya olayları tetikleyici olur. DNY-01 bitmeden KAP-18 açılamıyor, savaş olayı bu zinciri de besler. |
| HAR-03, tekfur baskını | Kuşatma savaşı. |
| HAR-04 | Orduya gidenlerin akıbeti. |
| HAR-05, HAR-14 | Dış sefer / pusu temizliği. |
| HAR-07 | Türkmen müttefik takviyesi. |
| HAR-08 | Çete anlaşması, baskın yerine geçer. |
| CAS-08, husumet | Gece baskını tetikleyicisi. |
| BUG-18, OMR-42 | Nüfus eşiği altında savaş açılmaz. Bu kural korunur. |
| MCL-09 | Meclis savaş açamaz. Savaşı yalnız oyuncu ve olaylar açar. |
| KAP-18 | Savaş sonrası yetim kafilesi. |
| YAP-56 (usta defterleri) | Ganimetten defter düşer; "uzun menzilli yay" savunma formülüne bağlanır. |
| UZM-14, YSM-03 | Nöbet yorgunluğu ve uyku savaşa yorgun başlamak demektir. |
| DIY-13, söylenti ağı (Bölüm 37) | Savaş sonuçları dedikoduya yazılır. |
| Bölüm 43 (GRV), Bölüm 45 (girdi), Bölüm 46 (yerelleştirme) | Arayüz teması, girdi eylemleri ve metin anahtarları. |
| Bölüm 34 (perde yapısı), SYS-19, SYS-20 | 2. perde savunma savaşı ve beş son; tekfur ve haraç sonları savaş sonucuna bağlanır. |

**ROADMAP_2'den ROADMAP_3'e geçiş önkoşulları (öneri):** DNY-01 dünya zaman çizelgesi kodu, GRV tema geçişlerinin kapanması ve yerelleştirme altyapısı (Bölüm 46).

---

## 7. Açık sorular (Ahmet / Berk kararı gerekenler)

1. **ID öneki:** ROADMAP_2'de yazılı ama hiç açılmamış CAT-05..84 dizisi mi kullanılsın, yoksa yeni **SVS-** öneki mi? (Önerim: SVS; CAT-01..04 olduğu gibi kalsın.)
2. **Dönem:** Dünya kitabı oyunu Kösedağ sonrasına (1243, 13. yy, Selçuklu ucu, Moğol baskısı) koyuyor. İstekte "14. yy Osmanlı uç beyliği" yazıyor. Hangisi esas? Bu karar düşman listesini (Moğol mu, Bizans mı ağırlıklı), terimleri (akıncı, tımar, sipahi) ve tarihî olayları değiştirir.
3. **Aksiyon modeli:** XCOM tipi 2 eylem mi, Battle Brothers tipi AP mi? (Önerim: 2 eylem.)
4. **Can modeli:** Yara basamakları mı, sayısal can mı? (Önerim: yara basamakları.)
5. **Muhafızın ölümü:** Muhafız savaşta ölebilir mi? Ölürse oyun biter mi, yoksa yalnız ağır yara mı alır?
6. **İç kargaşa:** Kıtlık isyanı ve ambar yağması savaş motoruna girsin mi? (Önerim: hayır, mevcut akış kalsın.)
7. **Moğol akını:** Doğrudan savaşılabilir mi, yoksa yalnız karar düğümü mü (kaç, saklan, haraç, elçi)? Tarihsel gerçekçilik ikinciyi destekliyor.
8. **Kimler savaşır:** Kadınlar ve gençler savaşa katılabilir mi? Kuşatmada taş atma, ok taşıma ya da yangın söndürme gibi destek rolleri olsun mu?
9. **Okçuluk mini oyunu:** Sur okçusu becerisine bağlansın mı, yoksa ayrı kalsın mı?
10. **Otomatik çözüm:** Oyuncu her savaşı otomatik çözebilsin mi? Kapı arbedesi her zaman isteğe bağlı oynanır mı olsun?
11. **Kayıt:** Savaş ortasında kayıt alınsın mı? (Önerim: hayır, savaş öncesi otomatik kayıt.)
12. **Ganimet paylaşımı:** Paylaşım bir ahlak kararı (adalet / yozlaşma terazisi) olsun mu?
13. **Esir ve fidye:** Esir yönetimi ROADMAP_3'e mi girsin, yoksa divana mı bırakılsın?
14. **Ölçek tavanı:** Bir savaşta en fazla kaç birim olsun? Performans hedefi nedir? (Önerim: 20 birim.)
15. **Ses ve animasyon:** Savaş için hangi asset kalemleri öncelikli? Ses yer tutucusu sessiz kalabilir mi? (Asset kuralı: üretim yok, envanter var.)
16. **Bölüşüm:** ROADMAP_3'te Antigravity ve Cursor / Berk tarafı bölüşümü ROADMAP_2'deki "baştan / sondan / orta" düzeniyle mi yapılsın?

---

## 8. ROADMAP_3 için önerilen madde başlıkları

Henüz detaysızdır. ID önerisi **SVS-xx**. Sıra, önerilen uygulama sırasıdır. Bağımlılıklar parantez içinde verildi.

### A. Temel ve veri

- **SVS-01:** Savaş klasör yapısı ve adaptör sınırları (`src/savas/`, `data/savas/`, `tests/unit/savas/`).
- **SVS-02:** Birim istatistik şablonu (saldırı, savunma, inisiyatif, dayanıklılık, moral, yorgunluk).
- **SVS-03:** Mevcut köylü, asker ve adlı karakterden savaş birimine dönüştürücü (SVS-02).
- **SVS-04:** Silah, kalkan ve zırh veri tablosu; köy silah stoğu (SVS-02).
- **SVS-05:** Düşman şablonları: harami, çete reisi, tekfur yayası, tekfur atlısı, Rum milisi, Moğol atlı okçusu, kurt (SVS-02).
- **SVS-06:** Dost şablonları: muhafız, çavuş, kapı mızraklısı, sur okçusu, milis, hekim, Türkmen atlısı (SVS-02).

### B. Motor çekirdeği

- **SVS-07:** Savaş durumu nesnesi ve deterministik RNG (saf mantık, sahnesiz).
- **SVS-08:** Savaş ızgarası: köy A* hücrelerinden savaş haritası, siper ve yükseklik (SVS-07).
- **SVS-09:** Kapı arenası haritası (küçük sabit ızgara) (SVS-08).
- **SVS-10:** İnisiyatif ve tur sırası (SVS-07).
- **SVS-11:** Eylem modeli: 2 eylem veya AP (karar 7.3) (SVS-10).
- **SVS-12:** Hareket, menzil ve görüş hesabı (SVS-08).
- **SVS-13:** Savaş zarı adaptörü: SorguZari kuralları, isabet formülü (SVS-11).
- **SVS-14:** Yara basamakları ve yara tablosu (karar 7.4) (SVS-13).
- **SVS-15:** Moral basamakları ve bozgun (SVS-13).
- **SVS-16:** Yorgunluk ve nöbet yorgunluğundan devralma (SVS-11).
- **SVS-17:** Nöbet tutma / karşılama saldırısı (SVS-12).
- **SVS-18:** Kazanma, kaybetme, geri çekilme ve teslim koşulları (SVS-15).
- **SVS-19:** Otomatik çözüm: aynı motorda YZ'ye karşı YZ, eski formüllerle denge testi (SVS-18, SVS-20).

### C. Yapay zekâ

- **SVS-20:** Fayda tabanlı YZ çekirdeği (SVS-12, SVS-13).
- **SVS-21:** Davranış profilleri: harami, tekfur yayası, atlı okçu, çaresiz tek kişi (SVS-20).
- **SVS-22:** Düşman niyet gösterimi, gözcü kulesine ve keşif erine bağlı (SVS-20, HAR-06).

### D. Savaş türleri

- **SVS-23:** Kapı arbedesi: CAT-02 "askerle karşılık" seçeneğinden oynanır savaşa geçiş (SVS-09, SVS-19).
- **SVS-24:** Gece baskını: husumet ve CAS-08 baskınının oynanır sürümü (SVS-19).
- **SVS-25:** Kapı ve sur kuşatması: tekfur baskınının çok aşamalı savunması (SVS-19).
- **SVS-26:** Kapı ve sur hasarı, yangın, onarım (SVS-25).
- **SVS-27:** Moğol akın kolu sonucu: karar düğümü ve/veya savaş (karar 7.7) (HAR-02, DNY-01).
- **SVS-28:** Dış sefer / pusu temizliği (HAR-05, HAR-14).
- **SVS-29:** Kervan koruma savaşı (`kervan_korumasi`).
- **SVS-30:** Müttefik takviyesi: Türkmen obası ve sancak askeri (HAR-04, HAR-07).

### E. Savaş öncesi ve sonrası

- **SVS-31:** Savaş kararı paneli: savaş, pazarlık, rüşvet, kapat, kaç, otomatik çöz.
- **SVS-32:** Konuşlanma ekranı: HAR-10 dizilişinden başlangıç (HAR-10).
- **SVS-33:** Ganimet ve paylaşım kararı (karar 7.12).
- **SVS-34:** Esir, teslim ve fidye; divana devir (karar 7.13).
- **SVS-35:** Yara tedavisi genişlemesi ve kalıcı sakatlık (CAT-03, KRI-13).
- **SVS-36:** Ölüm sonrası: hane, eş, yetim, miras ve cenaze zinciri (KRI-05, KAP-18).
- **SVS-37:** Köye etki: moral, Güvenlik, husumet, grup itibarı.
- **SVS-38:** Kan davası ve intikam tetikleyicileri.
- **SVS-39:** Savaş söylentisi ve dedikodu (DIY-13, Bölüm 37).
- **SVS-40:** Gece raporu ve hafıza defteri savaş satırları.

### F. Arayüz

- **SVS-41:** Savaş ekranı kabuğu: tur şeridi, birim kartı, eylem çubuğu (Bölüm 43 teması).
- **SVS-42:** Hedefleme, isabet olasılığı ve görünür zar kadrajı.
- **SVS-43:** Savaş günlüğü.
- **SVS-44:** Savaş sonu özet paneli.
- **SVS-45:** Savaş girdileri: klavye, fare ve gamepad eylemleri (Bölüm 45).
- **SVS-46:** Savaş metin anahtarları TR/EN (Bölüm 46).
- **SVS-47:** Yer tutucu birim görselleri (kutu + isim etiketi) ve savaş asset envanteri.

### G. Kayıt, denge ve kapanış

- **SVS-48:** Savaş öncesi otomatik kayıt ve kayıt göçü (karar 7.11).
- **SVS-49:** Denge tabloları ve ölçüm koşusu (senaryo koşucusu ile).
- **SVS-50:** `otomatik_oyuncu` savaş kipi ve 20 gece duman testi.
- **SVS-51:** Perde ve son bağlantıları: 2. perde savunması, tekfur sonu (SYS-19, SYS-20).
- **SVS-52:** ROADMAP_3 kapanış testi.

**Toplam: 52 madde başlığı (SVS-01 … SVS-52).**
