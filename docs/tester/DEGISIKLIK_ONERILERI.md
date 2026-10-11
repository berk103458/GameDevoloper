# Değişiklik Önerileri (Tester)

Hata olmayan ama değişmesi gereken yerler. Kalıp: `docs/tester/TESTER_REHBERI.md` §5. Numara ONR-001'den artar.
Durumlar: YENİ → ROADMAP'E ALINDI (madde kimliği) / REDDEDİLDİ (gerekçe) / UYGULANDI. Karar Claude'undur.

| Kimlik | Etki | Alan | Başlık | Durum |
| --- | --- | --- | --- | --- |
| ONR-003 | Yüksek | Ekonomi / denge | Odun zinciri (EKO-02) köyü kilitleyip zaferi ulaşılamaz kılıyor | YENİ |
| ONR-004 | Yüksek | Test araçları | Otomatik oyuncu + denge benzetimi EKO-02 öncesi stratejide kalmış | YENİ |
| ONR-001 | Orta | Kapı / CHR sorgusu | Başarısız ikna cevabı kalıcı kapanıyor, oyuncuya açıklanmıyor | YENİ |
| ONR-002 | Orta | Nüfus / sınıf sözlüğü | KoyNufusu sınıf sözlüğü eksik, API savunmasız | YENİ |

---


### ONR-003 · Yüksek · Ekonomi / denge · Odun zinciri (EKO-02) köyü kilitleyip zaferi ulaşılamaz kılıyor
- **Gözlem:** EKO-02 (`src/koy/odun_zinciri.gd`) `hizarhane`'yi "2 tomruk → 3 odun / 1 kereste" yaptı; tomruk yalnız `odunluk` yapısından geliyor. Pratikte bir kilit oluşuyor: `hizarhane` kurmak odun ister (6 odun), odun üretmek `hizarhane` ister; başlangıç odunu (20) çadır+odunluk+tarla ile tükenince köy odun üretemez. 22/22 oyunda `odun=0` (g1'den sonra). Sonuç: köy ~5 yapıda donar, tarla eklenemez, gıda 0, huzur 60→tek haneli, isyan.
- **Neden önemli:** Oyunun kazanma yolu (2. perde 12 gece / 3 baskın savuşturma) fiilen kapanıyor; denge eğrisi hep yenilgiye gidiyor.
- **Öneri:** (a) `odunluk` maliyetini odunsuz/tomruk ağırlıklı yap; (b) başlangıç odununu artır (ör. 26–30); (c) `hizarhane` tarifine "tomruk olmadan düşük verimli odun" seçeneği ekle; (d) meydan çevresinde en az iki boş 2×2 + yol ağını başlangıçtan ver. Hedef: doğru stratejiyle zafer ölçülebilir olsun.
- **Kanıt:** `work/tester/tur3/denge_ek.gd`, `work/tester/tur3/hizar_tani.gd`, `work/tester/oyunlar/oyun_108..116.log`; TST-0004.

### ONR-004 · Yüksek · Test araçları · Otomatik oyuncu + denge benzetimi EKO-02 öncesi stratejide kalmış
- **Gözlem:** `tests/oto/otomatik_oyuncu.gd:_koy_yonet` ve `tools/denge/koy_benzetimi.gd` yalnız cadir/kulube/tarla/hizarhane/avci kurar; `odunluk` (orman kampı) hiç kurulmaz. EKO-02'den sonra bu strateji köyü odunsuz bırakır.
- **Neden önemli:** 7/24 döngünün tüm oyunları ve denge benzetimi bu yüzden yenilgiye gidiyor; "oyun mu dengesiz, araç mı yanlış" ayrımı yapılamıyor, zafer yolu ölçülemiyor.
- **Öneri:** `_koy_yonet`/`_insa_et`'e `odunluk` ekle (önce kur, işçi ata), sıra odunluk→tarla→hizarhane; `koy_benzetimi.gd` de güncellensin. Ardından zafer oranını yeniden ölç.
- **Kanıt:** `tests/oto/otomatik_oyuncu.gd`, `tools/denge/koy_benzetimi.gd`, `work/tester/tur3/denge_ek.gd`.

### ONR-001 · Orta · Kapı / CHR sorgusu · Başarısız ikna denemesi cevabı kalıcı kapatıyor, oyuncuya açıklanmıyor
- **Gözlem:** CHR sorgusunda bir cevap denendikten sonra kalıcı kapanıyor (`sorgu._denemeler`). Tüm cevaplar kapanıp kalanlar ipucu kilitli olunca oyuncu kapıda sıkışıyordu (BUG-0016). Claude "Kararını ver" çıkışı ekledi; ancak bir cevabın neden kapandığı ekranda yazmıyor — buton yalnız pasif, tooltip "Önce nişan, yük veya fiziksel izi incele" iken görünür. Oyuncu bir cevabı yanlışlıkla tüketirse geri dönüşü yok.
- **Neden önemli:** Kapı sorgusu oyunun çekirdek döngüsü; geri dönüşsüz tüketim + sessiz kilit, oyuncuyu cezalandırıcı ve anlaşılmaz hissettirebilir. Ayrıca bu softlock 7/24 testte yakalandı; benzer geri dönüşsüz durumlar kapıda tekrar edebilir.
- **Öneri:** (a) Denenmiş bir cevaba basıldığında kısa geri bildirim ("Bu sözü bir kez söyledin"), (b) ipucu kilitli cevabın tooltip'i ekranda da görünsün, (c) TASARIM kararı: başarısız ikna denemesi kalıcı mı olmalı, yoksa bir kez daha denenebilir mi? GDD'de yazılı değilse netleştirilsin.
- **Kanıt:** commit 5396fae (`src/arayuz/chr_diyalog_paneli.gd`), `tests/unit/kvr/chr_kilit_cikisi_test.gd`.
- **Tur 3 notu (Claude ek sorusu):** Başarısız ikna cevabının kalıcı kapanması oyuncuya **adil değil ve ekranda açıklanmıyor** (buton yalnız pasif, neden kapandığı yazmıyor). Öneri: kapalı cevabın yanına kısa gerekçe ("Bu sözü bir kez söyledin") ve geri dönüşsüz tüketimin önceden uyarılması.

### ONR-002 · Orta · Nüfus / sınıf sözlüğü · KoyNufusu sınıf sözlüğü eksik, API savunmasız
- **Gözlem:** `KoyNufusu.sayilar` varsayılanı yalnız `{asker,esnaf,ciftci}` (`src/sistemler/koy_nufusu.gd:7`); `zanaatkar`/`dervis` sınıfları yalnız `Oturum._koy_esitle()` (`oturum.gd:335`) ile sonradan ekleniyor. `sayi()`/`cikar()` ve `ekle()` `.get()` kullanmıyor, bu yüzden sınıf sözlükte yokken SCRIPT ERROR üretiyor (bkz. TST-0001, oyun 107: 60 hata).
- **Neden önemli:** Arayüz ve bina/nüfus sistemleri beş sınıfı gösterirken alt katman üç sınıf varsayıyor; sayı yanlış raporlanabilir ya da sinir bozucu hata spam'i oluşur.
- **Öneri:** Varsayılan sözlüğe beş sınıfı da ekle (0 ile) veya `sayi()`/`cikar()`/`ekle()` içinde `.get(sinif, 0)` kullan.
- **Kanıt:** `src/sistemler/koy_nufusu.gd:7,16,24,28,33,35`; `src/sistemler/oturum.gd:335`; `work/tester/oyunlar/oyun_107.log`.