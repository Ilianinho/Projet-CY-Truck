# Définir le compilateur utilisé
CC = gcc
# Définir l'emplacement de l'exécutable
BUILD_DIR = .
# Définir le nom de l'exécutable
EXEC_NAME = prog

# Compile tout
all: 
	# compile les fichiers .c en objet 
	$(CC) $(BUILD_DIR)/Trie_t.c -o $(BUILD_DIR)/$(EXEC_NAME)_t
	$(CC) $(BUILD_DIR)/Trie_s.c -o $(BUILD_DIR)/$(EXEC_NAME)_s
	
# Compile les scripts pour l'option t
prog_t:
	$(CC) $(BUILD_DIR)/Trie_t.c -o $(BUILD_DIR)/$(EXEC_NAME)_t

# Compile le script pour l'option s
prog_s:
	$(CC) $(BUILD_DIR)/Trie_s.c -o $(BUILD_DIR)/$(EXEC_NAME)_s

# Efface les fichiers compilés
clean:
	# linux os ci dessous #
	rm -f $(BUILD_DIR)/$(EXEC_NAME)_* 




