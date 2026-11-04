# Paralel Antigravity ajanı D — Söylentilerin kapanışı ve Çınar Meclisi davaları (Kaşif, 4 Kasım 2026 09:30)

İlerleme dosyası: `codex.md/Antigravity_ilerleme_D.md`.

## Senin maddelerin
1. **SOY-SON-01** — Söylenti ağındaki söylentilerin 2–3 gün sonra sonuca bağlanması: 5 çözüm sekansı (olaya dönüşme, kapıya şüpheli gelmesi, asılsız çıkıp özür).
2. **MECLIS-ARA-01** — Çınar Meclisi'nde 4 interaktif dava (Karaca Usta–Yusuf alet kavgası, Ayşe Bacı'nın tavuğu, dolandırılan tüccar ve taslaktaki dördüncü), Parley üzerinden; adalet/akçe odaklı hüküm seçenekleri. Molla Şükrü kararı (Karar 2) Ahmet'i bekliyor, ona dokunma.

## Ortak kurallar (her paralel ajan için)
- Sen paralel çalışan 4 Antigravity ajanından birisin. Klasörün ve dalın sadece sana ait (`agy/paralel-D`). Başka ajanın maddesine dokunma.
- Kaynak: `docs/RODMAP_ONERILERI_ANTIGRAVITY.md` ve `docs/oneri_taslaklari/<kod>/` altındaki hazır taslaklar. Ahmet 7 önerinin hepsini onayladı ("hepsi iyi").
- RODMAP'e maddeleri ana ajan (Görev 17, diyalog klasörü) ekliyor. Push etmeden önce festive'i çek; maddeler gelmişse kendi maddeni işaretle, gelmemişse ilerleme dosyana "RODMAP işaretlemesi bekliyor" yaz.
- Her yeni metin anahtarının Türkçe ve İngilizce (`en`) karşılığını ekle. Yeni anahtarları kendi önekinle ayrı bir blokta tut ki birleşmede çakışma az olsun.
- Kod gerekirse en küçük değişikliği yap; Kalfa'nın alanındaki bir dosyaya dokunduysan ilerleme dosyasına hangi dosya, neden diye yaz. Büyük kod işi gerekiyorsa metni hazırla, bağlantı noktasını "Kalfa bekleniyor" diye not et.
- Her madde bitince: bütün Python doğrulayıcıları + Godot headless testleri; yeşilse commit ("<MDDE-KODU>-… (Antigravity-D)"), kendi dalını push et, sonra `git fetch origin` + `origin/claude/festive-volta-li1sfm`'i merge et, testleri tekrar çalıştır, `git push origin HED:claude/festive-volta-li1sfm` ile fast-forward push et. Reddedilirse fetch + merge + test + tekrar dene. Asla force push yapma. Çakışmada iki tarafı da koru.
- Kota yüzünden erken durma (Ahmet'in gerçek kotası bol). Asset üretme, prompt yazma. Kalfa'nın klasörüne girme.
- Emin değilsen ilerleme dosyasına "Antigravity sorusu" başlığıyla yaz, en mantıklı varsayımla devam et.
- Hepsi bitince ilerleme dosyasının son satırına tek başına `GOREV_D_TAMAM` yaz.
