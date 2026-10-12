# Söz Tasarımı — Kapı Muhafızı'nın konuşma motoru

DIY-01. Bu belge Söz motorunun neden böyle kurulduğunu yazar. Şema (DIY-01a) ve motor (DIY-02) bu belgeye dayanır. **Ahmet onaylamadan DIY-01a'ya geçilmez.**

Belge iki bölümdür: **İnceleme** yedi kaynağın ne yaptığını ve bizim ondan ne alıp ne almadığımızı yazar; **Kapı usulü** bizim konuşmamızın sabit kurallarını yazar. Üçüncü bölüm açılmaz. Alınan her mekanik bir DIY veya ZAR maddesine bağlıdır; bağı olmayan fikir bu belgeye girmez, "park" listesi de tutulmaz. İnceleme bölümü oyun repliği üretmez.

Doğrulayıcı: `python -B tools/soz_tasarimi_dogrula.py` (bölüm sayısı 2, yedi kaynak, her kaynakta dört satır, her "Alınacak" parçasında var olan bir DIY/ZAR kimliği; iç ses, beceri ağacı ve görünmez zar "Alınacak" satırında geçemez).

## İnceleme

### Kingdom Come: Deliverance II
- **Ne yapıyor:** Konuşma seçenekleri ikna, gözdağı ve etkileme gibi yaklaşımlara ayrılır; sonucu karakterin değerleri, kıyafeti, temizliği, üstündeki kan ve itibarı belirler. Karşıdaki kişi suçunu ya da kılığını hatırlar.
- **Neden işe yarıyor:** Oyuncu konuşmaya girmeden önce verdiği kararların (ne giydiği, ne yaptığı) konuşmada karşılığını görür; seçenek bir "doğru cevap" değil, bir yaklaşım seçimidir.
- **Alınacak:** Konuşmanın başında görünür durumun bağlam olarak okunması (DIY-08); yaklaşım türleri ve onları değiştiren koşullar (ZAR-04); kişiye göre değişen taban zorluk (ZAR-02).
- **Alınmayacak:** Deneyimle büyüyen konuşma becerisi ve beceri ağacı — muhafızın sözü terazisi ve geçmişiyle tonlanır (DIY-15), puan biriktirerek güçlenmez; kıyafet/temizlik ekonomisi — kapıda muhafızın kılığı oyun değişkeni değildir.

### Disco Elysium
- **Ne yapıyor:** Zar 2d6 olarak ekranda atılır, hedef sayı ve her değiştirici önceden gösterilir. Beyaz kontroller tekrar denenebilir, kırmızılar tek şanslıktır. Beceriler kahramanın kafasının içinde ayrı sesler olarak konuşur.
- **Neden işe yarıyor:** Görünür zar başarısızlığı adil kılar; oyuncu riski bilerek alır. Tek şanslık kontrol kararlara ağırlık verir, tekrarlanabilir olan ise oyuncuyu kilitlemez.
- **Alınacak:** Görünür zar ve hedefin önceden gösterilmesi (ZAR-01); tekrar edilebilir ve tek şanslık kontrol ayrımı (ZAR-05); zarsız, yalnız bir satırlık pasif fark ediş (ZAR-06).
- **Alınmayacak:** İç sesler ve düşünce dolabı — muhafızın iç dünyası kendi sesiyle değil, sezgi satırı (ZAR-06) ve eşin akşam yorumuyla anlatılır (Kapı usulü 6); 24 becerili ağaç — oyun bir rol yapma karakter yapımı değildir; uzun, edebi monologlar — kapıda kısa cümle konuşulur.

