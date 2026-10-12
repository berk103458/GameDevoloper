# UI asset promptları 2 — bütün üretilebilir 2D envanter (Kalfa)

12 Ekim 2026. Her prompt tek resim içindir. Saydam parçalarda düz **#00FF00** yeşil zemin; gerçek alfa, kırpma ve 16px dış pay indirme sonrası hazırlanır. 64px ve daha küçük eski motor yuvalarında bu pay içerik alanını aşırı küçülttüğünden istisna satırda açıklanır. Nihai ölçüler model çıktısının kesin ölçüsü değildir. Raster PNG, SVG/font/glTF yerine uzantı değiştirerek kullanılamaz; mevcut yükleyiciye ince adaptör ayrı entegrasyon işidir.

Kaynak: docs/asset_envanteri/2026-10-12-kaynak-taramasi.md A–D/G/H; aktif kuyruk docs/EKSIK_ASSET_ENVANTERI.md 2D/3D bölümleri, ARY-05/SRM-18 ve karakterler/CHR_001…030.md. 3D model/iskelet klibi, ses ve font bu üretime dahil değildir. 2D prompt hazır olması teslim veya oyun entegrasyonu anlamına gelmez. Atıl/ileri parçalar açıkça işaretlidir; üretim önceliği etkin UI, sonra karakter/ikon, sonra isteğe bağlı kaynaktır.

**281 yeni tekli prompt.** Mevcut 57 UI slotu ayrı GEMINI_TEKLI_URETIM_PROMPTLARI.md kataloğudur, burada sayılmaz.

## Kaynak kimliği kapsamı

