# Gemini (Antigravity) metin işleri

Kod tarafı hazırdır; metin gelene kadar oyun aşağıdaki "şu an" davranışıyla çalışır. Anahtarlar
`data/metin/metinler.csv` içine satır satır eklenir (dosya toptan ezilmez). Metin eklenince kod değişmez.

Ekleyen: Cursor, 15 Kasım 2026 (30 madde doğrulama turu).

| Madde | Eksik metin | Anahtar | Bağlandığı dosya | Şu an |
|---|---|---|---|---|
| ZAR-03, DEN-19 | Kaçışı gören tanığın köye taşıdığı tek satırlık dedikodu ("kapıdan kaçtı" haberi). Düz cümle, yer tutucu (`%s`) yok. | `dedikodu.kacis` | `src/kapi/tansiyon_kacis_akisi.gd` (`METIN_ANAHTARI`) | Anahtar tabloda; tanık varken dedikoduya bu satır yazılır. |
| ZAR-03 | Kapı karar satırında kaçış sözü (karar düğmesi yerine kişi kendisi gider). Tek kelime ya da kısa söz. | `arayuz.kapi.karar_kacti` | `src/kapi/tansiyon_kacis_akisi.gd` (`KARAR_ANAHTARI`) | Anahtar tabloda; karar satırı bu sözü kullanır. |
| ZAR-01 | Görünür zar sonucunun sözü: başarılı, başarısız, kilitli. | `ZAR_BASARILI`, `ZAR_BASARISIZ`, `ZAR_KILITLI` | `src/kapi/sorgu_zari.gd` (`SOZCUK_*`), panel: `src/arayuz/chr_diyalog_paneli.gd` (`ZarSonucu`; kilit `ZAR_KILITLI` ipucu) | Anahtarlar tabloda; sonuç satırı ve kilitli seçeneğin ipucu bu sözleri kullanır. |
| ZAR-04 | Zar öncesi değiştirici satırlarının adları (terazi adil/yoz, grup itibarı, kanıt, asker, yorgunluk, muhafız tecrübesi, kesildi). | `zar.degistirici.<tur>` | `src/kapi/zar_degistiricileri.gd` (`_satir`) | Anahtarlar tabloda; oyuncu satırı bu anahtardan gelir (`kesilme` `%d` ile). |
