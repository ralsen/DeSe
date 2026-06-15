def format_value(n: int, mode: str = "count") -> str:
    """
    Formatiert einen Integerwert als Zähler oder Bytegröße.
    
    mode="count" → SI-Präfixe (k, M, G, T, ...)
    mode="bytes" → Binäre Präfixe (KiB, MiB, GiB, ...)
    
    Rückgabe: immer 3-stellige Zahl + Einheit.
    """
    if mode == "bytes":
        units = ["B", "KiB", "MiB", "GiB", "TiB", "PiB", "EiB"]
        step = 1024
    elif mode == "count":
        units = ["", "k", "M", "G", "T", "P", "E"]
        step = 1000
    else:
        raise ValueError("mode muss 'count' oder 'bytes' sein")

    i = 0
    while n >= step and i < len(units) - 1:
        n /= step
        i += 1

    return f"{n:5.4f} {units[i]}"
