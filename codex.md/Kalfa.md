# Kalfa — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik

Kalfa, Ahmet’in Codex’idir. Berk’in Codex’inden ayrıdır. Berk’in Claude’u da ayrıdır. İmza `(Kalfa)` olur. Günlük bu dosyadır.

Kalfa, Ahmet’in Windows bilgisayarında Codex Pro ile çalışır. Repo yolu `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi`. Tek oyun dalı `claude/festive-volta-li1sfm`.

## Görev

Muharrir’in ROADMAP 2 devri sürüyor. BUG-16…20/25 ve TEK-08/13/14/15/16/18 tamamlandı (Kalfa). Son yön: eldeki TEK-19/20 yükleme kontrolü kapanınca yeni Bölüm 41 maddesi alınmadan Faz 1 ACL-01'e geçilir; ardından ACL ve KAP-16…19 sırası izlenir. BUG-22 ACL-01'i bekler. Başka ajan sahipliklerine dokunulmaz. Her maddeden önce pull, sahiplik commit+push; hedefli testler ve olgun paket öncesi tek tam UTF-8 sanity. Commit mesajları Türkçe, madde kodları, (Kalfa) ve asset gerekmedi notu korunur.

## Roller

Ayrıntı `AGENTS.md` ve `CLAUDE.md` Roller bölümündedir. Kısa hali:

- Muharrir (Ahmet’in Grok Bot asistanı) sessiz koordinatördür. Blok böler, çakışma ve kural uyumuna bakar, pull ve uyum raporunu yazar. Duyuru `docs/MUHARRIR_RAPORU.md` başındadır; oradaki bölüşüm ve uyarı geçerlidir.
- Claude (Berk) zor ve kapsamlı işi alır, Berk’in Codex’inin işini test edip onaylar. Berk tarafının iç dağıtımı Claude ile Codex arasında sürer.
- Codex (Berk) kolay ve orta işi alır; zor iş Claude’da kalır.
- Kalfa, Muharrir’in verdiği ayrı bloğu alır.
- Cursor ajanları, Muharrir’in verdiği düzeltme ve doğrulama işini alır.

## İşe başlarken

Blok gelince, yazmadan önce:

1. `AGENTS.md`, `codex.md/SOUL.md`, bu dosya ve `docs/AJAN_KITLERI.md` okunur.
2. `ROADMAP.md` ve `docs/MUHARRIR_RAPORU.md` başı okunur. Başka ajanın `[/]` satırına yazılmaz. Berk’in Codex’i veya Claude’u aynı dosyada veya aynı maddede çalışıyorsa iş alınmaz; not Muharrir raporunun başına düşülür.
3. Sahiplenilen madde `[/] (Kalfa)` olur. Kapanış `[x] (Kalfa)` olur. Başka imzanın kapalı maddesi yeniden açılmaz.
4. Yeni iş yeni dosya ve ince adaptördür. Çekirdek dosya toptan yazılmaz.
5. `koy_sahnesi`, statik `KoyYerlesimi` ve eski full-RTS yolu üretilmez. Yol `KoyYonetimSahnesi` + `KoyYonetimi` kalır.
6. Asset üretilmez. 11 Ekim Berk/Ahmet güncellemesiyle uygun CC0/kamu malı/CC-BY hazır asset kaynak, yazar ve lisans kaydıyla eklenebilir. Bulunamazsa isim etiketli kutu veya düz renk kullanılır; ihtiyaç `docs/EKSIK_ASSET_ENVANTERI.md` G tablosuna aynı kapanışta yazılır. Asset gerekmiyorsa commit başlığında «asset gerekmedi» durur.

## Doğrulama ve duyuru

Commit öncesi `python -B tools/sanity_check.py --godot <Godot 4.7.2>` geçer. `SCRIPT ERROR` veya `Failed to load script` varken commit yok.

Push sonrası kısa duyuru `docs/MUHARRIR_RAPORU.md` başına yazılır. Bu dosyadaki durum da güncellenir.

## Güncel durum

