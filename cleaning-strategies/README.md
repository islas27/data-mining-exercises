# Tecnicas para preprocesamiento de datos

Se diseño una herramienta de consola por medio de Commander (Libreria  para NodeJS) con la siguiente estructura:

```
Usage: clean-csv [options] [command]


  Commands:

    remove <file> <column>                                     remove registers missing a value in a specified column
    repl-const <file> <column> <const>                         fill a column missing values with a constant
    repl-mean <file> <column> <isNumeric>                      fill a column missing values with the mean for numeric values or the mode for other types
    repl-mean-class <file> <column> <classColumn> <isNumeric>  fill a column missing values with the mean for numeric values or the mode for other types, taking into account the class

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

Se tiene integrado en el repositorio un dataset con los datos de el juego de Pokemon Go

- Removiendo registros con valores faltantes
Por ejemplo, no todos los pokemon poseen un segundo tipo, por lo cual puede ser interesante analizar los pokemon que si tienen 2
```
clean-csv remove pokemon.csv "Type 2"
```
Con lo cual quita los registros mencionados, resulta en un archivo llamado `out1.csv`

- Rellenar los valores faltantes con una constante
Por ejemplo puede ser de utilidad rellenar campos faltates con una constante que deseemos
```
clean-csv repl-const out.csv "Max HP" "9999"
```
Rellenaria la columna con valor "9999", devolveria un archivo llamado `out2.csv` (`out.csv` fue modificado para tener valores faltantes)

- Rellenar con el promedio o la moda de la columna
Si la columna es de valor numerico, pondremos un `1`, si es nominal ponemos un `2` para la bandera de `isNumeric`
```
clean-csv repl-mean out.csv "Max HP" 1
clean-csv repl-mean out.csv "Max HP" 2
```
De acuerdo a Excel, los valores esperados son: `118.8148148` para el promedio y `107` para la moda con el archivo `out.csv` (el archivo resultado es `out3.csv`)

- Rellenar con el promedio o la moda de la columna considerando la clase del registro
Si la columna es de valor numerico, pondremos un `1`, si es nominal ponemos un `2` para la bandera de `isNumeric`, ademas de indicar el nombre de la columna que contiene a la clase
```
clean-csv repl-mean-class out.csv "Max HP" "Class" 1
clean-csv repl-mean-class out.csv "Max HP" "Class" 2
```
De acuerdo a Excel, los valores esperados son: `115.4347826` para el promedio y `107` para la moda en la clase 1; `121.322580` para el promedio y `138` para la moda en la clase 2, todo calculado con el archivo `out.csv` (el archivo resultado es `out4.csv`)
