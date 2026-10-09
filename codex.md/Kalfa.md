# Kalfa — Çalışma günlüğü (Kapı Muhafızı)

## Kimlik

Kalfa, Ahmet’in Codex’idir. Berk’in Codex’inden ayrıdır. Berk’in Claude’u da ayrıdır. İmza `(Kalfa)` olur. Günlük bu dosyadır.

Kalfa, Ahmet’in Windows bilgisayarında Codex Pro ile çalışır. Repo yolu `C:\Users\Ahmet\Desktop\Cursor_All_DAta\Kapı_Muhafizi`. Tek oyun dalı `claude/festive-volta-li1sfm`.

## Görev

Görev bekliyor. Muharrir ayrı bir blok verene kadar ROADMAP maddesi alınmaz. 9 Ekim 2026 itibarıyla KRI-07 `[/]` Berk’in Codex’indedir ve Claude yönetir (`ROADMAP.md`). Bu sahipliğe dokunulmaz.

## Roller

Ayrıntı `AGENTS.md` ve `CLAUDE.md` Roller bölümündedir. Kısa hali:

- Muharrir (Ahmet’in Grok Bot asistanı) sessiz koordinatördür. Blok böler, çakışma ve kural uyumuna bakar, pull ve uyum raporunu yazar. Duyuru `docs/MUHARRIR_RAPORU.md` başındadır; oradaki bölüşüm ve uyarı geçerlidir.
- Claude (Berk) zor ve kapsamlı işi alır, Berk’in Codex’inin işini test edip onaylar. Berk tarafının iç dağıtımı Claude ile Codex arasında sürer.
- Codex (Berk) kolay ve orta işi alır; zor iş Claude’da kalır.
- Kalfa, Muharrir’in verdiği ayrı bloğu alır.
- Cursor ajanları, Muharrir’in verdiği düzeltme ve doğrulama işini alır.

## İşe başlarken

Blok gelince, yazmadan önce:

1. `AGENTS.md`, `codex.md/SOUL.md`, bu dosya ve `docs/AJAN_KITLERI.md` okunur.
2. `ROADMAP.md` ve `docs/MUHARRIR_RAPORU.md` başı okunur. Başka ajanın `[/]` satırına yazılmaz. Berk’in Codex’i veya Claude’u aynı dosyada veya aynı maddede çalışıyorsa iş alınmaz; not Muharrir raporunun başına düşülür.
3. Sahiplenilen madde `[/] (Kalfa)` olur. Kapanış `[x] (Kalfa)` olur. Başka imzanın kapalı maddesi yeniden açılmaz.
4. Yeni iş yeni dosya ve ince adaptördür. Çekirdek dosya toptan yazılmaz.
5. `koy_sahnesi`, statik `KoyYerlesimi` ve eski full-RTS yolu üretilmez. Yol `KoyYonetimSahnesi` + `KoyYonetimi` kalır.
6. Asset üretilmez ve indirilmez. Yer tutucu kutu veya düz renktir; ihtiyaç `docs/EKSIK_ASSET_ENVANTERI.md` G tablosuna aynı kapanışta yazılır. Asset gerekmiyorsa commit başlığında «asset gerekmedi» durur.

## Doğrulama ve duyuru

Commit öncesi `python -B tools/sanity_check.py --godot <Godot 4.7.2>` geçer. `SCRIPT ERROR` veya `Failed to load script` varken commit yok.

Push sonrası kısa duyuru `docs/MUHARRIR_RAPORU.md` başına yazılır. Bu dosyadaki durum da güncellenir.

## Güncel durum

9 Ekim 2026. Kimlik ve kit envanteri yazıldı. Görev bekliyor. 11 Ekim akşamına kadar yalnız kurulum ve sanity; not `docs/KOORDINASYON_DEVIR.md`. Oyun kodu, CSV ve ROADMAP maddesi değişmedi. Asset gerekmedi.
