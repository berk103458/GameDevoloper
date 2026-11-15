# ROADMAP 3 — Savaş Ön Raporu

> **Sahip: Ahmet tarafı** (Google ajanları ve Cursor). Bu rapor, ondan doğacak `ROADMAP_3` / `SVS-*` maddeleri ve savaş kodu Ahmet tarafınındır; Berk tarafı dokunmaz. Ayrıntı: `AGENTS.md` → "15 Kas 2026 bölüşümü".
> Hazırlayan: Cursor (15 Kasım 2026). Güncelleme: Ahmet'in 15 Kasım kararları işlendi (bkz. "Kararlar"). Durum: **ön rapor**. ROADMAP_3 dosyası değildir, madde sahipliği açmaz.
> Hedef okur: Antigravity (Google ajanları), Ahmet, Berk, Muharrir, Usta.
> Yöntem: yüzeysel araştırma. Önce repo taraması, sonra kısa ilham notları. Derin tarih araştırması yapılmadı.
> Kural hatırlatması: Bu rapor kod, asset ve ROADMAP_2 değişikliği içermez. ROADMAP_3'e geçerken AGENTS.md kuralları aynen geçerlidir: genişletme, yeniden yazma değil; asset üretme yasağı, yer tutucu kutu ve envanter; veriye dayalı sayılar; Türkçe commit ve imza.

---

## 0. Amaç ve kapsam

ROADMAP_3 yalnızca **savaş** konusunu kapsar. Üç eksen var:

1. **Mekanikler:** Kapıda kavga, baskın, kuşatma, akın, saldırı ve savunma, yaralanma, ölüm, moral, ganimet ve savaşın köye etkisi.
2. **Karakterler:** Savaşa girebilecek dost ve düşman tipleri ile rolleri.
3. **Motor:** Sıra tabanlı savaş motoru. Tur yapısı, inisiyatif, eylem modeli, ızgara, zar bağı, yapay zekâ ve arayüz akışı.

Tasarım ilkesi: Oyun **ciddi ve gerçekçi** kalır. Savaş az olur ve pahalıdır. Her ölüm köyde bir hane, bir cenaze ve bir söylenti olarak iz bırakır. Savaş ayrı bir oyun gibi değil, kapı ve köy yönetiminin bir sonucu gibi hissettirmelidir.

---

## Kararlar (15 Kas 2026, Ahmet)

Bu kararlar raporun geri kalanından önce gelir. Gövdede çelişen bir cümle kalırsa geçerli olan bu bölümdür.

- **K1 — Dönem:** 13. yüzyıl Selçuklu ucu, Kösedağ (1243) sonrası. `docs/dunya_kitabi/` geçerlidir. Dost ve düşman listesi, terimler ve teçhizat buna göre yazılır. Osmanlı dönemine ait terimler kullanılmaz: akıncı, tımar, sipahi, yeniçeri, levent ocağı (yeni metinde). Asset görsel stili bu karardan etkilenmez; o ayrı bir konudur ve şimdilik değişmez.
- **K2 — Hamle:** Turda her karakterin **2 eylemi** vardır (XCOM tarzı). Aksiyon puanı (AP) modeli kullanılmaz.
- **K3 — Can:** **Sayısal can (HP)** kullanılır. Yara basamakları can yerine geçmez. Öneri: HP sıfıra inen karakter "düştü" durumuna geçer. Savaş sonunda düşenler için ayrı bir **yara ve sakatlık zarı** atılır (ölüm, ağır yara, kalıcı sakatlık, hafif yara). Ayrıntı §3.4 M23 ve §5.4'tedir.
- **K4 — Muhafız:** Muhafız **ölmez**. HP'si 0 olursa savaş kaybedilmiş sayılır; muhafız hayatta kalır ve mağlubiyet sonucu uygulanır. Yerine kimse geçmez. Ayrıntı §5.9 ve §7A.
- **K5 — Moğol akınları:** **Küçük Moğol grupları** (öncü, keşif kolu, dağılmış atlılar) ile savaşılabilir. **Büyük akın kolları** savaş olarak oynanmaz. Onlar karar düğümüyle çözülür: kaç, saklan, haraç ver, elçiyle görüş.
- **K6 — Kadınlar ve gençler:** Savaşa katılıp katılmayacaklarını **oyuncu belirler**. Varsayılan **açık**tır ve oyun ortasında değiştirilebilir. Çocuklar her durumda savaş dışıdır. Ayrıntı SVS-53 ve §7A.
- **K7 — Kıtlık / açlık isyanı:** **Şimdilik kapsam dışı.** ROADMAP_3'e madde olarak girmez. "Gelecek" notu olarak kalır (§3.1 M8).

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
| Kıtlık isyanı / ambar yağması (KRI-06, KRI-14) | `kitlik_isyani.gd`, `kitlik_nobeti.gd` | İç karışıklık, ambar kapısı hasarı, moral kaybı. | ROADMAP_3 kapsamı dışında (K7). Gelecek notu. |
| Moğol öncüsü (HAR-02) | `src/sistemler/mogol_oncusu.gd`, `data/mogol_oncusu.json` | Geri sayım ve uyarı. Koddaki not açık: "savaş/para/zar eklenmez." | Sayaç dolunca ne olacağı tanımlanmamış. **ROADMAP_3'ün en büyük boşluğu.** K5'e göre küçük öncü grubu savaşılır, büyük kol karar düğümüyle çözülür. |
| Sancak asker talebi (HAR-04) | `src/sistemler/sancak_asker_talebi.gd` | Fermanla gerçek köylüler orduya gönderilir ve köyden düşer. | Gidenlerin akıbeti (dönüş, ölüm, ganimet) yok. |
| Çete anlaşması (HAR-08) | `src/koy/cete_anlasmasi.gd` | Aylık rüşvet karşılığında dokunulmazlık. | — |
| Pusu temizliği (HAR-05, HAR-14) | `data/pusu_ticaret_akisi.json` | Başarılı pusu temizliği tüccar akışını artırır. | Pusunun kendisi oynanmıyor. Dış sefer için doğal bir aday. |
| Tehdit takvimi (BUG-18, OMR-42) | `src/sistemler/tehdit_takvimi.gd` | Nüfus 14'ün altındayken kurt dışındaki baskınlar gelmez. "Nüfus 18 öncesi savaş yok." | ROADMAP_3 bu kapıyı korumalı. |
| Okçuluk mini oyunu | `src/arayuz/okculuk_oyunu.gd` | Ayrı bir beceri oyunu. | Sur okçusu becerisine bağlanır (§7A, K9). |
| Sınıflar ve karakterler | `data/siniflar/asker.tres`, `data/karakterler/*.tres`, `karakterler/CHR_*.md` | Üç sınıf var: asker, çiftçi, esnaf. Adlı askerler: aydogdu, nogay, miraen. CHR_021..024 asker kaçağı ya da eski asker. | Savaş istatistiği yok (saldırı, savunma, inisiyatif, can/yara, moral, ekipman). |
| Donanım | `data/muhafiz_donanimi.json` | Kılıç ve mızrak yer tutucu parçaları (yalnız görsel kutular). | Silah ve zırh istatistiği yok. |
| Gruplar | `data/gruplar.json` | Türkmen, Rum, Ahi, Köylü, Tüccar, Asker; itibar ve karar deltaları. | Savaş sonuçları itibara yazılmıyor. |
| Dünya olayları (DNY-01..04) | `data/dunya/zaman_cizelgesi.json` | Moğol ilerleyişi ve diğer olaylar; haber ve rapor metinleri hazır, kod Kalfa'yı bekliyor. | Savaşa giriş tetikleyicisi olarak kullanılabilir. |

