# Üretim planı — kapı oyunu (Kösedağ sonrası uç, 1243)

*Derlendi: 4 Ekim 2026. Kaynaklardan derlenmiş bir özet belgedir; yeni karar içermez.*

> **Önce bir dürüstlük notu.** Bu proje için baştan yazılmış tek bir "plan dosyası" yoktu.
> 3D modelleri, yerleşimi, hikâyeyi ve diyalogları üretirken aşağıdaki **dağınık kaynaklardan**
> çalıştım. Bu belge o kaynakları tek yerde topluyor, her kararın **nereden geldiğini** ve
> **neden öyle yapıldığını** gösteriyor. Çelişki olursa sağdaki sütundaki asıl dosya geçerlidir.

| Konu | Asıl kaynak (geçerli olan) |
|---|---|
| Hikâye kilidi (dönem, oyuncu, düşman, perdeler) | `design/gdd/kapi-konsept.md` (Ahmet kilidi) |
| Oyun konsepti, sütunlar, anti-sütunlar | `design/gdd/game-concept.md` |
| Görsel kurallar (palet, ışık, çevresel anlatım) | `design/art/art-bible.md` |
| Adlı karakterler ve dönüş kuralları | `design/gdd/karakter-kadrosu.md` |
| 3D modellerin listesi, sırası ve istemleri | `tools/model/meshy_uret.py` → `VARLIKLAR` tablosu |
| 3D yerleşim (kim nerede durur) | `src/dunya/kapi_sahnesi.gd`, `src/dunya/koy_sahnesi.gd`, `src/dunya/dunya3b.gd` |
| Tüm diyalog, olay, son metinleri ve sayılar | `tools/icerik/icerik_uret.py` → `data/` |
| Sesler | `tools/ses/ses_uret.py` → `assets/ses/` |
| 2D sanat istemleri | `tools/art/istemler.md` |

Tüm diyalogların, 24 gece olayının ve sonların tam metni: **[EK-A-diyaloglar-olaylar-sonlar.md](EK-A-diyaloglar-olaylar-sonlar.md)**.
Oyunda henüz olmayan ve üretilmesi gerekenler: **[../eksikler/](../eksikler/README.md)**.

---

## 1. Hikâye ve senaryo

### 1.1 Tek cümle
Kösedağ'dan (1243) sonra, Moğol baskınından kaçanların sığındığı ıssız bir uçta kapıyı tutan
**kervan muhafızısın**. Gelenle önce konuşursun, sonra karar verirsin. İçeri aldıkların sıfırdan
bir köy kurar. Köy oturunca **ağa** olursun; kapı sade bir süzgece döner ve köyü **Tekfur'a** karşı savunursun.

### 1.2 Neden 1243 Kösedağ?
- Kilit dönemi böyle koydu: "Kösedağ sonrası uç. Fetret ve Malazgirt bu oyuna girmez."
- Kösedağ, Selçuklu ordusunun Moğollara yenildiği savaştır. Ardından Anadolu'da **kaçan insan dalgası**
  olur: dağılmış askerler (Miraen, Aydoğdu), yanmış şehirlerin esnafı (Karaca Usta, Ayşe Bacı),
  köylüler (Saruca Hatun, Yusuf), kâtipler (Hasan Çelebi), Moğol tarafından kaçanlar (Nogay).
  Kapıya gelen herkesin bir "neden kaçtım" hikâyesi bu yüzden doğal.
- Batıda Bizans tekfurları, uçta Türkmen beyleri, Ahi teşkilatı ve bacılar aynı döneme denk gelir;
  bu da üç topluluğu (yerli Türkmen, yabancı sığınmacı, Tekfur) ve iki yapıyı (pazar, kervansaray) verir.

### 1.3 Perde yapısı
| Bölüm | Ne olur | Sayılar (`data/ayarlar/oyun.tres`) |
|---|---|---|
| **Birinci perde** | Her gece kapıya 3 kişi gelir. Sohbet (en çok 2 soru) → karar (kabul / ret / rüşvet al / kışlaya yaz). Gece sonunda köy ekranı ve bir gece olayı. | `gece_basina_gelen=3`, `azami_soru=2`, `olay_olasiligi=0.75` |
| **Perde geçişi** | Köy nüfusu 18'e varınca "Köy oturdu." Oyuncu ağa olur. | `oturma_esigi=18` (kilitteki "50 gün" yalnız örnekti) |
| **İkinci perde** | Kapıya gece 2 kişi gelir. Tekfur'un adamları her gece saldırır; güç gecelerle artar. Savunma = asker + sur. | `perde2_gece_basina_gelen=2`, `perde2_hedef_gece=12` |
| **Sonlar** | 4 kırılma sonu (her bar ayrı) + ikinci perdenin sonunda köyün durumuna göre 5 son. | bkz. 1.6 |

