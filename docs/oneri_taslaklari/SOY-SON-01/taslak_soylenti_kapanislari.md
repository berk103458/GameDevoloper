# SOY-SON-01: Dedikodu ve Söylenti Ağının Somut Olaylara Kapanışı — Diyalog ve Olay Taslağı

Bu taslak, `soylenti_agi.gd` içinde dolaşan fısıltıların 2-3 gün sonra birer somut köy olayına veya kapı yüzleşmesine dönüşerek çözülmesini sağlar.

---

## 1. Çözülme: "Değirmencinin Eksik Kilesi ve Çınaraltı Hesabı"
- **Öncül Fısıltı:** `soylenti_degirmen_un_caliyor` (Köyde değirmencinin her çuvaldan iki kile aşırdığı dedikodusu).
- **Kapanış Sahnesi (Çınar Meclisi):**
  - Köylüler Yusuf ve Karaca Usta, Değirmenci Mihali'yi Çınaraltına çeker.
  - **Mihali:** "Efendi muhafız! Yemin olsun un çalmadım! Çarkın tahtası çürüdü, un oluktan dereye dökülüyor! Gelin değirmenin altına bakın!"
  - **Muhafız Seçimi 1 (Mihali'yi Haklı Bulma / Tamir Desteği):** "Gidip baktık; oluk delinmiş. Karaca Usta, iki tahta çakıverin şu oluğa. Boş yere adamın günahına girmeyin." -> `adalet +1`, `moral +1`, `soylenti_degirmen_cozuldu = true`.
  - **Muhafız Seçimi 2 (Zorla Teftiş ve Ceza):** "Her kileden bir avuç köy ambarına kefaret vereceksin." -> `akce +1`, `adalet -1`.

---

## 2. Çözülme: "Kuyu Zehirlenmesi Korkusunun İlacı"
- **Öncül Fısıltı:** `soylenti_kuyuya_zehir_atildi` (Kuyu suyunun acıdığı ve haramilerin zehir attığı paniği).
- **Kapanış Sahnesi (Meydan Taşı / Miraen):**
  - Köylü kadınlar testilerini kırmış, su içmeye korkmaktadır.
  - **Miraen:** "[Gümüş maşrapayla suyu koklar, içine adaçayı yaprağı atar] Zehir yoktur evelallah! Kuyu dibine rüzgârla çürük palamut yaprağı dolmuş, su ondan acımış. İki delikanlı insin, kovanın dibini temizlesin. Bir kile de tuz atın, su pırıl pırıl olur."
  - **Muhafız Seçimi (Meydanda Suyu İlk İçen Olma):** Muhafız maşrapayı kafasına diker: "Gördünüz mü? Suda hile yok, yüreğinizde vesvese var. İşinizin başına dönün." -> `asayis +2`, `moral +2`, `soylenti_kuyu_aklandi = true`.

---

## 3. Çözülme: "Tekfur'un Devrilen Altın Arabası"
- **Öncül Fısıltı:** `soylenti_tekfurun_altin_arabasi` (Vadide Tekfur'un altın yüklü arabasının devrildiği söylentisi).
- **Kapanış Sahnesi (Kapıda Yüzleşme):**
  - Kapıya omzu çıkmış, çamurlar içinde yaşlı bir Rum katırcı gelir (`chr_katirci_rum`).
  - **Katırcı:** "Aman beyim... dağda araba devrildi dediler, köyün gençleri kazma kürekle üstüme çullandı. Altın ne gezer? Tuz fıçısıydı hepsi! İki çuval tuzu da dereye döktüler!"
  - **Muhafız Seçimi 1 (Köylüleri Yatıştırıp Katırcıya Tazminat Verme):** "Biz harami değiliz. İki akçe verin şuna, tuzun parasını ambar ödesin." -> `adalet +2`, `akce -2`, `soylenti_tekfur_araba_sonuc = true`.
  - **Muhafız Seçimi 2 (Sınır Dışına Sürme):** "Yolu şaşırmışsın ihtiyar, dön vadine git." -> `asayis -1`, `adalet -1`.

---

## 4. Çözülme: "Meydan Ateşindeki Moğol Casusu Fısıltısı"
- **Öncül Fısıltı:** `soylenti_mogol_casusu_dolasiyor` (Köyde geceleri yabancı birinin ocakları gözetlediği dedikodusu).
- **Kapanış Sahnesi (Gece Devriyesi / Avcı Nogay):**
  - Avcı Nogay, samanlığın arkasında saklanan bir adamı yakalayıp Muhafız'ın önüne atar.
  - **Nogay:** "Casus diye bunu tuttuk ağam. Üç gecedir samanlıkta büzülüyordu."
  - **Şüpheli:** "Casus değilim kurban olayım! Sivas'ta borçlandım, alacaklılardan kaçıp samanlığa saklandım. Ekmek çalmadım, tavuk çalmadım!"
  - **Muhafız Seçimi 1 (Ahilik Kefaletine Verme):** Karaca Usta'ya çırak yazılır. -> `koy_nufusu +1`, `asayis +1`, `soylenti_casus_yakalandi = true`.
  - **Muhafız Seçimi 2 (Köyden Kovma):** "Gece vakti saklanan adamdan hayır gelmez." -> `asayis +1`, `moral -1`.

---

## 5. Çözülme: "Kilerdeki Vebalı Kumaş İftirası"
- **Öncül Fısıltı:** `soylenti_vebali_kumas_var` (Kayserili çuhacının getirdiği kumaşlarda veba mikrobu olduğu söylentisi).
- **Kapanış Sahnesi (Dokuma Tezgâhı Önü / Ayşe Bacı):**
  - Ayşe Bacı ve kadınlar kumaş toplarını kireçli kazanlarda kaynatır.
  - **Ayşe Bacı:** "Dedikoduyu çıkaran rakip kumaşçıymış meğer! Kumaşlar saf koyun yünüdür, güneşte havalandırdık, lavanta suyuyla yıkadık. Tek bir leke yoktur!"
  - **Muhafız Seçimi:** İftiracıyı teşhir edip çarşı nizamını sağlama. -> `adalet +2`, `moral +1`, `soylenti_kumas_temiz = true`.
