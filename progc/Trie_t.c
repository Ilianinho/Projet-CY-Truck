#include "Trie_t.h"                 
//    )__                     (__   ____)
//    _ )_                      (____)
//  __    )__            
//     ______)                   ___   
//  _____)                   ___(   )__
//                          (_       __)
//                           (_  ___)
//                            (___)
//                                                                             _______________________________________________________
//                                                                         /   | 							   |
//                                                                        /    | Hello ! Here you are In the Trie of the argument T of|
//                                                                       /---, | our program! We have largely taken advantage of the  |
//                                                                  -----# ==| | functions of the course and readjusted some functions|
//                                                                  | :) # ==| | so that it is faster and with the least space taken! |
//                                                             -----'----#   | |______________________________________________________|
//                                                               |)___()  '#   |______====____   \___________________________________|
//                                                              [_/,-,\"--"------ //,-,  ,-,\\\   |/             //,-,  ,-,  ,-,\\ __#
//                                                                ( 0 )|===******||( 0 )( 0 )||-  o              '( 0 )( 0 )( 0 )||
//-----------------------------------------------------------------'-'--------------'-'--'-'-----------------------'-'--'-'--'-'-----------------------------------------------------------------------





//------------------------------------------------------------------------------------------------- Creation And Search ---------------------------------------------------------------------------




StatesAVL *createNode(City *root) {														// Function to create a new AVL tree node
    StatesAVL *node = malloc(sizeof(StatesAVL)); // Allocate memory for the new node

    if (node == NULL) {
        exit(1); // Exit the program if memory allocation fails
    }
    node->city = root;
    node->fg = NULL;
    node->fd = NULL;
    node->balance = 0;

    return node;
}



StatesAVL *insertNode(StatesAVL *Node, City *root, int *h) {											// Function to insert a node into the AVL tree
    if (Node == NULL) {
        *h = 1;
        return createNode(root);
    } else if (Node->city->total_ride > root->total_ride) {
        Node->fg = insertNode(Node->fg, root, h);
        *h = -*h;
    } else if (Node->city->total_ride < root->total_ride) {
        Node->fd = insertNode(Node->fd, root, h);
    } else if (root->total_ride == Node->city->total_ride) {
        int cmp = strcmp(root->name, Node->city->name);
        if (cmp > 0) {
            Node->fd = insertNode(Node->fd, root, h);
        } else {
            Node->fg = insertNode(Node->fg, root, h);
            *h = -*h;
        }
    } else {
        *h = 0;
        return Node;
    }
    if (*h != 0) {
        Node->balance = Node->balance + *h;
        Node = balanceTree(Node);
        if (Node->balance == 0) {
            *h = 0;
        } else {
            *h = 1;
        }
    }
    return Node;
}


StatesAVL *loadData(char *filename) {                                                                                   		// Function to load data from a file into an AVL tree
    FILE *file = NULL;
    file = fopen(filename, "r");
    if (file == NULL) {
        fprintf(stderr, "The file %s is unknown \n", filename);
        exit(2);
    }
    StatesAVL *Node = NULL;
    char line[500];
    while (fgets(line, sizeof(line), file) != NULL) {
        char *token = strtok(line, ",");
        if (token != NULL) {
            City *root = malloc(sizeof(City));
            root->name = strdup(token);
            token = strtok(NULL, ",");
            root->total_ride = atoi(token);
            token = strtok(NULL, ",");
            root->start_ride = atoi(token);
            int h = 0;
            Node = insertNode(Node, root, &h);
        }
    }
    fclose(file);
    return Node;
}





//------------------------------------------------------------------------------------------------- Creation And Search ---------------------------------------------------------------------------


void freeCity(City *root) {												//Function to free memory allocated for a city node
    if (root != NULL) {
        free(root->name); // Free the memory allocated for the city name
        free(root); // Free the memory allocated for the city node
    }
}


void display(StatesAVL *Node, int *count) {										//Function to display AVL tree elements in descending order
    // Check if the current AVL node is not NULL and there are more elements to display
    if (Node != NULL && *count > 0) {
        display(Node->fd, count); // Recursively display right subtree
        // Check if there are more elements to display
        if (*count > 0) {
            // Print information of the current city node
            printf("%s,%d,%d\n", Node->city->name, Node->city->total_ride, Node->city->start_ride);
            (*count)--; 
        }
        display(Node->fg, count); // Recursively display left subtree
    }
}


