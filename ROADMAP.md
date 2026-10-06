# Kapı Muhafızı — Nihai Master Geliştirme Yol Haritası

**DURUM LEJANDI:**
- `[x]` TAMAMLANDI (KİLİTLİ — DOKUNMAYIN)
- `[/]` GELİŞTİRİLİYOR (AKTİF İŞ PAKETİ — ÇAKIŞMA ÖNLEME KORUMASINDA)
- `[ ]` BEKLEMEDE (SIRADAKİ GÖREVLER)
- `[!]` KRİTİK BUGFIX / TEST BEKLİYOR

---

## BÖLÜM 0: Geliştirici Admin Paneli ve Hızlı Test Araçları

- [ ] **ADM-01:** Global Debug Overlay Altyapısı (`src/debug/admin_hud.gd`) — F1 veya ~ (Tilde) tuşuyla her sahnede açılıp kapanabilen, oyunu dondurmadan bağımsız CanvasLayer katmanında çalışan konsol çatısı.
- [ ] **ADM-02:** Tek Tıkla Sahne Atlama (Kapı → Köy Geçişi) — Kapı sorgu döngüsünü tamamen bypass ederek o günün kuyruğunu rastgele sonuçlandırıp doğrudan `KoyYonetimSahnesi`'ne geçiş butonu.
- [ ] **ADM-03:** Zaman Makinesi (+1 Gün / +5 Gün / Gece Sonu Tetikleyici) — `gece_sonu()` hesaplamalarını anında çalıştırıp rapor üreten ve gün sayacını 1, 5 veya 10 gün ileri saran simülasyon kontrolü.
- [ ] **ADM-04:** Kaynak ve Stat Enjektörü — Köy Akçesi, Muhafız Akçesi, Erzak, Odun, Taş, Demir ve 5 ana statı (Refah, Erzak, Güvenlik, Moral, Sağlık) anında artıran/azaltan sayısal arayüz.
- [ ] **ADM-05:** NPC Doğrudan Çağırma (Instant Spawn Selector) — Açılır listeden CHR_001–CHR_030 veya Gezgin Tüccarlara kadar istenen karakteri seçip kapı önüne sıradaki kişi olarak ışınlama aracı.
- [ ] **ADM-06:** Bayrak ve İpucu Değiştirici (Flag & Clue Inspector) — Aktif `Flag_*` ve `Clue_*` anahtarlarını listeleyen, çalışma anında bayrakları açıp kapatmaya izin veren denetim paneli.
- [ ] **ADM-07:** Donanım ve Bellek Performans Monitörü — Canlı FPS, Frame Time (ms), Draw Call sayısı, VRAM ve RAM kullanımını ekranda gösteren hafif performans barı.
- [ ] **ADM-08:** Bina Seviye ve Durum Manipülatörü — Köydeki tüm binaları anında inşa etme, seviye atlatma veya hasarlı/yanmış duruma getirme kısayolları.
- [ ] **ADM-09:** Otomatik Senaryo Koşucusu (Scenario Runner) — "10 Gün Kıtlık", "Gece Haydut Baskını", "Veba Salgını" gibi uç durum senaryolarını tek tuşla tetikleyen test otomasyonu.
- [ ] **ADM-10:** Save / State Anlık Görüntü (Snapshot) Aracı — Mevcut oyun durumunu geçici bir slota kaydedip tek tuşla o ana geri dönmeyi sağlayan debug save/load desteği.

---

## BÖLÜM 1: Kritik Bugfix, Performans ve Bellek Optimizasyonu

- [!] **BUG-01:** Menü ve Kapı Sahnesi Giriş Takılmaları (Shader & Asset Hitching) — `src/cekirdek/varlik_onbellek.gd` kurularak modeller, materyaller ve fontlar arka planda (`ResourceLoader.load_threaded_request`) yüklenerek ana iş parçacığı rahatlatılacak.
- [!] **BUG-02:** Sıra Atlama Rüşvetinde Kuyruk Senkronizasyon Hatası — Rüşvetle öne geçmek isteyen NPC'nin kuyruk listesinde `erase` ve `push_front` ile en başa taşınması ve hemen kapı çizgisine yürümesi. **≡ KAP-15** — ayrı paket değil; KAP-15 bu maddeye referans verir.
- [!] **BUG-03:** Rüşvet Kabul ve Ret Repliklerinin Sessiz Kalması — Rüşvet kabul veya reddedildiğinde diyalog kutusuna uygun ses ve CSV repliğinin düşmemesi sorunu çözülecek.
- [!] **BUG-04:** Kapı Sahnesinde Işık ve Gölge Optimizasyonu — Meşale ışıklarındaki dinamik gölge haritası boyutu düşürülecek, gereksiz mesafe kontrolleri LOD ile optimize edilecek.
- [!] **BUG-05:** Boşta Duran Scriptlerin İşlemci Tüketimi (`_process` Hijyeni) — Kapı ve menü ekranlarında aktif girdi almayan düğümlerin `set_process(false)` ile uyutulması.
- [!] **BUG-06:** 3D Karakter Bellek Sızıntısı (Orphan Nodes) — Kapıdan içeri giren veya geri dönen karakter sahnelerinin ağaçtan silinirken bellekten düşmemesi hatası `queue_free()` kontrolleriyle giderilecek.
- [!] **BUG-07:** CSV Sözdizimi ve Tırnak Hataları Fallback Mekanizması — Eksik anahtar durumunda oyunun kilitlenmesi önlenecek, ekrana güvenli `[KEY_NOT_FOUND]` basılarak çalışmaya devam edilecek. **≡ SYS-09** (metinler.csv doğrulama / isimlendirme birleşik paket).
- [!] **BUG-08:** Gece Sonu Hesaplamasında Çift Sayım Bug'ı — UI hızlandırma (2x) açıkken gün bitişine basıldığında tüketim fonksiyonunun iki kez tetiklenmesi engellenecek.
- [!] **BUG-09:** Animasyon Oynatıcısında Eksik Klip Çökmesi — Bir modelde istenen animasyon yoksa sessizce varsayılan idle klibine geri dönen koruma bloğu yazılacak.
- [!] **BUG-10:** Düşük Donanım Grafik Ayarları Profili — Düşük grafik modunda partiküllerin (meşale kıvılcımı, duman) kapatılması ve 3B çözünürlük ölçeğinin ayarlanabilmesi.

