# =========================
# Patito - Makefile base
# =========================

CC			= gcc
FLEX		= flex
BISON	 = bison

# Nombre del ejecutable final
TARGET	= patito

# Fuentes principales
LEXER	 = patito.l
PARSER	= patito.y
# MAIN		= main.c

# Archivos generados
BISON_C = patito.tab.c
BISON_H = patito.tab.h
FLEX_C	= lex.yy.c

# Objetos
# OBJS		= main.o patito.tab.o lex.yy.o
OBJS		= patito.tab.o lex.yy.o  # Sin main.o

# Flags
CFLAGS	= -Wall -Wextra -g
LDFLAGS =
LIBS		=

# =========================
# Meta-targets
# =========================

all: $(TARGET)

# =========================
# Bison
# =========================
# Genera el parser y el header de tokens.
# El lexer incluye "patito.tab.h", así que este archivo debe existir
# antes de compilar el scanner.

$(BISON_C) $(BISON_H): $(PARSER)
	$(BISON) -d -o $(BISON_C) $(PARSER)

# =========================
# Flex
# =========================
# El lexer depende del header del parser porque usa tokens como
# T_PROGRAMA, T_VARS, T_INICIO, T_FIN, etc.

$(FLEX_C): $(LEXER) $(BISON_H)
	$(FLEX) -o $(FLEX_C) $(LEXER)

# =========================
# Objetos
# =========================

main.o: $(MAIN) $(BISON_H)
	$(CC) $(CFLAGS) -c $(MAIN) -o main.o

patito.tab.o: $(BISON_C) $(BISON_H)
	$(CC) $(CFLAGS) -c $(BISON_C) -o patito.tab.o

lex.yy.o: $(FLEX_C) $(BISON_H)
	$(CC) $(CFLAGS) -c $(FLEX_C) -o lex.yy.o

# =========================
# Enlazado
# =========================

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) $(OBJS) -o $(TARGET) $(LDFLAGS) $(LIBS) -lfl

# =========================
# Utilidades
# =========================

clean:
	rm -f $(TARGET) $(OBJS) $(BISON_C) $(BISON_H) $(FLEX_C)

run: $(TARGET)
	./$(TARGET)

debug: CFLAGS += -DDEBUG
debug: clean all

.PHONY: all clean run debug