### 1.2 ROADMAP_2 notları

- ROADMAP_2 durumu (15 Kasım): 941 `[x]`, 29 `[/]`, 108 `[ ]`.
- `ROADMAP_2.md:808` "Yeni maddeler CAT-05 … CAT-84" diyor, ama bu maddeler hiç yazılmamış. ROADMAP_3 bu boşluğu kapatmalı. ID öneki **SVS-** olarak kesinleşti (§7A, K8). CAT-01..04 olduğu gibi kalır.
- ROADMAP_2 birçok yerde açıkça "yeni savaş yok" diyor: Bölüm 26 nöbet devri, YAP-56 usta defterleri ("Yeni savaş … açılmaz"), MCL-09 ("Meclis savaş … açamaz"), HAR-02. Bunlar ROADMAP_2'nin sınırlarıdır. ROADMAP_3 bu sınırları bilinçli olarak açar, ama ROADMAP_2 maddelerinin kabul testlerini bozmamalıdır.

### 1.3 Kısa sonuç

Savaş verisinin ve sonuç zincirinin iskeleti hazır: kim asker, kim yaralı, kim öldü, cenaze, söylenti, itibar, güvenlik ve konuşlanma. Eksik olan **savaş anının kendisi**. Şu an her çatışma bir zar ya da bir sayı karşılaştırmasıyla bitiyor. ROADMAP_3'ün ana işi bu anları oynanır kılmak. Oyuncuya açık otomatik çözüm yoktur (§7A, K10): her savaş oynanır. Mevcut formüller (`savunma_gucu`, `SorguZari`, `HusumetBaskini`) silinmez; savaş sonucu aynı köy alanlarına yazılır. YZ'ye karşı YZ yalnız test koşucusudur.

---

## 2. İlham notları (yüzeysel)

### 2.1 Dönemin uç savaşı (13. yy Selçuklu ucu, Kösedağ sonrası — K1)

Dayanak: `docs/dunya_kitabi/uc_duzeni.md`, `tarih.md`, `bizans_rum.md`, `turkmen_gocu.md`. Aşağıdaki notlar yüzeyseldir; madde yazılırken dünya kitabındaki olgulara bakılır.

- **Küçük ölçek:** Uç savaşının çoğu meydan muharebesi değildi. Baskın, pusu, sürü ve insan kaçırma, kervan vurma, otlak kavgası ve kısa süreli kuşatmalardan oluşurdu. Bir köy için tipik tehdit 10–40 kişilik bir gruptur.
- **Merkez zayıf, uç serbest:** Kösedağ'dan sonra Selçuklu merkezi zayıfladı. Uç beyleri ve Türkmen boyları daha serbest davrandı. Köyü korumak çoğu zaman köyün ve muhafızın kendi işidir. Yardım uç beyinden ya da subaşıdan geç ve pazarlıkla gelir.
- **Türkmen uç atlısı (alp, gazi):** Hafif atlı okçudur. Vur-kaç yapar, sahte ricat uygular, okla yıpratır. Yakın dövüşten kaçar, ganimet ve sürü peşindedir. Yaya ve sur savunmasına karşı zayıftır. Dost da düşman da olabilir; otlak ve kin bayrağına bağlıdır.
- **Moğol (Baycu Noyan dönemi):** Disiplinli atlı okçudur. İyi atlı ve iyi teçhizatlıdır. Küçük öncü ve keşif kolları köye uğrayabilir; bunlarla savaşılabilir. Büyük kollar savaşılarak durdurulamaz (K5).
- **Tekfur askeri ve Rum milisi:** İznik İmparatorluğu'nun ve yerel tekfurların sınır askerleridir (Bizans sınır muhafızları, Rumca "akritai"). Zırh gömleği ve kalkanlı yaya, az sayıda mızraklı atlı ve okçudan oluşur. Sur ve kale savunmasında güçlüdür, açık arazide yavaştır.
- **Eşkıya / harami:** Asıl amacı öldürmek değil, mal almaktır. Moralleri bozulunca hemen dağılırlar. Gece ve sis severler. Köyde içeriden yardımcıları olur (CHR_004 ve CHR_009 bunun örneği).
- **Köylü milis:** Orak, balta, sopa ve sapan kullanır. Moral düşüktür ama evini korurken direnç artar.
- **Kuşatma:** Küçük bir köyde gerçek kuşatma makinesi beklenmez. Kapıyı yakmak ya da kırmak, suru tırmanmak, kuyuyu ve ambarı hedef almak, aç bırakmak ve pazarlık gerçekçi araçlardır.
- **Savaş sonu:** Fidye, esir değişimi, haraç anlaşması, ganimet paylaşımı ve kan davası. Bunlar mevcut grup itibarı ve söz sistemine doğal olarak bağlanır.

**Dönem teçhizatı (veri tablosu için başlangıç listesi):**

| Taraf | Silah | Koruma |
|---|---|---|
| Muhafız, köy askeri | Kılıç, mızrak, topuz (gürz), balta, Türk yayı (çok parçalı yay) | Kalkan, keçe ya da pamuk dolgulu kaftan, zırh gömleği (az), tolga (miğfer) |
| Türkmen uç atlısı | Türk yayı, kılıç, kısa mızrak | Keçe kaftan, deri zırh, küçük yuvarlak kalkan |
| Moğol atlısı | Türk-Moğol yayı, kılıç, mızrak, kement | Deri ya da pullu zırh, tolga |
| Tekfur askeri | Mızrak, kılıç, balta, yay, az sayıda arbalet (tzangra) | Büyük kalkan, zırh gömleği, miğfer |
| Harami | Bıçak, balta, sopa, yay, sapan | Çoğunlukla yok; ganimetten parça zırh |
| Köylü milis | Orak, balta, sopa, sapan, taş, yaba | Yok |

**Terim kuralı (K1):** Yeni metinde Osmanlı dönemine ait terimler kullanılmaz: akıncı, tımar, sipahi, yeniçeri, levent ocağı. Yerine dönem terimleri kullanılır: uç beyi, subaşı, ikta sahibi, alp, gazi, Türkmen atlısı, tekfur, harami. Mevcut metinlere ve diyaloglara dokunulmaz (§7A, K18). "Sancak Beyi" ve CHR_021'deki "levent ocağı" olduğu gibi kalır. Dönem terimi yalnız yeni savaş metinlerinde kullanılır.

### 2.2 Sıra tabanlı oyunlardan alınacaklar

