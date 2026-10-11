# BÖLÜM 46 — Yerelleştirme altyapısı

En son. Çeviri metni bu bölümün işi değildir; ikinci sütun boş kalabilir. Zemin:

- `project.godot:30–33` — `locale/translations` yalnız `res://data/metin/metinler.tr.translation`, `locale/fallback = "tr"`.
- `src/arayuz/ana.gd:23` `TranslationServer.set_locale("tr")` sabit.
- `data/metin/metinler.csv` başlık `keys,tr`. Tek dil sütunu. Standart `docs/METIN_ANAHTAR_STANDARDI.md`: noktalı küçük harf, `%s`/`%d` sayısı kodla aynı, boş Türkçe yok.
- Doğrulama `tools/metin_dogrula.py`. Çalışma anı `src/sistemler/guvenli_metin.gd` (`GuvenliMetin.kur`, eksikte `[KEY_NOT_FOUND]`, kilit yok).
- `TranslationServer.translate` doğrudan çağrıları: `karar_replik_adaptoru.gd`, `iflas_yoneticisi.gd`, `koylu_karti_verisi.gd`, `levent_firari.gd`, `sancak_teftisi.gd`, `koylu_takibi.gd`, `coban_surusu.gd`.
- Düz metin örnekleri: `varlik_yukleme_paneli.gd` `"Hazırlanıyor…"` (TEK-21 anahtara alır); `ana.gd:223` hata metni kasten kodda ("tablo bozuk olabilir").
- Font Alegreya `assets/font/`, `tema.gd`.

Kimlikler YER-01 … YER-23. Asset üretilmez. Bitince `[x]` ve ajan adı.

**Madde biçimi:** Ne, Kabul, Bağımlılık + Boyut, Dosya, Asset.

---

## 46.1 Dil seçimi

- [ ] **YER-01:** Ayarlarda dil sekmesi.
  - Ne: GRV-25 sekmelerinden biri dildir. Liste bugün tek satır: Türkçe (`tr`). İkinci dil dosyası yoksa başka satır çizilmez. Seçim `ayarlar.cfg` anahtarı `dil` (ek dosya `ayarlar_ek.gd` kalıbı, Bölüm 35). Varsayılan `tr`.
  - Kabul: dosya yokken liste uzunluğu 1. Test: ekran.
  - Bağımlılık: GRV-25. Boyut: S.
  - Dosya: yeni: `src/arayuz/dil_sekmesi.gd`.
  - Asset: asset gerekmedi.
- [ ] **YER-02:** Anahtar ve yer tutucu kuralı standarttadır.
  - Ne: `docs/METIN_ANAHTAR_STANDARDI.md` tek kural belgesidir. Yeni anahtar `alan.alt.ad` biçimindedir. `%s` / `%d` sayısı `tr()` argümanıyla aynıdır. Bu bölüm ikinci standart açmaz. TEK-21 ve GIR-03 bu kurala uyar.
  - Kabul: biçimsiz anahtar `metin_dogrula.py` ile 1 hata. Test: mevcut araç.
  - Bağımlılık: SYS-09. Boyut: S.
  - Dosya: `docs/METIN_ANAHTAR_STANDARDI.md`; `tools/metin_dogrula.py`.
  - Asset: asset gerekmedi.
- [ ] **YER-03:** `set_locale` sabiti kalkar.
  - Ne: `ana.gd:23` `"tr"` yazmaz. `ayarlar` içindeki `dil` okunur; geçersizse fallback `tr`.
  - Kabul: ayar `tr` iken locale `tr`; çöp değerde locale `tr` ve uyarı 1. Test: birim.
  - Bağımlılık: YER-01. Boyut: S.
  - Dosya: `ana.gd` tek satır.
  - Asset: asset gerekmedi.

## 46.2 İkinci sütun — altyapı, çeviri değil

- [ ] **YER-04:** CSV ikinci dil sütununu kabul eder, doldurmayı beklemez.
  - Ne: başlık `keys,tr` durur. İsteğe bağlı üçüncü sütun `en` eklenebilir; hücre boşsa o satır `tr`'ye düşer. Boş `tr` hâlâ hatadır (standart §2). Bu madde İngilizce cümle yazmaz.
  - Kabul: `en` boş bir satırda oyun Türkçe metni gösterir; `tr` boşsa doğrulayıcı hata. Test: iki satır.
  - Bağımlılık: YER-02. Boyut: M.
  - Dosya: `tools/metin_dogrula.py` sütun kuralı; `data/metin/metinler.csv` başlık (sütun eklenirse).
  - Asset: asset gerekmedi.
