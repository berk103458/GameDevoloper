# Alpha görevi — oyuncu gözüyle oyna, düzelt, ihtiyaç yaz

Bu belge bir görev promptudur. Alpha (Google Antigravity, Ahmet'in Windows bilgisayarında, `agy` CLI kurulu) bu metni baştan sona uygular. Başka bir ajanın iş listesi değildir.

Hazırlayan: Cursor, 20 Kasım 2026. Dal: `claude/festive-volta-li1sfm`. Kod yazılmadı. Bu dosya yalnız talimattır.

## Kimlik ve model

- Sen Antigravity'sin. İmzan `(Antigravity)`. Günlük: `codex.md/Antigravity.md`. Görev ve soru kanalı: `codex.md/Antigravity_gorev.md`, başlık `## Antigravity sorusu`.
- Tercih edilen model: **Gemini 4 Hydrogen High**. Bu model seçicide yoksa veya kota bitmişse **Gemini 4 Argon Medium**. **Orchestrator (Argon)** vardır: Argon planlar, Hydrogen uygular. Küçük tek dosya düzeltmesinde Orchestrator açma. Bir bölümün uçtan uca planında açabilirsin. Düşünme seviyesi Orchestrator'da seçilmez. Kaynak: https://antigravity.google/docs/models/
- Çalışma kopyası: `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi`. Tek dal: `claude/festive-volta-li1sfm`. Godot 4.7.2: `C:\Users\Ahmet\Desktop\Godot.exe`. Python için `PYTHONUTF8=1`.
- Oyun adı yapılandırmada `Uçta bir kapı.` (`project.godot`). Ana sahne `res://src/arayuz/ana.tscn`. Autoload `Ses`.

İşe başlamadan `AGENTS.md` ve `CLAUDE.md` içindeki Kapı Muhafızı kurallarını, sonra bu belgeyi oku. Çelişki olursa `AGENTS.md` geçerli olur. Bu belgedeki bir cümle `AGENTS.md` ile çelişirse cümleyi uygulama, farkı `## Antigravity sorusu` altına yaz.

## Proje kuralları

- Festive'e doğrudan commit edebilirsin. `git push --force` yok. `git reset --hard` yok. `git add -A`, stash, checkout ile başkasının dosyasını geri alma yok.
- Her commit öncesi `git pull --ff-only origin claude/festive-volta-li1sfm`. Reddedilirse pull et, kendi satırını güncel dosyanın üstüne yeniden koy, tekrar dene. Başkasının `[/]` ve `[x]` satırını ezme.
- ROADMAP işareti: yalnız kendi aldığın boş madde. Önce `[ ]` → `[/] (Antigravity)` commit ve push, push başarılı olmadan o maddenin koduna girme. Bitince `[x]` ve satır sonuna `(Antigravity)`. Bu görev bir ROADMAP maddesi değildir. Yeni madde açma. Mevcut maddeye rastlarsan sahiplik kuralı durur.
- Test: değişen betik için headless import, sonra o işin hedefli testi. `SCRIPT ERROR`, `Parse Error`, `Failed to load script` veya `KALDI` varken commit yok. Tam `python -B tools/sanity_check.py` yalnız bölümün sonunda, başka ajan sanity çalıştırmıyorsa. Meşgulse hedefli testi yaz, günlükte "sanity bekliyor" de, sanity'yi zorla kesme.
- Asset üretme yok: görsel, doku, 3B model, animasyon dosyası yok. Uygun açık lisans bulunursa yalnız CC0, kamu malı veya CC-BY. Kaynak, yazar ve lisans `docs/EKSIK_ASSET_ENVANTERI.md` satırına ve gerekiyorsa `docs/credits/HAZIR_ASSET_ATIFLARI.md` dosyasına yazılır. Ticari yasak, "yalnız kişisel" ve doğrulanamayan lisans alınmaz.
- Ses: yapay zekâ ile ses üretme yok. Ses aranacaksa kaynak sayfasında el yapımı (Handmade) ve CC0 olduğu tekil sayfada yazmalıdır. "Made with …" veya üretim yolu yazılmamış parça alınmaz. Bu kural `docs/arayuz/DONEM_ASSET_ENVANTERI.md` içindeki Summer Engine ayrımına uyar.
- Sır yok. Meshy anahtarı, token, e-posta ve `.env` içeriği sohbete, günlüğe, commit'e ve MCP ortam değişkenine yazılmaz.
- Dönem: Ahmet bu görev için **14. yüzyıl Osmanlı uç beyliği**, ciddi ve gerçekçi üslup dedi. Repodaki birçok metin **13. yüzyıl Anadolu / Selçuklu uç** der (`design/art/meshy/meshy-koy-varliklari.md`, `docs/EKSIK_ASSET_ENVANTERI.md`). Bu çelişkiyi sessizce düzeltme. İlk soruyu `## Antigravity sorusu` altına tek cümle yaz ve Ahmet cevap verene kadar tarihî metinleri toplu değiştirme. Oyun mekaniği bu soruya bağlı değildir. Mekaniğe devam et.
- Diyalog doğal konuşma dilindedir. Uydurma ferman, mühür metni, ayet, tarih ve kişi adı yazma. Kaynak repoda yoksa cümleyi koyma.
- `src/` altında korumalı çekirdek dosyalar (`AGENTS.md` bölüm 2) yalnız ince adaptör ister. Dosyayı baştan yazma. `ToplulukDekoru` dekor olarak kalır. Onu ekonomiye veya tıklanabilir karaktere bağlama.
- `ROADMAP_3.md` savaş maddeleri Ahmet tarafındadır. Bu görevde savaş bölümü en sondadır ve önceki bölümler Ahmet tarafından oynanıp onaylanmadan açılmaz.

## Repoda duran ve bu görevde kullanılacak yerler

Bunları yeniden keşfetmiş gibi davranma. Oku, çalıştır, ancak kod satırı bugünkü dosyayla uyuşmuyorsa dosyayı esas al.

- Kurallar: `AGENTS.md`, `CLAUDE.md`.
- İş listeleri: `ROADMAP.md` (kapalı referans), `ROADMAP_2.md` (aktif), `ROADMAP_3.md` (savaş, en son), `ROADMAP_4.md`.
- Test kitabı: `docs/tester/TESTER_REHBERI.md`, kod kapısı `docs/tester/TESTX_KOD_REHBERI.md`, Ahmet'in elle listesi `docs/OYUN_TESTI_KONTROL_LISTESI.md`.
- Cilalama ve 60.000 üçgen kuralı: `docs/CILALAMA_PLANI.md` satır 755. Ayrı bir optimizasyon planı dosyası yoktur.
- İnceltme raporu: `docs/meshy/TOPLULUK_INCELEME.md` bölüm F. Araç: `tools/varlik/meshy_incelt.py`. PR #31 birleşimi `2c968ec4`, iş `652d96c3`: 70 model, 1501,9 MB → 83,8 MB. Mesafe kesmesi `84c33da2`, `src/koy/gorsel/topluluk_dekoru.gd` (`GORUNUR_METRE` 120). Bu kesme mesh LOD zinciri değildir. Meshy `.import` dosyalarında `meshes/generate_lods=true` içe aktarıcı varsayılanıdır. Ayrı bir doku sıkıştırma kampanyası belgesi yoktur.
- Admin: `src/debug/admin_hud.gd`. Açılış `Godot.exe --path . -- --debug-arac`. Pencerede F1 veya ters tırnak. Oyuncu sürümünde bu bayrak yoksa panel kurulmaz.
- Akış testleri: `tests/oto/*_kontrol.tscn`, otomatik oyuncu `tests/oto/otomatik_oyuncu.tscn`. Performans günlüğü testi `tests/oto/performans_gunlugu_kontrol.tscn`. Tam kapı `tools/sanity_check.py`.
- Ölçüm eksiği: `docs/tester/TESTER_GELISIM_PLANI.md` `tests/oto/olcum/performans_izi.gd` ister. Bu dosya yoktur. `src/debug/performans_gunlugu.gd` ve `src/debug/performans_seridi.gd` vardır.
- Instancing: `MultiMeshInstance3D` zemin, yıldız ve yağmurda vardır (`src/koy/gorsel/koy_arazisi.gd`, `src/dunya/kapi_manzarasi.gd`). Köy prop'larında yoktur.
- Hayvan ve tüccar kodu, dekordan ayrı: `src/koy/gorsel/celep_hayvan_gorseli.gd`, `src/koy/gorsel/canli_hayvan_surusu.gd`, `src/koy/gorsel/hazir_esya_hayvan.gd`, `src/koy/ticaret/celep_hamdullah.gd`, `src/koy/ticaret/canli_hayvan_takasi.gd`, `src/koy/ticaret/gezgin_tuccar_stogu.gd`, `src/koy/ticaret/gezgin_tuccar_takvimi.gd`, `src/koy/ticaret/tuccar_kapi_gecisi.gd`, `src/arayuz/koy_hud/celep_pazar_adaptoru.gd`, `src/arayuz/koy_hud/gezgin_tuccar_pazar_adaptoru.gd`, `src/arayuz/koy_hud/hayvan_takas_paneli.gd`, `src/arayuz/tuccar_kapi_paneli.gd`. Testler: `tests/oto/hayvan_takas_kontrol.tscn`, `tests/oto/ticaret_fiyat_kontrol.tscn`, `tests/oto/tuccar_kapi_kontrol.tscn`, `tests/oto/topluluk_dekor_kontrol.tscn`.
- Menü: `src/arayuz/ana.gd` `ana_menu`, `yeni_oyun`. `src/arayuz/menu_ekrani.gd` satırları önce `visible = false`, sonra `_sirayla_goster`. `src/arayuz/yeni_oyun_ekrani.gd` `_baslat`: geçmiş seçilmemişse fonksiyon hiçbir şey yapmadan döner. Yuva doluysa `baslat_olur` ilk basışta yalnız `_onay = true` yapar, oyunu başlatmaz. İkinci basış başlatır. Düğme metni değişmez. Bu, Ahmet'in "ilk tık tetiklenmiyor" örneğinin kodda görülen adayıdır. Bunu kanıtlanmış tek neden sayma. Pencereyi aç, hangi düğmenin ilk basışta sustuğunu logla, sonra düzelt.

## Beş hedef

### 1. Oyuncu gözüyle oyna, düzelt, ihtiyaç tut

Her bölümde önce oyunu oyna. Sonra bozuk olanı düzelt. Aynı turda ihtiyaç listesini güncelle. Liste üç yere dağılmaz.

- Oynanış notu, kasma ve bölüm kararı: `codex.md/Antigravity.md`.
- Ahmet'e soru ve bölüm onay isteği: `codex.md/Antigravity_gorev.md` içinde `## Antigravity sorusu`.
- Asset, ses, model ihtiyacı: `docs/EKSIK_ASSET_ENVANTERI.md` sonuna yeni tarihli satır. Zorunlu alanlar: madde veya bölüm adı, asset adı ve türü, yer tutucunun yolu, TR ve EN arama kelimeleri, öncelik, ekleyen `(Antigravity)`. 2B için dosya adı, piksel boyutu, düz `#00FF00` kaynak ve tekli İngilizce prompt. 3B için kısa tanım ve metre. Üretim yapma. Satır "üretilmedi" desin.

Kod ihtiyacı ve tasarım ihtiyacı envantere girmez. Onlar günlükte "ihtiyaç" başlığıyla durur. Tasarım kararı Ahmet'e aitse soru kanalına tek cümle yaz, kendin kural icat etme.

### 2. Hayvan, tüccar ve karakteri oynanışa bağla

Bağlanacak olan, zaten bir sisteme yazılmış olanlardır: celep alımı, canlı sürü, hayvan takası, gezgin tüccar stoğu ve takvimi, tüccarın kapı geçişi, kapı kararıyla köye giren kişi.

`ToplulukDekoru` ve `src/koy/gorsel/topluluk_dekoru.gd` listesi hariçtir. Bu düğümler ızgara dışında tek kopya dekordur. Onlara tıklama, görev, envanter veya ekonomi ekleme.

Bağlantı bitmiş sayılması için dört şey gerekir. Biri eksikse madde açık kalır.

1. Oyuncu kararı veya satın alması dünyada görünür sonucu değiştirir.
2. Sonuç kayıtta durur ve yükleyince geri gelir.
3. Kapı, köy veya pazar ekranında oyuncunun okuduğu bir cümle vardır. Uydurma evrak yoktur.
4. Hedefli `tests/oto` sahnesi bu sonucu `KALDI` olmadan doğrular.

Görünen model hâlâ kutuysa mekanik kutunun üstünde tamamlanır. Model üretme. İhtiyacı envantere yaz.

### 3. Kasma, donma, takılma

Her bölümde üç kayıt tut: ne yaptın, kare veya giriş ne kadar sürdü, takılma tekrar etti mi.

- Giriş örneği yukarıdaki `_baslat` ve menü belirmesidir. Düzeltme, ilk anlamlı tıklamanın ya oyunu başlatması ya da ekranda neden başlamadığını söylemesidir. Sessiz `return` kalmaz. Dolu yuva ikinci onay istiyorsa düğme metni ilk basışta bunu söyler.
- Donma: pencere cevap vermiyor, aynı karede sonsuz döngü, veya otomatik oyuncu `KILIT` yazıyor. `docs/tester/BULGULAR.md` eski kayıtları oku. Kapanmış olanı yeniden açma. Yeni olanı aynı biçimde yaz.
- Performans izi: `tests/oto/olcum/performans_izi.gd` yoktur. Bölüm 1 onayından sonra, ayrı küçük bir iş olarak bu izi ekle. Her 10 saniyede FPS, kare süresi, statik bellek ve düğüm sayısı. Sahne değişiminde yükleme süresi. Oyuncu sürümünde yazmasın (`--debug-arac` veya `--perf-log`). `src/debug/performans_gunlugu.gd` ile ikinci bir format icat etme. Aynı sayıların devamı olsun.
- Instancing eksikliği bir varsayımdır, ölçülmüş darboğaz değildir. İz, aynı prop'tan çok kopyanın çizim maliyetini göstermeden `MultiMesh` yazma.
- Bütçe, ölçümden önce tek sayfa olarak `docs/gorevler/PERFORMANS_BUTCESI.md` dosyasına yazılır. Başlangıç sayıları repodan: tavuk hedefi 0,40 m, dekor görüşü 120 m, üçgen tavanı 60.000, düşük profilde FPS uyarısı 30 (`ROADMAP_2.md` AYR-41). Yeni sayı uydurma. Eşiği ölçüm çizer, Ahmet onaylar.

### 4. Bölüm bölüm ilerle, onay olmadan geçme

Sıra aşağıdadır. Bir bölümün kodu bitti sayılmaz. Ahmet o bölümü kendi eliyle oynayıp `codex.md/Antigravity_gorev.md` içine "onay" yazmadan sonraki bölümün koduna girilmez. Onay beklerken boş durma: ihtiyaç listesini, testi ve günlük kaydını bitir. Başka bölümün koduna geçme.

Her bölümün sonunda aynı dört başlık yazılır.

- Ne değişti (dosya yolları).
- Ahmet'in basacağı adımlar (pencereli Godot, tohum dahil).
- Kabul: oyuncunun göreceği sonuç, bir cümle.
- Ret: hangi görüntü veya log bölümü geri çevirir.

### 5. Kendi ajanların oyunu görsün

Godot Engine'in resmi bir MCP sunucusu yoktur. `godotengine.org` ve resmi belge bunu tanımlamaz. "Resmi Godot eklentisi" deme.

Birincil yol **hi-godot/godot-ai** eklentisi v4'tür. https://github.com/hi-godot/godot-ai

`LICENSE` dosyası (20 Kasım 2026, `main`): **MIT**. Telif satırı `Copyright (c) 2025 Godot AI contributors`. Koşul: bu telif ve izin metni kopyalarda durur. Yazılım olduğu gibi verilir, garanti yoktur. README de lisansı MIT diye yazar.

README'nin ilk cümlesi: eklenti Claude Code, Codex, Cursor ve diğer MCP istemcilerini **canlı bir Godot editörüne** bağlar. Desteklenen istemciler listesinde **Antigravity** vardır. Editör kapalıyken eklenti tarafı yoktur. Bağlantı, README'deki şema:

```text
MCP client
  → godot-ai attach (stdio)
  → Python server (authenticated HTTP, port 8000)
  → Godot editor plugin (authenticated WebSocket, port 9500)
```

v4 istemcisi `godot-ai attach` ile stdio üzerinden bağlanır. Düz `http://127.0.0.1:8000/mcp` satırı kimlik doğrulayamaz. README bunu böyle yazar.

Gerekenler, README Quick start: **Godot 4.7+**, [uv](https://docs.astral.sh/uv/getting-started/installation/), bir MCP istemcisi.

Kurulum adımları README Quick start'tan, Windows:

1. uv'yi bir kez kur (PowerShell):

```powershell
irm https://astral.sh/uv/install.ps1 | iex
```

2. Eklentiyi Godot **AssetLib** sekmesinden veya bir [GitHub release](https://github.com/hi-godot/godot-ai/releases) dosyasından `your-project/addons/godot_ai/` altına kur.
3. **Project → Project Settings → Plugins → Godot AI** ile aç.
4. **Godot AI** dock'unda istemcinin yanındaki **Configure**, ya da **Configure all**. İstemci değişikliği görmezse istemciyi yeniden başlat.

README uyarısı: kurulu sürümün üstüne yeni zip açma. Dock'taki **Update** kullanılır. v3'ten v4'e geçiş de bu düğmeyledir.

Antigravity dosyası README'de hazır JSON olarak durmaz. Dock üretir. Yazılacağı yer, eklenti kaynağı `plugin/addons/godot_ai/clients/antigravity.gd`: Windows'ta `%USERPROFILE%\.gemini\config\mcp_config.json`. Eski `%USERPROFILE%\.gemini\antigravity\mcp_config.json` yalnız mevcut kurulumu tanımak içindir. Yeni kayıt güncel yola gider. Biçim düz `command` / `args` / `env` şeklindedir. `type` anahtarı yoktur. Eski `serverUrl` yeniden yapılandırmada silinir. Elle yazılacak iskelet, argv uydurmadan:

```json
{
  "mcpServers": {
    "godot-ai": {
      "command": "<dock'un yazdığı komut>",
      "args": ["<dock'un yazdığı argümanlar>"],
      "env": {},
      "disabled": false
    }
  }
}
```

Kapsam varsayılanı global `user`dir. Proje kapsamı için **Editor Settings → Plugins → `godot_ai/mcp_client_scope`** değerini `project` yap, sonra **Configure**'a yeniden bas. Godot'yu proje klasöründen aç. Dock'un ürettiği komut sürümü, portu ve araç alanını sabitler. Elle `uvx` satırı yazma.

Eklenti repoya commit edilecekse MIT kaydı `docs/credits/` altına yazılır. LICENSE'taki telif satırı kopyada durur. Commit edilmeyecekse `addons/godot_ai/` satırı `.gitignore` dosyasına eklenir. İkisi birden yapılmaz. Eklenti commit edilmiyorsa `project.godot` içindeki eklenti açma satırı da commit edilmez.

Sahne ve betik yazma yetkisi `AGENTS.md` bölüm 2'deki korumalı çekirdek dosya kuralına tabidir. O listedeki dosya baştan yazılmaz. İnce adaptör yeter. Eklentinin kendi sınırı ayrıca durur: README, yazmaların proje içinde kaldığını ve `project.godot`, `override.cfg`, `.godot/` yollarının eklentiye kapalı olduğunu söyler.

Eklentisiz yol test içindir ve durur. MCP değildir.

```
C:\Users\Ahmet\Desktop\Godot.exe --headless --editor --import --quit --path C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi
C:\Users\Ahmet\Desktop\Godot.exe --headless --path C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi tests\oto\giris_yukleme_kontrol.tscn
C:\Users\Ahmet\Desktop\Godot.exe --path C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi -- --debug-arac
```

20 gece duman, `docs/tester/TESTER_REHBERI.md` bölüm 3.3: `DUMAN_TESTI_20=1` ve `tests/oto/otomatik_oyuncu.tscn`. Ekran görüntüsü için aynı rehberdeki `tests/oto/menu_foto.tscn`, `kapi_foto.tscn`, `koy_foto.tscn`.

**Yedek: Ziva** (https://ziva.sh). Tescilli yazılımdır. Hesap ister. Antigravity resmi istemci listesinde yoktur. Yalnız Cursor, Claude ve Codex içindir. Godot AI kurulamazsa ve Ahmet bu yedeği kendi Cursor, Claude veya Codex oturumunda açarsa kullanılır. Telemetri kapalı kalır. Sohbet yedeği kapalı kalır. Üretim özellikleri ve Share Web build kullanılmaz. Eklenti repoya commit edilmez. Kurulursa klasörü `.gitignore` satırına yazılır.

**Üçüncü seçenek: Coding-Solo/godot-mcp.** https://github.com/Coding-Solo/godot-mcp `LICENSE` dosyası MIT'tir. Telif `Copyright (c) 2025 Solomon Elias`. README özellik listesinde girdi simülasyonu ve ekran görüntüsü yoktur. Godot AI çalışıyorsa bu kurulmaz. İkisi birden açık kalmaz.

## Bölüm sırası

1. **Ana menü ve başlangıç.** `ana.gd`, `menu_ekrani.gd`, `menu_sahnesi.gd`, `yeni_oyun_ekrani.gd`, `src/sistemler/acilis_senaryosu.gd`. Çift tıklama burada kapanır. Test: `tests/oto/giris_yukleme_kontrol.tscn` ve `tests/oto/acilis_menu_kontrol.tscn`.
2. **İlk gün kapı.** `src/arayuz/kapi_ekrani.gd`, `src/kapi/`. Bir ziyaretçi, en çok iki soru, karar, sonuç köye veya ret. Test: `docs/OYUN_TESTI_KONTROL_LISTESI.md` ilk anı ve ilgili `tests/oto` kapı sahnesi.
3. **Köy gündüz.** `src/arayuz/koy_ekrani.gd`, `src/dunya/koy_yonetim_sahnesi.gd`, HUD `src/arayuz/koy_hud/`. Kurma, seçme, yürüme. Dekor listesine yeni oyun kuralı ekleme.
4. **Gece ve rapor.** Gece kapanışı, rapor ekranı, ertesi sabah kapıya dönüş. Kaynak ve huzur bir gece ilerler, çökme yok.
5. **Ekonomi, hayvan, tüccar.** Hedef 2'nin kabulü. Testler: `hayvan_takas_kontrol`, `ticaret_fiyat_kontrol`, `tuccar_kapi_kontrol`.
6. **Mevsim, kriz, sağlık.** İlgili `tests/oto` sahneleri (`mevsim_takvim_kontrol`, `saglik_salgini_kontrol`, `kitlik_nobeti_kontrol`). Yeni afet icat etme.
7. **Kayıt ve ayarlar.** Kaydet, çık, devam et. Eski kayıt açılırsa göç testi varsa onu koş. Ayarlar `src/arayuz/ayarlar/`.
8. **Savaş.** Yalnız `ROADMAP_3.md` ve Ahmet'in önceki yedi bölümü onaylamasından sonra. Bu belge savaş tasarımı yazmaz.

## Ahmet'in yapması gerekenler

Bunları Alpha yapamaz. Windows, proje `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi`.

1. Godot'nun `C:\Users\Ahmet\Desktop\Godot.exe` olduğunu ve sürümün 4.7.2 olduğunu bir kez çalıştırarak doğrula. Değilse Alpha'ya gerçek yolu `Antigravity sorusu` altına yaz. Alpha yolu tahmin etmesin.
2. Antigravity CLI açıkken model menüsünden Gemini 4 Hydrogen High seç. Yoksa Argon Medium. Orchestrator (Argon) yalnız uzun bölüm planında.
3. Oyunu elle aç:

```
C:\Users\Ahmet\Desktop\Godot.exe --path C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi -- --debug-arac
```

F1 ile admin paneli gelir. Bayraksız açılış oyuncu sürümüdür. O sürümde F1 yoktur. Bu beklenen davranıştır.

4. Birincil bağlantı hi-godot/godot-ai v4'tür. Hedef 5'teki README adımlarını uygula. Editör açık kalsın. uv kurulu olsun. Dock'ta Antigravity için **Configure**'a bas. Üretilen kayıt `%USERPROFILE%\.gemini\config\mcp_config.json` dosyasına gider. Düz HTTP adresi yazma. Meshy anahtarı bu `env` içine girmez.

Eklentiyi depoya koyacaksan önce `## Antigravity sorusu` altına yaz ve MIT kaydını `docs/credits/` altına ekle. Koymayacaksan `addons/godot_ai/` satırını `.gitignore` dosyasına yaz. `project.godot` eklenti satırını, eklenti commit edilmiyorsa commit etme.

Godot AI kurulamazsa yedek Ziva'dır (https://ziva.sh). Antigravity listesinde yoktur. Yalnız kendi Cursor, Claude veya Codex oturumunda dene. Telemetri kapalı, sohbet yedeği kapalı. Üretim özellikleri ve Share Web build yok. Eklentiyi commit etme.

Üçüncü seçenek Coding-Solo/godot-mcp'dir (MIT). Girdi simülasyonu ve ekran görüntüsü yoktur. Godot AI açıksa bunu kurma.

Headless test ve foto sahnesi eklentisiz çalışır. MCP şart değildir.

5. Bölüm sonundaki test adımlarını kendin oyna. Onay cümlesini `codex.md/Antigravity_gorev.md` dosyasına yaz. "Onay" yazılmadan Alpha sonraki bölüme geçmez.
6. Tarih sorusuna bir cümle cevap ver: 14. yüzyıl Osmanlı mı, repodaki 13. yüzyıl metinleri mi esas. Cevap gelene kadar Alpha tarihî metinleri toplu değiştirmez.

## Alpha'nın yapması gerekenler

1. `git pull --ff-only`. `AGENTS.md`, bu belge, `TESTER_REHBERI.md` bölüm 3 ve `TESTX_KOD_REHBERI.md` komutlarını oku.
2. Model: Hydrogen High, olmazsa Argon Medium.
3. Birincil yol hi-godot/godot-ai v4. Ahmet kurmadıysa headless, otomatik oyuncu ve foto sahneleriyle ilerle. "MCP yok" diye durma. Kurduysa editör açıkken dock bağlantısını kullan. Araç listesini eklentinin `docs/TOOLS.md` dosyasından oku. README'de olmayan aracı çağırma.
4. Sahne veya betik yazarken `AGENTS.md` bölüm 2 geçerlidir. Korumalı dosyayı baştan yazma. Yalnız ince adaptör. `project.godot`, `override.cfg` ve `.godot/` eklentiye kapalıdır. Onları MCP ile de yazma.
5. Ziva'ya kendin geçme. Ahmet yedeği açtıysa telemetri ve sohbet yedeği kapalı kalsın. Üretim özelliği ve Share Web build yok. Eklenti commit edilmez. Coding-Solo üçüncü sıradadır. Girdi veya ekran görüntüsü aldığını yazma. Godot AI ile aynı anda açık bırakma.
6. Bölüm 1'den başla. Menüyü pencerede veya foto sahnesinde gör. `_baslat` sessiz dönüşünü ya düzelt ya da Ahmet'in tıkladığı düğme bu değilse gerçek düğmeyi bul. Düzeltme, oyuncuya görünen bir cevap verir.
7. Her kod değişiminden sonra hedefli test. Bölüm bitince, sanity boşsa tam sanity. Sonuç günlükte `PASS` sayısı veya "sanity bekliyor".
8. İhtiyaç satırını aynı commit'te envantere ekle. Asset yoksa commit mesajında "asset gerekmedi" yaz.
9. Bölüm sonu metnini günlüğe yaz ve soru kanalına "Bölüm N oynanmayı bekliyor" satırı koy. Ahmet onay yazmadan N+1 koduna girme.
10. Commit: Türkçe, neyin değiştiği, imza `(Antigravity)`. Önce pull. Yalnız kendi dosyaların. `metinler.csv` anahtar satırı eklerken dosyayı baştan yazma.

## Günlük ve soru biçimi

`codex.md/Antigravity.md` sonuna:

```
### 20 Kasım — oyuncu gözü, bölüm N
- Oynanan:
- Değişen dosyalar:
- Test:
- İhtiyaç:
- kota görünmüyor
```

Kota görünmüyorsa bu cümle kalır. Uydurma yüzde yazma.

`codex.md/Antigravity_gorev.md` içinde başlık bir kez durur:

```
## Antigravity sorusu
- Bölüm 1 oynanmayı bekliyor. Adımlar: ... Kabul: ...
```

Her soru tek cümledir. Tahminini karar diye yazma.

## Açılış ve import yavaşlığı

Ahmet, Godot 4.7.2 editörünü her açışında asset'lerin yeniden içe aktarıldığını ve bunun uzun sürdüğünü söyledi. Sık `git pull` yapıyor. Proje `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi`. Bu madde bölüm 1 ile birlikte ele alınır. Kök neden ölçülmeden toplu import ayarı değiştirilmez.

20 Kasım 2026 sayımı, festive `386e6556`:

- `.gitignore` satır 3: `.godot/` depoya girmez. Bu, Godot'nun istediği davranıştır. Resmi belge: `.godot/`, proje önbelleğidir. İçindeki `imported/` silinirse veya klasörün tamamı yoksa asset'ler otomatik yeniden içe aktarılır. Önbelleği depoya koymak başka bilgisayarda süreyi kısaltabilir ama boyut ve bant genişliği yüzünden önerilmez. Kaynak: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/import_process.html ve https://docs.godotengine.org/en/stable/tutorials/best_practices/version_control_systems.html
- Aynı belge: kaynak dosyanın MD5 toplamı değişince Godot o asset'i otomatik yeniden içe aktarır. `.import` dosyası commit edilir. 1 Kasım'dan bu yana `.import` dosyasına dokunan 11 commit var. Bunlar çoğunlukla yeni sidecar ekler. Aynı dosyanın import parametresinin ajanlar arasında gidip geldiği bir iz bu taramada çıkmadı. Bunu kanıtlanmış neden diye yazma.
- `assets/model` altında 217 GLB var, yaklaşık 787 MB. 158'inin commit edilmiş `.import` dosyası yok. `assets/meshy` altında 69 GLB, yaklaşık 78 MB, bunların sidecar'ı var. Toplam izlenen GLB yaklaşık 867 MB. Önbellek yokken editör bu gövdeyi baştan işler.
- Commit edilmiş 254 sahne `.import` dosyasının hepsinde `meshes/generate_lods=true`. Resmi 4.7 belge: Generate LODs açıksa uzakta daha kaba mesh üretilir. Kapatmak içe aktarmayı hızlandırır ve çıktıyı küçültür. Uzakta görünmeyen mesh'te faydası azdır. Kaynak: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/import_configuration.html
- Aynı 254 dosyada `meshes/light_baking=1` ve `meshes/lightmap_texel_size=0.2`. Resmi belge: Light Baking, Static Lightmaps ise mesh'e UV2 üretir. Daha küçük texel daha uzun bake demektir. `1` sayısının editörde hangi etikete denk geldiğini Import dock'ta doğrula. Sayıyı tahminen çevirme.
- 476 görselde `compress/mode=0`, 86 görselde `compress/mode=2`. Resmi görsel belgesi: Lossless 2B için varsayılandır ve VRAM'de daha çok yer tutar. 3B için yaygın olan VRAM Compressed'dir. Kaynak: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html Bu, her açılışta yeniden içe aktarma tetiklemez. Toplu sıkıştırma değiştirme bu maddenin ilk işi değildir.
- `.uid`: 1371 `.gd` için 1329 `.uid` izleniyor. Eksik olanlar açılışta üretilebilir. Asıl süre GLB gövdesindedir. `docs/tester/TESTX_KOD_REHBERI.md` yeni `class_name` için `.uid` dosyasının teslim edilmesini ister.
- `docs/`, `design/`, `tools/`, `production/`, `prototypes/`, `scripts/`, `bridge/`, `assets/meshy/gelen/` ve `assets/ui/atmosfer/gece_kapisi/_inceleme/` içinde `.gdignore` var. `.claude/` ve `.github/` içinde yok. Resmi belge: klasöre boş `.gdignore` koymak o klasörü içe aktarmaz ve ilk içe aktarmayı hızlandırır. Kaynak: https://docs.godotengine.org/en/stable/tutorials/best_practices/project_organization.html
- Test kitapları her işten önce `godot --headless --editor --import --quit` çalıştırır. Tester tur notları (`docs/tester/turlar/TUR-003.md` ve devamı) bu komutun `.import` ve `.uid` dosyalarını yeniden yazdığını söyler. Yayın betiği onları commit etmez. Editörle aynı klasörde bu komut çalışırsa önbellek ve sidecar yine yazılır.
- Git LFS yok. `.gitattributes` yalnız `*.sh` ve `*.ps1` için satır sonu yazar. Resmi Windows notu: `core.autocrlf=true` metin dosyalarını gereksiz değişmiş gösterir. Öneri `git config --global core.autocrlf input`. Bu, GLB baytlarını değiştirmez.

Yapılacaklar:

1. Ahmet `.godot` klasörünü silmez. `git clean -fdx` ve `.godot` silen betik yok. Önbellek duruyorsa pull yalnız MD5'si değişen dosyayı yeniden içe aktarır.
2. Açılış çubuğu yine tüm projeyi gezıyorsa, hangi dosyaların yeniden işlendiğini editör çıktısından yaz. 158 sidecar'sız GLB listesi ilk şüphelidir.
3. Kullanılan `assets/model/**/*.glb` için Godot 4.7.2'nin ürettiği `.import` dosyasını, parametre uydurmadan, bir kez commit et. Kullanılmayan ham kopya depoya eklenmez. `.gitignore` içindeki karakter ham GLB kuralı durur.
4. Işık haritası kullanılmayan prop'ta Light Baking'i, Import dock etiketi doğrulandıktan sonra, UV2 üretmeyen moda al. Generate LODs yalnız uzakta görünen mesh'te açık kalsın. İkisini de ölçmeden toplu kapatma.
5. `.claude/` ve `.github/` köküne boş `.gdignore` ekle. Oyun asset'i bu klasörlerde değildir.
6. Headless `--import` sonrası `git status` yalnız kendi işinin dosyalarını gösterir. Kendiliğinden değişen `.import` ve `.uid` farkını, kaynak dosya değişmediyse commit etme.
7. Sıkıştırmayı bu maddede toplu değiştirme. Ayrı ölçüm ve Ahmet onayı olmadan `compress/mode` yazma.

## Yapılmayacaklar

- `ToplulukDekoru` listesini oyuna bağlamak.
- Yeni hayvan türü, yeni tüccar veya yeni savaş kuralı icat etmek.
- Asset, doku, model veya yapay zekâ sesi üretmek.
- Meshy anahtarını yazmak.
- Force push, `reset --hard`, başkasının maddesini kapatmak.
- Godot AI eklentisini `docs/credits/` MIT kaydı olmadan commit etmek. Commit yoksa `addons/godot_ai/` `.gitignore` satırı olmadan bırakmak.
- Ziva eklentisini depoya koymak. Telemetri, sohbet yedeği, üretim özelliği veya Share Web build açmak.
- Godot AI açıkken Coding-Solo/godot-mcp kurmak.
- Bir bölüm bitmeden sonrakinin koduna girmek.
- Godot MCP'yi resmi motor özelliği diye anlatmak.
- `.godot/` klasörünü silmek veya depoya eklemek.
- Import dock'ta doğrulamadan `generate_lods` ve `light_baking` değerlerini toplu çevirmek.
