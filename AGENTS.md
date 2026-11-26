# User project rules

These explicit user instructions take precedence over conflicting collaboration or approval guidelines in CLAUDE.md and other project documents.

- Project working copy: C:\Users\ds\Documents\Codex\2026-10-06\c\GameDevoloper
- Required local mirror: C:\Users\ds\Documents\GitHub\GameDevoloper
- Automatically transfer every change made for the user in this project to the required local mirror, including code, assets, configuration, documentation, new files, renames, and deletions. Do this during the task and before reporting completion; never wait for a commit prompt or separate transfer approval.
- Apply synchronization to the files changed by the task. Preserve unrelated local work. Do not blindly replace the entire checkout, its .git directory, branch, or history. If the same file has independent changes, reconcile them and preserve both intended changes; ask only when a real conflict requires the user's decision.
- Latest user override (7 October 2026): take autonomous responsibility for the entire project and keep developing without waiting for routine design decisions. The user explicitly authorized committing and pushing all Codex changes made so far to GitHub; the previous wait-for-commit restriction is superseded for this publication. Resolve ordinary design contradictions with documented decisions and tests. Preserve unrelated work and secrets; never force-push without explicit authorization.
- Newest user override (9 October 2026): Codex and Claude work together on this project — Codex guides/reviews and sets the next step, Claude implements, both follow ROADMAP order. This supersedes the earlier "Claude handoff is cancelled" rule below (kept for history).
- Latest user override: Claude handoff is cancelled. Codex continues autonomous project development; do not send Claude briefings, transfer ownership at usage thresholds, or perform reset-triggered takebacks. The old handoff automation is disabled.
- Keep these rules in both copies whenever updating them.

# Kapı Muhafızı — Çoklu Ajan ve Geliştirici Çalışma İlkeleri

Bu doküman, `berk103458/GameDevoloper` projesinde çalışan tüm yapay zeka ajanları ve geliştiriciler için **zorunlu kuralları** içerir. Herhangi bir kod yazmadan veya dal (branch) açmadan önce bu kuralların okunması ve uygulanması şarttır.

Ajan listesi ve kitleri: docs/AJAN_KITLERI.md. Kalfa = Ahmet'in Codex'i (Berk'in Codex'i değil); kimlik: codex.md/Kalfa.md. Başka ajanın [/] sahipliğine dokunma.

## Roller

Bu not mevcut işleyişi bozmaz. Berk tarafında Claude ile Codex arasındaki iç dağıtım kendi aralarında sürer. 9 Ekim 2026’da Ahmet’in onayıyla roller şöyle durur:

- **Muharrir** (Ahmet’in Grok Bot asistanı) sessiz koordinatördür. Ajanların günlük işine karışmaz. Blokları ajanlar arasında bölüştürür, çakışma ve kural uyumunu denetler, pull ve uyum raporlarını yazar. Duyurular `docs/MUHARRIR_RAPORU.md` başındadır; orada yazan bölüşüm ve uyarı geçerlidir.
- **Claude (Berk)** zor ve kapsamlı işleri alır; Codex’in işinin test ve onayını da o yapar.
- **Codex (Berk)** kolay ve orta işleri alır. Zor iş Claude’da kalır; bu, süregelen düzendir.
- **Kalfa** (Ahmet’in Codex’i) Muharrir’in verdiği ayrı bloğu alır. İmzası `(Kalfa)` olur.
- **Cursor ajanları** Muharrir’in verdiği düzeltme ve doğrulama işlerini alır.
- **testx** (eski adı Tester; EVREN üzerindeki DeepSeek modeli, 11 Ekim 2026, Berk): ROADMAP 2'de Codex ile birlikte **kod yazar** (Claude madde verir, testx uygular ve test yazar, Claude inceleyip yayınlar; kod rehberi `docs/tester/TESTX_KOD_REHBERI.md`) ve tam zamanlı test ajanıdır: oyunu açar, sürekli test eder; bulgu (`docs/tester/BULGULAR.md`), değişiklik önerisi ve gelişim raporunu Claude’a verir. Kod değiştirmez. Eğitimi ve kuralları Claude yazar ve yönetir: `docs/tester/TESTER_REHBERI.md`, skill `.claude/skills/kapi-tester`, günlük `codex.md/Tester.md`.
- **Claude alt ajanları** (Berk tarafı, 25 Kasım 2026, Berk): Claude odada lider olarak çalışır ve işi şu alt ajanlara dağıtır; hepsi Claude'un denetiminde, imzası `(Claude)` altında çalışır. **Cursor**: kod düzenleme, düzeltme ve doğrulama. **ChatGPT**: planlama, inceleme, dokümantasyon ve test yazımı. **Gemini**: görsel/asset üretimi ve araştırma (Antigravity hattı). **OpenCode**: terminal tabanlı derleme, test ve toplu kod işleri. Hepsi bu AGENTS.md ve Ajan Masası (issue #11) kurallarına uyar; blok sahipliği ROADMAP `[/]` ile durur.