- ACL04-ARASAHNE: `assets/art/env/acilis_ulak.png`.
- ANI15-DUMAN: `assets/art/fx/fx_smoke_01.png`.
- ANI15-KIVILCIM: `assets/art/fx/fx_spark_01.png`.
- ANI15-SU: `assets/art/fx/fx_water_drop_01.png`.
- ARY01-*: `assets/art/textures/gece_kapisi/timber_albedo.png`, `assets/art/textures/gece_kapisi/paper_albedo.png`.
- ARY03-*: `assets/art/env/secim_bg.png`, `assets/art/env/koy_hud_bg.png`.
- ARY03-HARITA: `assets/art/env/harita_uc.png`.
- ARY04-YUKLEME-01: `assets/art/env/yukleme_01.png`.
- ARY04-YUKLEME-02: `assets/art/env/yukleme_02.png`.
- ARY04-YUKLEME-03: `assets/art/env/yukleme_03.png`.
- ARY04-YUKLEME-04: `assets/art/env/yukleme_04.png`.
- ARY04-YUKLEME-05: `assets/art/env/yukleme_05.png`.
- ARY04-YUKLEME-06: `assets/art/env/yukleme_06.png`.
- ARY04-YUKLEME-07: `assets/art/env/yukleme_07.png`.
- ARY04-YUKLEME-08: `assets/art/env/yukleme_08.png`.
- CAS-DIVAN: `assets/art/ui/divan_kart.png`.
- DYL02-AYRINTI-*: `assets/art/inspect/carik.png`, `assets/art/inspect/el.png`, `assets/art/inspect/yara.png`, `assets/art/inspect/yanik.png`.
- DYL07-OCAK: `assets/art/env/ocak_arasahne.png`.
- ENV-KAPI: `assets/art/env/env_gate_scene_bg.png`.
- ENV-KOY-2D: `assets/art/env/env_village_bg.png`.
- ENV-MENU: `assets/art/env/env_menu_bg.png`.
- HAR-HARITA: `assets/art/env/harita_uc.png`.
- HAR-SAVAS: `assets/art/icons/icon_savunma_okcu_64.png`, `assets/art/icons/icon_savunma_mizrakli_64.png`.
- HAR01-HARITA: `assets/art/env/harita_uc.png`, `assets/art/icons/icon_map_hisar.png`, `assets/art/icons/icon_map_yol.png`, `assets/art/icons/icon_map_tekfur.png`, `assets/art/icons/icon_map_goc.png`.
- HAR03-HEYET: `assets/art/icons/icon_stok_heyet.png`.
- HAR06-IKON: `assets/art/icons/icon_stok_gozcu_kulesi.png`.
- HAR09-GUVERCIN: `assets/art/cards/guvercin.png`.
- HAR09-ULAK: `assets/art/cards/ulak.png`.
- HEYBE-11: `assets/art/icons/icon_esya_akce_64.png`, `assets/art/icons/icon_esya_arpa_64.png`, `assets/art/icons/icon_esya_tohum_64.png`, `assets/art/icons/icon_esya_ekmek_64.png`, `assets/art/icons/icon_esya_tuz_64.png`, `assets/art/icons/icon_esya_kumas_64.png`, `assets/art/icons/icon_esya_bakir_64.png`, `assets/art/icons/icon_esya_ok_64.png`, `assets/art/icons/icon_esya_hancer_64.png`, `assets/art/icons/icon_esya_ilac_64.png`, `assets/art/icons/icon_esya_yuzuk_64.png`.
- IKN-BAR: `assets/art/ui/ui_bar_segment_full.png`, `assets/art/ui/ui_bar_segment_empty.png`, `assets/art/ui/ui_bar_segment_cracked_01.png`, `assets/art/ui/ui_bar_segment_cracked_02.png`.
- IKN-KESE-BOS: `assets/art/ui/icon_bribe_pouch_empty_48.png`.
- IKN-KURK: `assets/ui/koy/gece_kapisi/kurk.png`.
- IKN-MESALE-2D: `assets/art/fx/fx_torch_village_01.png`, `assets/art/fx/fx_torchlight_patch_village_01.png`.
- IKN-UYARI: `assets/arayuz/ikonlar/uyari_isci_yok.png`, `assets/arayuz/ikonlar/uyari_hammadde_yok.png`, `assets/arayuz/ikonlar/uyari_ambar_dolu.png`.
- IKN-YAPI: `assets/ui/koy/gece_kapisi/firin.png`, `assets/ui/koy/gece_kapisi/degirmen.png`, `assets/ui/koy/gece_kapisi/sifahane.png`, `assets/ui/koy/gece_kapisi/ahir.png`, `assets/ui/koy/gece_kapisi/agil.png`, `assets/ui/koy/gece_kapisi/demirhane.png`, `assets/ui/koy/gece_kapisi/kislasi.png`, `assets/ui/koy/gece_kapisi/maden.png`, `assets/ui/koy/gece_kapisi/ocak.png`.
- KAPI-DEMIR: `assets/art/textures/gece_kapisi/iron_albedo.png`.
- KAR-TEKFUR-ASKER: `assets/art/char/crowd_tekfur_spear_01_far.png`.
- KOY-FIGUR-2D: `assets/art/char/char_miraen_idle_village.png`, `assets/art/char/char_sorhan_idle_village.png`, `assets/art/char/char_thessra_idle_village.png`, `assets/art/char/char_karaca_usta_idle_village.png`, `assets/art/char/char_aydogdu_idle_village.png`, `assets/art/char/char_saruca_hatun_idle_village.png`, `assets/art/char/char_soldier_01_idle_village.png`, `assets/art/char/char_farmer_01_idle_village.png`, `assets/art/char/char_farmer_02_idle_village.png`, `assets/art/char/char_craftsman_01_idle_village.png`.
- KRI-HASTA: `assets/art/fx/portrait_symptom_ates.png`, `assets/art/fx/portrait_symptom_irin.png`, `assets/art/fx/portrait_symptom_oksuruk.png`.
- KRI03-ILAC: `assets/art/icons/icon_stok_ilac_stok.png`.
- LOGO: `assets/art/ui/logo_kapi_muhafizi.png`, `assets/ui/atmosfer/gece_kapisi/app_icon.png`.
- MEV-AFET: `assets/art/textures/gece_kapisi/flood_water_albedo.png`, `assets/art/textures/gece_kapisi/burnt_ground_albedo.png`.
- MEV-HUD: `assets/ui/koy/gece_kapisi/mevsim_ilkbahar.png`, `assets/ui/koy/gece_kapisi/mevsim_yaz.png`, `assets/ui/koy/gece_kapisi/mevsim_sonbahar.png`, `assets/ui/koy/gece_kapisi/mevsim_kis.png`.
- MEV-SENLIK: `assets/art/decor/harvest_bunting.png`, `assets/art/decor/harvest_grain_wreath.png`, `assets/art/decor/harvest_cloth_banner.png`.
- MEV-ZEMIN: `assets/art/textures/gece_kapisi/snow_ground_albedo.png`, `assets/art/textures/gece_kapisi/snow_roof_albedo.png`.
- MEV04-KAR: `assets/art/fx/fx_snow_01.png`.
- MEV07-SU: `assets/art/icons/icon_stok_su.png`.
- MEV14-SAMAN: `assets/art/icons/icon_stok_saman.png`.
- NISAN-30: `assets/art/icons/icon_clue_chr_001_obje1.png`, `assets/art/icons/icon_clue_chr_002_obje1.png`, `assets/art/icons/icon_clue_chr_003_obje1.png`, `assets/art/icons/icon_clue_chr_004_obje1.png`, `assets/art/icons/icon_clue_chr_005_obje1.png`, `assets/art/icons/icon_clue_chr_006_obje1.png`, `assets/art/icons/icon_clue_chr_007_obje1.png`, `assets/art/icons/icon_clue_chr_008_obje1.png`, `assets/art/icons/icon_clue_chr_009_obje1.png`, `assets/art/icons/icon_clue_chr_010_obje1.png`, `assets/art/icons/icon_clue_chr_011_obje1.png`, `assets/art/icons/icon_clue_chr_012_obje1.png`, `assets/art/icons/icon_clue_chr_013_obje1.png`, `assets/art/icons/icon_clue_chr_014_obje1.png`, `assets/art/icons/icon_clue_chr_015_obje1.png`, `assets/art/icons/icon_clue_chr_016_obje1.png`, `assets/art/icons/icon_clue_chr_017_obje1.png`, `assets/art/icons/icon_clue_chr_018_obje1.png`, `assets/art/icons/icon_clue_chr_019_obje1.png`, `assets/art/icons/icon_clue_chr_020_obje1.png`, `assets/art/icons/icon_clue_chr_021_obje1.png`, `assets/art/icons/icon_clue_chr_022_obje1.png`, `assets/art/icons/icon_clue_chr_023_obje1.png`, `assets/art/icons/icon_clue_chr_024_obje1.png`, `assets/art/icons/icon_clue_chr_025_obje1.png`, `assets/art/icons/icon_clue_chr_026_obje1.png`, `assets/art/icons/icon_clue_chr_027_obje1.png`, `assets/art/icons/icon_clue_chr_028_obje1.png`, `assets/art/icons/icon_clue_chr_029_obje1.png`, `assets/art/icons/icon_clue_chr_030_obje1.png`.
- ODA-UI: `assets/art/icons/icon_oda_terazi.png`, `assets/art/icons/icon_oda_yetenek.png`, `assets/art/icons/icon_oda_yozlasma.png`, `assets/art/env/oda_epilog.png`.
- PALET: `assets/palette/palette_swatch.png`.
- PORTRE-ADLI-6: `assets/art/char/char_miraen_neutral_card.png`, `assets/art/char/char_sorhan_neutral_card.png`, `assets/art/char/char_thessra_neutral_card.png`, `assets/art/char/char_karaca_usta_neutral_card.png`, `assets/art/char/char_aydogdu_neutral_card.png`, `assets/art/char/char_saruca_hatun_neutral_card.png`.
- PORTRE-CHR-30: `assets/art/char/char_chr_001_neutral_card.png`, `assets/art/char/char_chr_002_neutral_card.png`, `assets/art/char/char_chr_003_neutral_card.png`, `assets/art/char/char_chr_004_neutral_card.png`, `assets/art/char/char_chr_005_neutral_card.png`, `assets/art/char/char_chr_006_neutral_card.png`, `assets/art/char/char_chr_007_neutral_card.png`, `assets/art/char/char_chr_008_neutral_card.png`, `assets/art/char/char_chr_009_neutral_card.png`, `assets/art/char/char_chr_010_neutral_card.png`, `assets/art/char/char_chr_011_neutral_card.png`, `assets/art/char/char_chr_012_neutral_card.png`, `assets/art/char/char_chr_013_neutral_card.png`, `assets/art/char/char_chr_014_neutral_card.png`, `assets/art/char/char_chr_015_neutral_card.png`, `assets/art/char/char_chr_016_neutral_card.png`, `assets/art/char/char_chr_017_neutral_card.png`, `assets/art/char/char_chr_018_neutral_card.png`, `assets/art/char/char_chr_019_neutral_card.png`, `assets/art/char/char_chr_020_neutral_card.png`, `assets/art/char/char_chr_021_neutral_card.png`, `assets/art/char/char_chr_022_neutral_card.png`, `assets/art/char/char_chr_023_neutral_card.png`, `assets/art/char/char_chr_024_neutral_card.png`, `assets/art/char/char_chr_025_neutral_card.png`, `assets/art/char/char_chr_026_neutral_card.png`, `assets/art/char/char_chr_027_neutral_card.png`, `assets/art/char/char_chr_028_neutral_card.png`, `assets/art/char/char_chr_029_neutral_card.png`, `assets/art/char/char_chr_030_neutral_card.png`, `assets/art/inspect/chr_001_trace.png`, `assets/art/inspect/chr_002_trace.png`, `assets/art/inspect/chr_003_trace.png`, `assets/art/inspect/chr_004_trace.png`, `assets/art/inspect/chr_005_trace.png`, `assets/art/inspect/chr_006_trace.png`, `assets/art/inspect/chr_007_trace.png`, `assets/art/inspect/chr_008_trace.png`, `assets/art/inspect/chr_009_trace.png`, `assets/art/inspect/chr_010_trace.png`, `assets/art/inspect/chr_011_trace.png`, `assets/art/inspect/chr_012_trace.png`, `assets/art/inspect/chr_013_trace.png`, `assets/art/inspect/chr_014_trace.png`, `assets/art/inspect/chr_015_trace.png`, `assets/art/inspect/chr_016_trace.png`, `assets/art/inspect/chr_017_trace.png`, `assets/art/inspect/chr_018_trace.png`, `assets/art/inspect/chr_019_trace.png`, `assets/art/inspect/chr_020_trace.png`, `assets/art/inspect/chr_021_trace.png`, `assets/art/inspect/chr_022_trace.png`, `assets/art/inspect/chr_023_trace.png`, `assets/art/inspect/chr_024_trace.png`, `assets/art/inspect/chr_025_trace.png`, `assets/art/inspect/chr_026_trace.png`, `assets/art/inspect/chr_027_trace.png`, `assets/art/inspect/chr_028_trace.png`, `assets/art/inspect/chr_029_trace.png`, `assets/art/inspect/chr_030_trace.png`.
- PORTRE-SINIF-4: `assets/art/char/char_soldier_01_neutral_card.png`, `assets/art/char/char_farmer_01_neutral_card.png`, `assets/art/char/char_farmer_02_neutral_card.png`, `assets/art/char/char_craftsman_01_neutral_card.png`.
- SAB03-ORTU: `assets/art/textures/gece_kapisi/cloth_cover_albedo.png`.
- SRM18-IKON: `assets/ui/atmosfer/gece_kapisi/app_icon.png`.
- SYS-PROLOG: `assets/art/env/prolog_01.png`, `assets/art/env/prolog_02.png`, `assets/art/env/prolog_03.png`, `assets/art/env/prolog_04.png`.
- SYS-SON: `assets/art/env/son_tekfur_haraccisi.png`, `assets/art/env/son_ertugrul_obasi.png`, `assets/art/env/son_beyin_uc_koyu.png`, `assets/art/env/son_ahi_kasabasi.png`, `assets/art/env/son_uc_tutundu.png`, `assets/art/env/son_epilog.png`.
- TEZ01-ORTU: `assets/art/textures/gece_kapisi/tez_agil_albedo.png`, `assets/art/textures/gece_kapisi/tez_degirmen_albedo.png`, `assets/art/textures/gece_kapisi/tez_demir_albedo.png`, `assets/art/textures/gece_kapisi/tez_bez_albedo.png`.
- TEZ07-TITREME: `assets/art/textures/gece_kapisi/shaky_line.png`.
- TUC-UI: `assets/art/icons/icon_trade_contract.png`, `assets/art/icons/icon_trade_price.png`, `assets/art/icons/icon_trade_caravan.png`.
- TUC03-BALTA: `assets/art/icons/icon_stok_balta.png`.
- TUC03-CIVI: `assets/art/icons/icon_stok_civi.png`.
- TUC03-TIRPAN: `assets/art/icons/icon_stok_tirpan.png`.
- TUC04-AFYON: `assets/art/icons/icon_stok_afyon.png`.
- TUC04-KECE: `assets/art/icons/icon_stok_kece.png`.
- TUC04-KUMAS: `assets/art/icons/icon_stok_kumas_stok.png`.
- TUC04-SARGI: `assets/art/icons/icon_stok_sargi.png`.
- TUC08-KALKAN: `assets/art/icons/icon_stok_kalkan.png`.
- TUC08-YAY: `assets/art/icons/icon_stok_yay.png`.
- TUC08-ZIRH: `assets/art/icons/icon_stok_zirh.png`.
- TUC11-IKSIR: `assets/art/icons/icon_stok_kacak_iksir.png`.
- TUC11-MUHUR: `assets/art/icons/icon_stok_yasak_muhur.png`.
- UI-IMLEC: `assets/art/ui/ui_cursor_arrow_32.png`, `assets/art/ui/ui_cursor_hand_32.png`.
- UI-KARAR-KABUL: `assets/art/ui/icon_decision_accept_48.png`.
- UI-KARAR-KISLA: `assets/art/ui/icon_decision_barracks_48.png`.
- UI-KARAR-RET: `assets/art/ui/icon_decision_reject_48.png`.
- UI-KARAR-RUSVET: `assets/art/ui/icon_decision_bribe_48.png`.
- UI-KESE-DOLU: `assets/art/ui/icon_bribe_pouch_full_48.png`.
- VFX-KAR: `assets/art/fx/fx_snow_01.png`.
- VFX-KIVILCIM: `assets/art/fx/fx_spark_01.png`.
- VFX-SIS: `assets/art/fx/fx_fog_noise.png`.
- VFX-YAGMUR: `assets/art/fx/fx_rain_streak_01.png`.
- YAP04-DEFTER: `assets/art/icons/icon_usta_defteri.png`.
- YAP06-ESYA: `assets/art/icons/icon_ozel_esya.png`.
- YSM01-IKON: `assets/art/icons/icon_yasam_aclik.png`, `assets/art/icons/icon_yasam_yorgunluk.png`, `assets/art/icons/icon_yasam_moral.png`.
- YUK-30: `assets/art/icons/icon_clue_chr_001_obje2.png`, `assets/art/icons/icon_clue_chr_002_obje2.png`, `assets/art/icons/icon_clue_chr_003_obje2.png`, `assets/art/icons/icon_clue_chr_004_obje2.png`, `assets/art/icons/icon_clue_chr_005_obje2.png`, `assets/art/icons/icon_clue_chr_006_obje2.png`, `assets/art/icons/icon_clue_chr_007_obje2.png`, `assets/art/icons/icon_clue_chr_008_obje2.png`, `assets/art/icons/icon_clue_chr_009_obje2.png`, `assets/art/icons/icon_clue_chr_010_obje2.png`, `assets/art/icons/icon_clue_chr_011_obje2.png`, `assets/art/icons/icon_clue_chr_012_obje2.png`, `assets/art/icons/icon_clue_chr_013_obje2.png`, `assets/art/icons/icon_clue_chr_014_obje2.png`, `assets/art/icons/icon_clue_chr_015_obje2.png`, `assets/art/icons/icon_clue_chr_016_obje2.png`, `assets/art/icons/icon_clue_chr_017_obje2.png`, `assets/art/icons/icon_clue_chr_018_obje2.png`, `assets/art/icons/icon_clue_chr_019_obje2.png`, `assets/art/icons/icon_clue_chr_020_obje2.png`, `assets/art/icons/icon_clue_chr_021_obje2.png`, `assets/art/icons/icon_clue_chr_022_obje2.png`, `assets/art/icons/icon_clue_chr_023_obje2.png`, `assets/art/icons/icon_clue_chr_024_obje2.png`, `assets/art/icons/icon_clue_chr_025_obje2.png`, `assets/art/icons/icon_clue_chr_026_obje2.png`, `assets/art/icons/icon_clue_chr_027_obje2.png`, `assets/art/icons/icon_clue_chr_028_obje2.png`, `assets/art/icons/icon_clue_chr_029_obje2.png`, `assets/art/icons/icon_clue_chr_030_obje2.png`.
- ZAR01-ZAR: `assets/art/ui/zar_d6.png`, `assets/art/ui/zar_d12.png`.

## 001 · assets/art/ui/icon_decision_accept_48.png

Kaynak: UI-KARAR-KABUL. Tür: ikon. Nihai ölçü: **48×48**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One compact icon depicting an open wooden gate. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 002 · assets/art/ui/icon_decision_reject_48.png

Kaynak: UI-KARAR-RET. Tür: ikon. Nihai ölçü: **48×48**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One compact icon depicting a closed barred wooden gate. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 003 · assets/art/ui/icon_decision_bribe_48.png

Kaynak: UI-KARAR-RUSVET. Tür: ikon. Nihai ölçü: **48×48**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One compact icon depicting a small tied coin pouch. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 004 · assets/art/ui/icon_decision_barracks_48.png

Kaynak: UI-KARAR-KISLA. Tür: ikon. Nihai ölçü: **48×48**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One compact icon depicting a plain round shield and short spear. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 005 · assets/art/ui/icon_bribe_pouch_full_48.png

Kaynak: UI-KESE-DOLU. Tür: ikon. Nihai ölçü: **48×48**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One full tied leather coin pouch. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 006 · assets/art/ui/icon_bribe_pouch_empty_48.png

