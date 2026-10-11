# Değişiklik Önerileri (Tester)

Hata olmayan ama değişmesi gereken yerler. Kalıp: `docs/tester/TESTER_REHBERI.md` §5. Numara ONR-001'den artar.
Durumlar: YENİ → ROADMAP'E ALINDI (madde kimliği) / REDDEDİLDİ (gerekçe) / UYGULANDI. Karar Claude'undur.

| Kimlik | Etki | Alan | Başlık | Durum |
| --- | --- | --- | --- | --- |
| ONR-003 | Yüksek | Ekonomi / denge | Odun zinciri (EKO-02) köyü kilitleyip zaferi ulaşılamaz kılıyor | YENİ |
| ONR-004 | Yüksek | Test araçları | Otomatik oyuncu + denge benzetimi EKO-02 öncesi stratejide kalmış | YENİ |
| ONR-005 | Yüksek | [DENGE] 2. perde / savunma | 2. perde geçişi savunma hazırlığı olmadan ölüm | YENİ |
| ONR-006 | Yüksek | [DENGE] 2. perde / huzur | 2. perde huzur çöküşü: gıda 0 → huzur gecelik −10…−19 → İsyan | YENİ |
| ONR-007 | Orta | [DENGE]/[TASARIM] Sancak teftişi | 6. gece %50 olasılıklı azil, erken ve RNG tabanlı terminal son | YENİ |
| ONR-008 | Orta | [CEVRE]/asset | Eksik hareket klipleri: gergin 44/44, ofke 37/44, panik 21/44 yok | YENİ |
| ONR-001 | Orta | Kapı / CHR sorgusu | Başarısız ikna cevabı kalıcı kapanıyor, oyuncuya açıklanmıyor | YENİ |
| ONR-002 | Orta | Nüfus / sınıf sözlüğü | KoyNufusu sınıf sözlüğü eksik, API savunmasız | YENİ |
| ONR-009 | Orta | [TASARIM]/[DENGE] zafer | Zafer, köy isyan/açlık içindeyken bile "saat doldu" ile geliyor (oyun 124) | YENİ |
| ONR-010 | Yüksek | [DENGE]/[TASARIM] zafer | 2. perdenin 12. gecesi ile Tekfur akını aynı geceye denk gelince oyuncu kaybediyor (zafer verilmiyor) | YENİ |
| ONR-011 | Düşük | [TASARIM] test aracı | Karakter muayene aracı çocuk modelini (yusuf 1.17 m) "ölçek hatası" diye işaretliyor: yanlış pozitif | YENİ |
| ONR-012 | Düşük | [ARAYUZ] köy ekranı | "Geceye geç" düğmesi düşük kontrastlı okunuyor (doğrulanmadı) | YENİ |

---

### ONR-012 · Düşük · [ARAYUZ] · Köy ekranı "Geceye geç" düğmesi düşük kontrastlı görünüyor
- **Gözlem:** Köy ekranında sağ paneldeki "Geceye geç" düğmesi metni, aynı paneldeki "Pazar" ve "Nüfus (P)" düğmelerine göre belirgin düşük kontrastlı (koyu yeşilimsi metin/koyu zemin). "Pazar"/"Nüfus" parlak beyaz okunurken "Geceye geç" zor seçiliyor.
- **Neden önemli:** Geceyi bitiren ana eylem; oyuncunun en sık bastığı düğme. Okunmazsa oyuncu "geceyi nasıl bitireceğim" diye arar.
- **Öneri:** `_gece_dugmesi`'ne (aynı `_dugme` yolunu kullanıyor: `src/arayuz/koy_ekrani.gd:168`) diğer eylem düğmeleriyle aynı okunur stil/renk verilsin; ya da birincil eylem olduğu için hafif vurgu (çerçeve/parlaklık) eklensin.
- **Kanıt:** `work/tester/tur7/v_koy_gunduz_insa.jpg` (sağ alt; "Geceye geç"), `work/tester/tur7/koy_gunduz_insa.png`.
- **Güven:** **Düşük / doğrulanmadı** (tek görsel gözlem; kod yolu diğer düğmelerle aynı — fark üst panel/geçiş efektinden olabilir). Claude bir kez bakıp ele almalı.

