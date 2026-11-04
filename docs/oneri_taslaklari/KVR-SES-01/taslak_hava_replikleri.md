# KVR-SES-01: Kapı Nöbetinde Dinamik Hava ve Ayaz Replikleri — Taslak

Mevsim ve hava durumu sistemine bağlı olarak, kapıya gelen 30 ziyaretçinin açılış sözlerine ve Muhafız'ın karşılamasına eklenecek dinamik atmosfer ön ekleridir.

---

## 1. Hava Durumu: Tipi ve Kar Fırtınası (`hava == "firtina" || hava == "kar"`)

### Ziyaretçi Açılış Ön Ekleri (Rastgele 1 Seçilir):
- `[titreyerek, dişleri birbirine çarparak]` "A-ağam... dondum... nefesim buz tuttu... İki adım daha atsam şu surun dibinde karlar örtecekti üstümü..."
- `[kaşlarından ve bıyıklarından sarkan buzları silkeleyerek]` "Boran dağ yolunu kapattı muhafız! Göz gözü görmez, atlar karda saplandı kaldı! Aç şu kapıyı kurbanın olayım!"
- `[hırkasına sıkıca sarılmış, titrek bir sesle]` "Rüzgâr kemiklerimi dondurdu... Bir avuç ocak sıcaklığı, bir yudum sıcak çorba için sığındım..."

### Muhafız Karşılama Varyasyonu:
- "Dur hele! Ayazdan sesin boğulmuş amma kapının nizamı karda da birdir, yazda da. Kimsin, nereden gelirsin?"

---

## 2. Hava Durumu: Yağmur ve Çamur Baskını (`hava == "yagmur"`)

### Ziyaretçi Açılış Ön Ekleri:
- `[cübbesinden şakır şakır sular süzülerek]` "Sırılsıklam olduk beyim... Dağ deresi taştı, köprü çöktü. Üstümdeki çaput bile on okka çeker oldu."
- `[çamurlu çizmelerini eşiğe vurarak]` "Yol çamur deryası... Ayaklarımız balçığa saplana saplana geldik. Bir kuru tahta verin dinlenelim."

### Muhafız Karşılama Varyasyonu:
- "Geldin amma yükünle geldin. Çöz heybeni, dök eteğindeki çamuru. Neyin nesisin?"

---

## 3. Hava Durumu: Gece Ayazı ve Don Kırgını (`hava == "ayaz"`)

### Ziyaretçi Açılış Ön Ekleri:
- `[avuçlarını ağzına götürüp hohlayarak]` "Bıçak gibi kesiyor ayaz... Demir kapının tokmağı elime yapıştı kaldı. Bir nefeslik dirlik verin."
- `[dudakları morarmış, fısıltıyla]` "Nefes aldıkça göğsüm yırtılıyor muhafız... Bu gece dışarıda kalan sabaha canlı çıkmaz..."

### Muhafız Karşılama Varyasyonu:
- "Ayaz serttir amma kapı gevşek tutulmaz. Aç ağzını, kimsin?"

---

## 4. Hava Durumu: Yoğun Sis ve Alacakaranlık (`hava == "sis"`)

### Ziyaretçi Açılış Ön Ekleri:
- `[sislerin arasından aniden belirip irkilerek]` "Meşalenin ışığını görünce koştum... Kurt uluması sandım rüzgârı. Neresidir burası?"
- `[fenerini kaldırarak]` "Karanlıkta yol kayboldu ağam. Kapı kulesi olmasa uçuruma yuvarlanacaktık."

### Muhafız Karşılama Varyasyonu:
- "Adımını yavaş at! Sisin ardında kimin yürüdüğünü göz görmez, yay kirişi bilir. Çık ışığa!"
