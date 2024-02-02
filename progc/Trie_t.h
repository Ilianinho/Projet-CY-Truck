#ifndef T_H
#define T_H 1200

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>


typedef struct City{
    char * name;
    int total_ride;
    int start_ride;
}City;



typedef struct StatesAVL{
    City * city;
    struct StatesAVL* fg;
    struct StatesAVL* fd;
    int balance;
}StatesAVL;




StatesAVL * createNode(City * root);
int my_max(int a, int b);
int min(int a, int b);
StatesAVL* leftRotation(StatesAVL * Node);
StatesAVL* rightRotation(StatesAVL * Node);
StatesAVL * doubleLeftRightRotation(StatesAVL * Node);
StatesAVL * doubleRightLeftRotation(StatesAVL * Node);
StatesAVL * balanceTree(StatesAVL * Node);
StatesAVL * insertNode(StatesAVL * Node, City * root, int * h);
StatesAVL * loadData(char *filename);

void display(StatesAVL * Node, int * count);
void freeCity(City * root);
void freeAVL(StatesAVL * Node);




#endif // T_H