| Oyun | Alınacak | Alınmayacak |
|---|---|---|
| **Battle Brothers** | Yorgunluk; ön ve arka sıra; moral durumları (kararlı → sarsılmış → bozgun); kalıcı yara ve sakatlık; ölümün kalıcı olması; silaha göre farklı yetenekler. | Aksiyon puanı (K2: 2 eylem), paralı asker şirketi yönetimi, sınırsız asker alma. |
| **Darkest Dungeon** | Stres veya moralin ayrı bir kaynak olması; savaş sonrası kamp ve iyileşme ekonomisi; kahramanların kalıcı travmaları. | Sabit 4'lü sıra düzeni, fantastik düşmanlar. |
| **XCOM** | İki eylemli basit tur (hareket + eylem); siper ve görüş; isabet olasılığının açıkça gösterilmesi; düşman sırasının görünmesi. | Bilimkurgu ekipman ağacı, %95 ıskalama şakası (zar şeffaf olmalı). |
| **Mount & Blade** | Savaş öncesi karar: savaş, pazarlık, kaç, rüşvet ver, adam bırak; esir ve fidye; birlik moralinin komutana bağlı olması. | Gerçek zamanlı savaş. Oyuncuya açık otomatik çözüm (K10). |
| **Into the Breach** | Düşman niyetinin bir tur önceden görünmesi; küçük harita, az birim, her hamlenin önemli olması. | Bulmaca hissi. |

### 2.3 Bu oyuna çeviri

- Savaş **nadir, küçük ve ağır** olsun. Tipik çatışmada 3–12 birim olsun.
- Kararların çoğu savaştan **önce** verilsin: konuşlanma, pazarlık, rüşvet, kapıyı kapatma, kaçış.
- Zar **görünür** olsun ve ZAR-01 diliyle aynı olsun: d6/d12, `zar >= gerekli`, sözcükle yazılan sonuç.
- **Sayısal can (HP)** kullanılır (K3). HP sıfıra inen karakter "düştü" sayılır. Kalıcı iz, savaş sonundaki ayrı yara ve sakatlık zarıyla bırakılır. Böylece savaş anı okunaklı kalır, sonuçlar da ağır olur.
- Savaş sonrası her şey mevcut sistemlere akmalı: cenaze (KRI-05), şifahane (KRI-03, KRI-13), söylenti (DIY-13), grup itibarı, hane, yetimler (KAP-18).

---

## 3. Mekanik listesi

Her mekanik için önerilen yön yazıldı. Detay ROADMAP_3 maddelerinde açılacak.

### 3.1 Çatışma türleri (ölçek basamakları)

| # | Tür | Yer | Tipik boyut | Tetikleyici (mevcut) | Önerilen çözüm |
|---|---|---|---|---|---|
| M1 | **Kapı arbedesi** | Kapı önü (küçük arena) | Düello 1'e 1, ya da muhafızın adamları 1–3'e 1–3 | CAT-01 / CAT-02 "askerle karşılık" | Oyuncu iki yoldan birini seçer (§7A, K11): adamlarını gönderir, ya da muhafızın kendisi kapıdaki karakterle düello yapar. İkisi de sıra tabanlıdır ve oynanır. Otomatik çözüm yoktur. |
| M2 | **Gece baskını / sızma** | Köy (mevcut ızgara) | 3–8 eşkıyaya karşı nöbetçiler | `Husumet.gece` → `baskin`, CAS-08 | Gece görüşü kısıtlı sıra tabanlı savaş. Hedef ambar ya da ağıl. Otomatik çözüm `HusumetBaskini.uygula` olarak kalır. |
| M3 | **Tekfur baskını / kapı kuşatması** | Sur + kapı + iç avlu | 8–20'ye karşı köy savunması | `tekfur_baski > savusturulan` | Çok aşamalı savunma: yaklaşma, kapı ve sur, gedik, iç avlu. Başlangıç dizilişi HAR-10 konuşlanmasından gelir. Otomatik çözüm `tekfur_gucu > savunma_gucu`. |
| M4a | **Küçük Moğol grubu** | Köy çevresi, yol | 3–8 öncü ya da keşif atlısı | HAR-02 öncü uyarısı, DNY-01 Moğol ilerleyişi | Sıra tabanlı savaş (K5). Düşman atlı okçu profilidir; yenilen grup büyük kolun gelişini hızlandırabilir. |
| M4b | **Büyük Moğol akın kolu** | Köy + çevre | Büyük kol | HAR-02 sayacının dolması | **Savaş olarak oynanmaz (K5).** Karar düğümüyle çözülür: kaç, saklan, haraç ver, elçiyle görüş. Sonuç mevcut kayıp ve itibar akışlarına yazılır. |
| M5 | **Dış sefer / pusu temizliği** | Harita düğümü (dağ yolu, geçit) | 3–8 seçilmiş köylü | HAR-05, HAR-14 | Oyuncunun başlattığı küçük saldırı. Ganimet ve tüccar akışı ödülü vardır. |
| M6 | **Kervan koruma** | Yol | 2–6 muhafız | `kervan_korumasi.json` | Savunma senaryosu. Kervanı kaçırmak kazanma koşuludur. |
| M7 | **Hayvan saldırısı** | Ağıl | Kurt sürüsü | MEV-10 | Mevcut soyut kalabilir. İstenirse M2'nin hafif bir türü olur. |
| M8 | **İç kargaşa (kıtlık / açlık isyanı)** | Ambar, meydan | Köylüler | KRI-06, KRI-14 | **Kapsam dışı (K7).** ROADMAP_3'e madde olarak girmez; mevcut KRI-06 / KRI-14 akışı aynen kalır. **Gelecek notu:** İleride ele alınırsa kendi halkına kılıç çekmek ayrı bir ahlak kararı olarak tasarlanmalı. |

### 3.2 Savaş öncesi

- **M9 Savaş kararı ekranı:** Savaş, pazarlık, rüşvet (akçe ya da erzak), kapıyı kapatıp bekle, kaç / sakla. **Otomatik çöz seçeneği yoktur (§7A, K10).** Kapı arbedesinde ek olarak "adamlarını gönder" ve "muhafızın kendisi düello yapsın" seçenekleri vardır (K11). Pazarlık mevcut söz sistemi ve zar ile yapılır.
- **M10 Keşif ve erken uyarı:** Gözcü kulesi (HAR-06, HAR-13) düşman sayısını ve türünü önceden gösterir. Kule yoksa sayı "bilinmiyor" görünür.
- **M11 Konuşlanma:** HAR-10 rolleri (kapı mızraklısı, sur okçusu, devriye) savaşın başlangıç konumlarına dönüşür. Oyuncu savaş başında sınırlı bir yeniden diziliş yapabilir.
- **M12 Silahlanma:** Köyün silah stoğu (silah karaborsası, demirci) birimlere dağıtılır. Silahı olmayan köylü alet kullanır.

### 3.3 Savaş anı