- [ ] **YER-05:** Godot çeviri dosyası sütundan üretilir.
  - Ne: bugün `metinler.tr.translation` tek dosyadır. İkinci sütun dolu değilse ikinci `.translation` üretilmez. Üretim kuralı `docs/METIN_ANAHTAR_STANDARDI.md` içine bir paragraf olarak yazılır; elle kopya çeviri dosyası yasaktır.
  - Kabul: `en` sütunu yokken `locale/translations` uzunluğu 1. Test: proje dosyası.
  - Bağımlılık: YER-04. Boyut: S.
  - Dosya: `project.godot`; standart belgesi.
  - Asset: asset gerekmedi.
- [ ] **YER-06:** Fallback `tr` kalır.
  - Ne: `locale/fallback` `tr`. İkinci dil eksik anahtarda Türkçe görünür, `[KEY_NOT_FOUND]` ancak Türkçe de yoksa çıkar (`GuvenliMetin`).
  - Kabul: fallback satırı `tr`. Test: dosya.
  - Bağımlılık: YER-05. Boyut: S.
  - Dosya: `project.godot`.
  - Asset: asset gerekmedi.

## 46.3 Doğrudan çeviri çağrıları

- [ ] **YER-07:** Yedi dosya `tr()` ile hizalanır.
  - Ne: `TranslationServer.translate` çağrıları şunlardadır: `karar_replik_adaptoru.gd`, `iflas_yoneticisi.gd`, `koylu_karti_verisi.gd`, `levent_firari.gd`, `sancak_teftisi.gd`, `koylu_takibi.gd`, `coban_surusu.gd`. Yeni çağrı eklenmez. Mevcut çağrı locale değişince aynı anahtarı yeni dilde okur; gövdeye Türkçe sabit gömülüyse sabit CSV'ye taşınır.
  - Kabul: bu yedi dosyada tırnak içi uzun Türkçe cümle 0 (anahtar hariç). Test: tarama.
  - Bağımlılık: YER-03. Boyut: M.
  - Dosya: adı geçen yedi script; `metinler.csv`.
  - Asset: asset gerekmedi.
- [ ] **YER-08:** `GuvenliMetin` locale değişince yeniden kurulur.
  - Ne: `dil` değişince `GuvenliMetin.kur()` bir kez daha çalışır. Eksik listesi yeni locale'e göredir.
  - Kabul: dil değiştirince `eksikler` yeniden sayılır. Test: birim.
  - Bağımlılık: YER-03. Boyut: S.
  - Dosya: `guvenli_metin.gd`; ayar `degisti` bağı.
  - Asset: asset gerekmedi.

## 46.4 Düz metin istisnaları

- [ ] **YER-09:** Katalog hata metni kodda kalır.
  - Ne: `ana.gd:222–226` "Oyun içeriği yüklenemedi" kasten çeviri dışıdır (tablo bozuk olabilir). İstisna listesi standart belgesine bir satır olarak yazılır. Başka düz metin bu istisnaya eklenmez.
  - Kabul: istisna listesinde 1 satır. Test: belge.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: `docs/METIN_ANAHTAR_STANDARDI.md`.
  - Asset: asset gerekmedi.
- [ ] **YER-10:** "Hazırlanıyor…" istisna değildir.
  - Ne: TEK-21 anahtara alır. Yükleme paneli YER-09 listesine girmez.
  - Kabul: panelde düz Türkçe 0. Test: TEK-21.
  - Bağımlılık: TEK-21. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **YER-11:** Debug metinleri çevrilmez.
  - Ne: `src/debug/` ve `performans_seridi.gd` tooltip'i oyuncu diline girmez. SRM-05 zaten oyuncuda kapalıdır.
  - Kabul: debug klasörü `metin_dogrula --kaynak` anahtar zorunluluğunun dışındadır (belgede). Test: araç.
  - Bağımlılık: SRM-05. Boyut: S.
  - Dosya: standart belgesi.
  - Asset: asset gerekmedi.

## 46.5 Font

- [ ] **YER-12:** Alegreya Türkçe glifleri taşır.
  - Ne: `ı İ ş ğ ü ö ç` gövde puntosunda `.` kutusuna düşmez. Ölçüm `tema.gd` fontu ile bir test dizesidir. Yeni font indirilmez.
  - Kabul: yedi karakterde `get_char_size` 0 değil. Test: birim.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: `tests/unit/arayuz/font_glif_test.gd`.
  - Asset: asset gerekmedi.
- [ ] **YER-13:** İkinci dil fontu bu sürümde yoktur.
  - Ne: `en` sütunu ileride dolarsa da Alegreya Latin yeter sayılır. Arap harfi, Kiril veya CJK için font maddesi açılmaz.
  - Kabul: `assets/font/` dosya sayısı değişmez. Test: sayım.
  - Bağımlılık: YER-12. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 46.6 Çoğul ve biçim

