# Karakter özgünlüğü — şablon her karakteri aynı yapmasın diye

Taslak, 10 Ekim 2026. ROADMAP 2: YAZ-03, YAZ-09.

## Sorun

Şablonda "sır" diye bir evre var. Yazar her karakterde onu doldurursa oyuncu beşinci karakterde oyunu çözer: herkes bir şey saklıyor, sıkıştır, sır çıksın. Yusuf iyi bir sahne. Ama kırk tane Yusuf olursa hiçbiri iyi olmaz.

Sorunun kaynağı şu: şablon iki işi birden yapıyor. Hem dili tarif ediyor (düğüm, seçenek, koşul, zar), hem de içeriğin kalıbını (selam → konular → yüzleşme → sır → ikilem). Dil kalmalı, kalıp gitmeli.

## 1. Şablon dilbilgisi, kalıp değil

Motor yalnız şunu bilir: düğüm var, satır var, seçenek var, koşul var. Hangi evrelerin kullanılacağına sahne karar verir.

- Zorunlu olan yalnız **varış** ve **karar**. Arada ne olacağı karaktere kalmış.
- Selam yok, doğrudan "Kapıyı aç!" diye bağıran biri olabilir.
- Konu merkezi yok, iki soruda biten bir sahne olabilir.
- Yüzleşme, sır, ikilem yok; olmaması da bir şey söyler.

Doğrulayıcı (YAZ-07) eksik evre için uyarı vermez. Tersine, kadroda herkes aynı evreleri kullanıyorsa uyarı verir (aşağıda §5).

## 2. Sır yerine hikâye çekirdeği

Her karakterin bir **çekirdeği** olur: sahnenin asıl meselesi ne? Sır bunlardan yalnız biri. Karakter dosyasında `karakter.cekirdek` alanı.

| Çekirdek | Ne oluyor | Oyuncu ne yaşıyor | Örnek |
|---|---|---|---|
| `durust` | Söylediği doğru, saklısı yok | Şüphe boşa çıkar; sorguladıkça mahcup olur | Kızılca'dan gelen yaşlı çömlekçi. Heybede çanak çömlek, o kadar. |
| `koruma_yalani` | Birini korumak için yalan | Yalanı bulur, sonra bulduğuna üzülür | Yusuf |
| `yanlis_anlasilma` | Şüpheli görünür ama başka bir şeydir | Yanlış izden gider, sonunda yanıldığını görür | Kanlı bıçak; kasap, yolda koyun kesmiş |
| `bilmedigi` | Karakterin kendisi de bilmiyor | Muhafız karakterden fazlasını öğrenir | Kardeşini arayan kadın; kardeş öldü, haberi kapıda muhafız duyar |
| `abartma` | Kendini olduğundan büyük gösterir | Yalan zararsız ama gülünç; söner | "Beyin atlarına ben baktım" diyen seyis yamağı |
| `baskasinin_sirri` | Saklanan şey onun değil | Sıkıştırınca kendi değil, başkası yanar | Köydeki birinin kaçak oğlunu getiren çoban |
| `pazarlik` | Açıkça bir şey ister, karşılığında bir şey verir | Karar ahlaki değil ticari | Tuz getiren kervancı: "İçeri al, yarısı senin" |
| `itiraf_etmek_isteyen` | Söylemek ister, cesareti yok | Sıkıştırmak bozar, beklemek açar | Asker kaçağı, teslim olmaya gelmiş |
| `dinlenmek_isteyen` | Bir derdi var, çözüm istemiyor | Sorgu değil sohbet; kararın önemi az | Oğlunu Kösedağ'da kaybetmiş ihtiyar |
| `tehlikeli_yalan` | Yalan söylüyor ve gerçekten tehlikeli | Klasik sorgu; yanlış karar köye bedel ödetir | Moğol tarafına haber taşıyan "derviş" |
| `hafif` | Komik ya da önemsiz | Nefes alma; gerilimi kırar | Keçisini kapıdan sokmak isteyen kadın |

**Kota:** kadronun yaklaşık %40'ı `durust` ya da `dinlenmek_isteyen` olur. Oyuncu herkesin yalan söylemediğini bilmeli; yoksa şüphe bir anlam taşımaz. Kalan çekirdekler kadroya dağıtılır, hiçbiri kadronun %15'ini geçmez. Bu kotayı doğrulayıcı sayar.

## 3. Benzersizlik matrisi

Çekirdek tek başına yetmez: iki `koruma_yalani` karakter yine aynı sahne olabilir. Her karakter yedi eksende yazılır. İki karakter dört ya da daha fazla eksende aynıysa doğrulayıcı uyarır.

