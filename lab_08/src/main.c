#include <stdio.h>

float calc(float a, float b, char sign)
{
    float res;

    __asm__(
        "flds %2\n\t"
        "flds %1\n\t"
        "mov %3, %%al\n\t"
        "cmp $43, %%al\n\t"
        "je addc\n\t"
        "cmp $45, %%al\n\t"
        "je subc\n\t"
        "cmp $42, %%al\n\t"
        "je mulc\n\t"
        "cmp $47, %%al\n\t"
        "je divc\n\t"
        "addc:\n\t"
        "faddp\n\t"
        "jmp endc\n\t"
        "subc:\n\t"
        "fsubp\n\t"
        "jmp endc\n\t"
        "mulc:\n\t"
        "fmulp\n\t"
        "jmp endc\n\t"
        "divc:\n\t"
        "fdivp\n\t"
        "endc:\n\t"
        "fstps %0"
        : "=m"(res)
        : "m"(a), "m"(b), "m"(sign)
        : "%al");

    return res;
}

int main()
{
    float a, b;
    char sign;

    printf("Input a, b, sign: ");
    scanf("%f %f %c", &a, &b, &sign);

    float res = calc(a, b, sign);

    printf("%f %c %f = %f\n", a, sign, b, res);

    return 0;
}