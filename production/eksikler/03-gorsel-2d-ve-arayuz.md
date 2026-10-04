# 03 — Eksik 2D görseller ve arayüz

## 1. Mevcut 2D dosyaların hepsi yer tutucu (Ö1)
`assets/art/`'teki 37 PNG `tools/art/uret_yer_tutucu.py` ile koddan çizildi. Gemini istemleri hazır
(`tools/art/istemler.md`), ama hiç uygulanmadı: git geçmişinde bu klasöre yalnız yer tutucu commit'leri var.

3D'ye geçişten sonra hâlâ **oyunda kullanılanlar** (önce bunlar):

| Dosya | Nerede |
|---|---|
| `icon_decision_accept/reject/bribe/barracks_48` | Karar düğmeleri (`kapi_ekrani.gd`) |
| `icon_bribe_pouch_full/empty_48` | Üst şerit, 3 kese (`hud.gd`) |
| `ui_bar_segment_full/empty/cracked_01/02` | 4 bar (`hud.gd`) |
| `ui_cursor_arrow_32` | İmleç (`ana.gd`) |
| `env_gate_scene_bg`, `env_village_bg` | Perde geçişi ve son ekranlarının arka planı (`bilgi_ekrani.gd`) |

**Artık kullanılmayanlar:** `char_*_neutral_card` ve `char_*_idle_village` portreleri. 3D modeller bunların
yerini aldı ve `Sanat.portre` hiçbir yerden çağrılmıyor. Bunlar için kredi harcanmamalı.

Yol: `tools/art/BENIOKU.md` → Yol B (Gemini uygulaması, el ile) → `python3 tools/art/gemini_uret.py --el-ile --yedek`.

## 2. Hiç olmayan 2D görseller (Ö2)
| Görsel | Neden |
|---|---|
| **Son illüstrasyonları** (9 adet: 5 son + 4 kırılma) | Son ekranları şu an yalnız yazı ve yer tutucu arka plan. Ya 2D illüstrasyon ya da 3D son sahnesi gerekiyor (bkz. 05) |
| **Perde geçişi görseli** | "Köy oturdu" anı. Sanat kitabı 2.6: "meşalelerin hepsi ilk kez tek kadraja sığar" |
| **Prolog kartları** (3–4 kare) | Kösedağ, kaçış, kapı (bkz. 04) |
| **Olay kartı çerçevesi** | Olaylar düz panelde açılıyor |
| **Oyun logosu** | Oyunun adı hâlâ yok (kilitte açık) |
| **Yükleme ve açılış ekranı** | |
| **Uygulama ve pencere simgesi** | Dışa aktarım için |
| **Mağaza görselleri** (kapak, yatay bant, ekran görüntüleri) | Yayına yakın, Ö3 |

## 3. Arayüz eksikleri (Ö2)
- **Köylü listesi / defter ekranı:** İçeri aldığın adlı karakterlerin köyde ne yaptığını gösteren bir ekran yok. Oyuncu Thessra'nın köyde olup olmadığını aklında tutmak zorunda.
- **Karakter dönüş ipucu:** Geri gelen birinin "yine geldi" olduğunu yalnız giriş cümlesi söylüyor. Görsel bir ipucu yok, örneğin yüzün önceki gelişten tanıdık bir izi.
- **Olay seçeneklerinin "olmaz" hâli** yalnız "(olmaz)" yazısıyla gösteriliyor; neden olmadığı (akçe yok, kişi köyde değil) yazmıyor.