- **M13 Saldırı ve savunma zarı:** Saldırı d12, gerekli değer = hedefin savunması + mesafe + siper + yorgunluk + moral. Kural ZAR-01 ile aynıdır. İsabet eden saldırı HP düşürür (K3): hasar = silah hasarı + d6 − zırh, en az 1. Değerler veridedir.
- **M14 Yakın dövüş ve menzil:** Kılıç, topuz ve balta; mızrak (2 hücre, karşılama saldırısı); Türk yayı (menzil, sur bonusu); sapan ve taş (köylü). Kalkan savunmaya ekler. Silah listesi §2.1 dönem teçhizatı tablosundan gelir (K1).
- **M15 Siper ve yükseklik:** Sur, kapı, çit, ev duvarı ve ağaç siper sağlar. Sur yüksekliği okçuya bonus verir.
- **M16 Kapı ve sur hasarı:** `sur_hasar` ve kapı hasarı savaş içinde değişir ve savaştan sonra da kalır. Onarım mevcut taş ve kereste bedeline bağlanır (KRI-06 onarım modeli).
- **M17 Yangın:** Saldırgan kapıyı ya da ambarı yakabilir. Mevcut kundak ve yangın akışlarına bağlanır (`yaz_su_yangin.json`, ambar kundaklaması).
- **M18 Moral:** Birim başına moral basamakları: kararlı, tedirgin, sarsılmış, bozgun. Komutan (muhafız ya da çavuş) yakınlığı, ölen dost, sayısal üstünlük ve evini savunma moral değiştirir. Bozgundaki birim kaçar. Eşkıya erken bozulur.
- **M19 Yorgunluk:** Her eylem yorar. Mevcut nöbet yorgunluğu (UZM-14) savaşa yorgun başlamak anlamına gelir.
- **M20 Görüş ve gece:** Gece savaşında görüş kısalır. Meşale ve muhafız ışığı (`muhafiz_donanimi.json` ışık değerleri) görüşü açar.
- **M21 Teslim ve esir:** Bozgundaki ya da ağır yaralı düşman teslim olabilir. Esir zindana gider (mevcut divan ve zindan akışı). Fidye ya da hüküm divana düşer.
- **M22 Geri çekilme:** Oyuncu da harita kenarından çekilebilir. Kaçan birim ganimet bırakır, moral kaybeder.

### 3.4 Savaş sonrası

- **M23 HP ve savaş sonrası yara / sakatlık katmanı (K3):** Savaş içinde her karakterin sayısal canı (HP) vardır. HP sıfıra inince karakter "düştü" sayılır: eylem yapamaz, haritada yatar, düşman onu esir alabilir ya da öldürebilir. Savaş bitince her düşen için bir **yara ve sakatlık zarı** atılır. Önerilen sonuçlar:
  - **Ölüm:** Ağır silah, savaş sonunda yerde kalma ya da hekimsizlikle olasılık artar.
  - **Ağır yara:** Birkaç gün çalışamaz. Hekim yoksa o gece ölüm zarı atılır.
  - **Kalıcı sakatlık:** İş gücü düşer, asker olamaz.
  - **Hafif yara:** Kısa süre iş gücü kaybı.
  - HP'si sıfıra inmeyen ama düşük kalan karakter "hafif yaralı" sayılır.
  - Tablo veridedir. Mevcut köylü sağlık değeri (0–100) savaş sonrası HP oranına göre düşürülür. CAT-03 ve KRI-03 tedavi akışı genişletilir.
- **M24 Ölüm:** Mevcut nüfus ve cenaze akışına tek çağrı yapılır (CAT-02 kuralı korunur). Hane reisi ölürse hane, eş, yetim ve miras etkileri devreye girer. **Muhafız bu zara girmez ve ölmez (§7A, K4).** HP'si 0 olursa savaş mağlubiyet sayılır; muhafız hayatta kalır, en kötü sonuç ağır yaradır, yerine kimse geçmez. Galibiyet ve mağlubiyetin getirileri §5.9 tablosundadır.
- **M25 Ganimet:** Düşmandan silah, zırh, at, akçe, defter (YAP-56) ve esir. Paylaşım kararı (beye pay, köye pay, muhafıza pay) mevcut kasa ve vergi ile adalet / yozlaşma terazisine bağlanır.
- **M26 Köye etkisi:** Moral (zafer +, kayıp −), Güvenlik, husumet puanı, grup itibarı (Rum, Türkmen, Asker), söylenti, kervan ve tüccar akışı, göç (kapıya savaştan kaçanlar gelir: KAP-18 yetim kafilesi).
- **M27 Kan davası ve intikam:** Öldürülen eşkıyanın çetesi husumet kazanır. Öldürülen tekfur askeri tekfur baskısını artırır.
- **M28 Hafıza defteri ve gece raporu:** Savaş özeti mevcut gece raporuna ve hafıza defterine yazılır. Ayrı bir rapor sahnesi açılmaz (GRV-12 kuralı).

---

## 4. Karakter listesi

İstatistik önerisi: tüm birimler aynı şablonu kullanır. Değerler veride tutulur. Önerilen alanlar:

`can` (azami HP, K3), `saldiri`, `savunma`, `menzil_becerisi`, `inisiyatif`, `moral_tabani`, `yorgunluk_tavani`, `ekipman` (silah, kalkan, zırh), `rol_etiketleri`.

### 4.1 Dost (köy tarafı)

| Tip | Kaynak (mevcut) | Rol | Not |
|---|---|---|---|
| **Muhafız (oyuncu karakteri)** | `Oturum`, muhafız yetenekleri | Komutan, yakın dövüş | Moral aurası, emir (bir müttefike ek eylem). Ölmez (K4). HP 0 olursa savaş kaybedilmiş sayılır; muhafız hayatta kalır, komuta kimseye devredilmez. Kalan dostlar savaşı sürdürebilir, sonuç yine mağlubiyettir (§5.9). |
| **Çavuş / nöbet başı** | Yeni rol etiketi (mevcut asker sınıfından) | Ast komutan | Muhafız yokken moral kaynağı. CHR_023'teki "çavuş Bedri" adı dünyada var. |
| **Kapı mızraklısı** | HAR-10 `kapi` rolü | Kapıyı tutan, karşılama saldırısı | Başlangıç konumu kapıdır. |
| **Sur okçusu** | HAR-10 `sur` rolü | Menzilli, yüksekten atış | Okçuluk mini oyununa bağlanabilir. |
| **Devriye askeri** | HAR-10 `devriye` | Hareketli yedek | |
| **Adlı askerler** | `aydogdu`, `nogay`, `miraen` (sinif=asker) | Özel yetenekli birim | Kişisel geçmiş ve yemin sistemine bağlanır. |
| **Eski asker / kaçak köylü** | CHR_021 Cemil (kaçak piyade; verideki "levent ocağı" ifadesine dokunulmaz, K18), CHR_022 Bayram (kışla davulcusu), CHR_023 Necip (keşif eri), CHR_024 Fehmi (cebe yamağı) | Kabul edilmişse savaşa katılabilir | Davulcu moral, keşif eri görüş, cebeci silah onarımı verir. Kaçak olarak tanınma riski. |
| **Köylü milis (yetişkin erkek)** | çiftçi / esnaf sınıfı yetişkin erkekler | Zayıf, çok sayıda | Silah stoğuna bağlı; yoksa orak, balta, sopa ya da sapan. |
| **Kadın ve genç milis** | çiftçi / esnaf sınıfı yetişkin kadınlar ve gençler | Destek ya da tam savaşçı | **Oyuncu belirler (K6).** Ayar kapalıysa savaşa girmezler, ama sivil olarak korunurlar. Ayar açıksa milis şablonunu kullanırlar. Çocuklar her durumda savaşmaz (öneri). Ayrıntı SVS-53. |
| **Hekim** | CHR_008, şifahane | Savaş içinde tedavi | Cephe dışında durur, düşeni yerden kaldırır, HP'sini biraz geri verir. |
| **Türkmen oba atlısı (alp)** | HAR-07 Ertuğrul obası ittifakı, `oba_ittifaki.gd` | Müttefik takviye | İttifak varsa savaşa birkaç atlı okçu gönderir. |
| **Uç beyi / subaşı askeri** | HAR-04 (veride "Sancak Beyi"), Taşlık Hisar | Takviye ya da talepçi | Büyük tehditte yardım gelebilir, karşılığında borç ya da ferman doğar. Yardım geç ve pazarlıkla gelir (Kösedağ sonrası zayıf merkez). |
| **Gazi / alp gönüllüleri** | yeni şablon (dış sefer) | Dış seferde müttefik | Ganimet payı ister. Türkmen itibarına bağlıdır. (Osmanlı dönemine ait "akıncı" yerine; K1.) |