Kaynak: IKN-KESE-BOS. Tür: ikon. Nihai ölçü: **48×48**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One visibly empty collapsed leather pouch. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 007 · assets/art/ui/ui_cursor_arrow_32.png

Kaynak: UI-IMLEC. Tür: ikon. Nihai ölçü: **32×32**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

32px hedefte 16px pay mümkün değil: büyük kaynak hazırlanır, final imleçte 2px pay/hotspot elle ayarlanır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple ivory arrow cursor pointing toward the upper-left. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 008 · assets/art/ui/ui_cursor_hand_32.png

Kaynak: UI-IMLEC. Tür: ikon. Nihai ölçü: **32×32**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

32px finalde 2px pay; hotspot ayrıca ayarlanır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One ivory pointing-hand cursor, index finger extended. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 009 · assets/art/env/env_menu_bg.png

Kaynak: ENV-MENU. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. A quiet closed frontier gate at night with a small open ceramic oil lamp and a naturally dark left menu area. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 010 · assets/art/env/env_gate_scene_bg.png

Kaynak: ENV-KAPI. Tür: arka plan. Nihai ölçü: **1140×1000**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. An empty guard-side gate threshold, dark calm central visitor area and one open ceramic oil lamp at the right; no people. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 011 · assets/art/env/env_village_bg.png

Kaynak: ENV-KOY-2D. Tür: arka plan. Nihai ölçü: **1920×1000**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. A small mud-brick frontier village and market awnings at night, quiet foreground; no people. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 012 · assets/art/char/char_miraen_neutral_card.png

Kaynak: PORTRE-ADLI-6. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up character portrait. Miraen, a Georgian former cavalryman in his forties: lean weathered face, short dark beard, tall felt cap whose LONG TAIL falls down behind his head and back (his signature shape, it must stick out of the silhouette), worn wool kaftan wrapped and belted, a BROKEN curved sabre scabbard - empty, snapped short, no blade - slung so it shows at his side/over the shoulder. Quiet neutral pose; no portrait frame or writing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 013 · assets/art/char/char_miraen_idle_village.png

Kaynak: KOY-FIGUR-2D. Tür: ikon. Nihai ölçü: **56×120**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl 2D köy yolu; mevcut 3D sahneye bağlanmaz. Finalde 4px pay; 16px içerik alanını aşırı küçültür.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One full-body stationary villager illustration. Miraen, a Georgian former cavalryman in his forties: lean weathered face, short dark beard, tall felt cap whose LONG TAIL falls down behind his head and back (his signature shape, it must stick out of the silhouette), worn wool kaftan wrapped and belted, a BROKEN curved sabre scabbard - empty, snapped short, no blade - slung so it shows at his side/over the shoulder. Clear small-scale silhouette, no scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 014 · assets/art/char/char_sorhan_neutral_card.png

Kaynak: PORTRE-ADLI-6. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up character portrait. Sorhan, a Kipchak horse trader, middle-aged: broad face, wide cheekbones, drooping moustache, felt cap, a COILED HORSE HALTER ROPE hanging over one shoulder (his signature shape), a tied cloth bundle on his back rising above the other shoulder, plain wool kaftan. Quiet neutral pose; no portrait frame or writing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 015 · assets/art/char/char_sorhan_idle_village.png

Kaynak: KOY-FIGUR-2D. Tür: ikon. Nihai ölçü: **56×120**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl 2D köy yolu; mevcut 3D sahneye bağlanmaz. Finalde 4px pay; 16px içerik alanını aşırı küçültür.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One full-body stationary villager illustration. Sorhan, a Kipchak horse trader, middle-aged: broad face, wide cheekbones, drooping moustache, felt cap, a COILED HORSE HALTER ROPE hanging over one shoulder (his signature shape), a tied cloth bundle on his back rising above the other shoulder, plain wool kaftan. Clear small-scale silhouette, no scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 016 · assets/art/char/char_thessra_neutral_card.png

Kaynak: PORTRE-ADLI-6. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up character portrait. Thessra, a young Greek woman from Trebizond, about eighteen, a healer's daughter: narrow tired face, a LONG HEADSCARF whose long tail hangs down past one shoulder (her signature shape), plain linen dress under a wool overdress, holding a SMALL PLAIN WOODEN BOX (no markings) against her chest with both hands. Quiet neutral pose; no portrait frame or writing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 017 · assets/art/char/char_thessra_idle_village.png

Kaynak: KOY-FIGUR-2D. Tür: ikon. Nihai ölçü: **56×120**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl 2D köy yolu; mevcut 3D sahneye bağlanmaz. Finalde 4px pay; 16px içerik alanını aşırı küçültür.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One full-body stationary villager illustration. Thessra, a young Greek woman from Trebizond, about eighteen, a healer's daughter: narrow tired face, a LONG HEADSCARF whose long tail hangs down past one shoulder (her signature shape), plain linen dress under a wool overdress, holding a SMALL PLAIN WOODEN BOX (no markings) against her chest with both hands. Clear small-scale silhouette, no scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 018 · assets/art/char/char_karaca_usta_neutral_card.png

Kaynak: PORTRE-ADLI-6. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up character portrait. Karaca Usta, an older Ahi master tanner from Kayseri: grey short beard, felt cap, a ROLLED ANIMAL HIDE tied horizontally across his back so it rises above both shoulders, wool kaftan, and the Ahi guild SASH (sed): a wide cloth sash tied over the leather belt with a knot whose two ENDS STICK OUT sideways beyond the body outline. Frame slightly lower than usual so the sash knot at the waist is visible. Quiet neutral pose; no portrait frame or writing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 019 · assets/art/char/char_karaca_usta_idle_village.png

Kaynak: KOY-FIGUR-2D. Tür: ikon. Nihai ölçü: **56×120**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl 2D köy yolu; mevcut 3D sahneye bağlanmaz. Finalde 4px pay; 16px içerik alanını aşırı küçültür.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One full-body stationary villager illustration. Karaca Usta, an older Ahi master tanner from Kayseri: grey short beard, felt cap, a ROLLED ANIMAL HIDE tied horizontally across his back so it rises above both shoulders, wool kaftan, and the Ahi guild SASH (sed): a wide cloth sash tied over the leather belt with a knot whose two ENDS STICK OUT sideways beyond the body outline. Frame slightly lower than usual so the sash knot at the waist is visible. Clear small-scale silhouette, no scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 020 · assets/art/char/char_aydogdu_neutral_card.png

Kaynak: PORTRE-ADLI-6. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up character portrait. Aydogdu, a young Turkmen archer: thin moustache, wool hood, one forearm wrapped in a pale cloth BANDAGE (that hand raised near the chest so it is visible), a felt cloak draped over ONE shoulder only, a recurved composite BOW and a QUIVER of arrows on his back with the bow tip and arrow ends rising above the shoulder. Quiet neutral pose; no portrait frame or writing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 021 · assets/art/char/char_aydogdu_idle_village.png

Kaynak: KOY-FIGUR-2D. Tür: ikon. Nihai ölçü: **56×120**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl 2D köy yolu; mevcut 3D sahneye bağlanmaz. Finalde 4px pay; 16px içerik alanını aşırı küçültür.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One full-body stationary villager illustration. Aydogdu, a young Turkmen archer: thin moustache, wool hood, one forearm wrapped in a pale cloth BANDAGE (that hand raised near the chest so it is visible), a felt cloak draped over ONE shoulder only, a recurved composite BOW and a QUIVER of arrows on his back with the bow tip and arrow ends rising above the shoulder. Clear small-scale silhouette, no scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 022 · assets/art/char/char_saruca_hatun_neutral_card.png

Kaynak: PORTRE-ADLI-6. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up character portrait. Saruca Hatun, a widowed farm woman in her fifties: lined face, a LARGE TRIANGULAR HEADSCARF tied under her chin (her signature shape), plain wool dress, a coarse cloth GRAIN SACK tied with rope held against her shoulder and chest. Quiet neutral pose; no portrait frame or writing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 023 · assets/art/char/char_saruca_hatun_idle_village.png

Kaynak: KOY-FIGUR-2D. Tür: ikon. Nihai ölçü: **56×120**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl 2D köy yolu; mevcut 3D sahneye bağlanmaz. Finalde 4px pay; 16px içerik alanını aşırı küçültür.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One full-body stationary villager illustration. Saruca Hatun, a widowed farm woman in her fifties: lined face, a LARGE TRIANGULAR HEADSCARF tied under her chin (her signature shape), plain wool dress, a coarse cloth GRAIN SACK tied with rope held against her shoulder and chest. Clear small-scale silhouette, no scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 024 · assets/art/char/char_soldier_01_neutral_card.png

Kaynak: PORTRE-SINIF-4. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up character portrait. An ordinary frontier foot soldier: padded quilted kaftan as his only armour, a plain conical iron cap or wool hood, a long spear held upright over the right shoulder with the spearhead above his head, the edge of a round wooden shield at his left side. Quiet neutral pose; no portrait frame or writing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 025 · assets/art/char/char_soldier_01_idle_village.png

Kaynak: KOY-FIGUR-2D. Tür: ikon. Nihai ölçü: **56×120**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl 2D köy yolu; mevcut 3D sahneye bağlanmaz. Finalde 4px pay; 16px içerik alanını aşırı küçültür.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One full-body stationary villager illustration. An ordinary frontier foot soldier: padded quilted kaftan as his only armour, a plain conical iron cap or wool hood, a long spear held upright over the right shoulder with the spearhead above his head, the edge of a round wooden shield at his left side. Clear small-scale silhouette, no scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 026 · assets/art/char/char_farmer_01_neutral_card.png

Kaynak: PORTRE-SINIF-4. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up character portrait. A male farmer: wool hood, plain tunic, a wooden carrying YOKE across both shoulders with ropes hanging down at each end - a wide horizontal shape. Quiet neutral pose; no portrait frame or writing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 027 · assets/art/char/char_farmer_01_idle_village.png

Kaynak: KOY-FIGUR-2D. Tür: ikon. Nihai ölçü: **56×120**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl 2D köy yolu; mevcut 3D sahneye bağlanmaz. Finalde 4px pay; 16px içerik alanını aşırı küçültür.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One full-body stationary villager illustration. A male farmer: wool hood, plain tunic, a wooden carrying YOKE across both shoulders with ropes hanging down at each end - a wide horizontal shape. Clear small-scale silhouette, no scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 028 · assets/art/char/char_farmer_02_neutral_card.png

Kaynak: PORTRE-SINIF-4. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up character portrait. A female farmer: plain headscarf, wool dress, a SICKLE held low in one hand at her side. Quiet neutral pose; no portrait frame or writing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 029 · assets/art/char/char_farmer_02_idle_village.png

Kaynak: KOY-FIGUR-2D. Tür: ikon. Nihai ölçü: **56×120**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl 2D köy yolu; mevcut 3D sahneye bağlanmaz. Finalde 4px pay; 16px içerik alanını aşırı küçültür.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One full-body stationary villager illustration. A female farmer: plain headscarf, wool dress, a SICKLE held low in one hand at her side. Clear small-scale silhouette, no scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 030 · assets/art/char/char_craftsman_01_neutral_card.png