11 Ekim 2026: BUG-25 takip + TEK-18 uygulama dd8f487; nihai tek tam UTF-8 sanity 345 PASS / 0 beklenmeyen hata / 20 gece. Material ömür 200→1, mevcut beş cache, aktif kaynak korunur. TEK-08/13/14/15/16 kapandı; sıradaki TEK-19/20. Pull güncel, reset/force yok. Asset gerekmedi. ds çalışma kopyası/ayna erişilemiyor; eşitlenemedi.

## Windows UTF-8 ve test çalışma kuralı — 10 Ekim 2026 (Kalfa)

Muharrir'in talimatı: Windows'ta Python araçlarını her zaman `PYTHONUTF8=1` ile çalıştır. PowerShell oturumunda `$env:PYTHONUTF8='1'` ayarlanır; gerekirse çıktı için `$env:PYTHONIOENCODING='utf-8'` kullanılır. İlk kurulum koşusunda varsayılan cp1252 kodlaması Türkçe `ı` ve `İ` karakterlerinde hata verdi. UTF-8 ortamıyla CSV doğrulaması ve 28 Python testi geçti.

Küçük işlerde yalnız ilgili birim veya sahne testi çalıştırılır. Tam sanity yalnız commit/push öncesi bir kez çalıştırılır; mevcut kurulum koşusunun tamamlanması Ahmet tarafından ayrıca istendi. Bu not commit edilmez; bir sonraki görevle birlikte commit edilir. ROADMAP maddesi alınmadı; görev bekleniyor. Asset gerekmedi.

## ROADMAP 2 başlangıcı — 11 Ekim 2026 (Kalfa)

Kontrol edilen festive commit: 0530d05. Muharrir Faz 0 görevini verdi. BUG-16 olay ön koşul denetimi sahipleniliyor; sonraki adım mevcut olay seçicisini incelemek, hedefli test ve kapanış öncesi UTF-8 tam sanity. Asset gerekmedi. ds çalışma ve GitHub ayna yolları bu bilgisayarda bulunmuyor; eşitlendi iddiası yok. Yerel untracked dosyalar korunur.


## BUG-16 kapanışı — 11 Ekim 2026 (Kalfa)

Sahiplik commit: 88ad820. Yeni olay_on_kosulu denetçisi mevcut seçiciye/kataloğa birer satırla bağlandı. Bina/nüfus/çocuk/yaş koşulları, bilinmeyen koşul hatası, 34 kartın bina taraması ve 13 kartın koşul düzeltmesi tamamlandı. Hedefli test: 100 gecede ambarsız kart 0, hazır bina/yaş, boş havuz, kayıt sonrası yeniden denetim ve aynı RNG kimliği. Python 40 test; tam sanity 328 PASS / 0 hata / 20 gece. Asset gerekmedi. Sonraki iş BUG-17, önce pull ve sahiplik push. ds ayna yolu yok; eşitlenemedi.


## BUG-17 sahipliği — 11 Ekim 2026 (Kalfa)

Pull kontrolü: 968c83e. BUG-16 kapandı ve push edildi. BUG-17 sabah pusulasında gerçek bina ve yaşayan kişi süzgeci; mevcut FisiltiGazetesi kaydı genişletilir, ikinci liste yok. Hedefli yer testi ve kapanış öncesi tek tam sanity. Asset gerekmedi; ds ayna erişilemiyor.

## BUG-17 sırasında pull — 11 Ekim 2026 (Kalfa)

ffe2e4b güvenli fast-forward ile alındı. Claude'un ROADMAP 2 temizliği ve Tester raporları korundu; oyun kaynaklarında uzak değişiklik yok. BUG-17 sahipliği Kalfa'da, hedefli fısıltı/divan/muhafız testleri geçti; tek tam sanity sürüyor. Arşiv temizliği üzerinde yerel düzenleme yapılmadı. Asset gerekmedi; ds ayna yolu yok.

## BUG-17 doğrulama düzeltmesi — 11 Ekim 2026 (Kalfa)

