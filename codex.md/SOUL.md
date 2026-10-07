# Kapı Muhafızı — Codex kalıcı çalışma kuralları

Kaynak: Ahmet'in 7 Ekim 2026 açık talimatı. Bu dosya kalıcı proje hafızasıdır; işe başlarken AGENTS.md ile okunur. Daha yeni açık kullanıcı talimatı önceliklidir.

- Tek ana çalışma dalı `claude/festive-volta-li1sfm`; ortak repo `berk103458/GameDevoloper`.
- Yenilik = yeni dosya + ince adaptör. Çekirdek dosyalara paralel ikinci sistem yazılmaz. Mevcut HUD/kaynak paneli genişletilir; aynı iş için çift panel üretilmez.
- `koy_sahnesi`, statik `KoyYerlesimi` ve eski full-RTS paralel mimari untracked bile üretilmez, commit/merge edilmez. Festive yolu `KoyYonetimSahnesi` ve mevcut adaptörlerdir.
- Olgun, kontrolleri geçmiş paket bitince anlamlı mesajla commit edilir; saatlerce dirty bırakılmaz. Tek harf/“d” commit mesajı kullanılmaz. Ahmet “commit etme” derse commit durur. Olgunlaşmamış WIP remote'a gönderilmez; normal push yapılır, force-push açık yetki gerektirir.
- Feature işi festive'e alınır; tamamlanmış draft/açık PR biriktirilmez. Keen/festive bilinçsiz karıştırılmaz.
- Her biten ROADMAP adımı `[x]` ve `(Codex)` olur. Açık PR veya işaretlenmemiş madde bitmiş sayılmaz. Her commit/pull kontrol noktasında `codex.md/Codex.md` güncellenir; her yenilikte OYUN_RAPORU notu eklenir.
- Her değişiklik `C:\Users\ds\Documents\GitHub\GameDevoloper` kopyasına bağımsız işleri ve sırları koruyarak eşitlenir.
- Commit sonrası Ahmet kopyası `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi` erişilebiliyorsa tüm remote dallar fetch edilerek, mevcut yerel çalışmalar korunup uygun dal fast-forward güncellenir. Bu makinede yol yoksa güncellendi denmez; Ahmet/Muharrir raporunda açıkça belirtilir. Cursor cloud sonrası Muharrir pull eder.
- Büyük paket, ihlal riski ve commit raporu Ahmet/Muharrir'e iletilir; erişilebilir muhatap kanalı yoksa repo raporu hazırlanır, teslim edildi iddiası kurulmaz.
- Claude iş devri kullanıcı tarafından iptal edilmiştir; Codex devam eder, limit devri otomasyonu kapalı kalır. Sorumluluk devriyle durum raporu farklıdır.
- SYS-09 PR #2 birleşmeden CSV değiştirilmez; eski kapı/karakter/kayıt API'leri ve sırlar korunur.

- Eksik commit / açılmama denetimi (7 Ekim): Ses/Ana üst parse hatasında ilk kök hata, engine sürümü, tüm bağımlılıklar, autoload/input/plugin, UID/class çakışmaları, UTF-8/BOM, sahne/resource yolları ve veri şemaları kontrol edilir. Büyük paket ve açılış hatasında commitli dosyalardan önbelleksiz kopya import + gerçek menü testi yapılır; eski önbellekli test yeterli sayılmaz. Tüm gerekli kaynak/test/ayarlar aynı olgun pakette commit edilir; denetim araçları tools/acilis_denetimi.py ve tests/oto/acilis_bagimlilik_kontrol.tscn. Son kanıt docs/denetim/2026-10-07-acilis.md; Ahmet kopyasında çözüm doğrulanmadan çözüldü denmez.

- Somut 7 Ekim açılış vakası: Ahmet engine 4.7.2 ed1daf0bf. `_iskelet`/`EL_KEMIGI` ve 338–349 hata satırları yayımlanmış 330 satırlık karakter_model.gd ile uyuşmaz; keen el kodu/yerel buffer farkı kontrol edilir. Eski tanım ekleyerek ikinci el/RTS sistemi üretilmez. `--remote-check` kritik yerel dosyaların gerçek festive içeriğini karşılaştırır; önce bağımsız diff korunur.