- [!] **BUG-11:** `gece_sonu` Çift Tetik Koruması — Gün bitişinde buton `disabled` + hız 1x; **BUG-08 hâlâ açık**; BUG-11 onun düzeltme/koruma alt adımı (ayrı numara).
- [!] **BUG-12:** `_klip_onbellek` `has()` / idle Fallback — Eksik animasyon klipinde `has()` kontrolü ve idle'a düşme (**taslak yol notu** OK; KarakterModel üzerinde).
- [!] **BUG-13:** Kapı Kamera FOV Sabitleme — Kapı sahnesinde FOV kayması/zoom drift'inin sabitlenmesi.
- [!] **BUG-14:** `Ses.oynat` Havuz Temizliği — Ses oynatıcı havuzunun sahne geçişlerinde temizlenmesi / sızıntı önleme.
- [!] **BUG-15:** Heybe `mouse_filter = STOP` — Heybe paneli açıkken tıklamanın 3B sahneye sızmasını engelleme.

---

## BÖLÜM 2: Kapı Sorgusu, Tansiyon ve 2D Heybe Clue Motoru

- [x] **KAP-01:** JSON Diyalog Ağacı İskeleti (KİLİTLİ)
- [/] **KAP-02:** Tansiyon Durum Makinesi (`src/kapi/tansiyon_yoneticisi.gd`) [AKTİF] — 0–3 Sakin, 4–7 Gergin, 8–10 Panik aralıklarının diyalog seçimlerindeki tansiyon çarpanlarıyla (+/−) güncellenmesi.
- [/] **KAP-03:** 2D Heybe Paneli Arayüzü (`src/arayuz/kapi/heybe_paneli.gd`) [AKTİF] — Karakterin yanında açılan, tıklandığında büyüyen ve ipucu kartı açan 2D eşya/nişan vitrini.
- [x] **KAP-04:** Obje 1 (Nişan / Mühür) Etkileşimi — Karakterin taşıdığı rozet, mühür, berat veya fermanın incelenmesi ve ilgili `Clue_*` anahtarının hafızaya atılması. (Codex)
- [x] **KAP-05:** Obje 2 (Yük / Çuval) Etkileşimi — Saman altı, gizli bölme veya sahte taban kontrolleriyle kaçak eşya tespit mekanizması. (Codex)
- [x] **KAP-06:** Görsel Hata (Yara / İz) İnceleme Alanı — Karakterin modelindeki fiziksel çelişkilerin (harç kireci, zincir yarası, süt lekesi) 2D görsel portre üzerinden tıklanması. (Codex)
- [x] **KAP-07:** Dal 3 (Kanıt & Suçlama) Kilit Mantığı — Gerekli ipucu elde edilmemişse 3. diyalog seçeneğinin kilitli kalması; ipucu varsa sert suçlama seçeneğinin parlaması. (Codex)
- [x] **KAP-08:** Panik Eşiği ve Zorunlu Ret Kilitlenmesi (`Flag_Kilitlendi`) — Tansiyon 8'e ulaştığında karakterin kılıç çekmesi/bağırması, barışçıl kabulün kapanması; sadece Kışla/Zindan, Zorunlu Ret ve Rüşvet kalması. (Codex)
- [x] **KAP-09:** Diyalog İçi Blöf ve İkna Başarı Olasılığı — Muhafızın tecrübesine ve karakterin tansiyonuna göre yalanı çürütme seçeneklerinin dinamik başarı zarı. (Codex)
- [x] **KAP-10:** Sorgu İçi Ses Efektleri (SFX) Tetikleyicisi — Çapa şakırtısı, ferman yırtılması, bebek soluğu ve kılıç kabzası seslerinin diyalog replikleriyle eşzamanlı çalması. (Codex)

