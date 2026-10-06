"""Original synthetic ney/kopuz, string pad and kudum/drum tension stems."""
from pathlib import Path
import math
import random
import struct
import wave

OUT = Path(__file__).resolve().parents[1] / "assets/ses"


def generate():
    rate, length = 16000, 8
    notes = [146.832, 174.614, 195.998, 174.614, 130.813, 146.832, 110.0, 130.813]
    for kind in ["sakin", "gergin", "panik"]:
        rng = random.Random(kind)
        data = bytearray()
        for n in range(rate * length):
            t = n / rate
            # Periodic phrase envelope avoids clicks at loop boundary.
            edge = min(1.0, t * 20, (length - t) * 20)
            if kind == "sakin":
                note = notes[int(t) % len(notes)]
                local = t % 1
                ney = math.sin(2 * math.pi * note * t) * math.sin(math.pi * local) * 0.14
                kopuz = sum(math.sin(2 * math.pi * note * h * local) / h ** 1.5 for h in [1, 2, 3, 4]) * math.exp(-local * 9) * 0.12
                sample = ney + kopuz
            elif kind == "gergin":
                sample = sum(math.sin(2 * math.pi * note * t) * 0.065 for note in [146.832, 174.614, 220.0])
                sample *= 0.7 + 0.3 * math.sin(2 * math.pi * t / 4)
            else:
                local = t % 0.5
                drum = math.sin(2 * math.pi * (80 * local + 70 * (1 - math.exp(-local * 12)) / 12)) * math.exp(-local * 16)
                sample = drum * 0.35 + rng.uniform(-1, 1) * math.exp(-local * 60) * 0.08
            data.extend(struct.pack("<h", int(max(-1, min(1, sample * edge)) * 32767)))
        with wave.open(str(OUT / f"muzik_chr_{kind}.wav"), "wb") as output:
            output.setparams((1, 2, rate, 0, "NONE", "not compressed"))
            output.writeframes(data)


if __name__ == "__main__":
    generate()
