# ES-GECM-01: Eşin Geçmişi, Evlilik Hikâyesi ve Gelecek Korkusu — Diyalog Taslağı

Bu taslak, oda dertleşme sahnesine (`koylu_muhabbet_es.ds` / `aksam_konulari.json`) eklenecek 3 yeni derin anlatı dalını içerir.

---

## 1. Dal: "Eski Köyün Yangını ve Göç Yolu" (Tetik: Gün >= 3, `es_guven >= 1`)

**Muhafız:** "Hatun... bazen dalıp gidiyorsun ocağın başına. Aklın yine eski topraklara mı düşüyor?"  
**Eş:** "[Derin bir iç çeker, közleri demir maşayla karıştırır] Nasıl düşmesin efendim? Rüzgâr bacada uğuldadıkça, o geceki ses gelir kulağıma. Tekfur'un atlıları vadiden indiğinde harmandaki buğday henüz toplanmamıştı. Alevler göğe vurduğunda anamın elinden tuttuğumu sanıyordum... meğer dumanı tutuyormuşum."

### Seçenek 1A (Mertçe Sahiplenme): "O günler geride kaldı; bu köyün surları da göğsüm de sana siperdir."
- **Eş Repliği:** "Bilirim yiğidim, bilirim. Zaten o göç yolunun çamurunda donup kalmadıysam, senin arkanda yürüdüğüm içindir. Çarıklarımız parçalandığında bana kendi çizmelerini vermiştin de ayakların buz tutmuştu. Lakin korkum kendimden değil... Bu sınır boyu da tekin değil. Bir gece yine at sesleriyle uyanırsak... bu defa kaçacak dağımız kalmadı."
- **Köy / İlişki Etkisi:** `es_guven +2`, `es_gecmis_yangin_bilindi = true`. Eş sonraki nöbetlerde daha metanetli durur.

### Seçenek 1B (Gerçekçi Kaygı): "Ben de o dumanı unutmuyorum. Surlara her baktığımda o alevleri görüyorum."
- **Eş Repliği:** "[Gözlerini gözlerine diker, elini elinin üstüne koyar] Unutma zaten. Unutan gafil avlanır. Ama korkuyu da yoldaş etme kendine. Kapıda dururken elin titrerse, arkandaki bu elli hane yetim kalır. Gel otur hele, omuzların taş kesilmiş."
- **Köy / İlişki Etkisi:** `es_guven +1`, `muhafiz_moral +1`. Muhafız'a gece nöbeti direnci sağlar.

---

## 2. Dal: "Yetimler ve Çocuk Korkusu" (Tetik: Dursun veya Turna kabul edildiyse ya da Gün >= 6)

**Eş:** "Bugün kapıdan aldığın o sabi... Dursun ile Turna'yı gördüm meydanda. Fırının saçak altına sığınmışlar, birbirlerinin ellerini üflüyorlardı. İçim bir tuhaf oldu efendim."  
**Muhafız:** "Neden tuhaf oldu hatunum? Pişman mısın kapıyı açtığıma?"  
**Eş:** "Hâşâ! Kapıyı açtığına değil, kendi nasibimize yanarım. Üç kış geçti şu eşikten gireli. Ocak yanar, tencere kaynar amma evde bir çocuk cıvıltısı yok. Dağ köylerinde vebadan kırılan sabileri gördükçe içim sızlar; bir yandan da derim ki: 'Rabbim bize evlat verseydi, bu ayazda, bu harami korkusunda onu nasıl saklardık?'"

### Seçenek 2A (Şefkatli Umut): "Turna ile Dursun artık bize emanettir; ocak tütüyorsa umut da tüter."
- **Eş Repliği:** "[Yüzüne hüzünlü ama aydınlık bir tebessüm yayılır] Sen böyle deyince içime bir ferahlık düşüyor. Turna'ya yarın bir yün yelek öreyim ben. Dursun'a da kilerdeki pekmezden bir tas götürürüm. Kendi kanımızdan olmasa da, aç bir sabiyi doyuran hane bereketsiz kalmaz."
- **Köy / İlişki Etkisi:** `es_yetim_analik_istegi = true`, `koy_moral +2`. Eş Turna'ya kol kanat gerer.

### Seçenek 2B (Kaderci Teselli): "Rızkı veren de sabrı veren de haktır hatun; vakti gelince bizim de ocağımız şenlenir."
- **Eş Repliği:** "Hak kelamı söyledin. Biz sabrederiz, yeter ki kapımızdan giren rızık helal olsun. El âlem 'muhafızın hanesi kurudu' diye fısıldaşır bazen çeşme başında; kulak asmam amma yürek bu, dinlemiyor."
- **Köy / İlişki Etkisi:** `es_guven +1`, `es_sabir_pekisti = true`.

---

## 3. Dal: "Muhafız'a Gece Şifası ve Destek" (Tetik: Hava ayaz/fırtına ise veya Nöbet Yorgunluğu >= 2)

**Eş:** "[Tepside dumanı tüten toprak bir maşrapa ile yaklaşır] Bırak o mızrağı köşeye, çöz kuşağını hele. Sakalın bıyığın kırağı tutmuş yine. Al şu kaynattığım aşı iç."  
**Muhafız:** "Bu ne kokusu hatun? Dağ kekliği mi kaynattın?"  
**Eş:** "Dağ kekiğidir, kurutulmuş ıhlamur çiçeğidir, bir parmak da Karaca Usta'nın getirdiği çam balındandır. Göğsündeki hırıltıyı söker atar. Gece boyu kapı aralığından giren kuzey yeli ciğerini kurutmuş senin."

### Seçenek 3A (Minnetle İçme): "Ellerin dert görmesin hatun. Bu soğukta can suyu gibi geldi."
- **Eş Repliği:** "[Kocasına sıcak yün şalını sarar] Helal olsun yiğidime. Sen orada dikilmezsen biz burada uyuyamayız. Sırtını ocağa ver, gözlerini yum biraz. Kapıya bir şey olursa ben nöbetçiyi duyarım, seni uyandırırım."
- **Köy / İlişki Etkisi:** `es_sifa_ihlamur_verildi = true`, `nobet_yorgunlugu -1` (veya zindelik buff'ı).

### Seçenek 3B (Şakayla Karışık Sitem): "Bal pahalıdır hatun; akçeyi denk tutamazsak kış ortasında aç kalırız."
- **Eş Repliği:** "[Hafifçe kaşlarını çatar, sonra gülümser] Akçe bulunur muhafız bey, can bulunmaz! Sen yatağa düşersen koca köyün kapısını o gümüş sikkeler mi tutacak? İç şunu lafı uzatma!"
- **Köy / İlişki Etkisi:** `es_sevgi +1`, `muhafiz_moral +1`.