İlk tam koşuda iki sahnenin kayıt eşitliği kaldı; diğer kontroller ve 20 gece geçti. Tani çıktısı levent_firari_kontrol farkının yalnız gorulen_olaylar ve RNG olduğunu doğruladı: UI olay seçicisini atlayan alt sınıf kullanıyor, restore gerçek Oturum kullanıyordu. İki fixture gerçek Oturum ve ortak sıfır olay olasılığına geçirildi; ölüm/ödül ve tam kayıt eşitliği iddiaları korunarak iki hedefli sahne geçti. Başarısız loglar work/sanity içinde korunuyor; nihai tam koşu work/sanity-bug17-final içinde. Ajan Masası'na sorun ve çözüm yazıldı. Oyun motorundaki kayıt/RNG akışı bu fixture düzeltmesi için değiştirilmedi.

## BUG-17 kapanışı — 11 Ekim 2026 (Kalfa)

Sahiplik 5f5ce8a; son pull 6f95634 (yalnız Tester raporları değişmişti). Pusulada {yer} yalnız mevcut hazır binadan seçilir; binasız köy, yanan/yıkılan bina ve ölen/ayrılan kişi kart üretmez. Mevcut kişi/bina kaydı ve FisiltiGazetesi kaydı kullanıldı, ikinci liste/sayaç/RNG eklenmedi. Hedefli 30 gece yer testi, fısıltı/divan/muhafız kontrolleri ve iki kayıt sahnesi geçti. Nihai UTF-8 tam sanity 329 PASS / 0 hata / 20 gece (work/sanity-bug17-final). Asset gerekmedi. ds ayna yolu yok; eşitlenemedi. Sonraki iş BUG-18, önce pull ve sahiplik push.

## BUG-18 sahipliği — 11 Ekim 2026 (Kalfa)

Pull kontrolü ed34d70; BUG-17 push edildi. BUG-18 için veri ayarlı tehdit başlangıcı, mevcut adlı aday/ağırlık akışı ve baskın/sabotaj tetiklerine ince adaptör. Gerçek gün kaydı okunur; Moğol, ulak ve diplomatik heyet ayrı kalır, debug doğal takvimi artırmaz. Önce sınır/kayıt testleri, sonra ilişkili regresyonlar; kapanış öncesi tek UTF-8 tam sanity. Asset gerekmedi; ds ayna yok.

## BUG-18 hedefli doğrulama — 11 Ekim 2026 (Kalfa)

Sahiplik ee0112e; pull hâlâ güncel. Yeni test önce erken geliş/fiil hatalarını gösterdi, adaptörden sonra geçti. Varsayılan 14, gerçek gün kaydından okunur; HAR-11 risk profilleri yeniden kopyalanmadı. Aday/ağırlık, doğal sabotaj/hırsızlık/baskın kapıları; erken husumet sönümü devam eder. Geçici debug baskın izni kayda girmez ve koşu sonunda temizlenir. CAS kaynak tur-offset fixtureları yeni alışma kapısından bağımsız koşar; iddialar korunur. 27 hedefli birim/sahne kontrolü geçti (work/bug18-target-final). Tasarım/kanıt docs/denetim/BUG-18-tehdit-takvimi.md; kapanış öncesi tek UTF-8 tam sanity başlıyor. Asset gerekmedi; ds ayna yok.

İlk tam koşu erken durduruldu: hedefli taramada atlanan HAR-08 çete anlaşması fixture'ı da ilk günde baskın üretmek istiyordu. Kaynak süre/ganimet testi alışma ayarından ayrıldı, iddiaları korundu. Çete birim ve gerçek UI testi geçti; hedefli toplam 29. Baskın çağrı noktaları yeniden tarandı. İlk kısa koşu work/sanity-bug18-final içinde saklandı; nihai koşu work/sanity-bug18-final-2 içinde çalışıyor.

BUG-18 koşusu sırasında f314e57 güvenli fast-forward ile alındı; yalnız Tester belgeleri değişmişti, oyun kaynaklarına uzak değişiklik yok. TUR-011, yayımlanan BUG-17'yi bağımsız kenar senaryolarıyla doğruladı. Tester dosyalarına yerel düzenleme yapılmadı; BUG-18 nihai koşusu sürüyor.

