# Ajan kitleri

Ahmet’in bilgisayarında ayrı bir Codex (lakabı Kalfa) kurulacak. Bu not, Berk’in ajanlarının repoda bıraktığı geliştirme kitini tarar. Tarama 9 Ekim 2026, dal `claude/festive-volta-li1sfm`, commit `727077a`. Yalnız repoda veya commit edilmiş günlükte görülenler yazıldı. Berk’in kendi bilgisayarında durup repoya girmeyen kurulum «bilinmiyor»dur.

Kalfa’nın kimliği `codex.md/Kalfa.md`. Roller `AGENTS.md` ve `CLAUDE.md` içindedir. Bu belge ROADMAP sahipliğini değiştirmez. KRI-07 `[/]` Berk’in Codex’indedir, Claude yönetir (`ROADMAP.md`).

## A) Kesin bilinen kit

### Kurallar ve günlükler

Ajanlar işe bu dosyalarla başlıyor. Hepsi repoda.

| Dosya | Ne işe yarar | Kanıt |
| --- | --- | --- |
| `AGENTS.md` | Dal, çekirdek dosya, ince adaptör, `koy_sahnesi` yasağı, imza, ds ayna, Ahmet kopyası, asset kuralı, Roller | Dosyanın kendisi |
| `CLAUDE.md` | Claude günlüğü. Üstte Claude Code Game Studios şablonu, altta Kapı Muhafızı günlüğü ve Roller | Dosyanın kendisi. KRI-06 kapanışı `0fbfd00` |
| `GEMINI.md` | Gemini plan/analiz günlüğü. İmza `(Gemini)` | Dosyanın kendisi |
| `codex.md/SOUL.md` | Codex kalıcı kuralları. İşe başlarken `AGENTS.md` ile okunur | Dosyanın kendisi. Kaynak notu: Ahmet, 7 Ekim 2026 |
| `codex.md/Codex.md` | Berk’in Codex günlüğü | Dosyanın kendisi. KRI-02/HAR notları ve kapanan madde listesi |
| `codex.md/Cursor.md` | Cursor doğrulama günlüğü. KAP-02/03, BUG-07/11/15 | Dosyanın kendisi |
| `codex.md/Muharrir.md` | Muharrir örneği. Günlük kuralının dışında tutulmuş | Dosyanın kendisi ve `AGENTS.md` dosya yönlendirmesi |
| `codex.md/Kalfa.md` | Ahmet’in Codex’i. Henüz görev yok | Bu paket |
| `docs/MUHARRIR_RAPORU.md` | Kapanış duyurusu. Yeni duyuru başa yazılır | Dosyanın başı. Örnek: KRI-06, commit `0fbfd00` |
| `docs/DEVIR.md` | Eski devir notu ve limit sayıları. Güncel cümle: Codex yönlendirir, Claude uygular | Dosyanın «Güncel sahiplik» bölümü |
| `docs/EKSIK_ASSET_ENVANTERI.md` | Eksik gerçek asset listesi. Adım bununla kapanır | `AGENTS.md` asset kuralı |
| `docs/denetim/2026-10-07-acilis.md` | Açılış denetiminin kanıtı | `codex.md/SOUL.md` ve dosyanın kendisi |
| `docs/engine-reference/godot/VERSION.md` | Sabit motor 4.7.2 | `CLAUDE.md` motor satırı |
| `project.yaml` | Motor, dil, Godot yolu, uzman adları, duman komutu | Dosyanın kendisi |
| `project.godot` | Oyun adı, sahne, 4.7, Forward Plus, `Ses` autoload, 1920×1080 | Dosyanın kendisi |

Şu klasörler bu taramada yok: `.codex/`, `.cursor/`, kök `.mcp.json`.

### Godot

- Sürüm **4.7.2**, özellikler `4.7` ve `Forward Plus`. Kanıt: `project.godot`, `project.yaml`, `docs/engine-reference/godot/VERSION.md`.
- Günlüklerdeki ikili kimlik **ed1daf0bf**. Kanıt: `codex.md/Codex.md` (HAR-15 ve KRI-06 notu), `codex.md/Cursor.md`, `docs/denetim/2026-10-07-acilis.md`.
- Berk’in `project.yaml` yolu: `C:/Users/ds/Desktop/Godot_v4.7.2-stable_win64.exe`. Bu, Berk’in masaüstüdür. Ahmet’in yolu bu dosyada yazılı değil.
- Ana sahne `res://src/arayuz/ana.tscn`. Autoload yalnız `Ses`.

### Python

Oyun kapısındaki araçlar standart kütüphane kullanır. Kökte `requirements.txt` yok.

