#include "Trie_s.h"                  
//    )__                     (__   ____)
//    _ )_                      (____)
//  __    )__            
//     ______)                   ___   
//  _____)                   ___(   )__
//                          (_       __)
//                           (_  ___)
//                            (___)
//                   _______________________________________________________
//                  | 							      |
//             /    | Hello ! Here you are In the Trie of the argument S of|
//            /---, | our program! We have largely taken advantage of the  |
//       -----# ==| | functions of the course and readjusted some functions|
//       | :) # ==| | so that it is faster and with the least space taken! |
// -----'----#   | |______________________________________________________|
//  |)___()  '#   |______====____   \___________________________________|
// [_/,-,\"--"------ //,-,  ,-,\\\   |/             //,-,  ,-,  ,-,\\ __#
//   ( 0 )|===******||( 0 )( 0 )||-  o              '( 0 )( 0 )( 0 )||
//----'-'--------------'-'--'-'-----------------------'-'--'-'--'-'-------------------------------------------------------------------------------------------------------------------------------------



//------------------------------------------------------------------------------------------------- Creation And Search ---------------------------------------------------------------------------




StateAVL* createNode(int Route_id, double d) {    				// Function to create a new node with specified Route_id and d values classic function that we saw in class
    StateAVL* newNode = (StateAVL*)malloc(sizeof(StateAVL));
    if (newNode == NULL) {
        fprintf(stderr, "Error: Memory allocation failed for new node.\n");
        exit(1);
    }
    newNode->Route_id = Route_id;
    newNode->d = d;
    newNode->d_min = d;    
    newNode->d_max = d;          
    newNode->d_max_min = 0;      
    newNode->d_moy = d/newNode->nb_state;          
    newNode->h = 1;                
    newNode->nb_state = 1;         
    newNode->fg = NULL;
    newNode->fd = NULL;

    return newNode;
}

Road* changeRoad(Road* root, StateAVL* newState) {  									// Function to update an existing Road node based on the newState
    if (root == NULL || root->node == NULL) {  
        return root;  
    }
    root->node->d += newState->d;  // Update the total distance (d) in the existing node
    if (root->node->d_max < newState->d) {
        root->node->d_max = newState->d;  // Update the maximum distance (d_max) if the newState distance is greater
    }
    if (root->node->d_min > newState->d) {
        root->node->d_min = newState->d;  // Update the minimum distance (d_min) if the newState distance is smaller
    }
    root->node->d_max_min = root->node->d_max - root->node->d_min;  // Update the range of distances (d_max_min)
    root->node->nb_state += 1;  
    root->node->d_moy = root->node->d / root->node->nb_state;  // Update the average distance (d_moy)
    return root; 
}





StateAVL *searchSmoller(StateAVL *root) {										// Function to find the smallest node in the AVL tree
    while (root != NULL && root->fg != NULL) {
        root = root->fg;
    }
    return root;
}

StateAVL *heightBalanced(StateAVL *root) {      									// Function to perform height balancing on an AVL tree
    if (root == NULL) {  
        return NULL;  
    }
    root->h = 1 + Max(height(root->fg), height(root->fd));  // Update the height of the current node
    int balance = Balanced(root);  
    if (balance > 1) {  
        if (Balanced(root->fg) >= 0) {
            return rotateRight(root);  // If the left child's balance factor is greater or equal to 0, perform a right rotation
        } else {
            root->fg = rotateLeft(root->fg);  // If the left child's balance factor is less than 0, perform a left rotation on the left child
            return rotateRight(root);  
        }
    }

    if (balance < -1) {  
        if (Balanced(root->fd) <= 0) {
            return rotateLeft(root);  // If the right child's balance factor is less or equal to 0, perform a left rotation
        } else {
            root->fd = rotateRight(root->fd);  // If the right child's balance factor is greater than 0, perform a right rotation on the right child
            return rotateLeft(root);  
        }
    }

    return root;  
}




//-------------------------------------------------------------------------- Rotation  ----------------------------------------------------------------------------------------------------------------