Başka ajanın `[/]` sahipliğine dokunulmaz. Bir blok değişikliği gerekirse not `docs/MUHARRIR_RAPORU.md` başına düşülür.

11 Ekim akşamına kadar koordinasyon notu: `docs/KOORDINASYON_DEVIR.md`.

Anlık iletişim: Ajan Masası = GitHub issue #11. Her turun başında `gh issue view 11 --comments` ile son yorumlar okunur; sana (@Codex/@Claude/@Kalfa/@Muharrir/@Cursor) yazılmışsa `gh issue comment 11 --body "[Gönderen → Alıcı] [ETIKET] konu: içerik"` ile cevaplanır. Sahiplik yine ROADMAP `[/]` ile durur; token paylaşılmaz. Mesajlar sade Türkçe ve tek konudur. Başlık `[Gönderen → Alıcı] [ETIKET] konu`. Etiketler: SORU, CEVAP, UYARI, SORUN, BITTI, DEVIR. SORUN’da ne olduğu, hangi dosya veya madde yazılır; insan kararı gerekiyorsa @ahmetbtopcu ve @berk103458 etiketlenir. Çözülen konu `[ÇÖZÜLDÜ]` ile biter. Ayrıntı issue #11’deki ikinci yorumdadır.

---

## 1. Dal (Branch) Disiplini ve Tek Doğruluk Kaynağı

- **Tek Aktif Ana Dal:** Oynanabilir ana oyun ve özellik entegrasyonu yalnızca `claude/festive-volta-li1sfm` (veya tanımlanmış ana entegrasyon dalı) üzerinden yürütülür.
- **Paralel Ana Dal Yasağı:** Bağımsız ikinci bir "tam oyun" dalı (`keen-cerf` vb.) açılamaz ve orada ana oyun mantığı ilerletilemez.
- **Feature Dalları:** Her yeni özellik, güncel festive dalından açılan kısa ömürlü bir feature branch'te (`feature/<ozellik-adi>`) geliştirilir. İş bittiğinde aynı gün PR ile festive'ye aktarılır ve dal silinir.
- **Deneysel Dallar:** Deney dalları uzun süre ayrı kalamaz; ya küçük parçalar halinde festive'ye entegre edilir ya da arşivlenir.

---

## 2. Korumalı Çekirdek Dosyalar (Paralel Yazma Yasağı)

Aşağıdaki çekirdek dosyalar, birden fazla dalda aynı anda değiştirilemez:

- `src/arayuz/ana.gd`, `koy_ekrani.gd`, `tema.gd`, `hud.gd`
- `src/dunya/karakter_model.gd`, `koy_yonetim_sahnesi.gd`
- `src/sistemler/oturum.gd`, `ses.gd`, `koy_nufusu.gd`, `guvenli_kayit.gd`
- `data/metin/metinler.csv`
- `tests/oto/otomatik_oyuncu.gd`

**Kural:** Bu dosyalardan birine dokunulması gerekiyorsa:
1. Festive dalından en son sürümü çekin.
2. Dosyayı toptan yeniden yazmayın; yalnızca gereken minimal, geriye dönük uyumlu API/adaptör eklentisini yapın.
3. Küçük bir commit/PR ile hızla ana dala gönderin.

---

## 3. Mimari Kural: Yeniden Yazma (Rewrite) Değil, Genişletme (Extension)

- **Yeni Özellik = Yeni Dosya + İnce Adaptör:**
  - Yeni HUD panelleri, hayvan yapay zekaları, kamera sistemleri ve dekoratörler `src/koy/...` veya `src/arayuz/koy_hud/...` altında **yeni dosya** olarak oluşturulmalıdır.
  - Mevcut bir sınıfı baştan aşağı silip yeniden yazmak yasaktır.
- **Eski Sahne Yasağı:**
  - Eski `koy_sahnesi.gd` ve statik `KoyYerlesimi` geri getirilemez. Hedef ve standart daima `KoyYonetimSahnesi` + `KoyYonetimi` mimarisidir.
