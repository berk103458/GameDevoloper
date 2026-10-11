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

## Bölüm 19–21 ayıklaması (Claude, 11 Ekim 2026)

Kaynak: `ROADMAP_2.md` (0530d05) bölüm 19–21, 203 madde; temiz taslak `Roadmap-2/arsiv/C_1.md` (19.1–21.8). Taslağın tuttuğu 84 madde aynen alındı; 21.9 ve 21.10 taslakta yoktu, iki alt başlığın maddeleri aşağıda karara bağlandı ve boş kalan başlıklar düştü. Taslakta taşınmamış yedi koşul elle Ek şart olarak eklendi (ISG-48, ISG-52, ISG-53, YAP-41, YAP-65, YAP-69, YAP-83). Sonuç: 203 → 84 madde.

| Kimlik | Karar | Hedef | Gerekçe |
|---|---|---|---|
| YAZ-01 | TUT | | Dünya kitabının on dört dosyası ve kaynak kuralı repoda yok; yazım hattının ilk girdisi. |
| YAZ-02 | TUT | | `data/soz/yasak_kelimeler.txt` ve üslup kapısı henüz yok. |
| YAZ-03 | TUT | | Yetmiş ses kartı ve alan şeması yazılmadı. |
| YAZ-04 | TUT | | `tools/soz_yazim/` ve imza kapısı yok; üretim ile oyunu ayıran tek madde. |
| YAZ-05 | TUT | | Üç pilot sahnesi toplu yazımdan önce onay noktası; dosyalar yok. |
| YAZ-06 | TUT | | Yedi dalgalık kadro yazımı; en büyük içerik işi. |
| YAZ-07 | TUT | | `tools/soz_dogrula.py` ve ADM önizleme düğmesi yok. |
| YAZ-08 | TUT | | Köylü kartından açılan köy satırları kodda yok. |
| YAZ-09 | TUT | | Çekirdek ve hitap kotasını sayan kadro denetimi yok. |
| YAZ-10 | TUT | | İnceleme işaretleri ve `--kapsam` taraması yok. |
| YAZ-11 | SİL | YAZ-01 | On dört dosya sayısı YAZ-01 kural 1'in son cümlesi. |
| YAZ-12 | SİL | YAZ-01 | Kaynaksız dosyanın onaylanmaması YAZ-01 kural 2. |
| YAZ-13 | SİL | YAZ-01 | Kitabın kural makinesi yazmaması YAZ-01 kural 3. |
| YAZ-14 | SİL | YAZ-01 | Çelişen iki dosyanın oyuna girmemesi YAZ-01 uç durumu ve kabulünde. |
| YAZ-15 | SİL | YAZ-01 | Coğrafyada olmayan şehrin hata vermesi YAZ-01 kabulünün son iddiası. |
| YAZ-16 | TUT | | Kitabın dışa aktarım paketinde olmaması ayrı bir KLT-22 taramasıdır; YAZ-01 bunu ölçmüyor. |
| YAZ-17 | SİL | YAZ-01 | İki isim onayı YAZ-01 kural 4. |
| YAZ-18 | TAŞI | YAZ-01 | Kayıtta kitap sürüm alanı olmaması YAZ-01 Ek şartı oldu. |
| YAZ-19 | TAŞI | YAZ-02 | İkinci üslup dosyasının reddi YAZ-02 Ek şartı oldu. |
| YAZ-20 | TUT | | KLT-04 ile aynı yasak listeyi çağırma bağı; liste tekliğini koruyan ayrı tarama. |
| YAZ-21 | TUT | | İki ağızda aynı iskelet uyarısı YAZ-09 sayımının dışında bir inceleme işi. |
| YAZ-22 | TUT | | `hitap_puani` alanının açılmamasını tarayan ayrı kontrol; romans/puan sızıntısını kapatır. |
| YAZ-23 | TAŞI | YAZ-02 | Doğaçlama taslağının dışa aktarımda olmaması YAZ-02 Ek şartı oldu. |
| YAZ-24 | TUT | | `ogretici.` anahtarlarını üslup kapısına sokan bağ OGR-09'a dayanır; YAZ-02'de yok. |
| YAZ-25 | TUT | | Teknik ayar anahtarlarını üslup taramasından çıkaran istisna; yoksa yanlış hata üretir. |
| YAZ-26 | TUT | | Karakter ağzında yıl sayısı yasağı yeni bir doğrulayıcı kuralıdır. |
| YAZ-30 | TUT | | Kart onayından önce DYL-11 kör okuma skoru şartı ayrı bir kapı. |
| YAZ-31 | TAŞI | YAZ-03 | Eş kartında yasak meslek kuralı YAZ-03 Ek şartı oldu. |
| YAZ-32 | SİL | YAZ-03 | Adsızın kart sayısına girmemesi YAZ-03 uç durumunun ilk cümlesi. |
| YAZ-33 | TUT | | Örnek cümlesi boş kartın reddi DYL-14 bağıyla ayrı alan kontrolü. |
| YAZ-34 | TAŞI | YAZ-03 | Ses kartının `kayit.json`'a girmemesi YAZ-03 Ek şartı oldu. |
| YAZ-35 | TUT | | HAT belgesindeki adım sırasının atlanmaması KLT-01 kapısına bağlı ayrı iş. |
| YAZ-36 | TAŞI | YAZ-04 | İstem yolunun `res://` dışında kalması YAZ-04 Ek şartı oldu. |
| YAZ-37 | TAŞI | YAZ-04 | `tools/soz_kapi.py` tek kapı aracı YAZ-04 Ek şartı oldu. |
| YAZ-38 | SİL | YAZ-04 | İmzasız dosyanın kopyalanmaması YAZ-04 kural 3. |
| YAZ-39 | TUT | | Eski diyaloğun DYL-13 kaydı olmadan "taşındı" sayılmaması DIY-16 ile kesişen ayrı kapı. |
| YAZ-40 | SİL | YAZ-04 | Üretimin oyun sürecinde çağrılmaması YAZ-04 kural 4. |
| YAZ-41 | TAŞI | YAZ-04 | Reddedilen dosyanın komşuyu düşürmemesi YAZ-04 Ek şartı oldu. |
| YAZ-43 | SİL | YAZ-05 | Pilotun üç kişi olması YAZ-05 kural 1. |
| YAZ-44 | TAŞI | YAZ-09 | Pilotun kota paydasına girmesi YAZ-09 Ek şartı oldu. |
| YAZ-45 | TUT | | Üç pilot kimliğinin DYL-16 `--check` listesine bağlanması ayrı fixture işi. |
| YAZ-46 | SİL | YAZ-01 | Pilot şehir adı da coğrafya kabulüne tabi; YAZ-01 son iddiası kapsar. |
| YAZ-47 | TUT | | Pilotta zorunlu `sira` alanının olmaması şema kontrolü (KLT-03); YAZ-05'teki "en çok bir sır" kuralından ayrı. |
| YAZ-48 | TAŞI | YAZ-05 | Pilotta ses dosyası yolu olmaması YAZ-05 Ek şartı oldu. |
| YAZ-49 | TAŞI | YAZ-08 | Pilot için ayrı köy sahnesi olmaması YAZ-08 Ek şartı oldu. |
| YAZ-51 | SİL | YAZ-06 | Kadro listesi dışında dosya üretilmemesi YAZ-06 kural 2. |
| YAZ-52 | SİL | YAZ-06 | Adsız şablonun kişi dosyası sayılmaması YAZ-06 kural 3. |
| YAZ-53 | TAŞI | YAZ-06 | Eski CSV anahtarının silinmemesi YAZ-06 Ek şartı oldu. |
| YAZ-54 | SİL | YAZ-06 | Kartsız kişinin üretilmemesi YAZ-06 kural 2'nin ikinci cümlesi. |
| YAZ-55 | SİL | YAZ-09 | Kota aşımını hata sayıyordu; YAZ-09 kotayı uyarı ve gerekçe notuyla yönetir. Çelişki, taslağın kararı korundu. |
| YAZ-58 | TAŞI | YAZ-06 | Yarım paketin yüklenmemesi YAZ-06 Ek şartı oldu. |
| YAZ-59 | SİL | YAZ-07 | Önizlemenin yalnız ADM panelinde olması YAZ-07 kural 3–4. |
| YAZ-61 | TAŞI | YAZ-07 | Önizlemede düz gömülü cümle olmaması YAZ-07 Ek şartı oldu. |
| YAZ-62 | SİL | YAZ-07 | Önizlemenin kayda yazmaması YAZ-07 kural 3 ve kabulü. |
| YAZ-63 | TAŞI | YAZ-08 | Kapı düğüm kimliğinin köyde tekrar etmemesi YAZ-08 Ek şartı oldu. |
| YAZ-64 | TAŞI | YAZ-08 | Günde tek konu YAZ-08 Ek şartı oldu. |
| YAZ-65 | TUT | | Köy satırının SOY-46 söylentisini okuması dedikodu bağının tek yeri. |
| YAZ-66 | TAŞI | YAZ-08 | Ayrı sohbet sahnesi açılmaması YAZ-08 kural 1 ve `koy_sahnesi` Ek şartında. |
| YAZ-67 | SİL | YAZ-09 | Çekirdek kotası YAZ-09 kural 2. |
| YAZ-68 | SİL | YAZ-09 | Dinleyici kotasını ayrı sütun istiyordu; YAZ-09 kural 2 "dürüst + dinlenmek isteyen" birlikte sayar. Çelişki, taslağın kararı korundu. |
| YAZ-70 | TUT | | Kota raporunun turda tek satır olması KLT-18 rapor biçimi; YAZ-09'da yok. |
| YAZ-71 | SİL | YAZ-10 | Her satırın işaret alması ve atlananın listelenmesi YAZ-10 kural 1 ve 3. |
| YAZ-72 | SİL | YAZ-10 | Taramanın oyuncuya çıkmaması YAZ-10 kural 3. |
| YAZ-73 | SİL | YAZ-20 | İncelemenin yasak listeyi USLUP'tan okuması YAZ-20'nin tek liste kuralı. |
| YAZ-74 | TUT | | İnceleme sonucunun HAT.md kutusuna yazılması dosyanın hazır sayılma şartı. |
| YAZ-75 | TUT | | Anahtar biçimi YER-02 standardına bağlı; metin doğrulayıcısına yeni kural. |
| YAZ-76 | TUT | | `%s`/`%d` sayısının kodla eşitliği yeni araç kuralı. |
| YAZ-77 | TUT | | Boş Türkçe hücrenin hata olması YER-04 ile kesişen doğrulama. |
| YAZ-78 | TUT | | TST-0006 çift boşluk kuralını `sohbet.` önekine genişletir. |
| YAZ-79 | TUT | | Kişi adının ikinci dilde aynı kalması YER-17 uyarısı. |
| YAZ-80 | TUT | | `CHR_XXX_DUGUM_YY` biçimini koruyan ret kuralı. |
| YAZ-81 | TUT | | Yetim anahtarın silinmeden listelenmesi; temizlik ile silme ayrılır. |
| YAZ-83 | TUT | | YAZ içeriğinin DIY-02 motoruna girmesi, ikinci motor açılmasını engeller. |
| YAZ-84 | SİL | YAZ-02 | Ses dosyası eklenmemesi YAZ-02 uç durumunda ve YAZ-05 Ek şartında. |
| YAZ-87 | TUT | | Kayıtta konuşmanın anahtar olarak durması KAY-04 göçüyle bağlı. |
| YAZ-89 | TUT | | Eski kaydın söz dosyası olmadan açılması göç güvencesi. |
| YAZ-90 | SİL | | Beş iddia kendi maddelerinin kabulünde: 14 dosya YAZ-01, pilotsuz kopya YAZ-05, düz cümle YAZ-07, çalışma anında istem YAZ-04. "Kota aşımı red" YAZ-09 ile çeliştiği için alınmadı. |
| ISG-01 | TUT | | Kabul panelindeki meslek uyarısı ve `meslek_binalari.json` yok. |
| ISG-02 | TUT | | Geçici işler havuzu ve `gecici_isler.json` yok. |
| ISG-03 | TUT | | "Boşta: N kişi" HUD satırı ve boşta bedeli yok. |
| ISG-05 | SİL | ISG-01 | Meslek listesinin eşleme dosyasından okunması ISG-01 kural 1. |
| ISG-07 | TAŞI | ISG-01 | Eşe uyarı çıkmaması ISG-01 Ek şartı oldu. |
| ISG-09 | SİL | ISG-01 | Uyarının kabulü kapatmaması ISG-01 "Ne" metninde yazılı. |
| ISG-11 | TAŞI | ISG-01 | Uyarının kayda yazılmaması ISG-01 Ek şartı oldu. |
| ISG-12 | SİL | ISG-02 | Havuzun ISG-02 olduğunu söyleyen madde ISG-02'nin kendisi. |
| ISG-13 | TUT | | Havuzun bina şartı BUG-16 koşul okumasına bağlı ayrı kontrol. |
| ISG-14 | TAŞI | ISG-02 | Aynı kişiye ikinci iş yazılmaması ISG-02 Ek şartı oldu. |
| ISG-15 | TAŞI | ISG-02 | Yaralının yazılmaması ISG-02 Ek şartında (çocuk, yaralı, nöbetçi). |
| ISG-16 | TAŞI | ISG-02 | Nöbetçinin yazılmaması ISG-02 Ek şartında. |
| ISG-18 | TAŞI | ISG-02 | Havuz sırasının kayda girmemesi ISG-02 Ek şartı oldu. |
| ISG-20 | SİL | ISG-03 | Bedelin veri dosyasında olması ISG-03 kural 2. |
| ISG-21 | TAŞI | ISG-03 | Günde tek düşüş ISG-03 Ek şartı oldu. |
| ISG-22 | SİL | ISG-03 | İşteki kişinin sayılmaması ISG-03 kural 1 ve 4. |
| ISG-24 | SİL | ISG-03 | HUD'da tek satır ISG-03 kural 1. |
| ISG-25 | TUT | | Bedel ölçümünün DEN satırı olması denge bandına bağlı ayrı ölçüm. |
| ISG-26 | TAŞI | ISG-03 | Kış çarpanının mevsim kaydından okunması ISG-03 Ek şartı oldu. |
| ISG-27 | TAŞI | ISG-03 | Açlık çubuğuyla birleşmemesi ISG-03 Ek şartı oldu. |
| ISG-28 | TAŞI | ISG-02 | Atamanın sürükleme kulpundan yapılması ISG-02 Ek şartı oldu. |
| ISG-30 | TUT | | Yanlış binaya bırakılan kişinin geri dönmesi atama arayüzünün yeni kuralı. |
| ISG-32 | TUT | | Duraklatta atamanın uygulanmaması zaman denetimiyle kesişen ayrı kural. |
| ISG-33 | TUT | | Atama ipucunun bir kez çıkması OGR öğretici bağı. |
| ISG-35 | TUT | | Klavyeyle atama GIR erişilebilirlik işi; fareyi şart olmaktan çıkarır. |
| ISG-36 | SİL | | Çalışansız üretim olmaması duran üretim hesabının mevcut davranışı; yeni iş değil. |
| ISG-37 | TUT | | Ustasız çırağın yarım üretimi TEZ-07 bağı. |
| ISG-38 | TUT | | Grevdeki kişinin işten düşmesi `meslek_grevi.gd` ile havuz arasındaki bağ. |
| ISG-39 | TUT | | Grev eşiğinin SOY-34'ten okunması ikinci eşiği engeller. |
| ISG-40 | TUT | | Sağlık 0 iken üretimin 0 olması KRI bağı. |
| ISG-41 | SİL | | Açlık verimi YSM-02'nin işi; burada tekrar ediliyordu. |
| ISG-42 | SİL | | Mevsim verimi MEV maddelerinde; ISG-03 Ek şartı kış çarpanını zaten mevsim kaydına bağlıyor. |
| ISG-43 | TUT | | Üretim ölçümünün DEN'de durması denge bandı. |
| ISG-44 | TUT | | İş yerinin ızgarada olması BUG-23 testine bağlı. |
| ISG-45 | TUT | | Bina yokken yer tutucu iş açılmaması BUG-16 koşuluna bağlı. |
| ISG-46 | SİL | | Kapasite bina kataloğundaki `slot` alanıdır (`data/koy/binalar.json`); yeni kural değil. |
| ISG-47 | SİL | ISG-02 | Sayıların kod sabiti olmaması ISG-02 kural 2. |
| ISG-48 | TAŞI | ISG-02 | Yıkılan binanın işçisinin hatasız boşa düşmesi ISG-02'ye Ek şart olarak eklendi. |
| ISG-51 | TAŞI | ISG-02 | Boş yuvanın sabah dolmaması ISG-02 Ek şartı oldu. |
| ISG-52 | TAŞI | ISG-02 | Kartta ham anahtar görünmemesi ISG-02'ye Ek şart olarak eklendi. |
| ISG-53 | TAŞI | ISG-03 | "Boşta" sözcüğünün CSV anahtarından gelmesi ISG-03'e Ek şart olarak eklendi. |
| ISG-56 | TUT | | İş ikonunun `Sanat` kaynağından gelmesi GRV-27 bağı. |
| ISG-57 | TUT | | İkon yokken harf yer tutucusu; asset kuralının uygulaması. |
| ISG-60 | TUT | | Atamanın kişi kaydında durması kayıt şemasının kararı. |
| ISG-61 | TUT | | Yüklemenin atamayı ikinci kez üretmemesi çift ürün hatasını kapatır. |
| ISG-62 | TUT | | Eski kayıtta iş alanı yoksa açılış göç kuralı. |
| ISG-63 | TAŞI | ISG-02 | Aynı tohumda aynı geçici iş kimliği ISG-02 Ek şartı oldu. |
| ISG-67 | TUT | | Otuz günlük boşta oranı bandı DEN ölçümü. |
| ISG-69 | SİL | ISG-02 | İkinci meslek ağacı yasağı bölüm girişinde ve ISG-02 Ek şartında (yeni meslek sınıfı adı yok). |
| ISG-73 | TUT | | Çırak yaşının UZM-04'ten okunması; ISG yaş icat etmez. |
| ISG-74 | TAŞI | ISG-02 | Yeni sınıf adı yasağı ISG-02 Ek şartı oldu. |
| ISG-75 | TAŞI | ISG-02 | `muhafiz_maas` ile karışmama ISG-02 Ek şartı oldu. |
| ISG-76 | TAŞI | ISG-01 | Uyarının köy ekranında tekrar basılmaması ISG-01 Ek şartı oldu. |
| ISG-77 | TUT | | Ayarlar menüsünden iş atanmaması AYR ile sınır. |
| ISG-78 | TUT | | Tezgâh yüzünün TEZ'de kalması sipariş cümlesini ayırır. |
| ISG-79 | SİL | | Yapı kilidi YAP-01'in işi; burada yalnız gönderme yapıyordu. |
| ISG-80 | TUT | | Divanın iş cezası yazmaması CAS üçlü kararıyla sınır. |
| ISG-83 | SİL | | Altı iddia ISG-01…03 kabullerinde ve Ek şartlarında; ayrı kapanış testi tekrar olurdu. |
| YAP-01 | TUT | | `data/koy/yapi_kademeleri.json` ve kilit menüsü yok. |
| YAP-02 | TUT | | Bilgi bayrağı ve üç kaynak kodda yok. |
| YAP-03 | TUT | | `data/ustalar.json` ve usta pazarlığı yok. |
| YAP-04 | TUT | | Defter ve yapı resmi ganimeti yok. |
| YAP-05 | TUT | | Çözümleme odası ve `usta_defterleri.json` yok. |
| YAP-06 | TUT | | `data/ozel_esyalar.json` yok. |
| YAP-08 | SİL | YAP-01 | "Kademe UZM seviyesidir" diyordu; YAP-01 kural 3 kademeyi kişinin UZM seviyesinden açıkça ayırır. Çelişki. |
| YAP-09 | TAŞI | YAP-01 | Bedelin `.gd` sabiti olmaması YAP-01 Ek şartı oldu. |
| YAP-10 | TAŞI | YAP-01 | Yetmeyen bedelde kapalı düğme YAP-01 Ek şartı oldu. |
| YAP-11 | TAŞI | YAP-01 | Kademe atlanmaması YAP-01 Ek şartı oldu. |
| YAP-12 | TAŞI | YAP-01 | Yıkımın kademeyi sıfırlaması YAP-01 Ek şartı oldu. |
| YAP-14 | TAŞI | YAP-01 | Kademe ikonu üretilmemesi YAP-01 Ek şartı oldu. |
| YAP-15 | SİL | YAP-02 | Üç kaynak YAP-02 kural 1. |
| YAP-16 | SİL | YAP-02 | Geçmişin yapı açması YAP-02 kural 1 ve uç durumu. |
| YAP-17 | SİL | YAP-02 | Çırağın bilgiyi tutması YAP-02 kural 3 ve Ek şartı. |
| YAP-18 | SİL | YAP-01 | Bilgisiz düğmenin gri durup sebep yazması YAP-01 kural 2. |
| YAP-19 | SİL | YAP-02 | Bilginin kalıcılığı YAP-02 kural 3. |
| YAP-20 | TUT | | Bilgi alanının kayıtta optional olması göç güvencesi. |
| YAP-24 | TUT | | Ustanın adlı dosya olması KOP-10 adsız havuzuyla sınır. |
| YAP-25 | SİL | YAP-03 | Reddedilen ustanın bilgi getirmemesi YAP-03 uç durumu. |
| YAP-26 | SİL | YAP-02 | Usta ölünce ayaktaki yapının durması YAP-02 kural 2. |
| YAP-27 | TAŞI | YAP-03 | İkinci ziyarette bilgi deltasının sıfır olması YAP-03 Ek şartı oldu. |
| YAP-28 | TUT | | Usta çocuğunun çıraklığı UZM-04 yaşına bağlı ayrı kural. |
| YAP-29 | TUT | | Ustanın nöbet tutmaması NBT ile sınır. |
| YAP-32 | TAŞI | YAP-04 | Defterin yeni eşya sınıfı açmaması YAP-04 Ek şartı oldu. |
| YAP-33 | SİL | YAP-04 | Aynı defterin ikinci kilit açmaması YAP-04 kural 3. |
| YAP-34 | TAŞI | YAP-04 | Defter için png üretilmemesi YAP-04 Ek şartı oldu. |
| YAP-35 | SİL | YAP-04 | Yapı resminin aynı ganimet akışından gelmesi YAP-04 kural 1. |
| YAP-36 | SİL | YAP-04 | Tablo dışı ganimetin defter üretmemesi YAP-04 uç durumu. |
| YAP-37 | TUT | | Defter sözünün DYL-08 ile dönmesi ikinci dönüş motorunu engeller. |
| YAP-38 | TUT | | Defter alanının kayıtta optional olması göç güvencesi. |
| YAP-40 | TUT | | Çözümleme işçisinin yetişkin olması çocuk işi yasağı. |
| YAP-41 | TAŞI | YAP-05 | İşçi işten alınınca sayacın durması YAP-05'e Ek şart olarak eklendi. |
| YAP-42 | SİL | YAP-05 | Sürenin dosyada olması YAP-05 kural 2. |
| YAP-43 | TAŞI | YAP-05 | Tek satır bildirim YAP-05 Ek şartı oldu. |
| YAP-44 | TAŞI | YAP-05 | İkinci akçe düşüşü olmaması YAP-05 Ek şartı oldu. |
| YAP-45 | TAŞI | YAP-05 | Ayrı kış araştırma sayısı olmaması YAP-05 Ek şartı oldu. |
| YAP-46 | TUT | | Çözümleme ölçümünün DEN satırı olması denge bandı. |
| YAP-47 | SİL | YAP-06 | Özel eşyanın YAP-06 listesinde olması YAP-06 kural 1. |
| YAP-48 | SİL | YAP-06 | Eşyanın bir kez etkilemesi YAP-06 uç durumu (çarpan bir kez). |
| YAP-49 | TAŞI | YAP-06 | Çocuk heybesinin ayrı kayıt açmaması YAP-06 Ek şartı oldu. |
| YAP-50 | TAŞI | YAP-06 | Eşya ikonu için png üretilmemesi YAP-06 Ek şartı oldu. |
| YAP-51 | TUT | | Eşya açıklamasının CSV anahtarı olması düz cümleyi engeller. |
| YAP-52 | TAŞI | YAP-06 | Satıştan sonra kademenin açık kalması YAP-06 Ek şartı oldu. |
| YAP-53 | TUT | | Kavga ganimetinin eşya kaynağı olması CAT ile bağ. |
| YAP-54 | TUT | | Nadir eşyanın DEN bandına sokulmaması ölçüm kararı. |
| YAP-55 | TUT | | Yapı kartının tema zemini GRV dosya maddesi. |
| YAP-56 | SİL | YAP-01 | Kilit sebebinin görünmesi YAP-01 kural 2. |
| YAP-58 | TAŞI | YAP-01 | Kilitli yapıda hayalet yerleşim olmaması YAP-01 Ek şartı oldu. |
| YAP-59 | TAŞI | YAP-01 | Kart metninin kayması YAP-01 Ek şartı oldu. |
| YAP-60 | TUT | | Eksik anahtarda kartın açık kalması hata dayanıklılığı. |
| YAP-61 | TUT | | Kartın köy hızına dokunmaması zaman denetimi sınırı. |
| YAP-62 | TUT | | Kartın 3B modeli değiştirmemesi SAH sınırı. |
| YAP-63 | SİL | | Kurulumda kaynak düşmesi duran inşaat maliyetinin mevcut davranışı. |
| YAP-64 | TAŞI | YAP-01 | İşçisiz inşaatın ilerlememesi YAP-01 Ek şartı oldu. |
| YAP-65 | TAŞI | YAP-01 | Yarım inşaatın yüklemeden sonra aynı yerden sürmesi YAP-01'e Ek şart olarak eklendi. |
| YAP-66 | SİL | | Yıkım iadesi duran `yik` kuralıdır; ikinci oran açılmıyor. |
| YAP-67 | TAŞI | YAP-01 | İnşaatın kış çarpanını mevsimden okuması YAP-01 Ek şartı oldu. |
| YAP-68 | TAŞI | YAP-01 | Hasta işçide inşaatın durması YAP-01 Ek şartı oldu. |
| YAP-69 | TAŞI | YAP-01 | Sur taksitinin kademeden bağımsızlığı YAP-01'e Ek şart olarak eklendi. |
| YAP-70 | TUT | | İnşaat süresi bandının DEN ölçümü. |
| YAP-72 | TAŞI | YAP-01 | Yeni bina kimliği olmaması YAP-01 Ek şartında. |
| YAP-78 | TAŞI | YAP-01 | Aynı tohumda aynı kilit listesi YAP-01 Ek şartında. |
| YAP-79 | TAŞI | YAP-04 | "Şematik" sözcüğünün oyuncu metninde olmaması YAP-04 Ek şartında. |
| YAP-82 | TAŞI | YAP-01 | Divanın kademe açmaması YAP-01 Ek şartında. |
| YAP-83 | TAŞI | YAP-01 | Kapı kararının bina kurmaması YAP-01'e Ek şart olarak eklendi. |
| YAP-85 | TAŞI | YAP-01 | Olay kartının kademe açmaması YAP-01 Ek şartında. |
| YAP-86 | SİL | | Altı iddia YAP-01…06 kabullerinde ve Ek şartlarında; ayrı kapanış testi tekrar olurdu. |

