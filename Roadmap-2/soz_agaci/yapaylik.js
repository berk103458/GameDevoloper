// Yapaylık denetimi: konuşma metninde yazı dili ve model kalıplarını işaretler.
// Yalnız uyarı üretir; metni değiştirmez, karar vermez. Kurallar USLUP_REHBERI.md §7.
// Kullanım: node yapaylik.js [sahne.js]
(function (kok) {
  const KONUSMA = new Set(["karakter", "es", "sira", "muhafiz"]);
  const H = "\\p{L}";
  const kelime = (liste) => new RegExp("(?<!" + H + ")(" + liste.join("|") + ")" + H + "*", "iu");

  const DOLGU = new RegExp("(?<!" + H + ")(işte|hani|eh|neyse|bak|ya|şey|yahu|be)(?!" + H + ")", "iu");
  const GEREKCE = new RegExp("(?<!" + H + ")(çünkü|zira|bu yüzden|bu sebeple|o yüzden)(?!" + H + ")", "iu");
  const SOYUT = kelime(["umut", "kader", "özgürlü", "huzur", "yalnızlı", "hayat", "anlam"]);
  const MODERN = kelime(["aslında", "kesinlikle", "harika", "mükemmel", "inanılmaz", "problem", "stres", "travma", "sistem", "organize", "okey"]);
  const KARSITLIK = new RegExp("(?<!" + H + ")değil,\\s+" + H, "iu");
  const NE = new RegExp("(?<!" + H + ")ne(?!" + H + ")", "giu");
  const UCLU = new RegExp("(?:^|[.!?…] )" + H + "+, " + H + "+(?:, | ve )(?:ve )?" + H + "+[.!…]", "u");
  const KAPANIS = new RegExp("(?<!" + H + ")\\S*(versin|görsün|görür)(?!" + H + ")", "iu");
  const VECIZE = new RegExp("(?<!" + H + ")demek(ti|tir)(?!" + H + ")", "iu");
  const SUSMA = /sus(ar|uyor|tu|kun)/iu;

  const KURALLAR = {
    noktali_virgul: "Konuşmada noktalı virgül yazı dilidir.",
    karsitlik: "\"X değil, Y\" karşıtlığı vecize gibi durur. Önce şeyi söyle, düzeltmeyi sonra ekle.",
    vecize: "\"…demekti\" tanım cümlesi vecize gibi durur.",
    ne_ne: "\"ne… ne…\" dengeli kalıbı cilalı durur.",
    uclu_sira: "Üçlü sıralama liste ritmidir.",
    gerekce: "Karakter gerekçesini açıklıyor. İnsan niyetini çoğu zaman söylemez.",
    soyut: "Soyut kelime. Somut olanı söylet.",
    modern: "Modern söz.",
    kapanis: "Kapanış duası ya da vecizesi. Her sahne bir 'söz'le bitmez.",
    susma_sayisi: "Sahnede çok fazla susma notu.",
    tekduze_uzunluk: "Replik uzunlukları birbirine çok yakın; ritim tekdüze.",
    dolgu_az: "Konuşma işaretleri (işte, hani, eh, neyse…) çok az.",
    uzun_not: "Sahne notu 30 kelimeyi aşıyor.",
    uc_nokta: "Üç nokta çok sık.",
  };

  function metinler(sahne) {
    const out = [];
    for (const [d, dg] of Object.entries(sahne.dugumler)) {
      (dg.satirlar || []).forEach((s, i) => {
        out.push({ id: d + ".s" + i, dugum: d, k: s.k, m: s.m, tur: "satir", kosul: s.kosul });
        (s.varyant || []).forEach((v, j) => out.push({ id: d + ".s" + i + ".v" + j, dugum: d, k: s.k, m: v.m, tur: "varyant", kosul: v.kosul }));
      });
      (dg.secenekler || []).forEach((o, i) => {
        out.push({ id: d + ".o" + i, dugum: d, k: "muhafiz", m: o.metin, tur: "secenek", kosul: o.kosul });
        (o.tepki || []).forEach((t, j) => out.push({ id: d + ".o" + i + ".t" + j, dugum: d, k: t.k, m: t.m, tur: "tepki" }));
      });
    }
    const so = sahne.kurallar && sahne.kurallar.sabir_olayi;
    if (so) so.satirlar.forEach((s, i) => out.push({ id: "_sabir.s" + i, dugum: "_sabir", k: s.k, m: s.m, tur: "satir" }));
    return out;
  }

  const sozKismi = (m) => m.replace(/\([^)]*\)/g, " ").replace(/\s+/g, " ").trim();
  const kelimeSayisi = (m) => (sozKismi(m).match(new RegExp(H + "+", "gu")) || []).length;

  function satirDenetle(x, sonDugumMu, sonReplikMi) {
    const u = [];
    if (x.k === "anlati") {
      if (kelimeSayisi(x.m) > 30) u.push("uzun_not");
      return u;
    }
    if (!KONUSMA.has(x.k)) return u;
    const m = sozKismi(x.m);
    if (!m) return u;
    if (m.includes(";")) u.push("noktali_virgul");
    if (KARSITLIK.test(m)) u.push("karsitlik");
    if (VECIZE.test(m)) u.push("vecize");
    if (!m.includes("?") && (m.match(NE) || []).length >= 2) u.push("ne_ne");
    if (UCLU.test(m)) u.push("uclu_sira");
    if (GEREKCE.test(m)) u.push("gerekce");
    if (SOYUT.test(m)) u.push("soyut");
    if (MODERN.test(m)) u.push("modern");
    if (sonDugumMu && sonReplikMi && x.k === "karakter" && KAPANIS.test(m)) u.push("kapanis");
    return u;
  }

  function denetle(sahne) {
    const liste = metinler(sahne);
    const satirlar = {};
    for (const x of liste) {
      const dg = sahne.dugumler[x.dugum];
      let sonReplik = false;
      if (dg && dg.son && (x.tur === "satir" || x.tur === "varyant")) {
        const karakterSatirlari = dg.satirlar.map((s, i) => ({ s, i })).filter((y) => y.s.k === "karakter");
        const son = karakterSatirlari[karakterSatirlari.length - 1];
        sonReplik = !!son && x.id.startsWith(x.dugum + ".s" + son.i);
      }
      const u = satirDenetle(x, dg && dg.son, sonReplik);
      if (u.length) satirlar[x.id] = u;
    }

    const sahneUyari = [];
    const replik = liste.filter((x) => x.k === "karakter");
    const susma = liste.filter((x) => SUSMA.test(x.m)).length;
    if (susma > 3) sahneUyari.push({ kural: "susma_sayisi", deger: susma + " susma notu" });
    const uz = replik.map((x) => kelimeSayisi(x.m)).filter((n) => n > 0);
    if (uz.length > 4) {
      const ort = uz.reduce((a, b) => a + b, 0) / uz.length;
      const sapma = Math.sqrt(uz.reduce((a, b) => a + (b - ort) ** 2, 0) / uz.length);
      const cv = sapma / ort;
      if (cv < 0.4) sahneUyari.push({ kural: "tekduze_uzunluk", deger: "değişkenlik " + cv.toFixed(2) });
    }
    const dolguOran = replik.filter((x) => DOLGU.test(sozKismi(x.m))).length / Math.max(1, replik.length);
    if (dolguOran < 0.2) sahneUyari.push({ kural: "dolgu_az", deger: "%" + Math.round(dolguOran * 100) });
    const ucNokta = replik.filter((x) => x.m.includes("…")).length / Math.max(1, replik.length);
    if (ucNokta > 0.3) sahneUyari.push({ kural: "uc_nokta", deger: "%" + Math.round(ucNokta * 100) });

    return {
      satirlar,
      sahne: sahneUyari,
      olcum: { replik: replik.length, susma, dolgu_orani: dolguOran, uc_nokta_orani: ucNokta, uzunluklar: uz },
    };
  }

  const api = { metinler, denetle, KURALLAR, sozKismi };
  kok.Yapaylik = api;
  if (typeof module !== "undefined") module.exports = api;

  if (typeof require !== "undefined" && typeof module !== "undefined" && require.main === module) {
    const yol = require("path").resolve(process.argv[2] || __dirname + "/sahne_recber.js");
    const sahne = require(yol);
    const r = denetle(sahne);
    const idx = Object.fromEntries(metinler(sahne).map((x) => [x.id, x]));
    console.log("Yapaylık denetimi: " + sahne.id);
    for (const [id, kurallar] of Object.entries(r.satirlar)) {
      console.log("  " + id + "  [" + kurallar.join(", ") + "]  " + idx[id].m);
    }
    for (const s of r.sahne) console.log("  SAHNE  [" + s.kural + "] " + s.deger + " — " + KURALLAR[s.kural]);
    console.log(
      "  Ölçüm: " + r.olcum.replik + " replik, " + r.olcum.susma + " susma, konuşma işareti %" + Math.round(r.olcum.dolgu_orani * 100) +
        ", üç nokta %" + Math.round(r.olcum.uc_nokta_orani * 100)
    );
    console.log("  Toplam satır uyarısı: " + Object.keys(r.satirlar).length + ", sahne uyarısı: " + r.sahne.length);
  }
})(typeof window !== "undefined" ? window : globalThis);
