# User project rules

These explicit user instructions take precedence over conflicting collaboration or approval guidelines in CLAUDE.md and other project documents.

- Project working copy: C:\Users\ds\Documents\Codex\2026-10-06\c\GameDevoloper
- Required local mirror: C:\Users\ds\Documents\GitHub\GameDevoloper
- Automatically transfer every change made for the user in this project to the required local mirror, including code, assets, configuration, documentation, new files, renames, and deletions. Do this during the task and before reporting completion; never wait for a commit prompt or separate transfer approval.
- Apply synchronization to the files changed by the task. Preserve unrelated local work. Do not blindly replace the entire checkout, its .git directory, branch, or history. If the same file has independent changes, reconcile them and preserve both intended changes; ask only when a real conflict requires the user's decision.
- Latest user override (7 October 2026): take autonomous responsibility for the entire project and keep developing without waiting for routine design decisions. The user explicitly authorized committing and pushing all Codex changes made so far to GitHub; the previous wait-for-commit restriction is superseded for this publication. Resolve ordinary design contradictions with documented decisions and tests. Preserve unrelated work and secrets; never force-push without explicit authorization.
- Latest user override: Claude handoff is cancelled. Codex continues autonomous project development; do not send Claude briefings, transfer ownership at usage thresholds, or perform reset-triggered takebacks. The old handoff automation is disabled.
- Keep these rules in both copies whenever updating them.

# Kapı Muhafızı — Çoklu Ajan ve Geliştirici Çalışma İlkeleri

Bu doküman, `berk103458/GameDevoloper` projesinde çalışan tüm yapay zeka ajanları ve geliştiriciler için **zorunlu kuralları** içerir. Herhangi bir kod yazmadan veya dal (branch) açmadan önce bu kuralların okunması ve uygulanması şarttır.

---

## 1. Dal (Branch) Disiplini ve Tek Doğruluk Kaynağı

- **Tek Aktif Ana Dal:** Oynanabilir ana oyun ve özellik entegrasyonu yalnızca `claude/festive-volta-li1sfm` (veya tanımlanmış ana entegrasyon dalı) üzerinden yürütülür.
- **Paralel Ana Dal Yasağı:** Bağımsız ikinci bir "tam oyun" dalı (`keen-cerf` vb.) açılamaz ve orada ana oyun mantığı ilerletilemez.
- **Feature Dalları:** Her yeni özellik, güncel festive dalından açılan kısa ömürlü bir feature branch'te (`feature/<ozellik-adi>` veya `cursor/<ad>-<sonek>`) geliştirilir. İş bitince PR **hedefi festive** olur. Dal, festive ilerleyince güncel festive ile birleştirilerek PR yaklaştırılır; uzun süre ayrı kalan paralel dal bırakılmaz.
- **Merge Ahmet’te:** Ajan kendi PR’ını veya başkasının PR’ını (`#2`, `#4` ve sonrakiler) kendiliğinden merge etmez. PR #1 festive→keen entegrasyon yolu değildir; ikinci tam oyun dalına özellik taşımak yasaktır.
- **Anlamlı commit:** İş bitmeden “bitti” denmez. Commit mesajı neyin neden değiştiğini söyler (`type(scope): açıklama`). `d`, `fix`, `update` gibi tek kelimelik mesaj yasaktır.
- **Deneysel Dallar:** Deney dalları uzun süre ayrı kalamaz; ya küçük parçalar halinde festive'ye entegre edilir ya da arşivlenir.
- **Ahmet yerel çekme:** Bulut ajanı Windows kopyalarına yazamaz ve “yerelde eşitledim” diyemez. Push veya PR sonrası Ahmet şu iki yolda `claude/festive-volta-li1sfm` çeker: `C:\Users\ds\Documents\Codex\2026-10-06\c\GameDevoloper` ve `C:\Users\ds\Documents\GitHub\GameDevoloper`.

---

## 2. Korumalı Çekirdek Dosyalar (Paralel Yazma Yasağı)

Aşağıdaki çekirdek dosyalar, birden fazla dalda aynı anda değiştirilemez:

- `src/arayuz/ana.gd`, `koy_ekrani.gd`, `tema.gd`, `hud.gd`
- `src/dunya/karakter_model.gd`, `koy_yonetim_sahnesi.gd`
- `src/sistemler/oturum.gd`, `ses.gd`, `koy_nufusu.gd`, `guvenli_kayit.gd`
- `data/metin/metinler.csv`
- `tests/oto/otomatik_oyuncu.gd`

**Çift HUD yasağı:** `Hud` / `KoyEkrani` yanında ikinci bir kök HUD yazılmaz. Yeni gösterge `src/arayuz/koy_hud/` (veya kapı için `src/arayuz/kapi/`) altında **yeni dosya**dır; çekirdeğe yalnız ince adaptör girer. İki dal aynı anda `hud.gd` veya `koy_ekrani.gd` yazamaz.

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
  - Bu dosya veya `class_name` festive’e eklenmez, commit’e sızdırılmaz ve ihlali gizlemek için `.gitignore`’a konmaz. Ağaçta yoksa silinecek bir şey yoktur; varsa ana yola alınmadan kaldırılır.
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

## 0. Bitiriş kontrolü (her ajan)

İş tesliminden önce `docs/AJAN_DUZEN.md` listesi uygulanır. Özet:

1. Yeni davranış yeni dosya + ince adaptördür. `koy_sahnesi` / `KoyYerlesimi` yok. Çekirdek ve kök HUD paralel yazılmaz.
2. Biten ROADMAP maddesi `[x]` olur ve satır `(AjanAdı)` ile biter. Bitmeyen, açık PR’da kalan veya festive’te dosyası olmayan madde `[x]` olmaz; açık PR için `PR #N bekliyor` notu yazılır. Dosyası olmayan `[/]` aktif kilit kaldırılır.
3. Kendi status dosyası güncellenir (aşağıdaki yönlendirme). Başka ajanın günlüğüne onun ağzından yazılmaz.
4. Anlamlı commit atılır, dal festive’e yaklaştırılır, PR festive’e açılır veya güncellenir. Merge Ahmet’tedir.
5. Ahmet’e iki yerel yol hatırlatılır (bölüm 1). Bulut ajanı o klasörlere yazdı demez.

**Status dosyası:** Claude → `CLAUDE.md` içindeki ajan durumu (studio şablonunu silmeden); Codex → `codex.md/Codex.md`; Gemini → `GEMINI.md`; Cursor ve diğer ajanlar → `codex.md/<AjanAdı>.md`. Muharrir isteğe bağlı (`codex.md/Muharrir.md`). Her commit/push sonrası o dosyada kimlik, üzerinde çalışılan iş, sonraki adım ve festive HEAD yazılır.