### 4.2 Düşman

| Tip | Kaynak (mevcut) | Rol / davranış | Not |
|---|---|---|---|
| **Kızıl Karga harami** | CHR_001, 004, 005, 006 (`Kızıl Karga Dağ Haramileri`), Karaboran | Gece baskını, ganimet odaklı | Erken bozulur. İçeriden casus desteği alır (CHR_004, CHR_009). |
| **Çete reisi (Karaboran)** | `karaboran_intikami.gd` | Lider, moral kaynağı | Öldürülürse çete dağılır, ama kan davası doğar. |
| **Eşkıya okçusu / sapancı** | yeni şablon | Menzilli taciz | |
| **Tekfur askeri (yaya)** | `tekfur_gucu`, HAR-03 | Zırh gömleği ve büyük kalkan, yavaş, kapı kırıcı | Kalkan duvarı. İznik İmparatorluğu ve yerel tekfur sınır askeri. |
| **Tekfur okçusu / arbaletçisi** | yeni şablon | Menzilli | Arbalet (tzangra) az sayıdadır, zırh deler, yavaş doldurulur. |
| **Tekfur mızraklı atlısı** | yeni şablon | Az sayıda, şok saldırısı | |
| **Rum milisi** | `gruplar.json: rum` | Zayıf yaya | Öldürülmesi Rum itibarını düşürür. |
| **Moğol öncü / keşif atlısı** | HAR-02, DNY-01 | Atlı okçu, vur-kaç, iyi teçhizatlı | **Yalnız küçük gruplar (3–8) savaşılır (K5).** Büyük kol savaşılmaz, karar düğümüyle çözülür (M4b). |
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
- **Her savaş oynanır (§7A, K10).** Oyuncuya açık otomatik çözüm yoktur. Eski formüller (`savunma_gucu`, `HusumetBaskini`) silinmez; savaşın sonucu aynı köy alanlarına yazılır. YZ'ye karşı YZ yalnız test koşucusudur (SVS-19) ve oyuncu menüsünde görünmez.
- **Bir savaşta en fazla 20 birim** vardır (§7A, K15). 21. birim sahneye girmez; fazlası yedek ya da "gelmedi" olarak veride kalır.

### 5.2 Izgara ve konum

- **Seçenek A — kare ızgara:** Köydeki mevcut A* ve `izgara.gd` hücreleriyle aynıdır. HAR-10 konumları doğrudan kullanılır. Basit ve uyumludur.
- **Seçenek B — altıgen ızgara:** Battle Brothers hissi verir, ama köy ızgarasıyla çeviri katmanı gerektirir.
- **Önerim:** Seçenek A, kare ızgara ve 8 yön. Köy savaşları köy sahnesinde, kapı savaşı küçük sabit bir kapı arenasında yapılır. Yeni harita üretilmez, mevcut sahne kullanılır.
- Hücre özellikleri: geçilebilirlik, siper (yok, yarım, tam), yükseklik (zemin, sur), yanıcılık, kapı (sağlamlık).
- Izgara ve tur döngüsü 20 birim tavanına göre kurulur (K15). Kapı düellosu aynı motoru 2 birimle kullanır.

### 5.3 Tur yapısı

- **Tur = bir raunt.** Her birim bir kez hareket eder.
- **İnisiyatif:** Raunt başında birim başına `inisiyatif + d6`. Sıra, ekranın üstündeki tur şeridinde görünür. Eşitlikte dost önce gelir (öneri).
- **Aksiyon modeli (K2): her karakterin turda 2 eylemi vardır** (XCOM tarzı). AP modeli kullanılmaz.
  - Geçerli birleşimler: hareket + eylem, eylem + hareket ya da iki hareket (koşu).
  - Ağır eylemler (ör. arbalet atışı, kapıya balta, yay ile nişanlı atış) iki eylemin ikisini de harcar ve turu bitirir. Hangi eylemin ağır olduğu veridedir.
  - Her eylem yorgunluk yazar. Yorgunluk tavanına ulaşan karakter o tur yalnız 1 eylem yapabilir.
  - Düşmüş (HP 0) karakterin eylemi yoktur.
- **Bekle / nöbet tut:** Eylemi sonraya bırakmak (overwatch). Menzile giren ilk düşmana atış ya da mızrak karşılaması.
- **Raunt sonu:** Moral kontrolü, kanama, yangın yayılması, takviye girişi ve kazanma koşulu kontrolü.

### 5.4 Zar sistemiyle ilişki

- `SorguZari` genelleştirilir ya da yanına **`SavasZari`** adaptörü yazılır. Aynı kural kaynağını ve dili kullanır: d6/d12, `zar >= gerekli`, tavan her zaman başarı, 1 her zaman başarısız, sonuç sözcükle yazılır (`ZAR_BASARILI` vb.).
- **İsabet:** d12 ≥ `hedef_savunma + mesafe_eki + siper_eki + moral_eki + yorgunluk_eki − saldiri`.
- **Hasar (K3):** silah hasarı + d6 − zırh, en az 1. Sonuç hedefin HP'sinden düşer. Değerler veridedir (`data/savas/silahlar.json`).
- **Savaş sonu yara ve sakatlık zarı:** Düşen her karakter için d12 atılır, sonuç `data/savas/yara_tablosu.json` ile ölüm, ağır yara, kalıcı sakatlık ya da hafif yaraya çevrilir. Değiştiriciler: hekim, şifahane, düşüren silah, savaş sonunda kimin alanda kaldığı.
- **Moral:** d6 ≥ moral eşiği; değiştiriciler veridedir.
- Arayüz isabet olasılığını `basari_olasiligi` ile gösterir. İkinci bir hesap yolu yazılmaz (ZAR kuralı).
- RNG oturum RNG'sinden türetilir, kayıtla tekrarlanabilir.