### ONR-005 · Yüksek · [DENGE] · 2. perde geçişi savunma hazırlığı olmadan ölüm
- **Gözlem:** 2. perdeye geçen köy hiçbir savunma hazırlığı yapmadan Tekfur saldırısıyla karşılaşıyor. Oyunda 2. perde, nüfus 18'de (kabul oranından bağımsız) açılıyor; o sırada `sur=0`, `odun=0` (bkz. TST-0004/ONR-003), `yapı=5`. `savunma_gucu() = sur_gucu(0,0) + etkin_muhafiz + asker/2` → duvarsız köyde yalnız `asker/2` (≈2–3). Sıradaki olay: `harac_araligi=6` gereği `(gün+1)%6==0` gününde haraç istenir; cevapsız bırakılırsa otomatik reddedilir → `tekfur_baski=1` → **aynı/ertesi gece** `tekfur_gucu()=2+1×2=4` ile ilk akın gelir. 4 > 2–3 → köy 2. perdenin 1.–2. gecesinde düşer.
- **Kanıt (oyun logları):** 106/113/117 (kabul 0.90/0.98/0.75): 2. perde g5–g6'da başlar, `sur=0 odun=0`, oyun **g7'de** "Tekfur'un akıncıları" ile biter. 110: ilk akın "güçleri 4, savunman 7" (büyük köy kurtuldu); 115: "güçleri 6, savunman 5" → g19 düştü. 118 (en iyi oyun, akçe 102): g7'de 2. perde, 11 gece dayandı, **g19'da** akınla düştü (zafer için g20 gerekiyordu).
- **Neden önemli:** 2. perde "hazırlık yap" fırsatı vermeden erken ölümle bitiyor; duvar/muhafız kurmak odun kilidi yüzünden (ONR-003) mümkün değil. Zafer fiilen ulaşılamaz.
- **Öneri:** (a) Haraç isteği ile ilk akın arasına en az 1–2 gece hazırlık koy (gecikme), (b) 2. perde başlangıcında köyü savunmaya yönlendiren açık ipucu/hedef metni ver, (c) duvar/muhafız kurulabiliyorsa (odun kilidi çözülünce) `savunma_gucu` ölçeklensin; ilk akın gücü (4) mevcut ekonomide savunulabilir olsun.
- **Kanıt:** `work/tester/oyunlar/oyun_113.log` (g5–g7), `oyun_118.log` (g7–g19), `oyun_110.log:396`, `oyun_115.log`; `src/koy/koy_yonetimi.gd:521,860-881`; `src/veri/koy_ayarlari.gd:113,118`.
- **Tur 5 ölçümü (sayılar):** Tohum 302, kabul 0.95 → 2. perde **gece 6** açıldı; haraç **10 akçe + 20 buğday** istendi, ödenemedi → baskı 1 → **gece 7** saldırı: **"güçleri 4, savunman 2"** → ölüm. Persona (bilinçli "önce odun zinciri") tohum 201/202/203: üçünde de gece 7 ölüm. Formül: `tekfur_gucu() = 2 + baskı×2 = 4`; duvarsız köyde `savunma_gucu() = sur(0) + muhafız + asker/2 ≈ 2`. 106–135 arası 29 oyunda **zafer 1** (oyun 124).