| Eksen | Seçenekler (örnek) |
|---|---|
| İstediği | girmek, geçmek, birini bulmak, satmak, haber vermek, sığınmak, sadece konuşmak |
| Korktuğu | ret, tanınmak, Moğol, beyin adamları, hastalık, kendi geçmişi, hiçbir şey |
| Bilgi durumu | her şeyi biliyor, yarısını biliyor, yanlış biliyor, hiçbir şey bilmiyor |
| Konuşma biçimi | kısa ve kapalı, geveze, soruya soru, pazarlıkçı, sert, yalvaran, alaycı |
| Muhafıza bakışı | korkuyor, küçümsüyor, yaranmaya çalışıyor, tanıyor, aldırmıyor |
| Sonucun bedeli | adalet, köyün güvenliği, vicdan, kasa, itibar, bedelsiz |
| Sahne biçimi | §4'teki listeden |

## 4. Sahne biçimleri

Ağacın şekli de değişmeli. Her sahne konu merkezli olursa oyuncu menüyü ezberler.

- **Kısa ve dürüst:** iki soru, karar. Bir dakika sürer.
- **Pazarlık:** konu yok; teklif, karşı teklif, kabul ya da ret.
- **Geveze:** karakter durmadan anlatır, muhafız sözü keser ya da dinler. Önemli şey uzun lafın içinde kaybolur.
- **Sessiz:** karakter neredeyse konuşmaz. Bilgi gözle gelir: heybe, eller, giysi.
- **Saldırgan:** karakter bağırır, tansiyon yüksek başlar. Sakinleştirmek bir zar kontrolüdür.
- **Soru soran:** sorguyu karakter yapar. "Bey burada mı? Kaç asker var?" Muhafız ne kadar söyleyeceğine karar verir.
- **Aile ya da grup:** birden çok konuşan; biri bir şey der, öbürü başka bir şey. Çelişki karakterler arasındadır.

Yusuf'un sahnesi "konu merkezli + yüzleşme" biçimi. Pilotun öbür iki karakteri (YAZ-05) bilerek başka biçimlerden seçilir.

## 5. Kadro düzeyinde denetim

Doğrulayıcı tek tek karakterlere değil, kadronun bütününe bakar:

- Çekirdek kotası (§2).
- Matris benzerliği (§3): dört eksen aynıysa uyarı.
- Evre kullanımı: kadronun yarısından fazlası "sır" evresini kullanıyorsa uyarı.
- Sahne biçimi dağılımı: tek biçim kadronun %30'unu geçmesin.
- Açılış cümlesi: iki karakterin ilk repliği aynı kalıpla başlamasın ("Selamün aleyküm" dışında).

Hepsi uyarıdır, karar değildir. Yazar gerekçesini karakter dosyasına not düşerek uyarıyı geçebilir.

## 6. Karakterler birbirine bağlansın

Kadro bir liste değil, bir köy kadar dünya. Karakterler birbirini anar, aynı olayları farklı yerden görür.

- Yusuf'un köyünden yedi ev daha yolda. Biri iki gün sonra gelir ve Yusuf'u sorar. Yusuf'u içeri almadıysanız kapıda başka bir sahne olur.
- Kızılca hanında asılan Ömer'in damadının karısı bir hafta sonra gelir.
- Moğol habercisi "derviş", Yusuf'un yolda gördüğü atlıları sorar.

Bağlar karakter dosyasında `baglar: [{karakter, nasil}]` alanında durur. Kişi hafızası (DIY-11) ve dedikodu (DIY-13) bunları taşır.

## 7. Yazım sırası

Şablon en son açılır. Önce insan:

1. **Kim bu insan?** Bir paragraf, düz yazı, insan eliyle. Nereden geliyor, dün gece nerede yattı, kapıya gelirken aklından ne geçiyor. Çekirdek ve matris bu paragraftan çıkarılır, tersi değil.
2. **Ses kartı.** Sıfat değil, alışkanlık: "Soruya önce yarım cevap verir, sonra düzeltir." (USLUP_REHBERI §5)
3. **Sesli doğaçlama.** Ahmet ya da Berk sahneyi telefona anlatır, karakterin ağzından. Kayıt yazıya geçer. (USLUP_REHBERI §6)
4. **Ağaç.** Doğaçlamadan çıkan satırlar şablona yerleştirilir. Hangi evrelerin gerektiğine sahne karar verir.
5. **Denetim.** Yapaylık denetimi, kapsam taraması, kadro denetimi.
6. **İnceleme.** Satır satır işaretleme; ✗ ve ✎ alanlar yeniden yazılır.

Model yardım edebilir: doğaçlamayı biçime sokar, eksik varyantı önerir, tutarsızlığı bulur. Ama "kim bu insan" paragrafını ve doğaçlamayı model yazmaz. Özgünlük oradan gelir.
