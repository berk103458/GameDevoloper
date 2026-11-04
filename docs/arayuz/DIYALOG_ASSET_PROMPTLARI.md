# Kapı Muhafızı — Diyalog ve Anlatı 2D Asset Promptları (Görev 13)

**Hazırlayan:** Antigravity  
**Tarih:** 4 Kasım 2026  
**Sanat Yönü:** 13. yüzyıl Anadolu Selçuklu uç beyliği atmosferi, 'gece_kapisi' koyu palet üslubu (isli ahşap #30251F, dövme demir #58616A, amber #C88A43, fildişi #E6DDC6, kömür #10171C). Saydam nesnelerde arka plan düz **#00FF00**, metinsiz (`no text`), 4:5 portre veya 16:9 sinematik kanvas.

---

## İçindekiler ve Özet Tablo

| ID | Nihai Dosya | Ölçü | Tür / Zemin | Tanım |
|---|---|---|---|---|
| `PORTRE-DYS-021` | `assets/art/char/char_dervis_baba_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 21 — Derviş Baba |
| `PORTRE-DYS-022` | `assets/art/char/char_tuccar_tebrizli_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 22 — Tebrizli Safrancı Tüccar |
| `PORTRE-DYS-023` | `assets/art/char/char_cavus_sungur_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 23 — Sancak Çavuşu Sungur |
| `PORTRE-DYS-024` | `assets/art/char/char_vebali_ana_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 24 — Vebalı Ana ve Sabi |
| `PORTRE-DYS-025` | `assets/art/char/char_firinci_dursun_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 25 — Fırın Çırağı Dursun |
| `PORTRE-DYS-026` | `assets/art/char/char_cerrah_lokman_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 26 — Şarlatan Cerrah Lokman |
| `PORTRE-DYS-027` | `assets/art/char/char_katip_sukru_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 27 — Sivas Kâtibi Molla Şükrü |
| `PORTRE-DYS-028` | `assets/art/char/char_banu_hatun_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 28 — Dağların Kurdu Banu Hatun |
| `PORTRE-DYS-029` | `assets/art/char/char_kafile_habercisi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 29 — Kafile Habercisi |
| `PORTRE-DYS-030` | `assets/art/char/char_yetim_turna_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 30 — Yetim Turna |
| `PORTRE-DYS-ES` | `assets/art/char/char_muhafiz_esi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Muhafızın Eşi — Oda ve Kapı Düşünceleri Portresi |
| `KART-OLAY-01` | `assets/art/events/event_kavga_harman.png` | 800×450 | Opak RGB | Köy Olayı 1 — Harman Yeri Kavgası |
| `KART-OLAY-02` | `assets/art/events/event_ambarda_hirsizlik.png` | 800×450 | Opak RGB | Köy Olayı 2 — Ambarda Gece Hırsızlığı |
| `KART-OLAY-03` | `assets/art/events/event_salgin_fisiltisi.png` | 800×450 | Opak RGB | Köy Olayı 3 — Salgın Fısıltısı ve Korku |
| `KART-OLAY-04` | `assets/art/events/event_koy_dugunu.png` | 800×450 | Opak RGB | Köy Olayı 4 — Köy Meydanında Kış Düğünü |
| `KART-OLAY-05` | `assets/art/events/event_firari_cenazesi.png` | 800×450 | Opak RGB | Köy Olayı 5 — Firari Asker Cenazesi |
| `KART-OLAY-06` | `assets/art/events/event_samanlik_yangini.png` | 800×450 | Opak RGB | Köy Olayı 6 — Gece Samanlık Yangını |
| `KART-OLAY-07` | `assets/art/events/event_gece_donu.png` | 800×450 | Opak RGB | Köy Olayı 7 — Gece Ayazı ve Don Kırgını |
| `KART-OLAY-08` | `assets/art/events/event_harami_elcisi.png` | 800×450 | Opak RGB | Köy Olayı 8 — Harami Elçisi ve Haraç Ültimatomu |
| `UI-DEFTER-DERI` | `assets/art/ui/ui_defter_kapak_deri.png` | 512×512 | RGBA; düz #00FF00 | Hafıza Defteri — Yıpranmış Deri Kapak |
| `UI-DEFTER-PARSOMEN` | `assets/art/ui/ui_defter_sayfa_parsomen.png` | 512×512 | RGBA; düz #00FF00 | Hafıza Defteri — Kadim Parşömen Sayfası |
| `UI-SOYLENTI-AGI` | `assets/art/ui/icon_soylenti_agi.png` | 512×512 | RGBA; düz #00FF00 | Söylenti Ağı İkonu — Bağlantılar ve İpuçları |
| `SON-DYS-TEKFUR` | `assets/art/env/son_tekfur_haraccisi_cinar.png` | 1920×1080 | Opak RGB | Oyun Sonu 1 — Tekfur'un Vergi Tahakkümü |
| `SON-DYS-ERTUGRUL` | `assets/art/env/son_ertugrul_obasi_sancak.png` | 1920×1080 | Opak RGB | Oyun Sonu 2 — Ertuğrul Obasının Uç Beyliği Zaferi |
| `SON-DYS-AHI` | `assets/art/env/son_ahi_kasabasi_refah.png` | 1920×1080 | Opak RGB | Oyun Sonu 3 — Müreffeh Ahi Zanaat Kasabası |
| `SON-DYS-KURTULUS` | `assets/art/env/son_veba_karantina_kurtulus.png` | 1920×1080 | Opak RGB | Oyun Sonu 4 — Salgını Yenen Umutlu Bahar |
| `SON-DYS-DIRENIS` | `assets/art/env/son_harami_kusatmasi_direnis.png` | 1920×1080 | Opak RGB | Oyun Sonu 5 — Surlarda Destansı Savunma |

| `PORTRE-DYS-001` | `assets/art/char/char_rencber_hamza_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 01 — Rençber Hamza |
| `PORTRE-DYS-002` | `assets/art/char/char_kayserili_cuhaci_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 02 — Kayserili Çuhacı |
| `PORTRE-DYS-003` | `assets/art/char/char_bozgun_neferi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 03 — Bozgun Askeri Neferi |
| `PORTRE-DYS-004` | `assets/art/char/char_coban_yusuf_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 04 — Toros Çobanı Yusuf |
| `PORTRE-DYS-005` | `assets/art/char/char_demirci_hasan_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 05 — Demirci Kalfası Hasan |
| `PORTRE-DYS-006` | `assets/art/char/char_silahsiz_piyade_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 06 — Silahsız Piyade |
| `PORTRE-DYS-007` | `assets/art/char/char_seyyar_kalayci_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 07 — Seyyar Kalaycı |
| `PORTRE-DYS-008` | `assets/art/char/char_tasci_kalfasi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 08 — Taşçı Kalfası |
| `PORTRE-DYS-009` | `assets/art/char/char_firinci_ali_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 09 — Fırıncı Çırağı Ali |
| `PORTRE-DYS-010` | `assets/art/char/char_sarac_kalfasi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 10 — Saraç Kalfası |
| `PORTRE-DYS-011` | `assets/art/char/char_yarali_nobetci_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 11 — Yaralı Nöbetçi |
| `PORTRE-DYS-012` | `assets/art/char/char_surgun_katip_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 12 — Sürgün Kadı Kâtibi |
| `PORTRE-DYS-013` | `assets/art/char/char_dervis_burhan_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 13 — Gezgin Derviş Burhan |
| `PORTRE-DYS-014` | `assets/art/char/char_kacak_madenci_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 14 — Kaçak Madenci |
| `PORTRE-DYS-015` | `assets/art/char/char_turkmen_anasi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 15 — Türkmen Anası Saruca |
| `PORTRE-DYS-016` | `assets/art/char/char_tovbekar_harami_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 16 — Tövbekâr Harami |
| `PORTRE-DYS-017` | `assets/art/char/char_degirmenci_mihali_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 17 — Rum Değirmenci Mihali |
| `PORTRE-DYS-018` | `assets/art/char/char_avci_kara_bekir_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 18 — Avcı Kara Bekir |
| `PORTRE-DYS-019` | `assets/art/char/char_asik_kul_dertli_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 19 — Saz Aşığı Kul Dertli |
| `PORTRE-DYS-020` | `assets/art/char/char_seyyar_nalbant_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Ziyaretçi 20 — Seyyar Nalbant |
| `PORTRE-KOY-AYDOGDU` | `assets/art/char/char_aydogdu_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Köylü — Okçu Aydoğdu |
| `PORTRE-KOY-AYSE-BACI` | `assets/art/char/char_ayse_baci_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Köylü — Ayşe Bacı |
| `PORTRE-KOY-HASAN-CELEBI` | `assets/art/char/char_hasan_celebi_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Köylü — Kâtip Hasan Çelebi |
| `PORTRE-KOY-KARACA-USTA` | `assets/art/char/char_karaca_usta_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Köylü — Karaca Usta |
| `PORTRE-KOY-MIRAEN` | `assets/art/char/char_miraen_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Köylü — Şifacı Miraen |
| `PORTRE-KOY-NOGAY` | `assets/art/char/char_nogay_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Köylü — Avcı Nogay |
| `PORTRE-KOY-SARUCA-HATUN` | `assets/art/char/char_saruca_hatun_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Köylü — Saruca Hatun |
| `PORTRE-KOY-SORHAN` | `assets/art/char/char_sorhan_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Köylü — At Tüccarı Sorhan |
| `PORTRE-KOY-THESSRA` | `assets/art/char/char_thessra_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Köylü — Hekim Kızı Thessra |
| `PORTRE-KOY-YUSUF` | `assets/art/char/char_yusuf_neutral_card.png` | 600×760 | RGBA; düz #00FF00 | Köylü — Yetim Çoban Yusuf |
---

## Tekil Nano Banana Promptları

### 1. `PORTRE-DYS-021` — Ziyaretçi 21 — Derviş Baba
- **Hedef Dosya:** `assets/art/char/char_dervis_baba_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Meczup gezgin derviş; 60 yaşlarında, sakalı göğsüne inen kır saçlı pir. Üzerinde yüzlerce renkli yamadan dikilmiş hırka, başında keçeden sivri derviş külahı. Boynunda boynuzdan nefir ve zikir taneleri. Gözlerinde dünya kaygısından uzak, bilge ve dalgın bir tebessüm. Sırtında heybesi.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Venerable 60-year-old wandering Sufi dervish with long gray beard, wearing a patched coarse woolen cloak, a pointed felt dervish cap, prayer beads and a horn hung around neck; calm, transcendent gaze of an ascetic mystic. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 2. `PORTRE-DYS-022` — Ziyaretçi 22 — Tebrizli Safrancı Tüccar
- **Hedef Dosya:** `assets/art/char/char_tuccar_tebrizli_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** İran ve Tebriz kervanlarından gelen kurnaz tüccar; 45 yaşlarında, sivri siyah sakallı, sürmeli gözlü. Başında ipek sarık, sırtında yakası samur kürk işlemeli lakin yol tozuyla kirlenmiş kaftan. Parmaklarında akik ve firuze yüzükler, boynunda tartı terazisi askısı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Cunning 45-year-old Persian saffron merchant from Tabriz with kohl-lined sharp eyes, trimmed black beard, ornate silk turban, and travel-stained sable-trimmed merchant coat; shrewd calculating expression. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 3. `PORTRE-DYS-023` — Ziyaretçi 23 — Sancak Çavuşu Sungur
- **Hedef Dosya:** `assets/art/char/char_cavus_sungur_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Sancak beyinin ordusundan firari ya da pusu kurtulanı kıdemli çavuş; 35 yaşlarında, sert çeneli. Başında dövme demir Selçuklu miğferi, sağ yanağında derin kılıç sıyrığı. Üzerinde kan ve pas lekeli perçinli zırh, gözlerinde tetikte bir şüphe ve yorgun savaşçı öfkesi.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Battle-hardened 35-year-old Seljuk frontier sergeant wearing a conical wrought-iron helmet, scarred weathered cheek, mud-and-blood splattered riveted brigandine armor; stern vigilant eyes of a grim veteran soldier. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 4. `PORTRE-DYS-024` — Ziyaretçi 24 — Vebalı Ana ve Sabi
- **Hedef Dosya:** `assets/art/char/char_vebali_ana_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Akpınar vebasından kaçan kederli anne; 25 yaşlarında, solgun yüzü yıpranmış kaba keten tülbentle burnunun altına kadar örtülü. Gözlerinde ateşli humma parıltısı ve evladını kurtarma çaresizliği. Göğsünde sıkı sıkıya sardığı eski kundakta 6 aylık bebeğin uyuyan yüzü belirir.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Desperate 25-year-old peasant mother suffering from epidemic fever, lower face wrapped in a worn homespun linen veil, hollow feverish sorrowful eyes, cradling a swaddled sleeping infant closely against her chest under a frayed blanket. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 5. `PORTRE-DYS-025` — Ziyaretçi 25 — Fırın Çırağı Dursun
- **Hedef Dosya:** `assets/art/char/char_firinci_dursun_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Fırın çırağı ve muhafızın yeğeni; 14 yaşlarında zayıf delikanlı. Yanaklarında ve alnında un ve fırın kurumu lekeleri, saçları dağınık. Üzerinde kolları sıvalı yırtık bez gömlek ve meşin önlük. Gözlerinde korku, heyecan ve amcasına sığınma telaşı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Lean 14-year-old bakery apprentice boy with soot and flour smudged on youthful cheeks, messy hair, wearing a patched rough tunic with rolled sleeves and stained leather apron; anxious yet earnest expression. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 6. `PORTRE-DYS-026` — Ziyaretçi 26 — Şarlatan Cerrah Lokman
- **Hedef Dosya:** `assets/art/char/char_cerrah_lokman_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Kaçak ve sahtekâr cerrah; 50 yaşlarında, yağlı seyrek sakallı, bıyıkları kına boyalı. Başında gösterişli ama solmuş sarık, kuşağında pirinç cerrah aletleri ve küçük cam ecza şişeleri. Gözlerinde yalan söyleyen adamın sinsi tebessümü.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Shifty 50-year-old itinerant charlatan barber-surgeon with henna-tinted thin mustache, greasy beard, faded peacock-patterned turban, small apothecary glass vials visible in sash; sly, untrustworthy smirk. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 7. `PORTRE-DYS-027` — Ziyaretçi 27 — Sivas Kâtibi Molla Şükrü
- **Hedef Dosya:** `assets/art/char/char_katip_sukru_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Sivas mahkemesinden kovulmuş kâtip; 40 yaşlarında, gözlerini sürekli kısan, zayıf ve kurnaz. Parmak uçları ve cübbesinin manşetleri kara divit mürekkebiyle boyanmış. Başında dar sarık, kuşağında pirinç divit sapı. Çalıntı mühür taşımanın getirdiği tedirgin kurnazlık.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Cunning, squinting 40-year-old disgraced court scribe with black ink stains on fingertips and cuffs, dark woolen scholar robe, small scholar turban; nervous, calculating gaze of an opportunistic forger. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 8. `PORTRE-DYS-028` — Ziyaretçi 28 — Dağların Kurdu Banu Hatun
- **Hedef Dosya:** `assets/art/char/char_banu_hatun_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Türkmen savaşçı kadın; 28 yaşlarında, kement gibi iki yana örülmüş koyu kahve saçlar. Omuzlarında gerçek gri kurt postu, göğsünde perçinli deri zırh. Elinde demir kabzalı kılıç, gözlerinde intikam ve mertlik ateşi yanan mağrur alp hatunu.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Fierce 28-year-old female Turkmen warrior with long braided dark hair, a real wolf pelt draped across sturdy shoulders, hardened leather armor with brass studs; proud, resolute warrior gaze burning with grief and vengeance. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 9. `PORTRE-DYS-029` — Ziyaretçi 29 — Kafile Habercisi
- **Hedef Dosya:** `assets/art/char/char_kafile_habercisi_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Kar fırtınasını aşıp gelen haberci; 30 yaşlarında, kaşları ve bıyıkları don tutmuş, dudakları soğuktan çatlamış ve morarmış. Başında kulaklıklı kalın kürk börk, sırtında mühürlü meşin haberci çantası. Nefes nefese, gözlerinde ölümle yarışmış adamın telaşı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Breathless 30-year-old frontier blizzard courier with frost on eyelashes and mustache, chapped windburned lips, thick sheepskin fur cap with ear flaps, heavy coarse wool cloak; urgent, desperate messenger eyes. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 10. `PORTRE-DYS-030` — Ziyaretçi 30 — Yetim Turna
- **Hedef Dosya:** `assets/art/char/char_yetim_turna_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** 10-12 yaşlarında yetim kız çocuğu, Dursun'un kayıp kardeşi. Başında solmuş çiçek işlemeli yemeni, omuzlarında yamalı yün şal. Kucağında paçavradan yapılmış tahta bir bez bebek tutar. Masum, ürkek ama umutla bakan ela gözler.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Innocent, timid 11-year-old orphan girl with large hazel eyes, faded embroidered cotton headscarf framing a delicate pale face, clutching a tiny handmade rag doll wrapped in coarse wool; hauntingly fragile yet hopeful expression. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 11. `PORTRE-DYS-ES` — Muhafızın Eşi — Oda ve Kapı Düşünceleri Portresi
- **Hedef Dosya:** `assets/art/char/char_muhafiz_esi_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Muhafızın eşi; 28-30 yaşlarında, vakur, şefkatli ve akıllı Selçuklu uç köyü kadını. Başında zarif toprak tonlarında bürüncük tülbent, üzerinde nakışlı sıcak yün yelek. Gözlerinde hem kocasının yükünü paylaşan derin bir sadakat hem de kışın sertliğine karşı dirayetli bir metanet.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Dignified 28-year-old Anatolian gatekeeper's wife with warm wise brown eyes, draped in a modest earthen-toned woolen veil over a finely embroidered winter vest; gentle, loving yet fiercely resilient countenance of a frontier matriarch. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 12. `KART-OLAY-01` — Köy Olayı 1 — Harman Yeri Kavgası
- **Hedef Dosya:** `assets/art/events/event_kavga_harman.png`
- **Boyut:** 800×450 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Harman yerinde iki köylünün dirgen ve kürekle buğday çuvalı kavgası; arkada saman yığınları, onları ayırmaya çalışan köylüler.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Heated village brawl at a rustic threshing floor in autumn dusk; two angry peasant farmers arguing over a grain sack with raised wooden pitchfork and spade while neighbors rush to intervene; golden haystacks and dusty autumn twilight. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 13. `KART-OLAY-02` — Köy Olayı 2 — Ambarda Gece Hırsızlığı
- **Hedef Dosya:** `assets/art/events/event_ambarda_hirsizlik.png`
- **Boyut:** 800×450 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Köy ambarının zorlanmış kilitli ahşap kapısı, yere dökülmüş arpa ve buğday taneleri, kar üstünde meşale ışığı ve kaçan ayak izleri.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Nocturnal burglary at a heavy timber communal granary; forced iron padlock hanging broken, trail of spilled barley on fresh snow illuminated by a warm torch held by a guard, dark shadowy footprints leading into the cold pine woods. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 14. `KART-OLAY-03` — Köy Olayı 3 — Salgın Fısıltısı ve Korku
- **Hedef Dosya:** `assets/art/events/event_salgin_fisiltisi.png`
- **Boyut:** 800×450 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Köy meydanındaki taş kuyu başında ağızlarını tülbentle kapatmış köylü kadınlar; sisli ve tekinsiz bir kış sabahında tedirgin fısıldaşma.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Tense village women gathered by an ancient stone well in morning fog, muffling their faces with coarse linen scarves while whispering in fearful suspicion of disease; ominous mist curling between stone cottages. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 15. `KART-OLAY-04` — Köy Olayı 4 — Köy Meydanında Kış Düğünü
- **Hedef Dosya:** `assets/art/events/event_koy_dugunu.png`
- **Boyut:** 800×450 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Köy meydanında devasa meşe odunu ateşi etrafında halay çeken neşeli köylüler, davul çalan ozan, kırmızı duvaklı gelin ve sıcak şenlik.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Festive winter wedding celebration around a roaring bonfire in the village square; villagers dancing hand-in-hand, a bard playing a rustic lute (kopuz), bride in a crimson-embroidered veil, festive warm sparks rising into the starry cold night. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 16. `KART-OLAY-05` — Köy Olayı 5 — Firari Asker Cenazesi
- **Hedef Dosya:** `assets/art/events/event_firari_cenazesi.png`
- **Boyut:** 800×450 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Karlar altındaki köy mezarlığında sade ahşap tabut, dua eden imam ve başı eğik muhafız; gri kasvetli gökyüzü altında sessiz hüzün.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Somber funeral in a snow-covered hillside graveyard; a simple unadorned wooden coffin resting by an open trench, villagers with bowed heads in solemn prayer beside an ancient lone gnarled oak, cold winter overcast sky. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 17. `KART-OLAY-06` — Köy Olayı 6 — Gece Samanlık Yangını
- **Hedef Dosya:** `assets/art/events/event_samanlik_yangini.png`
- **Boyut:** 800×450 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Gece karanlığında alev alev yanan köy samanlığı; tahta kovalarla kuyudan su taşıyan köylüler ve göğe yükselen duman bulutu.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Dramatic night fire consuming a thatched-roof wooden barn; panicked villagers forming a bucket brigade from the stone well, bright orange flames casting intense shadows across snow and timber walls, thick smoke billowing. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 18. `KART-OLAY-07` — Köy Olayı 7 — Gece Ayazı ve Don Kırgını
- **Hedef Dosya:** `assets/art/events/event_gece_donu.png`
- **Boyut:** 800×450 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Köy kapısının surlarından sarkan dev buz saçakları, donmuş dere yatağı, meşale başında donmamak için ellerini ovuşturan nöbetçi muhafız.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Extreme winter freeze at the fortified wooden palisade; massive sharp icicles hanging from parapets, frozen creek under thick ice, shivering sentry guard huddled near a sputtering brazier blowing warm breath into woolen mittens. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 19. `KART-OLAY-08` — Köy Olayı 8 — Harami Elçisi ve Haraç Ültimatomu
- **Hedef Dosya:** `assets/art/events/event_harami_elcisi.png`
- **Boyut:** 800×450 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Surların önünde siyah at üstünde, yüzü siyah puşiyle örtülü, mızrağının ucuna haraç mektubu takmış tehditkâr dağ haramisi süvarisi.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Menacing bandit rider on a dark steed outside the village gate in twilight mist; face concealed by a black scarf, holding a long spear bearing a blood-stained tribute parchment ultimatum, cold defiance. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 20. `UI-DEFTER-DERI` — Hafıza Defteri — Yıpranmış Deri Kapak
- **Hedef Dosya:** `assets/art/ui/ui_defter_kapak_deri.png`
- **Boyut:** 512×512 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** 13. yy el yazması defter kapağı; yıpranmış koyu kahve keçi derisi, köşelerinde dövme pirinç koruyucu bentler, ortasında silik Selçuklu sekizgen yıldız kabartması, deri bağcık.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated book object: Closed medieval leather ledger notebook bound in dark weathered goat hide with hand-hammered brass corner protectors, faint embossed Seljuk geometric star medallion, and a wrap-around leather thong tie. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas.
```

### 21. `UI-DEFTER-PARSOMEN` — Hafıza Defteri — Kadim Parşömen Sayfası
- **Hedef Dosya:** `assets/art/ui/ui_defter_sayfa_parsomen.png`
- **Boyut:** 512×512 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Eski parşömen kâğıdı dokusu; kenarları hafif yıpranmış, bezir yağı ve su lekeleri olan fildişi-sarı tonlu boş yazı sayfası.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated parchment page: Authentic aged medieval vellum parchment paper sheet with slightly deckled rough edges, warm ivory and amber aged patina, subtle water stains and worn folds; completely blank surface ready for writing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas.
```

### 22. `UI-SOYLENTI-AGI` — Söylenti Ağı İkonu — Bağlantılar ve İpuçları
- **Hedef Dosya:** `assets/art/ui/icon_soylenti_agi.png`
- **Boyut:** 512×512 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Ahşap masa üzerinde yanmış mum, divit hokka ve birbirine kırmızı sicim iplerle bağlanmış küçük parşömen kâğıtları; söylenti ağı dedektif ikonu.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated UI icon: Rustic wooden tabletop with small pinned parchment scraps interconnected by taut red twine threads, accompanied by a stubby melting beeswax candle and an iron inkpot with reed pen; medieval frontier rumor network. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas.
```

### 23. `SON-DYS-TEKFUR` — Oyun Sonu 1 — Tekfur'un Vergi Tahakkümü
- **Hedef Dosya:** `assets/art/env/son_tekfur_haraccisi_cinar.png`
- **Boyut:** 1920×1080 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Karanlık ve boyun eğmiş son; Bizans Tekfuru'nun ağır zırhlı süvarileri köy meydanına girmiş, ambarın başına kendi bayraklarını dikmiş, Çınar Meclisi'nin boynu bükük.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. Dramatic game ending cutscene: Gloomy defeat; armored Byzantine cataphract cavalry garrisoning the Anatolian village square, haughty tax collectors requisitioning the communal granary under a foreign eagle banner, villagers watching in somber defeat under the bare ancient plane tree at dusk. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 24. `SON-DYS-ERTUGRUL` — Oyun Sonu 2 — Ertuğrul Obasının Uç Beyliği Zaferi
- **Hedef Dosya:** `assets/art/env/son_ertugrul_obasi_sancak.png`
- **Boyut:** 1920×1080 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Büyük zafer ve umut sonu; Ertuğrul Gazi'nin yeşil ve kızıl sancaklı Türkmen alp süvarileri vadiyi doldurmuş, köy kapısına beylik mührü vurulmuş, köylüler coşkuyla karşılıyor.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. Triumphant game ending cutscene: Grand historical triumph; columns of noble Turkmen cavalry (kayi alps) bearing green and crimson banners riding into the welcoming frontier village at dawn, the village gate firmly secured as a thriving principality march outpost, cheering villagers under warm golden sunrise. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 25. `SON-DYS-AHI` — Oyun Sonu 3 — Müreffeh Ahi Zanaat Kasabası
- **Hedef Dosya:** `assets/art/env/son_ahi_kasabasi_refah.png`
- **Boyut:** 1920×1080 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Ekonomik refah ve adalet sonu; köy genişlemiş, Karaca Usta'nın demirhanesi ve zanaat dükkanları büyümüş, Ahi bayrakları altında kervanlar güvenle girip çıkıyor.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. Prosperous game ending cutscene: Flourishing Ahi guild craftsmanship town; bustling artisans hammering copper and iron, weavers, loaded merchant caravans safely trading at the fortified market square adorned with craft guild pennants, serene community wealth and harmony. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 26. `SON-DYS-KURTULUS` — Oyun Sonu 4 — Salgını Yenen Umutlu Bahar
- **Hedef Dosya:** `assets/art/env/son_veba_karantina_kurtulus.png`
- **Boyut:** 1920×1080 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Kireç ocağında vebayı savuşturan köyün karları eriyen bahara ulaştığı an; iyileşen sabi annesinin kucağında gülümser, köy evlerinin bacaları neşeyle tüter.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. Hopeful narrative ending cutscene: Salvation from pestilence; melting snow yielding to early spring blossoms around the frontier village, the cured peasant mother holding her healthy smiling toddler outside the sanitized stone lime kiln, smoke rising peacefully from cozy chimneys under a bright clear sky. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 27. `SON-DYS-DIRENIS` — Oyun Sonu 5 — Surlarda Destansı Savunma
- **Hedef Dosya:** `assets/art/env/son_harami_kusatmasi_direnis.png`
- **Boyut:** 1920×1080 | **Saydamlık / Zemin:** Opak RGB
- **Karakter ve Sahne Tarifi:** Banu Hatun ve 50 süvarisinin, muhafızların karlı vadide harami ordusuna karşı sur önünde durduğu destansı sınır direnişi zaferi.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. Epic battle ending cutscene: Legendary frontier gate defense; Banu Hatun and allied horsemen standing resolute on snow-covered ramparts and gate palisade alongside the village watch, repelling mountain raiders in a dramatic winter twilight, flaming arrows arching into the dusk. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas.
```

### 28. `PORTRE-DYS-001` — Ziyaretçi 01 — Rençber Hamza
- **Hedef Dosya:** `assets/art/char/char_rencber_hamza_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Karaköy'ün tohumunu haramilerden kaçıran yorgun rençber, Dursun ve Turna'nın dayısı; 45 yaşlarında, güneşten ve ayazdan yanmış kırışık yüzlü. Sırtında arpa tohumu çuvalı askısı, üzerinde aba yelek ve yamalı kaba kumaş gömlek. Başında yıpranmış keçeden köylü takkesi. Gözlerinde toprak derdi ve yeğenlerini kurtarma endişesi.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Weary 45-year-old Anatolian peasant farmer (Hamza) with deeply lined sun-weathered face, stubbled hollow cheeks, coarse homespun woolen vest, frayed felt cap, carrying coarse burlap seed sack strap across chest; sorrowful yet resilient gaze of an impoverished rural laborer. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 29. `PORTRE-DYS-002` — Ziyaretçi 02 — Kayserili Çuhacı
- **Hedef Dosya:** `assets/art/char/char_kayserili_cuhaci_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** İç Anadolu kumaş tüccarı; 40 yaşlarında, kurnaz ve etli çeneli. Başında kat kat sarılmış gösterişli kumaş sarık, sırtında yakası ince yün astarlı çuha kaftan. Boynunda pirinç dirhem terazisi askısı. Gözlerinde sürekli hesap yapan, kurnaz ve sakıngan bir tüccar bakışı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Shrewd 40-year-old Anatolian cloth merchant from Kayseri with plump jowls, calculating narrow dark eyes, finely wrapped merchant turban, heavy woolen broadcloth caftan with worn fur trim, brass coin scale cord hanging on chest; sly, observant merchant expression. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 30. `PORTRE-DYS-003` — Ziyaretçi 03 — Bozgun Askeri Neferi
- **Hedef Dosya:** `assets/art/char/char_bozgun_neferi_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Kösedağ bozgunundan kaçan mızraklı nefer; 25 yaşlarında, toz toprak ve kurum lekeleriyle kararmış çehre. Eğrilmiş perçinli demir miğfer, yakası yırtılmış zırh gömlek. Sağ gözünün üstünde kurumuş kan kabuğu. Gözlerinde büyük meydan savaşının dehşeti ve kaçak psikolojisi.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Traumatized 25-year-old Seljuk routed foot soldier with soot-smudged hollow face, battered dented conical iron helmet, torn quilted gambeson with broken scale armor links, dried blood streak over temple; haunted shock and survivor guilt in wide exhausted eyes. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 31. `PORTRE-DYS-004` — Ziyaretçi 04 — Toros Çobanı Yusuf
- **Hedef Dosya:** `assets/art/char/char_coban_yusuf_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Dağda sürüsü kurda kaptırılmış genç Yörük çobanı; 20 yaşlarında, sırtında kalın keçe kepenek, başında deve tüyü fes. Elinde meşe ağacından çoban kavalı ve sapan urganı. Gözlerinde hem dağ rüzgârının sertliği hem de sürüyü yitirmenin derin hüznü.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Rugged 20-year-old Taurus Mountain nomad shepherd with chapped lips, dark unruly hair under a coarse camel-hair skullcap, wrapped in a heavy raw wool felt shepherd's cloak (kepenek), wooden reed flute tucked into leather vest; stoic grief and weathered highland pride in dark eyes. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 32. `PORTRE-DYS-005` — Ziyaretçi 05 — Demirci Kalfası Hasan
- **Hedef Dosya:** `assets/art/char/char_demirci_hasan_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Konya Ahi ocağından kaçmış demirci kalfası; 26 yaşlarında, geniş omuzlu, adaleli boyun. Yüzünde demir tozu ve ocak kömürü isi, belinde kalın meşin önlük bağı. Saçları meşin kayışla geriye bağlanmış. Gözlerinde pabuç dama atılmasın diye direnen onurlu bir zanaatkâr bakışı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Sturdy 26-year-old blacksmith journeyman with muscular neck, coal-smudged forehead and cheeks, thick leather apron strap over a coarse linen tunic, hair tied back with leather cord; proud, defiant craftsman's gaze burning with stubborn resolve. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 33. `PORTRE-DYS-006` — Ziyaretçi 06 — Silahsız Piyade
- **Hedef Dosya:** `assets/art/char/char_silahsiz_piyade_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Sınır kalesinden firar etmiş nöbetçi; 22 yaşlarında, tıraşı uzamış, zayıf ve üşümüş. Üzerinde beylik armaları sökülmüş soluk asker cübbesi, silahsız kılıç kemeri. Sürekli arkasını kollayan, fısıltıyla konuşan adamın ürkek ve tetikte gözleri.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Panicked 22-year-old frontier garrison deserter with patchy stubble, shivering narrow shoulders, stripped military tunic where heraldic badges were roughly ripped off, empty sword belt buckle; paranoid darting eyes constantly checking shadows for pursuers. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 34. `PORTRE-DYS-007` — Ziyaretçi 07 — Seyyar Kalaycı
- **Hedef Dosya:** `assets/art/char/char_seyyar_kalayci_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Gezgin abdal kalaycı; 38 yaşlarında, dişlek, neşeli ve hızlı konuşan çehre. Sırtında kalay körüğü askısı, boynunda lehim damlalarıyla yanmış meşin önlük. Kulak memesinde küçük bakır halka, gözlerinde gurbet neşesi ve kurnazlık.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Lively 38-year-old wandering tinker tinsmith with crooked teeth, quick witty smile, soot-stained cheeks, leather aproned tunic speckled with silvery solder burn marks, a tiny copper hoop in earlobe; shrewd wanderer's warmth and cunning in bright eyes. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 35. `PORTRE-DYS-008` — Ziyaretçi 08 — Taşçı Kalfası
- **Hedef Dosya:** `assets/art/char/char_tasci_kalfasi_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Erzurum sur ustası ve taş yontucu; 48 yaşlarında, kireç ve taş tozuyla ağarmış gür kaşlar ve bıyıklar. Sert çatık kaşlar, nasırlı kaba eller. Üzerinde kalın keçe yelek ve taşçı önlüğü. Ağırbaşlı, az konuşan, taşın sesini dinleyen bir usta çehresi.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Burly 48-year-old master stonemason with bushy gray-streaked mustache and eyebrows coated in pale limestone dust, weathered chiselled jaw, heavy woolen felt work vest; quiet, somber dignified gaze of an experienced fortress builder. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 36. `PORTRE-DYS-009` — Ziyaretçi 09 — Fırıncı Çırağı Ali
- **Hedef Dosya:** `assets/art/char/char_firinci_ali_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Genç fırıncı kalfası; 16 yaşlarında, yanakları fırın sıcağından al al olmuş, burnunda un lekesi. Başında beyaz keten sarık, üzerinde kolları sıvalı bez gömlek. Ustasının dayağından kaçmış, kapıda donmamak için yalvaran samimi bir genç yüzü.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Earnest 16-year-old bakery journeyman boy with flour-dusted dark curly hair, flushed rosy cheeks from oven heat, rolled-up linen sleeves, wearing a simple cloth bakers cap; hopeful, anxious pleading look seeking refuge from harsh winter cold. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 37. `PORTRE-DYS-010` — Ziyaretçi 10 — Saraç Kalfası
- **Hedef Dosya:** `assets/art/char/char_sarac_kalfasi_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Eyer ve koşum ustası; 34 yaşlarında, bıyıkları sivri, parmakları meşin balmumuyla kararmış. Kuşağında saraç bıçağı kını ve pirinç perçinler. Yüzünde çalıntı eyer takımı taşımanın getirdiği gizli bir gerilim ve sert esnaf bakışı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Sharp-featured 34-year-old leather saddler craftsman with wax-blackened fingers, trimmed pointed mustache, thick hide apron with brass rivets and awl pocket visible at shoulder strap; guarded, suspicious glance of a craftsman guarding a costly secret. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 38. `PORTRE-DYS-011` — Ziyaretçi 11 — Yaralı Nöbetçi
- **Hedef Dosya:** `assets/art/char/char_yarali_nobetci_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Sınır köprüsünde oktan vurulmuş nöbetçi; 30 yaşlarında, sol omzu ve göğsü kanlı keten bezlerle sıkıca sarılmış. Kireç ve ziftle dağlanmış yaranın acısıyla dişlerini sıkan, solgun ve terli çehre. Gözlerinde ölüm kalım mücadelesinin acısı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Wounded 30-year-old outpost border sentry with pale clammy skin, jaw clenched in severe pain, left shoulder and collarbone bound in bloody linen bandages with herbal poultice seep, worn studded leather jerkin; feverish, defiant soldier gaze fighting off infection. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 39. `PORTRE-DYS-012` — Ziyaretçi 12 — Sürgün Kadı Kâtibi
- **Hedef Dosya:** `assets/art/char/char_surgun_katip_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Sivas kadılığından azledilmiş gururlu kâtip; 42 yaşlarında, sivri keçi sakallı, dar sarıklı. Parmakları mürekkep lekeli, yakası yıpranmış müderris cübbesi. Gözlerinde divandan kovulmuş olmanın kibri, küskünlüğü ve adalet açlığı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Disgraced 42-year-old exiled Islamic court scribe with trimmed goatee, dark scholarly turban, ink-stained quill fingers, frayed dark wool robe; haughty, resentful intellectual expression wounded by political betrayal. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 40. `PORTRE-DYS-013` — Ziyaretçi 13 — Gezgin Derviş Burhan
- **Hedef Dosya:** `assets/art/char/char_dervis_burhan_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Kalenderi sufi dervişi; 55 yaşlarında, çıplak göğsünde deve yünü haydariye, boynunda akik zikir taneleri. Elinde çentikli dut ağacından asa, başında on iki dilimli külah. Gözlerinde Moğol istilasını önceden görmüş bir ermişin dalgın ve hüzünlü bilgeliği.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Enigmatic 55-year-old wandering Kalenderi mystic with long wispy graying hair, coarse wool sleeveless mantle (haydariye), agate rosary beads, pointed felt dervish cap; serene, hauntingly prophetic smile of a sage who has transcended mortal dread. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 41. `PORTRE-DYS-014` — Ziyaretçi 14 — Kaçak Madenci
- **Hedef Dosya:** `assets/art/char/char_kacak_madenci_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Divriği demir ocaklarından kaçmış madenci; 36 yaşlarında, göğsü ve yüzü kara maden isi ve pasla kaplı, göz akları kömür karasında parlayan. Sırtında kırık demir kazma askısı, yırtık meşin yelek. Öksürükten boğulan göğüs, hürriyete kaçan adamın sert bakışı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Escaped 36-year-old iron ore miner with heavy coal soot embedded in skin pores, bloodshot dark eyes gleaming from a blackened gaunt face, ragged hide vest, broken pickaxe harness; fierce, breathless gaze of a laborer who broke free from subterranean bondage. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 42. `PORTRE-DYS-015` — Ziyaretçi 15 — Türkmen Anası Saruca
- **Hedef Dosya:** `assets/art/char/char_turkmen_anasi_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Yaşlı ve buyurgan Türkmen anası; 58 yaşlarında, yüzünde yayla rüzgârının derin çizgileri. Başında ak bürüncük tülbent, omuzlarında koyun yünü şal, kucağında iki öksüz sabiyi koruyan kollar. Gözlerinde sabilerin rızkı için orduların önüne duracak bir ana metaneti.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Indomitable 58-year-old Turkmen matriarch with deeply furrowed weathered brow, white homespun cotton headscarf framing a strong stern face, thick sheepskin shawl pinned with antique brass brooch; fiercely protective, unyielding maternal authority. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 43. `PORTRE-DYS-016` — Ziyaretçi 16 — Tövbekâr Harami
- **Hedef Dosya:** `assets/art/char/char_tovbekar_harami_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Dağ eşkıyalığından tövbe etmiş harami; 35 yaşlarında, sol elmacık kemiğinden boynuna uzanan derin kılıç yarası. Sırtında kurttan bozma kürk yelek, kuşağında gizli hançer kını. Gözlerinde hem eski çetesinin intikamından kaçmanın tedirginliği hem de temiz bir hayat arzusu.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Penitent 35-year-old reformed mountain bandit with a jagged scar across left cheek, dark stubbled jaw, wolf-fur trimmed rugged vest, concealed dagger sheath strap crossing chest; tense, dangerous yet remorseful gaze of an outlaw seeking redemption. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 44. `PORTRE-DYS-017` — Ziyaretçi 17 — Rum Değirmenci Mihali
- **Hedef Dosya:** `assets/art/char/char_degirmenci_mihali_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Kapadokya Rum değirmen ustası; 52 yaşlarında, sakalı un tozundan ağarmış, nazik ve temkinli çehre. Başında yuvarlak kumaş takke, üzerinde unla beyazlaşmış iş önlüğü. Gözlerinde suyun ve taşın sesini bilen, sınır kavgalarından bıkmış bir zanaatkâr sabrı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Gentle 52-year-old Cappadocian Greek miller with flour-whitened beard and bushy eyebrows, round soft woolen cap, dusty flour-coated coarse canvas smock; patient, cautious and weary gaze of a craftsman who respects the turning wheel. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 45. `PORTRE-DYS-018` — Ziyaretçi 18 — Avcı Kara Bekir
- **Hedef Dosya:** `assets/art/char/char_avci_kara_bekir_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Orman ve dağ avcısı; 44 yaşlarında, kurt postu başlıklı, fındık rengi keskin gözler. Kuşağında kemik kabzalı av bıçağı, sırtında porsuk derisi sadak. Yüzünde çam reçinesi ve rüzgâr yanığı, gecenin sesini dinleyen bir iz sürücü dikkati.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Vigilant 44-year-old forest hunter wearing a cured wolf-pelt hood, windburned weathered skin, badger-fur quiver strap over rough deerhide tunic; piercing hawk-like hazel eyes tuned to nocturnal danger in wild woods. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 46. `PORTRE-DYS-019` — Ziyaretçi 19 — Saz Aşığı Kul Dertli
- **Hedef Dosya:** `assets/art/char/char_asik_kul_dertli_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Gezgin halk ozanı; 40 yaşlarında, sırtında meşin kılıfta üç telli kopuz. Yıpranmış kırmızı aba yelek, dökülen dalgalı kır saçlar. Gözlerinde gurbet türkülerinin hüznü, beylik divanlarının zulmünü sazıyla haykıran aşık bakışı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Melancholic 40-year-old wandering folk bard (aşık) with greying shoulder-length hair, worn crimson woolen vest, wooden three-stringed lute (kopuz) neck visible over shoulder; soulful, poetic eyes holding decades of exile ballads and wanderlust. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 47. `PORTRE-DYS-020` — Ziyaretçi 20 — Seyyar Nalbant
- **Hedef Dosya:** `assets/art/char/char_seyyar_nalbant_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** At pazarı nalbant ustası; 46 yaşlarında, güçlü çeneli, parmakları demir tavı ve nal yağı lekeli. Göğsünde demir mıh torbası ve kerpeten askısı, kalın manda derisi önlük. Gözlerinde atın toynağından hastalığını anlayan pratik ve dobra bir esnaf mizacı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Sturdy 46-year-old itinerant farrier horse-shoer with thick forearms, oil-stained thick bull-hide apron, pincers and iron horseshoe nails hanging from leather belt; pragmatic, blunt and honest gaze of a seasoned horse healer. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 48. `PORTRE-KOY-AYDOGDU` — Köylü — Okçu Aydoğdu
- **Hedef Dosya:** `assets/art/char/char_aydogdu_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Kösedağ gazisi Avşar Türkmeni okçu; 28 yaşlarında, sol kolu bezle sıkı sargılı amma sağ eli yay kabzasında. Başında kulaklıklı keçe börk, sırtında huş ağacı yay ve tilki kuyruğu takılı sadak. Gözlerinde beylik umudu ve savaşçı dikkati.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Proud 28-year-old Avshar Turkmen archer (Aydoğdu) with bandaged left arm, resolute jaw, wearing a felt combat cap with earflaps, birch recurve bow and fur quiver strap across chest; hardened warrior gaze of a battle-tested marksman. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 49. `PORTRE-KOY-AYSE-BACI` — Köylü — Ayşe Bacı
- **Hedef Dosya:** `assets/art/char/char_ayse_baci_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Kayseri Bacıyan-ı Rum teşkilatından dokuma ustası; 45 yaşlarında, sırtında portatif katlanır dokuma tezgâhı ayağı. Başında temiz toprak rengi bürüncük tülbent, üzerinde nakışlı yün yelek. Gözlerinde analık şefkati, esnaf disiplini ve çıraklarına kol kanat geren usta vakarı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Venerable 45-year-old master weaver woman (Ayşe Bacı) of the Baciyan-i Rum guild, draped in a modest beige linen headscarf, embroidered artisan vest, carrying a compact wooden weaving loom frame; dignified, nurturing and authoritative guild-mother expression. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 50. `PORTRE-KOY-HASAN-CELEBI` — Köylü — Kâtip Hasan Çelebi
- **Hedef Dosya:** `assets/art/char/char_hasan_celebi_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Sivas divanı vergi kâtibi; 38 yaşlarında, iyi dikilmiş lacivert çuha kaftan, ince sarık. Parmak uçları ve tırnak dipleri siyah divit mürekkebiyle boyanmış. Yanında mühürlü meşin vergi kütüğü çantası. Gözlerinde bürokratik dürüstlük ve köyü nizamla yaşatma arzusu.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Erudite 38-year-old imperial tax scribe (Hasan Çelebi) with neat trimmed beard, elegant navy-blue scholar robe, dark ink stains on fingertips, small rolled scroll tucked into sash; intelligent, meticulous and quietly honorable administrative gaze. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 51. `PORTRE-KOY-KARACA-USTA` — Köylü — Karaca Usta
- **Hedef Dosya:** `assets/art/char/char_karaca_usta_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Köyün demirci ve nalbant piri, Kayseri Ahi ustası; 50 yaşlarında, kırlaşmış gür sakallı, belinde yeşil Ahi şeddi kuşağı. Üzerinde isli kalın manda derisi önlük. Gözlerinde adaleti örs üstünde tartan bir usta ciddiyeti ve esnaf babalığı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Respected 50-year-old master village blacksmith and tanner (Karaca Usta) with thick salt-and-pepper beard, green woven Ahi guild sash around waist, heavy soot-stained leather forge apron; stern, deeply fair and venerable patriarch expression. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 52. `PORTRE-KOY-MIRAEN` — Köylü — Şifacı Miraen
- **Hedef Dosya:** `assets/art/char/char_miraen_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Köyün kadim otacı ve şifacısı; 62 yaşlarında, yüzü kırışık ve nurani. Boynunda kurutulmuş dağ nanesi ve kantaron demetleri, başında mor desenli pamuklu örtü. Gözlerinde yüz yıllık otların sırrını bilen, merhametli ve bilge bir hekim bakışı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Wise 62-year-old village herbalist and apothecary grandmother (Miraen) with gentle wrinkling face, deep soulful dark eyes, draped in an indigo-patterned cotton shawl, sprigs of dried mountain thyme and yarrow hung around neck; compassionate, mystical healer's warmth. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 53. `PORTRE-KOY-NOGAY` — Köylü — Avcı Nogay
- **Hedef Dosya:** `assets/art/char/char_nogay_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Bozkır iz sürücüsü ve köy avcısı; 32 yaşlarında, çekik keskin gözlü, seyrek bıyıklı. Başında samur kürk börk, sırtında kemik kakmalı boynuz yay ve tilki kürkleri. Gözlerinde ormanın en gizli kıpırtısını anında sezen avcı refleksi.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Keen-eyed 32-year-old steppe hunter and tracker (Nogay) with high cheekbones, sparse mustache, conical fur-trimmed felt hat (börk), raw deerskin tunic, bone-inlaid bow strap crossing chest; silent, razor-sharp predator focus in dark slanted eyes. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 54. `PORTRE-KOY-SARUCA-HATUN` — Köylü — Saruca Hatun
- **Hedef Dosya:** `assets/art/char/char_saruca_hatun_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Köyün oba anası ve akıl hocası; 65 yaşlarında, vakur ve bilge Türkmen kadını. Başında altın sikkeli gümüş alınlık takılı ak tülbent, üzerinde sırmalı kadife cepken. Gözlerinde beylik töresini ayakta tutan çelik gibi bir irade ve ana şefkati.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Noble 65-year-old Turkmen clan matriarch (Saruca Hatun) wearing an immaculate white veil adorned with silver coin brow ornaments, embroidered dark velvet bodice; majestic, fiercely wise and venerable countenance of a frontier clan elder. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 55. `PORTRE-KOY-SORHAN` — Köylü — At Tüccarı Sorhan
- **Hedef Dosya:** `assets/art/char/char_sorhan_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Kıpçak at tüccarı ve eski akıncı; 36 yaşlarında, rüzgâr yanığı bronz ten, örülü saç tutamı. Boynunda at kılından nazarlık, üzerinde perçinli süvari deri yeleği. Gözlerinde bozkır fırtınalarının yabaniliği ve at cambazı gururu.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Weathered 36-year-old Kipchak horse merchant and veteran raider (Sorhan) with braided dark scalp lock, chapped sun-bronzed skin, braided horsehair talisman around neck, riveted leather horseman's vest; proud, restless equestrian wildness in steely eyes. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 56. `PORTRE-KOY-THESSRA` — Köylü — Hekim Kızı Thessra
- **Hedef Dosya:** `assets/art/char/char_thessra_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Trabzonlu Rum tabip kızı; 24 yaşlarında, zeytin yeşili zeki ve temkinli gözler. Başında zarif dantelli tülbent, boynunda küçük yeşim taşlı gümüş haç. Kucağında sedir ağacından minik ecza kutusu askısı. Gözlerinde hem gurbet tedirginliği hem de cerrahlık cesareti.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Intelligent 24-year-old Pontic Greek physician's daughter (Thessra) with observant olive-green eyes, fine dark lace veil pinned over braided hair, dark wool tunic with clean linen cuffs, small cedarwood apothecary case strap; cautious, proud medical scholar's poise. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```

### 57. `PORTRE-KOY-YUSUF` — Köylü — Yetim Çoban Yusuf
- **Hedef Dosya:** `assets/art/char/char_yusuf_neutral_card.png`
- **Boyut:** 600×760 | **Saydamlık / Zemin:** RGBA; düz #00FF00
- **Karakter ve Sahne Tarifi:** Köyün 12 yaşındaki öksüz keçicisi; zayıf, çilli yanaklı, dağınık saçlı delikanlı. Elinde boş keçi urganı parçası, üzerinde babasından kalma kolları katlanmış eski yün yelek. Gözlerinde hem yetim kalmanın hüznü hem de bir lokma ekmek ve şefkat bekleyen masumiyet.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Gaunt 12-year-old orphan goatherd boy (Yusuf) with tousled brown hair, freckled sun-chapped nose, oversized patched woolen vest with frayed hem, clutching a frayed hemp goat tether rope; poignantly innocent, vulnerable and quietly longing expression. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas.
```