- **Tur 6 ölçümü (44 kayıt, 38 tamamlanan):** 2. perdeye geçen 36 oyunun HEPSİ `sur=0, odun=0, yapı=5` ile girdi; ilk akın gücü 4 (baskı1) ya da 6 (baskı2), savunma 2–7. Persona (tohum 601/602/603) 3/3 g7'de öldü; kişisel not: sur taksiti ödeyen persona (601) g13'e kadar dayandı ama 2. akın (güç 6) onu da yendi → hazırlık penceresi yok. Kod: `tekfur_gucu()=2+baskı*2`, `savunma_gucu()=sur(0)+muhafız+asker/2`.
- **Tur 7 ölçümü:** 2. perdeye giren **36/36 oyun `sur=0`** ile girdi; girişte asker ort. **6,6** (3–10). İlk akın gücü 4 (baskı 1) / 6 (baskı 2); gözlenen savunmalar 2–7. Sur taksiti ödeyen persona (611) g13'e kadar dayandı, 2. akın (güç 6) yendi → hazırlık penceresi hâlâ yok. 8acb352 sonrası 147/148/149 → 3/3 `g19 Tekfur`.
### ONR-006 · Yüksek · [DENGE] · 2. perde huzur çöküşü: gıda 0 → gecelik −10…−19 → İsyan
- **Gözlem:** 2. perde başladıktan sonra gıda **1–3 gece içinde** 0'a düşüyor ve huzur gece başına ~10–19 puan eriyor; `isyan_esigi=10` altına inince 3 gecelik sayaç başlıyor → İsyan sonu.
- **Gece gece eğri (oyun logu `gün N … huzur=` satırları):** 110: g7 hz21 → g11 hz5 → g12 hz4 (İsyan g13). 112: g6 hz37 → g10 hz11 → g11 hz3 (İsyan g14). 114: g8 hz21 → g9 hz10 → g10 hz1 (İsyan g12). 116: g6 hz45 → g11 hz16 → g15 hz8 (İsyan g17). Tüm 2. perde oyunlarında `gida=0 odun=0 sur=0`.
- **Mekanizma:** `koy_yonetimi.gd:_saglik_ve_moral` → aç köylüye `aclik_moral=15` ceza. Gıda üretimi nüfus artışına yetişmiyor (tarla kurulamıyor: odun 0 → ONR-003). Yani huzur çöküşü = kıtlık zinciri.
- **Neden önemli:** 2. perde bir "dayanma" perdesi olacakken hızlı bir moral erimesine dönüşüyor; oyuncu toparlanma fırsatı bulamıyor.
- **Öneri:** (a) Önce odun/ekonomi kilidini çöz (ONR-003) ki tarla kurulup gıda üretilebilsin, (b) kıtlıkta açlık moral cezasını kademelendir (ilk gece hafif, sonra ağırlaşsın), (c) 2. perde başında ambarda en az birkaç günlük erzak garantisi (başlangıç stok) ver. Hedef: doğru oynayan köy 2. perdede moral erimesini yavaşlatabilsin.
- **Kanıt:** `work/tester/oyunlar/oyun_110/112/114/116.log`; özet eğri `work/tester/tur4/huzur.py`; `src/veri/koy_ayarlari.gd:97-98,107`.
- **Tur 5 ölçümü:** Persona koşularında gıda **gece 5'te 0** (nüfus 18 gece 6'da); gıda üretimi nüfus artışına yetişmiyor (tarla odunsuz kurulamıyor). Otomatik oyuncu tohum 301 (kabul 0.2): gün 12'de huzur 13, odun/gıda 0.

