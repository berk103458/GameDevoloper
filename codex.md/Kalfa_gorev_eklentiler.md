# Kalfa görevi — üçüncü parti editör eklentilerini yerelde dene

Tarih: 3 Kasım 2026. Yazan: Cursor. Bu dosya Ahmet'in makinesindeki Kalfa içindir. İmza `(Kalfa)`.

Araçlar kuruldu, etkinleştirilmedi. Kayıt: `docs/UCUNCU_PARTI_ARACLAR.md`. Dal: `cursor/ucuncu-parti-eklentiler-7070`. Taban: `claude/festive-volta-li1sfm`. Parley ve Theatre bu dalda yok; onlara dokunma. O iş `codex.md/Antigravity_gorev.md` Görev 2'dedir.

## 1. Dali diske al

Çalışma klasörü: `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi`.

```powershell
cd C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi
git status
git fetch --all --tags --prune
git checkout cursor/ucuncu-parti-eklentiler-7070
git pull --ff-only origin cursor/ucuncu-parti-eklentiler-7070
git lfs pull
```

`git status` temiz olmalı. Başkasının kaydedilmemiş dosyası varsa onu commit etme ve silme. Sparse checkout varsa kapat: `git sparse-checkout disable`. Dalın tamamı diskte olsun: `addons/godot_mcp`, `addons/hammerforge`, `addons/cognite`, `addons/Tree3D`, `addons/dingo`, `tools/ucuncu_parti/godot-mcp-server`.

Godot: `C:\Users\Ahmet\Desktop\Godot.exe`. Beklenen sürüm `4.7.2.stable.official.ed1daf0bf`. Başka sürümle açma.

## 2. Tek tek etkinleştir

Her eklentiden önce editörü kapat. Project Settings → Plugins içinde yalnız o eklentiyi aç. `project.godot` elle toplu yazılmasın; kutuyu editörden işaretle. Editörü yeniden aç. Açılışta çökme, kırmızı `SCRIPT ERROR` veya "Failed to load script" varsa o eklentiyi kapat, KALDI yaz, sonrakine geç.

Sıra:

1. Godot MCP — `addons/godot_mcp`. Açılınca sağ üstte MCP yazısı beklenir. Henüz sunucu yokken "Disconnected" normaldir; editörün kendisi ayakta kalmalıdır.
2. HammerForge — `addons/hammerforge`. 3B sahnede dock (Build, Paint, Objects, Test) görünmeli. Editör çökmeden açılmalı.
3. Cognite — `addons/cognite`. Dock açılmalı. Bu sürüm grafik durum makinesi değildir; skor dock'udur. Dock açılması yeter.
4. gdTree3D — Project Settings listesinde eklenti satırı yoktur. `addons/Tree3D/Tree3D.gdextension` diskte olduğu için motor açılışta DLL yükler. Çıktı panelinde GDExtension yükleme hatası varsa KALDI. Yeni düğüm listesinde `Tree3D` görünüyorsa geçti say.
5. Dingo — `plugin.cfg` yoktur, Plugins listesinde satırı olmaz. Etkinleştirme adımı "editör bu klasörle açıldı, betik parse hatası yok" demektir. Ayrı kutu işaretleme.

Hepsi kapalıyken de bir kez aç: mevcut oyun menüsü `res://src/arayuz/ana.tscn` gelmeli. Bu, dosyaların yalnız dururken oyunu bozmadığını gösterir. GDExtension her açılışta yüklendiği için "hepsi kapalı" Tree3D kütüphanesini kapsamaz; onu 4. adımda ayır.

## 3. Örnek sahneler

Etkin olan eklentinin kendi sahnesini F6 ile çalıştır. Oyun ana sahnesine bağlama.

| Eklenti | Sahne |
| --- | --- |
| Godot MCP | Ayrı sahne yok. Aşağıdaki MCP bağlantısı bu satırın demosudur. |
| HammerForge | `res://addons/hammerforge/ornek/hf_sample_minimal.tscn` |
| Cognite | `res://addons/cognite/ornek/example.tscn` |
| gdTree3D | `res://addons/Tree3D/ornek/tree_3d.tscn` sonra `forest.tscn` |
| Dingo | `res://addons/dingo/Scenes/Example Scenes/dungeon_starter_example.tscn` |