- [ ] **YER-14:** Çoğul eki ayrı anahtardır, motor değildir.
  - Ne: Türkçe ek uyumu için `tr()` içinde ek üretilmez. Gerekirse `...tek` / `...cok` iki anahtar. Yeni i18n kütüphanesi yok.
  - Kabul: `src/` içinde çoğul fonksiyonu 0. Test: tarama.
  - Bağımlılık: YER-02. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **YER-15:** Sayı biçimi Türkçe kalır.
  - Ne: binlik ayırıcı ve ondalık için ikinci bir biçimleyici yok. Akçe ve kaynak etiketleri bugünkü `tr` kalıbındadır.
  - Kabul: `Locale` sayı formatı değiştiren satır 0. Test: tarama.
  - Bağımlılık: yok. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 46.7 İçerik sınırı

- [ ] **YER-16:** Diyalog çevirisi yazılmaz.
  - Ne: `data/soz/` ve `sohbet.*` anahtarlarının İngilizcesi bu bölümde üretilmez. KLT kapısı Türkçe metne bakmaya devam eder.
  - Kabul: bu bölümün diff'i `data/soz/` içine girmez. Test: tarama.
  - Bağımlılık: KLT-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **YER-17:** Kişi adları çevrilmez.
  - Ne: `karakter.*` adları özel isimdir. İkinci sütun olsa da ad hücresi `tr` ile aynı kalır; doğrulayıcı uyarı vermez.
  - Kabul: ad satırında `en` ≠ `tr` ise 1 uyarı (sütun varsa). Test: fixtures.
  - Bağımlılık: YER-04. Boyut: S.
  - Dosya: `metin_dogrula.py`.
  - Asset: asset gerekmedi.

## 46.8 Değişim anı

- [ ] **YER-18:** Dil değişimi açık ekranı yeniler.
  - Ne: `Ayarlar.degisti` (`dil`) menü ve ayarlar etiketlerini yeniden `tr()` ile kurar. Oyun ortasında köy metni bir sonraki ekran açılışında değişir; yarıda kalan konuşma satırı o an yenilenmez (cümle bölünmesin).
  - Kabul: menüde anında yeni etiket; açık sorgu satırı aynı kalır. Test: iki ekran.
  - Bağımlılık: YER-03. Boyut: S.
  - Dosya: `menu_ekrani.gd`, `ayarlar_ekrani.gd`.
  - Asset: asset gerekmedi.
- [ ] **YER-19:** Kayıt dili gömmez.
  - Ne: `kayit.json` içinde locale yok. Dil ayardadır (GIR-19 ile aynı ayrım). Eski kayıt açılır.
  - Kabul: kayıtta `dil` anahtarı 0. Test: KAY.
  - Bağımlılık: YER-01. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.

## 46.9 Tester

- [ ] **YER-20:** TST-0002 bu kapıda da görünür.
  - Ne: eksik anahtar KLT-10 ile kapanır. Yerelleştirme aracı aynı `metin_dogrula.py` çıktısını okur, ikinci tarayıcı yazmaz.
  - Kabul: yeni `metin_tarayici` dosyası 0. Test: sayım.
  - Bağımlılık: KLT-10. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **YER-21:** Çift boşluk dil sütununda da aranır.
  - Ne: TST-0006 / KLT-11 kuralı `tr` sütununa bakar. `en` doluysa aynı kural ona da uygulanır; boş `en` atlanır.
  - Kabul: `en` içinde çift boşluk 1 hata, boş hücre 0 hata. Test: fixtures.
  - Bağımlılık: KLT-11, YER-04. Boyut: S.
  - Dosya: `metin_dogrula.py`.
  - Asset: asset gerekmedi.

## 46.10 Sınırlar ve kapanış

- [ ] **YER-22:** Çalışma anında çeviri hizmeti yoktur.
  - Ne: HTTP çeviri, model çağrısı, otomatik satır üretimi yok (KLT-23 ile aynı sınır).
  - Kabul: `src/arayuz/dil_sekmesi.gd` içinde ağ çağrısı 0. Test: tarama.
  - Bağımlılık: KLT-23. Boyut: S.
  - Dosya: —.
  - Asset: asset gerekmedi.
- [ ] **YER-23:** Kapanış testi.
  - Ne: locale ayarı `tr`; çöp dilde fallback; CSV'de boş `tr` hata; boş `en` Türkçe gösterir; yedi dosyada yeni `translate` çağrısı yok; font yedi glif; katalog hata metni istisna listesinde tek.
  - Kabul: yedi iddia. Test: `tests/tools/test_yerel_dil.py` + font birimi.
  - Bağımlılık: YER-01…22. Boyut: M.
  - Dosya: yeni test.
  - Asset: asset gerekmedi.

Alt başlıklarda madde sayısı iki ile üç arasındadır. Onuncu madde, İngilizce diyalog veya ikinci font uyduracağı için konmadı. Toplam 23 madde. Çeviri kapsam dışıdır.
