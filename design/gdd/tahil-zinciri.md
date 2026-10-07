# EKO-04 — Tahıl, un ve ekmek

## Overview

Tarla ve bostanda mevcut erzak tarifine ek olarak Buğday hasadı seçilir. Değirmende mevcut öğütme tarifine ek olarak Un seçilir. Köy Fırını yalnız un ve yakacakla çalışır; ekmek mevcut `gida` erzak stokuna eklenir. Eski erzak/sebze yolu, avcılık, `ogutme` kimliği ve kayıtlar korunur; bu paket tüm eski gıda kaynaklarını kaldırmaz.

## Detailed Rules ve Formulas

Denge varsayımları: çalışan başına temel 3 buğday; 2 buğday → temel 2 un; 2 un + 1 odun → temel 4 erzak. Mevcut stat, moral/sağlık, uzmanlık, seviye ve danışman formülleri uygulanır. Fırın 2 çalışan yuvası, 8 odun + 6 taş, 2 gün inşa. Fırının girdisi yoksa odun da tüketilmez. Tarla/bostan kış duruşu korunur; değirmen/fırın stokla kışın çalışabilir.

`bugday` ve `un` ayrı ambar stoklarıdır; mevcut toplam kapasiteyi kullanır. Eski kayıt eksik yeni stokları sıfır okur. CSV korunur; yeni adlar kod uzantısında Türkçe fallback alır. Yeni HUD ikonları proje içinde çizilmiş SVG’lerdir. Yeni yapı için mevcut genel yapı görseli kullanılır, özel fırın modeli/animasyonu bu pakette yoktur.

## Dependencies

Uygulama: `src/koy/tahil_zinciri.gd`, katalog tarif erişim adaptörü, kaynak/HUD uzantıları ve fırın bilgi panelinde girdi metni. Ham katalog JSON’u ezilmez.

## Acceptance Criteria

Kontroller: gerçek gece üç aşamalı akış; eksik un ile üretim/odun tüketiminin durması; yeni kaynak/tarif JSON dönüşümü; eski tarif ve gıda kaydı korunumu; gerçek UI ile buğday/un seçimi ve HUD; native Vulkan görüntüsü dış çalışma klasöründe `work/eko04_tahil.png`.

Denge değerleri dış yapılandırma dosyasında tutulur: `data/koy/tahil_zinciri.json`.

## Edge Cases

Eksik girdiler stok tüketmeden durur. Eski kayıt kimlikleri ve stoklar korunur. Dolu ambar ve kullanılamayan yapı durumu ilgili model testlerinde doğrulanır; kapsam dışı görsel/gezgin tüccar davranışları tamamlanmış sayılmaz.
