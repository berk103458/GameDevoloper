#!/usr/bin/env python3
"""ses_uret.py -- PROSEDUREL YER TUTUCU (placeholder) ses uretici.

Ne yapar
    Oyunun ihtiyac duydugu tum muzik / ortam / efekt WAV dosyalarini yalnizca
    koddan sentezler (ornek kutuphanesi yok). Her yerden calistirilabilir:

        python3 tools/ses/ses_uret.py              # hepsi
        python3 tools/ses/ses_uret.py sfx_adim     # yalnizca secilenler

    Cikti: assets/ses/*.wav -- 16-bit, 44.1 kHz, mono.

Belirlenimci (deterministic)
    Tum rastgelelik sabit tohumlu random.Random ile uretilir; ayni Python
    surumunde ayni girdi her zaman bayt-bayt ayni dosyalari verir.
    Bilincli olarak YALNIZCA standart kutuphane kullanilir (numpy yok):
    boylece cikti numpy surumune/BLAS'a gore degismez. Bedeli hiz:
    tum set saf Python ile yaklasik 1-2 dakika surer.

Seviyeler
    muzik / ortam dongusu : tepe -12 dBFS, dikissiz dongu (bas = son), solma yok
    SFX                   : tepe  -3 dBFS, 2 ms giris / kisa cikis solmasi

YER TUTUCU
    Bunlar gecici seslerdir; ayni dosya adiyla gercek kayitlar konuldugunda
    oyunda hicbir sey degismez.
"""

import math
import os
import random
import sys
import wave
from array import array

SR = 44100
TAU = 2.0 * math.pi
KOK = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
CIKIS = os.path.join(KOK, "assets", "ses")

DONGU_DB = -12.0
SFX_DB = -3.0


# ===================================================================== temel
def secs(t):
    return int(round(t * SR))


def zeros(n):
    return [0.0] * n


def db2lin(db):
    return 10.0 ** (db / 20.0)


def smooth(u):
    if u <= 0.0:
        return 0.0
    if u >= 1.0:
        return 1.0
    return u * u * (3.0 - 2.0 * u)


def noise(n, seed):
    g = random.Random(seed).random
    return [2.0 * g() - 1.0 for _ in range(n)]


def peak(x):
    return max(abs(v) for v in x) if x else 0.0


def norm(x, target=1.0):
    p = peak(x)
    if p <= 0.0:
        return list(x)
    g = target / p
    return [v * g for v in x]


def mul(x, e):
    return [a * b for a, b in zip(x, e)]


def pad(x, n):
    return x + zeros(n - len(x)) if len(x) < n else x[:n]


def mix(*layers):
    """(liste, kazanc) ciftlerini toplar; uzunluk = en uzun katman."""
    n = max(len(x) for x, _ in layers)
    out = zeros(n)
    for x, g in layers:
        for i, v in enumerate(x):
            out[i] += g * v
    return out


def mix_into(dst, src, gain=1.0):
    for i in range(min(len(dst), len(src))):
        dst[i] += gain * src[i]
    return dst