- [ ] **KAP-11:** İpucu Runtime Servisi (`src/kapi/ipucu_yoneticisi.gd` — **taslak hedef yol**) — 2D heybe/portre etkileşimlerinden üretilen `Clue_*` anahtarlarını oturumdan bağımsız toplayan, mükerrer kaydı engelleyen servis katmanı.
- [ ] **KAP-12:** Tansiyon Göstergesi UI (`src/arayuz/kapi/tansiyon_gostergesi.gd` — **taslak hedef yol**) — Karakter tansiyonu 0–10 dinamik bar/gösterge; Sakin (0–3), Gergin (4–7), Panik (8–10) eşik renkleri.
- [ ] **KAP-13:** `Flag_Kilitlendi` Karar Buton Kısıtı — Tansiyon ≥8 iken Kabul `disabled = true`; yalnızca Zorunlu Ret, Kışla ve Rüşvet seçilebilir.
- [ ] **KAP-14:** 2D Eşya İnceleme Modal Kartı (`src/arayuz/kapi/esya_detay_karti.tscn` — **taslak hedef yol**) — Heybe Obje 1/2 tıklanınca açılan görsel/fiziksel inceleme kartı.
- [ ] **KAP-15:** Sıra Atlama Rüşvet Entegrasyonu — **≡ BUG-02 — ayrı paket değil**; kuyruk `erase`/`push_front` senkronu BUG-02 altında takip edilir.

---

## BÖLÜM 2.5: Karakter Veri Sözleşmesi (CHR → Runtime Şeması)

Amaç: CHR_001–030 sayfalarındaki tüm kurgusal verilerin kodda tek bir standart `KarakterVerisi` kaynağına (`.tres` / Dictionary) dönüştürülmesi ve ajanlar arası veri tutarlılığının kilitlenmesi.

- [x] **KVR-01:** KarakterVerisi Temel Resource Sınıfı (`src/veri/karakter_verisi.gd` — **taslak hedef yol**) — `entity_id: StringName`, `ad: String`, `sinif: StringName`, `fraksiyon: StringName` ve `en_erken_tur: int` temel alanlarını içeren tip tanımlı veri yapısı. (Codex)
- [x] **KVR-02:** Bölüm 1 Eşlemesi (Secere, Doğum Yeri ve Kırılma Olayı) — Karakterin aile bağı, kırılma olayı ve köy içi gündüz/gece davranış hedeflerinin veri nesnesine string/enum olarak bağlanması. (Codex)
- [x] **KVR-03:** Bölüm 2 Eşlemesi (Heybe ve İpucu Sözleşmesi) — `obje_1: Dictionary`, `obje_2: Dictionary` ve üretecekleri `uretilen_ipucu: StringName` (ör. `Clue_CHR015_BentCapasi`) sözlüğü. (Codex)
- [x] **KVR-04:** Bölüm 3 Eşlemesi (Görsel Hata ve Tansiyon Pozları) — `gorsel_hata_ipucu: StringName` (`Clue_Görsel_*`), başlangıç tansiyonu (**1–3**, Ahmet kararı; eski 2–3 değil) ve Idle/Stressed/Panic animasyon kütüphanesi anahtarları. (Codex)
- [x] **KVR-05:** Bölüm 4 Eşlemesi (Diyalog Düğümleri ve Tansiyon Delta Şeması) — Düğüm 00, Dal 1 (Yol), Dal 2 (Geçmiş), Dal 3 (Kanıt) metin anahtarları ile her seçeneğin üreteceği tansiyon değişimi (`tansiyon_delta: int`). (Codex)
- [x] **KVR-06:** Bölüm 4 Bayrak Sözleşmesi (`Flag_*` Alanları) — Karakter sorgusunda tetiklenebilecek 4 standart bayrağın (`Flag_Yol_Sirri_Acik`, `Flag_Kimlik_Cozuldu`, `Flag_Sir_Tamamen_Cozuldu`, `Flag_Kilitlendi`) sözlük karşılığı. (Codex)
- [x] **KVR-07:** Bölüm 5 Karar Matrisi Şeması (Anlık Etkiler) — Kabul, Gönüllü Ret, Zorunlu Ret, Rüşvet (kişisel akçe/eşya) ve Kışla (zindan) durumlarının anlık 5 stat (Refah, Erzak, Güvenlik, Moral, Sağlık) etkileri. (Codex)
- [x] **KVR-08:** Bölüm 5 Gecikmeli Olay/Debuff Şeması — `gecikmeli_etkiler: Array[Dictionary]`: `{ "tur_offset": 3, "hedef_bina": "Ahir", "olay_id": "GeceBicaklamasi", "stat_etkisi": {"Guvenlik": -3} }`. (Codex)
- [x] **KVR-09:** Takip Eden Karakter Zinciri Şeması (Spawn Offsets) — `sonraki_spawns: Dictionary`: karara bağlı (`on_accept`, `on_reject`, `on_bribe`, `on_jail`) çağrılacak yeni NPC ID'si ve tur gecikmesi (`offset: int`). **Not (Gemini):** NPC kuyruk runtime hazır (VAR: kuyruk+ofset); CHR parser okuma kaldı — tam [x] değil. (Codex)
- [x] **KVR-10:** Otomatik CHR Markdown → `.tres` Derleme Betiği (`tools/chr_parser.py` — **taslak hedef yol**) — `karakterler/CHR_*.md` dosyalarını okuyup eksik alan kontrolü yapan ve doğrudan oyuna hazır `.tres` dosyası çıkaran derleme aracı. (Codex)

