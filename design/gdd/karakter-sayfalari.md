# Karakter sayfaları (CHR_001–030)

*Durum: Uygulandı (5 Ekim 2026, kullanıcı isteği). Kaynak: `karakterler/CHR_*.md` + `karakterler/OKU.md`. Ayrıştırıcı: `tools/icerik/karakter_sayfalari.py`. Modeller ve hareketler: `tools/model/meshy_uret.py` + `tools/model/chr_istemleri.py`.*

## Overview
Otuz adlı karakter, karakter sayfalarından otomatik olarak oyuna girer: ad, sınıf, en erken gece, kapıya varış
anlatısı (bekçinin gördüğü), açılış sözü ve üç dallı soru ağacı (yol, geçmiş, kanıt). Her birinin Meshy ile
üretilmiş 3D modeli, yürüyüşü ve dört hareketi var: bekleme, konuşma, kabulde şükran, rette tepki.

## Player Fantasy
Kapıdaki her yüzün bir hikâyesi, bir yalanı ve ele veren bir izi var: bileğindeki ip sıyrığı, torbadaki koku.

## Detailed Rules
1. `OKU.md` satırı → ad ve sınıf; `Tag_Array` → cinsiyet (model yoksa yedek model/portre seçimi).
2. `Spawn_Koşulu` "Tur > N" → `en_erken_gece = N`. Bar eşikleri (Güvenlik, Erzak, Moral…) oyunun barlarıyla eşleşmediği için alınmaz.
3. Varış anlatısı = `Persona_Maskesi` + `Görsel_Hata` (oyuncu izi görür, sorup sormamak ona kalır).
4. Açılış = Düğüm 00 NPC repliği. Soru ağacı: seçenek metni soru, hedef düğümün repliği cevap, hedefin seçenekleri takip sorusu. Tansiyon, ipucu ve bayrak koşulları yok sayılır; "Final_Ret" ve "Karar_Menusu" dallanmaz; NPC'siz düğüm koşullu yönlendirmesini izler.
5. Bu karakterlere en çok 6 soru sorulur (genel sınır 4).
6. Niyet: `Sadakat_Fraksiyonu` haramiler / ayaktakımı / divan ise **tehlikeli** (7 kişi). Karar etkileri (Halk, Soylular, Tüccarlar, Ordu):
   - Tehlikeli — kabul: sınıf katkısı + (−1, 0, 0, −2); ret: Ordu +1; rüşvet: (−1, 0, +1, −1); kışla: Ordu +2.
   - Masum — kabul: sınıf katkısı (asker Ordu +1, esnaf Tüccar +1, çiftçi Halk +1); ret: Halk −1; rüşvet: (−1, 0, +1, 0); kışla: (−1, 0, 0, +1).
7. Hareketler: kapıya varınca bekleme; cevap verirken cevabın uzunluğu kadar konuşma (1.5–5 s); kabulde şükran eğilmesi; retde tehlikeli öfkelenir, masum diz çöker. Klip yoksa prosedürel hareket (DurusDuzeltici) oynar; klip oynarken DurusDuzeltici susar.

8. **El eşyaları:** Meshy modelinde olmayan ya da yanlış yerde kalan yük (sayfadaki `Obje_2_Yük`) Godot'ta basit biçimlerle ele verilir (`src/dunya/el_esyasi.gd`, tablo `data/el_esyalari.json` ← `karakter_sayfalari.EL_ESYALARI`). Parmak kemiği olmadığı için tutma noktası mesh'ten ölçülen avuç ortasıdır; eşya kemiğin son pozunu (DurusDuzeltici sonrası) izler, asılı eşya yerçekimiyle sarkar ve el hızıyla sallanır, asa dik durur. Kredi harcamaz. Modelde zaten olan yük (CHR_008 sepet, CHR_011 sırt çuvalı, CHR_015 yaba) eklenmez.

## Formulas
- **Konuşma süresi:** `clamp(len(cevap) / 28, 1.5, 5.0)` saniye.
- **Meshy maliyeti:** karakter başına önizleme 5 + doku 10 + iskelet 5 + 4 hareket × 3 = 32 kredi.

## Edge Cases
- Sayfa yoksa (OKU.md'de var, dosya yok) karakter atlanır.
- Hareket klibi bu iskelette çözülmezse (izlerin < %80'i) alınmaz; prosedürel harekete düşülür.
- Model dosyası yoksa yedek model: kadın → `ciftci_kadin`, değilse sınıf modeli.

## Dependencies
Karakter kadrosu (karakter-kadrosu.md), Karar (7), Barlar (8), Sohbet ve karar arayüzü (18), DurusDuzeltici.

## Tuning Knobs
`karakter_sayfalari.py`: `NIYET`, `SINIF_KABUL`, `TEHLIKE`, `AZAMI_SORU`; `chr_istemleri.py`: `HAREKETLER`, `hareket_listesi()`.

## Open
- BÖLÜM 5 (gecikmeli sonuçlar, doğan karakterler, bayraklar) ve ipucu (Clue) nesneleri henüz bağlanmadı.
- `cursor/chr-001-sati-4019` dalındaki farklı CHR_001 (Satı) alınmadı; `OKU.md` ile uyumlu Hamza kullanıldı.

## Acceptance Criteria
- 30 karakter katalogda; her birinin açılışı, ≥3 kök sorusu, takip soruları, 6 soru sınırı ve 4 kararı var; tehlikeli sayısı 7; etki yönleri doğru. — `tests/unit/karakter_sayfalari/karakter_sayfalari_test.gd`
- Hareket klipleri iskelete oturur ve kapıda oynar. — `production/qa/evidence/karakter-sayfalari-1/`
- El eşyaları tablodaki her tür kurulur; eşya yürürken, konuşurken, eğilirken ve diz çökerken avuçta kalır. — aynı test + `production/qa/evidence/el-esyalari-1/`