Kaynak: PORTRE-SINIF-4. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up character portrait. A craftsman (not a guild master): wool hood, tunic, a leather strap across the chest to a tool bag on his hip with a small hammer handle sticking out, a tied bundle on his back rising above one shoulder. Quiet neutral pose; no portrait frame or writing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 031 · assets/art/char/char_craftsman_01_idle_village.png

Kaynak: KOY-FIGUR-2D. Tür: ikon. Nihai ölçü: **56×120**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl 2D köy yolu; mevcut 3D sahneye bağlanmaz. Finalde 4px pay; 16px içerik alanını aşırı küçültür.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One full-body stationary villager illustration. A craftsman (not a guild master): wool hood, tunic, a leather strap across the chest to a tool bag on his hip with a small hammer handle sticking out, a tied bundle on his back rising above one shoulder. Clear small-scale silhouette, no scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 032 · assets/art/char/char_chr_001_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_001.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Sun-browned tense man, old scar at the left temple, rigid shoulders; scorched camel-wool coat and coarse muddy clothing. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 033 · assets/art/icons/icon_clue_chr_001_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_001 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: blackened iron fire-striker case and leather tinder pouch. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 034 · assets/art/icons/icon_clue_chr_001_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_001 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: bundle of oak logs wrapped in wet reeds. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 035 · assets/art/char/char_chr_002_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_002.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Fearful young woman with swollen tearful eyelids and large eyes; faded cotton dress and torn muted headscarf. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 036 · assets/art/icons/icon_clue_chr_002_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_002 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: worn rawhide amulet cord. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 037 · assets/art/icons/icon_clue_chr_002_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_002 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: coarse hemp sack held closed. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 038 · assets/art/char/char_chr_003_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_003.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Weathered craftsman with a deeply lined brow and steady healer-like gaze; soot-stained buffalo-leather vest and protective cuffs. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 039 · assets/art/icons/icon_clue_chr_003_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_003 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: leather tinsmith apron and hide case. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 040 · assets/art/icons/icon_clue_chr_003_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_003 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: paired charcoal baskets and sewn buffalo-hide bellows. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 041 · assets/art/char/char_chr_004_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_004.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Stern man with pointed beard, furrowed brows and piercing eyes; wool caftan, fur lining and silver belt buckle. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 042 · assets/art/icons/icon_clue_chr_004_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_004 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: silver-inlaid bone whistle. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 043 · assets/art/icons/icon_clue_chr_004_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_004 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: bound sable and fox fur bundle. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 044 · assets/art/char/char_chr_005_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_005.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Dark pockmarked man with narrowed right eye and forward left shoulder; greasy sheepskin vest and torn wool clothing. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 045 · assets/art/icons/icon_clue_chr_005_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_005 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: dirty leather arm sling. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 046 · assets/art/icons/icon_clue_chr_005_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_005 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: old coarse haircloth saddlebag. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 047 · assets/art/char/char_chr_006_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_006.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Alert ragged villager with dirty blond hair, sooty cheeks and lowered head; tied torn linen shirt. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 048 · assets/art/icons/icon_clue_chr_006_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_006 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: perforated leather water flask. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 049 · assets/art/icons/icon_clue_chr_006_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_006 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: reed basket filled with straw. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 050 · assets/art/char/char_chr_007_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_007.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Pale full-faced official with sparse beard and disdainful eyes; muted green wool robe, clean wrapped headcloth and decorated belt. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 051 · assets/art/icons/icon_clue_chr_007_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_007 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: leather seal case. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 052 · assets/art/icons/icon_clue_chr_007_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_007 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: double-locked wooden court chest. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 053 · assets/art/char/char_chr_008_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_008.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Kind sorrowful elder with deeply wrinkled face and slight stoop; patched dark blue wool and dusty pale headcloth. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 054 · assets/art/icons/icon_clue_chr_008_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_008 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: copper mortar and pestle. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 055 · assets/art/icons/icon_clue_chr_008_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_008 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: large herb basket covered with cloth. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 056 · assets/art/char/char_chr_009_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_009.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Pockmarked sly man with a damaged right earlobe; patched colorful wool vest and crooked muted yellow headwrap. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 057 · assets/art/icons/icon_clue_chr_009_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_009 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: small wooden peddler drawer on a leather strap. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 058 · assets/art/icons/icon_clue_chr_009_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_009 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: paired henna saddlebags, without an animal. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 059 · assets/art/char/char_chr_010_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_010.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Round-faced shrewd mustached man; bright but worn wool vest, leather sash and period-appropriate wrapped headcloth, not a modern fez. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 060 · assets/art/icons/icon_clue_chr_010_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_010 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: leather bell and hide pouch. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 061 · assets/art/icons/icon_clue_chr_010_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_010 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: haircloth travel bag beside two small goat silhouettes. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 062 · assets/art/char/char_chr_011_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_011.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Sun-weathered frightened worker with hollow cheeks and strong shoulders; dusty sweat-stained cotton shirt. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 063 · assets/art/icons/icon_clue_chr_011_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_011 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: cracked wooden debt tally. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 064 · assets/art/icons/icon_clue_chr_011_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_011 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: heavy double-sewn sack. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 065 · assets/art/char/char_chr_012_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_012.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Sun-browned sorrowful protective woman, firm posture; faded cotton dress and worn pale headscarf. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 066 · assets/art/icons/icon_clue_chr_012_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_012 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: carved wooden pacifier on a wool cord. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 067 · assets/art/icons/icon_clue_chr_012_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_012 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: large vine basket. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 068 · assets/art/char/char_chr_013_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_013.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: White-bearded weathered elder with slightly bent back; worn camel-wool vest and dusty wool turban. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 069 · assets/art/icons/icon_clue_chr_013_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_013 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: perforated terracotta seed jar. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 070 · assets/art/icons/icon_clue_chr_013_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_013 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: paired leather saddlebags. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 071 · assets/art/char/char_chr_014_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_014.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Alert strong shepherd with thick brows and sun-browned face; sheepskin cloak and plain felt shepherd cap. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 072 · assets/art/icons/icon_clue_chr_014_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_014 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: leather collar and ram bell. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 073 · assets/art/icons/icon_clue_chr_014_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_014 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: heaped wool bundle beside two ram silhouettes. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 074 · assets/art/char/char_chr_015_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_015.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Determined angry sun-weathered woman with strong working arms; muddy cotton dress and muted dark green headwrap. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 075 · assets/art/icons/icon_clue_chr_015_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_015 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: iron irrigation hoe and lead plumb bob. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 076 · assets/art/icons/icon_clue_chr_015_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_015 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: basket of vegetable seedlings and two simple well fittings. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 077 · assets/art/char/char_chr_016_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_016.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Tired vineyard worker with cracked lips, low shoulders and weathered neck; old grape-stained shirt. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 078 · assets/art/icons/icon_clue_chr_016_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_016 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: notched wooden debt stick. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 079 · assets/art/icons/icon_clue_chr_016_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_016 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: bundle of wicker rods. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 080 · assets/art/char/char_chr_017_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_017.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Sleepless worried shepherd with wind-chapped cheeks and thick wrists; worn wool robe and felt over one shoulder. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 081 · assets/art/icons/icon_clue_chr_017_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_017 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: clogged sheep bell. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 082 · assets/art/icons/icon_clue_chr_017_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_017 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: felt saddlebag. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 083 · assets/art/char/char_chr_018_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_018.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Stooped field worker with sun-spotted forehead and soil-stained hands; muddy dress and patched vest. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 084 · assets/art/icons/icon_clue_chr_018_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_018 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: knotted waist cord. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 085 · assets/art/icons/icon_clue_chr_018_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_018 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: dry water gourd. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 086 · assets/art/char/char_chr_019_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_019.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Downcast worker with sparse beard and collapsed shoulders; sweaty shirt and muddy wool trousers. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 087 · assets/art/icons/icon_clue_chr_019_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_019 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: folded village note, blank paper. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 088 · assets/art/icons/icon_clue_chr_019_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_019 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: simple wooden water measure. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 089 · assets/art/char/char_chr_020_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_020.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Broad-shouldered harvest worker with flour-dusted beard and evasive eyes; straw-marked shirt. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 090 · assets/art/icons/icon_clue_chr_020_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_020 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: crumpled pawn paper, blank. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 091 · assets/art/icons/icon_clue_chr_020_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_020 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: empty sieve hoop. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 092 · assets/art/char/char_chr_021_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_021.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Sleepless hollow-cheeked villager with fallen posture; faded wool waistcoat. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 093 · assets/art/icons/icon_clue_chr_021_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_021 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: broken wooden attendance token. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 094 · assets/art/icons/icon_clue_chr_021_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_021 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: cloth-wrapped travel bundle. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 095 · assets/art/char/char_chr_022_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_022.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Thin-faced sleepless villager with uneven shoulders; old muted green waistcoat. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 096 · assets/art/icons/icon_clue_chr_022_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_022 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: wooden drum beater. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 097 · assets/art/icons/icon_clue_chr_022_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_022 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: broken brass ring wrapped in an herb bundle. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 098 · assets/art/char/char_chr_023_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_023.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Heavy-eyed exhausted scout with cracked lips and lowered head; dusty worn scouting jacket. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 099 · assets/art/icons/icon_clue_chr_023_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_023 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: empty period ceramic wine bottle. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 100 · assets/art/icons/icon_clue_chr_023_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_023 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: wooden pass tally. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 101 · assets/art/char/char_chr_024_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_024.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Ash-browed ashamed worker with inward shoulders; burn-marked shirt and short apron. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 102 · assets/art/icons/icon_clue_chr_024_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_024 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: cloth-wrapped curved sword. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 103 · assets/art/icons/icon_clue_chr_024_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_024 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: wooden granary tally. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 104 · assets/art/char/char_chr_025_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_025.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Dry-lipped tired mill worker with low shoulders; wet sweat-stained shirt and subtle flour traces. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 105 · assets/art/icons/icon_clue_chr_025_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_025 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: wooden water-carrying shoulder yoke. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 106 · assets/art/icons/icon_clue_chr_025_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_025 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: stitched headscarf, without a person. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 107 · assets/art/char/char_chr_026_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_026.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Downcast leatherworker with worn hands and evasive gaze; oil-stained apron. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 108 · assets/art/icons/icon_clue_chr_026_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_026 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: wooden saddle tally. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 109 · assets/art/icons/icon_clue_chr_026_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_026 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: leather stirrup strap. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 110 · assets/art/char/char_chr_027_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_027.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Weary clay worker with dusty brows; mud-stained shirt and clay traces. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 111 · assets/art/icons/icon_clue_chr_027_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_027 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: cracked clay jug base. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 112 · assets/art/icons/icon_clue_chr_027_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_027 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: wooden delivery tally. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 113 · assets/art/char/char_chr_028_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_028.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Weary textile worker with inward shoulders; faded outer robe over a tight inner vest. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 114 · assets/art/icons/icon_clue_chr_028_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_028 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: wooden cutting tally. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 115 · assets/art/icons/icon_clue_chr_028_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_028 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: two cloth roll ends wrapped in a waistcoat lining. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 116 · assets/art/char/char_chr_029_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_029.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Ash-browed embarrassed smith hiding the left hand; ember-marked shirt and short apron. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 117 · assets/art/icons/icon_clue_chr_029_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_029 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: wooden order tally. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 118 · assets/art/icons/icon_clue_chr_029_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_029 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: small nail pouch partly hidden by apron cloth. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 119 · assets/art/char/char_chr_030_neutral_card.png