- [ ] **KVR-11:** `metinler.csv` Anahtar Standardı Sözleşmesi — Replik: `CHR_XXX_DUGUM_YY_REPLIK`; seçenek: `CHR_XXX_DUGUM_YY_SEC_Z_METIN`; heybe: `CLUE_CHRXXX_ESYA_ADI_BASLIK` / `_TANIM`; CSV'ye satır bazlı ekleme kuralı.
- [/] **KVR-12:** Bina Adı Sözlüğü — CHR hedef binalarını katalogdaki türlerle birebir eşleyen statik sözlük (ör. Köy Meydanı, Ahır, Muhafız Kışlası, Değirmen, Şifahane, Bostan).
- [ ] **KVR-13:** Tansiyon / Stat Clamp — Runtime sınır kontrolü: tansiyon 0–10; karar anlık etkileri tipik −4…+4 clamp.
- [ ] **KVR-14:** Eksik Alan Fallback — CHR/`KarakterVerisi` okumada boş veya eksik alanda güvenli varsayılan profil; çökme yok.
- [ ] **KVR-15:** `dogrula() -> bool` — Zorunlu alanlar (ID, başlangıç tansiyonu, karar etkileri) derleme/başlangıçta geçerlilik teyidi (**taslak hedef**: `KarakterVerisi.dogrula` / `tools/chr_parser.py`).

---

## BÖLÜM 3: Karakter Yetenek, Meslek Sinerjisi ve Kişilik Dinamikleri

- [ ] **UZM-01:** Karakter Zanaat Sınıflandırması (`ZanaatTuru` Enum) — Çiftçi, Bostancı, Çoban, Değirmenci, Kalaycı, Cerrah, Demirci, Asker, Tellal, Kâtip gibi net zanaat rollerinin kodlanması.
- [ ] **UZM-02:** İkili Pasif Özellik Matrisi (Trait Sistemi) — Her karaktere atanmış güçlü ve zayıf yönler (ör. "Gece Nöbetçisi", "Ağır Yük Ustası", "Hırsızlığa Meyilli", "Korkak").
- [ ] **UZM-03:** Bina–Meslek Uyumluluk Çarpanı — Bostancının Bostanda çalışması: +%60 verim; Demircide: −%50 verim ve alet kırma riski.
- [ ] **UZM-04:** Usta–Çırak Eğitim Sinerjisi — Usta zanaatkarın (ör. Osman Dayı) yanına yerleştirilen vasıfsız köylünün 5 gün sonra yarı-usta seviyesine yükselmesi.
- [ ] **UZM-05:** Çapraz Çalışma Sakatlanma ve Kaza Riski — Askerin tarlada tırpanla bacağını kesmesi veya çiftçinin kışlada nöbet tutarken uyuyakalması gibi uyumsuzluk kazaları.
- [ ] **UZM-06:** Köylü Kişisel Memnuniyet ve İsyan Eşiği — Sevdiği işte çalışan köylünün Moral sağlaması; zorla kışlaya yazılan zanaatkarın sabotaj ihtimalinin artması.
- [ ] **UZM-07:** Sosyal Çatışma ve Kan Davası Dinamiği — Düşman köy/aşiretten iki kişinin aynı binaya atanması → üretim durması ve kavga olayları.
- [ ] **UZM-08:** Yaşlılık ve Çocuk Rol Kısıtlamaları — Yaşlıların ağır fiziksel iş yapamaması; Değirmende danışmanlık/denetim bonusu.
- [ ] **UZM-09:** Gizli Eğilimler (Hidden Alignment) — İçeri sızan haydutların iş başında gibi görünüp geceleri erzak çalması.
- [ ] **UZM-10:** Köylü Kartı UI ve Görev Atama Ekranı — Köylüye tıklanınca yetenekler, geçmiş ve en verimli binaları gösteren yönetim kartı.

---

## BÖLÜM 4: Derin Ekonomi, Üretim Zincirleri ve Çift Kasa Sistemi

- [x] **EKO-01:** Çift Kasa Mimarisi (`Oturum.gd`) — `koy_akce` (kamu) ile `muhafiz_akce` (kişisel gizli kese) kesin ayrımı. (Codex)
- [ ] **EKO-02:** Odun ve Kereste Üretim Zinciri — Orman → Tomruk → Hızar/Bıçkıhane → Kalas (inşaat) ve Odun (yakıt).
- [ ] **EKO-03:** Çeki Hayvanı Lojistik Çarpanı — Öküz/İnek varken taşıma kapasitesi ×3, süre yarıya iner.
- [ ] **EKO-04:** Tahıl, Un ve Ekmek Döngüsü — Tarla/Bostan (buğday) → Değirmen (un) → Köy Fırını (ekmek/erzak); unsuz fırın çalışamaz.
- [ ] **EKO-05:** Taş Ocağı, Kireç ve Harç Üretimi — Sur/taş binalar için ham taş ve kireç kuyusunda harç.
- [ ] **EKO-06:** Demir Madenciliği, Ocak ve Alet Aşınması — Demirci alet üretir; alet yoksa üretim hızı %70 düşer.
- [ ] **EKO-07:** Asker Maaşları ve Kamu İsyan Eşiği — Kışladaki askerler her gece 1 akçe; ödenmezse güvenlik çöker, rüşvete yönelim.
- [ ] **EKO-08:** Köy Pazarı Vergilendirme Oranları — Düşük/Orta/Ağır vergi (ağır akçe getirir, Moral ve Refahı ezer).
- [ ] **EKO-09:** Dinamik Tüketim Dengesi (Nüfus × İklim) — Her canlı: 1 Erzak/gece; soğukta +1 Odun; karşılanamazsa donma/açlık ölümleri. **Not (Gemini):** BEKLEMEDE — satır/dosya kanıtsız; yanlış kısmi kilit yok (`[x]` verilmedi).
- [ ] **EKO-10:** İflas ve Hazine Çöküşü Olayları — Köy Akçesi 3 gece üst üste <0 → tefeci baskını ve kamu mallarına el koyma.

