# KRI-04 — Su kuyusu kirlenmesi ve kireçleme

9 Ekim 2026 · Codex uygulaması; Claude Code incelemesi/kapanışı bekleniyor. ROADMAP `[/]` korunur.

## Tek su kaynağı ve tetikleyiciler

`SuDengesi` gece arzını **mevcut meydan kuyusundan** hesaplar. `su_kuyusu` katalogda kurulamaz CHR hedef kaydıdır; yeni kuyudan üretim/ayrı depo kurulmaz. `KuyuKirliligi` bu aynı ortak kaynağa üç gecelik durum ekler. Var olan CHR kuyu/su arkı kayıtları bu kaynağın bilgi erişimidir. Kireç kuyusu (`kirec_kuyusu`) su kuyusu sayılmaz.

- **CAS-03:** Yalnız gerçek zehir fiili uygulanınca kirletir. Kapıda sır çözümü, yükün güvene alınması, kışla, tur/ofset, uygunluk, kaynak tek makbuzu, taze kullanıcıya ani zehir hasarı ve CAS gözlem/tutanak yolu değişmez. Temizlik CAS karar/fiil/kanıt kayıtlarını silmez. Gizli fail adı veya CHR kimliği kuyu durumunda/panelinde tutulmaz; sağlık raporu fail kanıtı değildir.
- **ADM-14:** Mevcut `kuyu` enjektörü aynı kirliliği başlatır. Eski üç gecelik −25 sağlık debug etkisi korunur; acil dezenfeksiyon kalan debug zehir sayacını da durdurur. Debug'ın açtığı eski `hasta` bayrağı sessizce silinmez. Kirlilik alanı olmayan eski kayıt eski debug davranışını korur; yeni tifo kendiliğinden üretilmez.
- **MEV-06:** Kırık bent her gerçek gecede aynı kuyuyu yeniden kirletir. Mevcut −3 sağlık, olay kartı ve 4 taş + 2 kireç onarımı korunur. Onarımdaki kireç kirlenmeyi **ek bedelsiz** temizler. Yalnız acil kireçleme bendi onarmaz; kırık bent ertesi gece tekrar kirletir.
- **Hasta yoğunluğu:** Serbest, yaşayan ve mevcut `temas_edebilir` kapısına uygun kişilerin en az üçünde ve en az %25'inde **açık** enfeksiyon belirtisi olması. Gizli kuluçka sayılmaz. Eşik aşağıdan yukarıya geçildiğinde kirlenir; aynı yoğunlukta temizlik ertesi gece geri alınmaz. Eşik düşüp yeniden yükselirse yeni kirlenme olabilir. Yoğunluk mevcut tedavilerden sonra, su/sağlık sınırında değerlendirilir.

Gün D'de kirlenme D, D+1 ve D+2 su gecelerini kapsar; D+3'te biter. Yeni gerçek kirlenme bugünden üç geceye yeniler; süre biriktirmez. Aynı gece kirlilik makbuzu tekrar zar/vaka/raporu engeller.

## Tifo mevcut sağlık motorunda

`SaglikYoneticisi.AYAR.tifo`: **5 gün**, **%25 su riski**, gecelik **−10 sağlık**. Tifo kişiler arasında ev/iş temasıyla bulaşmaz; kuluçka, sağlık, doğal iyileşme, ölüm, hekim, ilaç ve ortak Şifahane kontenjanı mevcut KRI-01/02/03 yollarıdır.

Kirli kuyuda yalnız `SuDengesi.gece` raporunun **taze** akışını kullanan ilk N köylü risk altındadır: `N = min(nüfus, ceil(taze / kişi_su))`. Kişi su miktarı MEV-07 yaz/kuraklık çarpanını içerir. Sıra mevcut CAS su kullanım sırasıdır; yeni kullanıcı dağıtımı/su sayacı yoktur. Önceden ayrılmış rezerv ve susuz kalanlar zar çekmez. Zindan, dış görev, ölüm ve karantina mevcut temas kapısıyla kuyu rutininden çıkarılır; karantinanın bakım suyu bu taze yolunda değildir. Enfekte kişiye ikinci hastalık veya süre eklenmez.

**Ortak gece sınırı:** KRI-01 temas motoru yeni vaka sayısını döndürür; su aynı iki yeni vaka tavanının kalanını kullanır. Temas iki yeri doldurduysa ek su zarı yoktur. Temiz kuyu, sıfır taze akış veya uygun kullanıcı yoksa RNG çekilmez. Risk yalnız mevcut yönetim `_rng` ile çekilir; sorgu/yükleme/kireçleme RNG kullanmaz. Yeni su vakası aynı gecenin temas kaynağı olamaz.

