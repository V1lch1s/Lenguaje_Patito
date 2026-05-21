#ifndef ORDERED_DICT_H
#define ORDERED_DICT_H

#include <stdbool.h>
#include <stddef.h>

// Tipos opacos: El usuario NO sabe cómo está estructurado ordered_dict internamente.
typedef struct DictIterator DictIterator;
typedef struct ordered_Dict ordered_Dict;

// Funciones de comparación y hash (deben ser compatibles)
typedef int    (*DictCompareFunc)(const void *a, const void *b);
typedef size_t (*DictHashFunc)(const void *key);
/*
 * typedef    size_t    (*DictHashFunc)(const void* key);
 * ^^^^^^     ^^^^^^    ^^^^^^^^^^^^^  ^^^^^^^^^^^^^^^^^
 * │          │         │               └─ parámetro: puntero const void*
 * │          │         └─ nombre del tipo
 * │          └─ retorna size_t (número sin signo)
 * └─ typedef
 */

// Constructor / destructor
ordered_Dict *ordered_dict_create(size_t key_size, size_t value_size,
                  DictCompareFunc key_compare,
                  DictHashFunc key_hash,
                  void (*key_destructor)(void*),
                  void (*value_destructor)(void*));
                  
void  ordered_dict_destroy(ordered_Dict *d);

// Operaciones principales
bool          ordered_dict_put(ordered_Dict *d, const void *key, const void *value);     // Inserción o actualización
bool          ordered_dict_get(const ordered_Dict *d, const void *key, void *out_value); // Consulta de Valor
bool          ordered_dict_remove(ordered_Dict *d, const void *key);                     // Eliminación segura
bool          ordered_dict_contains(const ordered_Dict *d, const void *key);             // Verificacón de clave
size_t        ordered_dict_size(const ordered_Dict *d);                                  // Número de elmentos activos
void          ordered_dict_clear(ordered_Dict *d);                                       // Elimina todos los elementos

// Iterador (para recorrido ordenado por inserción)
DictIterator *ordered_dict_iterator_create(const ordered_Dict *d);
bool          ordered_dict_iterator_next(DictIterator *it, void *out_key, void *out_value);
void          ordered_dict_iterator_destroy(DictIterator *it);

#endif