Sahne açılmazsa, ağaç veya oda üretilmezse, konsol hata basarsa KALDI. Dingo üretimi editörde "Generate me a dungeon!" kutusundadır; bir kez çalıştır, oda sayısı konsolda görünsün.

## 4. godot-mcp sunucusu

Node.js LTS kurulu olsun.

Hızlı yol, sürüm kilitli:

```json
{
  "mcpServers": {
    "godot": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "godot-mcp-server@0.6.1"]
    }
  }
}
```

Sabit kaynak yolu:

```powershell
cd C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi\tools\ucuncu_parti\godot-mcp-server
npm install
npm run build
node dist/index.js
```

İstemci argümanı o zaman `dist\index.js` olsun. Godot eklentisi açıkken editörü yeniden başlat. Sağ üst yeşil "MCP: Agent Active" ise GEÇTİ. Turuncu "No Agent" sunucunun ayakta, istemcinin değil demektir; istemciyi yeniden aç, bir kez daha bak. Kırmızı "Disconnected" veya port 6505'e kimse bağlanamıyorsa KALDI. `node_modules` commit edilmez.

## 5. Oyunun kendisi

GEÇTİ olan eklentiler açıkken ana sahneyi çalıştır: `res://src/arayuz/ana.tscn`. Ana menü gelsin, kapıya veya devam et akışına bir kez gir, konsolda yeni `SCRIPT ERROR` olmasın. Köy sahnesi açılıyorsa bir gün ilerletmek zorunda değilsin; menü ve ilk ekran yeter. Bozulma varsa son açılan eklentiyi kapatıp tekrarla, suçluyu KALDI yap.

## 6. Tablo

`codex.md/Kalfa.md` günlüğüne şu tabloyu yaz:

| Eklenti | Editör açıldı | Örnek / bağlantı | Oyun duruyor | Sonuç |
| --- | --- | --- | --- | --- |
| godot-mcp | | | | GEÇTİ veya KALDI |
| HammerForge | | | | GEÇTİ veya KALDI |
| Cognite | | | | GEÇTİ veya KALDI |
| gdTree3D | | | | GEÇTİ veya KALDI |
| Dingo | | | | GEÇTİ veya KALDI |

Sonuç GEÇTİ ise üç sütun da geçti demektir. Biri kaldıysa sonuç KALDI.

## 7. Commit

Yalnız GEÇTİ olanlar etkin kalsın. KALDI olanın kutusu kapalı olsun. gdTree3D KALDI ise `addons/Tree3D/Tree3D.gdextension` dosyasını silme; günlüğe "yüklenmedi" yaz ve dosyayı yerinde bırak. Etkin listeyi editör kaydetsin.

Commit'e yalnız şunlar girer: `project.godot` içindeki eklenti etkinliği, `codex.md/Kalfa.md`, bu denemede oluşan ve senin işin olan not. `git add -A` kullanma. `.godot/`, `node_modules`, başkasının kirli dosyası ve `.import` yığını sana ait değilse alma.

```powershell
git add project.godot codex.md/Kalfa.md
git commit -m "test(eklenti): yerelde açılan üçüncü parti araçlar etkin (Kalfa); asset gerekmedi"
git push origin cursor/ucuncu-parti-eklentiler-7070
```

Festive'ye push etme. Force-push yok. PR'yi birleştirme.

Günlük satırı: neyin geçtiği, Godot sürümü, `kota: ...` veya `kota görünmüyor`. ds yolları (`C:\Users\ds\Documents\GitHub\GameDevoloper`) bu makinede yoksa "eşitlenmedi" yaz, eşitlendi deme.

Ajan Masası'na (GitHub issue #11) tek yorum: `[Kalfa → Muharrir] [BITTI] eklenti denemesi: tablo özeti`. Ayrıntı günlükte kalsın.
