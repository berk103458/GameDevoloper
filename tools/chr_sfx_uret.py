"""Generate short original interrogation foley, deterministic and loop-free."""
from pathlib import Path
import math
import random
import struct
import wave

ROOT = Path(__file__).resolve().parents[1] / "assets/ses"


def generate():
    rate = 22050
    for kind in ["metal", "kagit", "bebek", "kabza", "deri", "sikke"]:
        rng = random.Random(kind)
        frames = []
        for n in range(int(rate * 0.65)):
            t = n / rate
            fade = min(1.0, t * 100) * max(0.0, 1 - t / 0.65)
            noise = rng.uniform(-1, 1)
            if kind in ("metal", "sikke", "kabza"):
                pitch = {"metal": 780, "sikke": 1600, "kabza": 310}[kind]
                value = sum(math.sin(2 * math.pi * pitch * partial * t) * math.exp(-t * (8 + partial)) / partial for partial in (1, 2.7, 4.1)) * 0.35
                value += noise * math.exp(-t * 45) * 0.12
            elif kind == "bebek":
                value = noise * (math.sin(math.pi * t / 0.65) ** 2) * 0.16 + math.sin(2 * math.pi * 390 * t) * math.exp(-((t - 0.25) / 0.1) ** 2) * 0.08
            else:
                pulses = abs(math.sin(t * (47 if kind == "kagit" else 22)))
                value = noise * pulses * (0.22 if kind == "kagit" else 0.11)
            frames.append(struct.pack("<h", int(max(-1, min(1, value * fade)) * 32767)))
        with wave.open(str(ROOT / f"sfx_chr_{kind}.wav"), "wb") as output:
            output.setparams((1, 2, rate, 0, "NONE", "not compressed"))
            output.writeframes(b"".join(frames))


if __name__ == "__main__":
    generate()