### 1.4 Dört bar — kimi temsil eder
**Halk · Soylular · Tüccarlar · Ordu.** Her karar bunlardan bazılarını oynatır. 0'a düşen bar oyunu bitirir,
muhafız yetmezse 3 rüşvet kesesi bir kez kurtarır. (Bar adları kilitte "onaylanmadı" diye geçer, hâlâ açık.)

### 1.5 Karakter kadrosu — neden bu 10 kişi?
Kilit: "Miraen, Sorhan ve Thessra özel olabilir… yanlarına yedi sekiz özgün karakter daha gelecek.
Biri bir orana göre döner, biri hiç dönmez, biri birden fazla gelir." Her karakter bu üç dönüş kuralından
birini taşıyacak, her biri ayrı bir **topluluğu ve kaçış nedenini** temsil edecek şekilde seçildi.

| Karakter | Kim | Sınıf | Dönüş kuralı | Neden var (anlatıdaki işlevi) |
|---|---|---|---|---|
| **Miraen** | Gürcü eski süvari, atsız, kını kırık | asker | hiç dönmez | Bozgunun yüzü; "kaçak asker" ikilemi (Selçuklu çavuşu onu arar) |
| **Sorhan** | Kıpçak at tüccarı, atlar damgalı | esnaf | birden çok gelir (3) | Her gelişte daha az şeyi olan adam: atlar → aile → yalnız. Reddin bedelini gösterir |
| **Thessra** | Trabzonlu Rum hekim kızı, ilaç kutusu | esnaf | oranla döner | Faydalı ama tehlikeli (afyon/eksik şişe); salgında kurtarıcı |
| **Karaca Usta** | Kayserili Ahi tabak ustası | esnaf | oranla döner | "Ahi esnafın yüzü" kilidini taşır; Ahi ocağı → Ahi kasabası sonu |
| **Aydoğdu** | Türkmen okçu, kolu sargılı | asker | hiç dönmez | Arkasından obası gelir: tek karar 20 kişiyi etkiler |
| **Saruca Hatun** | Sivaslı dul çiftçi kadın | çiftçi | birden çok gelir (2) | Tohum: "ye mi, ek mi?" — kısa vade/uzun vade takası |
| **Ayşe Bacı** | Kayserili dokumacı, Bacıyan-ı Rum | esnaf | oranla döner | Kadın esnafın yüzü; tezgâh/kilim olayı |
| **Hasan Çelebi** | Sivas divanı kâtibi, defterler | esnaf | hiç dönmez | Düzen ile korku arasındaki takas (defter = vergi) |
| **Nogay** | Moğol beyinin dilmacı, kaçak | asker | birden çok gelir (2) | "Düşmanın adamı" mı uyarıcı mı? Moğol öncüsü işaretleri |
| **Yusuf** | 12 yaşında çoban oğlan, ipi var keçisi yok | çiftçi | oranla döner | En saf yüz; kışlaya yazmak Halk'ı en çok yaralar |

Adsız figürler (çiftçi, esnaf, asker) şablondan gelir; ad havuzu ve ikişer giriş çeşidi vardır (Ek A2).

### 1.6 Sonlar
| Son | Koşul (özet, `src/sistemler/oturum.gd`) |
|---|---|
| Halk / Soylular / Tüccarlar / Ordu kırıldı | İlgili bar 0 ve rüşvet kesesi yok |
| **Ertuğrul'un obasına katıldın** | `ertugrul` bayrağı + Ordu ≥ 6 |
| **Ahi kasabası** | `ahi_ocagi` bayrağı + pazar ≥ 2 |
| **Tekfur'un haraççısı** | `harac` bayrağı |
| **Beyin uç köyü** | `bey_dostu` bayrağı + Soylular ≥ 7 |
| **Uç tutundu** | İkinci perdeyi hiçbiri olmadan bitirmek |

