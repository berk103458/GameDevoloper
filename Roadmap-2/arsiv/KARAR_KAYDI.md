# Karar kaydı — katı ayıklama

Kapsam: `ROADMAP_2_A.md`, `ROADMAP_2_B.md`, `ROADMAP_2_C.md`, `ROADMAP_2_BOLUM_26.md` … `ROADMAP_2_BOLUM_30.md`. Her kimlik bir satırdır. Numara yeniden sıralanmaz.

| Kimlik | Karar | Hedef | Gerekçe |
|---|---|---|---|
| BUG-16 | TUT | | Gece kartının bina, nüfus ve yaş koşulunu okuması henüz kodda yok; `OlayVerisi.kosullar` başka anahtarlar taşıyor. |
| BUG-26 | SİL | BUG-16 | İmzasız bina adı zaten BUG-16 kabulünün tarama satırı. |
| BUG-27 | SİL | BUG-16 | Boş havuzda kart çıkmaması BUG-16 kural 2'de yazılı. |
| BUG-28 | SİL | BUG-16 | Yarım olayın ertesi gece yeniden koşula bakması BUG-16 uç durumundaydı. |
| BUG-29 | SİL | BUG-16 | Tanınmayan koşul anahtarının hata sayılması BUG-16 kural 1. |
| BUG-30 | SİL | BUG-19 | Metindeki yaşın modele uyması sıra olayı maddesinin işi, ikinci denetçi değil. |
| BUG-31 | SİL | KAP-19 | Nüfusun yaşayan hane sayılması KAP-19 kural 4'te duruyor. |
| BUG-32 | SİL | OZL-01 | İkinci olay seçicisinin yasaklanması OZL-01'in kendisi. |
| BUG-33 | TAŞI | BUG-16 | Eşiğin `.gd` içine gömülmemesi BUG-16'nın ek şartı oldu. |
| BUG-17 | TUT | | `fisilti_gazetesi.json` hâlâ sabit "ambar" kalıbı taşıyor; `{yer}` seçimi kodda yok. |
| BUG-34 | SİL | BUG-17 | `{yer}` kalıbı BUG-17'nin kendisi. |
| BUG-35 | SİL | BUG-17 | Kişi adının yer yerine yazılmaması BUG-17 uç durumundaydı. |
| BUG-36 | SİL | BUG-17 | Yanan binanın sabah seçilmemesi BUG-17 uç durumundaydı. |
| BUG-37 | SİL | BUG-17 | Uygun bina yoksa pusulanın susması BUG-17 kural 3. |
| BUG-39 | SİL | KOP-05 | Gazetenin yazarının dedikodu olması KOP-05; BUG-17 yalnız bunu hatırlatıyordu. |
| BUG-40 | SİL | | `aralik_gece` zaten `data/fisilti_gazetesi.json` içinde ve `fisilti_gazetesi.gd` satır 23'te JSON'dan okunuyor. |
| BUG-41 | SİL | SOY-45 | Ölü kaynaklı satırın basılmaması SOY-45'te ayrı iş olarak duruyor. |
| BUG-18 | TUT | | Tehdit takvimi dosyası repoda yok; pusucu ilk günlerde hâlâ gelebilir. |
| BUG-42 | SİL | BUG-18 | Sürenin ayarda durması BUG-18'in birinci kuralı. |
| BUG-43 | SİL | BUG-18 | 13. günde tehdidin sıfır olması BUG-18 kabulünün ilk iddiası. |
| BUG-44 | SİL | BUG-18 | 15. günde ağırlığın dönmesi BUG-18 kabulünün üçüncü iddiası. |
| BUG-46 | SİL | BUG-18 | Ulağın tehdit sayılmaması BUG-18 kural 4. |
| BUG-47 | SİL | BUG-18 | Heyetin listenin dışında kalması BUG-18 kural 5. |
| BUG-48 | TAŞI | BUG-18 | Debug çağrısının doğal geliş sayılmaması BUG-18 uç durumundan kabulün ek şartına alındı. |
| BUG-49 | TAŞI | BUG-18 | Eski kaydın takvimi geri sarmaması BUG-18 kabulünün ek şartı oldu. |
| BUG-19 | TUT | | Sıra olayları hâlâ sabit kişi sözcüğü kullanabiliyor; `{kisi}` bağını kuracak dosya yok. |
| BUG-50 | SİL | BUG-19 | `{kisi}` ve dört anahtar BUG-19'un kendisi. |
| BUG-51 | SİL | BUG-19 | Cinsiyet yokken "biri" demek BUG-19 kural 4. |
| BUG-52 | SİL | BUG-19 | Çocuğun yaşlı anahtarı almaması BUG-19 kabulüne ek şart olarak yazıldı. |
| BUG-54 | SİL | OZL-06 | Beş sıra dosyası ve altıncı türün yasaklanması OZL-06. |
| BUG-55 | SİL | BUG-20 | Kaynaksız yardım düğmesinin kapanması BUG-20 kabulünde duruyor. |
| BUG-20 | TUT | | "Sıra yürüsün" hâlâ yalnız bar düşürüyor; kişiye ölüm veya sakatlık işlemiyor. |
| BUG-57 | SİL | BUG-20 | Sakatın düşük sağlıkla girmesi ve terk edenin köylü olmaması BUG-20 metninde. |
| BUG-59 | SİL | BUG-21 | İkinci ocak türünün açılmaması BUG-21 kural 5. |
| BUG-60 | SİL | BUG-22 | Beş açılış sırasının kilitlenmemesi BUG-22'nin kabul testi. |
| BUG-61 | SİL | DEN-01 | Odun sıfırı ayrı sistem değil; Bölüm 32 bunu BUG-22 tablosunun satırı sayıyor. |
| BUG-62 | SİL | | `baslangic_kaynak` zaten `src/veri/koy_ayarlari.gd` içinde ve `data/ayarlar/koy.tres` dosyasından okunuyor. |
| BUG-63 | SİL | DEN-03 | Negatif stokun oyunu açmaması DEN-03'ün işi. |
| BUG-65 | TAŞI | BUG-23 | Tarlasız atamanın betik hatası yazmaması BUG-23 kabulünün ek şartı oldu. |
| BUG-21 | TUT | | Taş yatağı ve üçüncü kurtarıcı yatak kodda yok; açılış hâlâ taşa kilitlenebiliyor. |
| BUG-66 | SİL | BUG-24 | Orta tuşun kaydırması BUG-24'ün kendisi. |
| BUG-67 | TAŞI | BUG-24 | Kaydırma hızının denge dosyasında durması BUG-24 kabulüne ek şart olarak yazıldı. |
| BUG-68 | TAŞI | BUG-24 | Duraklatta dünyanın kaymaması BUG-24 kabulünde duruyor. |
| BUG-69 | SİL | BUG-24 | Harita kenarının aşılmaması BUG-24 kural 2. |
| BUG-71 | SİL | BUG-25 | Eksik kuyu modelinin yer tutucu kalması BUG-25 kural 3. |
| BUG-72 | SİL | BUG-25 | Köyde ikinci meşale sınıfının açılmaması BUG-25 metninde. |
| BUG-73 | SİL | TEK-07 | Kuyu zehrinin hekimi hasta etmemesi TEK-07'nin işi. |
| BUG-22 | TUT | | Beş açılış sırasının 20 gece kilitlenmeden geçmesi henüz duman testinde yok. |
| BUG-74 | SİL | TEK-16 | Null köylü iş yeri TST-0003 ile doğrulanmış; regresyon TEK-16 bütçesinde. |
| BUG-76 | SİL | TEK-20 | Çift gece bitişinin ikinci köy açmaması TEK-20. |
| BUG-77 | SİL | TEK-25 | Kesik kaydın menüye dönmesi TEK-25. |
| BUG-78 | SİL | | `koy_ekrani.gd` `_exit_tree` hızı zaten 1'e çekiyor. |
| BUG-79 | SİL | | `koy_ekrani.gd` `_hiz_sec` gece kilidinde 3x seçimini zaten reddediyor. |
| BUG-80 | SİL | TEK-19 | Yükleme panelinin girdiyi bırakması TEK-19. |
| BUG-81 | SİL | TEK-01 | Boş sınıf listesinin sabahı düşürmemesi TEK-01'in sayım sözleşmesi. |
| BUG-23 | TUT | | Çiftçinin tarla dikdörtgeni içinde duracağı iş noktası dosyası yok. |
| BUG-82 | SİL | KAP-45 | Karar çift tıklamasının tek etki yazması KAP-45'te duruyor. |
| BUG-83 | SİL | KAP-16 | Heybe açıkken kararın gitmemesi aynı kapı kararının yan şartı. |
| BUG-84 | SİL | DIY-04 | Aynı soru indeksinin iki kez açılmaması soru listesi maddesinin işi. |
| BUG-85 | SİL | OZL-08 | Boş kuyrukta sıra olayının başlamaması OZL-08. |
| BUG-86 | SİL | KAP-17 | Ailenin parça kabul etmemesi KAP-17. |
| BUG-87 | SİL | UZM-08 | Çocuğun işe yazılmaması UZM-08. |
| BUG-88 | SİL | KAP-16 | Bar kırılınca tek sinyal BUG-16/KAP-16 karar yolunun tekrarı. |
| BUG-89 | SİL | GIR-08 | Duraklatta kararın uygulanmaması GIR-08. |
| BUG-24 | TUT | | Köy kamerası hâlâ tekerlekle yakınlaşıyor; orta tuş kaydırması yok. |
| BUG-90 | SİL | SYS-09 | Eksik çeviri anahtarının kilitlememesi SYS-09. |
| BUG-91 | SİL | TEK-18 | Bozuk ayarın varsayılana dönmesi TEK-18. |
| BUG-94 | SİL | DEN-01 | Odun kilidinin bu bölümde yazılmaması DEN-01'in sınırı. |
| BUG-97 | SİL | TEK-16 | Betik hata bütçesinin sıfır olması TEK-16. |
| BUG-25 | TUT | | Kapı meşalesi ile kuyu tabanı hâlâ sahne ayarında bozuk duruyor. |
| BUG-98 | TAŞI | BUG-16 | Aynı tohumun aynı olayı seçmesi BUG-16 kabulünün ek şartı oldu. |
| BUG-99 | SİL | KAY-04 | Eski kaydın koşulsuz açılması KAY-04. |
| BUG-102 | SİL | | Ses dosyası üretmemek bu bölümün işi değil; ses yasağı karar kaydında zaten var. |
| BUG-104 | SİL | DEN-01 | Denge sayısının bu bölümden değişmemesi DEN-01'in işi. |
| BUG-105 | SİL | BUG-16 | Altı iddialı kapanış paketi BUG-16, BUG-17, BUG-18 ve BUG-19'un kabulünü tekrarlıyor. |
| ACL-01 | TUT | | Yeni oyunun tek ev ve kapalı kapıyla köyden açılması `ana.gd` içinde ayrı senaryo olarak yok. |
| ACL-08 | SİL | ACL-01 | Tek ev ve iki kişi ACL-01 kabulünde sayı olarak duruyor. |
| ACL-09 | SİL | HAN-49 | Eşin işe sürüklenmemesi HAN-49. |
| ACL-10 | SİL | ACL-01 | Ev içi sahnenin açılmaması ACL-01 kabulünün ek şartı oldu. |
| ACL-11 | TAŞI | ACL-01 | Boş eş kimliğinin kuruluştan türetilmesi ACL-01 kabulüne yazıldı. |
| ACL-12 | SİL | TEK-22 | Açılış hızının 1 olması TEK-22. |
| ACL-13 | SİL | ACL-01 | Menünün silinmemesi yeni oyunun yönlendirmesinin parçası, ayrı iş değil. |
| ACL-14 | SİL | ACL-01 | Açılışa yeni ses eklememek ACL-01 ek şartında. |
| ACL-02 | TUT | | Eşin meslek listesi ve kapalı düğmeleri `hane_esi.gd` olarak yok. |
| ACL-15 | SİL | ACL-02 | Meslek listesinin sınırlı olması ACL-02'nin kendisi. |
| ACL-16 | SİL | HAN-47 | Altı meslek artı kâtip sayımı HAN-47 ile aynı iş. |
| ACL-18 | SİL | HAN-52 | Eş ölünce üretimin durması HAN-52. |
| ACL-19 | TAŞI | ACL-02 | Eşin kapı kuyruğunda görünmemesi ACL-02 kabulüne yazıldı. |
| ACL-20 | SİL | SEV-06 | Eş kartının maske kuralına girmemesi SEV-06. |
| ACL-21 | SİL | HAN-49 | Eş için ikinci oynanabilir gövde HAN-49'un yasağı. |
| ACL-22 | SİL | ACL-02 | Aynı gece ikinci meslek değişiminin birikmesi ACL-02 uç durumunda. |
| ACL-03 | TUT | | Akşam sohbetinin tetik dosyası yok; DYL-07 metni de henüz bağlı değil. |
| ACL-24 | TAŞI | ACL-03 | Meclis gecesinde sohbetin susması ACL-03 kabulüne yazıldı. |
| ACL-26 | SİL | ACL-03 | Günde bir sohbet ACL-03 kural 2. |
| ACL-29 | SİL | ACL-03 | Sohbete ses eklememek ACL-03 ek şartında. |
| ACL-04 | TUT | | İlk akşam ulağı ve öğretici aile `kapi_acilis_olayi.gd` olarak yok. |
| ACL-33 | SİL | ACL-04 | İlk sorgunun ailede olması ACL-04 kural 2. |
| ACL-37 | TAŞI | ACL-04 | Ulağın köylü olmaması ACL-04 kabulüne yazıldı. |
| ACL-05 | TUT | | Yatak doluyken uyarıyı gösteren `barinak_uyarisi.gd` yok. |
| ACL-39 | SİL | ACL-01 | Açılış yatağının 4 olması ACL-01 kabulünde. |
| ACL-40 | SİL | ACL-05 | Yer yokken kabulün gizlenmemesi ACL-05 kural 2. |
| ACL-41 | SİL | KAP-18 | Açıkta kalanın silinmemesi KAP-18. |
| ACL-42 | SİL | UZM-08 | Çocuğun çalışmaması UZM-08. |
| ACL-43 | TAŞI | ACL-05 | Yatağın akçe yazmaması ACL-05 kabulüne yazıldı. |
| ACL-44 | TAŞI | ACL-05 | Kapasitenin kod sabiti olmaması ACL-05 kabulüne yazıldı. |
| ACL-45 | SİL | ACL-05 | Eşin yatak sayısına dahil olması ACL-05 kural 1. |
| ACL-06 | TUT | | Dört geçmişten birinin seçilip kayda yazılması `muhafiz_gecmisi.gd` olarak yok. |
| ACL-47 | SİL | ACL-06 | Geçmişin yalnız açılışta seçilmesi ACL-06 kural 4. |
| ACL-48 | TAŞI | ACL-06 | Geçmişin zar tabanını değiştirmemesi ACL-06 kabulüne yazıldı. |
| ACL-50 | SİL | ACL-06 | Eski kayıtta alan yoksa "seçilmedi" kalması ACL-06 metninde. |
| ACL-51 | SİL | ACL-06 | "Üç geçmiş" iddiası ACL-06'daki dört kartla çelişiyor; gövde dört kartta kalır. |
| ACL-53 | TAŞI | ACL-06 | Geçmişin eş meslek listesine girmemesi ACL-06 kabulüne yazıldı. |
| ACL-55 | SİL | HAN-02 | Sabah satırının hane döngüsünde kalması HAN-02. |
| ACL-60 | TAŞI | KAP-16 | Aynı gece çıkan kişinin kuyruğa dönmemesi KAP-16 kabulüne yazıldı. |
| ACL-61 | SİL | HAN-50 | Hanenin ayrı ekran olmaması HAN-50. |
| ACL-63 | SİL | OGR-01 | İlk saatin açılışı yeniden yazmaması OGR-01. |
| ACL-65 | SİL | BUG-18 | Tehdidin ilk saatten önce gelmemesi BUG-18. |
| ACL-67 | SİL | KAY-04 | İpucu kaydının eski kayıtta boş kalması KAY-04. |
| ACL-68 | SİL | HFZ-16 | Açılışta defterin boş olması HFZ-16. |
| ACL-69 | SİL | SOY-40 | Açılışta kamuoyunun olmaması SOY-40. |
| ACL-70 | SİL | NBT-08 | Açılışta nöbetçi uyarısının olmaması NBT-08. |
| ACL-71 | SİL | BUG-22 | Açılış stokunun ikinci tablo olmaması BUG-22. |
| ACL-72 | SİL | BUG-21 | Taş kilidinin ikinci maden olmaması BUG-21. |
| ACL-73 | SİL | HAN-10 | Eş üretiminin ambara gitmesi HAN-10. |
| ACL-74 | SİL | | Açılış akçesi zaten `data/ayarlar/koy.tres` içindeki `baslangic_kaynak` alanında. |
| ACL-75 | SİL | ACL-01 | Açılışta pazarın olmaması tek ev senaryosunun sonucu. |
| ACL-76 | SİL | ACL-01 | Açılışta surun olmaması aynı senaryonun sonucu. |
| ACL-77 | SİL | BUG-18 | İlk gece salgın olayının gelmemesi BUG-18 tehdit takvimi. |
| ACL-78 | SİL | DEN-01 | Açılış ölçüsünün denge formülünü değiştirmemesi DEN-01. |
| ACL-79 | SİL | TEK-12 | Çekirdek imzanın büyümemesi TEK-12. |
| ACL-85 | TAŞI | ACL-01 | Aynı tohumun aynı evi kurması ACL-01 kabulüne yazıldı. |
| ACL-86 | SİL | ACL-01 | Altı iddialı kapanış paketi ACL-01, ACL-02, ACL-04, ACL-05 ve ACL-06 kabulünü tekrarlıyor. |
| KAP-16 | TUT | | Gelen sayısı hâlâ `gece_basina_gelen = 3`; bar cümlesini okuyan akış dosyası yok. |
| KAP-20 | SİL | KAP-16 | Tavanın dosyada durması KAP-16 kural 1. |
| KAP-21 | SİL | KAP-16 | Kış çarpanının mevsim motorundan okunması KAP-16 kural 1. |
| KAP-22 | TAŞI | KAP-16 | Perde 2'nin kendi gelen alanını okuması KAP-16 metnine yazıldı. |
| KAP-23 | TAŞI | KAP-16 | Aynı kişinin bir gecede iki kez gelmemesi KAP-16 kabulüne yazıldı. |
| KAP-24 | TAŞI | KAP-16 | Ayrılan kimliğin kuyruğa girmemesi KAP-16 kabulüne yazıldı. |
| KAP-25 | SİL | ACL-02 | Eş ve muhafızın gelen olmaması ACL-02 ve ACL-01'de duruyor. |
| KAP-26 | SİL | KAP-16 | 28 günde dört boş gün KAP-16 kural 2. |
| KAP-27 | TAŞI | KAP-16 | Tavan dolunca fazlanın ertesi güne kalmaması KAP-16 kabulüne yazıldı. |
| KAP-17 | TUT | | Aile kafilesi ve bölme düğmesi `aile_kafilesi.gd` olarak yok. |
| KAP-28 | SİL | KAP-16 | Fırtına adaptörünün ikinci dizi tutmaması gelen akışının yan şartı; oyuncu sırayı zaten değiştiremiyor. |
| KAP-29 | SİL | KOP-02 | Heyetin kuyruk başından atlanmaması KOP-02. |
| KAP-30 | SİL | SOY-04 | Reddin tek cümle bırakması SOY-04. |
| KAP-31 | SİL | BUG-20 | Kuyruk indeksinin kaymaması BUG-20 uç durumunda. |
| KAP-32 | TAŞI | KAP-16 | Boş kuyruğun köye geçmesi KAP-16 kabulüne yazıldı. |
| KAP-33 | SİL | KAY-04 | Anlık görüntünün kuyruğu koruması KAY-04. |
| KAP-34 | SİL | TEK-20 | Çift gece başlatmanın ikinci kuyruk açmaması TEK-20. |
| KAP-35 | TAŞI | KAP-16 | Karar bitmeden kuyruğun ilerlemesi KAP-16 kabulüne yazıldı. |
| KAP-18 | TUT | | Savaş sonrası çocuk kafilesi ve emanet `yetim_bakimi.gd` olarak yok. |
| KAP-36 | SİL | DIY-05 | Soru tavanının ayardan okunması DIY-05. |
| KAP-37 | SİL | DIY-04 | Sorulan sorunun tekrar açılmaması DIY-04. |
| KAP-38 | SİL | OGR-02 | İlk gece rüşvet kilidi OGR-02. |
| KAP-39 | TUT | | Heybe açıkken soru hakkının düşmemesi kapı ekranında ayrı bir kilit; mevcut kod bunu söylemiyor. |
| KAP-40 | SİL | | `yalan_olasiligi` zaten `src/veri/oyun_ayarlari.gd` içinde ve `oturum.gd` satır 167'de okunuyor. |
| KAP-41 | SİL | | `adli_olasiligi` zaten `oturum.gd` satır 125'te `ayarlar` üzerinden okunuyor. |
| KAP-42 | SİL | | Zengin eşiği `oturum.gd` satır 134'te harç seçeneğini zaten kesiyor. |
| KAP-43 | SİL | DIY-02 | Beyan bitmeden karar çubuğunun kapalı kalması DIY-02. |
| KAP-19 | TUT | | Hane sayısına göre üç olay katmanı veri olarak bağlı değil. |
| KAP-44 | SİL | | Yedinci karar türü açmamak yeni bir iş değil; duran altı simge duruyor. |
| KAP-45 | TUT | | Çift tıklamanın gece sonunu bir kez yazması kapı düğmesinde kanıtlı değil. |
| KAP-46 | SİL | AYR | İsteğe bağlı ikinci tık ayarlar bölümünün işi. |
| KAP-47 | TAŞI | KAP-45 | Bar kırılınca tek `oturum_bitti` KAP-45 kabulüne yazıldı. |
| KAP-48 | TUT | | `rusvet_hakki` yalnız `oyun_ayarlari.gd` satır 12'de duruyor; kapı ekranı bu alanı okumuyor. |
| KAP-49 | SİL | | Harç sayıları `koy.tres` ve oturum çözümünde; kapının kendi harç sabiti yazması bu maddenin işi değil. |
| KAP-50 | SİL | | Kışla ve elkoy için yeni sınıf açmamak yeni bir sistem değil. |
| KAP-51 | SİL | SYS-09 | Karar metninin çeviri anahtarı olması SYS-09. |
| KAP-52 | SİL | KAP-17 | Parça kabulü yasaklamak KAP-17'deki bölme düğmesiyle çelişiyor; gövde bölmeyi tutar. |
| KAP-53 | SİL | KAP-18 | Çocuğun işe yazılmaması KAP-18 kabulünde. |
| KAP-55 | SİL | BUG-19 | Yaş sözcüğünün modelden gelmesi BUG-19. |
| KAP-56 | SİL | ACL-05 | Yatak uyarısının kabulü engellememesi ACL-05. |
| KAP-57 | SİL | KAP-19 | Küçük köyde çocuk olayının kapalı olması KAP-19. |
| KAP-58 | SİL | KAP-17 | Çocuk ve yaşlı modelinin tek satır olması KAP-17. |
| KAP-59 | TAŞI | KAP-17 | Reisin düşünce kafilenin dağılmaması KAP-17 kabulüne yazıldı. |
| KAP-60 | SİL | KAP-16 | Boş günde kuyruk uzunluğunun sıfır olması KAP-16'nın boş gün tanımı. |
| KAP-61 | SİL | SEV-01 | Boş günün keyfi SEV-01. |
| KAP-62 | SİL | OZL-08 | Boş günde sıra olayının olmaması OZL-08. |
| KAP-63 | SİL | KAP-16 | Gözcünün boş günü bildirmesi KAP-16 kural 2. |
| KAP-64 | SİL | BUG-18 | Tehdidin boş günü delmemesi BUG-18. |
| KAP-65 | SİL | KAY-04 | Boş gün alanının eski kayıtta yok sayılması KAY-04. |
| KAP-66 | SİL | ZAR-01 | Boş günde zar panelinin açılmaması ZAR-01. |
| KAP-67 | TAŞI | KAP-16 | Aynı tohumun aynı kuyruğu vermesi KAP-16 kabulüne yazıldı. |
| KAP-68 | SİL | GRV-06 | Konuşma kutusunun deftere binmemesi GRV-06. |
| KAP-69 | SİL | ZAR-03 | Tansiyonun konuşmayı örtmemesi ZAR-03. |
| KAP-70 | SİL | AYR | Belirme gecikmesinin ayardan gelmesi ayarlar bölümü. |
| KAP-71 | SİL | ARY-05 | Eksik portrenin düz renk olması ARY-05. |
| KAP-72 | SİL | SYS-09 | Eksik metnin kapıyı kilitlememesi SYS-09. |
| KAP-73 | SİL | | Kamera kaymasının ikinci sahne açmaması yeni bir iş değil; ofset zaten duran kapı sahnesinde. |
| KAP-74 | SİL | GIR-06 | Odağın ilk düğmede olması GIR-06. |
| KAP-75 | SİL | TEK-22 | Kapı hızının 1'de kilitli olması TEK-22. |
| KAP-76 | SİL | TEK-20 | Gece bitti sinyalinin bir kez gitmesi TEK-20. |
| KAP-77 | SİL | SYS-02 | Köye geçmeden kaydın yazılması SYS-02. |
| KAP-78 | SİL | SYS-19 | Perde kartının kapıyı atlaması SYS-19. |
| KAP-79 | SİL | SYS-20 | Kırılan barın son ekranına gitmesi SYS-20. |
| KAP-80 | SİL | KAP-16 | Raporun gece çözümünden gelmesi ikinci rapor üretmemek; ayrı madde değil. |
| KAP-81 | SİL | GIR-08 | Esc'nin kapıda karar vermeden duraklatması GIR-08. |
| KAP-82 | TAŞI | KAP-16 | Duraklatıp devam edince aynı kişinin kalması KAP-16 kabulüne yazıldı. |
| KAP-83 | SİL | AYR | Ayar kapanınca evrenin bozulmaması ayarlar bölümü. |
| KAP-84 | SİL | BUG-18 | Moğol sayacının tehdit süresinde işlemesi BUG-18. |
| KAP-85 | SİL | ACL-04 | Ulağın ilk gün tehdit sayılmaması ACL-04. |
| KAP-86 | SİL | OMR-24 | Bir gecede iki dış yüzün olmaması OMR-24. |
| KAP-87 | SİL | DIY-11 | Dönen kişinin ziyaret sayacı DIY-11. |
| KAP-88 | SİL | SRM-07 | Demo perde 2 kuyruğunun açılmaması SRM-07. |
| KAP-89 | SİL | BUG-18 | Tehdit listesinin üç sınıfı geciktirmesi BUG-18. |
| KAP-90 | SİL | DNY-02 | Dünya haberinin kuyruk yüzüyle çakışmaması DNY-02. |
| KAP-91 | SİL | MEV-01 | Kış tehdidinin mevsim çarpanını okuması MEV-01. |
| KAP-92 | TAŞI | KAP-16 | Aynı tohumun aynı kuyruğu vermesi KAP-16 kabulündeki altı gece şartı. |
| KAP-93 | SİL | TEK-12 | Çekirdek imzanın büyümemesi TEK-12. |
| KAP-94 | SİL | | `koy_sahnesi` import yasağı ortak kural; ayrı kapı maddesi değil. |
| KAP-95 | SİL | SRM-05 | Debug gelenin oyuncuda olmaması SRM-05. |
| KAP-96 | SİL | KAY-04 | Eski kaydın kuyruksuz açılması KAY-04. |
| KAP-97 | SİL | KAP-45 | Çift tıklamanın tek etki yazması KAP-45. |
| KAP-98 | SİL | ARY-05 | Yeni portre indirmemek ARY-05. |
| KAP-99 | SİL | KAP-16 | Altı iddialı kapanış paketi KAP-16, KAP-17, KAP-45 ve ACL-04 kabulünü tekrarlıyor. |
| ARY-01 | TUT | | Üç şablonun önizlemesi ve seçim belgesi repoda yok. |
| ARY-06 | SİL | ARY-01 | Seçim boşken tema klasörünün oluşmaması ARY-01 kabulünde. |
| ARY-07 | SİL | ARY-01 | Üç yer tutucu ekran ARY-01'in kendisi. |
| ARY-08 | SİL | ARY-01 | Dört düğme durumu ARY-01 kural 1. |
| ARY-09 | SİL | ARY-01 | Yeni font indirmemek ARY-01 kural 4. |
| ARY-10 | TAŞI | ARY-01 | İki şablon aynı renk çiftini kullanırsa üçüncünün ayrılması ARY-01 kabulüne yazıldı. |
| ARY-11 | TAŞI | ARY-01 | Önizlemenin ana sahne olmaması ARY-01 kabulüne yazıldı. |
| ARY-12 | SİL | ARY-01 | Seçimin iki isimle yazılması ARY-01 metninde. |
| ARY-13 | SİL | ARY-01 | Yer tutucunun düz kutu olması ARY-01 kural 4. |
| ARY-02 | TUT | | Seçilen şablonun tek tema kaynağına bağlanması `src/arayuz/tema/` olarak yok. |
| ARY-14 | SİL | ARY-02 | Panelin renk adını kaynaktan okuması ARY-02 kural 2. |
| ARY-15 | TAŞI | ARY-02 | Eksik stilin pembe basmaması ARY-02 metninde. |
| ARY-16 | SİL | ARY-02 | Puntoun `boyut()` ile gelmesi ARY-02 tarama kuralı. |
| ARY-17 | TAŞI | ARY-02 | Gövde puntosunun 26 olması ARY-02 kabulüne yazıldı. |
| ARY-18 | TAŞI | ARY-02 | Küçük puntoun 22'nin altına inmemesi ARY-02 kabulüne yazıldı. |
| ARY-20 | SİL | ARY-02 | `tema.gd` dosyasının yalnız bağlaması ARY-02 kural 1. |
| ARY-21 | SİL | ARY-02 | Kapı sahnesinin yeniden çizilmemesi ARY-02 uç durumunda. |
| ARY-03 | TUT | | Sekiz ekranın temaya taşınması ve önce/sonra görüntüsü henüz yok. |
| ARY-22 | BİRLEŞTİR | ARY-03 | Harita kabuğu sekiz ekrandan biri; ayrı madde değil. |
| ARY-23 | BİRLEŞTİR | ARY-03 | Sorgu kabuğu aynı sekiz ekran işinin parçası. |
| ARY-24 | BİRLEŞTİR | ARY-03 | Karar düğmesinin tema durumu aynı kabuk işi. |
| ARY-25 | BİRLEŞTİR | ARY-03 | Köy HUD kabuğu aynı sekiz ekran işi. |
| ARY-26 | BİRLEŞTİR | ARY-03 | Pazarın satış, fiyat ve kaydırma dosyaları ARY-03 kabulünde duruyor. |
| ARY-27 | BİRLEŞTİR | ARY-03 | Divan kabuğu aynı sekiz ekran işi. |
| ARY-28 | BİRLEŞTİR | ARY-03 | Odanın yedi paneli ARY-03 metninde. |
| ARY-29 | BİRLEŞTİR | ARY-03 | Gece raporunun ayrı sahne olmaması ARY-03 metninde. |
| ARY-04 | TUT | | Sekiz yuvası olan yükleme çerçevesi `yukleme_ekrani.gd` olarak yok. |
| ARY-31 | SİL | ARY-04 | Eksik yuvanın düz renge düşmesi ARY-04 kural 4. |
| ARY-32 | SİL | ARY-04 | Satırın kod içi tarih cümlesi olmaması ARY-04 kural 2. |
| ARY-34 | SİL | GRV-03 | Yükleme panelindeki gömülü rengin kalkması GRV-03. |
| ARY-37 | SİL | ARY-05 | Yükleme görselinin üretilmemesi envanter maddesinin yer tutucu kuralı. |
| ARY-05 | TUT | | ROADMAP 2 asset satırlarını tarayan liste henüz yok. |
| ARY-39 | SİL | GRV-26 | Ayarlar ve duraklat zemin satırları GRV-26. |
| ARY-40 | SİL | SRM-18 | İkon satırı SRM-18. |
| ARY-41 | SİL | ARY-05 | Aynı kimliğin iki satırda duramaması ARY-05 uç durumu. |
| ARY-42 | SİL | ARY-05 | Yer tutucusu olan maddenin listede aranması ARY-05 uç durumu. |
| ARY-43 | SİL | ARY-05 | Kimliksiz satırın silinmesi ARY-05 kural 3. |
| ARY-44 | SİL | ARY-05 | B ve C kimliklerinin madde yazıldıkça eklenmesi ARY-05 kural 5. |
| ARY-45 | TAŞI | ARY-05 | Envanterde wav satırı olmaması ARY-05 kabulüne yazıldı. |
| ARY-47 | SİL | GRV-16 | Kapalı düğmenin görünür kalması GRV-16. |
| ARY-48 | SİL | GRV-04 | Duraklat zemininin boş string bırakmaması GRV-04. |
| ARY-49 | SİL | GRV-02 | Ayarlar sağ boşluğunun tema ile dolması GRV-02. |
| ARY-50 | SİL | GRV-20 | Menü 3B sahnesinin durması GRV-20. |
| ARY-51 | SİL | GRV-21 | İpucu köşesinin ölçekte taşmaması GRV-21. |
| ARY-52 | SİL | GRV-15 | Uzun metnin kayması GRV-15. |
| ARY-53 | SİL | GRV-17 | Odak çerçevesinin tek anahtar olması GRV-17. |
| ARY-54 | SİL | GRV-25 | Ayarların tek pencere olması GRV-25. |
| ARY-55 | SİL | GIR-01 | Kontrol sekmesi GIR-01. |
| ARY-56 | SİL | YER-01 | Dil sekmesi YER-01. |
| ARY-57 | SİL | HFZ-01 | Defter kabuğunun kendi paletini açmaması HFZ-01. |
| ARY-58 | SİL | GRV-25 | Grafik panelinin ayar penceresine girmesi tek pencere kuralı. |
| ARY-61 | SİL | TEK-24 | Sekmenin hızı değiştirmemesi TEK-24. |
| ARY-62 | SİL | TEK-19 | Yükleme katmanının bitince kalkması TEK-19. |
| ARY-63 | SİL | GIR-08 | Duraklatın alt süreci kapatması GIR-08. |
| ARY-69 | TAŞI | ARY-02 | Mühür ve çerçevenin ham renk bırakmaması ARY-02 kabulüne yazıldı. |
| ARY-70 | TUT | | Üç genişlikte taşan metnin kayması tema ölçüsünde ayrı iş; bugün kabuk bunu söylemiyor. |
| ARY-71 | TAŞI | ARY-70 | 150 ölçekte glifin kesilmemesi ARY-70 kabulüne yazıldı. |
| ARY-72 | SİL | | `canvas_items` / `expand` zaten `project.godot` içinde; bu madde onu değiştirmiyor. |
| ARY-73 | SİL | AYR | Pencere boyu listesi ayarlar bölümünde. |
| ARY-74 | SİL | | `ekran_modu` zaten pencere ve tam ekran olarak `src/sistemler/ayarlar.gd` içinde. |
| ARY-75 | SİL | ARY-05 | Yeni imleç üretmemek envanter yasağı. |
| ARY-77 | SİL | ARY-03 | Harita düğmesinin köy şeridinde kalması sekiz ekran kabuğunun parçası. |
| ARY-78 | SİL | GRV-28 | Oynanış fonksiyonunun tema yüzünden değişmemesi GRV-28. |
| ARY-80 | SİL | ARY-05 | Ses üretilmemesi ARY-05 ek şartı. |
| ARY-81 | SİL | ARY-02 | İkinci tema sınıfının açılmaması tek kaynak kuralı. |
| ARY-82 | SİL | KAY-04 | Kaydın tema rengi gömmemesi KAY-04. |
| ARY-83 | SİL | TEK-18 | Eksik ayar anahtarının varsayılana dönmesi TEK-18. |
| ARY-85 | SİL | ARY-01 | Beş iddialı kapanış paketi ARY-01, ARY-03 ve ARY-04 kabulünü tekrarlıyor. |
| KOP-01 | TUT | | Divan sahnesi henüz Söz motoruna bağlı değil. |
| KOP-02 | TUT | | Heyetin atlanamayan konuşma dosyası yok. |
| KOP-03 | TUT | | Hastalık belirtisi bakış bölgesi olarak bağlı değil. |
| KOP-04 | TUT | | Gecikmeli etki hâlâ serbest cümle; yapılandırılmış tek kuyruk yok. |
| KOP-05 | TUT | | Fısıltı gazetesi dedikodu kaydını okumuyor, kendi kalıbını basıyor. |
| KOP-06 | TUT | | Yozlaşma skoru zar değiştiricisi ve ton olarak okunmuyor. |
| KOP-07 | TUT | | Beş sonun metni `sonlar.json` anahtarından okunmuyor. |
| KOP-08 | TUT | | Tüccarın kapı pazarlığı ayrı konu menüsü gibi duruyor. |
| KOP-09 | TUT | | Sayfasız takip kimliği hâlâ uyarı; hata değil. |
| KOP-10 | TUT | | Adlı CHR bar etkisi hâlâ sınıf şablonundan geliyor. |
| DIY-01 | TUT | | `docs/SOZ_TASARIMI.md` yok. |
| DIY-01a | TUT | | Konuşma JSON şeması ve üç örnek dosya yok. |
| DIY-19 | TAŞI | DIY-01a | Kadrosuz konuşmacının reddi DIY-01a kabulünde. |
| DIY-20 | TAŞI | DIY-01a | Çift seçenek kimliği DIY-01a kabulünde. |
| DIY-21 | TAŞI | DIY-01a | Kendine kenar DIY-01a kabulünde. |
| DIY-22 | TAŞI | DIY-01a | Derinlik tavanı DIY-01a kabulünde. |
| DIY-23 | TAŞI | DIY-02 | Etki anahtarı beyaz listesi DIY-02 metninde. |
| DIY-24 | TAŞI | DIY-02 | Boş metin anahtarının reddi DIY-02 metninde. |
| DIY-25 | TAŞI | DIY-02 | Bağlamda olmayan yer tutucunun susması DIY-02 metninde. |
| DIY-26 | TAŞI | DIY-01a | Tek giriş düğümü DIY-01a kabulünde. |
| DIY-02 | TUT | | `soz_motoru.gd` yok. |
| DIY-03 | TUT | | Selamdan önce konu listesinin kapalı olduğu konu merkezi yok. |
| DIY-27 | TAŞI | DIY-02 | Etkinin seçim başına bir kez yazılması DIY-02 kabulünde. |
| DIY-28 | TAŞI | DIY-02 | Eski kayıtta boş düğüm alanının girişten başlaması DIY-02 metninde. |
| DIY-29 | TAŞI | DIY-03 | Konu ekranında karar düğmesinin kapalı olması DIY-03 kabulünde. |
| DIY-30 | SİL | KOP-04 | Motorun ikinci kuyruk açmaması KOP-04. |
| DIY-31 | SİL | DIY-02 | Şema hatasının sahneyi sustu kapatması DIY-02. |
| DIY-32 | TAŞI | DIY-16 | Eski sıranın kapanış bayrağıyla susması DIY-16 kabulünde. |
| DIY-33 | SİL | DIY-02 | Kilit kümesinin büyümemesi DIY-02 kural 2. |
| DIY-34 | TAŞI | DIY-05 | Hız çarpanının düğümü kesmemesi DIY-05 metninde. |
| DIY-04 | TUT | | Aynı konuda üsteleme katmanı yok. |
| DIY-05 | TUT | | Soru sayısına bağlı sabır HUD'u yok. |
| DIY-35 | SİL | DIY-03 | Selamın konu listesini açmaması DIY-03. |
| DIY-36 | TAŞI | DIY-03 | Konu sırasının dosyadaki dizi olması DIY-03 metninde. |
| DIY-37 | SİL | AYR-10 | Tükenen konunun gri kalması AYR-10. |
| DIY-38 | TAŞI | DIY-03 | Merkeze dönüş kenarının zorunlu olması DIY-03 kabulünde. |
| DIY-39 | SİL | DIY-04 | Üstelemenin aynı konuda kalması DIY-04. |
| DIY-40 | TAŞI | DIY-04 | Üsteleme tavanının veride olması DIY-04 kabulünde. |
| DIY-41 | TAŞI | DIY-03 | Konu açıkken köye geçilmemesi DIY-03 metninde. |
| DIY-42 | SİL | KOP-10 | Adsızın sınıf şablonunu kullanması KOP-10. |
| DIY-06 | TUT | | Beyan defteri `beyan_defteri.gd` olarak yok. |
| DIY-07 | TUT | | Çelişki çifti `celiski.gd` olarak yok. |
| DIY-43 | SİL | DIY-05 | Sabır tavanının `azami_soru` olması DIY-05 kabulünde. |
| DIY-44 | TAŞI | DIY-18 | Karşı sorunun bir hak harcaması DIY-18 kabulünde. |
| DIY-45 | SİL | ZAR-01 | Söz kesme tansiyonunun zar tablosundan okunması ZAR-01. |
| DIY-46 | TAŞI | DIY-05 | Menü açıkken sabrın düşmemesi DIY-05 kabulünde. |
| DIY-47 | TAŞI | DIY-05 | Sıra olayının sabrı dondurması DIY-05 metninde. |
| DIY-48 | TAŞI | DIY-05 | Hak bitince vedanın açılması DIY-05 metninde. |
| DIY-49 | SİL | DIY-05 | Belirme hızının hak sayısını değiştirmemesi DIY-05 kural 2. |
| DIY-50 | SİL | KAP-16 | Boş günde motorun açılmaması KAP-16. |
| DIY-08 | TUT | | Konuşma başı bağlam sözlüğü yok. |
| DIY-09 | TUT | | En çok koşulu tutan varyantı seçen tablo yok. |
| DIY-51 | SİL | DIY-06 | Beyanın bir kez yazılması DIY-06 kural 3. |
| DIY-52 | SİL | DIY-06 | Aynı cümlenin ikinci kez yazılmaması DIY-06. |
| DIY-53 | SİL | DIY-07 | Çelişkinin çift istemesi DIY-07. |
| DIY-54 | SİL | DYL-01 | Yüzleşme düğmesinin oyuncuya bırakılması DYL-01. |
| DIY-55 | SİL | KOP-01 | Tüketilmiş ipucunun ikinci dal açmaması KOP-01 uç durumu. |
| DIY-56 | SİL | HFZ-09 | Defter kopyasının HFZ-09 olması. |
| DIY-57 | TAŞI | DIY-06 | Ayrılanın beyanının silinmemesi DIY-06 kabulünde. |
| DIY-58 | TAŞI | DIY-06 | Eski kayıtta boş beyan listesi DIY-06 kabulünde. |
| DIY-10 | TUT | | Sır açılınca neden dalı ve iki bedelli seçenek yok. |
| DIY-11 | TUT | | Dönen karakterin son kararı okuyan selamı yok. |
| DIY-59 | SİL | DIY-08 | Bağlam köklerinin sözlük alanları olması DIY-08. |
| DIY-60 | SİL | DIY-09 | Dosya sırasını hakem yapmak DIY-09'un öncelik kuralıyla çelişiyor. |
| DIY-61 | SİL | DIY-09 | Tutmayan satırın susması DIY-09 kural 3. |
| DIY-62 | SİL | BUG-16 | Bina adının listede olması BUG-16. |
| DIY-63 | SİL | DIY-08 | Mevsimin bağlamda olması DIY-08. |
| DIY-64 | SİL | SYS-19 | Perde anahtarının perde geçişinden okunması SYS-19. |
| DIY-65 | SİL | SRM-05 | Bağlam dökümünün oyuncu sürümünde olmaması SRM-05. |
| DIY-66 | SİL | | Bağlamın ağa sorulmaması yeni bir iş değil; sözlük yerel kayıttan kurulur. |
| DIY-12 | TUT | | Altı grup itibarı `grup_itibari.gd` olarak yok. |
| DIY-13 | TUT | | Tanıklı haberin bir ila üç gecede yayılması yok. |
| DIY-67 | TAŞI | DIY-11 | Yüklemenin ziyareti artırmaması DIY-11 kabulünde. |
| DIY-68 | TAŞI | DIY-11 | Onuncu ziyaretin dokuzuncu anahtarı kullanması DIY-11 kabulünde. |
| DIY-69 | SİL | DIY-10 | Sır düğümünün zorunlu olmaması DIY-10 ve DIY-01a. |
| DIY-70 | SİL | DIY-12 | Altı grup adı DIY-12'nin kendisi. |
| DIY-71 | SİL | DIY-12 | Taşan yazımın reddi, DIY-12'nin eksi on ve artı onda kesmesiyle çelişiyor; gövde kesmeyi tutar. |
| DIY-72 | TAŞI | DIY-12 | Kalp anahtarının yasak olması DIY-12 metninde. |
| DIY-73 | TAŞI | DIY-17 | Güven ve korkunun toplanmaması DIY-17 metninde. |
| DIY-74 | SİL | ZAR-04 | Güven eşiğinin zarı motorun içinde atmaması ZAR-04. |
| DIY-14 | TUT | | "Bu hatırlanacak" notu `hatirlanma_notu.gd` olarak yok. |
| DIY-15 | TUT | | Adil, sert ve yoz üç metin varyantı yok. |
| DIY-75 | SİL | DIY-13 | Tanıksız olayın dedikodu açmaması DIY-13. |
| DIY-76 | SİL | DIY-13 | Yayılım gecesinin veride olması DIY-13 kural 3. |
| DIY-77 | SİL | DIY-13 | Ağır olay listesi DIY-13 kural 1. |
| DIY-78 | TAŞI | DIY-14 | Not metninin çeviri anahtarı olması DIY-14 metninde. |
| DIY-79 | SİL | DIY-14 | Notun seçim başına bir kez çıkması DIY-14 kural 4. |
| DIY-80 | SİL | SOY-19 | Muhafız yalanı kancası SOY-19. |
| DIY-81 | SİL | KOP-05 | Gazete basımının motorun işi olmaması KOP-05. |
| DIY-82 | SİL | DIY-13 | Histeri sayacının motorda tutulmaması DIY-13 kural 4. |
| DIY-16 | TUT | | Eski diyalog yolunu kapatan `gecis.json` yok. |
| DIY-17 | TUT | | Güven ve korkunun ayrı çubukları yok. |
| DIY-83 | SİL | ZAR-01 | Üç tansiyon kademesi ZAR-01. |
| DIY-84 | SİL | DIY-15 | Eksik tonun nötr düşmesi, boş varyantın hata sayılmasıyla çelişiyor; gövde hatayı tutar. |
| DIY-85 | SİL | DIY-15 | Tonun etkiyi değiştirmemesi DIY-15 kural 1. |
| DIY-86 | TAŞI | DIY-16 | Kapanış bayrağının veride olması DIY-16 kabulünde. |
| DIY-87 | TAŞI | DIY-16 | Eski ve yeni satırın aynı karede basılmaması DIY-16 metninde. |
| DIY-88 | TAŞI | DIY-16 | Dosyasız adlı figürün sustu kapanması DIY-16 metninde. |
| DIY-89 | SİL | DIY-02 | Bozuk dosyanın 0 satır oynatması DIY-02 kabulü; diğer kişi aynı kurala girer. |
| DIY-90 | SİL | DYL-16 | Prototip fixtures karşılaştırması DYL-16. |
| DIY-18 | TUT | | Söz kesme ve karşı soru motoru yok. |
| DIY-91 | SİL | | Söz motorunun ses çalmaması yeni iş değil; ses yasağı duruyor. |
| DIY-92 | SİL | DIY-02 | Tek söz motoru sınıfı DIY-02'nin kendisi. |
| DIY-93 | SİL | | `koy_sahnesi` import yasağı ortak kural. |
| DIY-94 | SİL | TEK-12 | İmza baseline'ı TEK-12. |
| DIY-95 | SİL | KAY-04 | Kayıt göçünün bir adım olması KAY-04. |
| DIY-96 | SİL | SRM-05 | Deney panelinin oyuncu sürümünde olmaması SRM-05. |
| DIY-97 | SİL | | Çalışma anında model çağrısı olmaması yeni bir özellik değil. |
| DIY-98 | SİL | DIY-02 | Beş iddialı kapanış paketi DIY-02, DIY-03, DIY-06 ve DIY-11 kabulünü tekrarlıyor. |
| ZAR-01 | TUT | | Görünür d6/d12 ve gerekli değer formülü `sorgu_zari.gd` olarak yok. |
| ZAR-07 | SİL | ZAR-01 | İki zar türü ZAR-01'in kendisi. |
| ZAR-08 | SİL | ZAR-01 | Atışın görünür olması ZAR-01. |
| ZAR-09 | SİL | ZAR-01 | Formül ZAR-01 kural 2. |
| ZAR-10 | SİL | ZAR-01 | Üç tansiyon eki ZAR-01 kural 3. |
| ZAR-11 | SİL | ZAR-01 | Değer 2 tablosu ZAR-01 kabulünde. |
| ZAR-12 | TAŞI | ZAR-01 | Aynı tohumun aynı sayıyı vermesi ZAR-01 kabulünde. |
| ZAR-13 | SİL | OGR-03 | İlk atış ipucu OGR-03. |
| ZAR-02 | TUT | | Adlı karakterin sorgu değeri CHR sayfasında ve doğrulayıcıda yok. |
| ZAR-15 | SİL | ZAR-02 | Adlının kendi değerini taşıması ZAR-02 kural 5. |
| ZAR-16 | SİL | ZAR-02 | Aralık dışı değerin reddi ZAR-02 kural 4. |
| ZAR-17 | TAŞI | ZAR-02 | Aynı ziyarette tabanın değişmemesi ZAR-02 kabulünde. |
| ZAR-18 | SİL | UZM-08 | Çocukta zarın kapalı olması UZM-08. |
| ZAR-19 | SİL | ACL-02 | Eşin kapı zarına girmemesi ACL-02. |
| ZAR-20 | SİL | | Değerin çubuk olarak çizilmemesi ayrı bir iş değil; sayı ZAR-02'de. |
| ZAR-21 | SİL | ZAR-02 | Eksik alanda sınıf varsayılanı ve hata ZAR-02 kural 3; yedek 10 yazılmaz. |
| ZAR-22 | SİL | DIY-11 | Ayrı zar değeri kökünün olmaması DIY-11. |
| ZAR-03 | TUT | | Tansiyon onu aşınca kaçış kararı yok. |
| ZAR-24 | TAŞI | ZAR-03 | Kaçışın ret sayacını artırmaması ZAR-03 kabulünde. |
| ZAR-25 | TAŞI | ZAR-03 | Konu değişince tansiyonun sıfırlanmaması ZAR-03 metninde. |
| ZAR-26 | SİL | ZAR-03 | Tek tansiyon alanı ZAR-03'ün kendisi. |
| ZAR-27 | SİL | DIY-02 | Panik kilidi DIY-02. |
| ZAR-28 | TAŞI | ZAR-03 | Menüde tansiyonun donması ZAR-03 metninde. |
| ZAR-29 | SİL | KAP-16 | Boş günde ibrenin olmaması KAP-16. |
| ZAR-30 | TAŞI | ZAR-03 | Eşiğin denge dosyasında olması ZAR-03 kabulünde. |
| ZAR-04 | TUT | | Dört yaklaşım ve değiştirici tablosu yok. |
| ZAR-31 | SİL | ZAR-04 | "Etkileme ve baskı" dörtlüsü ZAR-04'teki ikna, blöf, gözdağı ve gönül alma ile çelişiyor. |
| ZAR-32 | SİL | ZAR-04 | Değiştirici tablosu `zar_degistiricileri.json`; denge.json iddiası gövdeyle çelişiyor. |
| ZAR-33 | SİL | DIY-12 | Grup itibarının DIY-12'den okunması ZAR-04 kural 2. |
| ZAR-34 | SİL | DIY-17 | Güven değiştiricisi DIY-17. |
| ZAR-36 | SİL | ZAR-04 | Eşiğin 1'in altına inmemesi, eksi üç tavanıyla çelişiyor; gövde tavanı tutar. |
| ZAR-37 | SİL | DIY-15 | Yaklaşımın metni değiştirip etkiyi aynı bırakması DIY-15. |
| ZAR-38 | SİL | ZAR-04 | Kıyafet değiştiricisi ZAR-04 listesinde yok; kostüm sistemi açılmıyor. |
| ZAR-05 | TUT | | Beyaz ve kırmızı kontrol ayrımı şemada yok. |
| ZAR-39 | SİL | ZAR-05 | Serbest ikinci atış, koşul değişmeden tekrar atılmamasıyla çelişiyor. |
| ZAR-40 | SİL | ZAR-05 | Kırmızı kontrolün tek şans olması ZAR-05 kural 3. |
| ZAR-42 | TAŞI | ZAR-05 | Kodun türü değiştirmemesi ZAR-05 metninde. |
| ZAR-43 | SİL | DIY-02 | Başarının etkiyi bir kez yazması DIY-02. |
| ZAR-44 | SİL | ZAR-03 | Başarısızlığın tansiyonu artırması ZAR-03 kural 1. |
| ZAR-45 | TAŞI | ZAR-05 | Menünün tekrar hakkını düşürmemesi ZAR-05 kabulünde. |
| ZAR-46 | SİL | ZAR-05 | Kırmızı başarının da dalı kapatması ZAR-05 kural 4. |
| ZAR-06 | TUT | | Zarsız sezgi satırı `muhafiz_sezgisi.gd` olarak yok. |
| ZAR-48 | SİL | ZAR-06 | Eşiğin dosyada olması ZAR-06 kural 2; "değer artı güven" formülü gövdede yok. |
| ZAR-49 | SİL | ZAR-06 | Sezginin hüküm yazmaması ek satır kuralı. |
| ZAR-50 | TAŞI | ZAR-06 | Bir ziyarette bir sezgi ZAR-06 kabulünde. |
| ZAR-51 | SİL | ZAR-06 | Sezginin beyan olmaması ZAR-06 kural 5. |
| ZAR-52 | SİL | UZM-08 | Çocukta sezginin kapalı olması UZM-08. |
| ZAR-53 | SİL | DIY-02 | Panikte sezginin susması DIY-02 panik kilidi. |
| ZAR-54 | SİL | SYS-09 | Sezgi metninin çeviri anahtarı olması SYS-09. |
| ZAR-55 | SİL | ZAR-01 | Sonucun bir kez yazılması görünür zarın kendisi. |
| ZAR-56 | SİL | ARY-02 | Zar yazısının tema puntosu ARY-02. |
| ZAR-57 | TAŞI | ZAR-01 | Sonucun yalnız renkle anlatılmaması ZAR-01 kabulünde. |
| ZAR-58 | SİL | AYR | Anında belirme hızı ayarlar bölümü. |
| ZAR-59 | SİL | ARY-05 | 3B zar modelinin istenmemesi envanter yasağı. |
| ZAR-60 | SİL | ZAR-03 | İbre tavanının on olması ZAR-03. |
| ZAR-61 | SİL | ZAR-01 | İbrenin köy HUD'una taşınmaması kapı zarının yeri. |
| ZAR-62 | SİL | GIR-16 | Odağın zarı yeniden atmaması GIR-16. |
| ZAR-63 | SİL | KAY-04 | Atış kaydının optional olması KAY-04. |
| ZAR-64 | SİL | KAY-04 | Kaydın ham tohumu gömmemesi KAY-04. |
| ZAR-65 | SİL | SYS-02 | Yüklemenin atışı tekrarlamaması SYS-02. |
| ZAR-66 | SİL | KAY-04 | Kırmızı bayrağın göçmesi KAY-04. |
| ZAR-67 | SİL | ZAR-01 | İkiz atış ZAR-01 kabulünde. |
| ZAR-69 | SİL | DEN-05 | Başarı oranının denge ölçümü DEN-05. |
| ZAR-70 | SİL | DEN-04 | Zorluk çarpanının ikinci tablo açmaması DEN-04. |
| ZAR-71 | SİL | DEN-05 | Otuz gece bandı DEN-05. |
| ZAR-72 | SİL | DEN-05 | Panik oranının ayrı sayılması denge ölçümü. |
| ZAR-73 | SİL | ZAR-05 | Beyaz tekrarın akçe düşürmemesi yeni ekonomi değil. |
| ZAR-74 | SİL | ZAR-05 | Kırmızı başarısızlığın dalı bir kez kapatması ZAR-05. |
| ZAR-75 | SİL | ZAR-06 | Sezginin atış oranına karışmaması sezginin zarsız olması. |
| ZAR-76 | SİL | KAY-04 | Eski sonucun yeniden atılmaması KAY-04. |
| ZAR-77 | SİL | KOP-10 | Adsız şablonun ikinci formül olmaması KOP-10. |
| ZAR-79 | SİL | DIY-02 | Motorun zarı çağırması, kendi atmaması DIY-02. |
| ZAR-80 | SİL | ZAR-01 | İkinci zar sınıfının olmaması ZAR-01. |
| ZAR-86 | SİL | ZAR-01 | Altı iddialı kapanış paketi ZAR-01, ZAR-03, ZAR-05 ve ZAR-06 kabulünü tekrarlıyor. |
| CAT-01 | TUT | | Kapıda asker varken kavga isteği `kapi_kavgasi.gd` olarak yok. |
| CAT-06 | SİL | KAP-16 | Boş günde kavganın olmaması KAP-16. |
| CAT-07 | SİL | UZM-08 | Çocukta kavganın olmaması UZM-08. |
| CAT-08 | TAŞI | CAT-01 | Heyet sırasında kavganın açılmaması CAT-01 metninde. |
| CAT-11 | TAŞI | CAT-01 | Yeni ses dosyası olmaması CAT-01 kabulünde. |
| CAT-12 | SİL | DEN-01 | Kavga olasılığının denge dosyasında olması DEN-01. |
| CAT-02 | TUT | | Dört kavga seçeneği ve sonuç tablosu yok. |
| CAT-13 | SİL | CAT-02 | Dört seçenek CAT-02'nin kendisi. |
| CAT-14 | SİL | CAT-02 | Asker yokken karşılık düğmesinin kapanması CAT-02 uç durumu. |
| CAT-15 | TAŞI | CAT-02 | Akçe yetmeyince ertelemenin kilitlenmesi CAT-02 metninde. |
| CAT-18 | TAŞI | CAT-02 | Seçeneğin bir kez yazılması CAT-02 kabulünde. |
| CAT-03 | TUT | | Kavga yaralısının hekim akışına bağlanması yok. |
| CAT-22 | SİL | CAT-03 | Yaralı hekimin iyileştirememesi CAT-03 metninde. |
| CAT-23 | SİL | CAT-03 | İyileşmenin duran hekim akışını kullanması CAT-03 kural 2. |
| CAT-24 | TAŞI | CAT-03 | Aynı yaranın ikinci gece iyileşmemesi CAT-03 kabulünde. |
| CAT-26 | SİL | UZM-08 | Yaralı çocuğun çalışmaması UZM-08. |
| CAT-27 | SİL | DIY-13 | Yaranın tanıkla söylentiye düşmesi DIY-13. |
| CAT-04 | TUT | | Şiddetin sırayı korkutup ayrılmaya götürmesi `siddet_korkusu.gd` olarak yok. |
| CAT-31 | SİL | CAT-04 | Yeni korku barının açılmaması CAT-04 metninde. |
| CAT-32 | SİL | KAP-17 | Ailenin birlikte etkilenmesi KAP-17. |
| CAT-33 | SİL | KOP-02 | Heyetin bu artışı yememesi KOP-02. |
| CAT-34 | TAŞI | CAT-04 | Artışın menüde donması CAT-04 kabulünde. |
| CAT-35 | SİL | KAY-04 | Artış kaydının optional olması KAY-04. |
| CAT-36 | SİL | DEN-05 | Artış ölçümü DEN-05. |
| CAT-40 | SİL | DIY-13 | Kavga dedikodusunun tanık istemesi DIY-13. |
| CAT-41 | SİL | SAB-01 | Muhafız yarasının sabah satırı SAB-01. |
| CAT-44 | SİL | CAS-07 | Divanın yeniden kurulmaması CAS-07. |
| CAT-45 | SİL | CAT-01 | Kavganın kapı konuşması olması CAT-01; yeni sahne yok. |
| CAT-46 | SİL | ARY-02 | Düğmelerin tema durumu ARY-02. |
| CAT-47 | SİL | GIR-06 | Odağın ilk açık düğmede olması GIR-06. |
| CAT-48 | SİL | GIR-08 | Esc'nin karar vermemesi GIR-08. |
| CAT-49 | SİL | GRV-15 | Metnin kaydırılması GRV-15. |
| CAT-50 | SİL | SYS-09 | Eksik anahtarın kilitlememesi SYS-09. |
| CAT-51 | SİL | CAT-01 | Kavganın köy HUD'una taşınmaması CAT-01 kural 4. |
| CAT-52 | SİL | ZAR-03 | İbrenin tansiyon göstergesi olması ZAR-03. |
| CAT-53 | SİL | CAT-02 | Sonuç tablosunun veride olması CAT-02 kural 2. |
| CAT-54 | SİL | CAT-02 | Oran sapması sonuç tablosunun testi; ayrı madde değil. |
| CAT-55 | SİL | EKO-01 | Akçe ertelemenin mevcut kasaya yazılması EKO-01. |
| CAT-56 | SİL | NBT-02 | Asker yarasının iş gününü düşürmesi NBT-02. |
| CAT-57 | SİL | CAT-04 | Retin barı dosyadan düşürmesi şiddet korkusu tablosu. |
| CAT-58 | SİL | CAT-02 | Yatıştırmanın ödül barı yazmaması CAT-02 kural 4. |
| CAT-61 | SİL | KAY-04 | Kavga kaydının optional olması KAY-04. |
| CAT-62 | SİL | SYS-02 | Yüklemenin sonucu tekrarlamaması SYS-02. |
| CAT-63 | SİL | | İkiz dal "Eşit" kısaltması; CAT-02 tablosu tohumu ZAR-01 ile paylaşır. |
| CAT-65 | SİL | KAY-04 | Eski kaydın kavgayı yok sayması KAY-04. |
| CAT-68 | SİL | TEK-20 | Çift sinyalin olmaması TEK-20. |
| CAT-70 | SİL | ARY-05 | Yeni silah modelinin olmaması envanter yasağı. |
| CAT-71 | TAŞI | CAT-01 | Kan efekti ve yeni sesin üretilmemesi CAT-01 kabulünde. |
| CAT-74 | SİL | UZM-08 | Çocuğun dövüşçü olmaması UZM-08. |
| CAT-75 | SİL | ACL-02 | Eşin kavgaya çıkmaması ACL-02. |
| CAT-76 | SİL | SYS-20 | Muhafız ölümünün son ekranına gitmesi SYS-20. |
| CAT-78 | SİL | OZL-06 | Sıra olayının kavga olmaması OZL-06. |
| CAT-79 | SİL | OZL-30 | Olay kartının kavga açmaması OZL-30. |
| CAT-80 | SİL | CAS-07 | Divanın yeni ceza açmaması CAS-07. |
| CAT-81 | SİL | NBT-03 | Nöbetin kavga anında değişmemesi NBT-03. |
| CAT-82 | SİL | MCL-05 | Meclisin kavga anında açılmaması MCL-05. |
| CAT-84 | SİL | CAT-01 | Altı iddialı kapanış paketi CAT-01, CAT-02 ve CAT-03 kabulünü tekrarlıyor. |
| DYL-01 | TUT | | Oyuncunun iki kaydı kendisinin eşleştirdiği "Göster" eylemi yok. |
| DYL-02 | TUT | | Bölgelere ayrılmış bakış eylemi `bakis.gd` olarak yok. |
| DYL-17 | SİL | DYL-01 | Yanlış çiftin bedeli DYL-01 metninde. |
| DYL-18 | SİL | DYL-01 | İki kaydı oyuncunun seçmesi DYL-01'in kendisi. |
| DYL-20 | TAŞI | DYL-02 | Hastalık belirtisinin bakış bölgesi olması DYL-02 metninde. |
| DYL-21 | SİL | DIY-06 | Bakışın beyan sayılmaması DIY-06; gözlem ayrı satırdır. |
| DYL-22 | SİL | DIY-02 | Panikte bakışın kapanması DIY-02. |
| DYL-23 | SİL | UZM-08 | Bakışın çocuğa uygulanmaması UZM-08. |
| DYL-03 | TUT | | İnanca göre yemin `yemin.gd` olarak yok. |
| DYL-04 | TUT | | Muhafız yalanının gece sonunda köyle karşılaştırılması yok. |
| DYL-25 | SİL | DYL-03 | Yemin kalıbının dünya kitabından gelmesi DYL-03 kural 2. |
| DYL-26 | TAŞI | DYL-03 | Bozulan yeminin bir kez ceza yazması DYL-03 kabulünde. |
| DYL-27 | TAŞI | DYL-03 | Yeminin zar açmaması DYL-03 kabulünde. |
| DYL-28 | SİL | DYL-04 | Tanıklı yalanın dedikoduya düşmesi DYL-04 kural 4. |
| DYL-29 | SİL | DIY-15 | Yalan tonunun etkiyi değiştirmemesi DIY-15. |