- **İsim Çakışması Önleme:**
  - Aynı `class_name` veya dosya adı iki farklı anlam taşıyamaz.
  - Var olan bir isimlendirme ile çatışma çıktığında (ör. `kaynak_gostergesi.gd` tekil kart mı, şerit mi?), mevcut olan ezilmez; yeni amaca uygun açıklayıcı yeni bir isim seçilir (ör. `KoyKaynakSeridi.gd`).

---

## 4. Birleştirme (Merge) ve İmza Koruma Standartları

Lokalde veya uzak ortamda dallar birleştirilirken "diğer daldaki dosyayı tümüyle kopyalama/ezme" (`checkout --theirs`) yöntemi kesinlikle yasaktır.

Birleştirme sırasında aşağıdaki kritik API ve sinyal imzaları korunmalıdır:
- **Sinyaller:** `devam_istendi(rapor: Dictionary)`, `oturum_bitti(son: StringName)`
- **Karakter Modeli:** `KarakterModel.kur(model, ad="")`, `yuru(hedef, hiz=...)`, `_klip_onbellek`
- **Ekonomi & Kayıt:** `Oturum` akçe erişimcileri (getter/setter), `KAYIT_SURUMU`, `GuvenliKayit`
- **Mantık Ayrımı:** UI zaman kontrolleri (1x/2x hız, geceye geçiş düğmesi) ile ekonomik/döngüsel `gece_sonu()` tetikleyicisi birbirine karıştırılamaz.
- **Metin Veritabanı:** `metinler.csv` dosya seviyesinde ezilmez; anahtar (ID) bazlı satır satır ekleme/güncelleme yapılır.

---

## 5. Doğrulama ve Kabul Kriteri (Merge Öncesi)

Merge yapılmadan önce şu adımlar doğrulanmalıdır:
1. **Sıfır Hata Politikası:** Godot headless import ve parse kontrolü hatasız tamamlanmalıdır. Konsolda `SCRIPT ERROR` veya `Failed to load script` çıktısı varken kod birleştirilemez.
2. **Birim Testler:** `koy_yonetimi` birim testleri ve mümkünse `otomatik_oyuncu` kısa koşusu sorunsuz geçmelidir.
3. **Ajan Notu:** Her ajan yaptığı değişikliği açıkça listeleyen kısa bir oturum özeti bırakmalı, böylece `OYUN_RAPORU` kolayca güncellenebilmelidir.

## 0. Her çalışmanın başında

Bu projede her çalıştığında **önce** aşağıdaki «Codex çalışma günlüğü ve ROADMAP işaretleme» kuralına uy.

---

### Codex çalışma günlüğü ve ROADMAP işaretleme (Muharrir hariç tüm ajanlar)

Proje reposunda codex.md adlı bir klaösr ekle. Basitçe kendini tanıt. Ardından ne üzerinde çalıştığını, sonraki çalışma planını, güncel durumunu rapor halinda oraya her commit ve pull ettiğinde güncelleyerek yaz.

Ayrıca roadmap üzerinde çalışmayı bitirdiğin, kapanmış adımları işaretle ve yapanın sen olduğun parantez açarak o adımın sonunda belirt.

**Dosya yönlendirme (Muharrir hariç):** Claude → `CLAUDE.md`; Codex → `codex.md/` (ör. `codex.md/Codex.md`); Gemini → `GEMINI.md`. Muharrir bu günlük kuralının dışında; isteğe bağlı tutabilir (`codex.md/Muharrir.md`).


## Güncel ajan düzeni — Ahmet, 7 Ekim 2026

İşe başlamadan `codex.md/SOUL.md` kalıcı kurallarını oku. Tek ana çalışma dalı festive; mevcut mimari ve HUD genişletilir, eski koy_sahnesi/statik KoyYerlesimi/full-RTS dosyaları untracked bile oluşturulmaz. Doğrulanmış paket bitince anlamlı mesajla commit/push yapılır; olgunlaşmamış WIP remote'a zorlanmaz. Tamamlanan feature/PR festive'e alınır; açık/draft biriktirilmez. ROADMAP `[x] (Codex)`, kendi status dosyası ve OYUN_RAPORU güncel tutulur. Her değişiklik ds GitHub kopyasına eşitlenir. Commit sonrası Ahmet'in `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi` kopyası erişilebiliyorsa tüm dallar fetch ve güvenli fast-forward ile güncellenir; yol erişilemiyorsa bunu raporla, güncellendi deme. Büyük paket/ihlal riski/commit Ahmet–Muharrir raporuna yazılır. Claude'a görev devri iptal kararı geçerlidir.

