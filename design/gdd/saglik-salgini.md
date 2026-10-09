# KRI-01 — Veba ve Humma Bulaşma Motoru

**Durum:** Uygulandı (Codex başlattı, limit dolunca Claude tamamladı) · 9 Ekim 2026
**Dosya:** `src/koy/saglik_yoneticisi.gd` (`SaglikYoneticisi`)

## Amaç
Kapıdan kabul edilen hasta sığınmacının köye gizli bir bulaşma getirmesi; oyuncunun kabul kararının gecikmeli bedeli.

## Kurallar
- **Kaynak:** Kabulde Gelen bayrakları (`veba`, `humma`, CHR_002 dışı `hasta`) gizli `enfeksiyon` kaydı açar. Hikâye metni/hekimin sargısı enfeksiyon sayılmaz.
- **Kuluçka:** Kayıt gizli başlar; ilk gecede belirti (`hasta` bayrağı) açılır. Kartta yalnız açık belirti gösterilir.
- **Bulaşma:** Her gece, ortak *hazır* bina (ev veya iş yeri) paylaşanlar arasında; kaynak başına en çok **3 temas**, köy başına gece en çok **2 yeni vaka**. Risk: veba %30, humma %20. Aynı gece yeni hasta zincirleme kaynak olamaz.
- **RNG:** Yalnız mevcut yönetim RNG'si; enfeksiyon yoksa RNG çekilmez; kayıt/yükleme sonrası birebir aynı sonuç.
- **Hasar:** Ev iyileşmesinden sonra gece başına veba −12, humma −8 sağlık; ölüm mevcut tek ölüm taramasında.
- **İyileşme:** Süre sonunda (veba 6, humma 4 gün) doğal; ya da Şifahane boş kontenjanı + 2 erzak ile (yanık/kış hastalığıyla aynı kontenjan, ikinci Şifahane yok).
- **Hariç:** Zindandakiler ve kervan korumasındakiler temas etmez.
- **Kayıt:** `Koylu.enfeksiyon` ve yönetim `salgin_son_gece` optional; legacy/bozuk kayıt hastalık üretmez.

## KRI-02/03 için açık API
`enfekte()`, `iyilestir()`, `temas_edebilir()` (karantina buraya bağlanır), `tedavi()` (hekim yetkinliği buraya bağlanır).

## Doğrulama
`tests/unit/kvr/saglik_yoneticisi_test.gd`, `tests/oto/saglik_salgini_kontrol.tscn` (kapı → çadır → gece düğmesi → kart → kayıt). Asset gerekmedi.
