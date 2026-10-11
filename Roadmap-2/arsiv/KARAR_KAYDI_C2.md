# Karar kaydı — C_2 (Bölüm 22, 23, 25a)

Kapsam: yalnız `C_2.md`. Başlangıç kimlik sayısı 168. Satır sayısı 168 olmalıdır. Numara yeniden sıralanmaz.

Aynı dosyada hedefi olan TAŞI maddesi silindi ve ek şart ana kabule yazıldı. Başka dosyada hedefi olan madde silinmedi; cümle `TASIMA_LISTESI_C2.md` içindedir.

| Kimlik | Karar | Hedef | Gerekçe |
|---|---|---|---|
| YSM-01 | TUT | | Kişi başı açlık sayacı, üç değerin kartta görünmesi kodda yok; `koylu.gd` yalnız `ac` bayrağı ve moral sayısı tutuyor. |
| YSM-04 | SİL | YSM-01 | Açlığın kişi başı olması ve ortalama çubuğun açılmaması YSM-01 gövdesinde. |
| YSM-05 | SİL | YSM-01 | Yorgunluğun UZM-14 kaydı olması ve uykunun aynı alanı düşürmesi YSM-01 gövdesinde. |
| YSM-06 | TAŞI | YSM-01 | Kişi moralinin köy barına yazılmaması YSM-01 kabulüne ek şart oldu. |
| YSM-07 | SİL | YSM-01 | 0–100 dayatması açlığın gece sayısı olmasıyla çelişir; moral kırpması `is_memnuniyeti.gd` satır 45'te duruyor. |
| YSM-08 | SİL | | `baslangic_sadakat` ve `baslangic_moral` zaten `src/veri/koy_ayarlari.gd` satır 64–65'te export. |
| YSM-10 | SİL | YSM-01 | Eşin aynı üç alanı kullanması YSM-01 uç durumunda duruyordu. |
| YSM-02 | TUT | | Üç açlık kademesi kodda yok; `uretim.gd` yalnız `k.ac` iken tek `aclik_verim` çarpıyor. |
| YSM-12 | SİL | YSM-02 | Tok, aç ve bitkin üçlüsü YSM-02 kademelerinin kendisi. |
| YSM-13 | SİL | YSM-02 | Eşiğin dosyada durması YSM-02 kural 1. |
| YSM-14 | SİL | YSM-02 | Tek çarpan YSM-02 kural 2; `uretim.gd` satır 10 zaten bir `aclik_verim` okuyor. |
| YSM-15 | SİL | YSM-02 | Üçüncü gün iş satırı yazılmaması YSM-02 kabulünde. |
| YSM-16 | TAŞI | YSM-02 | Açlığın yeni ölüm türü açmaması YSM-02 kabulüne ek şart oldu. |
| YSM-17 | TAŞI | YSM-02 | Tok kişide dosyadan bir kez iyileşme YSM-02 kabulüne ek şart oldu. |
| YSM-18 | TAŞI | YSM-02 | İyileşmenin günde bir kez yazılması aynı ek şartın içinde. |
| YSM-19 | TAŞI | YSM-02 | Kartta tok, aç, bitkin kelimesi YSM-02 kabulüne ek şart oldu. |
| YSM-03 | TUT | | Yatak ve açıkta uyku düşüşü kodda yok; `nobet_yorgunlugu.gd` yalnız son nöbet gecesini tutuyor. |
| YSM-22 | SİL | YSM-03 | Gündüz dinlenmenin üretimi kesen ayrı iş olması, dinlenmenin yalnız gece uykusu olmasıyla çelişir. |
| YSM-23 | SİL | YSM-03 | Gece vardiyasının o gece uyumaması YSM-03 gövdesinde. |
| YSM-24 | SİL | YSM-01 | Oyuncu açlık alanının olmaması YSM-01 ek şartında; nöbet yorgunluğu `nobet_yorgunlugu.gd` içinde. |
| YSM-26 | TAŞI | YSM-03 | Yeni uyku ses dosyası eklenmemesi YSM-03 kabulüne ek şart oldu. |
| YSM-27 | TAŞI | YSM-03 | Kayıtta uyku alanı yoksa kişinin dinlenmiş sayılmaması YSM-03 kabulüne ek şart oldu. |
| YSM-28 | SİL | YSM-01 | Erzak payının EKO-09 olması YSM-01 gövdesinde. |
| YSM-29 | SİL | | Soğuk hasarı `src/dunya/donma_yoneticisi.gd` içinde; MEV-02 duruyor. |
| YSM-30 | SİL | | Odun eşiği tutunca `donma_yoneticisi.gd` `risk()` boş dizi döndürüyor. |
| YSM-31 | TAŞI | YSM-02 | Aç kademesinde moral düşüşünün dosyadan okunması YSM-02 kabulüne ek şart oldu. |
| YSM-32 | TAŞI | YSM-01 | Moral 0 iken kaçış açılmaması YSM-01 kabulüne ek şart oldu. |
| YSM-34 | TAŞI | YSM-02 | Aynı gece iki iyileşmeden büyük olanın kalması YSM-02 kabulüne ek şart oldu. |
| YSM-35 | SİL | YSM-02 | Hastalık riskinin KRI'ye yazılması ve yeni salgın açılmaması YSM-02 kural 3. |
| YSM-36 | SİL | YSM-01 | Kartta üç değer YSM-01 kabulünde. |
| YSM-37 | TAŞI | TEK-03 | Hedef `ROADMAP_2_BOLUM_41.md`; madde duruyor. |
| YSM-38 | TAŞI | ARY-02 | Hedef `ROADMAP_2_A.md`; eklenecek cümle yok, madde duruyor. |
| YSM-39 | SİL | YSM-02 | Sayı yerine kelime YSM-02 ek şartında. |
| YSM-40 | TAŞI | YSM-01 | Köy HUD'unda kişi barı açılmaması YSM-01 kabulüne ek şart oldu. |
| YSM-41 | TAŞI | SYS-09 | Hedef `ROADMAP.md`; eklenecek cümle yok, madde duruyor. |
| YSM-42 | TAŞI | TEK-22 | Hedef `ROADMAP_2_BOLUM_41.md`; eklenecek cümle yok, madde duruyor. |
| YSM-44 | TAŞI | YSM-01 | Değerlerin kişi kaydında durması YSM-01 kabulüne ek şart oldu. |
| YSM-45 | TAŞI | YSM-01 | Yüklemenin aynı gece düşüşünü tekrarlamaması YSM-01 kabulüne ek şart oldu. |
| YSM-46 | SİL | YSM-01 | Eski kaydın orta değer sayılması, açlığın 0'dan başlamasıyla çelişir. |
| YSM-47 | TAŞI | YSM-01 | Aynı tohumda aynı düşüş YSM-01 kabulüne ek şart oldu. |
| YSM-51 | TAŞI | DEN-05 | Hedef `ROADMAP_2_BOLUM_32.md`; madde duruyor. |
| YSM-52 | SİL | YSM-02 | Çarpanların tek kaynakta birleşmesi YSM-02 kural 2. |
| YSM-53 | SİL | | `carpan_alt` 0.4 zaten `koy_ayarlari.gd` satır 80'de; `uretim.gd` tabana kırpıyor. |
| YSM-54 | SİL | | Usta çarpanı `uretim.gd` satır 20'de flag sözlüğünden okunuyor. |
| YSM-55 | SİL | YSM-02 | Bitkinin taban üretim vermesi, evde yatıp iş satırı yazmamasıyla çelişir. |
| YSM-56 | SİL | YSM-03 | Gündüz dinlenen kişiye ayrı çarpan, gövdedeki gece uykusu kuralıyla çelişir. |
| YSM-57 | SİL | | Grevci ağır işi `meslek_grevi.gd` `aktif()` ile reddediyor. |
| YSM-58 | SİL | YSM-02 | Duran çarpanlar koy ayarında; yeni kademe dosyası YSM-02 kural 1. |
| YSM-59 | SİL | YSM-02 | Oyuncunun çarpan yerine kelime görmesi YSM-02 ek şartında. |
| YSM-60 | TAŞI | DIY-09 | Hedef `ROADMAP_2_B.md`; madde duruyor. |
| YSM-62 | TAŞI | DIY-13 | Hedef `ROADMAP_2_B.md`; eklenecek cümle yok, madde duruyor. |
| YSM-63 | TAŞI | SAB-01 | Hedef `ROADMAP_2_BOLUM_28.md`; madde duruyor. |
| YSM-66 | TAŞI | ZAR-04 | Hedef `ROADMAP_2_B.md`; madde duruyor. |
| YSM-67 | TAŞI | UZM-08 | Hedef `ROADMAP.md`; eklenecek cümle yok, madde duruyor. |
| YSM-69 | TAŞI | YSM-01 | Dört köy barının durması YSM-01 kabulüne ek şart oldu. |
| YSM-74 | SİL | YSM-01 | Oyuncu açlık alanının olmaması YSM-01 ek şartında. |
| YSM-76 | SİL | YSM-01 | Halk, ordu, soylu ve tüccar barının kişi değerine çevrilmemesi YSM-69 ile aynı ek şart. |
| YSM-77 | TAŞI | YSM-01 | Tek kişinin bar kırmaması YSM-01 kabulüne ek şart oldu. |
| YSM-79 | TAŞI | YSM-01 | Olay kartının açlık sayacına yazmaması YSM-01 kabulüne ek şart oldu. |
| YSM-80 | TAŞI | CAS-07 | Hedef `ROADMAP.md`; eklenecek cümle yok, madde duruyor. |
| YSM-82 | TAŞI | YSM-01 | Kapı kabulünün açlığı o anda değiştirmemesi YSM-01 kabulüne ek şart oldu. |
| YSM-83 | SİL | YSM-01 | Altı iddialı kapanış YSM-01, YSM-02 ve YSM-03 kabulünü tekrarlıyor. |
| DNY-01 | TUT | | Altı olaylık çizelge dosyası yok; `data/dunya` klasörü repoda yok. |
| DNY-05 | TAŞI | DNY-01 | Yılın koda gömülmemesi DNY-01 kabulüne ek şart oldu. |
| DNY-06 | TAŞI | DNY-01 | Kitapla çelişen satırın düşmemesi DNY-01 kabulüne ek şart oldu. |
| DNY-08 | TAŞI | DNY-01 | Aynı olay kimliğinin ikinci kez düşmemesi DNY-01 kabulüne ek şart oldu. |
| DNY-11 | TAŞI | DNY-01 | Eski kayıtta boş işaret listesi DNY-01 kabulüne ek şart oldu. |
| DNY-02 | TUT | | Etki öncesi iki ayrı ağız satırı yok; `haberci_agi.gd` yazılı gece raporunu karta bağlıyor. |
| DNY-13 | TAŞI | OMR-37 | Hedef `ROADMAP_2_BOLUM_34.md`; eklenecek cümle yok, madde duruyor. |
| DNY-14 | SİL | DNY-02 | İki satırın birebir aynı olmaması DNY-02 kuralında. |
| DNY-15 | TAŞI | OMR-36 | Hedef `ROADMAP_2_BOLUM_34.md`; eklenecek cümle yok, madde duruyor. |
| DNY-16 | SİL | | `haberci_anlati_paneli.gd` ve `haberci_agi.gd` duruyor; yeni panel işi değil. |
| DNY-18 | SİL | DNY-02 | Konuşacak kimse yoksa satırın sıfır olması DNY-02 kabulünde. |
| DNY-19 | TAŞI | SOY-13 | Hedef `ROADMAP_2_BOLUM_37.md`; madde duruyor. |
| DNY-03 | TUT | | Altı olayın tek kapıya yazılması `dunya_etkisi.gd` olarak yok. |
| DNY-21 | TAŞI | DNY-03 | Etkinin mevcut olay şemasına yazılması DNY-03 kabulüne ek şart oldu. |
| DNY-23 | SİL | DNY-03 | Seçimsiz susma, etki evresinin kapıya yazmasıyla çelişir. |
| DNY-24 | TAŞI | DNY-02 | Salgın haber satırının hastalığı başlatmaması DNY-02 kabulüne ek şart oldu. |
| DNY-25 | SİL | | `vergi_paneli.gd` duruyor; altı kapılık DNY-03 haritasında vergi paneli yok. |
| DNY-26 | TAŞI | DNY-03 | Etkinin bir kez yazılması DNY-03 kabulüne ek şart oldu. |
| DNY-28 | TAŞI | DEN-05 | Hedef `ROADMAP_2_BOLUM_32.md`; eklenecek cümle yok, madde duruyor. |
| DNY-04 | TUT | | Üç kararın çizelge koşuluna dönmesi kodda yok; `oba_ittifaki.gd` buğday takası, çizelge değil. |
| DNY-29 | SİL | DNY-04 | İşaretin yeni son açmaması DNY-04 kabulünde; son kümesi beş. |
| DNY-30 | TAŞI | DNY-04 | Aynı gecede en çok bir işaret DNY-04 kabulüne ek şart oldu. |
| DNY-31 | TAŞI | DNY-04 | Kabul ve ret dallarının ayrı olması DNY-04 kabulüne ek şart oldu. |
| DNY-32 | TAŞI | DIY-09 | Hedef `ROADMAP_2_B.md`; madde duruyor. |
| DNY-34 | TAŞI | DNY-02 | Kişi dalı yoksa yazılı haberde kalma DNY-02 kabulüne ek şart oldu. |
| DNY-35 | TAŞI | OMR-50 | Hedef `ROADMAP_2_BOLUM_34.md`; eklenecek cümle yok, madde duruyor. |
| DNY-36 | SİL | DNY-04 | `bekliyor` ile açılan kayıt DNY-04 kabulünde. |
| DNY-37 | SİL | DNY-01 | Moğol gününün HAR-02'den okunması DNY-01 kural 3. |
| DNY-38 | SİL | | `data/olaylar/tekfur_elcisi.tres` duruyor. |
| DNY-39 | SİL | | `data/sancak_asker_talebi.json` içinde `ilk_gece` 8 ve `aralik_gece` 12; `sancak_asker_talebi.gd` bunları okuyor. |
| DNY-40 | TAŞI | DNY-04 | İkinci ziyaret dört geceden önceyse ittifak isteğinin açılmaması DNY-04 kabulüne ek şart oldu. |
| DNY-41 | SİL | | `data/olaylar/ahi_haber.tres` duruyor. |
| DNY-43 | SİL | DNY-02 | Etki evresinin öne çekilmemesi DNY-02 gövdesinde; 1 veya 2 gece önde olma OMR-36 kopyası. |
| DNY-44 | TAŞI | SRM-07 | Hedef `ROADMAP_2_BOLUM_42.md`; eklenecek cümle yok, madde duruyor. |
| DNY-46 | TAŞI | GRV-15 | Hedef `ROADMAP_2_BOLUM_43.md`; eklenecek cümle yok, madde duruyor. |
| DNY-47 | TAŞI | TEK-22 | Hedef `ROADMAP_2_BOLUM_41.md`; eklenecek cümle yok, madde duruyor. |
| DNY-48 | SİL | | `haberci_agi.gd` `uygula` haberi listeden çıkarır, kapı kararı ve kasa yazmaz. |
| DNY-49 | TAŞI | SYS-09 | Hedef `ROADMAP.md`; eklenecek cümle yok, madde duruyor. |
| DNY-51 | TAŞI | SOY-31 | Hedef `ROADMAP_2_BOLUM_37.md`; eklenecek cümle yok, madde duruyor. |
| DNY-54 | TAŞI | DNY-01 | Mevsimin olay gününü kaydırmaması DNY-01 kabulüne ek şart oldu. |
| DNY-55 | TAŞI | DNY-02 | Boş günde yazılı haberin silinmemesi DNY-02 kabulüne ek şart oldu. |
| DNY-58 | TAŞI | YIL-01 | Hedef `ROADMAP_2_BOLUM_30.md`; eklenecek cümle yok, madde duruyor. |
| DNY-59 | TAŞI | DEN-01 | Hedef `ROADMAP_2_BOLUM_32.md`; madde duruyor. |
| DNY-60 | TAŞI | DNY-01 | Aynı tohumda aynı olay günü DNY-01 kabulüne ek şart oldu. |
| DNY-61 | TAŞI | DNY-01 | Kaydın işaret listesi olması DNY-01 kabulüne ek şart oldu. |
| DNY-62 | TAŞI | DNY-03 | Yüklemenin etkiyi tekrarlamaması DNY-03 kabulüne ek şart oldu. |
| DNY-63 | TAŞI | DNY-01 | Geçmiş gecelerin zorla işletilmemesi DNY-11 ile aynı ek şartta. |
| DNY-67 | TAŞI | DEN-05 | Hedef `ROADMAP_2_BOLUM_32.md`; eklenecek cümle yok, madde duruyor. |
| DNY-68 | TAŞI | DNY-02 | Aynı tohumda aynı haber günü DNY-02 kabulüne ek şart oldu. |
| DNY-74 | SİL | | Çalışma anında model çağrılmaması Parça C giriş ilkesinde; ayrı dünya işi değil. |
| DNY-76 | TAŞI | OZL-25 | Hedef `ROADMAP_2_BOLUM_38.md`; eklenecek cümle yok, madde duruyor. `data/olaylar` altında 34 tres duruyor. |
| DNY-77 | SİL | DNY-02 | Gazete üretilmemesi DNY-02 gövdesinde. |
| DNY-79 | TAŞI | DNY-04 | Kapı kabulünün dünya işareti sayılmaması DNY-04 kabulüne ek şart oldu. |
| DNY-80 | TAŞI | CAS-07 | Hedef `ROADMAP.md`; madde duruyor. |
| DNY-81 | TAŞI | NBT-06 | Hedef `ROADMAP_2_BOLUM_26.md`; madde duruyor. |
| DNY-84 | SİL | DNY-01 | Altı iddialı kapanış DNY-01, DNY-02, DNY-03 ve DNY-04 kabulünü tekrarlıyor. |
| SEV-01 | TUT | | Boş günde ateş veya tezgâh satırı yok; `ates_basi_rutini.gd` yalnız konumu çiziyor. |
| SEV-11 | TAŞI | ZAR-01 | Hedef `ROADMAP_2_B.md`; eklenecek cümle yok, madde duruyor. |
| SEV-12 | TAŞI | KAY-04 | Hedef `ROADMAP_2_BOLUM_31.md`; madde duruyor. |
| SEV-02 | TUT | | `son_karar` anan ateş selamı yok; ateş rutini selam dosyası okumuyor. |
| SEV-17 | SİL | SEV-02 | Ölen veya ayrılan kişinin gelmemesi SEV-02 gövdesinde. |
| SEV-18 | TAŞI | SEV-02 | Bir boş günde bir kişi SEV-02 kabulüne ek şart oldu. |
| SEV-19 | TAŞI | SEV-02 | Çocuğun yalnız çağrılmaması SEV-02 kabulüne ek şart oldu. |
| SEV-20 | TAŞI | SEV-02 | Eş sohbeti açıkken ateş selamının susması SEV-02 kabulüne ek şart oldu. |
| SEV-21 | TAŞI | DIY-02 | Hedef `ROADMAP_2_B.md`; eklenecek cümle yok, madde duruyor. |
| SEV-22 | TAŞI | SEV-02 | Yeni sahne açılmaması SEV-02 kabulüne ek şart oldu. |
| SEV-03 | TUT | | Kişisel iz yer tutucusu `kisisel_iz.gd` olarak yok. |
| SEV-25 | TAŞI | SEV-03 | Kişi başı bir iz SEV-03 kabulüne ek şart oldu. |
| SEV-27 | SİL | SEV-03 | İzin iş binasında durması SEV-03 kural 2. |
| SEV-28 | TAŞI | SEV-03 | İz dururken otomatik işçi yazılmaması SEV-03 kabulüne ek şart oldu. |
| SEV-29 | TAŞI | SEV-03 | Kartta iz kelimesi SEV-03 kabulüne ek şart oldu. |
| SEV-30 | TAŞI | SEV-03 | Kayıtta iz yoksa kişinin izsiz açılması SEV-03 kabulüne ek şart oldu. |
| SEV-04 | TUT | | Yerleşen kişinin bir kez bir cümleyle istemesi `tek_istek.gd` olarak yok. |
| SEV-32 | SİL | SEV-04 | İsteğin bir kez açılması SEV-04 kabulünde. |
| SEV-33 | TAŞI | SEV-04 | İsteğin kapı düğmesi açmaması SEV-04 kabulüne ek şart oldu. |
| SEV-34 | TAŞI | SEV-04 | Kaynak yoksa isteğin kapanması SEV-04 kabulüne ek şart oldu. |
| SEV-35 | SİL | SEV-04 | İkinci ödül, isteğin bir kez konuşulması ve ceza barı açılmamasıyla çelişen ayrı bir ödül kapısı. |
| SEV-36 | TAŞI | SEV-04 | Çocuğun istek sahibi olmaması SEV-04 kabulüne ek şart oldu. |
| SEV-38 | TAŞI | SEV-04 | Reddedilen isteğin yeni bar açmaması SEV-04 kabulüne ek şart oldu. |
| SEV-05 | TUT | | Dost çiftin verim farkı ve ateş cümlesi yok; `husumet.gd` düşman kaydı. |
| SEV-40 | TAŞI | SEV-05 | Bağın grup itibarına yazılmaması SEV-05 kabulüne ek şart oldu. |
| SEV-42 | TAŞI | SEV-05 | Bağın kartta kelime olması SEV-05 kabulüne ek şart oldu. |
| SEV-44 | TAŞI | SEV-05 | Günde bir çift SEV-05 kabulüne ek şart oldu. |
| SEV-46 | TAŞI | DIY-03 | Hedef `ROADMAP_2_B.md`; madde duruyor. |
| SEV-47 | TAŞI | SEV-05 | Kayıtta bağ yoksa çiftin bağsız açılması SEV-05 kabulüne ek şart oldu. |
| SEV-06 | TUT | | Ad sorulunca kartın dönmesi yok; `koylu_karti_verisi.gd` maske alanı taşımıyor. |
| SEV-50 | SİL | SEV-06 | Adsızın sınıf adında kalması SEV-06 gövdesinde. |
| SEV-51 | SİL | SEV-06 | Eş adının maskeye girmemesi SEV-06 gövdesinde. |
| SEV-54 | TAŞI | YER-17 | Hedef `ROADMAP_2_BOLUM_46.md`; eklenecek cümle yok, madde duruyor. |
| SEV-07 | TUT | | Cenaze adı, izin kalkması ve boş tezgâh `cenaze_yasi.gd` içinde bu bağla yok. |
| SEV-58 | SİL | SEV-07 | Törenin bilinen adı söylemesi SEV-07 kural 2. |
| SEV-60 | SİL | SEV-07 | Eş yasının ACL-02'de kalması SEV-07 uç durumunda. |
| SEV-61 | SİL | SEV-07 | Adsız vedanın izsiz satır olması SEV-07 uç durumunda. |
| SEV-62 | TAŞI | SEV-07 | Yeni mezar modeli eklenmemesi SEV-07 kabulüne ek şart oldu. |
| SEV-64 | TAŞI | SEV-01 | Boş günün yeni panel açmaması SEV-01 kabulüne ek şart oldu. |
| SEV-66 | SİL | SEV-04 | Kapalı istek düğmesine sebep yazmak, görev listesi düğümünün yasak olmasıyla çelişir. |
| SEV-68 | TAŞI | GRV-15 | Hedef `ROADMAP_2_BOLUM_43.md`; eklenecek cümle yok, madde duruyor. |
| SEV-69 | TAŞI | GIR-08 | Hedef `ROADMAP_2_BOLUM_45.md`; eklenecek cümle yok, madde duruyor. |
| SEV-70 | TAŞI | TEK-22 | Hedef `ROADMAP_2_BOLUM_41.md`; madde duruyor. |
| SEV-71 | TAŞI | SYS-09 | Hedef `ROADMAP.md`; eklenecek cümle yok, madde duruyor. |
| SEV-72 | SİL | SEV-03 | İz, bağ ve ad bayrağının boş açılması SEV-03, SEV-05 ve SEV-06 ek şartlarında. |
| SEV-73 | TAŞI | SEV-04 | Yüklemenin isteği tekrarlamaması SEV-04 kabulüne ek şart oldu. |
| SEV-74 | TAŞI | KAP-16 | Hedef `ROADMAP_2_A.md`; eklenecek cümle yok, madde duruyor. |
| SEV-78 | TAŞI | DEN-05 | Hedef `ROADMAP_2_BOLUM_32.md`; eklenecek cümle yok, madde duruyor. |
| SEV-79 | TAŞI | SEV-06 | Yüklemenin ad bayrağını açmaması SEV-06 kabulüne ek şart oldu. |
| SEV-87 | SİL | SEV-01 | Altı iddialı kapanış SEV-01, SEV-02, SEV-06 ve SEV-07 kabulünü tekrarlıyor. |
