"use strict";

function secimKimligi(baglam) {
  const secenekler = (baglam && baglam.secenekler) || [];
  const bayraklar = (baglam && baglam.bayraklar) || {};
  for (const secenek of secenekler) {
    const kosul = (secenek && secenek.kosul) || {};
    let olur = true;
    for (const ad of Object.keys(kosul)) {
      if (Boolean(bayraklar[ad]) !== Boolean(kosul[ad])) olur = false;
    }
    if (olur) return String((secenek && secenek.id) || "");
  }
  if (!secenekler.length || !secenekler[0]) return "";
  return String(secenekler[0].id || "");
}

module.exports = { secimKimligi };
