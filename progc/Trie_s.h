#ifndef S_H
#define S_H 1200



#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>



typedef struct StateAVL {
int Route_id;
double d;
double d_min;
double d_max;
double d_max_min;
double d_moy;
int h;
int nb_state;
struct StateAVL *fg;
struct StateAVL *fd;
} StateAVL;

typedef struct Road {
 	StateAVL* node;
 	struct Road* next;
    struct Road *end;
} Road;




int Max(int a, int b);
int height(StateAVL *node);
int Balanced(StateAVL* root);

StateAVL* rotateRight(StateAVL* b);
StateAVL *rotateLeft(StateAVL *a);
StateAVL* createNode(int Route_id, double d);
Road* changeRoad(Road* root, StateAVL* newState);
Road *insertPliste(Road *pliste, StateAVL *newState);
StateAVL *insertAVL(StateAVL *root, StateAVL *newState);
StateAVL *searchSmoller(StateAVL *root);
StateAVL *heightBalanced(StateAVL *root);
StateAVL *suppSmoler(StateAVL *root);
StateAVL *insertAVLFromList(Road *pliste, StateAVL *a);


void SortedData(struct StateAVL* newNode, struct StateAVL* sortedData[50], int* Index);
void freeSortedData(struct StateAVL* sortedData[50], int Index);
void CreateCSV(struct StateAVL* root);
#endif // S_H