StateAVL* rotateRight(StateAVL* b) {												// rotationRight as we saw in class
    StateAVL* a = b->fg;
    StateAVL* n = a->fd;
    a->fd = b;
    b->fg = n;
    b->h = Max(height(b->fg), height(b->fd)) + 1;
    a->h = Max(height(a->fg), height(a->fd)) + 1;
    return a;
}


StateAVL *rotateLeft(StateAVL *a) {												// rotationLeft as we saw in class
    StateAVL *b = a->fd;
    StateAVL *n = b->fg;
    b->fd = a;
    a->fg = n;
    a->h = Max(height(a->fg), height(a->fd)) + 1;
    b->h = Max(height(b->fg), height(b->fd)) + 1;

    return b;
}


//----------------------------------------------------------- Insert and Suppresion  ------------------------------------------------------------------------------------------------------------------


Road *insertPliste(Road *pliste, StateAVL *newState) {   							// Function to insert a new node into a linked list (pliste)
    Road *Node = (Road *)malloc(sizeof(Road));  
    if (Node == NULL) {
        perror("Memory allocation error");  
        exit(1);  
    }
    Node->node = newState;  // Set the new node's data to the provided StateAVL pointer
    Node->next = NULL;  
    if (pliste == NULL) {  // If the linked list is empty, the new node becomes the list
        Road *inter = Node;  
        inter->end = Node;  
        return inter;  
    }
    Road *temp = pliste;  // Create a temporary pointer to traverse the linked list
    // Check if the last node in the list has the same Route_id as the new node
    if (temp->end->node->Route_id == newState->Route_id) {
        temp = changeRoad(temp->end, newState);  // Update the existing node using the changeRoad function
        free(Node);  
        return pliste;  
    }
    temp->end->next = Node;  // Insert the new node at the end of the linked list
    temp->end = temp->end->next;  // Update the 'end' pointer to the last node
    return pliste;  
}



StateAVL *insertAVL(StateAVL *root, StateAVL *newState) {   									// Function to insert a new node into an AVL tree
    if (root == NULL) {
        return newState;  
    }
    // Determine whether to insert into the left or right subtree based on d_max_min values
    if (newState->d_max_min < root->d_max_min) {
        root->fg = insertAVL(root->fg, newState);  
    } else if (newState->d_max_min >= root->d_max_min) {
        root->fd = insertAVL(root->fd, newState);  
    }
    root->h = 1 + Max(height(root->fg), height(root->fd));
    int balance = Balanced(root);
    if (balance > 1) {  // Perform rotations to restore balance if necessary
        if (newState->d_max_min < root->fg->d_max_min) {    // Left subtree is heavier
            return rotateRight(root);  
        } else {
            root->fg = rotateLeft(root->fg);
            return rotateRight(root);  
        }
    }
    if (balance < -1) {
        if (newState->d_max_min >= root->fd->d_max_min) {    // Right subtree is heavier
            return rotateLeft(root);  
        } else {
            root->fd = rotateRight(root->fd);
            return rotateLeft(root);  
        }
    }

    return root;  
}




StateAVL *insertAVLFromList(Road *pliste, StateAVL *a) {								// Function to insert nodes from a linked list into an AVL tree that we saw in class
    Road *temp = pliste;
    int c = 0;
    while (temp != NULL) {
        if ( c >= 50){
            if(searchSmoller(a)->d_max_min < temp->node->d_max_min){
                a = suppSmoler(a);
                a = heightBalanced(a);
                a = insertAVL(a, temp->node);
            }
        }
        else{
            a = insertAVL(a, temp->node);
        }
        c ++;
        temp = temp->next;
    }
    return a;
}


StateAVL *suppSmoler(StateAVL *root) {										// Function to remove the smallest node from an AVL tree that we saw in class
    if (root == NULL) {
        return NULL;
    }
    if (root->fg != NULL) {
        root->fg = suppSmoler(root->fg);
    } else {
        StateAVL *temp = root->fd;
        free(root);
        return temp;
    }
    return root;
}