- `tools/sanity_check.py`, `tools/metin_dogrula.py`, `tools/chr_parser.py`: `list[str]` ve `X | Y`. Bu sözdizimi Python 3.10 ve sonrasıdır.
- Berk’in makinesinde görülen sürüm **Windows Python 3.13**. Kanıt: `codex.md/Codex.md` KRI-06 notu (28 test, `mkdtemp` 0700 / sandbox ACL). Tam yama numarası (`3.13.x`) repoda yok.
- `bridge/python/requirements.txt` içinde `mcp>=2.2,<3` var. Bu, aşağıdaki köprü şablonuna aittir. Sanity bu paketi import etmez.

### Testler — nasıl çalışır

Tek kapı `tools/sanity_check.py`. Dokümantasyonu: stage, commit, CSV ve kullanıcı kaydı yazmaz. Log `work/sanity/` altına gider; `.gitignore` bu klasörü dışlar.

```text
python -B tools/sanity_check.py --godot C:\yol\Godot_v4.7.2-stable_win64.exe
```

Godot sırası: `--godot`, yoksa `GODOT_BIN`, yoksa PATH’te `godot` veya `godot4`. Zaman aşımı varsayılan 120 saniye. Başarı `PASS` satırları ve çıkış kodu 0. Çıktıda `SCRIPT ERROR`, `ERROR:`, `Failed to load script` veya `KALDI` varsa o adım düşer.

Koşunun içi (`tools/sanity_check.py`):

1. `python -B tools/chr_parser.py --check` — `karakterler/` markdown, yazmadan doğrular.
2. `python -B tools/metin_dogrula.py --kaynak` — `data/metin/metinler.csv` ve `src` / `data` anahtarları. Standart `docs/METIN_ANAHTAR_STANDARDI.md`.
3. `python -B -m unittest discover -s tests/tools` — `test_sanity_check.py`, `test_chr_parser.py`, `test_metin_dogrula.py`, `test_api_sozlesmesi.py`, `test_script_taramasi.py`.
4. `python -B tools/acilis_denetimi.py` — izlenen dosyalarda UID, sınıf, UTF-8, sahne yolu, JSON, CSV. `--remote-check` yerel kritik dosyayı `origin/claude/festive-volta-li1sfm` ile karşılaştırır, dosyayı değiştirmez (`docs/denetim/2026-10-07-acilis.md`).
5. `python -B tools/api_sozlesmesi.py` — `kur` / `yuru` / `_klip_onbellek`, `devam_istendi` / `oturum_bitti`, `gece_sonu` / `akce` / `KAYIT_SURUMU`, `GuvenliKayit` yaz-oku-sil. Git tabanına bakar.
6. Godot `--headless --path <kök> --editor --import --quit`.
7. `tests/unit` altındaki `*test.gd` dosyaları, `--headless -s`, bitiş yazısı `GEÇTİ`.
8. `tests/oto/*_kontrol.tscn` sahneleri, bitiş yazısı `GEÇTİ`.
9. `tests/oto/otomatik_oyuncu.tscn` ve ortam `DUMAN_TESTI_20=1`, bitiş yazısı `20 GECE DUMAN: GEÇTİ`.

Ayrı tarama, sanity listesinin dışında:

```text
python -B tools/godot_script_taramasi.py --godot <godot>
```

Headless import çıktısını dosya ve satırla `work/sanity/script-scan.json` dosyasına yazar. Kanıt: dosyanın başlığı ve `codex.md/Codex.md` SYS-07 maddesi.

`project.yaml` içindeki `commands.test` satırı `addons/gdUnit4` arar. Repoda `addons/gdUnit4` yok. Günlüklerdeki gerçek kapı `sanity_check.py` (SYS-06, `codex.md/Codex.md`). Son tam sayı örneği: KRI-06, 293 PASS / 0 hata / 20 gece (`docs/MUHARRIR_RAPORU.md`, `0fbfd00`).

Açılış sahnesi ayrıca `tests/oto/acilis_bagimlilik_kontrol.tscn`.

### Günlüklerde adı geçen çalışma biçimi