- [ ] **EKO-11:** Kişisel Kasa (`muhafiz_akce`) HUD Göstergesi (`src/arayuz/koy_hud/kese_gostergesi.gd` — **taslak hedef yol**) — Rüşvet geliri ve kişisel kesenin köy HUD'unda gösterimi; **≡ ODA-02** yüzeyi.
- [ ] **EKO-12:** Ambar Kapasite Sınırı ve Bozulma/Ziyan Mantığı — Stok üst sınırı; aşım veya bekletmede ziyan/bozulma.
- [ ] **EKO-13:** Zanaat Aletleri Aşınma ve Verim Düşüşü Adaptörü — Tarla/maden vb. üretimde alet aşınması → verim düşüşü.
- [ ] **EKO-14:** Çift Kasa Arası Acil Kurtarma ve Zimmet Mekaniği — `koy_akce` ↔ `muhafiz_akce` acil transfer / zimmet tradeoff.
- [ ] **EKO-15:** Gece Sonu Ayrıntılı Bilanço Sözlüğü — `gece_sonu()` dönüşüne ayrıntılı bilanço alanları.

---

## BÖLÜM 5: Yaşayan Köy, Zanaat Rutinleri ve Görsel Polish

- [ ] **ANI-01:** Muhafız Modellerine Silah ve Meşale Soketleri — Kılıç, kalkan, mızrak; geceleri dinamik ışıklı meşale.
- [ ] **ANI-02:** Muhafız Dinamik Nöbet ve Devriye Rotası — Kapı, kışla ve sur kuleleri arasında düzenli yürüyüş.
- [ ] **ANI-03:** Çiftçi ve Bostancı Su Taşıma Rutini — Kuyu → kova → su arkı hendekleri döngüsü.
- [ ] **ANI-04:** Oduncu ve Öküz Tomruk Taşıma Rotası — Orman → balta → tomruk öküzle hızara.
- [ ] **ANI-05:** Çoban ve Sürü Otlatma Döngüsü — Sabah ağıl aç → çayır → akşam ağıla kapat.
- [ ] **ANI-06:** Değirmen Çarkı ve Çuval Taşıma Hareketi — Çark/pervane dönüşü; değirmenci çuvalla sundurma.
- [ ] **ANI-07:** Akşam Ateş Başı Toplanma Ritüeli — Gece boşta kalan köylülerin meydan ateşi etrafında ısınması.
- [ ] **ANI-08:** Zanaatkar Tezgâh Animasyonları — Örs/çekiç, fırın küreği vb. döngüsel hareketler.
- [ ] **ANI-09:** Hava Durumuna Göre Karakter Tepkileri — Yağmurda saçak altı; karda yavaş/büzülmüş yürüyüş.
- [ ] **ANI-10:** Sabotajcıların Gece Gölgeli Sinsi Davranışı — Ateşten uzak, kuytu bekleme; nöbetçi yaklaşınca yön değiştirme.

---

## BÖLÜM 6: Gezgin Tüccarlar, Hayvan Pazarı ve Sipariş Sözleşmeleri

- [ ] **TUC-01:** Gezgin Tüccar Takvimi ve Varış Mantığı — Her 4 günde bir uzman tüccar; 2 gün pazar konaklaması.
- [ ] **TUC-02:** Celep Hamdullah (Canlı Hayvan Tüccarı) — Öküz, inek, koç, beygir → Ahır/Ağıl.
- [ ] **TUC-03:** Nalbur ve Maden Tüccarı — Demir, çivi, tırpan, balta stoğu.
- [ ] **TUC-04:** Kumaşçı ve Aktar — Şifahane (afyon, sargı); Refah (keçe, kumaş).
- [ ] **TUC-05:** Zanaat Sipariş Sözleşmeleri (Work Orders) — "Haftaya 12 çuval un…" teklifleri sözleşme paneline.
- [ ] **TUC-06:** Sözleşme Teslimatı ve İtibar Skoru — Zamanında teslim → sadakat + sonraki nadir ürünler.
- [ ] **TUC-07:** Sipariş İhlali ve Ceza Faizi — Gecikme → tüccar terk + Refah düşüşü.
- [ ] **TUC-08:** Gezgin Silah Tüccarı (Karaborsa) — Zırh/yay/kalkan; kaçak tutsak satın alma teklifi.
- [ ] **TUC-09:** Dinamik Fiyatlandırma ve Kıtlık Enflasyonu — Kışta odun/erzak ×3; yazda ucuzlama.
- [ ] **TUC-10:** Pazar Yeri Alışveriş Arayüzü (Trade UI) — Ambar fazlası → köy veya muhafız akçesi.

