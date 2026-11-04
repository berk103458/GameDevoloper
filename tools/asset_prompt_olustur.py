#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Diyalog ve Anlatı 2D Asset Promptları Üretici — Görev 13 Bölüm B
27 yeni anlatı ve diyalog görsel ihtiyacı:
- 10 Ziyaretçi Portresi (21-30)
- 1 Eş Portresi
- 8 Köy Olayı Kartı
- 3 Defter ve Söylenti Görseli
- 5 Oyun Sonu / Epilog Görseli
"""

import os

PROMPT_DOSYASI = "docs/arayuz/DIYALOG_ASSET_PROMPTLARI.md"
ENVANTER_DOSYASI = "docs/EKSIK_ASSET_ENVANTERI.md"

asset_listesi = [
    # 1. Ziyaretçi Portreleri (10 Karakter)
    {
        "id": "PORTRE-DYS-021",
        "dosya": "assets/art/char/char_dervis_baba_neutral_card.png",
        "boyut": "600×760",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Ziyaretçi 21 — Derviş Baba",
        "tur": "portre",
        "tanim": "Meczup gezgin derviş; 60 yaşlarında, sakalı göğsüne inen kır saçlı pir. Üzerinde yüzlerce renkli yamadan dikilmiş hırka, başında keçeden sivri derviş külahı. Boynunda boynuzdan nefir ve zikir taneleri. Gözlerinde dünya kaygısından uzak, bilge ve dalgın bir tebessüm. Sırtında heybesi.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Venerable 60-year-old wandering Sufi dervish with long gray beard, wearing a patched coarse woolen cloak, a pointed felt dervish cap, prayer beads and a horn hung around neck; calm, transcendent gaze of an ascetic mystic. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas."
    },
    {
        "id": "PORTRE-DYS-022",
        "dosya": "assets/art/char/char_tuccar_tebrizli_neutral_card.png",
        "boyut": "600×760",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Ziyaretçi 22 — Tebrizli Safrancı Tüccar",
        "tur": "portre",
        "tanim": "İran ve Tebriz kervanlarından gelen kurnaz tüccar; 45 yaşlarında, sivri siyah sakallı, sürmeli gözlü. Başında ipek sarık, sırtında yakası samur kürk işlemeli lakin yol tozuyla kirlenmiş kaftan. Parmaklarında akik ve firuze yüzükler, boynunda tartı terazisi askısı.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Cunning 45-year-old Persian saffron merchant from Tabriz with kohl-lined sharp eyes, trimmed black beard, ornate silk turban, and travel-stained sable-trimmed merchant coat; shrewd calculating expression. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas."
    },
    {
        "id": "PORTRE-DYS-023",
        "dosya": "assets/art/char/char_cavus_sungur_neutral_card.png",
        "boyut": "600×760",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Ziyaretçi 23 — Sancak Çavuşu Sungur",
        "tur": "portre",
        "tanim": "Sancak beyinin ordusundan firari ya da pusu kurtulanı kıdemli çavuş; 35 yaşlarında, sert çeneli. Başında dövme demir Selçuklu miğferi, sağ yanağında derin kılıç sıyrığı. Üzerinde kan ve pas lekeli perçinli zırh, gözlerinde tetikte bir şüphe ve yorgun savaşçı öfkesi.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Battle-hardened 35-year-old Seljuk frontier sergeant wearing a conical wrought-iron helmet, scarred weathered cheek, mud-and-blood splattered riveted brigandine armor; stern vigilant eyes of a grim veteran soldier. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas."
    },
    {
        "id": "PORTRE-DYS-024",
        "dosya": "assets/art/char/char_vebali_ana_neutral_card.png",
        "boyut": "600×760",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Ziyaretçi 24 — Vebalı Ana ve Sabi",
        "tur": "portre",
        "tanim": "Akpınar vebasından kaçan kederli anne; 25 yaşlarında, solgun yüzü yıpranmış kaba keten tülbentle burnunun altına kadar örtülü. Gözlerinde ateşli humma parıltısı ve evladını kurtarma çaresizliği. Göğsünde sıkı sıkıya sardığı eski kundakta 6 aylık bebeğin uyuyan yüzü belirir.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Desperate 25-year-old peasant mother suffering from epidemic fever, lower face wrapped in a worn homespun linen veil, hollow feverish sorrowful eyes, cradling a swaddled sleeping infant closely against her chest under a frayed blanket. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas."
    },
    {
        "id": "PORTRE-DYS-025",
        "dosya": "assets/art/char/char_firinci_dursun_neutral_card.png",
        "boyut": "600×760",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Ziyaretçi 25 — Fırın Çırağı Dursun",
        "tur": "portre",
        "tanim": "Fırın çırağı ve muhafızın yeğeni; 14 yaşlarında zayıf delikanlı. Yanaklarında ve alnında un ve fırın kurumu lekeleri, saçları dağınık. Üzerinde kolları sıvalı yırtık bez gömlek ve meşin önlük. Gözlerinde korku, heyecan ve amcasına sığınma telaşı.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Lean 14-year-old bakery apprentice boy with soot and flour smudged on youthful cheeks, messy hair, wearing a patched rough tunic with rolled sleeves and stained leather apron; anxious yet earnest expression. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas."
    },
    {
        "id": "PORTRE-DYS-026",
        "dosya": "assets/art/char/char_cerrah_lokman_neutral_card.png",
        "boyut": "600×760",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Ziyaretçi 26 — Şarlatan Cerrah Lokman",
        "tur": "portre",
        "tanim": "Kaçak ve sahtekâr cerrah; 50 yaşlarında, yağlı seyrek sakallı, bıyıkları kına boyalı. Başında gösterişli ama solmuş sarık, kuşağında pirinç cerrah aletleri ve küçük cam ecza şişeleri. Gözlerinde yalan söyleyen adamın sinsi tebessümü.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Shifty 50-year-old itinerant charlatan barber-surgeon with henna-tinted thin mustache, greasy beard, faded peacock-patterned turban, small apothecary glass vials visible in sash; sly, untrustworthy smirk. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas."
    },
    {
        "id": "PORTRE-DYS-027",
        "dosya": "assets/art/char/char_katip_sukru_neutral_card.png",
        "boyut": "600×760",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Ziyaretçi 27 — Sivas Kâtibi Molla Şükrü",
        "tur": "portre",
        "tanim": "Sivas mahkemesinden kovulmuş kâtip; 40 yaşlarında, gözlerini sürekli kısan, zayıf ve kurnaz. Parmak uçları ve cübbesinin manşetleri kara divit mürekkebiyle boyanmış. Başında dar sarık, kuşağında pirinç divit sapı. Çalıntı mühür taşımanın getirdiği tedirgin kurnazlık.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Cunning, squinting 40-year-old disgraced court scribe with black ink stains on fingertips and cuffs, dark woolen scholar robe, small scholar turban; nervous, calculating gaze of an opportunistic forger. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas."
    },
    {
        "id": "PORTRE-DYS-028",
        "dosya": "assets/art/char/char_banu_hatun_neutral_card.png",
        "boyut": "600×760",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Ziyaretçi 28 — Dağların Kurdu Banu Hatun",
        "tur": "portre",
        "tanim": "Türkmen savaşçı kadın; 28 yaşlarında, kement gibi iki yana örülmüş koyu kahve saçlar. Omuzlarında gerçek gri kurt postu, göğsünde perçinli deri zırh. Elinde demir kabzalı kılıç, gözlerinde intikam ve mertlik ateşi yanan mağrur alp hatunu.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Fierce 28-year-old female Turkmen warrior with long braided dark hair, a real wolf pelt draped across sturdy shoulders, hardened leather armor with brass studs; proud, resolute warrior gaze burning with grief and vengeance. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas."
    },
    {
        "id": "PORTRE-DYS-029",
        "dosya": "assets/art/char/char_kafile_habercisi_neutral_card.png",
        "boyut": "600×760",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Ziyaretçi 29 — Kafile Habercisi",
        "tur": "portre",
        "tanim": "Kar fırtınasını aşıp gelen haberci; 30 yaşlarında, kaşları ve bıyıkları don tutmuş, dudakları soğuktan çatlamış ve morarmış. Başında kulaklıklı kalın kürk börk, sırtında mühürlü meşin haberci çantası. Nefes nefese, gözlerinde ölümle yarışmış adamın telaşı.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Breathless 30-year-old frontier blizzard courier with frost on eyelashes and mustache, chapped windburned lips, thick sheepskin fur cap with ear flaps, heavy coarse wool cloak; urgent, desperate messenger eyes. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas."
    },
    {
        "id": "PORTRE-DYS-030",
        "dosya": "assets/art/char/char_yetim_turna_neutral_card.png",
        "boyut": "600×760",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Ziyaretçi 30 — Yetim Turna",
        "tur": "portre",
        "tanim": "10-12 yaşlarında yetim kız çocuğu, Dursun'un kayıp kardeşi. Başında solmuş çiçek işlemeli yemeni, omuzlarında yamalı yün şal. Kucağında paçavradan yapılmış tahta bir bez bebek tutar. Masum, ürkek ama umutla bakan ela gözler.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Innocent, timid 11-year-old orphan girl with large hazel eyes, faded embroidered cotton headscarf framing a delicate pale face, clutching a tiny handmade rag doll wrapped in coarse wool; hauntingly fragile yet hopeful expression. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas."
    },

    # 2. Eş Portresi
    {
        "id": "PORTRE-DYS-ES",
        "dosya": "assets/art/char/char_muhafiz_esi_neutral_card.png",
        "boyut": "600×760",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Muhafızın Eşi — Oda ve Kapı Düşünceleri Portresi",
        "tur": "portre",
        "tanim": "Muhafızın eşi; 28-30 yaşlarında, vakur, şefkatli ve akıllı Selçuklu uç köyü kadını. Başında zarif toprak tonlarında bürüncük tülbent, üzerinde nakışlı sıcak yün yelek. Gözlerinde hem kocasının yükünü paylaşan derin bir sadakat hem de kışın sertliğine karşı dirayetli bir metanet.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Dignified 28-year-old Anatolian gatekeeper's wife with warm wise brown eyes, draped in a modest earthen-toned woolen veil over a finely embroidered winter vest; gentle, loving yet fiercely resilient countenance of a frontier matriarch. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas."
    },

    # 3. Köy Olayı Kartları (8 Olay)
    {
        "id": "KART-OLAY-01",
        "dosya": "assets/art/events/event_kavga_harman.png",
        "boyut": "800×450",
        "saydamlik": "Opak RGB",
        "ad": "Köy Olayı 1 — Harman Yeri Kavgası",
        "tur": "olay_karti",
        "tanim": "Harman yerinde iki köylünün dirgen ve kürekle buğday çuvalı kavgası; arkada saman yığınları, onları ayırmaya çalışan köylüler.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Heated village brawl at a rustic threshing floor in autumn dusk; two angry peasant farmers arguing over a grain sack with raised wooden pitchfork and spade while neighbors rush to intervene; golden haystacks and dusty autumn twilight. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    },
    {
        "id": "KART-OLAY-02",
        "dosya": "assets/art/events/event_ambarda_hirsizlik.png",
        "boyut": "800×450",
        "saydamlik": "Opak RGB",
        "ad": "Köy Olayı 2 — Ambarda Gece Hırsızlığı",
        "tur": "olay_karti",
        "tanim": "Köy ambarının zorlanmış kilitli ahşap kapısı, yere dökülmüş arpa ve buğday taneleri, kar üstünde meşale ışığı ve kaçan ayak izleri.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Nocturnal burglary at a heavy timber communal granary; forced iron padlock hanging broken, trail of spilled barley on fresh snow illuminated by a warm torch held by a guard, dark shadowy footprints leading into the cold pine woods. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    },
    {
        "id": "KART-OLAY-03",
        "dosya": "assets/art/events/event_salgin_fisiltisi.png",
        "boyut": "800×450",
        "saydamlik": "Opak RGB",
        "ad": "Köy Olayı 3 — Salgın Fısıltısı ve Korku",
        "tur": "olay_karti",
        "tanim": "Köy meydanındaki taş kuyu başında ağızlarını tülbentle kapatmış köylü kadınlar; sisli ve tekinsiz bir kış sabahında tedirgin fısıldaşma.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Tense village women gathered by an ancient stone well in morning fog, muffling their faces with coarse linen scarves while whispering in fearful suspicion of disease; ominous mist curling between stone cottages. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    },
    {
        "id": "KART-OLAY-04",
        "dosya": "assets/art/events/event_koy_dugunu.png",
        "boyut": "800×450",
        "saydamlik": "Opak RGB",
        "ad": "Köy Olayı 4 — Köy Meydanında Kış Düğünü",
        "tur": "olay_karti",
        "tanim": "Köy meydanında devasa meşe odunu ateşi etrafında halay çeken neşeli köylüler, davul çalan ozan, kırmızı duvaklı gelin ve sıcak şenlik.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Festive winter wedding celebration around a roaring bonfire in the village square; villagers dancing hand-in-hand, a bard playing a rustic lute (kopuz), bride in a crimson-embroidered veil, festive warm sparks rising into the starry cold night. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    },
    {
        "id": "KART-OLAY-05",
        "dosya": "assets/art/events/event_firari_cenazesi.png",
        "boyut": "800×450",
        "saydamlik": "Opak RGB",
        "ad": "Köy Olayı 5 — Firari Asker Cenazesi",
        "tur": "olay_karti",
        "tanim": "Karlar altındaki köy mezarlığında sade ahşap tabut, dua eden imam ve başı eğik muhafız; gri kasvetli gökyüzü altında sessiz hüzün.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Somber funeral in a snow-covered hillside graveyard; a simple unadorned wooden coffin resting by an open trench, villagers with bowed heads in solemn prayer beside an ancient lone gnarled oak, cold winter overcast sky. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    },
    {
        "id": "KART-OLAY-06",
        "dosya": "assets/art/events/event_samanlik_yangini.png",
        "boyut": "800×450",
        "saydamlik": "Opak RGB",
        "ad": "Köy Olayı 6 — Gece Samanlık Yangını",
        "tur": "olay_karti",
        "tanim": "Gece karanlığında alev alev yanan köy samanlığı; tahta kovalarla kuyudan su taşıyan köylüler ve göğe yükselen duman bulutu.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Dramatic night fire consuming a thatched-roof wooden barn; panicked villagers forming a bucket brigade from the stone well, bright orange flames casting intense shadows across snow and timber walls, thick smoke billowing. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    },
    {
        "id": "KART-OLAY-07",
        "dosya": "assets/art/events/event_gece_donu.png",
        "boyut": "800×450",
        "saydamlik": "Opak RGB",
        "ad": "Köy Olayı 7 — Gece Ayazı ve Don Kırgını",
        "tur": "olay_karti",
        "tanim": "Köy kapısının surlarından sarkan dev buz saçakları, donmuş dere yatağı, meşale başında donmamak için ellerini ovuşturan nöbetçi muhafız.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Extreme winter freeze at the fortified wooden palisade; massive sharp icicles hanging from parapets, frozen creek under thick ice, shivering sentry guard huddled near a sputtering brazier blowing warm breath into woolen mittens. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    },
    {
        "id": "KART-OLAY-08",
        "dosya": "assets/art/events/event_harami_elcisi.png",
        "boyut": "800×450",
        "saydamlik": "Opak RGB",
        "ad": "Köy Olayı 8 — Harami Elçisi ve Haraç Ültimatomu",
        "tur": "olay_karti",
        "tanim": "Surların önünde siyah at üstünde, yüzü siyah puşiyle örtülü, mızrağının ucuna haraç mektubu takmış tehditkâr dağ haramisi süvarisi.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. One narrative event illustration: Menacing bandit rider on a dark steed outside the village gate in twilight mist; face concealed by a black scarf, holding a long spear bearing a blood-stained tribute parchment ultimatum, cold defiance. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    },

    # 4. Defter ve Söylenti Görselleri (3 Görsel)
    {
        "id": "UI-DEFTER-DERI",
        "dosya": "assets/art/ui/ui_defter_kapak_deri.png",
        "boyut": "512×512",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Hafıza Defteri — Yıpranmış Deri Kapak",
        "tur": "ui_nesnesi",
        "tanim": "13. yy el yazması defter kapağı; yıpranmış koyu kahve keçi derisi, köşelerinde dövme pirinç koruyucu bentler, ortasında silik Selçuklu sekizgen yıldız kabartması, deri bağcık.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated book object: Closed medieval leather ledger notebook bound in dark weathered goat hide with hand-hammered brass corner protectors, faint embossed Seljuk geometric star medallion, and a wrap-around leather thong tie. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas."
    },
    {
        "id": "UI-DEFTER-PARSOMEN",
        "dosya": "assets/art/ui/ui_defter_sayfa_parsomen.png",
        "boyut": "512×512",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Hafıza Defteri — Kadim Parşömen Sayfası",
        "tur": "ui_nesnesi",
        "tanim": "Eski parşömen kâğıdı dokusu; kenarları hafif yıpranmış, bezir yağı ve su lekeleri olan fildişi-sarı tonlu boş yazı sayfası.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated parchment page: Authentic aged medieval vellum parchment paper sheet with slightly deckled rough edges, warm ivory and amber aged patina, subtle water stains and worn folds; completely blank surface ready for writing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas."
    },
    {
        "id": "UI-SOYLENTI-AGI",
        "dosya": "assets/art/ui/icon_soylenti_agi.png",
        "boyut": "512×512",
        "saydamlik": "RGBA; düz #00FF00",
        "ad": "Söylenti Ağı İkonu — Bağlantılar ve İpuçları",
        "tur": "ui_nesnesi",
        "tanim": "Ahşap masa üzerinde yanmış mum, divit hokka ve birbirine kırmızı sicim iplerle bağlanmış küçük parşömen kâğıtları; söylenti ağı dedektif ikonu.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated UI icon: Rustic wooden tabletop with small pinned parchment scraps interconnected by taut red twine threads, accompanied by a stubby melting beeswax candle and an iron inkpot with reed pen; medieval frontier rumor network. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas."
    },

    # 5. Son ve Epilog Görselleri (5 Son)
    {
        "id": "SON-DYS-TEKFUR",
        "dosya": "assets/art/env/son_tekfur_haraccisi_cinar.png",
        "boyut": "1920×1080",
        "saydamlik": "Opak RGB",
        "ad": "Oyun Sonu 1 — Tekfur'un Vergi Tahakkümü",
        "tur": "son_sahnesi",
        "tanim": "Karanlık ve boyun eğmiş son; Bizans Tekfuru'nun ağır zırhlı süvarileri köy meydanına girmiş, ambarın başına kendi bayraklarını dikmiş, Çınar Meclisi'nin boynu bükük.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. Dramatic game ending cutscene: Gloomy defeat; armored Byzantine cataphract cavalry garrisoning the Anatolian village square, haughty tax collectors requisitioning the communal granary under a foreign eagle banner, villagers watching in somber defeat under the bare ancient plane tree at dusk. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    },
    {
        "id": "SON-DYS-ERTUGRUL",
        "dosya": "assets/art/env/son_ertugrul_obasi_sancak.png",
        "boyut": "1920×1080",
        "saydamlik": "Opak RGB",
        "ad": "Oyun Sonu 2 — Ertuğrul Obasının Uç Beyliği Zaferi",
        "tur": "son_sahnesi",
        "tanim": "Büyük zafer ve umut sonu; Ertuğrul Gazi'nin yeşil ve kızıl sancaklı Türkmen alp süvarileri vadiyi doldurmuş, köy kapısına beylik mührü vurulmuş, köylüler coşkuyla karşılıyor.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. Triumphant game ending cutscene: Grand historical triumph; columns of noble Turkmen cavalry (kayi alps) bearing green and crimson banners riding into the welcoming frontier village at dawn, the village gate firmly secured as a thriving principality march outpost, cheering villagers under warm golden sunrise. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    },
    {
        "id": "SON-DYS-AHI",
        "dosya": "assets/art/env/son_ahi_kasabasi_refah.png",
        "boyut": "1920×1080",
        "saydamlik": "Opak RGB",
        "ad": "Oyun Sonu 3 — Müreffeh Ahi Zanaat Kasabası",
        "tur": "son_sahnesi",
        "tanim": "Ekonomik refah ve adalet sonu; köy genişlemiş, Karaca Usta'nın demirhanesi ve zanaat dükkanları büyümüş, Ahi bayrakları altında kervanlar güvenle girip çıkıyor.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. Prosperous game ending cutscene: Flourishing Ahi guild craftsmanship town; bustling artisans hammering copper and iron, weavers, loaded merchant caravans safely trading at the fortified market square adorned with craft guild pennants, serene community wealth and harmony. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    },
    {
        "id": "SON-DYS-KURTULUS",
        "dosya": "assets/art/env/son_veba_karantina_kurtulus.png",
        "boyut": "1920×1080",
        "saydamlik": "Opak RGB",
        "ad": "Oyun Sonu 4 — Salgını Yenen Umutlu Bahar",
        "tur": "son_sahnesi",
        "tanim": "Kireç ocağında vebayı savuşturan köyün karları eriyen bahara ulaştığı an; iyileşen sabi annesinin kucağında gülümser, köy evlerinin bacaları neşeyle tüter.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. Hopeful narrative ending cutscene: Salvation from pestilence; melting snow yielding to early spring blossoms around the frontier village, the cured peasant mother holding her healthy smiling toddler outside the sanitized stone lime kiln, smoke rising peacefully from cozy chimneys under a bright clear sky. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    },
    {
        "id": "SON-DYS-DIRENIS",
        "dosya": "assets/art/env/son_harami_kusatmasi_direnis.png",
        "boyut": "1920×1080",
        "saydamlik": "Opak RGB",
        "ad": "Oyun Sonu 5 — Surlarda Destansı Savunma",
        "tur": "son_sahnesi",
        "tanim": "Banu Hatun ve 50 süvarisinin, muhafızların karlı vadide harami ordusuna karşı sur önünde durduğu destansı sınır direnişi zaferi.",
        "prompt": "Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, atmospheric storytelling and cinematic lighting. Epic battle ending cutscene: Legendary frontier gate defense; Banu Hatun and allied horsemen standing resolute on snow-covered ramparts and gate palisade alongside the village watch, repelling mountain raiders in a dramatic winter twilight, flaming arrows arching into the dusk. No text, no letters, no numbers, no checkerboard, no UI borders, no 3D render. Use a 16:9 source canvas."
    }
]

def uret_prompt_dokumani():
    lines = [
        "# Kapı Muhafızı — Diyalog ve Anlatı 2D Asset Promptları (Görev 13)",
        "",
        "**Hazırlayan:** Antigravity  ",
        "**Tarih:** 4 Kasım 2026  ",
        "**Sanat Yönü:** 13. yüzyıl Anadolu Selçuklu uç beyliği atmosferi, 'gece_kapisi' koyu palet üslubu (isli ahşap #30251F, dövme demir #58616A, amber #C88A43, fildişi #E6DDC6, kömür #10171C). Saydam nesnelerde arka plan düz **#00FF00**, metinsiz (`no text`), 4:5 portre veya 16:9 sinematik kanvas.",
        "",
        "---",
        "",
        "## İçindekiler ve Özet Tablo",
        "",
        "| ID | Nihai Dosya | Ölçü | Tür / Zemin | Tanım |",
        "|---|---|---|---|---|"
    ]

    for item in asset_listesi:
        lines.append(f"| `{item['id']}` | `{item['dosya']}` | {item['boyut']} | {item['saydamlik']} | {item['ad']} |")

    lines.extend([
        "",
        "---",
        "",
        "## Tekil Nano Banana Promptları",
        ""
    ])

    for i, item in enumerate(asset_listesi, 1):
        lines.append(f"### {i}. `{item['id']}` — {item['ad']}")
        lines.append(f"- **Hedef Dosya:** `{item['dosya']}`")
        lines.append(f"- **Boyut:** {item['boyut']} | **Saydamlık / Zemin:** {item['saydamlik']}")
        lines.append(f"- **Karakter ve Sahne Tarifi:** {item['tanim']}")
        lines.append("")
        lines.append("```text")
        lines.append(item["prompt"])
        lines.append("```")
        lines.append("")

    with open(PROMPT_DOSYASI, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"{PROMPT_DOSYASI} oluşturuldu ({len(asset_listesi)} prompt).")

def guncelle_envanter():
    with open(ENVANTER_DOSYASI, "r", encoding="utf-8") as f:
        icerik = f.read()

    # İlgili bölümün altına diyalog assetleri tablosunu ekle
    baslik = "### Envanterin tekli 2D parçaları"
    if "### Diyalog ve Anlatı 2D Parçaları (Görev 13 — Antigravity)" in icerik:
        print("Envanter zaten güncel.")
        return

    ek_tablo = [
        "",
        "### Diyalog ve Anlatı 2D Parçaları (Görev 13 — Antigravity)",
        "",
        "Görev 6, 8 ve 13 kapsamında derinleştirilen 10 ziyaretçi (21-30), muhafızın eşi, 8 köy olayı kartı, defter/söylenti görselleri ve 5 oyun sonu için hazırlanan 27 tekil 2D parçadır. Tam İngilizce Nano Banana promptları ve Türkçe karakter tarifleri [Diyalog Asset Promptları](arayuz/DIYALOG_ASSET_PROMPTLARI.md) belgesindedir.",
        "",
        "| Kaynak ID | Nihai dosya | Boyut (px) | Saydamlık / kaynak zemin | Hazır prompt |",
        "|---|---|---|---|---|"
    ]

    for item in asset_listesi:
        ek_tablo.append(f"| `{item['id']}` | `{item['dosya']}` | {item['boyut']} | {item['saydamlik']} | [Prompt {item['id']}](arayuz/DIYALOG_ASSET_PROMPTLARI.md#{item['id'].lower()}) |")

    ek_tablo_metin = "\n".join(ek_tablo) + "\n\n"

    # Envanterde '### Envanterin tekli 2D parçaları' başlığının hemen önüne veya arkasına ekle
    # '### Envanterin tekli 2D parçaları' sonrasındaki tablonun bittiği yere ekleyelim
    # Tablo satırları '| `IKN-KURK` |' gibi biter, sonra '## Ses ve diğer görsel dışı ihtiyaçlar' gelir
    hedef_bolum = "## Ses ve diğer görsel dışı ihtiyaçlar"
    if hedef_bolum in icerik:
        yeni_icerik = icerik.replace(hedef_bolum, ek_tablo_metin + hedef_bolum)
        with open(ENVANTER_DOSYASI, "w", encoding="utf-8") as f:
            f.write(yeni_icerik)
        print(f"{ENVANTER_DOSYASI} güncellendi.")
    else:
        print("HATA: Hedef bölüm bulunamadı.")

if __name__ == "__main__":
    uret_prompt_dokumani()
    guncelle_envanter()