## BUG-18 kapanışı — 11 Ekim 2026 (Kalfa)

Son pull f314e57; sahiplik ee0112e. Tehdit başlangıcı JSON'da 14; mevcut tamamlanan gün okunur, doğal riskli adaylar ve sabotaj/baskın tetikleri erken çalışmaz. Normal husumet sönümü sürer. Moğol/resmi bildiri/heyet engellenmez; debug izni geçici ve kayda yazılmaz, eski gün geri sarılmaz. 29 hedefli kontrol + nihai UTF-8 tam sanity 330 PASS / 0 hata / 20 gece (work/sanity-bug18-final-2). API/import/CSV ve Python denetimleri geçti. Kaynak zaman/ganimet fixtureları bağımsız denetlendi; mevcut sonuç/RNG iddiaları korundu. Asset gerekmedi; ds ayna hâlâ yok, eşitlenemedi. Sonraki iş BUG-19; önce pull ve sahiplik push.

## BUG-19 sahipliği — 11 Ekim 2026 (Kalfa)

Pull kontrolü a636768; BUG-18 push edildi. Beş sıra olayının metni canlandırılan gerçek sıra modelinin cinsiyet/yaşını okuyacak; eksik bilgiye kişi/cinsiyet tahmini yapılmayacak, biri denecek. Yeni helper + ince sahne/UI adaptörü ve CSV anahtarları; boş sıra olay başlatmaz. Hedefli 100 deneme ve gerçek sıra sahnesi, kapanış öncesi UTF-8 tam sanity. Asset gerekmedi; ds ayna yok.

## BUG-19 uygulaması — 11 Ekim 2026 (Kalfa)

Sahiplik e32dda5. Beş sıra olayı gerçek kuyruk modelinin cinsiyet/yaş metadatasını okur. Metin ve animasyon ortak indeks kullanır; kapsül/bilinmeyen cinsiyet “biri”, çocuk “bir çocuk”. Model cinsiyeti mevcut tools/model/chr_istemleri.py tanımlarından veri olarak alındı; bu araç çalıştırılmadı, asset üretilmedi. Yaş kaynağı mevcut YasRolleri. CSV anahtar bazında değişti. 500 deneme, kuyruk/çeviri hedefli testleri ve gerçek sahne geçti. Nihai UTF-8 tam sanity 331 PASS / 0 hata / 20 gece (work/sanity-bug19-final). Muharrir son talimatı: önce uygulama commit, sonra merge pull, ardından ROADMAP kapanışı/push. Asset gerekmedi. ds ayna yolu tekrar kontrol edildi, mevcut değil; eşitlenemedi.

## BUG-19 kapanışı ve festive merge — 11 Ekim 2026 (Kalfa)

Uygulama d1e851e: tek tam sanity 331/0/20 gece. Festive'deki 14 commit merge ile alındı; CSV sonundaki farklı anahtarlar birlikte korundu. Untracked iki UID zaten aynı içerikteydi; yerel kopyaları work/bug19-pull-untracked-uids altında saklandı. Merge sonrası 11 hedefli kontrol geçti; yeni köprü/taş yatağı/nüfus akışı dahil. Tam koşu merge öncesi uygulamaya aittir, tüm yeni festive için tam koşu iddiası yok. Asset gerekmedi. ds ayna yolu yok. BUG-19 kapanış/push sonrası ilk boş Faz 0 maddesi BUG-20 sahiplenilir; BUG-21/23/24 ve TEK sahiplikleri korunur. Yeni kullanıcı kuralı: asset üretmek yasak, hazır CC0/CC-BY asset ancak kaynak/lisans kaydıyla; testlerde res://work yolu yok, aynı anda tek tam sanity.

## BUG-20 sahipliği — 11 Ekim 2026 (Kalfa)

