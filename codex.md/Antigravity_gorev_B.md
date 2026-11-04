# Paralel Antigravity ajanı B — Seslendirme ve dil kılavuzu (Kaşif, 4 Kasım 2026 09:35)

İlerleme dosyası: `codex.md/Antigravity_ilerleme_B.md`.

**Önemli (09:35 güncellemesi):** ES-GECM-01, ANL-DON-01, SOY-SON-01 ve MECLIS-ARA-01 ana ajan tarafından zaten yapıldı ve festive'de. Önce `git fetch origin` + `git merge origin/claude/festive-volta-li1sfm` yap. Ana ajan şu an yalnızca ANL-EPI-01 epilog metinleri üzerinde çalışıyor; ona dokunma. Başlamadan önce kendi maddenin festive'de zaten yapılıp yapılmadığına bak (ROADMAP_2.md işareti ve dosyalar); yapılmışsa tekrar yazma, eksikleri tamamla.

## Senin maddelerin
1. **SES-DIL-01** — `docs/SESLENDIRME_REJI_KILAVUZU.md`: karakter başına ses tonu, yaş, ağız/şive, duygu aralığı, nefes ve duraklama notları; ana karakterler (Muhafız, eş, köylüler) ve 30 ziyaretçi. Her karakter için 2 örnek replik (TR + EN) ve reji notu. ROADMAP_2.md'de SES-DIL-01'i işaretle.

## Ortak kurallar (her paralel ajan için)
- Sen paralel çalışan 4 Antigravity ajanından birisin. Klasörün ve dalın sadece sana ait (`agy/paralel-B`). Başka ajanın maddesine dokunma.
- Kaynak: `docs/ROBMAP_ONERILERI_ANTIGRAVITY.md` ve `docs/oneri_taslaklari/<kod>/` altındaki hazır taslaklar. Ahmet 7 önerinin hepsini onayladı ("hepsi iyi").
- ROBMAP'e maddeleri ana ajan (Görev 17, diyalog klasörü) ekliyor. Push etmeden önce festive'i çek; maddeler gelmişse kendi maddeni işaretle, gelmemişse ilerleme dosyana "ROBMAP işaretlemesi bekliyor" yaz.
- Her yeni metin anahtarının Türkçe ve İngilizce (`en`) karşılığını ekle. Yeni anahtarları kendi önekinle ayrı bir blokta tut ki birleşmede çakışma az olsun.
- Kod gerekirse en küçük değişikliği yap; Kalfa'nın alanındaki bir dosyaya dokunduysan ilerleme dosyasına hangi dosya, neden diye yaz. Büyük kod işi gerekiyorsa metni hazırla, bağlantı noktasını "Kalfa bekleniyor" diye not et.
- Her madde bitince: bütün Python doğrulayıcıları + Godot headless testleri; yeşilse commit ("<MBDE-KODU>-… (Antigravity-B)"), kendi dalını push et, sonra `git fetch origin` + `origin/claude/festive-volta-li1sfm`'i merge et, testleri tekrar çalıştır, `git push origin HEB:claude/festive-volta-li1sfm` ile fast-forward push et. Reddedilirse fetch + merge + test + tekrar dene. Asla force push yapma. Çakışmada iki tarafı da koru.
- Kota yüzünden erken durma (Ahmet'in gerçek kotası bol). Asset üretme, prompt yazma. Kalfa'nın klasörüne girme.
- Emin değilsen ilerleme dosyasına "Antigravity sorusu" başlığıyla yaz, en mantıklı varsayımla devam et.
- Hepsi bitince ilerleme dosyasının son satırına tek başına `GOREV_B_TAMAM` yaz.