Açılış/eksik commit vakasında kalıcı denetim: tools/acilis_denetimi.py (UID dahil) ve tests/oto/acilis_bagimlilik_kontrol.tscn; büyük paket/parse hatasında yalnız commitli dosyalardan önbelleksiz import + gerçek menü kontrolü. Ahmet/Muharrir raporu docs/denetim/2026-10-07-acilis.md. Yerel hata kodu festive ile uyuşmuyorsa bağımsız diff korunur; eski keen alanları için sahte stub/ikinci sistem yazılmaz.

## Asset kuralı: üretme yok, kutu yer tutucu + envanter (Ahmet, 8 Ekim 2026; Berk güncellemesi 11 Ekim 2026)
- Hiçbir ajan asset **üretmez**: görsel, doku, 3B model, ses, müzik, animasyon dosyası yok (AI generate, script ile sentez dahil).
- **Güncelleme (Berk, 11 Ekim 2026):** İnternette oyuna **uygun ve lisansı açık** bir asset bulunursa eklenebilir. Yalnız CC0 / kamu malı ya da atıfla serbest (CC-BY) lisanslar. Kaynak bağlantısı, yazar ve lisans (atıf gerekiyorsa atıf metni) `docs/EKSIK_ASSET_ENVANTERI.md`'deki ilgili satıra yazılır. Ticari kullanımı yasak, "yalnız kişisel" ya da lisansı doğrulanamayan asset alınmaz. Döneme (13. yy Anadolu) ve oyunun üslubuna uymayan asset alınmaz. Uygun asset bulunamazsa aşağıdaki yer tutucu kuralı aynen geçerlidir; yer tutucu oyunda kısa bir isim etiketiyle görünür.
- Mekaniği yine de eksiksiz tamamla: assetin yerine basit yer tutucu kullan. 3B'de `BoxMesh`/`CapsuleMesh` gibi düz renkli temel şekil, 2B'de düz renkli `ColorRect`/kutu ve kısa etiket, seste sessiz/boş çağrı. Örnek: koyun bakımı mekaniği yapıyorsan koyun modeli üretme; koyun yerine bir kutu koy ve mekaniği kutu üzerinden çalıştır.
- Yer tutucuyu gerçek asset gelince tek yerden değiştirilebilecek şekilde kur (tek sahne/kaynak yolu veya sabit), kodun içine dağıtma.
- İhtiyaç duyduğun her asseti `docs/EKSIK_ASSET_ENVANTERI.md` dosyasına ekle: hangi ROADMAP maddesi için, asset adı ve türü, şu an kullanılan yer tutucunun yolu, arama anahtar kelimeleri (TR+EN), öncelik, ekleyen ajan.
- **ROADMAP'te bir sonraki adıma geçmeden önce**, bitirdiğin adımın eksik assetlerinin bu dosyaya yazıldığını doğrula ve aynı commit'e dahil et. Asset gerektirmiyorsa commit mesajında veya status dosyanda "asset gerekmedi" yaz. Envanter güncellenmeden adım `[x]` sayılmaz.

## ROADMAP 2 (11 Ekim 2026)
Aktif iş listesi kök dizindeki `ROADMAP_2.md`dir; `ROADMAP.md` (ROADMAP 1) tamamlandı ve yalnız okuma referansıdır. Sahiplik ve sıra kuralları `ROADMAP_2.md` başındaki AJAN İLERLEME PANOSU'ndadır.

## Commit ve kota disiplini (Muharrir, 12 Ekim 2026)
Bu kural bütün ajanlar için geçerlidir: Claude, Kalfa, Codex, testx ve sonradan katılan her ajan.

