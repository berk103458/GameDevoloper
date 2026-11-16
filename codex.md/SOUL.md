# Kapı Muhafızı — Codex kalıcı çalışma kuralları

Kaynak: Ahmet'in 7 Ekim 2026 açık talimatı. Bu dosya kalıcı proje hafızasıdır; işe başlarken AGENTS.md ile okunur. Daha yeni açık kullanıcı talimatı önceliklidir.

- Tek ana çalışma dalı `claude/festive-volta-li1sfm`; ortak repo `berk103458/GameDevoloper`.
- Bölüşüm (Ahmet, 15 Kasım 2026): ROADMAP_2'de kalan açık/yarım maddeler Berk tarafının; Meshy, Gemini metin işleri ve ROADMAP 3 savaş Ahmet tarafının. Ayrıntı: AGENTS.md → "15 Kas 2026 bölüşümü".
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

- Ahmet/Muharrir, 8 Ekim asset kuralı: asset üretimi/indirme yok; mekanik basit kutu/düz renk yer tutucuyla tamamlanır. Eksik gerçek asset docs/EKSIK_ASSET_ENVANTERI.md G tablosuna kapanış commitinde kaydedilir; yeni asset gerekmiyorsa commit başlığında "asset gerekmedi" belirtilir. BUG-03/15 Cursor tarafından kapandı, tekrar alınmaz. KAP-02/03 sahipsizse [ ] kalır; üstlenince ad yazılır.

- 8 Ekim Muharrir talimatı: yeni rutin mantığı koy_halk_hareketi.gd içine eklenmez; yeni rutin dosyasına tek satırlık adaptör çağrılarıyla bağlanır. Status kontrol edilen son commit bilgisini taşır, boş başlık bırakılmaz.

## Güncel asset teslim kuralı — 12 Ekim 2026 (Ahmet/Muharrir)

Önceki ekleme/üretim sırası yerine: üretim tamamlanana kadar mekanikler isim etiketli kutu yer tutucuyla bitirilir; asset beklenmez. Assetler üretim sonunda ayrı entegrasyonla eklenir. docs/EKSIK_ASSET_ENVANTERI.md aktif 2D / 3D başlıklarıdır; eski G tablosuna ekleme yönlendirmesi geçersizdir. Her yeni 2D ihtiyacı için aynı maddede gece_kapisi stilinde tekli İngilizce Nano Banana promptu, dosya adı, boyut ve saydamlık hazırlanır; saydam kaynak düz #00FF00 yeşildir. 3D için kısa tanım ve metreyle ölçü yeterlidir.

## ENGELDE DURMA YOK (Berk, 16 Kasım 05:20)

ROADMAP ajanları (Claude, Antigravity, Codex) için kalıcı kural:
- Bir maddede engele ya da ön koşula takılan ajan DURMAZ.
- Önce engeli kendisi çözmeye çalışır: ön koşulu tamamlar, hata veren testi düzeltir ya da bağımlı maddeyi önce bitirir.
- Çözemezse engeli kendi günlüğüne kısaca yazar, o maddeyi atlar ve sıradaki boş maddeye geçer; döngü devam eder.
- Hiçbir ajan "engel var" gerekçesiyle durmaz. Artık ENGEL yazıp durmak yok; yalnızca gerçek kullanım limiti dolunca durulur.
- Hiç çalışılabilir boş madde kalmadıysa çıktıya yalnızca tek satır BOS yazılır; döngü bir süre bekleyip pull yapar ve yeniden dener.
