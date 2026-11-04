# Paralel Antigravity ajanı C — Ziyaretçilerin geri dönüşü (Kaşif, 4 Kasım 2026 09:30)

İlerleme dosyası: `codex.md/Antigravity_ilerleme_C.md`.

## Senin maddelerin
1. **ANL-DON-01** — Kabul edilen/reddedilen kritik ziyaretçilerin (Dursun, Turna, Lokman, Sungur, Banu Hatun ve taslaktaki diğerleri) 5–10 gece sonra yeni bir durumla dönmesi: 6 kısa kapı sekansı + 3 köy içi yüzleşme, mevcut `ziyaretci_kosul` bayraklarıyla bağla. Banu Hatun için Ahmet'in kararı 1.1 (ittifak süvari) geçerli; ana ajan onu uyguluyor, bayrak adlarını onunla uyumlu tut.

## Ortak kurallar (her paralel ajan için)
- Sen paralel çalışan 4 Antigravity ajanından birisin. Klasörün ve dalın sadece sana ait (`agy/paralel-C`). Başka ajanın maddesine dokunma.
- Kaynak: `docs/ROCMAP_ONERILERI_ANTIGRAVITY.md` ve `docs/oneri_taslaklari/<kod>/` altındaki hazır taslaklar. Ahmet 7 önerinin hepsini onayladı ("hepsi iyi").
- ROCMAP'e maddeleri ana ajan (Görev 17, diyalog klasörü) ekliyor. Push etmeden önce festive'i çek; maddeler gelmişse kendi maddeni işaretle, gelmemişse ilerleme dosyana "ROCMAP işaretlemesi bekliyor" yaz.
- Her yeni metin anahtarının Türkçe ve İngilizce (`en`) karşılığını ekle. Yeni anahtarları kendi önekinle ayrı bir blokta tut ki birleşmede çakışma az olsun.
- Kod gerekirse en küçük değişikliği yap; Kalfa'nın alanındaki bir dosyaya dokunduysan ilerleme dosyasına hangi dosya, neden diye yaz. Büyük kod işi gerekiyorsa metni hazırla, bağlantı noktasını "Kalfa bekleniyor" diye not et.
- Her madde bitince: bütün Python doğrulayıcıları + Godot headless testleri; yeşilse commit ("<MCDE-KODU>-… (Antigravity-C)"), kendi dalını push et, sonra `git fetch origin` + `origin/claude/festive-volta-li1sfm`'i merge et, testleri tekrar çalıştır, `git push origin HEC:claude/festive-volta-li1sfm` ile fast-forward push et. Reddedilirse fetch + merge + test + tekrar dene. Asla force push yapma. Çakışmada iki tarafı da koru.
- Kota yüzünden erken durma (Ahmet'in gerçek kotası bol). Asset üretme, prompt yazma. Kalfa'nın klasörüne girme.
- Emin değilsen ilerleme dosyasına "Antigravity sorusu" başlığıyla yaz, en mantıklı varsayımla devam et.
- Hepsi bitince ilerleme dosyasının son satırına tek başına `GOREV_C_TAMAM` yaz.