- **Tur 6 ölçümü (gece gece eğri):** gıda 0'a gün 6–8'de düşüyor; huzur gece başına ~10–19 eriyip 10–30 bandına oturuyor; `isyan_esigi=10`, `isyan_gun=3`. Örnek (140): g5 hz47→g6 hz51→g7 hz45/gd0→g8 hz29→g9 hz16→g10 hz12→İsyan g14. İsyan 11/34 (%32). Öne çıkan: düşük/orta kabulde İsyan, yüksek kabulde Tekfur.
- **Tur 7 ölçümü:** 43 tamamlanan oyunda gıda gün 6–8'de 0; huzur gece başına ~10–19 eriyor (örnek 145: g7 hz39/gd0 → g14 hz10 → g15 hz6 → Azil g16). İsyan 11/43; düşük/orta kabul → İsyan/Azil, yüksek kabul → Tekfur.
### ONR-007 · Orta · [DENGE]/[TASARIM] · 6. gece %50 olasılıklı azil, erken ve RNG tabanlı terminal son
- **Gözlem:** Sancak teftişi `ilk_gece=6, aralik=5`, `bulma_olasiligi=0.50`: yozlaşma ≥20 ve kişisel kasa dolu ise **6. gecede** %50 olasılıkla anında "Muhafız azledildi" (terminal son). Oyun 109, 120, 122 bu şekilde bitti; köy sağlıklıydı (109: huzur 54, perde 1, koy 15) ve akçe 1 ile "ekonomi çöktü" görüntüsü veriyordu.
- **Neden önemli:** (a) Bu son **ekonomi çöküşü değil**, rüşvet/yozlaşma teftişi; ama düşük kamu akçesiyle aynı ana denk gelince "erken ekonomi çöküşü" izlenimi yaratıyor. (b) Tek atışlık %50 RNG, oyunun ilk teftişinde oyuncuyu oyundan koparabiliyor; oyuncu yozlaşmayı geç fark ederse geri dönüşü yok.
- **Öneri:** (a) 6. geceden önce oyuncuya yozlaşma uyarısı ver ("Teftiş yaklaşıyor; kasa/yozlaşma riski"), (b) ilk teftişte bulunma olasılığını düşür (ör. 0.25) veya ilk sonuç "uyarı" olsun, ikinci teftişte azil. Oyun dengesi kararı Claude/Codex'in.
- **Kanıt:** `data/sancak_teftisi.json`; `src/sistemler/sancak_teftisi.gd:36-44`; `work/tester/oyunlar/oyun_109.log` (SON: Muhafız azledildi gun=6 huzur=54 akce=1).
- **Tur 6 ölçümü:** azil 9/38 (%24); üçü tam **g6** (109 akçe1, 120 akçe16, 138 akçe12), dördü g10–16; kendi koşum tohum 702 (kabul 0.35) → `SON: Muhafız azledildi gun=6`. İlk teftiş gece 6, aralık 5, yozlaşma≥20 + dolu kasa + %50 (`data/sancak_teftisi.json`). Erken ekonomik çöküş değil, rüşvet kaynaklı yozlaşma + RNG terminal son; oyuncu 2. perdeyi görmeden bitebiliyor.
### ONR-008 · Orta · [CEVRE]/asset · Eksik hareket klipleri (gergin/ofke/panik/konus/sevinc)
- **Gözlem:** Karakter muayenesinde (44 model) `gergin` **44/44 modelde yok**; `ofke` 37/44; `panik` 21/44; `konus` ve `sevinc` 14/44 modelde yok. **14 adlı/kutu modelde yalnız bekle+yürü var** (asker, aydogdu, ayse_baci, ciftci, ciftci_kadin, esnaf, hasan_celebi, karaca_usta, miraen, nogay, saruca_hatun, sorhan, thessra, yusuf). CHR_001–030'da en az bekle/yürü/konuş/sevinc/öfke/panik karışımı var; adlı karakterlerin çoğu donuk.
- **Neden önemli:** Oyunda bu hareketler çağrılırsa (kriz, kutlama, gece rutini) karakter donuk/hareketsiz kalır ya da fallback'e düşer; oyuncu gözüyle "kukla" hissi artar. `gergin` hiçbir modelde olmadığı için bu durum tüm oyunda geçerli.
- **Öneri:** (a) Hangi hareketlerin kod tarafından gerçekten çağrıldığını çıkar (animasyon çağrı listesi); çağrılan ama olmayanlar için klip ekle ya da doğru fallback eşle. (b) Eksik klipler `docs/EKSIK_ASSET_ENVANTERI.md`'ye girsin (öncelik: `gergin` > `ofke` > `panik`). Asset üretmeden yalnız envanter/karar.
- **Kanıt:** `work/tester/muayene/muayene.json` (her modelin `eksik` listesi), `work/tester/tur4/muayene_ozet.py`.
### ONR-003 · Yüksek · Ekonomi / denge · Odun zinciri (EKO-02) köyü kilitleyip zaferi ulaşılamaz kılıyor
- **Gözlem:** EKO-02 (`src/koy/odun_zinciri.gd`) `hizarhane`'yi "2 tomruk → 3 odun / 1 kereste" yaptı; tomruk yalnız `odunluk` yapısından geliyor. Pratikte bir kilit oluşuyor: `hizarhane` kurmak odun ister (6 odun), odun üretmek `hizarhane` ister; başlangıç odunu (20) çadır+odunluk+tarla ile tükenince köy odun üretemez. 22/22 oyunda `odun=0` (g1'den sonra). Sonuç: köy ~5 yapıda donar, tarla eklenemez, gıda 0, huzur 60→tek haneli, isyan.
- **Neden önemli:** Oyunun kazanma yolu (2. perde 12 gece / 3 baskın savuşturma) fiilen kapanıyor; denge eğrisi hep yenilgiye gidiyor.
- **Öneri:** (a) `odunluk` maliyetini odunsuz/tomruk ağırlıklı yap; (b) başlangıç odununu artır (ör. 26–30); (c) `hizarhane` tarifine "tomruk olmadan düşük verimli odun" seçeneği ekle; (d) meydan çevresinde en az iki boş 2×2 + yol ağını başlangıçtan ver. Hedef: doğru stratejiyle zafer ölçülebilir olsun.
- **Kanıt:** `work/tester/tur3/denge_ek.gd`, `work/tester/tur3/hizar_tani.gd`, `work/tester/oyunlar/oyun_108..116.log`; TST-0004.
- **Tur 5 notu (kopya kontrolü):** Bu öneri ayrı bir kök neden DEĞİL; **TST-0004 (ana kayıt)** ile aynı nedeni anlatır. Ana kayıt TST-0004'tür; ONR-003/ONR-004 ona bağlıdır.

