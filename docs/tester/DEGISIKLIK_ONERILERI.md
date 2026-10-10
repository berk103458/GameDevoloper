# Değişiklik Önerileri (Tester)

Hata olmayan ama değişmesi gereken yerler. Kalıp: `docs/tester/TESTER_REHBERI.md` §5. Numara ONR-001'den artar.
Durumlar: YENİ → ROADMAP'E ALINDI (madde kimliği) / REDDEDİLDİ (gerekçe) / UYGULANDI. Karar Claude'undur.

| Kimlik | Etki | Alan | Başlık | Durum |
| --- | --- | --- | --- | --- |
| ONR-001 | Orta | Kapı / CHR sorgusu | Başarısız ikna cevabı kalıcı kapanıyor, oyuncuya açıklanmıyor | YENİ |
| ONR-002 | Orta | Nüfus / sınıf sözlüğü | KoyNufusu sınıf sözlüğü eksik, API savunmasız | YENİ |

---


### ONR-001 · Orta · Kapı / CHR sorgusu · Başarısız ikna denemesi cevabı kalıcı kapatıyor, oyuncuya açıklanmıyor
- **Gözlem:** CHR sorgusunda bir cevap denendikten sonra kalıcı kapanıyor (`sorgu._denemeler`). Tüm cevaplar kapanıp kalanlar ipucu kilitli olunca oyuncu kapıda sıkışıyordu (BUG-0016). Claude "Kararını ver" çıkışı ekledi; ancak bir cevabın neden kapandığı ekranda yazmıyor — buton yalnız pasif, tooltip "Önce nişan, yük veya fiziksel izi incele" iken görünür. Oyuncu bir cevabı yanlışlıkla tüketirse geri dönüşü yok.
- **Neden önemli:** Kapı sorgusu oyunun çekirdek döngüsü; geri dönüşsüz tüketim + sessiz kilit, oyuncuyu cezalandırıcı ve anlaşılmaz hissettirebilir. Ayrıca bu softlock 7/24 testte yakalandı; benzer geri dönüşsüz durumlar kapıda tekrar edebilir.
- **Öneri:** (a) Denenmiş bir cevaba basıldığında kısa geri bildirim ("Bu sözü bir kez söyledin"), (b) ipucu kilitli cevabın tooltip'i ekranda da görünsün, (c) TASARIM kararı: başarısız ikna denemesi kalıcı mı olmalı, yoksa bir kez daha denenebilir mi? GDD'de yazılı değilse netleştirilsin.
- **Kanıt:** commit 5396fae (`src/arayuz/chr_diyalog_paneli.gd`), `tests/unit/kvr/chr_kilit_cikisi_test.gd`.

### ONR-002 · Orta · Nüfus / sınıf sözlüğü · KoyNufusu sınıf sözlüğü eksik, API savunmasız
- **Gözlem:** `KoyNufusu.sayilar` varsayılanı yalnız `{asker,esnaf,ciftci}` (`src/sistemler/koy_nufusu.gd:7`); `zanaatkar`/`dervis` sınıfları yalnız `Oturum._koy_esitle()` (`oturum.gd:335`) ile sonradan ekleniyor. `sayi()`/`cikar()` ve `ekle()` `.get()` kullanmıyor, bu yüzden sınıf sözlükte yokken SCRIPT ERROR üretiyor (bkz. TST-0001, oyun 107: 60 hata).
- **Neden önemli:** Arayüz ve bina/nüfus sistemleri beş sınıfı gösterirken alt katman üç sınıf varsayıyor; sayı yanlış raporlanabilir ya da sinir bozucu hata spam'i oluşur.
- **Öneri:** Varsayılan sözlüğe beş sınıfı da ekle (0 ile) veya `sayi()`/`cikar()`/`ekle()` içinde `.get(sinif, 0)` kullan.
- **Kanıt:** `src/sistemler/koy_nufusu.gd:7,16,24,28,33,35`; `src/sistemler/oturum.gd:335`; `work/tester/oyunlar/oyun_107.log`.