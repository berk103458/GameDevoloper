# ANL-DON-01: Ziyaretçi Geri Dönüş Döngüsü ve İkinci Karşılaşmalar — Diyalog Taslağı

İlk 10-15 günde kapıdan içeri alınan veya geri çevrilen kritik karakterlerin, kararın sonuçlarıyla 5-10 gece sonra kapıya veya köy meydanına ikinci kez gelmesi taslağıdır.

---

## 1. İkinci Karşılaşma: Sancak Çavuşu Sungur (Karşıt Dönüş)
- **Koşul:** Sungur ilk gelişinde reddedildiyse ve `gun >= 12`.
- **Durum:** Sungur bu defa tek başına değil; yanında 4 sancak muhafızı, elinde Sivas Divanı'nın kırmızı mühürlü arama fermanıyla gelir.
- **Diyalog:**
  - **Sungur:** "[Alaycı ve sert] Hatırladın mı beni muhafız efendi? 'Kapıdan kuş uçurtmam' diyordun. Bak bakalım bu fermana! Beylik mührü altında 'firari avı için her ambar ve hane aranacaktır' yazar! Çekil önümden, yoksa kapıyı başına yıkarım!"
  - **Seçenek 1 (Fermanı Tanıyıp İzin Verme):** "Ferman beyliğindir amma köyün namusu bendedir. Yalnız iki neferinle gireceksin; köylünün tavuğuna dokunursan kılıcımı çekerim." -> `asayis -2`, `adalet +1`, `sungur_ikinci_arama_yapildi = true`.
  - **Seçenek 2 (Direniş ve Divan Tehdidi):** "Bu köy uç beyliğidir; kadı naibi olmadan kapı açmam. Git Sivas'a, kadı efendiyi al da gel!" -> `sungur_dusman_oldu = true`, `asayis +2`, `sancak_ofkesi +1`.

---

## 2. İkinci Karşılaşma: Sancak Çavuşu Sungur (Müttefik Dönüş)
- **Koşul:** Sungur ilk gelişinde rüşvet / un verilerek tatmin edildiyse ve `gun >= 10`.
- **Durum:** Sungur gece fırtınasında tek atla kapıya yaklaşır, kapı kulesine ıslık çalar.
- **Diyalog:**
  - **Sungur:** "[Fısıldayarak] Muhafız! Aç şu mazgalı, ses etme. Sana borcum vardı. İki güne Sivas teftiş heyeti bu boğaza gelecek. Ambarınızdaki kaçak arpayı ve askersiz nöbet defterini saklayın. Benden duymadın say!"
  - **Seçenek 1 (Teşekkür ve İhbarı Kullanma):** "Eksik olma çavuş. Hakkı gözeteni bu kapı unutmaz." -> `divan_teftis_ihbari = true`, `koy_guvenlik +2`.

---

## 3. İkinci Karşılaşma: Yeğenler Dursun ve Turna'nın İlk Ekmeği
- **Koşul:** Hem Dursun hem Turna kabul edildiyse, `gun >= 8`.
- **Durum:** Sabah nöbetinin ayazında Dursun başında unlu fesi, Turna kucağında beyaz bezle sarılı sıcak somunla kapı kulesine çıkar.
- **Diyalog:**
  - **Dursun:** "Dayı! Ayşe Bacı fırını yaktı bu sabah! İlk harman ekmeğini çıkardık. Turna dedi ki 'dayımın nöbeti bitmeden götürelim, soğumasın'."
  - **Turna:** "[Bezi aralar; mis gibi taze ekmek buharı tüter] Al dayı... Hamza dayımın yüzüğünü de yeleğimin içine diktim, hiç kaybetmiyorum. Sıcak sıcak ye, ayaz çarpmasın."
  - **Muhafız Seçimi:** "Bereketli olsun kuzularım. Sizin şu ekmeğiniz koca bir obayı doyurur." -> `muhafiz_moral +3`, `es_mutluluk +2`, `dursun_turna_mutlu = true`.

---

## 4. İkinci Karşılaşma: Cerrah Lokman'ın Köy İçi İhaneti
- **Koşul:** Cerrah Lokman kabul edildiyse ve `gun >= 9`.
- **Durum:** Köy meydanında arbede kopar. Nalbant Karaca Usta, Lokman'ı yakasından tutmuş kapıya sürükler.
- **Diyalog:**
  - **Karaca Usta:** "Bu sahtekârı kapıdan içeri aldın muhafız! Çırağım Musa'nın sancılanan dişine 'şifadır' diye afyon suyu sürmüş, çocuk iki gündür uyanamaz! Cebinden de sahte Selçuklu dirhemleri çıktı!"
  - **Lokman:** "İftira ağam! Ağrıyı kesti ya! Karaca Usta bana borçludur, parasını vermemek için yaygara koparıyor!"
  - **Muhafız Seçimi 1 (Meydanda Falakaya Yatırma ve Sürme):** Lokman dövülerek köyden atılır. -> `adalet +2`, `asayis +1`, `lokman_kovuldu = true`.
  - **Muhafız Seçimi 2 (Aletlerine El Koyup Zindana Atma):** "İlaç şişelerini Miraen'e verin, kendisini de kule zindanına kilitleyin." -> `adalet +1`, `akce +1`.

---

## 5. İkinci Karşılaşma: Banu Hatun'un Zafer Müjdesi
- **Koşul:** Banu Hatun ile ittifak yapıldıysa ve `gun >= 14`.
- **Durum:** Banu Hatun, karlı gecede 10 süvarisiyle köyün önünde at oynatır.
- **Diyalog:**
  - **Banu Hatun:** "[Atının üstünden kılıcını kınına sokar] Muhafız! Kapıyı açmana lüzum yok, haber vermeye geldim. Vadide pusu kuran Tekfur'un 30 çapulcusunu derede kıstırdık. Atlarını ve pusatlarını aldık. Beş beygiri ve on mızrağı köyün kapısına bıraktık, nöbetçilerinize helaldir!"
  - **Muhafız Seçimi:** "Var olasın Banu Hatun! Sınır boyunda Türkmen'in pusatı parladıkça bu köyün başı eğilmez!" -> `koy_savunma +3`, `moral +2`, `banu_ittifak_pekisti = true`.

---

## 6. İkinci Karşılaşma: Tebrizli Safrancı Behram'ın Hediye Kervanı
- **Koşul:** Tüccar Behram kabul edildiyse ve `gun >= 11`.
- **Durum:** Behram'ın katırları tuz ve kuru meyve yüklü olarak dönüş yolunda kapıda mola verir.
- **Diyalog:**
  - **Behram:** "Selamünaleyküm muhafız ağam! Tebriz kervanını sağ salim Konya pazarına indirdik. Kapında dinlendiğim o gece hayatımı kurtardı; haramiler beni dağda bekliyormuş. Al şu iki çuval kuru incirle bir tulum Halep zeytinyağını; hanendeki hatununa hediyemdir."
  - **Muhafız Seçimi:** "Bereketini gör tüccar başı. Helal kazananın yolu açık olsun." -> `koy_erzak +2`, `akce +1`, `behram_vefa_gosterdi = true`.
