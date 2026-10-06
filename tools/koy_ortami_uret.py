"""Original synthetic village ambience: work/sheep/water and fire/wolf/owl."""
from pathlib import Path
import math
import random
import struct
import wave

OUT = Path(__file__).resolve().parents[1] / "assets/ses"

def generate():
    rate, seconds = 16000, 12
    for night in [False, True]:
        rng = random.Random(83 if night else 29)
        data = bytearray()
        smooth = 0.0
        for n in range(rate * seconds):
            t = n / rate
            noise = rng.uniform(-1, 1)
            smooth = smooth * 0.85 + noise * 0.15
            if night:
                fire = noise * 0.015 + smooth * 0.04
                wolf_t = max(0, t - 3)
                wolf = math.sin(2 * math.pi * (180 * wolf_t + 8 * wolf_t ** 2)) * math.exp(-((t - 4.5) / 0.75) ** 2) * 0.07
                owl_t = t % 6
                owl = math.sin(2 * math.pi * 270 * owl_t) * math.exp(-((owl_t - 1.5) / 0.16) ** 2) * 0.065
                value = fire + wolf + owl
            else:
                water = smooth * 0.065
                hit = t % 2
                hammer = (math.sin(2 * math.pi * 680 * hit) + 0.4 * math.sin(2 * math.pi * 1630 * hit)) * math.exp(-hit * 25) * 0.085
                bleat_t = t % 6
                bleat = math.sin(2 * math.pi * (320 * bleat_t + 5 * math.sin(bleat_t * 25))) * math.exp(-((bleat_t - 4) / 0.3) ** 2) * 0.09
                value = water + hammer + bleat
            edge = min(1.0, t * 20, (seconds - t) * 20)
            data.extend(struct.pack("<h", int(max(-1, min(1, value * edge)) * 32767)))
        with wave.open(str(OUT / ("ortam_koy_gece.wav" if night else "ortam_koy_gunduz.wav")), "wb") as output:
            output.setparams((1, 2, rate, 0, "NONE", "not compressed"))
            output.writeframes(data)

if __name__ == "__main__":
    generate()
