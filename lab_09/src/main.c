#include <stdio.h>

#define CYPHER 88

int getcyph(int num, int cs)
{
    int sum = 0, digits = 0;

    while (num > 0)
    {
        sum += num % cs;
        num /= cs;
        digits++;
    }

    for (int i = 0; i < digits; ++i)
    {
        sum += cs - 1;
    }

    return sum;
}

int cmpnum(int first, int second)
{
    return first == second;
}

int main()
{
    int num, cs, cypher;

    printf("Enter the count system: ");
    scanf("%d", &cs);
    printf("Enter the passcode: ");
    scanf("%d", &num);

    cypher = getcyph(num, cs);

    if (!cmpnum(cypher, CYPHER))
    {
        printf("Wrong passcode! Access denied!");
    }
    else
    {
        printf("Access given!");
    }

    return 0;
}