Kaynak: PORTRE-CHR-30. Tür: portre. Nihai ölçü: **600×760**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: karakterler/CHR_030.md, Bölüm 3. Fiziksel el/ayak ipucu ayrı ayrıntı kartındadır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One shoulders-up portrait: Tired mill worker with flour on eyelashes and guarded hands; flour-covered shirt. No frame, props or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 4:5 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 120 · assets/art/icons/icon_clue_chr_030_obje1.png

Kaynak: NISAN-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_030 Obje_1; görünür yüz, yazısız. İpucu metni oyunda basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated clue-object illustration: wooden measuring tally. If paper is present, keep its surface blank. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 121 · assets/art/icons/icon_clue_chr_030_obje2.png

Kaynak: YUK-30. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Kaynak: CHR_030 Obje_2. Gizli içeriği varsayılan kapalı yük resminde ifşa etme.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated load illustration: small flour pouch sewn into a coat lining. No people or surrounding scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 122 · assets/art/icons/icon_esya_akce_64.png

Kaynak: HEYBE-11. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple item icon: silver coin. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 123 · assets/art/icons/icon_esya_arpa_64.png

Kaynak: HEYBE-11. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple item icon: barley grains. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 124 · assets/art/icons/icon_esya_tohum_64.png

Kaynak: HEYBE-11. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple item icon: seed pouch. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 125 · assets/art/icons/icon_esya_ekmek_64.png

Kaynak: HEYBE-11. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple item icon: small flatbread. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 126 · assets/art/icons/icon_esya_tuz_64.png

Kaynak: HEYBE-11. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple item icon: salt pile in a bowl. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 127 · assets/art/icons/icon_esya_kumas_64.png

Kaynak: HEYBE-11. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple item icon: folded woven cloth. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 128 · assets/art/icons/icon_esya_bakir_64.png

Kaynak: HEYBE-11. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple item icon: copper ingot. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 129 · assets/art/icons/icon_esya_ok_64.png

Kaynak: HEYBE-11. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple item icon: single arrow. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 130 · assets/art/icons/icon_esya_hancer_64.png

Kaynak: HEYBE-11. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple item icon: plain dagger. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 131 · assets/art/icons/icon_esya_ilac_64.png

Kaynak: HEYBE-11. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple item icon: small ceramic medicine bottle. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 132 · assets/art/icons/icon_esya_yuzuk_64.png

Kaynak: HEYBE-11. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple item icon: plain metal ring. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 133 · assets/ui/koy/gece_kapisi/kurk.png

Kaynak: IKN-KURK. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Mevcut tüketici SVG bekliyor; PNG için ileride ince adaptör gerekir, uzantı değiştirilmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One clear building or resource icon: folded fur pelt. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 134 · assets/ui/koy/gece_kapisi/firin.png

Kaynak: IKN-YAPI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Mevcut tüketici SVG bekliyor; PNG için ileride ince adaptör gerekir, uzantı değiştirilmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One clear building or resource icon: clay bread oven. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 135 · assets/ui/koy/gece_kapisi/degirmen.png

Kaynak: IKN-YAPI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Mevcut tüketici SVG bekliyor; PNG için ileride ince adaptör gerekir, uzantı değiştirilmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One clear building or resource icon: wooden mill wheel. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 136 · assets/ui/koy/gece_kapisi/sifahane.png

Kaynak: IKN-YAPI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Mevcut tüketici SVG bekliyor; PNG için ileride ince adaptör gerekir, uzantı değiştirilmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One clear building or resource icon: simple cot and herb mortar. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 137 · assets/ui/koy/gece_kapisi/ahir.png

Kaynak: IKN-YAPI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Mevcut tüketici SVG bekliyor; PNG için ileride ince adaptör gerekir, uzantı değiştirilmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One clear building or resource icon: stable doorway and hay. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 138 · assets/ui/koy/gece_kapisi/agil.png

Kaynak: IKN-YAPI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Mevcut tüketici SVG bekliyor; PNG için ileride ince adaptör gerekir, uzantı değiştirilmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One clear building or resource icon: stone sheep pen. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 139 · assets/ui/koy/gece_kapisi/demirhane.png

Kaynak: IKN-YAPI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Mevcut tüketici SVG bekliyor; PNG için ileride ince adaptör gerekir, uzantı değiştirilmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One clear building or resource icon: anvil and bellows. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 140 · assets/ui/koy/gece_kapisi/kislasi.png

Kaynak: IKN-YAPI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Mevcut tüketici SVG bekliyor; PNG için ileride ince adaptör gerekir, uzantı değiştirilmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One clear building or resource icon: guard hut and spear rack. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 141 · assets/ui/koy/gece_kapisi/maden.png

Kaynak: IKN-YAPI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Mevcut tüketici SVG bekliyor; PNG için ileride ince adaptör gerekir, uzantı değiştirilmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One clear building or resource icon: shallow mine entrance. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 142 · assets/ui/koy/gece_kapisi/ocak.png

Kaynak: IKN-YAPI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Mevcut tüketici SVG bekliyor; PNG için ileride ince adaptör gerekir, uzantı değiştirilmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One clear building or resource icon: small bloomery furnace. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 143 · assets/arayuz/ikonlar/uyari_isci_yok.png

Kaynak: IKN-UYARI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One warning icon showing empty work gloves; avoid written punctuation. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 144 · assets/arayuz/ikonlar/uyari_hammadde_yok.png

Kaynak: IKN-UYARI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One warning icon showing empty timber bin; avoid written punctuation. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 145 · assets/arayuz/ikonlar/uyari_ambar_dolu.png

Kaynak: IKN-UYARI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One warning icon showing grain overflowing a storage basket; avoid written punctuation. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 146 · assets/art/ui/ui_bar_segment_full.png

Kaynak: IKN-BAR. Tür: ikon. Nihai ölçü: **22×30**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl eski bar yuvası; final çok küçük olduğundan 16px pay uygulanmaz, büyük çalışma kaynağından 1px payla hazırlanır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One small vertical stone bar segment: solid intact slab. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 147 · assets/art/ui/ui_bar_segment_empty.png

Kaynak: IKN-BAR. Tür: ikon. Nihai ölçü: **22×30**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl eski bar yuvası; final çok küçük olduğundan 16px pay uygulanmaz, büyük çalışma kaynağından 1px payla hazırlanır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One small vertical stone bar segment: empty shallow stone recess. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 148 · assets/art/ui/ui_bar_segment_cracked_01.png

Kaynak: IKN-BAR. Tür: ikon. Nihai ölçü: **22×30**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl eski bar yuvası; final çok küçük olduğundan 16px pay uygulanmaz, büyük çalışma kaynağından 1px payla hazırlanır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One small vertical stone bar segment: slab with one hairline crack. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 149 · assets/art/ui/ui_bar_segment_cracked_02.png

Kaynak: IKN-BAR. Tür: ikon. Nihai ölçü: **22×30**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Atıl eski bar yuvası; final çok küçük olduğundan 16px pay uygulanmaz, büyük çalışma kaynağından 1px payla hazırlanır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One small vertical stone bar segment: slab with two wider cracks. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 150 · assets/art/fx/fx_torch_village_01.png

Kaynak: IKN-MESALE-2D. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Yumuşak ışıkta alfa elle onarılır; renk anahtarı tek başına premultiplied hale bırakmamalı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated effect element: one compact amber torch flame. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 151 · assets/art/fx/fx_torchlight_patch_village_01.png

Kaynak: IKN-MESALE-2D. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Yumuşak ışıkta alfa elle onarılır; renk anahtarı tek başına premultiplied hale bırakmamalı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated effect element: one soft amber illumination patch. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 152 · assets/art/char/crowd_tekfur_spear_01_far.png

Kaynak: KAR-TEKFUR-ASKER. Tür: ikon. Nihai ölçü: **420×80**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Yalnız 2D siluet; 3D asker modeli ihtiyacı açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One distant horizontal strip of small Byzantine frontier spear-bearing silhouettes, no faces. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 21:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 153 · assets/art/fx/fx_snow_01.png

Kaynak: VFX-KAR, MEV04-KAR. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Tek kare kaynak. Duman/sis yumuşak alfa editörde hazırlanır; modelden atlas ya da animasyon istenmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One effect source: one soft ivory snowflake. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 154 · assets/art/fx/fx_rain_streak_01.png

Kaynak: VFX-YAGMUR. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Tek kare kaynak. Duman/sis yumuşak alfa editörde hazırlanır; modelden atlas ya da animasyon istenmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One effect source: one slender pale rain streak. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 155 · assets/art/fx/fx_spark_01.png

Kaynak: VFX-KIVILCIM, ANI15-KIVILCIM. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Tek kare kaynak. Duman/sis yumuşak alfa editörde hazırlanır; modelden atlas ya da animasyon istenmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One effect source: one small warm amber ember. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 156 · assets/art/fx/fx_fog_noise.png

Kaynak: VFX-SIS. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Tek kare kaynak. Duman/sis yumuşak alfa editörde hazırlanır; modelden atlas ya da animasyon istenmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One effect source: one low-contrast grayscale fog noise sample. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 157 · assets/art/fx/fx_smoke_01.png

Kaynak: ANI15-DUMAN. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Tek kare kaynak. Duman/sis yumuşak alfa editörde hazırlanır; modelden atlas ya da animasyon istenmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One effect source: one soft gray smoke puff. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 158 · assets/art/fx/fx_water_drop_01.png

Kaynak: ANI15-SU. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Tek kare kaynak. Duman/sis yumuşak alfa editörde hazırlanır; modelden atlas ya da animasyon istenmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One effect source: one small pale cool water droplet. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 159 · assets/art/ui/logo_kapi_muhafizi.png

Kaynak: LOGO. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Başlık ve Türkçe oyun adı fontla ayrıca basılır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One original compact wordless gate-and-oil-lamp emblem. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 160 · assets/ui/atmosfer/gece_kapisi/app_icon.png

Kaynak: LOGO, SRM18-IKON. Tür: ikon. Nihai ölçü: **1024×1024**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

PNG kaynak; ICO sonradan hazırlanır. project.godot SRM-18 ayarı değiştirilmedi.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One original compact wooden gate and open ceramic oil lamp symbol, strong silhouette; not the Godot logo. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 161 · assets/palette/palette_swatch.png

Kaynak: PALET. Tür: ikon. Nihai ölçü: **1024×192**. Saydamlık: **opak RGB**.

İstisna: bu parça renk örneği levhasıdır. GPL/ASE rastır üretimi değildir; hex değerlerinden editörde hazırlanır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. Seven separate plain color patches using the specified night palette, arranged in one clean row without labels. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 21:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 162 · assets/art/icons/icon_trade_contract.png