### ONR-004 · Yüksek · Test araçları · Otomatik oyuncu + denge benzetimi EKO-02 öncesi stratejide kalmış
- **Gözlem:** `tests/oto/otomatik_oyuncu.gd:_koy_yonet` ve `tools/denge/koy_benzetimi.gd` yalnız cadir/kulube/tarla/hizarhane/avci kurar; `odunluk` (orman kampı) hiç kurulmaz. EKO-02'den sonra bu strateji köyü odunsuz bırakır.
- **Neden önemli:** 7/24 döngünün tüm oyunları ve denge benzetimi bu yüzden yenilgiye gidiyor; "oyun mu dengesiz, araç mı yanlış" ayrımı yapılamıyor, zafer yolu ölçülemiyor.
- **Öneri:** `_koy_yonet`/`_insa_et`'e `odunluk` ekle (önce kur, işçi ata), sıra odunluk→tarla→hizarhane; `koy_benzetimi.gd` de güncellensin. Ardından zafer oranını yeniden ölç.
- **Kanıt:** `tests/oto/otomatik_oyuncu.gd`, `tools/denge/koy_benzetimi.gd`, `work/tester/tur3/denge_ek.gd`.
- **Tur 5 notu (kopya kontrolü):** Ayrı kök neden değil; **TST-0004** kök nedenine bağlıdır. Tur 5 ölçümü: `_koy_yonet` hâlâ `odunluk` kurmuyor → 7/24 oyunlarında gün 0'da odun 20→7, gün 1'de 0.

### ONR-001 · Orta · Kapı / CHR sorgusu · Başarısız ikna denemesi cevabı kalıcı kapatıyor, oyuncuya açıklanmıyor
- **Gözlem:** CHR sorgusunda bir cevap denendikten sonra kalıcı kapanıyor (`sorgu._denemeler`). Tüm cevaplar kapanıp kalanlar ipucu kilitli olunca oyuncu kapıda sıkışıyordu (BUG-0016). Claude "Kararını ver" çıkışı ekledi; ancak bir cevabın neden kapandığı ekranda yazmıyor — buton yalnız pasif, tooltip "Önce nişan, yük veya fiziksel izi incele" iken görünür. Oyuncu bir cevabı yanlışlıkla tüketirse geri dönüşü yok.
- **Neden önemli:** Kapı sorgusu oyunun çekirdek döngüsü; geri dönüşsüz tüketim + sessiz kilit, oyuncuyu cezalandırıcı ve anlaşılmaz hissettirebilir. Ayrıca bu softlock 7/24 testte yakalandı; benzer geri dönüşsüz durumlar kapıda tekrar edebilir.
- **Öneri:** (a) Denenmiş bir cevaba basıldığında kısa geri bildirim ("Bu sözü bir kez söyledin"), (b) ipucu kilitli cevabın tooltip'i ekranda da görünsün, (c) TASARIM kararı: başarısız ikna denemesi kalıcı mı olmalı, yoksa bir kez daha denenebilir mi? GDD'de yazılı değilse netleştirilsin.
- **Kanıt:** commit 5396fae (`src/arayuz/chr_diyalog_paneli.gd`), `tests/unit/kvr/chr_kilit_cikisi_test.gd`.
- **Tur 7 notu (kod kanıtı):** `src/sistemler/chr_sorgusu.gd:69-71` beceri (ikna/blöf) seçeneğini **zar atılmadan önce** `_denemeler` sözlüğüne yazıyor → başarı/başarısızlık fark etmeksizin kalıcı kapanıyor. `src/arayuz/chr_diyalog_paneli.gd:40` yalnız düğmeyi pasifleştiriyor; önceden "tek şans" uyarısı/onayı yok. GDD yok (yalnız kodda). `chr_kilit_cikisi_test` GEÇTİ; KILIT/`SOHBET_KILIDI` fix sonrası 0 → çıkış çözümü sağlam, tasarım adaleti sorusu (a/b/c önerileri) AÇIK.
- **Tur 3 notu (Claude ek sorusu):** Başarısız ikna cevabının kalıcı kapanması oyuncuya **adil değil ve ekranda açıklanmıyor** (buton yalnız pasif, neden kapandığı yazmıyor). Öneri: kapalı cevabın yanına kısa gerekçe ("Bu sözü bir kez söyledin") ve geri dönüşsüz tüketimin önceden uyarılması.