### 5.5 Yapay zekâ

- **Fayda tabanlı (utility) basit YZ.** Her birim, olası eylemleri puanlayıp en iyisini seçer. Puan ağırlıkları düşman türüne göre veridedir.
- **Davranış profilleri:**
  - **Harami:** Hedef ganimet hücresidir (ambar, ağıl). Zayıf hedefi seçer, moral düşünce kaçar.
  - **Tekfur yayası:** Kapıya ilerler, kalkan duvarını korur, gedik açar.
  - **Atlı okçu:** Mesafe korur, vurup çekilir.
  - **Köylü milis (oyuncu seçmediği dost birimler ve test koşucusu):** Savunur, mevzisini bırakmaz.
  - **Çaresiz tek kişi (kapı):** Kaçış yolu arar, sıkışınca saldırır.
- **Niyet gösterimi (Into the Breach):** İsteğe bağlı. Düşmanın bir sonraki hedefinin çizgiyle gösterilmesi. Gözcü kulesi ya da keşif eri varsa açılabilir.
- **Zorluk:** YZ hile yapmaz. Zorluk birim sayısı ve donanımla ayarlanır.

### 5.6 Arayüz akışı

1. **Tetik:** Kapıda kavga, gece olayı ya da harita olayı.
2. **Savaş kararı paneli (M9):** Düşman özeti (gözcüye göre kesin ya da belirsiz) ve seçenekler. Otomatik çöz satırı yoktur (K10). Kapı arbedesinde iki yol vardır: adamlarını gönder, ya da muhafızın kendisi düello yapsın (K11).
3. **Konuşlanma (M11):** HAR-10 dizilişi gelir. Sınırlı yeniden diziliş yapılabilir.
4. **Savaş ekranı:**
   - Üstte tur sırası şeridi.
   - Altta seçili birim kartı: HP, moral, yorgunluk, kalan eylem (2/2), ekipman.
   - Eylem çubuğu: hareket, saldır, nöbet tut, kalkan, bandaj, emir, çekil. Klavye ve gamepad girdisi Bölüm 45 ile uyumlu olmalı.
   - Hedef üzerine gelince isabet olasılığı ve gerekli zar değeri görünür.
   - Zar atışı mevcut görünür zar kadrajıyla yapılır.
   - Sol altta savaş günlüğü.
5. **Savaş sonu özeti:** Kayıplar, yaralılar, esirler, ganimet ve paylaşım kararı.
6. **Gece raporu ve hafıza defteri** satırları (ayrı sahne yok).

- Tema: Bölüm 43 tema anahtarları. 2B arayüz üretimi serbesttir. Birimler kutu ve kapsül yer tutucularıyla, isim etiketiyle gösterilir.
- Ses sessiz yer tutucudur (§7A, K16). 3B savaş animasyonları Meshy ile üretilebilir. İkisi de `docs/EKSIK_ASSET_ENVANTERI.md` içine yazılır; 3B kalemler 3B başlığına girer.
- Erişilebilirlik: Sonuç renkle değil sözcükle yazılır. Okuma puntosu GRV-13'e uyar. Savaş hızı ayarlanabilir.

### 5.7 Kayıt

- **Karar (§7A, K12):** Savaşın ortasında kayıt yoktur. Savaş başlamadan önce otomatik kayıt alınır. Oyun savaş sırasında kapanırsa savaş başından devam edilir. Bu, `GuvenliKayit` ve `KAYIT_SURUMU` göç yükünü küçük tutar.
- Savaş sonucu mevcut alanlara yazılır: nüfus, sağlık, `sur_hasar`, kaynaklar, husumet, itibar. Yeni kayıt alanı gerekirse SYS-14 adım göçüyle eklenir.

### 5.8 Test

- Saf mantık birim testleri: isabet formülü, HP hasarı, 2 eylem kuralı, savaş sonu yara tablosu, moral eşiği, inisiyatif sırası, 20 birim tavanı, galibiyet ve mağlubiyet tablosu. Muhafızın HP'si 0 olunca sonuç mağlubiyettir ve muhafız hayattadır.
- Sabit tohumlu senaryo testleri: "3 harami / 2 muhafız" ve "kapı düellosu" `senaryo_kosucusu.gd` ile koşulur.
- Oyuncuya açık otomatik çözüm testi yazılmaz. `otomatik_oyuncu.gd` 20 geceyi, oyuncu menüsünde olmayan YZ-YZ test koşucusuyla (SVS-19) kilitlenmeden geçer.
- Eski `savunma_gucu` ve `HusumetBaskini` testleri durur. Yeni bir "otomatik çöz, eski formülle aynı sayı" testi açılmaz.

### 5.9 Galibiyet ve mağlubiyet (§7A, K4)

Muhafız ölmez. HP'si 0 olursa savaş kaybedilmiş sayılır. Kalan dost birimler o turu bitirebilir (çekilme), ama galibiyet yazılmaz ve komuta kimseye devredilmez. Muhafız savaş sonu yara zarının ölüm satırına girmez. Savaştan en kötü ağır yarayla çıkar ve oyuncu aynı muhafızla devam eder. Yerine geçme yolu yoktur.

Değerler veridedir (`data/savas/sonuc_tablosu.json`). İşaretler yön gösterir; sayılar madde yazılırken tabloya konur.

| Sonuç | Tetik | Ganimet | İtibar | Husumet | Yara | Kaynak | Köye etki |
|---|---|---|---|---|---|---|---|
| Galibiyet | Düşman bitti (öldü, kaçtı ya da teslim oldu) ve muhafızın HP'si 0'ın üstünde | Düşmandan silah, akçe, at ve esir. Paylaşım terazisi (K13) | Savunulan tarafın grubuna artı | Rakip çete ya da tekfur baskısı artabilir (kan davası) ya da azalır | Düşen dostlara yara zarı. Muhafıza ölüm satırı yok | Ok ve cephane tüketilir | Moral ve Güvenlik artar. Zafer söylentisi yazılır |
| Mağlubiyet | Dost taraf bozulur, kaçar ya da teslim olur | Ganimet yoktur. Düşman payını alır | Eksi | Artı | Düşen dostlara yara zarı | Ambar, akçe ya da sürü kaybı. Sur ve kapı hasarı | Moral ve Güvenlik düşer. Yenilgi söylentisi. Kapıya kaçanlar gelebilir |
| Muhafız düşer | Muhafızın HP'si 0 olur | Mağlubiyet satırı | Mağlubiyet satırı | Mağlubiyet satırı | Muhafız ölmez. En kötü sonuç ağır yaradır. Savaştan düşük HP ile çıkar | Mağlubiyet satırı | Savaş kaybedilmiş sayılır. Kalan dostlar çekilir. Galibiyet yazılmaz |

Kapı düellosu aynı tabloyu küçük ölçekte kullanır. Düelloyu kaybetmek kapı kavgasının kin, yara ve dedikodu sonucudur. Muhafız yine ölmez.

---

## 6. ROADMAP_2 ile bağlantılar

