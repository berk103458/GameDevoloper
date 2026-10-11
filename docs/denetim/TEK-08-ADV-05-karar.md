# TEK-08 / ADV-05 — karar (Kalfa)

11 Ekim 2026. ROADMAP 2 TEK-08, mevcut ADV-05 davranışını karar olarak korur; yeni bonus yoktur. KRI-10 tamamlanmış sistemdir.

Kenetlenme bonusu, gizli kuluçkadaki enfeksiyon dahil gerçek hastalık bitmeden verilmez. Oyuncu bonusun gelmemesinden dolaylı ipucu çıkarabilir; bu sonuç kabul edilir. Bonus almamak hastanın kimliğini veya hastalık nedenini bildirmez. Bu not, yeni bilgi paneli veya ikinci hastalık/bonus sistemi talimatı değildir.

Mevcut `src/koy/kriz_kenetlenmesi.gd` `_iyilesmis` tüm yerel yaşayan halkta `SaglikYoneticisi.hasta(k)` koşulunu okur. Belirtisiz enfeksiyon bu koşulda kalır. `krizler` yalnız açık belirtide salgın dönemi başlatır; gizli kişinin adı rapora taşınmaz. `bitir` yalnız iyileşmiş dönemi kapatır, kişi başına mevcut Sadakat/Refah tavanlarını ve bekleme süresini kullanır. `data/koy/kriz_kenetlenmesi.json` aynen korunur.

Kaynak: `docs/denetim/2026-10-10-claude-test-raporu.md`, ADV-05; `ROADMAP.md` KRI-10; `ROADMAP_2.md` TEK-08. Bu kararda bonus formülü kaynak diff'i **0**, oyun kaynak/veri dosyası değişikliği **0**. Asset gerekmedi.

Doğrulama: mevcut kriz kenetlenmesi birim ve gerçek UI testleri; sonuçlar tamamlanınca kaydedilecek. Önceki nihai tam sanity BUG-25 uygulamasında 342 PASS / 0 hata / 20 gece; sonraki merge 9 hedefli kontrolle doğrulandı. Bu belge oyun kaynaklarını değiştirmez.

Zorunlu ds yerel aynası bu bilgisayarda erişilemiyor; eşitlenemedi.

Sonuç: mevcut `kriz_kenetlenmesi_test.gd` ve `kriz_kenetlenmesi_kontrol.tscn` **2 PASS / 0 hata**. Kanıt `work/tek08-target`. `git diff f41e1b8 -- src data tools tests` boş; bonus formülü diff 0. Yeni tam koşu tekrarlanmadı: yalnız belge değişti, az önceki nihai 342/0/20 gece ve merge sonrası 9 hedefli kontrol kanıtı korunuyor.
