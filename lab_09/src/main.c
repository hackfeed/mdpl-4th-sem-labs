#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int getrand(int left, int right)
{
    srand(time(NULL));
    return (rand() % (left - right + 1)) + left;
}

int cmpnum(int first, int second)
{
    return first == second;
}

int main()
{
    int num, randnum, left, right;

    printf("Enter range for random numbers: ");
    scanf("%d %d", &left, &right);
    printf("Try your luck! Enter the number: ");
    scanf("%d", &num);

    randnum = getrand(left, right);

    if (!cmpnum(num, randnum))
    {
        printf("Not today! Guessed number is %d", randnum);
    }
    else
    {
        printf("You are lucky! You got it!");
    }

    return 0;
}