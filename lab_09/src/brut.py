INT_MAX = 2147483647


def brut(cs, cypher):
    for i in range(cs - 1, INT_MAX):
        sm = 0
        digits = 0

        while i > 0:
            sm += i % cs
            i /= cs
            digits += 1

        for _ in range(digits):
            sm += cs - 1

        if sm == cypher:
            return i

    return -1


if __name__ == "__main__":
    cs = int(input("Enter the count system: "))
    cypher = int(input("Enter the cypher: "))
    print(brut(cs, cypher))