Pull: 1032861. BUG-19 kapandı. BUG-20 sıra bayılma seçiminin gerçek sonuçları: veri ayarlı ölüm/sakatlık/ayrılma/toparlanma, gerçek yardım bedeli, mevcut cenaze ve gece raporu, aynı Gelen ile sakatlık kabulü. Yeni yardımcı + ince adaptör; asset gerekmedi. Sahiplik commit/push sonrası uygulama. Diğer ajanın BUG-23/24 ve TEK işlerine dokunulmaz; BUG-22 ACL-01 bekler.

## BUG-20 uygulaması ve hedefli doğrulama — 11 Ekim 2026 (Kalfa)

Sahiplik 781d88f. Sonuç JSON'u ve yeni yardımcı mevcut gerçek kuyruk kişisini okur: ölüm/ayrılma listeden çıkar, sakat kabul 35 sağlık, yardım mevcut 1 erzak. Çift seçim/ikinci bayılma kilidi, optional pending gece raporu ve Gelen snapshot makbuzu var. Ölüm adı mevcut sağlık taraması sonrası olenler listesine girer; duran CenazeYasi çağrısı bir kez çalışır. 1000 zar 149/265/258/328, tüm sapmalar yüzde3 altında. Beş sonuç gerçek UI düğmeleriyle geçti; toplam 17 hedefli kontrol 0 hata (kaynak/API, kayıt/bilanço/cenaze, sıra/snapshot ve iki kriz sahnesi dahil). Sonraki adım tek tam UTF-8 sanity. Asset gerekmedi; ds ayna yok, eşitlenemedi. Testlerde res://work yok.

BUG-20 nihai tek tam UTF-8 sanity: 338 PASS / 0 hata / 20 gece; work/sanity-bug20-final. Uygulama commit sonrası yeni festive commitler merge ile alınacak. Asset gerekmedi.

## BUG-20 kapanışı ve entegrasyon — 11 Ekim 2026 (Kalfa)

Uygulama f4c19bc öncesi tek tam sanity 338/0/20 gece. Sonraki üç festive commit çakışmasız merge edildi; yeni tarla ve navigasyonla 10 hedefli kontrol geçti. Tam koşu merge öncesi uygulamaya aittir; yeni festive'nin tümüne yeni tam koşu iddiası yok. Başka ajan imzaları/kuralları korundu. Asset gerekmedi; ds ayna tekrar kontrol edildi, yok. Kapanış push sonrası BUG-25 için pull/sahiplik yapılır.

BUG-20 push yarışı: b023973 kamera kapanışı pull ile alındı; CSV'de sıra sonucu/kamera ekleri birlikte korundu. Ek 7 hedefli kontrol 0 hata (CSV/kaynak/import, kamera/sonuç birimleri, gerçek sonuç/köy sahneleri). BUG-24 Codex imzası ve TEK sahiplikleri korundu. Force/reset yok; tam koşu uygulama f4c19bc'ye ait 338/0/20 gece, iki merge sonrası 10+7 hedefli kontrol. Asset gerekmedi.

## BUG-25 sahipliği — 11 Ekim 2026 (Kalfa)

Pull: ebb4c33. BUG-20 kapandı ve push edildi. İlk boş, bağımlılığı hazır Faz 0 işi BUG-25: mevcut iki meşalenin alev/ışık soketi ve kuyu zemin/yükseklik dönüşü. Model üretilmez; mevcut nesneler ve ışık/gece görüşü korunur. Hedefli gerçek sahne ölçümü ve görünür doğrulama, kapanış öncesi tek tam sanity. Gereken asset varsa envanter; aksi halde asset gerekmedi. BUG-22 ACL-01 bekler; TEK sahipliklerine dokunulmaz. ds ayna yok.

## BUG-25 uygulaması — 11 Ekim 2026 (Kalfa)

Sahiplik 9d51959 push edildi. İki kapı ışığı ve alev ortak Marker3D soketinde; JSON sahne ayarı. Mevcut kuyu modeli 1,20 m, taban sıfır ve nötr taş malzemesi. Gerçek çiftçi baş kemiği 1,45 m; iskeletli mesh ham AABB yanlış boy referansıdır. Su/ekonomi/RNG sistemleri değiştirilmez. Hedefli ve görünür sahne doğrulaması sürüyor; tam sanity henüz başlamadı. Asset gerekmedi. ds ayna erişilemiyor; eşitlenemedi.