Kaynak: TUC-UI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple trade icon: blank sealed folded contract. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 163 · assets/art/icons/icon_trade_price.png

Kaynak: TUC-UI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple trade icon: plain balance scale and coin. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 164 · assets/art/icons/icon_trade_caravan.png

Kaynak: TUC-UI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One simple trade icon: packed mule silhouette. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 165 · assets/ui/koy/gece_kapisi/mevsim_ilkbahar.png

Kaynak: MEV-HUD. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

SVG tüketicisine doğrudan verilmez; PNG adaptörü daha sonraki entegrasyonda.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One season icon: sprouting branch. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 166 · assets/ui/koy/gece_kapisi/mevsim_yaz.png

Kaynak: MEV-HUD. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

SVG tüketicisine doğrudan verilmez; PNG adaptörü daha sonraki entegrasyonda.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One season icon: sun over wheat. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 167 · assets/ui/koy/gece_kapisi/mevsim_sonbahar.png

Kaynak: MEV-HUD. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

SVG tüketicisine doğrudan verilmez; PNG adaptörü daha sonraki entegrasyonda.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One season icon: dry leaf. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 168 · assets/ui/koy/gece_kapisi/mevsim_kis.png

Kaynak: MEV-HUD. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

SVG tüketicisine doğrudan verilmez; PNG adaptörü daha sonraki entegrasyonda.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One season icon: simple snowflake. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 169 · assets/art/ui/divan_kart.png

Kaynak: CAS-DIVAN. Tür: ikon. Nihai ölçü: **768×1024**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

2D kart hazır prompt; 3D divan sahnesi ayrı açık ihtiyaç.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One blank rectangular evidence card, dark quiet center and small timber-and-iron corners. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 170 · assets/art/icons/icon_oda_terazi.png

Kaynak: ODA-UI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One concise room-menu icon: plain balance scale. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 171 · assets/art/icons/icon_oda_yetenek.png

Kaynak: ODA-UI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One concise room-menu icon: steady working hand. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 172 · assets/art/icons/icon_oda_yozlasma.png

Kaynak: ODA-UI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One concise room-menu icon: coin half concealed in a sleeve. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 173 · assets/art/env/oda_epilog.png

Kaynak: ODA-UI. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. A quiet empty guard room with a plain bed, small table and open ceramic oil lamp, subdued night atmosphere. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 174 · assets/art/env/harita_uc.png

Kaynak: HAR-HARITA, HAR01-HARITA, ARY03-HARITA. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.

Koordinatlar data/cevre_haritasi.json referansı; sayılar resme basılmaz, veri hizası Godot ekranında kontrol edilir.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. An unlabeled flat frontier terrain illustration; low-contrast regions near normalized positions fortress (0.28,0.58), mountain pass (0.22,0.20), eastern fortress (0.75,0.30), migration road (0.73,0.76). Do not draw nodes, labels or fixed settlement markers. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 175 · assets/art/icons/icon_map_hisar.png

Kaynak: HAR01-HARITA. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One map symbol: simple frontier gate fortress. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 176 · assets/art/icons/icon_map_yol.png

Kaynak: HAR01-HARITA. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One map symbol: winding road. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 177 · assets/art/icons/icon_map_tekfur.png

Kaynak: HAR01-HARITA. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One map symbol: Byzantine frontier fort. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 178 · assets/art/icons/icon_map_goc.png

Kaynak: HAR01-HARITA. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One map symbol: small travel bundle. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 179 · assets/art/icons/icon_savunma_okcu_64.png

Kaynak: HAR-SAVAS. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One deployment icon: a bow and arrow. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 180 · assets/art/icons/icon_savunma_mizrakli_64.png

Kaynak: HAR-SAVAS. Tür: ikon. Nihai ölçü: **64×64**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Eski küçük tüketici yuvası: ara kaynakta 16px alfa payı; nihai 48/64px ikonlarda 2px dış pay korunur. Daha büyük PNG yuvasına geçiş ayrı ince adaptör ister.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One deployment icon: a spear and round shield. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 181 · assets/art/fx/portrait_symptom_ates.png

Kaynak: KRI-HASTA. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Onaylı portreye ayrı katman; kişinin yüzü yeniden üretilmez, belirtiler veriyle hizalanır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated portrait detail overlay: small fever-flushed cheek detail, no whole face. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 182 · assets/art/fx/portrait_symptom_irin.png

Kaynak: KRI-HASTA. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Onaylı portreye ayrı katman; kişinin yüzü yeniden üretilmez, belirtiler veriyle hizalanır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated portrait detail overlay: a small covered inflamed skin patch, non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 183 · assets/art/fx/portrait_symptom_oksuruk.png

Kaynak: KRI-HASTA. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Onaylı portreye ayrı katman; kişinin yüzü yeniden üretilmez, belirtiler veriyle hizalanır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated portrait detail overlay: a small faint pale breath puff. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 184 · assets/art/env/son_tekfur_haraccisi.png

Kaynak: SYS-SON. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One atmospheric ending tableau: a frontier gate with tribute sacks on the road and a distant eastern fortress. No text or invented insignia. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 185 · assets/art/env/son_ertugrul_obasi.png

Kaynak: SYS-SON. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One atmospheric ending tableau: a frontier village beside a small nomadic camp and distant horses. No text or invented insignia. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 186 · assets/art/env/son_beyin_uc_koyu.png

Kaynak: SYS-SON. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One atmospheric ending tableau: a guarded frontier village with plain blank cloth pennants. No text or invented insignia. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 187 · assets/art/env/son_ahi_kasabasi.png

Kaynak: SYS-SON. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One atmospheric ending tableau: a small flourishing craft market with workshops and a plain balance scale. No text or invented insignia. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 188 · assets/art/env/son_uc_tutundu.png

Kaynak: SYS-SON. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One atmospheric ending tableau: a weathered independent frontier gate and modest warm village lights. No text or invented insignia. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 189 · assets/art/env/son_epilog.png

Kaynak: SYS-SON. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. A quiet frontier valley at dusk with a small distant village, space for runtime narration. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 190 · assets/art/env/prolog_01.png

Kaynak: SYS-PROLOG. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One atmospheric prologue tableau: a distant disrupted army camp in Anatolian hills, no graphic violence. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 191 · assets/art/env/prolog_02.png

Kaynak: SYS-PROLOG. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One atmospheric prologue tableau: an abandoned road with travel bundles and wagon tracks. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 192 · assets/art/env/prolog_03.png

Kaynak: SYS-PROLOG. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One atmospheric prologue tableau: a remote frontier wooden gate at twilight. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 193 · assets/art/env/prolog_04.png

Kaynak: SYS-PROLOG. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One atmospheric prologue tableau: a modest empty village square beside the gate. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 194 · assets/art/textures/gece_kapisi/snow_ground_albedo.png

Kaynak: MEV-ZEMIN. Tür: doku. Nihai ölçü: **1024×1024**. Saydamlık: **opak RGB**.

Yalnız renk/albedo. Normal, roughness ve PBR haritaları değildir; tekrar dikişi elle kontrol edilir. 3D geometri varsa açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One flat texture study of subtle pale snow cover over rough earth. Fill the square edge to edge with a flat material sample, evenly lit; no object, perspective, frame, directional shadow or lettering. Opposite edges should visually match; seamlessness will be checked and repaired after download. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 195 · assets/art/textures/gece_kapisi/snow_roof_albedo.png

Kaynak: MEV-ZEMIN. Tür: doku. Nihai ölçü: **1024×1024**. Saydamlık: **opak RGB**.

Yalnız renk/albedo. Normal, roughness ve PBR haritaları değildir; tekrar dikişi elle kontrol edilir. 3D geometri varsa açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One flat texture study of patchy snow over rough timber. Fill the square edge to edge with a flat material sample, evenly lit; no object, perspective, frame, directional shadow or lettering. Opposite edges should visually match; seamlessness will be checked and repaired after download. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 196 · assets/art/textures/gece_kapisi/flood_water_albedo.png

Kaynak: MEV-AFET. Tür: doku. Nihai ölçü: **1024×1024**. Saydamlık: **opak RGB**.

Yalnız renk/albedo. Normal, roughness ve PBR haritaları değildir; tekrar dikişi elle kontrol edilir. 3D geometri varsa açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One flat texture study of subdued muddy flood water ripples. Fill the square edge to edge with a flat material sample, evenly lit; no object, perspective, frame, directional shadow or lettering. Opposite edges should visually match; seamlessness will be checked and repaired after download. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 197 · assets/art/textures/gece_kapisi/burnt_ground_albedo.png

Kaynak: MEV-AFET. Tür: doku. Nihai ölçü: **1024×1024**. Saydamlık: **opak RGB**.

Yalnız renk/albedo. Normal, roughness ve PBR haritaları değildir; tekrar dikişi elle kontrol edilir. 3D geometri varsa açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One flat texture study of charred earth and ash. Fill the square edge to edge with a flat material sample, evenly lit; no object, perspective, frame, directional shadow or lettering. Opposite edges should visually match; seamlessness will be checked and repaired after download. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 198 · assets/art/textures/gece_kapisi/iron_albedo.png

Kaynak: KAPI-DEMIR. Tür: doku. Nihai ölçü: **1024×1024**. Saydamlık: **opak RGB**.

Yalnız renk/albedo. Normal, roughness ve PBR haritaları değildir; tekrar dikişi elle kontrol edilir. 3D geometri varsa açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One flat texture study of matte worn wrought iron without bolts. Fill the square edge to edge with a flat material sample, evenly lit; no object, perspective, frame, directional shadow or lettering. Opposite edges should visually match; seamlessness will be checked and repaired after download. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 199 · assets/art/textures/gece_kapisi/timber_albedo.png

Kaynak: ARY01-*. Tür: doku. Nihai ölçü: **1024×1024**. Saydamlık: **opak RGB**.

Yalnız renk/albedo. Normal, roughness ve PBR haritaları değildir; tekrar dikişi elle kontrol edilir. 3D geometri varsa açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One flat texture study of smoky straight timber grain. Fill the square edge to edge with a flat material sample, evenly lit; no object, perspective, frame, directional shadow or lettering. Opposite edges should visually match; seamlessness will be checked and repaired after download. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 200 · assets/art/textures/gece_kapisi/paper_albedo.png

Kaynak: ARY01-*. Tür: doku. Nihai ölçü: **1024×1024**. Saydamlık: **opak RGB**.

Yalnız renk/albedo. Normal, roughness ve PBR haritaları değildir; tekrar dikişi elle kontrol edilir. 3D geometri varsa açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One flat texture study of subdued fibrous parchment. Fill the square edge to edge with a flat material sample, evenly lit; no object, perspective, frame, directional shadow or lettering. Opposite edges should visually match; seamlessness will be checked and repaired after download. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 201 · assets/art/textures/gece_kapisi/cloth_cover_albedo.png

Kaynak: SAB03-ORTU. Tür: doku. Nihai ölçü: **1024×1024**. Saydamlık: **opak RGB**.

