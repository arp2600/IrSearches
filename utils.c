#include <stdlib.h>
#include <stdio.h>
#include "utils.h"

struct list_node
{
    struct list_node *next;
    int value;
};

struct list
{
    struct list_node *root;
    struct list_node *end;
};

void add_value (struct list *list, int value)
{
    if (list->root == 0)
    {
        list->root = malloc(sizeof(struct list_node));
        list->root->next = 0;
        list->root->value = value;
        list->end = list->root;
    }
    else
    {
        list->end->next = malloc(sizeof(struct list_node));
        list->end = list->end->next;
        list->end->next = 0;
        list->end->value = value;
    }
}

void clear_list (struct list *list)
{
    struct list_node *iter = list->root;
    while (iter != 0)
    {
        struct list_node *next = iter->next;
        free(iter);
        iter = next;
    }
}

size_t read_data (int **data)
{
    struct list list;
    list.root = 0;
    list.end = 0;
    size_t size = 0;

    FILE *fp;
    fp = fopen("data", "r");

    int a = 0;
    while (feof(fp) == 0)
    {
        int b = fgetc(fp);
        if (b >= '0' && b <= '9')
        {
            a = a*10 + (b - '0');
        }
        else
        {
            add_value(&list, a);
            size += 1;
            a = 0;
        }
    }

    struct list_node *iter = list.root;
    *data = malloc(sizeof(int) * size);
    size_t i = 0;
    while (iter != 0)
    {
        (*data)[i] = iter->value;
        iter = iter->next;
        i++;
    }

    clear_list(&list);

    return size;
} 

void println_int (int v)
{
    printf("%d\n", v);
}

void println_size_t (size_t v)
{
    printf("%zd\n", v);
}

void println()
{
    printf("\n");
}