//------------------------------------------------------------------------ Logical Operation ----------------------------------------------------------------------------------------------------------




int Max(int a, int b) {
    return (a > b) ? a : b;
}

int height(StateAVL *node) {
    if (node == NULL) {
        return 0; 
    } else {
        int h_G = height(node->fg);
        int h_D = height(node->fd);
        return 1 + Max(h_G, h_D);
    }
}

int Balanced(StateAVL* root) {
    if (root == NULL) {
        return 1;  
    } else {
        int diff_h = height(root->fg) - height(root->fd);  // Calculate the height difference between left and right subtrees
        if (diff_h < -1 || diff_h > 1) {
            return 0;  
        }
        return Balanced(root->fg) && Balanced(root->fd);   // Recursively check balance for left and right subtrees
    }
}





//------------------------------------------------------------------------ Global Execution ----------------------------------------------------------------------------------------------------------




void SortedData(struct StateAVL* newNode, struct StateAVL* sortedData[50], int* Index) {  					// Function to create a sorted array of AVL nodes
    // Checking if the current node is not NULL and the index is within the array bounds
    if (newNode != NULL && *Index < 50) {  
        SortedData(newNode->fd, sortedData, Index);
        if (*Index < 50) {  // Checking if the index is still within the array bounds
            sortedData[*Index] = newNode;  
            *Index = *Index + 1;  
        }
        SortedData(newNode->fg, sortedData, Index);// Recursively traverse the left subtree and populate sortedData array
    }
}



void freeSortedData(struct StateAVL* sortedData[50], int Index) {								// Function to free memory allocated for a sorted array of AVL nodes
    for (int i = 0; i < Index; ++i) {
        free(sortedData[i]);
    }
}


void CreateCSV(struct StateAVL* root) {  											// Function to create a CSV file (Resultat_s2) from the sorted AVL nodes
    struct StateAVL* sortedData[50];    
    int Index = 0;                       
    SortedData(root, sortedData, &Index); 		// Function to populate sortedData array with AVL nodes
    FILE* data = fopen("temp/Resultat_s2.txt", "w");
    fprintf(data, "#ID D_min D_moy D_max D_max-D_min\n");		// Writing the header to the CSV file
    // Looping through the sorted AVL nodes and writing data to the CSV file
    for (int i = 0; i < Index; ++i) {
        fprintf(data, "%d %.2lf %.2lf %.2lf %.2lf\n", sortedData[i]->Route_id, sortedData[i]->d_min, sortedData[i]->d_moy, sortedData[i]->d_max, sortedData[i]->d_max_min);
    }
    fclose(data);
    freeSortedData(sortedData, Index);       	// Freeing memory allocated for the sortedData array
}






//------------------------------------------------------------------------ Main --------------------------------------------------------------------------------------------------------------------






int main() {
    FILE* file = fopen("temp/Resultat_s.txt", "r");
    
    if (file == NULL) {		 // Checking if the file opening was successful
        fprintf(stderr, "Error opening the C file.\n");
        return 1;
    }
    int Route_id;
    double d;
    int c;
    StateAVL* a = NULL;
    // Initializing a linked list for storing data temporarily
    Road* pliste = NULL;
    Road* temp = pliste;
    // Reading data from the file until the end is reached
    while (!feof(file)) {
        c++;
        fscanf(file, "%d", &Route_id);
        fscanf(file, "%lf", &d);
        StateAVL* newState = createNode(Route_id, d);// Creating a new AVL node with the read data
        pliste = insertPliste(pliste, newState);
    }
    a = insertAVLFromList(pliste, a);       // Inserting nodes from the linked list into the AVL tree
    pliste = NULL;
    CreateCSV(a);		// Creating a CSV file (Resultat_s2) from the sorted AVL nodes
    fclose(file);
    while (pliste != NULL) {  // Freeing memory allocated for the linked list
        Road* temp = pliste;
        pliste = pliste->next;
        free(temp);
    }

    return 0;
}