| ROADMAP_2 / ROADMAP_1 maddesi | Bağlantı |
|---|---|
| CAT-01..04 | Kapı arbedesinin tetiği. "Askerle karşılık" seçeneğinin içinde oyuncu iki yoldan birini seçer: adamlarını gönder, ya da muhafızın kendisi düello yapsın (K11). İkisi de oynanır. Eski tek zar otomatik çözüm olarak kalmaz. "Beşinci seçenek yok" kuralı korunur: bu iki yol, karşılık seçeneğinin içindedir. |
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
| KRI-06, KRI-14 | Kıtlık isyanı ve ambar yağması ROADMAP_3 kapsamı dışında (K7). Mevcut akış değişmez. |
| Bölüm 35 (ayarlar) | Kadın ve gençlerin savaşa katılım ayarı bu ayar panelinde durur (K6, SVS-53). |
| DIY-13, söylenti ağı (Bölüm 37) | Savaş sonuçları dedikoduya yazılır. |
| Bölüm 43 (GRV), Bölüm 45 (girdi), Bölüm 46 (yerelleştirme) | Arayüz teması, girdi eylemleri ve metin anahtarları. |
| Bölüm 34 (perde yapısı), SYS-19, SYS-20 | 2. perde savunma savaşı ve beş son; tekfur ve haraç sonları savaş sonucuna bağlanır. |

**ROADMAP_2'den ROADMAP_3'e geçiş önkoşulları (öneri):** DNY-01 dünya zaman çizelgesi kodu, GRV tema geçişlerinin kapanması ve yerelleştirme altyapısı (Bölüm 46).

---

## 7. Açık sorular

Bu bölümdeki soruların tamamı 15 Kasım 2026 akşamı Ahmet tarafından kapatıldı. Kararlar §7A'dadır. Bu listeden açık soru kalmadı.

Kapananlar: 7.1 → K8, 7.2 → K1, 7.3 → K2, 7.4 → K3, 7.5 → K4, 7.6 → K7, 7.7 → K5, 7.8 ve 7.18 → K6, 7.9 → K9, 7.10 ve kapı arbedesi → K10 ve K11, 7.11 → K12, 7.12 → K13, 7.13 → K14, 7.14 → K15, 7.15 → K16, 7.16 → K17, 7.17 → K18.

---

## 7A. Kesinleşen kararlar (15 Kas 2026, Ahmet)

K1–K7 öğleden sonraki kararlardır. K8–K18 akşamki kararlardır. Çelişen bir cümle kalırsa bu tablo geçerlidir.

| ID | Kaynak | Karar |
|---|---|---|
| K1 | Dönem | 13. yüzyıl Selçuklu ucu, Kösedağ (1243) sonrası. `docs/dunya_kitabi/` geçerlidir. Asset görsel stili bu karardan etkilenmez. |
| K2 | Hamle | Turda her karakterin 2 eylemi vardır (XCOM tarzı). Aksiyon puanı yoktur. |
| K3 | Can | Sayısal can (HP). HP 0 "düştü" demektir. Savaş sonunda düşenler için yara ve sakatlık zarı atılır. Muhafız bu zarın ölüm satırına girmez (K4). |
| K4 | 7.5, eski K4 | Muhafız ölmez. HP'si 0 olursa savaş kaybedilmiş sayılır. Savaş sürebilir, kalan dostlar çekilir, ama galibiyet yazılmaz ve komuta kimseye devredilmez. Muhafız hayatta kalır. Yerine geçme yolu yoktur. Getiri ve götürü §5.9 tablosundadır: ganimet, itibar, husumet, yara, kaynak kaybı, köye etki. |
| K5 | Moğol | Küçük gruplarla savaşılır. Büyük akın savaş olarak oynanmaz; kaç, saklan, haraç ver ya da elçiyle görüş. |
| K6 | 7.8, 7.18 | Kadın ve genç katılımı bir ayardır. Varsayılan **açık**tır ve oyun ortasında değiştirilebilir. Çocuklar her durumda savaş dışıdır. |
| K7 | Kıtlık | Kıtlık ve açlık isyanı şimdilik kapsam dışıdır. Gelecek notu olarak kalır. |
| K8 | 7.1 | Önek **SVS-** dir. CAT-01..04 olduğu gibi kalır. CAT-05..84 açılmaz. |
| K9 | 7.9 | Okçuluk mini oyunu (`okculuk_oyunu.gd`) sur okçusu becerisine bağlanır. |
| K10 | 7.10 | Otomatik çözüm yoktur. Her savaş oynanır. YZ'ye karşı YZ yalnız test koşucusudur ve oyuncuya açık bir seçenek değildir. |
| K11 | Kapı arbedesi | Oyuncu iki yoldan birini seçer: muhafızın adamlarını gönderir, ya da muhafızın kendisi kapıdaki karakterle sıra tabanlı düello yapar. |
| K12 | 7.11 | Savaşın ortasında kayıt yoktur. Savaş başlamadan otomatik kayıt alınır. |
| K13 | 7.12 | Ganimet paylaşımı terazili bir ahlak kararıdır (adalet ve yozlaşma). |
| K14 | 7.13 | Esir ve fidye ROADMAP_3'e girer. |
| K15 | 7.14 | Bir savaşta en fazla 20 birim olur. |
| K16 | 7.15 | Ses için sessiz yer tutucu kullanılır. Savaş asset'leri envantere yazılır. 3B savaş animasyonları Meshy ile üretilebilir ve envanterde 3B başlığına yazılır. |
| K17 | 7.16 | Bölüşüm ROADMAP_2'deki gibi baştan ve sondan yapılır. Her maddenin sahip alanı "baştan" ya da "sondan" olur. |
| K18 | 7.17 | Eski metinlere ve diyaloglara dokunulmaz. Dönem terimi (uç beyi, subaşı, alp, gazi) yalnız yeni savaş metinlerinde kullanılır. |

---

## 8. ROADMAP_3 için önerilen madde başlıkları

Henüz detaysızdır. Önek **SVS-** olarak kesinleşti (K8). Sıra, önerilen uygulama sırasıdır. Bağımlılıklar parantez içinde verildi.

**Bölüşüm (K17):** ROADMAP_2'deki gibi baştan ve sondan. Antigravity listenin başından (A grubu) ileri gider. Berk tarafı listenin sonundan (G ve H) geri gelir. Her maddede sahip alanı "baştan" ya da "sondan" yazılır. Ayrı bir orta bölge açılmaz.

### A. Temel ve veri

- **SVS-01:** Savaş klasör yapısı ve adaptör sınırları (`src/savas/`, `data/savas/`, `tests/unit/savas/`).
- **SVS-02:** Birim istatistik şablonu: can (HP), saldırı, savunma, inisiyatif, moral, yorgunluk (K3).
- **SVS-03:** Mevcut köylü, asker ve adlı karakterden savaş birimine dönüştürücü; köylü sağlığından başlangıç HP'si; katılım ayarına göre aday süzme (SVS-02, SVS-53).
- **SVS-04:** 13. yy dönem teçhizatı tablosu: kılıç, mızrak, topuz, balta, Türk yayı, arbalet (tekfur), kalkan, keçe kaftan, zırh gömleği, tolga; köy silah stoğu (SVS-02, K1).
- **SVS-05:** Düşman şablonları: harami, çete reisi, tekfur yayası, tekfur okçusu / arbaletçisi, tekfur mızraklı atlısı, Rum milisi, Moğol öncü / keşif atlısı (yalnız küçük grup), asi Türkmen atlısı, kurt (SVS-02, K1, K5).
- **SVS-06:** Dost şablonları: muhafız, çavuş, kapı mızraklısı, sur okçusu, yetişkin erkek milis, kadın ve genç milis (ayara bağlı), hekim, Türkmen oba atlısı (alp), uç beyi / subaşı askeri, gazi / alp gönüllüsü (SVS-02, K1, K6).