Su gecesi belirti fazından sonra gelir: yeni tifo mevcut gizli `enfeksiyon` kuluçkasıyla başlar; sonraki sağlık gecesinde belirti ve tek sağlık hasarı açılır. Zaten açık eski `hasta` bayrağı (ör. debug) varsa kart bu açık belirtiyi gizlemez. Yetkin hekim mevcut ×0,20 çarpanıyla tifo hasarını 10→2 yapar. Şifahane sonraki tedavi fazında 1 ilaç/+25 veya ilaç yoksa 2 erzak/+10 ile aynı enfeksiyonu iyileştirir; karantina tedavi değildir.

## Oyuncu bilgisi ve dezenfeksiyon

Meydan kuyusunun hücresine tıklamak mevcut **bina bilgi alanında** kuyu durumunu açar. Aynı bilgi varsa hazır CHR `su_kuyusu`/`su_arki` kaydında ve mevcut pazar su hizmetinde görünür. Su tooltip'i aynı durumu gösterir. Panel kalan geceyi, su riskini, kireç stoğunu ve **“Kuyuyu dezenfekte et · 2 kireç”** düğmesini verir. Hasta kartının mevcut salgın satırı yalnız açık belirti varsa **“Tifo · su kaynaklı · kişiler arasında bulaşmaz”** bilgisini gösterir.

Bedel mevcut EKO-05 stoğundan atomik **2 kireç**tir. Temiz/bitmiş oturum/olmayan veya hazır olmayan bina/yetersiz kaynak/bayat düğme reddi kaynak, RNG ve hastayı değiştirmez. Çift tıklamada yalnız ilk işlem tüketir. Dezenfeksiyon kaynağı temizler; mevcut tifo hastasını iyileştirmez, CAS failini açıklamaz ve kanıtı silmez. Kirli kuyudan yeni temiz rezerv ayırma `doldurabilir()` kapısında durur; önceki ambar suyu değişmez. Temizlenince rezerv hizmeti yeniden açılır.

## Kayıt ve doğrulama

Yönetimde optional `kuyu_kirliligi = {baslangic, bitis, son_gece, yogunluk}`; köylüde mevcut optional `enfeksiyon.tur = tifo`. Kayıt sürümü değişmez. Sonlu/tam/bounded sayılar, en fazla üç gecelik aralık ve gerçek bool kabul edilir. Eksik/bozuk/gelecek/süresi bitmiş kirlilik temiz açılır. Süresi bitmiş durum sorgu/kayıt/yüklemede aynı normalize edilir. Aktif kayıt gün kurulduktan sonra doğrulanır; kimlik tutulmaz.

Yeni helper/panel: `src/koy/kuyu_kirliligi.gd`, `src/arayuz/koy_hud/kuyu_kirecleme_paneli.gd`. İnce adaptörler sağlık, su, CAS, debug, taşkın, yönetim kayıt/gece ve KoyEkrani bilgi alanındadır. Bina bilgisinin eski çocukları yenilemede hemen parent'tan ayrılır; aynı karede düğme adı çakışmaz.

`tests/unit/kvr/kuyu_kirliligi_test.gd`: taze/rezerv/yaz, deterministik RNG/ortak kota, süre/tekrar, kuluçka/temas, hekim/ilaç/tek hasar/doğal iyileşme, karantina/zindan, CAS/debug/taşkın/yoğunluk, kireç atomikliği, fail/kanıt, legacy/bozuk kayıt ve gerçek gece JSON eşitliği.

`tests/oto/kuyu_kirliligi_kontrol.tscn`: gerçek gizli CHR kabulü → tur3 gece sabotaj/kirlenme/tifo kuluçkası → kuyu bilgisi → sonraki gerçek gece/hasta kartı → aktif GuvenliKayit → gerçek 2 kireç düğmesi → temiz GuvenliKayit → sonraki gece yeni kullanıcıda tifo olmaması. Sahne `tools/sanity_check.py` listesinde; birim otomatik keşiftedir. Otomasyon geçici %100 riski fixture sonunda geri bırakır.

Asset gerekmedi: mevcut kuyu/kireç ve Label/Button kullanıldı. Envanter kontrol edildi; yeni görsel/model/ses/animasyon ihtiyacı yok, üretim/indirme yapılmadı. Son kanıt `codex.md/Codex.md` ve `work/kri04/`. Kullanıcı talimatıyla editor import/tam sanity çalıştırılmaz; ROADMAP/ayna/stage/commit/push/`.import` korunur.
