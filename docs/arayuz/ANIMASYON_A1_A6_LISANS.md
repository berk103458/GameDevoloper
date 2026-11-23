# A1–A6 kare animasyonları — lisans

A2, A4, A5 ve A6 tam sahne kareleri Grok Bot GenerateImage ile özgün üretildi, 23 Kas 2026 (Europe/Istanbul).

| Dizi | Yol | Kare | Boyut |
|---|---|---|---|
| A2 Rüşvet kesesi | `assets/ui/kapi/rusvet_kesesi/kare_01.png` … `kare_08.png` | 8 | 1152×864, opak RGB |
| A4 Kapı sürgüsü — kabul | `assets/ui/kapi/surgu/kabul/kare_01.png` … `kare_08.png` | 8 | 1152×864, opak RGB |
| A5 Kapı sürgüsü — ret | `assets/ui/kapi/surgu/ret/kare_01.png` … `kare_08.png` | 8 | 1152×864, opak RGB |
| A6 Sabah defteri | `assets/ui/koy/sabah_defteri/kare_01.png` … `kare_09.png` | 9 | 1152×864, opak RGB |

Palet: kömür `#10171C`, ahşap `#30251F`, demir `#58616A`, kehribar `#C88A43`, fildişi `#E6DDC6`. Yazı, rakam ve UI metni karelere işlenmez (A6 defter sayfaları boş bırakıldı; rapor metni oyunda Label ile yazılır).

A1 (zar atışı) ve A3 (yalan mührü) bu turda yeni kare üretmez. Mevcut `assets/art/anim/zar_d6_roll_*`, `zar_d12_roll_*` ve `muhur_bas_*` (256×256 RGBA, Gemini ikon izi) kullanılır; lisansları o izdeki kayda bağlıdır. `heybe_ac_*` A2 değildir (heybe açılışı cep aramadadır).

## v2 (23 Kas 2026, Europe/Istanbul)

A1 yüzleri: `assets/ui/kapi/zar_yuz/zar_d6_yuz_1.png` … `6.png` ve `zar_d12_yuz_1.png` … `12.png`. Boyalı gövde mevcut `assets/art/anim/zar_d6_roll_04.png` ve `zar_d12_roll_04.png` (Gemini ikon izi) üzerine temiz pips / oyma rakam işlendi; hareket kodladır, kare dizisi değildir. `zar_golge.png` gölge sprite'ı.

A6 destek kareleri: `assets/ui/koy/sabah_defteri/kapali.png`, `kapak_yarim.png`, `kapak_sola.png`, `acik.png` — Grok Bot GenerateImage ile özgün üretildi (1152×864 opak RGB). Sayfa çevirme ve kayıt yazısı kodladır; metin görsele gömülmez. Eski `kare_01.png`–`kare_09.png` dizisi kaldırıldı.