- **Godot headless.** Birim, UI sahnesi, import ve 20 gece. Kanıt: `tools/sanity_check.py`; `codex.md/Codex.md` HAR-13…15; `docs/MUHARRIR_RAPORU.md` KRI-01…06.
- **Görünür Godot incelemesi.** Claude kapanışları «görünür Godot incelemesi» der (`docs/MUHARRIR_RAPORU.md`, KRI-06). Codex «native RTX3060» ve `work/` altı png yazar (`docs/DEVIR.md`, EKO-02 `work/eko02_zincir.png`). Pencerenin Windows’ta hangi araçla fotoğraflandığı repoda yazmıyor; bu madde B’de.
- **ds ayna.** Kanonik `C:\Users\ds\Documents\Codex\2026-10-06\c\GameDevoloper`. Zorunlu ayna `C:\Users\ds\Documents\GitHub\GameDevoloper`. Kanıt: `AGENTS.md`. Günlük dili «iki ds kopyası». Ahmet kopyası `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi`. Bulunamazsa «güncellendi» denmez (`codex.md/SOUL.md`, `docs/MUHARRIR_RAPORU.md` KRI-06).
- **Limit sayıları.** `docs/DEVIR.md` kısa dönem yüzde, haftalık yüzde, `ordinaryUsageAllowed` ve reset zamanı yazar. Bu sayıyı üreten komutun adı repoda yok.
- **Asset.** Üretme ve indirme yok. Kutu yer tutucu ve `docs/EKSIK_ASSET_ENVANTERI.md`. Kanıt: `AGENTS.md`, `codex.md/SOUL.md`.

### Repoda duran, oyun günlüğünde çağrı kaydı olmayanlar

Bunlar dosya olarak var. HAR/KRI/ODA kapanışları bunları tek tek çalıştırdığını yazmıyor.

- `.claude/settings.json` izinleri, hook’lar ve `enabledPlugins` listesi. Hook’lar `.claude/hooks/*.sh`. Şablon gereksinimi Python 3, Bash ve önerilen `jq` (`.claude/docs/setup-requirements.md`). Oyun günlüğü bu hook’ların KRI sırasında çalıştığını yazmıyor.
- `.claude/skills/`, `.claude/agents/`, `.github/skills/`, `.github/awesome-copilot/`. Büyük şablon ağacı. `project.yaml` uzman adları: `godot-gdscript-specialist`, `godot-shader-specialist`, `godot-specialist`, `godot-gdextension-specialist`. `CLAUDE.md` `/setup-engine` ve `/start` anar. Tek tek skill’in oyun işinde çağrıldığına dair günlük satırı yok.
- `.github/workflows/` altında oyun CI’si yok. Dosyalar `.yml` değil, `.md` şablon notu.
- `tools/godot_bg.sh` ve `tools/godot_bg/nofocus.m`. macOS’ta pencere odağını almadan kare, Linux’ta `xvfb-run`. Windows yolu yazmıyor.
- `tools/godot_api.py`. İlk çalışmada Godot sınıf referansını `~/.cache/ai-gamedev-kit/godot-ref/` altına indirir. Günlüklerde KRI/HAR kanıtı olarak geçmiyor.
- `bridge/python/server.py` ve `bridge/python/mcp.example.json`. Örnek MCP adı `game`, komut `bash tools/mcp/run.sh`, port 9177. `tools/mcp/run.sh` repoda yok. `src/` altında köprü portu aranmadı, eşleşme yok.
- Eski üretim betikleri duruyor: `tools/ses/ses_uret.py`, `tools/model/meshy_uret.py`, `tools/varlik/polyhaven_indir.py`, `tools/art/gemini_uret.py`. Güncel kural bunları çalıştırmayı bırakır (`AGENTS.md` asset kuralı). `.meshy-api-key` gitignore’da; anahtar repoda aranmadı ve yazılmamalı.

## B) Repodan görünmeyen — bilinmiyor

Berk’e sorulacaklar. Uydurma yok.

- Codex CLI’nin kurulu sürümü, `~/.codex/config.toml`, `~/.codex/skills`, kullanıcı `AGENTS` dosyası.
- Claude Code’un kurulu sürümü, `~/.claude/settings.json`, `~/.claude/skills`, `~/.claude/agents`, giriş yöntemi. `docs/DEVIR.md` bir ara `claude auth status` için `loggedIn: false` yazmıştı; bugünkü giriş bilinmiyor.
- `codex mcp list` / `claude mcp list` çıktısı. Repoda Berk’in oyun oturumuna bağlı MCP sunucu adı yok.
- Windows’ta görünür Godot incelemesinin fotoğraf aracı (ekran alıntısı, RTX kaydı, başka bir köprü).
- `docs/DEVIR.md` limit yüzdelerini basan panel veya komut.
- Python 3.13’ün tam yama numarası ve `python` ile `py` launcher’ından hangisinin kullanıldığı.
- Godot 4.7.2 ikilisinin Ahmet makinesindeki yolu. Berk’in masaüstü yolu Ahmet’te geçerli sayılmaz.
- Berk’in yerel ve repoya girmemiş skill, kural veya MCP anahtarı.
- Bu ortamda ds ayna ve Ahmet kopyası yok. Eşitlendi denmez. Kanıt cümlesi zaten raporlarda var.