BUG-25: nihai tam UTF-8 sanity 342 PASS / 0 hata / 20 gece. İlk koşunun renderer hatası tek malzeme atamasıyla düzeltildi; çınar üç tekrar ve tam koşuda geçti. Uygulama commit ve festive merge sırası başlıyor. Asset gerekmedi, ds ayna yok.

BUG-25 uygulama 06cb592. Pull/merge: testx yetim import temizliği ve Codex TEK-06/TEK-12 sahipliği çakışmasız alındı; bu maddelere dokunulmaz. Merge sonrası import/karakter/kuyu/çınar/sulama açılış hedefli kontrolleri sürüyor. Sonraki hazır boş aday TEK-08 (karar kaydı), KRI-10 zaten tamam.

BUG-25 uygulama 06cb592: iki kapı meşalesinin alev/ışık/soket farkı dört sur seviyesinde 0; mevcut kuyu taban 0,00 m, tepe 1,20 m, gerçek çiftçi başı 1,45 m. Görünür sahne ve 10 hedefli kontrol geçti. İlk renderer malzeme hatası tek atamayla düzeltildi; çınar üç tekrar + nihai tam koşuda geçti. Nihai UTF-8 sanity 342 PASS / 0 hata / 20 gece (uygulama öncesi), festive import temizliği/sahiplik merge sonrası 9 hedefli kontrol geçti. Kanıt docs/denetim/BUG-25-kapi-kuyu-donusu.md. Asset gerekmedi; ds ayna yok, eşitlenemedi. Sonraki boş hazır Faz 0 teknik borç TEK-08; BUG-22 ACL-01 bekler, TEK-06/12 Codex sahipliği korunur.

TEK-08: pull güncel f41e1b8; ilk hazır boş Faz 0 teknik borç. ADV-05 dolaylı kuluçka ipucu kabul edilmiş karar olarak docs/denetim içine yazılacak. KRI-10 formülü değişmez, yeni bonus/ikinci sistem yok. Asset gerekmedi. TEK-06/12 Codex sahipliği nedeniyle atlandı; TEK-03/05/09 bağımlılık bekler.

TEK-08 / ADV-05 karar olarak belgelendi: gizli kuluçka çözülmeden kenetlenme bonusu verilmez; bonusun gelmemesi dolaylı ipucu olarak kabul edilir, kişi ifşa edilmez. KRI-10 yeniden kurulmadı, yeni bonus yok. Oyun src/data/tools/tests ve bonus formülü diff 0; mevcut birim + gerçek UI 2 PASS / 0 hata. Az önceki tam sanity 342/0/20 gece ve merge sonrası 9 kontrol kanıtı geçerli; yalnız belge için tam koşu tekrarlanmadı. Kanıt docs/denetim/TEK-08-ADV-05-karar.md. Asset gerekmedi; ds ayna erişilemiyor, eşitlenemedi. Sonraki hazır adaylar aynı 41.3 alt başlığındaki TEK-13/14/15; pull sonrası sahiplik kontrol edilecek.

TEK-13/14/15: pull 9cf9185 güncel; aynı 41.3 alt başlığındaki S boyutlu mevcut bellek/efekt kontrol maddeleri birlikte alındı. Beş cache sözleşmesi, düşük profil sahne geçişi ve tek mevcut efekt temizliği doğrulanacak. İkinci önbellek/havuz/performans motoru yok. Asset gerekmedi; ds ayna erişilemiyor.

TEK-13/14/15: 5 hedefli kontrol geçti; tam beş cache/sayı sözleşmesi, üç gerçek düşük profil geçişi, aynı ses havuzu ve kapalı performans şeridi. Oyun src/data diff 0; yalnız test ve sanity sahne listesi genişletildi. Yeni kaynak/cache/asset yok. Nihai tam UTF-8 koşu başlıyor.