### Valve — bağlamsal kural seçimi (Left 4 Dead 2, Elan Ruskin, GDC 2012)
- **Ne yapıyor:** Konuşan karakter her an dünyanın durumunu tek bir sorgu sözlüğünde toplar. Satırlar koşul listesiyle yazılır; sözlükle en çok koşulu eşleşen, yani en özgül kural seçilir. Söylenen satır hafızaya yazılır ki tekrar edilmesin.
- **Neden işe yarıyor:** Yazar binlerce dal çizmeden, satırı koşuluyla birlikte ekler; dünya değiştikçe doğru satır kendiliğinden öne çıkar. Ekleme yapmak eskiyi bozmaz.
- **Alınacak:** Dünya durumunun konuşma başında tek salt-okunur sözlükte toplanması (DIY-08); koşul sayısına göre en özgül satırın seçilmesi (DIY-09); söylenenin kişi hafızasına yazılıp dönüşte hatırlanması (DIY-11).
- **Alınmayacak:** Kuralların dünyaya geri yazması — bizim sözlüğümüz salt okunurdur, ekonomiye ve sayaçlara yazmaz (DIY-08 kural 2); eşitlikte rastgele seçim — eşit özgüllükte seçim köyün tohumlu RNG'siyle yapılır, aynı tohum aynı satırı verir.

### Failbetter Games ve Emily Short — nitelik temelli anlatı ve öne çıkma (salience)
- **Ne yapıyor:** İçerik küçük "storylet" parçalarıdır; her parça oyuncunun niteliklerine (sayılar, bayraklar) bağlı koşulla açılır. Emily Short'un öne çıkma ilkesinde o an en ilgili parça sunulur, gerisi beklemede kalır.
- **Neden işe yarıyor:** Hikâye doğrusal bir ağaç değil, dünyanın durumuna göre açılan bir havuzdur; yeni parça eklemek mevcut akışı kırmaz, oyuncunun geçmişi doğal olarak görünür.
- **Alınacak:** Grup itibarının (Türkmen, Rum, Ahi, köylü, tüccar, asker) satır koşulu olarak okunması (DIY-12); haberin gecikmeli dolaşan parçalar olarak yayılması (DIY-13); kişinin sırrının ve ikileminin koşulla açılan dal olması (DIY-10).
- **Alınmayacak:** Nitelik toplamak için tekrar eden "grind" ve eylem enerjisi — kapıda zamanın bedeli sıra sabrıdır (DIY-05), harcanan bir enerji kaynağı değildir; oyuncuya görünen ham nitelik sayıları — itibar oyuncuya söz ve tavır olarak yansır.

### Pentiment
- **Ne yapıyor:** Soruşturmada her şeyi yapmaya zaman yetmez; oyuncu kimi dinleyeceğini seçer. Kararların sonucu günler sonra, kasabanın sözünde ve tavrında görünür; "doğru" sanık kesin olarak açıklanmaz. Kahramanın geçmişi konuşma seçeneklerini renklendirir.
- **Neden işe yarıyor:** Zaman bedeli her sohbete ağırlık verir. Sonucun geç gelmesi kararı bir test sorusu olmaktan çıkarıp bir sorumluluğa çevirir.
- **Alınacak:** Sohbetin sıra ve gün içinde zaman bedeli (DIY-05); kararın hatırlanacağının oyuncuya bildirilmesi (DIY-14); muhafızın geçmişi ve terazisiyle seçenek metninin tonlanması (DIY-15).
- **Alınmayacak:** Gerçeğin hiç açıklanmaması — bizde yalan kanıtla ortaya çıkabilir (DIY-07); sınıfa göre değişen yazı tipi — metin okunurluğu ve erişilebilirlik ayarları önce gelir; uzun anlatıcı ara bölümleri — konuşma kapıda, o an olur.

### Papers, Please
- **Ne yapıyor:** Görevli, gelenin belgelerini ve sözünü karşılaştırır; tutarsızlığı işaretleyip sorgular. Gün sınırlıdır; her geçen kişi aileye ekmek, her hata ceza demektir.
- **Neden işe yarıyor:** Sorgu soyut bir merak değil, somut bir eşleştirmedir: "bu söz şu kanıtla çelişiyor". Zaman baskısı her kararı pahalı kılar ve görevlinin vicdanı ile ekonomi aynı masaya oturur.
- **Alınacak:** Gelenin söylediklerinin kayda geçmesi (DIY-06); söz ile kanıtın çelişkisinin oyuncu tarafından gösterilip yüzleşmeye dönüşmesi (DIY-07); muhafızın da söz kesip karşı soru sorabilmesi ve kendi beyanını vermesi (DIY-18).
- **Alınmayacak:** Kural kitabı ve damga mini oyunu — kapı bir bürokrasi masası değil, bir eşiktir; yalnız belge eşleştirme — bizim kanıtımız heybe, yüz ve söz, kâğıt değildir; sohbetsiz karar — her karar bir konuşmanın sonudur.

