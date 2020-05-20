#include <stdio.h>
#include <string.h>

#define BUFFER 100

int asmstrlen(const char *str)
{
    int len = 0;
    const char *str_copy = str;

    __asm__(
        "mov $0xffffffff, %%ecx\n\t"
        "mov $0, %%al\n\t"
        "mov %1, %%rdi\n\t"
        "repne scasb\n\t"
        "mov $0xffffffff, %%eax\n\t"
        "dec %%eax\n\t"
        "sub %%ecx, %%eax\n\t"
        "mov %%eax, %0"
        : "=r"(len)
        : "r"(str_copy)
        : "%eax", "%ecx", "%rdi", "%al");

    return len;
}

void strcopy(char *dest, char *src, int len);

void test_asmstrlen()
{
    const char *test_str = "This is test string!";

    printf("asmstrlen result: %d\nstrlen result: %d\n", asmstrlen(test_str), strlen(test_str));
}

void test_asmstrcopy()
{
    char src[] = "abcdefghijklmnopqrstuvwxyz";
    char dest[BUFFER] = "1234567890";
    int len;

    printf("<Simple test>\n");
    printf("--------------------\n");
    printf("Sources for test: src - %s\n, dest - %s\n", src, dest);
    len = 2;
    strcopy(dest, src, len);
    printf("Different Source and Destination. Result: %s\nSymbols copied: %d\n", dest, len);
    printf("--------------------\n");

    printf("<Complicated tests>\n");
    printf("--------------------\n");
    printf("Source for test: %s\n", src);
    len = 8;
    strcopy(src + 4, src, len);
    printf("Destination is Source + 4. Result: %s\nSymbols copied: %d\n", src, len);
    printf("--------------------\n");
    printf("Source for test: %s\n", src);
    len = 8;
    strcopy(src, src + 4, len);
    printf("Source is Destination + 4. Result: %s\nSymbols copied: %d\n", src, len);
}

int main()
{
    printf("--------------------\n");
    test_asmstrlen();
    printf("--------------------\n");
    test_asmstrcopy();
    printf("--------------------\n");

    return 0;
}