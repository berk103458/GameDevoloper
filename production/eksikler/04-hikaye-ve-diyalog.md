# 04 — Eksik hikâye, senaryo ve diyalog

Mevcut tüm metin: `../plan/EK-A-diyaloglar-olaylar-sonlar.md`.

## 1. Yarım kalan hikâye kolları (Ö1, kodda doğrulandı)
Olaylar aşağıdaki bayrakları koyuyor, ama `src/` içinde hiçbir kod bunları **okumuyor**.
Oyuncu bu seçimleri yapıyor, sonra bunlar hiçbir şeyi değiştirmiyor. Bu, Sütun 4'ü ("köy senin aynan") bozar.

| Bayrak | Nerede konuyor | Önerilen devam |
|---|---|---|
| `thessra_kirgin` | Eksik şişe → "Thessra'yı sorguya çek" | Salgında Thessra yardım etmeyi reddeder ya da isteksiz yapar; ya da bir gece köyü sessizce terk eder |
| `miraen_sadik` | Çavuş → "Burada öyle biri yok de" | 2. perdede Miraen bir saldırıda öne çıkar (savunma +1) ya da çavuş daha kalabalık geri gelir |
| `turkmen_kin` | Damgalı atlar → "Sorhan'ı koru" | Türkmen beyinin adamları 2. perdede Tekfur'a yardım etmez ya da kervanı keser |
| `dervis` | Derviş → "Misafir et" | Ertuğrul haberi olayının ön koşulu ya da ağırlığı olur; derviş Söğüt'ten geri döner |
| `baci_tezgah` | Ayşe Bacı → "Destekle" | Pazar geliri artar; Ahi kasabası sonuna "bacılar" satırı eklenir |

Ayrıca bağlantı eksikleri var:
- `ahi_ocagi` yalnız son koşulunda okunuyor. Ocağın gece gece bir etkisi yok.
- **Rüşvet sayısı** (`rusvet_sayisi`) tutuluyor ama hikâyede karşılığı yok. Kilit "kimse sonucu söylemez" diyor, yine de çok rüşvet alan muhafızın adı çıkmalı (bir olay ya da sonda bir satır).

## 2. Prolog yok (Ö1)
Oyun doğrudan "1. gece. Yolda yine birileri var." ile açılıyor. Eksik olanlar:
- **Kösedağ'dan sonra** ne oldu (1–2 cümle).
- **Muhafız kim?** Kilit yalnız "kervan muhafızı" diyor. Kimin kervanıydı? Kervan nerede kaldı? Neden bu ıssız yerde, neden tek başına? (Bu **kullanıcının karar vermesi gereken** bir konu; adı ve geçmişi uydurmadım.)
- **Kapı neden burada?** Uçta yıkık bir han mı, eski bir karakol mu?
- Öneri: 3–4 kartlık sessiz bir prolog (kara ekran + tek cümle + meşale yanar). Ses: rüzgâr, sonra ilk adım.

## 3. Epilog yok (Ö2)
Sonlar 2–3 cümle. Papers Please ve Reigns türünde oyuncunun en çok beklediği şey eksik: **"Onlara ne oldu?"**
- Her adlı karakter için **kaldı / gitti / reddedildi / öldü** hâline göre birer satır. Örnek: "Yusuf'un keçileri on yedi oldu." ya da "Yusuf'u bir daha gören olmadı."
- Bu, karakter-kadrosu GDD'sindeki "kaldı/gitti eşlemesi" kararıyla (Karar 7) bağlanmalı.

## 4. Kararın ardından tepki satırı yok (Ö2)
Karardan sonra herkese aynı satır çıkıyor: "Kapı açıldı. %s içeri girdi." / "Kapı kapalı kaldı. %s yoluna döndü."
- Her adlı karakter için karar başına **tek kısa tepki** gerekir: 10 karakter × 3–4 karar ≈ 35 satır.
  Örnek, Miraen kışlaya yazılınca: "Kılıcı yok. Ama tutacak bir şey isterim."
- Kural aynı kalır: tepki **ipucu verir, hüküm vermez**.

## 5. Sohbet derinliği (Ö2)
- **Güncelleme (4 Ekim):** Ahmet'in 20 hazır diyaloğu (`data/diyalog/diyalog_01_20.json`) adsız gelenlere bağlandı: düğmeler sorulan soru sayısına göre açılıyor, karardan sonra gelenin bir cevabı geliyor. Her diyalog oyun başına bir kez geliyor; sıra kayda yazılıyor, 20'si bitince sınıf şablonlarına dönülüyor.
- Her gelişte 3 soru var ve en çok 2'si sorulabiliyor. Sorular hep aynı sırada ve hep aynı cevabı alıyor.
- Discovery (MDA 2. öncelik) için şunlar eksik:
  - **Takip sorusu:** Bir cevap yeni bir soru açar. "Kösedağ'da kaldı." → "Sen nasıl kurtuldun?"
  - **Çelişki:** Bazı adsız figürler yalan söyler; iki cevap birbirini tutmaz (Papers Please'teki okuma becerisi). Sütun 2 bunu destekliyor.
  - **Geri dönenlerin önceki karara değinmesi:** "Geçen sefer kapını kapattın." Şu an 2. gelişteki sorular, önceki kararın kabul mü ret mi olduğuna bakmıyor.
- Kilit: "Dört düğme … sonra değişecek." Karaktere özel karar türleri eklenebilir: "Silahını bırakırsa", "Atları dışarıda kalsın", "Ayrı çadıra".

## 6. İkinci perde içeriği az (Ö2)
- 2. perdeye özel 4 olay var: elçi, Ertuğrul haberi, sur çatlağı, kaçan köylüler.
- **Tekfur'un yüzü yok.** Adı yok, nedeni yok. Öneri: adlı bir Tekfur ya da onun Rum komutanı. Thessra'nın Rum olması burada bir gerilim kolu açar.
- **Moğol tehdidi 2. perdede kayboluyor.** Ufukta duman olayı 12. geceden sonra hiç gelmiyor.
- Kapı 2. perdede "sade süzgeç" diye tarif ediliyor. Kapıya gelenler arasında Tekfur casusu bir figür türü eklenebilir.

## 7. Olay sayısı ve tekrar (Ö3)
- 24 olay var. Uzun bir oyunda tahsildar, kervan ve kıtlık tekrar ediyor. Her türe ikinci bir varyant metin yazılmalı.
- Mevsim: Saruca "Kış yaklaşıyor" diyor ama oyunda mevsim yok. Gece sayısına bağlı bir **kış** dönemi kurulabilir: ambar baskısı artar, kar sahnesi gelir (bkz. 05).

## 8. Tasarım belgesi eksikleri
`design/gdd/systems-index.md`'de 22 sistemden 15'i **Not Started**. Hikâyeyi doğrudan etkileyenler:
- **Sohbet (6)**, **Karar (7)**, **Sonlar (15)**: Oyunda kodları var ama GDD'leri yok. Kurallar şu an "GDD'siz geçici kurallar" (bkz. `production/session-state/active.md`).
- Sıradaki iş zaten **Barlar (8)** GDD'si.