### inkle / Ink (80 Days, Heaven's Vault)
- **Ne yapıyor:** Metin düğümler ve dikişlerle yazılır; seçenekler dallanıp yeniden bir araya gelir ("weave"). Durum değişkenleri satırları açar, sohbet bir konu merkezine dönerek sürer. Heaven's Vault geçmiş konuşmaları hatırlar.
- **Neden işe yarıyor:** Yazar düz metin yazar gibi çalışır; dallar bir merkeze döndüğü için içerik patlamaz. Konu merkezli yapı oyuncuya "neyi sorabilirim" haritası verir.
- **Alınacak:** Metin önce, sade bir konuşma dosyası biçimi (DIY-01a); düğümleri yürüten tek çekirdek (DIY-02); selamdan sonra konu merkezine dönen sohbet (DIY-03); aynı konuda üstelemenin yeni bilgi açması (DIY-04).
- **Alınmayacak:** Ink çalışma zamanının kendisi — Söz motoru tektir ve bizim veri biçimimizi okur, ikinci bir motor eklenmez; dakikalarca süren dallı düzyazı — kapıda kısa cümle ve hızlı tempo; zamanlı seçim sayacı — baskı sıra sabrından gelir (DIY-05), ekranda geri sayımdan değil.

## Kapı usulü

Kapı Muhafızı'nda konuşma bir eşikte olur. Aşağıdaki yedi kural her konuşmada geçerlidir; şema ve içerik bunlara uyar.

1. **Önce selam, sonra hikâye.** Her konuşma selamla açılır; muhafız ya da gelen selam vermeden konuya girilmez. Selamın biçimi (verilen, alınan, verilmeyen) kişinin tavrını belirler. (DIY-03)
2. **İkram tansiyonu değiştirir.** Su, ekmek ya da ateş başına davet sunulabilir. İkram gerginliği düşürür; geri çevrilen ikram da bir cevaptır. (ZAR-03)
3. **Eşikte konuşma iki ayrı sahnedir.** Kapı açılmadan önce söylenen ile içeri alındıktan sonra söylenen ayrı satırlardır; içeri alınan kişi daha rahat konuşur, ama kapı dışında söylediği de kayıtta kalır. (DIY-06)
4. **Soru heybeden sürüklenir.** Muhafız heybede ya da kişinin üstünde gördüğü bir şeyi sohbete sürükleyerek sorar; soru menüden değil, görülen eşyadan doğar. Görülmemiş eşya sorulamaz. (DIY-04, DIY-08)
5. **Susmak cevaptır.** Kişi bir soruya cevap vermeyebilir; susma kayda geçer ve kendi başına bir işarettir. Muhafız da susabilir; sabrı tükenen gelen konuşmaya kendisi devam eder ya da gider. (DIY-06, ZAR-03)
6. **Beyan defteri ve yüzleşme.** Gelenin söyledikleri beyan defterine yazılır. Muhafız iki kaydı ya da bir kayıtla bir kanıtı eşleştirip yüzleşmeye götürür; yalan böyle ortaya çıkar. Muhafız da kendi beyanını verir ve sözünü keser. (DIY-06, DIY-07, DIY-18)
7. **İç ses yoktur; sezgi ve eşin yorumu vardır.** Muhafızın iç dünyası tek satırlık sezgiyle (zarsız pasif kontrol) ve akşam eşinin günün kararları üzerine yorumuyla anlatılır. Cümleler kısadır; dönem diline uygundur. (ZAR-06, DIY-15)
