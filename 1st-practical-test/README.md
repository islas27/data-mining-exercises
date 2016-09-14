# Examen Practico Primer Parcial

Se diseñó una herramienta de consola por medio de Commander (Librería para NodeJS) con la siguiente estructura:

```
Usage: process-csv [options] [command]


  Commands:

    analyze <file>                                                      show headers and number of procesable entries
    analyze-column <file> <column>                                      show values and its freq in a specified column
    analyze-missing <file> <column>                                     Report how many values are missing in a specified column
    analyze-dates <file> <column> <splitter>                            Report invalid dates
    reorder <file> <column>                                             Reorder by column
    unpad-date <file> <column> <splitter> <dayPosition> <m> <y>         Clean up date format by unpadding the zeros in the month or day part
    search-column-value <file> <column> <value>                         search for entries with a specific value in the specified column
    search-duplicates <file> <omitColumn>                               search duplicates with all values, ommiting a column (like ID)
    remove-missing <file> <column>                                      remove registers missing a value in a specified column
    remove-duplicates <file> <column>                                   remove duplicates registers using a value in a specified column, will conserve the first one to appear in the file
    remove-by-value <file> <column> <value>                             remove registers using a value in a specified column
    switch-const <file> <column> <valueToReplace> <const>               fill some column select values with a constant
    switch-dates <file> <columnToFix> <dateColumn> <place> <splitter>   fill some column select values with a constant
    fill-const <file> <column> <const>                                  fill a column missing values with a constant
    fill-mean <file> <column> <isNumeric>                               fill a column missing values with the mean for numeric values or the mode for other types
    fill-mean-class <file> <column> <classColumn> <isNumeric>           fill a column missing values with the mean or mode, taking into account the class

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
- Crear el enlace simbólico para usarse en consola
```
npm link
```
- Ejecutar los comandos deseados

## Ejemplo de uso

En este ejercicio se proporcionó un dataset con inconsistencias y el objetivo es obtener el mejor dataset posible rescatando cuanta información sea posible por medio de las técnicas vistas en clase.

A continuación algunos ejemplos de comandos por medio de la herramienta process-csv para trabajar este dataset.


```
process-csv analyze-dates crime_with_errors.csv REPORT_DAT
process-csv unpad-date crime_with_errors.csv REPORT_DAT / 2 1 3
process-csv switch-dates out-ud.csv year REPORT_DAT 3 /
```

Con el primer comando verificamos si las fechas registradas son válidas (en cuanto número de meses y días, además de revisar si el año corresponde a lo declarado) y nos da una copia de los registros que no sean válidos. El segundo comando arregla la presencia de ceros innecesarios en las fechas para que sean más fácil de procesar en JS.

Finalmente el tercer comando restaura la información de la columna `REPORT_DAT` a la columna `year`.
