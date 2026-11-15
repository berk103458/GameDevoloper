"""KLT-46: docs/soz/kor_okuma.csv dosyasını HEAD sürümüyle karşılaştırır."""
from __future__ import annotations

import subprocess
import sys

if __package__:
    from .soz_kapi import KOR_OKUMA, ROOT, kor_okuma_gecmis_hatalari
else:
    from soz_kapi import KOR_OKUMA, ROOT, kor_okuma_gecmis_hatalari


def main() -> int:
    yol = KOR_OKUMA.relative_to(ROOT).as_posix()
    eski = subprocess.run(["git", "show", "HEAD:" + yol], cwd=ROOT, capture_output=True, text=True, encoding="utf-8")
    hatalar = kor_okuma_gecmis_hatalari(eski.stdout if eski.returncode == 0 else "", KOR_OKUMA.read_text(encoding="utf-8"))
    for hata in hatalar:
        print("%s %s" % (hata["kod"], hata["mesaj"]))
    print("silinen_kor=%d" % len(hatalar))
    return 1 if hatalar else 0


if __name__ == "__main__":
    sys.exit(main())