Yalnız renk/albedo. Normal, roughness ve PBR haritaları değildir; tekrar dikişi elle kontrol edilir. 3D geometri varsa açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One flat texture study of plain faded woven cloth. Fill the square edge to edge with a flat material sample, evenly lit; no object, perspective, frame, directional shadow or lettering. Opposite edges should visually match; seamlessness will be checked and repaired after download. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 202 · assets/art/textures/gece_kapisi/tez_agil_albedo.png

Kaynak: TEZ01-ORTU. Tür: doku. Nihai ölçü: **1024×1024**. Saydamlık: **opak RGB**.

Yalnız renk/albedo. Normal, roughness ve PBR haritaları değildir; tekrar dikişi elle kontrol edilir. 3D geometri varsa açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One flat texture study of dirty ivory wool cloth. Fill the square edge to edge with a flat material sample, evenly lit; no object, perspective, frame, directional shadow or lettering. Opposite edges should visually match; seamlessness will be checked and repaired after download. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 203 · assets/art/textures/gece_kapisi/tez_degirmen_albedo.png

Kaynak: TEZ01-ORTU. Tür: doku. Nihai ölçü: **1024×1024**. Saydamlık: **opak RGB**.

Yalnız renk/albedo. Normal, roughness ve PBR haritaları değildir; tekrar dikişi elle kontrol edilir. 3D geometri varsa açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One flat texture study of stone-gray flour-dusted cloth. Fill the square edge to edge with a flat material sample, evenly lit; no object, perspective, frame, directional shadow or lettering. Opposite edges should visually match; seamlessness will be checked and repaired after download. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 204 · assets/art/textures/gece_kapisi/tez_demir_albedo.png

Kaynak: TEZ01-ORTU. Tür: doku. Nihai ölçü: **1024×1024**. Saydamlık: **opak RGB**.

Yalnız renk/albedo. Normal, roughness ve PBR haritaları değildir; tekrar dikişi elle kontrol edilir. 3D geometri varsa açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One flat texture study of soot-dark cloth. Fill the square edge to edge with a flat material sample, evenly lit; no object, perspective, frame, directional shadow or lettering. Opposite edges should visually match; seamlessness will be checked and repaired after download. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 205 · assets/art/textures/gece_kapisi/tez_bez_albedo.png

Kaynak: TEZ01-ORTU. Tür: doku. Nihai ölçü: **1024×1024**. Saydamlık: **opak RGB**.

Yalnız renk/albedo. Normal, roughness ve PBR haritaları değildir; tekrar dikişi elle kontrol edilir. 3D geometri varsa açık kalır.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One flat texture study of plain raw linen cloth. Fill the square edge to edge with a flat material sample, evenly lit; no object, perspective, frame, directional shadow or lettering. Opposite edges should visually match; seamlessness will be checked and repaired after download. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 206 · assets/art/inspect/carik.png

Kaynak: DYL02-AYRINTI-*. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

2D inceleme kartı/doku; mevcut 3D ayrıntı geometrisini tamamlamaz.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One inspection illustration: a close detail of a patched rawhide sandal. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 207 · assets/art/inspect/el.png

Kaynak: DYL02-AYRINTI-*. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

2D inceleme kartı/doku; mevcut 3D ayrıntı geometrisini tamamlamaz.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One inspection illustration: a close detail of a calloused working hand. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 208 · assets/art/inspect/yara.png

Kaynak: DYL02-AYRINTI-*. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

2D inceleme kartı/doku; mevcut 3D ayrıntı geometrisini tamamlamaz.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One inspection illustration: a close detail of a cloth-wrapped wound, non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 209 · assets/art/inspect/yanik.png

Kaynak: DYL02-AYRINTI-*. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

2D inceleme kartı/doku; mevcut 3D ayrıntı geometrisini tamamlamaz.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One inspection illustration: a close detail of scorched clothing. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 210 · assets/art/textures/gece_kapisi/shaky_line.png

Kaynak: TEZ07-TITREME. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One single imperfect charcoal curved scratch stroke. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 211 · assets/art/decor/harvest_bunting.png

Kaynak: MEV-SENLIK. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

PNG süs; 3D bezeme gereksinimi varsa ayrıca açık.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One modest harvest-fair ornament: short plain cloth bunting. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 212 · assets/art/decor/harvest_grain_wreath.png

Kaynak: MEV-SENLIK. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

PNG süs; 3D bezeme gereksinimi varsa ayrıca açık.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One modest harvest-fair ornament: simple wheat wreath. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 213 · assets/art/decor/harvest_cloth_banner.png

Kaynak: MEV-SENLIK. Tür: ikon. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

PNG süs; 3D bezeme gereksinimi varsa ayrıca açık.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One modest harvest-fair ornament: small plain woven hanging cloth. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 214 · assets/art/icons/icon_stok_afyon.png

Kaynak: TUC04-AFYON. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: closed ceramic poppy medicine pot. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 215 · assets/art/icons/icon_stok_sargi.png

Kaynak: TUC04-SARGI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: folded linen bandage. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 216 · assets/art/icons/icon_stok_kece.png

Kaynak: TUC04-KECE. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: rolled wool felt. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 217 · assets/art/icons/icon_stok_kumas_stok.png

Kaynak: TUC04-KUMAS. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: woven cloth roll. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 218 · assets/art/icons/icon_stok_yasak_muhur.png

Kaynak: TUC11-MUHUR. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: blank wax seal. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 219 · assets/art/icons/icon_stok_kacak_iksir.png

Kaynak: TUC11-IKSIR. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: small sealed ceramic potion bottle. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 220 · assets/art/icons/icon_stok_zirh.png

Kaynak: TUC08-ZIRH. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: plain lamellar vest. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 221 · assets/art/icons/icon_stok_yay.png

Kaynak: TUC08-YAY. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: short wooden bow. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 222 · assets/art/icons/icon_stok_kalkan.png

Kaynak: TUC08-KALKAN. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: plain round shield. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 223 · assets/art/icons/icon_stok_civi.png

Kaynak: TUC03-CIVI. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: small cluster of iron nails. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 224 · assets/art/icons/icon_stok_tirpan.png

Kaynak: TUC03-TIRPAN. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: simple scythe. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 225 · assets/art/icons/icon_stok_balta.png

Kaynak: TUC03-BALTA. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: wood axe. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 226 · assets/art/icons/icon_stok_su.png

Kaynak: MEV07-SU. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: water jug. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 227 · assets/art/icons/icon_stok_saman.png

Kaynak: MEV14-SAMAN. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: bound hay bale. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 228 · assets/art/icons/icon_stok_ilac_stok.png

Kaynak: KRI03-ILAC. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: ceramic medicine bottle. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 229 · assets/art/icons/icon_stok_heyet.png

Kaynak: HAR03-HEYET. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: sealed tribute scroll. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 230 · assets/art/icons/icon_stok_gozcu_kulesi.png

Kaynak: HAR06-IKON. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One stock or menu icon: four-post wooden watchtower. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 231 · assets/art/cards/guvercin.png

Kaynak: HAR09-GUVERCIN. Tür: ikon. Nihai ölçü: **512×640**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

PNG çözümü; isteğe bağlı glTF alternatifi bu işte üretilmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One narrative card illustration: messenger pigeon with a sealed small note. No writing or scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 232 · assets/art/cards/ulak.png

Kaynak: HAR09-ULAK. Tür: ikon. Nihai ölçü: **512×640**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

PNG çözümü; isteğe bağlı glTF alternatifi bu işte üretilmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One narrative card illustration: dusty mounted courier silhouette holding a closed message tube. No writing or scene. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 3:4 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 233 · assets/art/env/acilis_ulak.png

Kaynak: ACL04-ARASAHNE. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One empty frontier gate at dusk with a small sealed message tube on the timber ledge; quiet narration space. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 234 · assets/art/ui/zar_d6.png

Kaynak: ZAR01-ZAR. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Yüz değerleri oyunda ayrı basılır; 3D alternatif opsiyonel, bu teslim 2D gövde promptudur.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One die body illustration: one plain ivory six-sided die with blank faces. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 235 · assets/art/ui/zar_d12.png

Kaynak: ZAR01-ZAR. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

Yüz değerleri oyunda ayrı basılır; 3D alternatif opsiyonel, bu teslim 2D gövde promptudur.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One die body illustration: one plain ivory twelve-sided die with blank faces. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 236 · assets/art/icons/icon_usta_defteri.png

Kaynak: YAP04-DEFTER. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One closed plain leather-bound notebook. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 237 · assets/art/icons/icon_ozel_esya.png

Kaynak: YAP06-ESYA. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

YAP-06 [ ] ve data/ozel_esyalar.json henüz yok: sekiz eşya adı uydurulmaz. Bu ortak yer tutucu ikon promptu hazır; gerçek türler madde uygulanınca ayrı kaynak tanımından açılmalı.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One blank small cloth-wrapped crafted keepsake. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 238 · assets/art/icons/icon_yasam_aclik.png

Kaynak: YSM01-IKON. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One life-status icon: empty wooden bowl. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 239 · assets/art/icons/icon_yasam_yorgunluk.png

Kaynak: YSM01-IKON. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One life-status icon: closed tired eyelid. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 240 · assets/art/icons/icon_yasam_moral.png

Kaynak: YSM01-IKON. Tür: ikon. Nihai ölçü: **256×256**. Saydamlık: **RGBA; dış zemin çıkarılacak**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One life-status icon: small warm hearth flame. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 241 · assets/art/env/secim_bg.png

Kaynak: ARY03-*. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One empty timber guard desk beside a night gate, broad low-detail dark center for runtime choices. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 242 · assets/art/env/koy_hud_bg.png

Kaynak: ARY03-*. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One subdued village perimeter at night, thin calm lower area and no people or controls. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 243 · assets/art/env/yukleme_01.png

Kaynak: ARY04-YUKLEME-01. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One quiet loading scene: a night road approaching the gate. Use only open ceramic oil lamps, no glass chimneys. Keep the lower fifth naturally calm. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 244 · assets/art/env/yukleme_02.png

Kaynak: ARY04-YUKLEME-02. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One quiet loading scene: an empty market at dusk. Use only open ceramic oil lamps, no glass chimneys. Keep the lower fifth naturally calm. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 245 · assets/art/env/yukleme_03.png

Kaynak: ARY04-YUKLEME-03. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One quiet loading scene: an empty small hearth room. Use only open ceramic oil lamps, no glass chimneys. Keep the lower fifth naturally calm. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 246 · assets/art/env/yukleme_04.png

Kaynak: ARY04-YUKLEME-04. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One quiet loading scene: quiet timber workshops at night. Use only open ceramic oil lamps, no glass chimneys. Keep the lower fifth naturally calm. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 247 · assets/art/env/yukleme_05.png

Kaynak: ARY04-YUKLEME-05. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One quiet loading scene: an empty stone well courtyard. Use only open ceramic oil lamps, no glass chimneys. Keep the lower fifth naturally calm. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 248 · assets/art/env/yukleme_06.png