## C) Berk’e gidecek sorular ve komutlar

Gizli anahtar, token, `.env`, `.meshy-api-key` ve sohbet çerezi paylaşılmaz. Ayar dosyasında sır varsa satır silinir, dosyanın gerisi yeter.

Sorular:

1. Codex ve Claude Code hangi sürüm? İkisi de bu repoda mı açılıyor?
2. `codex mcp list` ve `claude mcp list` ne gösteriyor? Oyun işinde hangisi gerçekten kullanılıyor?
3. `~/.codex` ve `~/.claude` altında bu oyuna özel skill, agent veya kural var mı? Varsa yalnız adları.
4. Godot 4.7.2 tam yolu ve `godot --version` çıktısı (ed1daf0bf görünüyor mu)?
5. Python tam sürümü ve komut `python` mi, `py` mi?
6. Görünür inceleme nasıl alınıyor? Komut veya uygulamanın adı yeter.
7. Limit yüzdesi hangi ekrandan okunuyor?
8. ds ayna hâlâ `C:\Users\ds\Documents\GitHub\GameDevoloper` mi?

Berk’in kendi bilgisayarında, sır basmadan:

```text
codex mcp list
claude mcp list
godot --version
where godot
python --version
where python
py --version
```

Windows’ta ev klasörü:

```text
type %USERPROFILE%\.codex\config.toml
dir /b %USERPROFILE%\.codex\skills
dir /b %USERPROFILE%\.codex
type %USERPROFILE%\.claude\settings.json
dir /b %USERPROFILE%\.claude\skills
dir /b %USERPROFILE%\.claude\agents
```

Aynı yerler bir Unix kabuğunda `~/.codex/config.toml`, `~/.codex/skills`, `~/.claude/settings.json`, `~/.claude/skills`, `~/.claude/agents`.

## D) Kalfa kurulumu (Ahmet, Windows, Codex Pro)

Kalfa, Berk’in Codex’inin kopyası değildir. Ayrı oturum, imza `(Kalfa)`, günlük `codex.md/Kalfa.md`. Görev Muharrir blok verince başlar. Şu an görev yok. 11 Ekim akşamına kadar yalnız bu kurulum ve sanity çalışır (`docs/KOORDINASYON_DEVIR.md`).

Kurulacaklar:

1. Git for Windows. Çekme `git pull --ff-only`. Zorla itme yok.
2. Python 3.10 veya daha yeni. Berk’te görülen sürüm 3.13. Oyun araçları için pip şart değil.
3. Godot 4.7.2 stable, Windows 64-bit. `godot --version` çıktısında 4.7.2 ve mümkünse `ed1daf0bf` aranır. Resmi Godot sitesinden kurulur. Başka ajanın masaüstü yolu kopyalanmaz.

Repo:

```text
C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi
```

Klasör yoksa veya dal eskiyse, sırlar ve yerel iş silinmeden:

```text
cd /d C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi
git fetch origin
git checkout claude/festive-volta-li1sfm
git pull --ff-only
git status
```

İlk kontrol, tam paketten önce:

```text
godot --version
python --version
python -B tools/acilis_denetimi.py
```

Tam kapı uzun sürer. Godot yolu kendi kurulumuna göre değişir:

```text
python -B tools/sanity_check.py --godot "C:\yol\Godot_v4.7.2-stable_win64.exe"
```

İsteğe bağlı kalıcı yol, oturum için: `set GODOT_BIN=C:\yol\Godot_v4.7.2-stable_win64.exe`.

Kalfa’nın okuduğu kuralların özeti:

- Dal festive. Yeni oyun dalı açılmaz. `koy_sahnesi` ve statik `KoyYerlesimi` yok.
- İş, yeni dosya ve ince adaptördür.
- Başka ajanın `[/]` satırına yazılmaz. Çakışma olursa Muharrir raporunun başına not düşülür, madde alınmaz.
- Blok gelince sahiplik `[/] (Kalfa)`, kapanış `[x] (Kalfa)`.
- Asset yok. Kutu yer tutucu ve `docs/EKSIK_ASSET_ENVANTERI.md`. Gerekmiyorsa commit’te «asset gerekmedi».
- Commit öncesi sanity. Push sonrası duyuru raporun başında.
- `tools/` altındaki ses, Meshy, Polyhaven ve Gemini üretim betikleri çalıştırılmaz.
- Sır, anahtar ve token günlükye yazılmaz.