### ONR-002 · Orta · Nüfus / sınıf sözlüğü · KoyNufusu sınıf sözlüğü eksik, API savunmasız
- **Gözlem:** `KoyNufusu.sayilar` varsayılanı yalnız `{asker,esnaf,ciftci}` (`src/sistemler/koy_nufusu.gd:7`); `zanaatkar`/`dervis` sınıfları yalnız `Oturum._koy_esitle()` (`oturum.gd:335`) ile sonradan ekleniyor. `sayi()`/`cikar()` ve `ekle()` `.get()` kullanmıyor, bu yüzden sınıf sözlükte yokken SCRIPT ERROR üretiyor (bkz. TST-0001, oyun 107: 60 hata).
- **Neden önemli:** Arayüz ve bina/nüfus sistemleri beş sınıfı gösterirken alt katman üç sınıf varsayıyor; sayı yanlış raporlanabilir ya da sinir bozucu hata spam'i oluşur.
- **Öneri:** Varsayılan sözlüğe beş sınıfı da ekle (0 ile) veya `sayi()`/`cikar()`/`ekle()` içinde `.get(sinif, 0)` kullan.
- **Kanıt:** `src/sistemler/koy_nufusu.gd:7,16,24,28,33,35`; `src/sistemler/oturum.gd:335`; `work/tester/oyunlar/oyun_107.log`.

### ONR-009 · Orta · [TASARIM]/[DENGE] · Zafer, köy isyan/açlık içindeyken bile "saat doldu" ile geliyor
- **Gözlem:** Zafer yalnız 2. perdede 12 gece dayanınca (`src/koy/perde_gecisi.gd:denetle`) ya da N baskı savuşturunca gelir; köyün **iç durumu** (isyan, açlık, ölüm) zaferi engellemiyor. Oyun 124: 2. perde gece 6→18; gece 17–18'de "Köy isyanda!", "Kıtlık isyanı: ambar kapısı kırıldı", 20+ kişi aç yattı, ölümler — ama gece 18'de saat dolunca **Uç Tutundu (zafer)** verildi. İsyan sonu 3 gece gerektirdiği için henüz tetiklenmemişti.
- **Neden önemli:** "Uç kendi kendine tutundu" zafer metni, isyan ve açlık içindeki bir köy için anlamsız/çelişkili görünüyor; oyuncuya "kötü oynadım ama kazandım" hissi verebilir. Ayrıca tek zafer vakası, oyunun değil saatin sonucu.
- **Öneri:** Zafer koşuluna iç durum eşiği ekle (ör. huzur ≥ X ve isyan yok); isyan/açlık sürerken saat dolarsa "kırılma" sonu ver. Böylece zafer gerçekten "tutunma" anlamına gelsin.
- **Kanıt:** `work/tester/oyunlar/oyun_124.log` (gece 17–18 kartları + `SON: Uç Tutundu gun=18`), `src/koy/perde_gecisi.gd`, `data/nihai_sonlar.json`.