TEK-13/14/15 nihai tam sanity 343 PASS / 0 hata / 20 gece. Test paketi olgun; uygulama commit, pull/merge ve kapanış sırası. Oyun src/data diff 0, asset gerekmedi; ds ayna yok.

TEK-13/14/15 test paketi a33c874: beş cache dönüş anahtarı/sayıları, gerçek Ana._goster yolunda üç düşük profil geçişi, ertelenmiş karelerde ikinci temizlik olmaması, aktif kliplerin korunması, kapalı performans şeridi ve aynı gerçek ses havuzu doğrulandı. Oyun src/data diff 0; ikinci önbellek/havuz/motor yok. 5 hedefli kontrol + tek tam UTF-8 sanity 343 PASS / 0 hata / 20 gece. Pull güncel, ek merge gerekmedi. Kanıt docs/denetim/TEK-13-14-15-bellek-efekt.md. Asset gerekmedi; ds ayna yok, eşitlenemedi. Sonraki hazır boş Faz 0 teknik borç TEK-16; TEK-17 KLT-10 bekler. BUG-22 ACL-01 bağımlılığı sürüyor.

TEK-16: pull d18e781 güncel, TEK-01 testx tarafından kapalı. Son tam 343/0/20 gece loglarında SCRIPT ERROR sayımı yapılacak; aynı kaynak/test/ayar ağacına ait temiz koşu kanıtı korunur. Hata bütçesi/istisnası değiştirilmez, asset gerekmedi.

TEK-16: TEK-01 kapalı; son tam UTF-8 sanity 343 PASS / 0 hata / 20 gece loglarında SCRIPT ERROR 0, Parse Error 0, Failed to load script 0, ERROR 0, KALDI 0. Kaynak/test/ayar ağacı a33c874 ile aynı; yalnız belge için aynı tam koşu tekrarlanmadı. Hata toleransı/istisnası eklenmedi, ikinci doğrulayıcı yok. Kanıt docs/denetim/TEK-16-sanity-hata-butcesi.md. Asset gerekmedi; ds ayna erişilemiyor, eşitlenemedi. TEK-17 KLT-10 bekler; sıradaki hazır aday TEK-18.

TEK-18: pull db2fafe güncel; bozuk ayar yüklemesinde varsayılanlarla gerçek menü kabul testi. Kullanıcı ayarına dokunmadan pid ile adlandırılmış user:// test cfg kullanılır. Beklenen hata kayıtları ayrı çocuk süreçte yakalanıp kesin doğrulanır; genel sanity hata bütçesi değişmez. Oyun src/data değişmez, asset gerekmedi.

TEK-18: 4 hedefli kontrol geçti; bozuk pid adlı test cfg sonrası gerçek menü ve varsayılanlar. Çocuk süreçte yalnız iki kesin beklenen config hatası kabul; genel sanity regex değişmedi, engine hataları susturulmadı. Src/data diff 0; test fikstürü/çocuk kontrolü sanity listesine eklendi. Tek nihai tam UTF-8 sürüyor, asset gerekmedi.

BUG-25 takip düzeltmesi: TEK-18 tam koşusunda kriz sahnesinin oyun iddiaları geçti fakat kuyu materyali RID hatası tekrarlandı. Önceki tek atama düzeltmesi aralıklı sorunu tamamen gidermemiş; kendi BUG-25 maddem tekrar [/] alınır. Pull 63b1bbe güncel. TEK-18 testi ve 20 gece geçti ancak tam koşu 1 hata ile başarısız sayılır, kapanmaz. Kuyu materyalinin yenileme yaşam süresi mevcut Pbr cache içinde incelenecek; ikinci cache yok, diğer ajan sahiplikleri korunur.