Kilit "Osmanoğullarına katılmak sonlardan biridir" diyor; 1243'te Osman Bey henüz doğmadığı için bu son
**Ertuğrul / Söğüt** üzerinden kuruldu (derviş olayı batıdan, Söğüt'ten haber getirir). Anakronizm sorusu
hâlâ açık (bkz. `production/session-state/active.md` "Osmanoğulları anakronizmi").

### 1.7 Diyalog yazım kuralları (neden böyle yazıldı)
- **Konuşma gündelik Türkçe, kısa.** Anlatı (italik giriş cümlesi) ile konuşma ayrıdır (kilit).
- **Kimse seçeneğin sonucunu söylemez** (Sütun 2). Cevaplar ipucu verir, hüküm vermez:
  "Bu atlar senin mi?" — "Şimdi benim."
- **Her geri dönüş bir şey eksiltir** (Sütun 1, "her kapı bir bedel"): Sorhan'ın atı, Karaca'nın çırağı,
  Ayşe'nin tezgâh ayağı, Yusuf'un kilosu. Reddettiğin kişi geri geldiğinde bedeli görürsün.
- **Sonuç sonradan gelir:** Kapıdaki kararın asıl bedeli gece olayında ödenir (Miraen'i arayan çavuş,
  Thessra'nın eksik şişesi, Aydoğdu'nun obası). Sütun 4: "köy senin aynan".

---

## 2. 3D varlıklar — sıra, neden ve nasıl

### 2.1 Karar
4 Ekim 2026'da oyun 2D'den 3D'ye geçti (kullanıcı kararı, `game-concept.md` → Technical Considerations).
Modeller **Meshy AI** ile metinden üretildi (`tools/model/meshy_uret.py`, model `meshy-6-lite`).
Arayüz 2D kaldı. Sanat kitabının paleti, gece-meşale ışığı ve "iyi/kötü işareti yok" kuralı 3D'de de geçerli.

### 2.2 Ortak stil istemi (her modelin başına eklenir)
> Stylized low-poly game asset for a 13th-century Anatolian frontier setting (year 1243, Seljuk borderland).
> Simple clean shapes, readable silhouette, hand-made rustic materials, muted colours. No text, no modern items.

Karakterlere ek olarak: A-pozu, yorgun sığınmacı görünüşü, yün başlık/keçe külah, keten tunik, kuşaklı kaftan,
deri kemer, dolak, deri çarık; **zırh plakası ve boynuzlu miğfer yok** (sanat kitabı 5.2).

### 2.3 Üretim sırası ve gerekçesi
Sıra `VARLIKLAR` tablosunun sırasıdır; ilk commit ("add generated character models so far") karakterlerin önce geldiğini doğrular.

| Sıra | Grup | Modeller | Neden bu sırada |
|---|---|---|---|
| 1 | **Sınıf karakterleri** | asker, esnaf, çiftçi, çiftçi kadın | Her gece kapıya gelen adsız figürler ve köy kalabalığının tamamı bu 4 modelle çalışır. Bunlar olmadan oyun hiç oynanmaz. |
| 2 | **Adlı karakterler** | miraen, sorhan, thessra, karaca_usta, aydogdu, saruca_hatun, ayse_baci, hasan_celebi, nogay, yusuf | Sütun 2 "yüz konuşur": kapı sahnesinin kahramanı gelen kişidir. Model yoksa sınıf modeline düşer (`Dunya3B.karakter_adi`), oyun bozulmaz. |
| 3 | **Yapılar** | kapı, kervansaray, pazar tezgâhı, ev, çadır | Köy ekranı. Kilit: "Bina yalnız kervansaray ve pazar"; ev/çadır nüfusu gösterir (çadır = Türkmen obası). |
| 4 | **Nesneler** | meşale, kazık çit, kuyu, araba (kağnı), çuval yığını, ağaç (çıplak ceviz), kaya | Ucuz (dokusuz). Ortamı "ıssız uç" yapar, meşale tek sıcak ışık kaynağıdır. |

### 2.4 Kredi tasarrufu kuralları (neden bazı modeller dokusuz)
| Adım | Kredi | Kimde |
|---|---|---|
| Önizleme (şekil) | 5 | herkes |
| Doku (refine) | 10 | karakterler + yapılar |
| İskelet + yürüme animasyonu | 5 | yalnız karakterler |

Nesneler dokusuz gelir ve oyunda **sanat kitabı paletinden düz renkle** boyanır (`Dunya3B.NESNE_RENK`):
ahşap `#3D2E24`, soğuk mavi `#4A6B8A`, derin mavi `#24364A`. Bu hem krediyi korur hem "düz renk, gradyan yok" kuralına uyar.
Repoya karakterlerin yalnız `*_yuru.glb` (iskelet + yürüme) dosyası girer; ham ve iskelet kopyaları `.gitignore`'da.

### 2.5 Poligon ve boy hedefleri
Karakterler 8000 üçgen (Yusuf 6000), boylar gerçekçi: Yusuf 1.35 m, kadınlar 1.60–1.62 m, erkekler 1.70–1.80 m
(Miraen en uzun, 1.80 m — süvari). Yapılar 3000–8000, nesneler 600–2500.

---

## 3. Yerleşim — neyi nereye koydum, neden

Birimler metre; −Z yolun uzağı, +Z kameranın arkası.

### 3.1 Kapı sahnesi (`src/dunya/kapi_sahnesi.gd`)
**Fikir:** Oyuncu kapıdaki muhafızın **gözünden** bakar (sanat kitabı: muhafız hiç görünmez). Sahne açık bir kapı,
tek meşale, yola uzanan kuyruk.

| Öğe | Konum | Neden |
|---|---|---|
| **Kamera** | (0, 1.62, 1.2), FOV 52°, kapının önüne bakar | 1.62 m göz hizası = birinci şahıs muhafız. Karar anında FOV sert adımlarla daralır (kadraj daralır, gerilim). |
| **Kapı** (iki direk + lento + içe açık iki kanat) | z = −1.4 | Kapı kanatları 72° içe açık: "kapı açık, karar senin" hissi. |
| **Kazık duvar** | Kapının iki yanında 6'şar parça | Ucu hissi; parça genişliği modelden ölçülür ki kapı boşluğu kapanmasın. |
| **Ana meşale** | (−1.75, 0, −1.6), güçlü | Sütun 3: tek sıcak kaynak. Gelenin yüzünü yandan aydınlatır. |
| **Uzak meşale** | (3.5, 0, −14), zayıf | Kuyruğu karanlıkta seçilir kılar; "yolda yine birileri var". |
| **Gelen kişi** | (0.6, 0, −12.5)'ten yürür → (0, 0, −3)'te durur, kameraya döner | Sohbet mesafesi; yüz okunur, beden tam kadraj. |
| **Kabul edilen** | Sağdan kameranın yanından (1.9, 0, 2.5) içeri | Oyuncu, içeri aldığının yanından geçtiğini hisseder. |
| **Reddedilen** | Yoldan geri (−0.8, 0, −22) | Sırtını dönüp karanlığa yürür; bedel görünür. |
| **Kuyruk** | 5 figür (çiftçi, esnaf, çiftçi kadın, asker, çiftçi), z −16…−25, kapıya bakar | Gece bitmiyor; bekleyenler var. Sınıfların karışık olması kalabalığı okunur kılar. |
| **Kağnı** (−3.6, −6.5) ve **çuval yığını** (3.0, −4.0) | Kapının hemen dışı | Kilit: "insan **ve mal** kapıdan geçer." |
| **Çıplak ceviz ağaçları, kayalar** | Yolun iki yanı, uzak | Issız uç; yaprak yok = soğuk, yorgun gece. |
| **Uzak tepeler** | z −60, derin mavi düz kutular | Ufuk; Tekfur'un geleceği dağlar. |
| **Yol** | 4.5 m genişlik, 60 m, ahşap–mavi karışımı | Bakışı kapıdan uzağa çeker. |

### 3.2 Köy sahnesi (`src/dunya/koy_sahnesi.gd`)
**Fikir:** Sanat kitabı 6.5 — köy **yeni bina türüyle değil, insan ve meşaleyle** büyür; her şey bir kabul kararının izidir.
Kamera köyün üstünde yavaşça döner (7.5 m yükseklik, 17 m yarıçap).

| Öğe | Konum / kural | Neden |
|---|---|---|
| **Kapı modeli** | (0, 0, −19), arkası köye dönük | Köyün kuzeyinde; yeni gelenler oradan yürüyerek girer — oyuncu kararını köyde görür. |
| **Kuyu** | (1.5, 0, 1.0), merkez | Köyün kalbi; evler onun çevresine dizilir. |
| **Evler / çadırlar** | Kuyunun çevresinde 2 halka (r = 9 m ve 14.5 m), 30°'den başlayıp 50° arayla; **kuzey yolu boş** | Kapıdan gelen yol açık kalsın. Her 3. yapı çadır = Türkmen obası. Sayı = 1 + nüfus/3 (en çok 14). |
| **Meşaleler** | Ev sayısı kadar, evlerin 0.82 yarıçapında | Asıl büyüme ölçüsü meşale sayısıdır (sanat kitabı 6.5-1). Palet ısınmaz, sıcak leke sayısı artar. |
| **Kervansaray** | Batı (−8.5, 0, −6.5), 25° dönük; seviyeyle büyür | Kervan yolu tarafı; büyüme = aynı yapının büyümesi, yeni bina türü değil. |
| **Pazar tezgâhları** | Doğu (6.5…, −5.5…), seviye başına 2 tezgâh | Esnafın izi pazarda toplanır (6.4-2). |
| **Çuval, kağnı** | Köy kenarı | Çiftçinin izi pazar ve kervansaray **dışında** (kilit: çiftçi pazara yazmaz). |
| **Köylüler** | Ev konumlarının 0.7'si + küçük kayma, en çok 32 figür, kuyuya bakar | Kalabalık nüfusla artar; sınıf dağılımı köyün gerçek bileşimini gösterir. |
| **Bu gece girenler** | Kapıdan sırayla (0.9 s arayla) yürüyüp yerlerine gider | Sütun 4: "köy senin aynan" — kararının sonucunu o gece görürsün. |
| **Sur** (2. perde) | r = 20 m çember, 34 kazık parçası, kapı önünde boşluk; boy sur seviyesiyle artar | Savunmanın görünüşü. |
| **Tekfur'un adamları** (2. perde) | Kuzeyde, 60 m'den 35 m'ye yaklaşır; sayı 4 + gece (en çok 16); **derin mavi düz siluet** | Sanat kitabı: Tekfur tarafında ayrıntı yok, yalnız siluet. Her gece biraz daha yakın = gerilim. |

### 3.3 Işık ve ortam (`src/dunya/dunya3b.gd`)
- Arka plan gece `#0D0F14`, ortam ışığı soğuk mavi `#4A6B8A` (0.32), ay ışığı soğuk mavi yönlü ışık, sis.
- **Tek sıcak ışık meşaledir** `#C4843A`; titremesi yumuşak değil, sert adımlı (sanat kitabı 7.7).
- Ton eşleme filmik; gün ışığına hiç geçilmez (6.5 yasak listesi).

---

## 4. Ses planı (mevcut)
Hepsi `tools/ses/ses_uret.py` ile **koddan sentezlenmiş yer tutucu**dur; aynı adla gerçek ses konunca oyun onu kullanır.

| Dosya | Nerede çalar |
|---|---|
| `muzik_gece_dongu` (75 s, ney/Hicaz havası) | Sürekli gece müziği |
| `ortam_mesale_dongu` (20 s) | Meşale çıtırtısı ortamı |
| `sfx_adim` | Gelen kişi yürürken |
| `sfx_kapi_acilir` / `sfx_kapi_kapanir` | Kabul / ret |
| `sfx_kese` | Rüşvet, kese doldurma |
| `sfx_bar_catlak` / `sfx_bar_kirildi` | Bar düşerken / kırılınca (renk körlüğü için zorunlu yedek sinyal) |
| `sfx_secim` / `sfx_onay` | Arayüz odak / onay |
| `sfx_gece_bitti` | Gece sonu |
| `sfx_insaat` | Yapı kurulunca |
| `sfx_olay` | Gece olayı açılınca |
| `sfx_saldiri` | 2. perdede gece saldırısı |

---

## 5. Kanıt
Oyunun 3D hâlinin ekran görüntüleri: `production/qa/evidence/3d-1/` (menü, sohbet, karar, olay, köy).