### B. Motor çekirdeği

- **SVS-07:** Savaş durumu nesnesi ve deterministik RNG (saf mantık, sahnesiz).
- **SVS-08:** Savaş ızgarası: köy A* hücrelerinden savaş haritası, siper ve yükseklik. Bir savaşta en fazla 20 birim (K15) (SVS-07).
- **SVS-09:** Kapı arenası haritası (küçük sabit ızgara) (SVS-08).
- **SVS-10:** İnisiyatif ve tur sırası (SVS-07).
- **SVS-11:** Eylem modeli: turda karakter başına 2 eylem (XCOM tarzı); ağır eylemler iki eylemi harcar (K2) (SVS-10).
- **SVS-12:** Hareket, menzil ve görüş hesabı (SVS-08).
- **SVS-13:** Savaş zarı adaptörü: SorguZari kuralları, isabet formülü ve HP hasarı (SVS-11, K3).
- **SVS-14:** HP sıfırda "düştü" durumu ve savaş sonu yara / sakatlık zarı: ölüm, ağır yara, kalıcı sakatlık, hafif yara tablosu (K3) (SVS-13).
- **SVS-15:** Moral basamakları ve bozgun (SVS-13).
- **SVS-16:** Yorgunluk ve nöbet yorgunluğundan devralma (SVS-11).
- **SVS-17:** Nöbet tutma / karşılama saldırısı (SVS-12).
- **SVS-18:** Kazanma, kaybetme, geri çekilme ve teslim. Muhafız ölmez. HP'si 0 olursa savaş kaybedilmiş sayılır; kalan dostlar çekilebilir, galibiyet yazılmaz, komuta kimseye devredilmez. Sonuç §5.9 tablosundan gelir (K4) (SVS-15).
- **SVS-19:** Yalnız test amaçlı YZ-YZ koşucusu. Oyuncu menüsünde yoktur ve otomatik çözüm değildir (K10). `otomatik_oyuncu` bu koşucuyu kullanır. Eski formüllerle "aynı sayıyı ver" testi yazılmaz (SVS-18, SVS-20).

### C. Yapay zekâ

- **SVS-20:** Fayda tabanlı YZ çekirdeği (SVS-12, SVS-13).
- **SVS-21:** Davranış profilleri: harami, tekfur yayası, atlı okçu (Moğol ve Türkmen), çaresiz tek kişi (SVS-20).
- **SVS-22:** Düşman niyet gösterimi, gözcü kulesine ve keşif erine bağlı (SVS-20, HAR-06).

### D. Savaş türleri

- **SVS-23:** Kapı arbedesi (K11): oyuncu ya muhafızın adamlarını gönderir ya da muhafızın kendisi kapıdaki karakterle düello yapar. İkisi de oynanır. Otomatik zar çözümü yoktur (SVS-09, CAT-02).
- **SVS-24:** Gece baskını: husumet ve CAS-08 baskınının oynanır sürümü (SVS-18).
- **SVS-25:** Kapı ve sur kuşatması: tekfur baskınının çok aşamalı savunması (SVS-18).
- **SVS-26:** Kapı ve sur hasarı, yangın, onarım (SVS-25).
- **SVS-27:** Moğol tehdidi (K5): küçük öncü / keşif grubuyla sıra tabanlı savaş; büyük akın kolu savaşsız karar düğümü (kaç, saklan, haraç ver, elçiyle görüş) (HAR-02, DNY-01, SVS-18).
- **SVS-28:** Dış sefer / pusu temizliği (HAR-05, HAR-14).
- **SVS-29:** Kervan koruma savaşı (`kervan_korumasi`).
- **SVS-30:** Müttefik takviyesi: Türkmen obası ve uç beyi / subaşı askeri (HAR-04, HAR-07, K1).

### E. Savaş öncesi ve sonrası

- **SVS-31:** Savaş kararı paneli: savaş, pazarlık, rüşvet, kapat, kaç. Otomatik çöz satırı yoktur (K10). Kapıda iki yol: adamlarını gönder, düello (K11).
- **SVS-32:** Konuşlanma ekranı: HAR-10 dizilişinden başlangıç (HAR-10).
- **SVS-33:** Ganimet paylaşımı, terazili ahlak kararı: adalet ve yozlaşma (K13).
- **SVS-34:** Esir ve fidye ROADMAP_3 içindedir: yakalama, tutma, fidye, salıverme. Divan hükmü bu akışın parçasıdır, işin tamamı divana bırakılmaz (K14).
- **SVS-35:** Savaş sonrası tedavi: SVS-14 sonuçlarının şifahane akışına bağlanması, HP'den köylü sağlığına aktarım, kalıcı sakatlığın iş gücüne etkisi (CAT-03, KRI-13, SVS-14).
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
- **SVS-47:** Yer tutucu birimler (kutu + isim etiketi). Ses sessiz yer tutucudur. 3B savaş animasyonları Meshy ile üretilebilir. Hepsi envantere yazılır; 3B kalemler 3B başlığındadır (K16).

### G. Kayıt, denge ve kapanış

- **SVS-48:** Savaş başlamadan otomatik kayıt. Savaş ortasında kayıt yoktur (K12). Kayıt göçü SYS-14 adımıyla.
- **SVS-49:** Denge tabloları ve ölçüm koşusu (senaryo koşucusu ile).
- **SVS-50:** `otomatik_oyuncu` 20 gece duman testi. Savaşlar SVS-19 test koşucusuyla geçer. Oyuncuya açık bir atlama seçeneği eklenmez (K10).
- **SVS-51:** Perde ve son bağlantıları: 2. perde savunması, tekfur sonu (SYS-19, SYS-20).
- **SVS-52:** ROADMAP_3 kapanış testi.

### H. Kararlardan doğan ek madde

- **SVS-53:** Savaşa katılım ayarı (K6): kadınlar ve gençler. Varsayılan açık, oyun ortasında değiştirilebilir. Çocuklar her durumda savaş dışıdır. Yeni oyun seçeneği ve ayarlar paneli (Bölüm 35). Uygulama sırası A grubunda, SVS-03'ten öncedir.
- **SVS-54:** Okçuluk mini oyunu sur okçusu becerisine bağlanır (`okculuk_oyunu.gd`, HAR-10 `sur` rolü) (K9).

**Toplam: 54 madde başlığı (SVS-01 … SVS-54).**

**Kapsam dışı (K7, gelecek notu):** Kıtlık / açlık isyanı ve ambar yağması için SVS maddesi açılmaz.