void freeAVL(StatesAVL *Node) {													//Function to recursively free memory allocated for AVL tree nodes
    if (Node != NULL) {
        freeAVL(Node->fg); // Recursively free memory for left subtree
        freeAVL(Node->fd); // Recursively free memory for right subtree
        freeCity(Node->city); // Free memory for the city node
        free(Node); 
    }
}




//------------------------------------------------------------------------------------------ Rotation And Double Rotation ---------------------------------------------------------------------------



StatesAVL *leftRotation(StatesAVL *Node) {									//Function to perform left rotation in AVL tree  as we saw in class
    if (Node == NULL) {
        return Node; 
    }
    int balanceA, balanceP;
    StatesAVL *p = Node->fd; // Get the right child
    // Store balance factors before rotation
    balanceA = Node->balance;
    balanceP = p->balance;
    // Perform left rotation
    Node->fd = p->fg;
    p->fg = Node;
    // Update balance factors after rotation
    Node->balance = balanceA - my_max(balanceP, 0) - 1;
    p->balance = min(balanceA - 2, min(balanceA + balanceP - 2, balanceP - 1));
    return p; 
}


StatesAVL *rightRotation(StatesAVL *Node) {								//function to perform right rotation in AVL tree as we saw in class
    if (Node == NULL) {
        return Node; 
    }
    int balanceA, balanceP;
    StatesAVL *p = Node->fg; // Get the left child
    // Store balance factors before rotation
    balanceA = Node->balance;
    balanceP = p->balance;
    // Perform right rotation
    Node->fg = p->fd;
    p->fd = Node;
    // Update balance factors after rotation
    Node->balance = balanceA - min(balanceP, 0) + 1;
    p->balance = my_max(balanceA + 2, my_max(balanceA + balanceP + 2, balanceP + 1));
    return p; 
}



StatesAVL *doubleLeftRightRotation(StatesAVL *Node) {								     //Function to perform double left-right rotation in AVL tree as we saw in class
    if (Node == NULL) {
        return Node; 
    }
    Node->fd = rightRotation(Node->fd);         // Perform right rotation on the right child
    return leftRotation(Node);      // Perform left rotation on the current node
}



StatesAVL *doubleRightLeftRotation(StatesAVL *Node) {							//Function to perform double right-left rotation in AVL tree as we saw in class
    if (Node == NULL) {
        return Node; 
    }
    Node->fg = leftRotation(Node->fg);       // Perform left rotation on the left child
    return rightRotation(Node);        // Perform right rotation on the current node
}



StatesAVL *balanceTree(StatesAVL *Node) {												//Function to balance the AVL tree as we saw in class
    if (Node == NULL) {
        return Node; 
    }
    if (Node->balance >= 2) {      // Check if the current node is left-heavy
        if (Node->fd->balance >= 0) {        // Check if the right child is left-heavy
            return leftRotation(Node); 
        } else {
            return doubleLeftRightRotation(Node); // Perform double left-right rotation
        }
    }
    else if (Node->balance <= -2) {      // Check if the current node is right-heavy
        if (Node->fg->balance <= 0) {       // Check if the left child is right-heavy
            return rightRotation(Node); 
        } else {
            return doubleRightLeftRotation(Node); // Perform double right-left rotation
        }
    }
    return Node; 
}


//------------------------------------------------------------------------------------------------- Logical Operation ---------------------------------------------------------------------------





int min(int a, int b) {														// Function to find the minimum of two integers
    if (a < b) {
        return a;
    } else {
        return b;
    }
}


int my_max(int a, int b) {														// Function to find the maximum of two integers
    if (a > b) {
        return a;
    } else {
        return b;
    }
}





//------------------------------------------------------------------------------------------------- Main Code ---------------------------------------------------------------------------



int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "%s: Incorrect number of parameters, a file is expected \n", argv[0]);
        return 1;
    }
    StatesAVL *avl = loadData(argv[1]); 		// Load data from file into AVL tree
    int count = 10;
    display(avl, &count); 		// Display AVL tree elements
    freeAVL(avl); 
    return 0;
}