BUG-25 takip: 200 yenilemede 200→1 Material; mevcut Pbr cache, beş cache temizliği ve aktif kuyu referansı. Ömür/ölçü/düşük bellek/gerçek geçiş 4 kontrol, kriz 3 + çınar 3, API/negatif cfg/import geçti. Material isteğe bağlı beşinci parametre eski çağrıları korur. BUG-25 ve TEK-18 kapanışları için tek yeni nihai tam UTF-8 koşu başlıyor; source sabit. Asset gerekmedi.

BUG-25 takip + TEK-18 nihai tam 345 PASS / 0 beklenmeyen hata / 20 gece. Material ömür 200→1, mevcut beş cache, aktif referans korunumu; kriz/çınar tekrarlar ve tam koşuda geçti. Negatif cfg/gerçek menü geçti, iki kasıtlı config kaydı ayrı; genel hata bütçesi değişmedi. Uygulama commit, pull ve kapanış sırası. Asset gerekmedi; ds ayna yok.

BUG-25 takip ve TEK-18 uygulama dd8f487. Aralıklı kuyu Material RID hatası için mevcut Pbr cachede aynı renkte tek malzeme paylaşılır: 200 yenilemede 200→1; memory_free yine beş cachei temizler, aktif kuyu korunur. Kriz/çınar üçer hedefli tekrar ve nihai tam koşuda geçti. Bozuk pid adlı ayrı test cfg sonrası tüm varsayılanlar ve gerçek menü açık; negatif çocuk süreçte tam iki kasıtlı config kaydı doğrulanır, genel hata bütçesi değişmez. Ömür/ölçü/bellek/geçiş 4 kontrol, kriz/çınar 6 tekrar, API/negatif cfg/import geçti. Nihai tek tam UTF-8 sanity 345 PASS / 0 beklenmeyen hata / 20 gece. Önceki başarısız koşu kanıt olarak korunur; pull güncel, merge gerekmedi. Kanıt docs/denetim/BUG-25-kapi-kuyu-donusu.md ve TEK-18-bozuk-ayar-menu.md. Asset gerekmedi; ds ayna yok, eşitlenemedi. Sonraki hazır aday TEK-19/20 yükleme kontrolü; faz döngüsü sorusu Ajan Masası’nda.

TEK-19/20: pull 44cadd1 güncel; aynı yükleme alt başlığında bağlı iki S kontrol birlikte alınır. Mevcut giriş akışı testine ilk gerçek menü tıklaması, panel sayısı 0, tek kapı ekranı ve bitişte serbest bayrak kanıtı eklenecek. Kullanıcı kaydı/ayarı yazılmaz; oyun API/source yeniden yazılmaz. TEK-21 YER-02 bekler. Asset gerekmedi.

TEK-19/20: hedefli gerçek giriş sahnesi geçti; panel sayısı sıfır, ilk gerçek fare tıklaması ayar ekranına ulaşır, iki kapı çağrısı tek ekran kurar, bitişte yükleme bayrağı false. Üretim kaynakları/API değişmez. Kullanıcı ayarı ve kaydı yazılmaz. Commit öncesi tek tam UTF-8 sanity work/sanity-tek19-20-final sürüyor. Asset gerekmedi; ds ayna erişilemiyor.

Muharrir yönü alındı: BUG-25/TEK-18 kapalı; önceden alınmış TEK-19/20 bitince yeni TEK alınmadan ACL-01'e geçilir. Commit mesajları Türkçe, madde kimlikleri ve asset gerekmedi korunur. TEK-19/20 ilk tam koşusu kıtlık fikstürünün yarım kalan karakter yüklemesi yüzünden çıkış sızıntısıyla kaldı; fikstür Ana bayrağına ek tüm yükleme panellerini bekler. Üç hedefli tekrar geçti; yeni nihai tam koşu work/sanity-tek19-20-final-2 sürüyor. Oyun src/data değişmedi.

TEK-19/20 nihai tam UTF-8 sanity 345 PASS / 0 beklenmeyen hata / 20 gece; giriş ve kıtlık geçişi temiz. İlk başarısız loglar korunur. Uygulama commit, pull ve kapanış yapılır; yeni TEK alınmaz, ACL-01 sırada. Asset gerekmedi; ds ayna erişilemiyor.
