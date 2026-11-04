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