Kaynak: ARY04-YUKLEME-06. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One quiet loading scene: misty hillside path. Use only open ceramic oil lamps, no glass chimneys. Keep the lower fifth naturally calm. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 249 · assets/art/env/yukleme_07.png

Kaynak: ARY04-YUKLEME-07. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One quiet loading scene: a modest grain barn at twilight. Use only open ceramic oil lamps, no glass chimneys. Keep the lower fifth naturally calm. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 250 · assets/art/env/yukleme_08.png

Kaynak: ARY04-YUKLEME-08. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One quiet loading scene: a village wall under light snowfall. Use only open ceramic oil lamps, no glass chimneys. Keep the lower fifth naturally calm. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 251 · assets/art/env/ocak_arasahne.png

Kaynak: DYL07-OCAK. Tür: arka plan. Nihai ölçü: **1920×1080**. Saydamlık: **opak RGB**.



```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One quiet empty cottage hearth at evening, low flames and worn timber, calm dark narration area. Continuous full-bleed image to all edges; no paper border, pasted UI rectangle or controls. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 16:9 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 252 · assets/art/inspect/chr_001_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_001 görsel ipucu: Sağ el başparmak tırnağı dibinde katranlaşmış kükürt sarılığı ve avuç içinde taze kav isi; parmak boğumlarında ip bağlama sürtünmesi izi. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing right thumb nail with muted sulfur-yellow residue, soot on the palm and rope-friction knuckles. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 253 · assets/art/inspect/chr_002_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_002 görsel ipucu: İki elinin ayasında ve bileklerinde su toplamış morumsu kabarcıklar, çatlaklar ve deliceotu özsuyunun bıraktığı asitli yanık lekeleri. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing palms and wrists with non-graphic purple irritation, blisters and plant-sap stains. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 254 · assets/art/inspect/chr_003_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_003 görsel ipucu: Sağ el başparmağı ile işaret parmağı arasında cerrah neşteri ve hassas mengene tutmaktan kemikleşmiş derin nasır çizgisi ile ön kolundaki akkor maden sıçramasından kalma hilal biçimli eski pota yanığı. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing right thumb-index web with a deep working callus and forearm with an old crescent-shaped furnace scar. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 255 · assets/art/inspect/chr_004_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_004 görsel ipucu: Sol elinin işaret ve orta parmağında yay kirişi çekmekten oluşmuş derin yara izi ve sağ avucunda ağır kılıç kabzası nasırı. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing left index and middle fingers with old bowstring scars and right palm with a sword-grip callus. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 256 · assets/art/inspect/chr_005_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_005 görsel ipucu: Sakat numarası yaptığı sol elinin parmakları diri ve güçlüdür; bileğinde sargının kenarından taşan karga pençesi dövmesi görünür. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a strong left hand and wrist with a small crow-claw tattoo visible at the edge of a linen wrap. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 257 · assets/art/inspect/chr_006_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_006 görsel ipucu: Dilsiz numarası yapmasına rağmen arkadan gelen ani nida sesine irkilerek dönmesi ve gömlek yakasındaki taze kara zift lekesi. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a linen shirt collar with a fresh dark tar stain; the startle response is gameplay, not a still image. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 258 · assets/art/inspect/chr_007_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_007 görsel ipucu: Kaftanının geniş yen astarında gizli para kesesi cepleri ve parmaklarındaki yüzük diplerinde taze kırmızı mühür mumu lekesi. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a broad kaftan sleeve lining with a hidden pouch pocket, fingers with red sealing-wax residue. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 259 · assets/art/inspect/chr_008_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_008 görsel ipucu: Sağ avucunun içinde şifalı ot özünden değil, kızgın demirle yara dağlamaktan sıçrayan cerahat yanığı izi ve parmak uçlarında ocak isi. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a right palm with an old non-graphic cautery scar and fingertips with hearth soot. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 260 · assets/art/inspect/chr_009_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_009 görsel ipucu: Sarı poşusunun altından taşan sağ kulağındaki ceza kesiği izi ve tırnak diplerindeki kına değil, gri engerek zehri tortusu. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a right ear partly beneath a yellow headcloth with an old notch scar and nails with gray residue. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 261 · assets/art/inspect/chr_010_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_010 görsel ipucu: Sol avucunun içinde tefeci mührü basmaktan kalma mor çivit mürekkebi lekesi ve kuşağında gizli altın bölmesi. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a left palm stained with purple indigo ink beside a sash with a discreet gold compartment. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 262 · assets/art/inspect/chr_011_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_011 görsel ipucu: Göğsündeki yırtık yakadan görünen sopa darbesi morluğu ve kollarında gece kaçarken dikenli çit tellerinden kalma taze yırtıklar. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a torn shirt neckline revealing a subdued bruise and sleeves with shallow non-graphic thorn scratches. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 263 · assets/art/inspect/chr_012_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_012 görsel ipucu: Elbisesinin göğüs kısmındaki taze süt sızıntısı lekesi ve küfeyi taşırken omzunu korumak için sardığı kundak bezi parçası. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a plain dress bodice with a faint milk stain beside a folded infant cloth shoulder pad. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 264 · assets/art/inspect/chr_013_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_013 görsel ipucu: Sağ paçasında taze kan sızmış bez sargı ve ağanın av köpeklerinin dişlediği taze diş yarası izi. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a right trouser leg with a slightly stained linen wrap, implied dog bite; no exposed injury or gore. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 265 · assets/art/inspect/chr_014_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_014 görsel ipucu: Çizmesinde dağ tozu süsü varken tırnak diplerinde sulak yayla kili kokusu ve omzunda koç zaptetmekten kalma taze boynuz çürüğü. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a dusty boot and fingernails with pale wet clay, beside a shoulder cloth with a muted pressure bruise. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 266 · assets/art/inspect/chr_015_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_015 görsel ipucu: Kollarında dere kireci ve harç yanıkları ile sağ bileğinde bent kapağını kanırtırken demir manivelanın bıraktığı derin sıyrık izi. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing forearms with chalky mortar stains and a right wrist with a non-graphic old lever abrasion. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 267 · assets/art/inspect/chr_016_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_016 görsel ipucu: Sol bileğinde taze ip yanığı ve gömlek yeninde kopmuş kenevir lifleri. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a left wrist with a shallow rope-friction mark beside torn hemp fibers at a shirt cuff. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 268 · assets/art/inspect/chr_017_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_017 görsel ipucu: Göğsündeki süt lekesi ve etek ucunda küçük bir çamur izi, koyun ayağından büyük. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a plain dress chest with a faint milk stain and hem with one broad mud mark. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 269 · assets/art/inspect/chr_018_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_018 görsel ipucu: Yen dikişinde sıkışmış iki tane bamya tohumu ve tırnak altında taze toprak değil, kuru tohum kabuğu. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a sleeve seam with two tiny okra seeds and nails with dry seed husks. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 270 · assets/art/inspect/chr_019_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_019 görsel ipucu: Paçası dizine kadar taze ark çamuru, toz değil; yeninde hâlâ ıslak su çizgisi. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a trouser cuff stained with fresh irrigation mud beside a sleeve with a wet tide line. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 271 · assets/art/inspect/chr_020_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_020 görsel ipucu: Sağ elinin mafsalı yarık ve gömlek yakasında şarap lekesi, harman tozu değil. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a right knuckle with a shallow non-graphic crack and shirt collar with a wine stain. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 272 · assets/art/inspect/chr_021_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_021 görsel ipucu: Sol bileğinde taze ip sıyrığı ve deriye gömülü kenevir lifi. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a left wrist with a shallow rope abrasion and a few caught hemp fibers. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 273 · assets/art/inspect/chr_022_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_022 görsel ipucu: Sol omzunda davul kayışının bıraktığı soluk çizgi ve kopuk toka deliği. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a left shoulder garment with a faded drum-strap pressure line and a broken buckle hole. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 274 · assets/art/inspect/chr_023_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_023 görsel ipucu: Sakalında ve çenesinde taze üzüm sırası lekesi. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a beard and chin with fresh muted grape-must stains. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 275 · assets/art/inspect/chr_024_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_024 görsel ipucu: Sol ön kolda eğri namlunun açtığı taze ince kesik. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a left forearm with a thin non-graphic curved abrasion; do not add any weapon. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 276 · assets/art/inspect/chr_025_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_025 görsel ipucu: Sol koltuk dikişinde kurumuş un ve ekmek kırıntısı. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a left underarm garment seam with dried flour and a small bread crumb. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 277 · assets/art/inspect/chr_026_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_026 görsel ipucu: Sağ bileğinde rehinci ipinin bıraktığı taze yanık halka. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a right wrist with a non-graphic rope-friction ring. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 278 · assets/art/inspect/chr_027_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_027 görsel ipucu: Sol baldırda yukarıdan aşağı inen ıslak kil çizgisi. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a left calf garment with a vertical streak of wet clay. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 279 · assets/art/inspect/chr_028_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_028 görsel ipucu: Yeleğin iç yüzünde, dışarıdan görünmeyen taze çivit lekesi. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing an open waistcoat lining with a hidden fresh indigo stain. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 280 · assets/art/inspect/chr_029_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_029 görsel ipucu: Sol başparmakta on taze çekiç çukuru ve kese ağzındaki isli dikiş. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a right thumb with small old hammer dents beside a pouch mouth with a sooty seam. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## 281 · assets/art/inspect/chr_030_trace.png

Kaynak: PORTRE-CHR-30. Tür: inceleme ayrıntısı. Nihai ölçü: **512×512**. Saydamlık: **RGBA; dış zemin çıkarılacak**.

CHR_030 görsel ipucu: Ölçen elin tırnağı altında beyaz un hilali. Statik görsel davranış/animasyon yerine geçmez.

```text
Create ONE actual image. Original hand-painted 2D game art for a 13th-century Anatolian frontier gatekeeper; matte smoky timber, worn iron, charcoal #10171C, wood #30251F, iron #58616A, amber #C88A43 and ivory #E6DDC6; restrained ink-and-gouache brushwork, readable silhouettes and quiet space. One isolated close-up inspection illustration showing a measuring hand with a small white flour crescent beneath the thumbnail. Keep the clue readable and non-graphic. Use uniform solid #00FF00 green outside the complete object for later masking; no green in the object, no green reflections, no shadow on the background. Leave clear space around the object. no text, no letters, no numbers, no checkerboard, no palette labels, no contact sheet, no 3D render. Use a 1:1 source canvas. If an approved style reference is attached, borrow only its palette and brushwork. Do not copy its scene or introduce its objects.
```

## Bilinçli sınırlar

YAP06-ESYA tek genel ikonla temsil edilir: henüz tanımlanmamış sekiz özel eşya için özgül üretim briefi verilmiş sayılmaz. ARY01-* font bölümü mevcut lisanslı fontlarla sürer; Gemini font üretmez. PALET GPL/ASE metinleri mevcut hex değerlerinden hazırlanır. PBR normal/roughness haritaları, gerçek dikişsiz tekrar ve yumuşak VFX alfa ayrı doğrulama gerektirir. Ses işleri ayrı ses kuyruğunda kalır; 2D prompt tamamlanınca ses tamamlandı denmez.