1. **Commit sıklığı:** Çalışırken en geç **1 saatte bir** ya da **her madde bittiğinde** commit at ve `claude/festive-volta-li1sfm`e push et. Uzun süre commit'siz çalışma; iş yarım kalsa bile `WIP: ...` başlıklı bir commit at. (Sandbox'ı git'e izin vermeyen ajanlar — ör. testx — teslimini `work/testx/teslim.json` ile verir; yayınlayan ajan aynı kurala uyar.)
2. **Kota satırı:** Her commit'ten sonra `codex.md/<AjanAdı>.md` günlüğüne, iş bitince de Ajan Masası'na (GitHub issue #11) kalan kotanı yaz. Örnek: `kota: %40 kaldı`. Kotanı göremiyorsan `kota görünmüyor` yaz.
3. **Kota azalınca:** Kotan **%15'in altına** düştüğünde yeni işe başlama. Elindeki işi commit'le ve push et; bitiremediğin `[/]` maddelerini `[ ]` yap ve maddenin yanına ya da Ajan Masası'na `kota bitti, bırakıldı` notu düş.

## Madde sahipliği ve bölüşüm (Ahmet, 15 Kasım 2026)
Bütün ajanlar için geçerlidir: Antigravity, Cursor, Cursor-Berk, Codex, Claude, Kalfa, testx ve sonradan katılanlar.

1. **Önce pull:** Madde almadan önce `claude/festive-volta-li1sfm` dalını tam pull et.
2. **Alınmış maddeye dokunma:** ROADMAP'te maddenin başında `[/] (AjanAdı)` varsa o madde o ajanındır. Ona kod, test, `[x]` ya da not yazma. Başkasının `[x]` maddesine de iş eklenmez; ek iş gerekiyorsa yeni madde ya da Ajan Masası notu açılır.
3. **Sahiplenme push edilmeden iş yok:** Önce yalnız `[ ]` → `[/] (AjanAdı)` değişikliğini commit'le ve push et. Push başarılı olmadan koda başlama.
4. **Push reddedilirse:** Pull et, maddeye yeniden bak. Hâlâ boşsa sahiplenmeyi tekrar push et ve devam et. Bu arada başkası almışsa kendi değişikliğini geri al ve maddeyi bırak.
5. **İlk push eden sahiptir:** Aynı maddeyi iki ajan aldıysa, ROADMAP'e ilk `[/]` push eden sahiptir. İş ikinci ajan tarafından bitirilmiş ve testleri geçiyorsa kod silinmez; sahiplik ROADMAP'te bitirene taşınır ve notlanır. Çift yazılmış kod raporlanır; silme kararı insanındır.
6. **Eski satırla ezme yok:** Rebase veya merge sırasında ROADMAP satırını kendi eski hâlinle ezme. Satırın güncel durumunu (`[x]`, doğrulama notu) koru.
7. **Bölüşüm:**
   - Antigravity `ROADMAP_2.md` başından ileri çalışır.
   - Cursor (Ahmet tarafı) sonundan geriye çalışır.
   - Berk tarafı (Claude ve alt ajanları, Codex, Cursor-Berk) Ajan Masası'nda (issue #11) bildirilen orta bölümlerde çalışır.
   - Bölge dışına çıkmak için insan ya da koordinatör (Muharrir veya Claude) onayı gerekir.

### 15 Kas 2026 bölüşümü (Ahmet, 15 Kasım 2026 19:39)

Bu karar yukarıdaki 7. kuraldaki bölge bölüşümünün yerine geçer; 1–6. kurallar aynen geçerlidir.

| Alan | Sahip | Kapsam | Öbür taraf |
|---|---|---|---|
| `ROADMAP_2.md`'de kalan bütün açık `[ ]` ve yarım `[/]` maddeler | **Berk tarafı** (Claude ve alt ajanları, Codex-Berk, Cursor-Berk, testx) | Cursor'un yarım bıraktığı 21 GRV maddesi; Antigravity'nin 8 açık maddesi (OGR-43, DYL-14, SEV-05, AYR-29, AYR-33, HAN-13, HAN-34, SOY-SON-01); Cursor'un bıraktığı KAP-18, YAP-03, KLT-47, SAH-55, YIL-09; sahipsiz bütün maddeler | Ahmet tarafı bu maddelere commit atmaz, işaretlerini değiştirmez |
| Meshy asset üretimi ve oyuna bağlanması | **Ahmet tarafı** — Antigravity | `tools/meshy/**`, `assets/meshy_manifest.json`, `assets/model/**` ve ilgili görsel bağlantı dosyaları | Berk tarafı dokunmaz |
| Gemini metin işleri | **Ahmet tarafı** — metin Gemini (Antigravity), kod bağlantısı Cursor | `docs/GEMINI_METIN_ISLERI.md`'deki anahtarlar: `dedikodu.kacis`, `arayuz.kapi.karar_kacti`, `ZAR_BASARILI`, `ZAR_BASARISIZ`, `ZAR_KILITLI`, `zar.degistirici.*` ve bunların kod bağlantısı | Berk tarafı dokunmaz |
| ROADMAP 3 savaş | **Ahmet tarafı** — Google ajanları ve Cursor | `docs/ROADMAP_3_SAVAS_ON_RAPOR.md`, ondan doğacak `ROADMAP_3` / `SVS-*` maddeleri ve savaş kodu | Berk tarafı dokunmaz |

- **Ahmet tarafı:** Antigravity, Cursor, Codex, Claude. **Berk tarafı:** Claude ve alt ajanları, Codex-Berk, Cursor-Berk, testx.
- **Ortak dosyalar** (`data/metin/metinler.csv`, `ROADMAP_2.md` gibi) iki tarafça da düzenlenebilir. Ancak yalnız kendi maddelerinin satırlarına dokunulur. Çakışma olursa Ajan Masası'na (issue #11) `[SORUN]` yazılır.
- `ROADMAP_2.md`'deki madde satırlarında yazan eski sahip adları değiştirilmez; sahiplik bu tablodan okunur.

## Güncel asset teslim kuralı — 12 Ekim 2026 (Ahmet/Muharrir)

Önceki ekleme/üretim sırası yerine: üretim tamamlanana kadar mekanikler isim etiketli kutu yer tutucuyla bitirilir; asset beklenmez. Assetler üretim sonunda ayrı entegrasyonla eklenir. docs/EKSIK_ASSET_ENVANTERI.md aktif 2D / 3D başlıklarıdır; eski G tablosuna ekleme yönlendirmesi geçersizdir. Her yeni 2D ihtiyacı için aynı maddede gece_kapisi stilinde tekli İngilizce Nano Banana promptu, dosya adı, boyut ve saydamlık hazırlanır; saydam kaynak düz #00FF00 yeşildir. 3D için kısa tanım ve metreyle ölçü yeterlidir.

## Oyun geliştirme skill'leri

- `.agents/skills/` altında Godot 4.7 skill'leri var (kaynak: gamedev-skills/awesome-gamedev-agent-skills, commit 19d93f9, Apache-2.0). Godot konusunda emin olmadığında önce ilgili skill'i oku; hangisi olduğunu bilmiyorsan `router` skill'ine bak.
- Skill'ler sadece teknik referanstır. Çelişki olursa bu dosyadaki kurallar geçerlidir: Türkçe commit ve imza, ROADMAP işaretleme, 2D asset yasağı, test kuralı (headless import/parse + hedefli test; tam sanity yalnız sonda).
- `create-game-assets` kurulu değildir; 2D görsel üretmek için hiçbir skill kullanılmaz.
- Skill klasörlerini değiştirme; güncelleme yalnızca Muharrir onayıyla yapılır.

## ENGELDE DURMA YOK (Berk, 16 Kasım 05:20)

ROADMAP ajanları (Claude, Antigravity, Codex) için kalıcı kural:
- Bir maddede engele ya da ön koşula takılan ajan DURMAZ.
- Önce engeli kendisi çözmeye çalışır: ön koşulu tamamlar, hata veren testi düzeltir ya da bağımlı maddeyi önce bitirir.
- Çözemezse engeli kendi günlüğüne kısaca yazar, o maddeyi atlar ve sıradaki boş maddeye geçer; döngü devam eder.
- Hiçbir ajan "engel var" gerekçesiyle durmaz. Artık ENGEL yazıp durmak yok; yalnızca gerçek kullanım limiti dolunca durulur.
- Hiç çalışılabilir boş madde kalmadıysa çıktıya yalnızca tek satır BOS yazılır; döngü bir süre bekleyip pull yapar ve yeniden dener.

## ONAY BEKLEME YOK (Berk, 16 Kasım 05:35)

Yapay zekâ ajanları (Claude, Antigravity, Codex ve diğerleri) için kalıcı kural:
- Berk'in ya da Ahmet'in onayını beklemeden işi doğrudan yap, kendi kararınla ilerle.
- Tek istisna: ROADMAP_2.md'de insan kararı ya da insan işi bekleyen boş maddeler. Bunlarda onay beklenmeye devam edilir: ARY-01 şablon seçimi ve ona bağlı ARY-02, ARY-03, ARY-04, ARY-70; DYL-14 örnek defteri (kayıtları yalnızca insan girer); YAZ-01 onayı.
- Güvenlik kuralları aynen geçerli: asset üretme, gizli bilgi yazma, force push ya da reset --hard yapma, yalnızca D: sürücüsünü kullan, başkalarının [/] ve [x] satırlarına dokunma.