## Taşıma listeleri uygulandı (Claude, 11 Ekim 2026)

Kaynak: `Roadmap-2/arsiv/TASIMA_LISTESI_{B,C2,26,27,28,29,30}.md`, 97 satır. Her satırın cümlesi hedef maddenin Kabul satırına "Ek şart:" olarak eklendi, kaynak madde `ROADMAP_2.md`'den silindi. Bağımlılık taramasında silinen kimliklere atıf kalmadı. ROADMAP 1 hedefli 9 satırda ROADMAP 1 değiştirilmedi.

| Kimlik | Karar | Hedef | Not |
|---|---|---|---|
| NBT-20 | SİL | GIR-08 | Listede eklenecek cümle yok; kaynak silindi. |
| NBT-30 | TAŞI | SAB-01 | Kabul satırına Ek şart: Sabah defteri nöbetin görülenler listesini ikinci kez basmaz; nöbeti anarsa bunu tek satır |
| NBT-38 | SİL | OMR-45 | Listede eklenecek cümle yok; kaynak silindi. |
| NBT-39 | TAŞI | GIR-08 | Kabul satırına Ek şart: Nöbet atama kartı açıkken Esc seçimi yuvaya yazmaz. |
| NBT-42 | SİL | DIY-13 | Listede eklenecek cümle yok; kaynak silindi. |
| NBT-79 | TAŞI | DEN-05 | Kabul satırına Ek şart: Nöbet maaşı ölçümü denge raporunun bir satırıdır; maaş formülü bu satırda değişmez. |
| MCL-23 | TAŞI | GIR-08 | Kabul satırına Ek şart: Çınar meclisi oy düğmesi duraklat menüsü açıkken sadakat ve moral farkı yazmaz. |
| MCL-26 | TAŞI | DEN-05 | Kabul satırına Ek şart: Çınar meclisinin oy farkı denge formülünü değiştirmez; ölçüm yeni bir tüketim fonksiyonu a |
| MCL-55 | TAŞI | SAB-01 | Kabul satırına Ek şart: Çınar meclisi sabah defterine cümle yazmaz; sabah satırının kaynağı CAS-07 hükmüdür. |
| MCL-59 | SİL | OMR-44 | Listede eklenecek cümle yok; kaynak silindi. |
| MCL-60 | TAŞI | OMR-44 | Kabul satırına Ek şart: Aynı gecede köy şikâyeti ile dış hat konusu birlikte açılmaz; dış hat varsa konuşulan konu |
| MCL-61 | TAŞI | OMR-24 | Kabul satırına Ek şart: Dış hat yüzü çınarın altında durmaz; mecliste yalnız adı anılır, modeli kapıda kalır. |
| MCL-62 | TAŞI | SOY-16 | Kabul satırına Ek şart: Çınar meclisi kamuoyu değerini tek başına değiştirmez; düşüş divan hükmü veya süre dolumud |
| MCL-69 | TAŞI | GRV-15 | Kabul satırına Ek şart: Çınar meclisi şikâyet satırı kaydırılır; uzun metinde kesilen glif kalmaz. |
| MCL-72 | TAŞI | TEK-24 | Kabul satırına Ek şart: Çınar meclisi paneli açıkken oyun hızı değişmez; panel kapanınca hız kaldığı değere döner. |
| MCL-76 | TAŞI | NBT-03 | Kabul satırına Ek şart: Çınar meclisi açıkken nöbet devri aynı gece yazılır; meclis devri kesmez. |
| MCL-81 | TAŞI | ISG-02 | Kabul satırına Ek şart: Çınar meclisi gecesinde geçici iş ve bina üretimi kesilmez; iş o gece biter. |
| MCL-82 | TAŞI | NBT-01 | Kabul satırına Ek şart: Çınar meclisi nöbetçi maaşını değiştirmez. |
| SAB-17 | TAŞI | KAY-04 | Kabul satırına Ek şart: Eski kayıtta sabah defteri satırı yoksa satır boş sayılır ve oyun açılır. |
| SAB-18 | TAŞI | TEK-22 | Kabul satırına Ek şart: Sabah defteri satırı yazılırken `time_scale` değişmez. |
| SAB-25 | TAŞI | HAN-07 | Kabul satırına Ek şart: Hüküm sabahı eşin üretim satırını ikinci kez basmaz. |
| SAB-42 | TAŞI | KAY-04 | Kabul satırına Ek şart: Eski kayıtta sabah gün sayacı yoksa sayaç 0 sayılır ve yükleme onu artırmaz. |
| SAB-55 | TAŞI | NBT-07 | Kabul satırına Ek şart: Hüküm sabahı nöbet raporunun iki satırını tam liste diye basmaz. |
| SAB-56 | TAŞI | MCL-05 | Kabul satırına Ek şart: Hüküm sabahı meclis sahnesini açmaz. |
| SAB-57 | TAŞI | ZAR-01 | Kabul satırına Ek şart: Hüküm sabahı zar atışı yazmaz. |
| SAB-62 | TAŞI | YSM-02 | Kabul satırına Ek şart: Zindan payı bitince yeni hastalık açılmaz; sağlık düşüşü yalnız açlık kademesindedir. |
| SAB-64 | TAŞI | DEN-05 | Kabul satırına Ek şart: Zindan ekmek payı denge formülünü değiştirmez; ölçüm mevcut gece raporunu okur. |
| SAB-68 | SİL | KAP-16 | Listede eklenecek cümle yok; kaynak silindi. |
| SAB-69 | TAŞI | ACL-02 | Kabul satırına Ek şart: Eş sürgün yoluna yazılırsa hane uyarısı çıkar ve köy kaydı silinmez. |
| SAB-78 | TAŞI | GRV-15 | Kabul satırına Ek şart: Hüküm sabahı paneli uzun satırda glif kesmez, kaydırır. |
| TEZ-14 | TAŞI | HAN-07 | Kabul satırına Ek şart: Eşin meslek çıktısı dört tezgâh sabahına yazılmaz; tezgâh ikinci meslek sınıfı açmaz. |
| TEZ-37 | SİL | YAZ-21 | Listede eklenecek cümle yok; kaynak silindi. |
| TEZ-38 | SİL | YAZ-26 | Listede eklenecek cümle yok; kaynak silindi. |
| TEZ-40 | SİL | SAB-01 | Listede eklenecek cümle yok; kaynak silindi. |
| TEZ-41 | SİL | DIY-13 | Listede eklenecek cümle yok; kaynak silindi. |
| TEZ-47 | SİL | DEN-05 | Listede eklenecek cümle yok; kaynak silindi. |
| TEZ-58 | SİL | DEN-05 | Listede eklenecek cümle yok; kaynak silindi. |
| TEZ-70 | TAŞI | GRV-15 | Kabul satırına Ek şart: Tezgâh sabah satırı köy panelinde kesilmez; 400 karakterlik denemede son satır kayarak oku |
| TEZ-72 | TAŞI | GIR-08 | Kabul satırına Ek şart: Esc tezgâh teslimini onaylamaz; ücret ve parça o tuşla yazılmaz. |
| TEZ-89 | SİL | OZL-30 | Listede eklenecek cümle yok; kaynak silindi. |
| YIL-34 | SİL | DEN-05 | Listede eklenecek cümle yok; kaynak silindi. |
| YIL-62 | SİL | SAB-01 | Listede eklenecek cümle yok; kaynak silindi. |
| YIL-69 | TAŞI | GRV-15 | Kabul satırına Ek şart: Yıl cümlesi köy satırında kesilmez; 400 karakterlik denemede son satır kayarak okunur. |
| YIL-71 | TAŞI | GIR-08 | Kabul satırına Ek şart: Esc yıl cümlesini kapatır, moral ve erzak yazmaz. |
| YIL-81 | SİL | DEN-05 | Listede eklenecek cümle yok; kaynak silindi. |
| DYL-73 | SİL | ARY-02 | Listede eklenecek cümle yok; kaynak silindi. |
| DYL-76 | TAŞI | GIR-06 | Kabul satırına Ek şart: Kapıdaki sorgu eylemleri ok tuşuyla seçilir; bu iş yeni oyun kolu şartı açmaz. |
| DYL-77 | TAŞI | KAP-39 | Kabul satırına Ek şart: Heybe açıkken sorgu eylemi seçilmez; panel kapanınca aynı düğme durur. |
| DYL-78 | SİL | KAP-16 | Listede eklenecek cümle yok; kaynak silindi. |
| DYL-81 | TAŞI | KAY-04 | Kabul satırına Ek şart: Eski kayıtta eylem listesi yoksa liste boş sayılır. |
| DYL-82 | TAŞI | KAY-04 | Kabul satırına Ek şart: Kayıt yüklenince aynı kapı eylemi ikinci kez uygulanmaz. |
| DYL-85 | TAŞI | DEN-05 | Kabul satırına Ek şart: Ölçüm raporunda her sorgu eyleminin kullanım sayısı bir satırdır; gece formülü değişmez. |
| DYL-89 | TAŞI | TEK-12 | Kabul satırına Ek şart: Kapı ekranına `eylem_bitti` sinyali eklenmez. |
| DYL-95 | SİL | KLT-23 | Listede eklenecek cümle yok; kaynak silindi. |
| YSM-37 | TAŞI | TEK-03 | Kabul satırına Ek şart: Yaşam satırları güvenlik satırını ilk ekrandan düşürmez. |
| YSM-38 | SİL | ARY-02 | Listede eklenecek cümle yok; kaynak silindi. |
| YSM-42 | SİL | TEK-22 | Listede eklenecek cümle yok; kaynak silindi. |
| YSM-51 | TAŞI | DEN-05 | Kabul satırına Ek şart: Aç kişi oranı gece ölçümüne bir satır eklenir; denge hesabı ikinci kez çalışmaz. |
| YSM-60 | TAŞI | DIY-09 | Kabul satırına Ek şart: Aç kişinin söz bağlamına aclik anahtarı yazılır; motor ikinci cümle üretmez. |
| YSM-62 | SİL | DIY-13 | Listede eklenecek cümle yok; kaynak silindi. |
| YSM-63 | TAŞI | SAB-01 | Kabul satırına Ek şart: Ölüm sabah defterine tek satır yazılır; ikinci ölüm cümlesi açılmaz. |
| YSM-66 | TAŞI | ZAR-04 | Kabul satırına Ek şart: Yorgunluk yaklaşım eki varsa yalnız zar değiştirici tablosundadır; yaşam kodu iç ek yazmaz |
| DNY-13 | SİL | OMR-37 | Listede eklenecek cümle yok; kaynak silindi. |
| DNY-15 | SİL | OMR-36 | Listede eklenecek cümle yok; kaynak silindi. |
| DNY-19 | TAŞI | SOY-13 | Kabul satırına Ek şart: Haber satırı kamuoyu barını tek başına değiştirmez. |
| DNY-28 | SİL | DEN-05 | Listede eklenecek cümle yok; kaynak silindi. |
| DNY-32 | TAŞI | DIY-09 | Kabul satırına Ek şart: Dünya işareti söz bağlamına dunya öneki ve olay kimliği olarak girer; motor yeni cümle üre |
| DNY-35 | SİL | OMR-50 | Listede eklenecek cümle yok; kaynak silindi. |
| DNY-44 | SİL | SRM-07 | Listede eklenecek cümle yok; kaynak silindi. |
| DNY-46 | SİL | GRV-15 | Listede eklenecek cümle yok; kaynak silindi. |
| DNY-47 | SİL | TEK-22 | Listede eklenecek cümle yok; kaynak silindi. |
| DNY-51 | SİL | SOY-31 | Listede eklenecek cümle yok; kaynak silindi. |
| DNY-58 | SİL | YIL-01 | Listede eklenecek cümle yok; kaynak silindi. |
| DNY-59 | TAŞI | DEN-01 | Kabul satırına Ek şart: Olay olasılığı dünya işaretini silmez. |
| DNY-67 | SİL | DEN-05 | Listede eklenecek cümle yok; kaynak silindi. |
| DNY-76 | SİL | OZL-25 | Listede eklenecek cümle yok; kaynak silindi. |
| DNY-81 | TAŞI | NBT-06 | Kabul satırına Ek şart: Nöbet ekranı çizelge işaretine yazmaz. |
| SEV-11 | SİL | ZAR-01 | Listede eklenecek cümle yok; kaynak silindi. |
| SEV-12 | TAŞI | KAY-04 | Kabul satırına Ek şart: Boş gün kayıtta bos türüyle durur; alan yoksa o gün yok sayılır. |
| SEV-21 | SİL | DIY-02 | Listede eklenecek cümle yok; kaynak silindi. |
| SEV-46 | TAŞI | DIY-03 | Kabul satırına Ek şart: Bağ için söz dalı yoksa doğrulayıcı hata yazmaz. |
| SEV-54 | SİL | YER-17 | Listede eklenecek cümle yok; kaynak silindi. |
| SEV-68 | SİL | GRV-15 | Listede eklenecek cümle yok; kaynak silindi. |
| SEV-69 | SİL | GIR-08 | Listede eklenecek cümle yok; kaynak silindi. |
| SEV-70 | TAŞI | TEK-22 | Kabul satırına Ek şart: Boş günde hız köy ekranının seçimidir; kapı kilidi uygulanmaz. |
| SEV-74 | SİL | KAP-16 | Listede eklenecek cümle yok; kaynak silindi. |
| SEV-78 | SİL | DEN-05 | Listede eklenecek cümle yok; kaynak silindi. |
| NBT-69 | TAŞI | YSM-03 | Listede hedef YSM-24 yazıyordu, böyle madde yok; NBT-69'un kendi bağımlılığı YSM-03 (gece evde uyku). Ek şart YSM-03'e yazıldı. |
| DNY-80 | TAŞI | DNY-01 | Hedef CAS-07 ROADMAP 1'de (salt okunur); cümle çizelge işaretini tanımlayan DNY-01'e Ek şart olarak yazıldı. |
| NBT-81 | SİL | ROADMAP 1 EKO-07 | Hedef ROADMAP 1'de (salt okunur) ve listede eklenecek cümle yok; kaynak silindi. |
| SAB-15 | SİL | ROADMAP 1 SYS-09 | Hedef ROADMAP 1'de (salt okunur) ve listede eklenecek cümle yok; kaynak silindi. |
| SAB-80 | SİL | ROADMAP 1 SYS-09 | Hedef ROADMAP 1'de (salt okunur) ve listede eklenecek cümle yok; kaynak silindi. |
| YSM-41 | SİL | ROADMAP 1 SYS-09 | Hedef ROADMAP 1'de (salt okunur) ve listede eklenecek cümle yok; kaynak silindi. |
| YSM-67 | SİL | ROADMAP 1 UZM-08 | Hedef ROADMAP 1'de (salt okunur) ve listede eklenecek cümle yok; kaynak silindi. |
| YSM-80 | SİL | ROADMAP 1 CAS-07 | Hedef ROADMAP 1'de (salt okunur) ve listede eklenecek cümle yok; kaynak silindi. |
| DNY-49 | SİL | ROADMAP 1 SYS-09 | Hedef ROADMAP 1'de (salt okunur) ve listede eklenecek cümle yok; kaynak silindi. |
| SEV-71 | SİL | ROADMAP 1 SYS-09 | Hedef ROADMAP 1'de (salt okunur) ve listede eklenecek cümle yok; kaynak silindi. |