### ONR-010 · Yüksek · [DENGE]/[TASARIM] · 2. perdenin son gecesi ile Tekfur akını çakışınca zafer verilmiyor
- **Gözlem:** Zafer koşulu 2. perdede 12 gece dayanmak (`perde2_hedef_gece=12`) ya da 3 baskın savuşturmak. Ancak `Oturum.gece_sonu` önce `yonetim.gece()` çalıştırır (içindeki `_asamalar` Tekfur akınını çözer ve `son=tekfur` yazar), SONRA `PerdeGecisi.denetle` çağırır; `denetle` başında `if y.son != "": return` vardır. Sonuç: **12. gece ile akın aynı geceye denk gelirse oyuncu kaybeder, kazandığı zafer verilmez.**
- **Ölçüm (tur 6):** 38 tamamlanan oyunun **9'u tam g19'da** Tekfur ile bitti (111,115,118,123,125,128,131,134,136); bunların 2. perdesi g6–g7'de açıldı → g19 ≈ 12. gece. Zafer yalnız 2/38 (%5,3) ve ikisi de g18'de (124, 143) — akının denk gelmediği gece. Kendi koşum: tohum 701 (kabul 0.9) → `SON: Tekfur gun=19 perde=2` (yine zafer gecesi). Tek zafer (124) akının denk gelmediği gece doldu.
- **Neden önemli:** Zafer fiilen "son gece akın gelmesin" şansına bağlı; oyuncu 12 geceyi tamamladığı gece ölüyor ve bunu hiçbir yerde göremiyor. Zafer oranı 2/38 (%5,3) bunu doğruluyor.
- **Öneri:** Zafer denetimini akından **önce** yap (gece sayacı hedefe ulaştıysa akın uygulanmasın) ya da aynı gece çakışırsa zaferi önceliğe al; en azından oyuncuya "bu geceyi atlatırsan tutundun" uyarısı ver.
- **Kanıt:** `src/sistemler/oturum.gd:277-288` (sıra), `src/koy/perde_gecisi.gd:denetle`, `src/koy/koy_yonetimi.gd:860-884` (`_asamalar`), `work/tester/oyunlar/oyun_136.log` (g19), `work/tester/tur6/oto_701.log`.
- **Tur 7 ek kanıtı:** TST-0010 düzeltmesinden (8acb352) sonraki 7/24 oyunları **147 (g19 Tekfur), 148 (g19 Tekfur), 149 (g19 Tekfur)** — yani 8acb352 üzerinde 3/3 oyun tam **g19'da** Tekfur ile bitti. Düzeltme davranışı değiştirmedi (hedef 12 gece hâlâ doğru) ama "zafer gecesi = ölüm gecesi" çakışması sürüyor; zafer hâlâ 2/43 (%4,7).

### ONR-011 · Düşük · [TASARIM] · Karakter muayene aracı çocuk modelini yanlış işaretliyor
- **Gözlem:** `tests/oto/karakter_muayene.tscn` yusuf modelini "baş yüksekliği olağandışı (1.17 m) — ölçek hatası" diye uyarıyor. Ama yusuf **kasıtlı çocuk**: `data/chr_runtime/CHR_012.tres` "üç yaşındaki yetim oğlu Yusuf". `data/karakterler/yusuf.tres`'te `cocuk` bayrağı yok, araç da bilemiyor.
- **Neden önemli:** Gerçek hatalar bu yanlış pozitifin gürültüsünde kaybolabilir; her turda yusuf uyarısı tekrar okunuyor.
- **Öneri:** `KarakterVerisi`'ye `cocuk: bool` ekle (veya muayene aracına bilinen çocuk id listesi) → yusuf uyarı sayılmasın. Gerçek asset üretmeden yapılabilir.
- **Kanıt:** `work/tester/muayene/muayene.json` (yusuf.uyarilar), `data/karakterler/yusuf.tres`, `data/chr_runtime/CHR_012.tres:16`.

