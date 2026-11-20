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
- Admin: `src/debug/admin_hud.gd`. Açılış `Godot.exe --path . -- --debug-arac`. Pencerede F1 veya tire. Oyuncu sürümünde bu bayrak yoksa panel kurulmaz.
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

Godot Engine'in resmi bir MCP sunucusu yoktur. `godotengine.org` ve resmi belge bunu tanımlamaz. Aşağıdaki depolar üçüncü taraftır. Hiçbiri bu oyunda denenmedi. "Resmi Godot eklentisi" deme.

Önce eklentisiz yol. Bu yol bugün çalışır ve repoya dosya eklemez.

```
C:\Users\Ahmet\Desktop\Godot.exe --headless --editor --import --quit --path C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi
C:\Users\Ahmet\Desktop\Godot.exe --headless --path C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi tests\oto\giris_yukleme_kontrol.tscn
C:\Users\Ahmet\Desktop\Godot.exe --path C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi -- --debug-arac
```

20 gece duman, `docs/tester/TESTER_REHBERI.md` bölüm 3.3: `DUMAN_TESTI_20=1` ve `tests/oto/otomatik_oyuncu.tscn`. Ekran görüntüsü için aynı rehberdeki `tests/oto/menu_foto.tscn`, `kapi_foto.tscn`, `koy_foto.tscn`.

Canlı tıklama ve oyun içi kare ancak Ahmet bir MCP kurarsa gelir. Kurulum adımları aşağıdaki iki bölümdedir. Eklenti repoya, Ahmet soru kanalında yazmadan eklenmez. Eklenirse lisansı `docs/credits/` altına kaydedilir.

## Bölüm sırası

1. **Ana menü ve başlangıç.** `ana.gd`, `menu_ekrani.gd`, `menu_sahnesi.gd`, `yeni_oyun_ekrani.gd`, `src/sistemler/acilis_senaryosu.gd`. Çift tıklama burada kapanır. Test: `tests/oto/giris_yukleme_kontrol.tscn`, `tests/oto/acilis_menu_kontrol.tscn` varsa o, yoksa menü foto sahnesi.
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

4. MCP şart değildir. Headless test ve foto sahnesi eklentisiz çalışır. Canlı tıklama istiyorsan aşağıdaki ikisinden birini seç. İkisini birden kurma.

**Seçenek A — Erengun/godot-mcp.** https://github.com/Erengun/godot-mcp Lisans: MIT (deponun README rozeti ve LICENSE). Durum, 20 Kasım 2026'da okunan README'ye göre `2.0.0-dev`, npm'de değil. `npx godot-mcp` eski 0.x sürümünü kurar. Onu kullanma. Kaynaktan `npm ci` ve `npm run build`. Node.js 20 veya üstü gerekir. README, Godot 4.7.2 ile CI geçtiğini yazar. Aynı README'nin yol haritası şunu henüz yapmadığını söyler: çalışan oyunun ekran görüntüsü, debugger ve **girdi simülasyonu**. Yani bu sunucu oyunu başlatır, log okur ve sahne düzenler. "Düğmeye bas" bu sürümde yoktur. Bunu Alpha'ya yaz.

Kurulum, deponun kendi adımlarıdır. Özet:

```
git clone https://github.com/Erengun/godot-mcp.git
cd godot-mcp
npm ci
npm run build
```

Antigravity CLI MCP dosyası, resmi belgeye göre ya genel `~/.gemini/config/mcp_config.json` ya da projede `.agents/mcp_config.json` dosyasıdır. Yönetim: CLI içinde `/mcp`. Kaynak: https://antigravity.google/docs/mcp/ ve https://antigravity.google/docs/settings/

Windows örneği (yolları kendi clone yolunla değiştir):

```json
{
  "mcpServers": {
    "godot": {
      "command": "node",
      "args": ["C:\\src\\godot-mcp\\build\\index.js"],
      "env": {
        "GODOT_PATH": "C:\\Users\\Ahmet\\Desktop\\Godot.exe",
        "GODOT_MCP_ALLOWED_ROOTS": "C:\\Users\\Ahmet\\Desktop\\Cursor_All_DAta\\Kapı_Muhafizi"
      }
    }
  }
}
```

`GODOT_MCP_ALLOWED_ROOTS` bu klasörle sınırlı kalsın. Sunucu `127.0.0.1` dışında dinlemesin. Meshy anahtarı bu `env` içine girmez.

**Seçenek B — juffson/godot-agent.** https://github.com/juffson/godot-agent Lisans: README "MIT" der. Rust ile derlenir. README Godot 4.2 ve üstü, denenen sürüm olarak 4.6.3 yazar. **4.7.2 bu sayfada yazmaz.** Oyun içi MCP `127.0.0.1:6011` için girdi simülasyonu ve kare yakalama tarif eder. `execute_script` oyun sürecinde isteğe bağlı GDScript çalıştırır. Bu güçlüdür ve tehlikelidir. Yalnız `127.0.0.1`. Port yönlendirme yok. Derleme `install.sh` ile Linux veya macOS içindir. Windows'ta aynı betiğin çalıştığı bu görevde doğrulanmadı. Windows adımını uydurma. Depodaki Windows notunu oku. Yoksa Seçenek A'da kal.

Seçenek B, `addons/godot_agent/` ve bir autoload ekler. Bu, oyun deposunu değiştirir. Ahmet istemeden Alpha bu eklentiyi commit etmez.

5. Bölüm sonundaki test adımlarını kendin oyna. Onay cümlesini `codex.md/Antigravity_gorev.md` dosyasına yaz. "Onay" yazılmadan Alpha sonraki bölüme geçmez.
6. Tarih sorusuna bir cümle cevap ver: 14. yüzyıl Osmanlı mı, repodaki 13. yüzyıl metinleri mi esas. Cevap gelene kadar Alpha tarihî metinleri toplu değiştirmez.

## Alpha'nın yapması gerekenler

1. `git pull --ff-only`. `AGENTS.md`, bu belge, `TESTER_REHBERI.md` bölüm 3 ve `TESTX_KOD_REHBERI.md` komutlarını oku.
2. Model: Hydrogen High, olmazsa Argon Medium.
3. Eklenti kurma. Ahmet kurmadıysa headless, otomatik oyuncu ve foto sahneleriyle ilerle. "MCP yok" diye durma.
4. Ahmet Seçenek A'yı kurduysa araç listesini sunucunun kendi `docs/mcp-tools.md` dosyasından oku. README'de olmayan aracı varmış gibi çağırma. Girdi simülasyonu bu sürümün yol haritasındadır. Yoksa tıklamayı kendin yaptığını yazma.
5. Ahmet Seçenek B'yi kurup autoload'u onayladıysa 6011 araçlarını kullan. `execute_script` ile kayıt silme, dosya yazma veya ağ çağrısı yapma. Yalnız ekran durumu ve girdi. Kareyi ve logu `work/tester/` altına koy. `work/` commit edilmez.
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

## Yapılmayacaklar

- `ToplulukDekoru` listesini oyuna bağlamak.
- Yeni hayvan türü, yeni tüccar veya yeni savaş kuralı icat etmek.
- Asset, doku, model veya yapay zekâ sesi üretmek.
- Meshy anahtarını yazmak.
- Force push, `reset --hard`, başkasının maddesini kapatmak.
- MCP eklentisini onaysız commit etmek.
- Bir bölüm bitmeden sonrakinin koduna girmek.
- Godot MCP'yi resmi motor özelliği diye anlatmak.
