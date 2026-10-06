# Codex — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik
Codex — Godot kodu, veri sözleşmeleri, araçlar ve testler üzerinde çalışan ajan.

## Güncel durum
6 Ekim 2026. Taban: festive 8ba9956; çalışma dalı feature/kvr-runtime. Önceki yayımlanan commit: fb771bf. Her tur başında festive güncellemeleri kontrol edilir. Tamamlanan geliştirmeler ilgili kontrollerden sonra iki yerel kopyada eşitlenir, commit edilir ve ayrı komut beklemeden GitHub’a gönderilir. Başka ortamın festive+keen WIP'i bu çalışmaya alınmadı.

## Kapanan maddeler
- KVR-01: KarakterVerisi: entity_id, ad, sinif, fraksiyon, en_erken_tur sözleşmesi; eski id/en_erken_gece adaptörleri korunuyor. KVR Resource roundtrip ve mevcut 30 karakter regresyon testi başarılı.
- KVR-02: Şecere ve gündüz/gece davranışı kaynak anahtarlarıyla Resource alanlarına bağlandı; kayıt/yükleme ve veri izolasyonu testi geçti.
- KVR-03: obje_1/obje_2 sözlükleri ve StringName ipucu erişim adaptörü eklendi; iki ipucu roundtrip ve geçersiz nesne testleri geçti.
- KVR-04: Görsel hata ipucu, başlangıç tansiyonu ve poz anahtarları eklendi; 3/4 ve 7/8 eşikleri ile özelleştirilmiş animasyon Resource testi geçti.
- KVR-05: Düğüm/seçenek sözleşmesi, SYS-09 uyumlu metin anahtarları ve hedef/delta doğrulaması eklendi; kaynak izolasyonu ve bozuk zincir testleri geçti. CSV ve KAP-01 değiştirilmedi.
- KVR-06: Dört standart Flag sözlüğü ve sorgu başına izole kopya eklendi; bool tip/eksik/yabancı bayrak ve izolasyon testleri geçti.
- KVR-07: Beş kararın beş stat etkisi, kişisel akçe ve eşya alanları eklendi; eski bar API korunarak tip ve rüşvet ayrımı testleri geçti.
- KVR-08: Tipli gecikmeli olay dizisi ve pozitif tur/bina/olay/stat doğrulaması eklendi; negatif debuff roundtrip ve bozuk olay testleri geçti.
- KVR-09: Dört karar spawn sözlüğü ve kanonik CHR kimliği/pozitif offset doğrulaması eklendi; zincir roundtrip ve geçersiz veri testleri geçti.
- KVR-10: CHR derleyicisi 30 sayfayı doğrulayıp ayrı chr_runtime kaynakları üretiyor; 5 Python testi, 30 Resource kabul testi ve headless import geçti. Kaynak başlangıç tansiyonu 1–3 korunuyor; 93 harici spawn ID henüz kaynak sayfası olmayan referans olarak raporlanıyor. CSV/JSON kilidine dokunulmadı.
- KAP-04: CHR ziyaretine ayrı sorgu hafızası ve nişan inceleme paneli bağlandı; gerçek düğme tıklaması, tekrarlı inceleme ve ziyaret izolasyonu testi geçti. Mevcut heybe/JSON akışı korunuyor.
- KAP-05: Yük/gizli bölme eylemi ayrı ipucu üretiyor; nişanla karışmıyor ve geçersiz indeks reddediliyor. Panel inceleme sırasında alttaki ekranın tıklamalarını engelliyor; UI testi geçti.
- KAP-06: 2D portre tıklaması kaynak fiziksel iz açıklamasını ve görsel ipucunu açıyor; mevcut portre dosyası yeniden kullanılıyor. Üç ipucunun bağımsızlığı ve tekrarlı inceleme testleri geçti.
- KAP-07: CHR diyalog paneli eklendi; kanıt seçeneği UI ve model katmanında kilitleniyor, herhangi bir geçerli ipucuyla açılıp parlıyor. Kaynak dallar/flaglar ve sessiz koşullu düğümler yürütülüyor; kilit, UI açılma ve sır çözme testleri geçti.
- KAP-08: Tansiyon 8 panik/Flag_Kilitlendi oluşturuyor, kabul ve harç kapanıyor; yalnız zorunlu ret/kışla/rüşvet kalıyor. UI ve Oturum API engeli ile duygu adaptörü eklendi; eşik, kalıcılık ve yan etkisiz ret testleri geçti.
- KAP-09: Blöf/ikna olasılığı ayrı Resource kurallarında; tecrübe artırıyor, tansiyon düşürüyor. Denenmiş seçenek yeniden zar atamaz; başarısızlık tansiyon/panik doğuruyor. Deterministik zar, tecrübe ve başarısızlık testleri geçti; tecrübe kayıtla korunuyor.
- KAP-10: Replik başında özgün kısa foley ve konuşma animasyonu tetikleniyor; metal/ferman/bebek/kabza/deri/sikke sesleri üretildi. Panel yenilemesi sesi tekrarlamaz; ses dosyaları, eşleme ve tekrar engeli testi geçti.
- EKO-01: Kamu/kişisel kasa ayrıldı; eski akce kamu aliası olarak kaldı. Rüşvet ve eşyası muhafıza, el koyma/harç köye gidiyor; şüpheli rüşvetin asayiş etkisi korunuyor. Çift kasa/JSON roundtrip, heybe ve kapı karar testleri geçti.
- SYS-01: v2 kayıtları v3 çift kasa/mevsim/yeni bina alanlarına derin kopyada göç ediyor; köy/kadro/RNG korunuyor. İdempotent göç, eski JSON yükleme ve bozuk/gelecek sürüm reddi testleri geçti. Köy içermeyen eski v1 biçimi tahmini dönüşüm yerine güvenle reddediliyor.
- SYS-02: Ana kayıt doğrulanmış tmp üzerinden değişiyor; yedek de bak.tmp ile atomik güncelleniyor. Yarım tmp, bozuk ana dosya ve başarısız yedek rename ana kaydı koruyor. Atomik kayıt, köy yönetimi ve headless import testleri geçti; KayitDeposu aynı güvenli APIye bağlandı.
- SYS-03: Tansiyon 0–3 ney/kopuz, 4–7 yaylı ve 8–10 kudüm/davul temalı özgün üç müzik katmanı eklendi. Eşikler 0.7 saniyede geçiyor; aynı eşik döngüyü yeniden başlatmıyor. Çıkışta sesler duruyor; müzik katmanı ve gerçek kapı UI testleri geçti.
- SYS-04: Gündüz çekiç/koyun/su, gece meşale/kurt/baykuş temalı özgün döngüler Ambiance→Efekt bus ile bağlandı. Köyün gece fazı sesi değiştiriyor; çıkışta bus geri dönüyor. Faz/idempotent geçiş ve gerçek köy UI/ses kapanışı testleri geçti.
- SYS-05: Ses.oynat bool API ve optional autoload adaptörü eklendi; eski cal korunuyor. Eksik/null dosya, hazır olmayan havuz, bozuk havuz indeksi ve döngü oynatıcısı güvenle atlanıyor. Yeni güvenli ses ve mevcut ses regresyon testleri geçti.
- SYS-06: tools/sanity_check.py tek komutta CHR/Python/headless import, 18 Godot birim testi ve 2 izole UI sahnesini çalıştırıyor. Sıfır çıkış koduyla Script Error, eksik tamamlanma işareti veya timeout başarı sayılmıyor; timeout yalnız kendi süreç ağacını kapatıyor. Tam koşu: 0 başarısız.
- SYS-07: Headless import tarayıcısı hata mesajlarını res://dosya ve satır bilgisiyle JSON/log raporuna çıkarıyor. Script Error ve yükleme hatası süreç 0 olsa da başarısız; warning ayrı tutuluyor. Çoklu tanı/path testi ve gerçek headless tarama geçti.
- SYS-08: Korumalı kur/yuru/gece_sonu, sinyal payloadları, akce/kayıt sürümü ve klip önbelleği Git tabanına karşı doğrulanıyor. Silme/tip/imza değişimi reddedilir; biçim ve sürüm değeri değişimi serbest. 4 denetçi testi ve gerçek API taraması geçti; sanity komutuna bağlandı.
- SYS-10: İzole model koşusu tam 20 geceyi, her gece JSON kayıt roundtrip ve bellek ölçümünü doğruladı; mevcut otomatik oyuncuya yalnız ortam değişkeni adaptörü eklendi. Tam sanity koşusu: 18 Godot birim testi, 3 kabul/duman sahnesi ve Python kontrolleri başarılı; gerçek kullanıcı kayıtları korunur.
- SYS-15: DUMAN_TESTI_20 modu sabit 20 iterasyon çalışır ve hem gece hem gün 20 olmadan başarılı çıkmaz. SYS-10 ile aynı doğrulanmış pakettir; normal otomatik oyuncu modu korunur.
- SYS-14: Göç motoru açık _v2_v3 adımı ve N→N+1 döngüsüyle ilerliyor; sürüm atlaması/kesirli sürüm güvenle reddedilir. Kişisel alanların korunması, derin kopya, idempotent yükleme ve 20 gecelik JSON dönüşüm testi geçti.
- KVR-12: CHR bina adı sözlüğü tüm 30 sayfanın gecikmeli hedeflerini katalog türlerine eşliyor; birleşik Ağıl/Ahır iki hedef olarak korunur. Yeni CHR türleri inşa/üretim uygulaması gelene kadar kurulamaz; mevcut 8 yapı verisi aynen kaldı. Bina sözlüğü, köy regresyonu ve headless script taraması geçti.
- KVR-13: Runtime tansiyonu doğrudan yazım dahil 0–10 sınırında; karar anlık beş stat kopyaları ve koşullu varyantlar −4…+4 sınırında. Kaynak Resource ve kişisel kasa tutarları değişmez. Sınır, sorgu/panik, çift kasa ve headless script testleri geçti.
- KVR-14: Null kaynak, eksik/bozuk düğüm, seçenek, bayrak, nesne, animasyon ve karar alanları kaynak verisi değiştirilmeden güvenle okunuyor. Bozuk geçiş/eşya/kasa alanları eylem üretmez; boş profil karar ekranına izin verir. Tam sanity ve ek fallback/çift kasa regresyonu geçti.
- KVR-15: KarakterVerisi.dogrula ve hata listesi 30 derlenmiş profili yüklemede denetliyor: CHR kimliği, başlangıç tansiyonu 1–3 ve karar/varyant stat tipleri. Geçersiz kaynak Gelen adaptöründe sorguya bağlanmıyor; eski katalog korunur. 30 profil, kaynak 1 değerleri, bozuk profil, sorgu ve headless testleri geçti.
- KAP-11: IpucuYoneticisi ziyaret başına oturumdan bağımsız Clue kaydı sunuyor; mükerrer kayıt/sinyal, boş anahtar ve Flag reddedilir. ChrSorgusu inceleme adaptörleri bu servisi kullanır; dışa verilen sözlük kopyadır. Servis, gerçek sorgu/UI ve headless testleri geçti.
- KAP-12: 0–10 canlı tansiyon barı Sakin/Gergin/Panik eşik renkleriyle sorgu sinyaline bağlandı; kalıcı kabul kilidi açıklanıyor. Eşik, renk, değer clamp ve sahne çıkışı testleri geçti; gerçek kapı UI headless ve native görüntü kontrolü tamamlandı.
- KAP-13: Panikte Kabul düğmesi disabled olarak görünür ve gerekçesini gösterir; yalnız ret/kışla/rüşvet etkin kalır. Düğme/kısayol onay yolu ve doğrudan karar API'si kabulü yan etkisiz engeller. Gerçek kapı UI kabul testi ve korumalı API denetimi geçti.
- KAP-14: Nişan ve yük tıklaması kaynak fiziksel açıklamasını ayrı modal karta açıyor; alttaki girdi durur ve kapatma sorguya döner. Mevcut heybe akışı ve başka ajanın dosyaları korunur. Nişan/yük kartı, gerçek kapı native görüntü ve headless tarama testleri geçti.
- BUG-02: Sıra atlama kabulünde aynı Gelen ve model erase/push_front ile birlikte öne taşınır, model doğrudan kapı çizgisine yürür. Tekrarlı model adları indeksle taşınır; rüşvet kişisel keseye gider. En az iki kişi koşulu eklendi; gerçek 3D sıra atlama, ret, kasa ve mevcut kuyruk regresyonu geçti.
- KAP-15: BUG-02 ile aynı doğrulanmış entegrasyon paketi: gece listesi ve model kuyruğu eşleşir, öne alınan nesne kapıda yeniden yaratılmaz. Yeni gerçek sahne testi sanity paketine bağlandı; korumalı API denetimi geçti.
- BUG-04: Kapı noktasal gölge atlası en çok 2048; meşale ışık/gölge mesafe sönümü renderer üzerinden ayarlanır, kare başına uzaklık taraması eklenmez. Düşük kalite ve sahne açıkken değişen tercihler korunur; son kapı kapanınca atlas geri döner. Profil/çoklu sahne/ayar testleri, native kapı görüntüsü ve korumalı API denetimi geçti.

## Sonraki çalışma
BUG-05. İlk öncelik paketi (KVR-01…10 → KAP-04…10 → EKO-01 → SYS-01/02) tamamlandı. Kullanıcının dur talimatına kadar çakışmasız bekleyen ROADMAP maddeleri sırayla sürdürülür. KAP-01 kilitli; KAP-02/03 başka ajana ait aktif işlerdir. SYS-09 PR #2 birleşmeden CSV değiştirilmez. CHR sayfaları ve isimleri kaynak sözleşmeye göre korunur.

## Doğrulama ve kayıt
Her madde ilgili testler geçince ROADMAP'te [x] (Codex) olarak kapanır; OYUN_RAPORU güncellenir. Tamamlanan paketler otomatik commit/push kuralına göre kaydedilir. SYS-09 ayrı özellik dalı/PR #2 olarak korunur.