---

## BÖLÜM 7: [Yeni Özellik 1] Mevsimler, Hava Durumu ve Kış Felaketi

- [ ] **MEV-01:** 4 Mevsim Döngü Motoru (`src/dunya/mevsim_yoneticisi.gd`) — Her mevsim 7 gün; 28 günlük yıl.
- [ ] **MEV-02:** Kış Soğuğu ve Don Mekaniği — Fazladan odun; biterse 1–3 köylü donar.
- [ ] **MEV-03:** Donmuş Toprak ve Tarımsal Felç — Kışın bostan/tarla üretimi durur; yalnızca ambar.
- [ ] **MEV-04:** Dinamik Kar Yağışı ve Zemin Kar Örtüsü Shader'ı — Zemin ve çatılarda kademeli kar.
- [ ] **MEV-05:** Çatı Çökmesi ve Kar Temizleme Rutini — Ağır karda çökme riski; kürekle çatı kürüme.
- [ ] **MEV-06:** İlkbahar Taşkınları ve Su Bendi Kırılması — Kar erimesi, kuyu kireci, bent onarım olayı.
- [ ] **MEV-07:** Yaz Kuraklığı ve Yangın Riski — Su tüketimi ×2; meşaleden kuru ota kıvılcım riski.
- [ ] **MEV-08:** Sonbahar Hasat Şenliği ve Moral Dopingi — Ambar doluysa şenlik → Moral zirve.
- [ ] **MEV-09:** Fırtınalı Günlerde Kapı Görüşünün Kapanması — Tipi/sis → 2D ipuçları bulanık.
- [ ] **MEV-10:** Kış Kurt Sürüsü Saldırıları — Aç kurtlar ağıla; muhafız meşale/mızrak nöbeti.

---

## BÖLÜM 8: [Yeni Özellik 2] Casus Soruşturması, Sabotaj ve Divan Yargılaması

- [ ] **CAS-01:** Köy İçi Gece Sabotaj Takip Motoru — Şüphelilerin gece ambar/kuyu/cephanelik bayrakları.
- [ ] **CAS-02:** Gece Devriyesi ve Şüpheli Yakalama Mini-Olayı — Fenerle suçüstü yakalama şansı.
- [ ] **CAS-03:** Kuyu Zehirleme ve Salgın Tespiti — CHR_002/009 içeri alınmışsa banotu + sabah zehir.
- [ ] **CAS-04:** Ambar Kundaklaması ve Yangın Söndürme Krizi — CHR_001/006; su zinciri.
- [ ] **CAS-05:** Muhafız Divanı / Mahkeme Sahnesi (`src/kapi/divan_ekrani.tscn`) — Meydanda yargılama.
- [ ] **CAS-06:** Kanıt Sunma ve Sorgulama — Kapı `Clue_*` + suç aletleri → itiraf.
- [ ] **CAS-07:** Üçlü Yargı Kararı: Zindan, Sürgün, İnfaz — Asayiş↑ Moral↓ tradeoff.
- [ ] **CAS-08:** Çete İntikam Baskını Tetikleyicisi — CHR_004 zindanda → 3 gece sonra Karaboran baskını.
- [ ] **CAS-09:** Köylü İhbar Mektupları ve Fısıltı Gazetesi — Sabah imzasız şüphe pusulaları.
- [ ] **CAS-10:** Sahte Suçlama ve Haksız Yargı Tazminatı — Masum zindan → aile terk + Moral çöküşü.

- [ ] **CAS-11:** `Clue_*` → Divan Kanıt Listesi Bağlayıcı (`src/kapi/divan_kanit.gd` — **taslak hedef yol**) — Kapı sorgu ipuçlarını divan yargılamasına taşıyan köprü.
- [ ] **CAS-12:** Kuyu Zehirleme Clue/Flag Tetikleyici — CHR_002/009 içeri alındığında banotu + sabah zehir olayını `Flag_*`/`Clue_*` sözleşmesine bağlama.
- [ ] **CAS-13:** Ambar Kundaklama Clue/Flag Tetikleyici — CHR_001/006 kundak riskini mevcut Clue/Flag sözleşmesine bağlama.
- [ ] **CAS-14:** Divan Kanıt Sunum UI — Kapıda toplanan `Clue_*` kartlarının divan sahnesinde gösterimi (CAS-05/`divan_ekrani` — **taslak hedef**).
- [ ] **CAS-15:** Clue→Divan Örtüşme Notu — KAP ipucu motoru ile CAS kanıt sunumu tek veri sözleşmesi; çift kayıt yok.

---

## BÖLÜM 9: [Yeni Özellik 3] Muhafızın Odası, Kişisel Kasa ve Yozlaşma Ağacı

