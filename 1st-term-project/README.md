# Tecnicas para preprocesamiento de datos

Se diseño una herramienta de consola por medio de Commander (Libreria  para NodeJS) con la siguiente estructura:

```
Usage: process-csv [options] [command]


  Commands:

    analyze <file>                                             show headers and number of procesable entries
    analyze-column <file> <column>                             show values and its freq in a specified column
    search-column-value <file> <column> <value>                search for entries with a specific valule in the specified column
    remove-missing <file> <column>                             remove registers missing a value in a specified column
    remove-duplicates <file> <column>                          remove duplicates registers using a value in a specified column, will conserve the first one to appear in the file
    remove-by-value <file> <column> <value>                    remove registers using a value in a specified column
    switch-const <file> <column> <valueToReplace> <const>      fill some column select values with a constant
    fill-const <file> <column> <const>                         fill a column missing values with a constant
    fill-mean <file> <column> <isNumeric>                      fill a column missing values with the mean for numeric values or the mode for other types
    fill-mean-class <file> <column> <classColumn> <isNumeric>  fill a column missing values with the mean for numeric values or the mode for other types, taking into account the class

  Options:

    -h, --help  output usage information

```

Puedes consultar la ayuda del programa por medio de la consola.

## Manual para usarse

- Bajar el repositorio
- Instalar las dependencias (dentro de la carpeta con este README)
```
npm install
```
- Crear el enlace simbolico para usarse en consola
```
npm link
```
- Ejecutar los comandos deseados

## Ejemplo de uso

Se tiene integrado en el repositorio un dataset con los datos de los juegos de Pokemon, y se puede consultar mas informacion en la siguiente liga: [Bulbapedia | Stats](http://bulbapedia.bulbagarden.net/wiki/Statistic)

```
process-csv remove-duplicates pokemon_base_full.csv dex_number
```

Con este comando y esta forma podria quitar todos los que tengan un numero duplicado en el pokedex, removiendo efectivamente variantes de forma (Mega Evolution, Alternates, etc.)