def fade(x, fin=0.002, fout=0.01):
    n = len(x)
    a = min(secs(fin), n // 2)
    b = min(secs(fout), n // 2)
    y = list(x)
    for i in range(a):
        y[i] *= math.sin(0.5 * math.pi * i / a)
    for i in range(b):
        y[n - 1 - i] *= math.sin(0.5 * math.pi * i / b)
    return y


# ================================================================== filtreler
def _coef(kind, f, q):
    f = min(max(f, 10.0), SR * 0.45)
    w = TAU * f / SR
    c = math.cos(w)
    al = math.sin(w) / (2.0 * q)
    if kind == "lp":
        b0, b1, b2 = (1.0 - c) / 2.0, 1.0 - c, (1.0 - c) / 2.0
    elif kind == "hp":
        b0, b1, b2 = (1.0 + c) / 2.0, -(1.0 + c), (1.0 + c) / 2.0
    else:  # "bp" -- tepe kazanci 0 dB (RBJ)
        b0, b1, b2 = al, 0.0, -al
    a0 = 1.0 + al
    return b0 / a0, b1 / a0, b2 / a0, (-2.0 * c) / a0, (1.0 - al) / a0


def biquad(x, kind, f, q=0.707):
    """RBJ biquad. f sabit Hz ya da f(t_saniye) fonksiyonu (32 ornekte bir)."""
    dyn = callable(f)
    b0, b1, b2, a1, a2 = _coef(kind, f(0.0) if dyn else f, q)
    out = zeros(len(x))
    x1 = x2 = y1 = y2 = 0.0
    for i, v in enumerate(x):
        if dyn and (i & 31) == 0:
            b0, b1, b2, a1, a2 = _coef(kind, f(i / SR), q)
        y = b0 * v + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2
        x2 = x1
        x1 = v
        y2 = y1
        y1 = y
        out[i] = y
    return out


def resonate(exc, modes):
    """Uyarimi rezonator bankasindan gecirir. modes: (Hz, Q, genlik).
    Genlik, darbe yanitinin tepe genligi olacak sekilde Q/f ile dengelenir."""
    out = zeros(len(exc))
    for f, q, g in modes:
        y = biquad(exc, "bp", f, q)
        c = g * q * 1000.0 / f
        for i, v in enumerate(y):
            out[i] += c * v
    return out


def reverb(x, room=0.7, damp=0.5, wet=0.3, dry=1.0):
    """Freeverb tarzi mono yanki (8 tarak + 4 tum-geciren)."""
    combs = (1116, 1188, 1277, 1356, 1422, 1491, 1557, 1617)
    alls = (556, 441, 341, 225)
    fb = room * 0.28 + 0.7
    d = damp * 0.4
    n = len(x)
    inp = [v * 0.015 for v in x]
    acc = zeros(n)
    for L in combs:
        buf = zeros(L)
        idx = 0
        st = 0.0
        for i in range(n):
            o = buf[idx]
            st = o * (1.0 - d) + st * d
            buf[idx] = inp[i] + st * fb
            acc[i] += o
            idx += 1
            if idx == L:
                idx = 0
    for L in alls:
        buf = zeros(L)
        idx = 0
        for i in range(n):
            b = buf[idx]
            v = acc[i]
            acc[i] = b - v
            buf[idx] = v + b * 0.5
            idx += 1
            if idx == L:
                idx = 0
    return [dry * x[i] + wet * 3.0 * acc[i] for i in range(n)]


# ================================================================ kaynaklar
def burst(n, onset, length, decay, seed, amp=1.0):
    """onset ornekte baslayan, decay (-60 dB suresi) ile sonen gurultu."""
    out = zeros(n)
    g = random.Random(seed).random
    k = math.exp(math.log(0.001) / max(1.0, decay * SR))
    e = amp
    for j in range(secs(length)):
        i = onset + j
        if i >= n:
            break
        out[i] = e * (2.0 * g() - 1.0)
        e *= k
    return out


def partials(n, modes, onset=0):
    """Sonumlu sinus kismilari. modes: (Hz, genlik, t60 s)."""
    out = zeros(n)
    for f, a, t60 in modes:
        w = TAU * f / SR
        k = math.exp(math.log(0.001) / max(1.0, t60 * SR))
        g = a
        for i in range(onset, n):
            out[i] += g * math.sin(w * (i - onset))
            g *= k
            if g < 1e-6:
                break
    return out


def sweep_thump(n, onset, f_hi, f_lo, tau, t60, amp=1.0):
    """Perdesi f_hi -> f_lo kayan sonumlu sinus (zar / govde gumburtusu)."""
    out = zeros(n)
    k = math.exp(math.log(0.001) / max(1.0, t60 * SR))
    e = amp
    ph = 0.0
    for i in range(onset, n):
        t = (i - onset) / SR
        ph += (f_lo + (f_hi - f_lo) * math.exp(-t / tau)) / SR
        out[i] += e * math.sin(TAU * ph)
        e *= k
        if e < 1e-6:
            break
    return out


def smooth_rand(n, rate, seed, lo=0.0, hi=1.0):
    """Saniyede ~rate dugumlu, kosinus aradegerlemeli yumusak rastgele egri."""
    r = random.Random(seed)
    step = SR / rate
    nodes = [r.random() for _ in range(int(n / step) + 3)]
    out = zeros(n)
    span = hi - lo
    for i in range(n):
        p = i / step
        j = int(p)
        f = (1.0 - math.cos(math.pi * (p - j))) * 0.5
        out[i] = lo + span * (nodes[j] + (nodes[j + 1] - nodes[j]) * f)
    return out


def karplus(n, f, t60, seed, smooth_passes=3):
    """Karplus-Strong tel. Ortalama filtresi yarim ornek gecikme ekler."""
    N = max(2, int(round(SR / f - 0.5)))
    r = random.Random(seed)
    buf = [2.0 * r.random() - 1.0 for _ in range(N)]
    for _ in range(smooth_passes):  # yumusak (parmakla) mizrap
        buf = [0.5 * (buf[i] + buf[i - 1]) for i in range(N)]
    m = sum(buf) / N
    buf = [v - m for v in buf]
    rho = 0.001 ** (N / (t60 * SR))
    out = zeros(n)
    idx = 0
    last = 0.0
    for i in range(n):
        cur = buf[idx]
        out[i] = cur
        buf[idx] = rho * 0.5 * (cur + last)
        last = cur
        idx += 1
        if idx == N:
            idx = 0
    return out


# ============================================================= dongu araclari
def seam(bed, L, X):
    """Surekli katman: son X ornegi basa esit-guclu capraz gecisle katlar.
    bed uzunlugu >= L+X olmali. Sonuc L ornek; out[L-1] -> out[0] kesintisiz."""
    out = bed[:L]
    for i in range(X):
        u = 0.5 * math.pi * i / X
        out[i] = bed[i] * math.sin(u) + bed[L + i] * math.cos(u)
    return out


def wrap_add(ev, L):
    """Olay katmani: L sonrasina tasan kuyruklari basa ekler (dairesel tampon)."""
    out = ev[:L]
    for i in range(L, len(ev)):
        out[i - L] += ev[i]
    return out


# ====================================================================== SFX
def sfx_adim():
    n = secs(0.25)
    heel = biquad(biquad(burst(n, 0, 0.05, 0.035, 101), "lp", 220, 0.9), "lp", 320)
    toe = biquad(biquad(burst(n, secs(0.045), 0.04, 0.025, 102), "lp", 260, 0.9), "lp", 380)
    r = random.Random(103)
    grains = zeros(n)
    for _ in range(45):
        t = 0.003 + 0.13 * r.random() ** 1.6
        i = secs(t)
        a = (0.3 + 0.7 * r.random()) * math.exp(-t / 0.06)
        for j in range(secs(0.0015)):
            if i + j < n:
                grains[i + j] += a * (2.0 * r.random() - 1.0) * math.exp(-j / 20.0)
    grit = biquad(biquad(grains, "hp", 900), "lp", 5000)
    low = mix((heel, 1.0), (toe, 0.55))
    return mix((norm(low), 1.0), (norm(grit), 0.35))


def sfx_secim():
    n = secs(0.06)
    exc = burst(n, 0, 0.003, 0.0012, 201)
    body = resonate(exc, [(1650, 14, 1.0), (2750, 12, 0.45), (950, 9, 0.35), (4300, 8, 0.1)])
    return biquad(mix((norm(body), 1.0), (norm(biquad(exc, "hp", 3000)), 0.06)), "lp", 6500)


def sfx_onay():
    n = secs(0.15)
    exc = burst(n, 0, 0.004, 0.002, 301)
    body = resonate(exc, [(185, 16, 1.0), (430, 18, 0.7), (790, 14, 0.4), (1320, 10, 0.18)])
    thump = biquad(burst(n, 0, 0.03, 0.02, 302), "lp", 160)
    return mix((norm(body), 1.0), (norm(thump), 0.4))


GATE_MODES = [(88, 5, 1.0), (196, 7, 0.9), (355, 9, 0.75), (610, 9, 0.55),
              (1040, 8, 0.4), (1780, 7, 0.22), (2900, 6, 0.1)]


def creak(dur, f_fn, a_fn, seed, jitter=0.08, skip=0.03):
    """Yapis-kay (stick-slip) gicirtisi: duzensiz darbe dizisi -> ahsap govde."""
    n = secs(dur)
    r = random.Random(seed)
    pulses = zeros(n)
    t = 0.0
    while True:
        i = int(t * SR)
        if i >= n:
            break
        if r.random() > skip:
            pulses[i] += a_fn(t) * (0.6 + 0.4 * r.random())
        t += (1.0 / max(20.0, f_fn(t))) * (1.0 + jitter * (2.0 * r.random() - 1.0))
    body = resonate(pulses, GATE_MODES)
    ae = [a_fn(i / SR) for i in range(n)]
    hiss = mul(biquad(noise(n, seed + 7), "bp", 1400, 0.8), ae)
    rumble = mul(biquad(biquad(noise(n, seed + 8), "lp", 110), "lp", 160), ae)
    return mix((norm(body), 1.0), (norm(hiss), 0.07), (norm(rumble), 0.25))


def sfx_kapi_acilir():
    D = 1.2

    def f_fn(t):
        return 48.0 + 95.0 * math.sin(math.pi * min(t / 1.05, 1.0)) ** 1.6 \
            + 9.0 * math.sin(TAU * 2.3 * t)

    def a_fn(t):
        rise = min(1.0, t / 0.12)
        fall = min(1.0, max(0.0, (D - t) / 0.3))
        return rise * fall * (0.75 + 0.25 * math.sin(TAU * 3.1 * t + 0.5))

    x = creak(D, f_fn, a_fn, 401)
    return reverb(x, room=0.5, damp=0.5, wet=0.12)


def sfx_kapi_kapanir():
    n = secs(1.0)
    T = 0.36

    def a_fn(t):
        return min(1.0, t / 0.05) * min(1.0, max(0.0, (0.38 - t) / 0.08))

    cr = pad(creak(0.38, lambda t: 70.0 + 60.0 * t / 0.38, a_fn, 411, jitter=0.06), n)
    on = secs(T)
    thud = resonate(burst(n, on, 0.02, 0.012, 412),
                    [(62, 4, 1.0), (98, 5, 0.8), (145, 6, 0.6), (240, 7, 0.4), (410, 8, 0.25)])
    boom = biquad(biquad(burst(n, on, 0.12, 0.09, 413), "lp", 90), "lp", 140)
    latch = zeros(n)
    for dt, a in ((0.04, 0.5), (0.085, 0.3), (0.13, 0.15)):
        mix_into(latch, partials(n, [(2130, a, 0.12), (3370, a * 0.6, 0.08),
                                     (5210, a * 0.3, 0.05)], secs(T + dt)))
    x = mix((norm(cr), 0.45), (norm(thud), 1.0), (norm(boom), 0.7), (norm(latch), 0.12))
    return reverb(x, room=0.6, damp=0.5, wet=0.18)


def sfx_kese():
    n = secs(0.5)
    r = random.Random(501)
    coins = zeros(n)
    for _ in range(14):
        t = 0.015 + 0.30 * r.random() ** 1.7
        base = 2600.0 + 2200.0 * r.random()
        a = (0.35 + 0.65 * r.random()) * (1.0 - 0.5 * t / 0.32)
        sc = 0.6 + 0.6 * r.random()
        modes = [(base * m, a * g, d * sc) for m, g, d in
                 ((1.0, 1.0, 0.16), (1.53, 0.6, 0.11), (2.27, 0.4, 0.08), (2.94, 0.25, 0.05))]
        mix_into(coins, partials(n, modes, secs(t)))
    coins = biquad(coins, "lp", 6500)  # kese icinde: boguk
    thump = biquad(burst(n, 0, 0.05, 0.03, 502), "lp", 260)
    rustle = biquad(burst(n, 0, 0.2, 0.12, 503), "bp", 1600, 0.7)
    return mix((norm(coins), 1.0), (norm(thump), 0.5), (norm(rustle), 0.18))


WOOD_CRACK = [(180, 4, 0.5), (720, 5, 1.0), (1450, 6, 0.8), (2650, 5, 0.6), (4100, 4, 0.4)]


def crack(n, onset, seed, count, spread, snap_len, strength=1.0):
    """Kuru catlama: keskin kirilma + kisa mikro-catlak yagmuru."""
    r = random.Random(seed)
    imp = zeros(n)
    imp[onset] += 1.5
    for _ in range(count):
        dt = spread * r.random() ** 2
        i = onset + secs(dt)
        if i < n:
            imp[i] += (0.25 + 0.75 * r.random()) * (1.0 - 0.7 * dt / spread)
    body = resonate(imp, WOOD_CRACK)
    snap = biquad(burst(n, onset, snap_len, snap_len * 0.6, seed + 1), "hp", 1200)
    return mix((norm(body), 1.0), (norm(snap), 0.7 * strength))


def sfx_bar_catlak():
    n = secs(0.4)
    return reverb(crack(n, secs(0.004), 601, 9, 0.09, 0.004), room=0.4, wet=0.1)


def sfx_bar_kirildi():
    n = secs(1.0)
    main = crack(n, secs(0.004), 701, 34, 0.38, 0.008, 1.3)
    low = sweep_thump(n, secs(0.01), 75.0, 42.0, 0.08, 0.5)
    boom = biquad(biquad(burst(n, secs(0.01), 0.1, 0.08, 702), "lp", 120), "lp", 160)
    r = random.Random(703)
    dexc = zeros(n)
    for k in range(6):
        i = secs(0.25 + 0.5 * r.random())
        mix_into(dexc, burst(n, i, 0.003, 0.0015, 710 + k, 0.3 + 0.5 * r.random()))
    debris = resonate(dexc, [(430, 10, 1.0), (760, 12, 0.6), (1220, 10, 0.35)])
    x = mix((norm(main), 1.0), (norm(low), 0.8), (norm(boom), 0.5), (norm(debris), 0.25))
    return reverb(x, room=0.6, damp=0.5, wet=0.2)


def sfx_gece_bitti():
    n = secs(2.5)
    p = 146.83  # D3 -- muzikle ayni tonik (Hicaz D)
    bell = partials(n, [(p * 0.5, 0.5, 4.0), (p, 0.7, 3.0), (p + 0.7, 0.3, 3.0),
                        (p * 1.19, 0.45, 2.2), (p * 1.5, 0.25, 1.8), (p * 2.0, 0.4, 1.6),
                        (p * 2.5, 0.12, 1.0), (p * 3.0, 0.1, 0.8), (p * 4.2, 0.06, 0.5)])
    strike = biquad(burst(n, 0, 0.015, 0.01, 1001), "lp", 1500)
    mallet = biquad(biquad(burst(n, 0, 0.15, 0.12, 1002), "lp", 90), "lp", 130)
    x = mix((norm(bell), 1.0), (norm(strike), 0.2), (norm(mallet), 0.45))
    x = biquad(x, "lp", 2200)  # uzaklik
    return reverb(x, room=0.9, damp=0.5, wet=0.5, dry=0.6)


def sfx_insaat():
    n = secs(1.5)
    hits = ((0.02, 1.0, 1.0), (0.40, 0.85, 1.03), (0.76, 0.95, 0.98), (1.13, 0.8, 1.01))
    exc = zeros(n)
    metal = zeros(n)
    thump = zeros(n)
    for k, (t, a, pt) in enumerate(hits):
        on = secs(t)
        mix_into(exc, burst(n, on, 0.0015, 0.0008, 1100 + k, a))
        mix_into(metal, partials(n, [(1870 * pt, 0.25 * a, 0.12), (3050 * pt, 0.15 * a, 0.08),
                                     (4630 * pt, 0.1 * a, 0.05)], on))
        mix_into(thump, burst(n, on, 0.01, 0.008, 1110 + k, a))
    wood = resonate(exc, [(310, 12, 1.0), (680, 14, 0.6), (1240, 12, 0.4)])
    thump = biquad(thump, "lp", 150)
    x = mix((norm(wood), 1.0), (norm(metal), 0.35), (norm(thump), 0.5))
    return reverb(x, room=0.55, damp=0.5, wet=0.2)


VOWEL_A = [(750, 7, 1.0), (1180, 8, 0.55), (2550, 9, 0.22)]
VOWEL_E = [(520, 7, 1.0), (1750, 9, 0.45), (2500, 9, 0.25)]


def shout_src(dst, onset, dur, f0, seed, amp):
    """Bagirma kaynagi: zayif testere (girtlak) + gurultu, kabarip sonen zarf."""
    g = random.Random(seed).random
    ph = 0.0
    m = secs(dur)
    for j in range(m):
        i = onset + j
        if i >= len(dst):
            break
        t = j / SR
        u = j / m
        f = f0 * (1.0 + 0.18 * math.sin(math.pi * u)) * (1.0 + 0.01 * math.sin(TAU * 5.5 * t))
        ph += f / SR
        ph -= int(ph)
        e = amp * math.sin(math.pi * u) ** 1.5
        dst[i] += e * (0.35 * (2.0 * ph - 1.0) + 0.65 * (2.0 * g() - 1.0))


def sfx_saldiri():
    n = secs(3.0)
    r = random.Random(801)
    sa = zeros(n)
    se = zeros(n)
    for v in range(10):
        shout_src(sa if v % 3 else se, secs(0.05 + 1.9 * r.random()), 0.55 + 0.8 * r.random(),
                  150.0 + 130.0 * r.random(), 810 + v, 0.5 + 0.5 * r.random())
    crowd = mix((resonate(sa, VOWEL_A), 1.0), (resonate(se, VOWEL_E), 0.8))
    crowd = biquad(biquad(crowd, "lp", 1500), "hp", 180)
    swell = [smooth(i / secs(1.2)) * (1.0 - 0.4 * smooth((i - secs(2.2)) / secs(0.8)))
             for i in range(n)]
    wash = mul(biquad(noise(n, 820), "bp", 600, 0.5), swell)
    drums = zeros(n)
    for k, (t, a) in enumerate(((0.25, 1.0), (0.95, 0.7), (1.3, 0.85), (2.0, 1.0), (2.35, 0.75))):
        on = secs(t)
        mix_into(drums, sweep_thump(n, on, 90.0, 56.0, 0.045, 0.75, a))
        mix_into(drums, biquad(burst(n, on, 0.04, 0.025, 830 + k, a), "bp", 260, 1.2), 0.35)
    drums = biquad(drums, "lp", 900)
    x = mix((norm(mul(crowd, swell)), 0.75), (norm(wash), 0.35), (norm(drums), 1.0))
    return reverb(x, room=0.85, damp=0.6, wet=0.5, dry=0.55)


def sfx_olay():
    n = secs(1.0)
    s1 = karplus(n, 73.42, 1.6, 1201)          # D2
    s2 = karplus(n, 146.83, 1.1, 1202)         # D3 (cift tel, baglama gibi)
    strings = mix((s1, 1.0), (s2, 0.28))
    body = resonate(strings, [(105, 3, 0.6), (240, 4, 0.5), (520, 5, 0.25)])
    click = biquad(burst(n, 0, 0.003, 0.002, 1203), "hp", 2000)
    x = mix((norm(strings), 1.0), (norm(body), 0.3), (norm(click), 0.05))
    return biquad(x, "lp", 3500)


# ==================================================================== dongular
NEY_HARM = (1.0, 0.42, 0.2, 0.09, 0.05, 0.03)


def ney_phrase(buf, start, notes, base, amp, seed):
    """Nefesli ney cumlesi: legato perde yolu, vibrato, perdeli + genis nefes."""
    total = sum(d for _, d in notes)
    n = secs(total + 0.8)
    o = secs(start)
    r = random.Random(seed)
    vph = TAU * r.random()
    fr = zeros(n)
    edges = []
    t0 = 0.0
    fprev = None
    for j, (semi, d) in enumerate(notes):
        f = base * 2.0 ** (semi / 12.0)
        i0 = secs(t0)
        i1 = n if j == len(notes) - 1 else secs(t0 + d)
        fp = f * 0.97 if fprev is None else fprev
        g = secs(0.12 if fprev is None else 0.07)
        if fprev is not None:
            edges.append(i0)
        for i in range(i0, i1):
            k = i - i0
            ff = fp + (f - fp) * smooth(k / g) if k < g else f
            vd = 0.0045 * min(1.0, max(0.0, (k / SR - 0.35) / 0.8))
            fr[i] = ff * (1.0 + vd * math.sin(TAU * 4.6 * i / SR + vph))
        fprev = f
        t0 += d

    dip = [1.0] * n
    w = secs(0.15)
    for e0 in edges:
        for i in range(max(0, e0 - w), min(n, e0 + w)):
            dt = (i - e0) / (0.05 * SR)
            dip[i] -= 0.2 * math.exp(-dt * dt)
    rel0 = total - 1.0
    rel_len = 1.8
    env = zeros(n)
    benv = zeros(n)
    for i in range(n):
        t = i / SR
        rel = smooth((rel0 + rel_len - t) / rel_len) if t > rel0 else 1.0
        env[i] = smooth(t / 0.35) * rel * dip[i] * (0.9 + 0.1 * math.sin(TAU * t / 4.3 + vph))
        benv[i] = smooth(t / 0.1) * rel * dip[i] * (0.55 + 0.8 * math.exp(-t / 0.25))

    tone = zeros(n)
    ph = 0.0
    H = NEY_HARM
    for i in range(n):
        ph += fr[i] / SR
        if ph >= 1.0:
            ph -= 1.0
        x = TAU * ph
        s1 = math.sin(x)
        c2 = 2.0 * math.cos(x)
        sp, sc = 0.0, s1
        acc = H[0] * s1
        for k in range(1, len(H)):
            sp, sc = sc, c2 * sc - sp
            acc += H[k] * sc
        tone[i] = acc * env[i]

    pb = biquad(noise(n, seed + 1), "bp", lambda tt: fr[min(int(tt * SR), n - 1)], 9.0)
    bb = biquad(biquad(noise(n, seed + 2), "hp", 1800), "lp", 7000)
    for i in range(n):
        if o + i >= len(buf):
            break
        buf[o + i] += amp * (tone[i] + env[i] * 4.0 * pb[i] + benv[i] * 0.14 * bb[i])


def drone_layer(n, voices, period_s):
    """Dongu boyunca tam periyodik dem: dalga tablosu + yavas nefes genligi."""
    T = 4096
    tbl = [sum((1.0 / k ** 2.2) * math.sin(TAU * k * j / T + 0.3 * k) for k in range(1, 9))
           for j in range(T)]
    tbl.append(tbl[0])
    out = zeros(n)
    for f, a in voices:
        inc = f * T / SR
        ph = 0.0
        for i in range(n):
            j = int(ph)
            v0 = tbl[j]
            out[i] += a * (v0 + (tbl[j + 1] - v0) * (ph - j))
            ph += inc
            if ph >= T:
                ph -= T
    for i in range(n):
        t = i / SR
        out[i] *= 0.72 + 0.18 * math.sin(TAU * t / (period_s / 5.0)) \
            + 0.10 * math.sin(TAU * t / (period_s / 2.0) + 1.1)
    return out


def muzik_gece_dongu():
    Ls = 75.0
    L = secs(Ls)
    X = secs(4.0)
    M = L + X

    def q(f):  # dongude tam sayida devir -> dikissiz
        return round(f * Ls) / Ls

    drone = drone_layer(L, [(q(73.42), 1.0), (q(73.42) + 0.2, 0.6),
                            (q(110.0), 0.35), (q(146.84), 0.15)], Ls)

    breath = mul(biquad(noise(M, 2001), "lp", 350), smooth_rand(M, 0.2, 2002, 0.5, 1.0))
    wc = smooth_rand(M, 0.12, 2003)
    wind = biquad(noise(M, 2004), "bp", lambda t: 300.0 + 250.0 * wc[min(int(t * SR), M - 1)], 0.8)
    wind = mul(wind, smooth_rand(M, 0.08, 2005, 0.35, 1.0))
    bed = seam(mix((norm(breath), 0.05), (norm(wind), 0.10)), L, X)

    # Hicaz (D): D Eb F# G A Bb C D -- yari ton ofsetleri D4'e gore
    D4 = 293.66
    phrases = (
        (3.0, [(7, 2.2), (5, 0.9), (4, 1.1), (1, 1.4), (0, 3.0)], 0.9),
        (15.0, [(0, 1.2), (1, 0.8), (4, 1.6), (5, 1.0), (7, 3.2)], 0.85),
        (26.5, [(8, 1.0), (7, 1.4), (5, 0.8), (4, 2.4)], 0.8),
        (37.0, [(4, 0.8), (1, 1.0), (0, 1.0), (-2, 1.2), (0, 3.4)], 0.9),
        (49.0, [(7, 1.6), (8, 0.7), (10, 1.2), (8, 0.8), (7, 2.8)], 0.85),
        (60.5, [(5, 1.0), (4, 1.0), (1, 1.4), (0, 4.0)], 0.8),
    )
    ney = zeros(L + secs(7.0))
    for k, (st, notes, a) in enumerate(phrases):
        ney_phrase(ney, st, notes, D4, a, 2100 + 10 * k)
    ney = wrap_add(reverb(ney, room=0.88, damp=0.55, wet=0.38, dry=0.8), L)

    return mix((norm(ney), 1.0), (norm(drone), 0.30), (bed, 1.0))


def crackle_layer(n, limit, seed, rate, dens):
    r = random.Random(seed)
    fine = zeros(n)
    pops = zeros(n)
    t = 0.0
    while True:
        lam = rate * (0.35 + 1.3 * dens[min(int(t * SR), len(dens) - 1)])
        t += -math.log(1.0 - r.random()) / lam
        i = int(t * SR)
        if i >= limit:
            break
        big = r.random() < 0.12
        a = 0.5 + 0.5 * r.random() if big else 0.04 + 0.96 * r.random() ** 3
        tgt = pops if big else fine
        m = int(SR * (0.0004 + 0.0025 * r.random()))
        tau = SR * (0.0005 + 0.003 * r.random())
        for j in range(m):
            if i + j >= n:
                break
            tgt[i + j] += a * (2.0 * r.random() - 1.0) * math.exp(-j / tau)
    fine = biquad(biquad(fine, "hp", 1200), "lp", 9000)
    pops = resonate(pops, [(700, 3, 1.0), (1500, 3, 0.7), (3200, 2.5, 0.4)])
    return mix((norm(fine), 1.0), (norm(pops), 0.8))


def ortam_mesale_dongu():
    Ls = 20.0
    L = secs(Ls)
    X = secs(1.5)
    M = L + X
    roar = mul(biquad(biquad(noise(M, 901), "lp", 280, 0.8), "lp", 520),
               smooth_rand(M, 1.3, 902, 0.5, 1.0))
    fl = smooth_rand(M, 7.0, 903)
    flutter = mul(biquad(noise(M, 904), "bp", 900, 0.6), [v * v for v in fl])
    wc = smooth_rand(M, 0.15, 905)
    wind = biquad(noise(M, 906), "bp", lambda t: 380.0 + 260.0 * wc[min(int(t * SR), M - 1)], 0.9)
    wind = mul(wind, smooth_rand(M, 0.22, 907, 0.3, 1.0))
    bed = seam(mix((norm(roar), 0.5), (norm(flutter), 0.12), (norm(wind), 0.3)), L, X)
    dens = smooth_rand(L, 0.5, 908)
    cr = wrap_add(crackle_layer(L + secs(0.5), L, 909, 9.0, dens), L)
    return mix((bed, 1.0), (cr, 1.0))


# ====================================================================== cikis
def write_wav(path, x):
    a = array("h", (int(round(max(-1.0, min(1.0, v)) * 32767.0)) for v in x))
    if sys.byteorder == "big":
        a.byteswap()
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(a.tobytes())
    if sys.byteorder == "big":
        a.byteswap()
    pk = max(abs(v) for v in a) if len(a) else 0
    return len(a) / SR, (20.0 * math.log10(pk / 32767.0) if pk else float("-inf"))


# (dosya, uretici, tur, sure_s, cikis_solmasi_s)
URETICILER = (
    ("muzik_gece_dongu.wav", muzik_gece_dongu, "dongu", None, None),
    ("ortam_mesale_dongu.wav", ortam_mesale_dongu, "dongu", None, None),
    ("sfx_adim.wav", sfx_adim, "sfx", 0.25, 0.03),
    ("sfx_kapi_acilir.wav", sfx_kapi_acilir, "sfx", 1.2, 0.08),
    ("sfx_kapi_kapanir.wav", sfx_kapi_kapanir, "sfx", 1.0, 0.15),
    ("sfx_secim.wav", sfx_secim, "sfx", 0.06, 0.008),
    ("sfx_onay.wav", sfx_onay, "sfx", 0.15, 0.03),
    ("sfx_kese.wav", sfx_kese, "sfx", 0.5, 0.08),
    ("sfx_bar_catlak.wav", sfx_bar_catlak, "sfx", 0.4, 0.08),
    ("sfx_bar_kirildi.wav", sfx_bar_kirildi, "sfx", 1.0, 0.15),
    ("sfx_gece_bitti.wav", sfx_gece_bitti, "sfx", 2.5, 0.5),
    ("sfx_insaat.wav", sfx_insaat, "sfx", 1.5, 0.12),
    ("sfx_saldiri.wav", sfx_saldiri, "sfx", 3.0, 0.5),
    ("sfx_olay.wav", sfx_olay, "sfx", 1.0, 0.2),
)


def main(argv):
    secilen = {a[:-4] if a.endswith(".wav") else a for a in argv[1:]}
    os.makedirs(CIKIS, exist_ok=True)
    print("%-26s %9s %12s  %s" % ("dosya", "sure (s)", "tepe (dBFS)", "not"))
    for ad, fn, tur, dur, fout in URETICILER:
        if secilen and ad[:-4] not in secilen:
            continue
        x = fn()
        if tur == "dongu":
            x = norm(x, db2lin(DONGU_DB))
            jumps = [abs(x[i] - x[i - 1]) for i in range(1, len(x), 97)]
            note = "dikis |x0-xN| %.4f (tipik adim %.4f)" % (abs(x[0] - x[-1]), max(jumps))
        else:
            x = pad(x, secs(dur))
            x = biquad(x, "hp", 30.0)  # DC / infrasonik temizligi
            x = norm(fade(x, 0.002, fout), db2lin(SFX_DB))
            note = ""
        sure, tepe = write_wav(os.path.join(CIKIS, ad), x)
        print("%-26s %9.3f %12.2f  %s" % (ad, sure, tepe, note))
        sys.stdout.flush()


if __name__ == "__main__":
    main(sys.argv)