- [ ] **ODA-01:** Muhafız Odası 3B/2.5B İç Mekan (`src/dunya/muhafiz_odasi.tscn`) — Yatak, masa, meşale, gizli kasa.
- [ ] **ODA-02:** Gizli Zemin Kasası (Rüşvet Deposu) — Rüşvet akçesi ve kaçak eşya; denetçiden gizli. **≡ EKO-01 / EKO-11** — `muhafiz_akce` çift kasa + kişisel kese HUD ile örtüşür; ayrı ekonomi paketi değil, ODA yüzeyi.
- [ ] **ODA-03:** Muhafız Kişisel Envanteri — CHR rüşvet eşyalarının sergilenmesi.
- [ ] **ODA-04:** Yozlaşma vs. Adalet Terazisi — "Adil Muhafız" ↔ "Yozlaşmış Derebeyi".
- [ ] **ODA-05:** Yozlaşma Yetenek Ağacı — Göz Yumma (+%50 rüşvet); Haraç Kesme (günlük esnaf).
- [ ] **ODA-06:** Adalet Yetenek Ağacı — Keskin Bakış (heybe); Gönül Bağı (isyan≈0).
- [ ] **ODA-07:** Sancak Müfettişi Teftiş Baskını — Gizli kasa bulunursa azil/idam riski.
- [ ] **ODA-08:** Oda Geliştirmeleri — Muhafız akçesiyle yatak/askılık/kütüphane → yorgunluk silme.
- [ ] **ODA-09:** Vicdan Azabı ve Gece Kabusları — Haksız ret/ölüm → rüya/algı bozukluğu.
- [ ] **ODA-10:** Oyun Sonu Muhafız Kaderi (Epilogue) — Köyden bağımsız: kaçak Venedik veya adil kahraman.

- [ ] **ODA-11:** Rüşvet → `muhafiz_akce` Oda Kasası Yazımı (`src/dunya/muhafiz_odasi.gd` — **taslak hedef yol**) — Kapı rüşvetinin gizli kasaya işlenmesi; **≡ EKO-01 / EKO-11**.
- [ ] **ODA-12:** Yozlaşma Skoru Runtime (`src/sistemler/yozlasma.gd` — **taslak hedef yol**) — Adalet↔yozlaşma terazisinin oturum alanı.
- [ ] **ODA-13:** Müfettiş Teftiş Save-Slot Taraması — Gizli kasa içeriğinin teftiş olayında save/state üzerinden kontrolü.
- [ ] **ODA-14:** Oda UI Kese Göstergesi — ODA-02 yüzeyi + EKO-11 `kese_gostergesi` (**taslak hedef yol**) köy/oda ortak gösterge.
- [ ] **ODA-15:** Epilogue Dal Seçici — Yozlaşma/adalet skoruna göre oyun sonu kader dalları (ODA-10 tamamlayıcı).

---

## BÖLÜM 10: [Yeni Özellik 4] Bölge Haritası, Dış Tehditler ve Haraç Diplomasisi

- [ ] **HAR-01:** Stratejik Çevre Haritası UI (`src/arayuz/harita_ekrani.gd`) — Taşlık Hisar, Karaboran, Tekfur, göç yolları.
- [ ] **HAR-02:** Kösedağ Moğol Akın Kolu Tehdit Sayacı — Ufukta yaklaşan öncü; kalan gün.
- [ ] **HAR-03:** Bizans Tekfuru Haraç Heyeti — Her 6 günde altın/buğday; yoksa saldırı hazırlığı.
- [ ] **HAR-04:** Selçuklu Sancak Beyi Asker Toplama Fermanı — Levent talebi; iş gücü vs. isyancı.
- [ ] **HAR-05:** Göç Kervanlarını Köye Çekme — Eşkıya temizliği → kervan uğrama ↑.
- [ ] **HAR-06:** Gözcü Kulesi ve Erken Uyarı — Kapıya kimin geleceğini 1 gün önce öğrenme.
- [ ] **HAR-07:** Ertuğrul Obası ile İttifak ve At Takası — Buğday ↔ damızlık at / alp.
- [ ] **HAR-08:** Dağdaki Çeteye Rüşvet / Anlaşma — Aylık 10 akçe → ambar/sürü dokunulmazlığı.
- [ ] **HAR-09:** Haberci Güvercin ve Ulak Sistemi — Harita krizlerinin köye anlatı sahneleri.
- [ ] **HAR-10:** 2. Perde Savunma Savaşı Taktik Konuşlanması — Sur okçu / kapı mızraklı yerleştirme.

---

## BÖLÜM 11: [Yeni Özellik 5] Salgın Hastalık, Şifahane ve Toplumsal Krizler

- [ ] **KRI-01:** Veba ve Humma Bulaşma Motoru (`src/koy/saglik_yoneticisi.gd`) — Hasta sığınmacı enfeksiyon riski.
- [ ] **KRI-02:** Şifahane Karantina Koğuşu — Şüpheliler 2 gün karantina.
- [ ] **KRI-03:** Hekim Yetkinliği ve İlaç Üretimi — CHR_008/003 şifahanedeyse ölüm %80↓.
- [ ] **KRI-04:** Su Kuyusu Kirlenmesi ve Kireçleme — Tifo riski; acil dezenfeksiyon.
- [ ] **KRI-05:** Toplu Mezar ve Cenaze Töreni — Moral 2 gün sarsılır.
- [ ] **KRI-06:** Kıtlık İsyanı ve Ambar Yağması — Erzak 2 gün 0 → ambar kapısı kırılır.
- [ ] **KRI-07:** Çınar Altı Köy Meclisi — Krizde halk oylaması.
- [ ] **KRI-08:** Batıl İnanç ve Cadı Avı Histerisi — Yabancı kadın (ör. Dudu) hedefi.
- [ ] **KRI-09:** Kaçak Leventlerin Köyü Terk Etmesi — Krizde firar → Güvenlik çöker.
- [ ] **KRI-10:** Krizden Çıkış ve Toplumsal Kenetlenme Bonusu — Atlatınca sadakat + Refah patlaması.

---

## BÖLÜM 12: Güvenli Kayıt (Migration), Ses ve Doğrulama (Sanity Check)

- [x] **SYS-01:** Sürüm Atlama ve Kayıt Göç Motoru (`guvenli_kayit.gd`) — `KAYIT_SURUMU` geçişinde `muhafiz_akce`, mevsim, yeni_binalar alanlarıyla göç. **Not (Gemini):** kısmi iz (`GuvenliKayit` + `KAYIT_SURUMU`) var ama **satır kanıtsız** — tam `[x]` verilmedi; adım adım migration doğrulanmadı. (Codex) Göç artık `tests/unit/kvr/kayit_gocu_test.gd` ile doğrulandı; Gemini notu önceki durumdur.
- [x] **SYS-02:** Atomik Kayıt Protokolü (`.tmp` Koruması) — Önce `kayit.json.tmp`, sonra atomik rename. (Codex)
- [x] **SYS-03:** Katmanlı Dinamik Tansiyon Müziği — 0–3 ney/kopuz; 4–7 yaylı; 8–10 kudüm/davul. (Codex)
- [x] **SYS-04:** Köy Dinamik Ortam Sesleri (Ambiance Bus) — Gündüz çekiç/koyun/su; gece meşale/kurt/baykuş. (Codex)
- [x] **SYS-05:** Eksik Ses Dosyası Null Audio Koruması — Güvenli `Ses.oynat()` sarmalayıcısı. (Codex)
- [x] **SYS-06:** Ajan Pre-Merge Doğrulama Betiği (`tools/sanity_check.py`) — Commit öncesi tek komut yerel test. (Codex)
- [x] **SYS-07:** Headless Godot Derleme ve Script Error Taraması — Parse/script yükleme hatalarını listele. (Codex)
- [x] **SYS-08:** Korumalı Çekirdek Fonksiyon İmza Denetçisi — `KarakterModel.kur`, `devam_istendi`, `gece_sonu` silinmesin (`git diff`). (Codex)
- [ ] **SYS-09:** Metinler CSV Doğrulama ve İsimlendirme Standardı — **≡ BUG-07** birleşik paket. Bağlayıcı anahtarlar:
  - Replikler: `CHR_XXX_DUGUM_YY_REPLIK`
  - Seçenekler: `CHR_XXX_DUGUM_YY_SEC_Z_METIN`
  - Heybe: `CLUE_CHRXXX_ESYA_ADI_BASLIK` / `_TANIM`
  - Format bozukluğu, eksik sütun, mükerrer ID denetimi.
- [x] **SYS-10:** 20 Turluk Otomatik Oyuncu Duman Testi (`otomatik_oyuncu.gd`) — Headless 20 gece; bellek/çökme kontrolü. **Not (Gemini):** kısmi iz (headless otomatik oyuncu) var ama **sabit 20 tur satır kanıtsız** — tam `[x]` verilmedi. (Codex)

- [ ] **SYS-11:** Ajan Pre-Merge `sanity_check` Paketi (`tools/sanity_check.py` — **taslak hedef yol**) — Commit öncesi CSV/anahtar/script tarama tek komut; SYS-06 ile tamamlayıcı.
- [ ] **SYS-12:** Runtime `[KEY_NOT_FOUND]` / `MISSING_KEY` Gösterimi — **≡ BUG-07 / SYS-09**; eksik metin anahtarında güvenli ekran metni.
- [ ] **SYS-13:** `memory_free` / Düşük Donanım Bellek Paketi — **taslak hedef**; düşük VRAM/RAM profilinde cache temizliği (BUG-10 ile ilişkili).
- [x] **SYS-14:** `KAYIT_SURUMU` Adım Adım Migration — SYS-01 tamamlayıcı; sürüm N→N+1 alan göç fonksiyonları (satır kanıtsız uyarı geçerli). (Codex)
- [x] **SYS-15:** `otomatik_oyuncu` Sabit 20 Tur Kilidi — SYS-10 tamamlayıcı; headless duman testinde tur sayısının sabitlenmesi. (Codex)

---

**Gemini döngü 1–7 birikimi (2026-10-06):** KAP/KVR/EKO/SYS/BUG/CAS/ODA +11…15 eklendi; örtüşmeler (KAP-15≡BUG-02, BUG-07≡SYS-09, ODA-02≡EKO-01/EKO-11) notlandı; kanıtsız path = taslak hedef; kanıtsız `[x]` yok.
