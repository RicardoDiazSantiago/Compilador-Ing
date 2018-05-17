# CompiladorA
Compilador Versión A
1. Lee y cuidadosamente cada uno de los archivos, entendiendo lo que hace cada una de las funciones. Las funciones y variables de la forma yyXXXX están documentadas en el manual de referencia de Flex.

3. Documenta todo el código y las modificaciones que escribas.

4. La primera parte del compilador consiste en completar el analizador léxico que se te proporciona (mc.l).

5. Los archivos que están en este subdirectorio están listos para compilarse a través de un archivo de proyecto de C.

Su contenido es el siguiente:

Leeme.Primero  : Lo estás leyendo en este momento.

mc.l       : Contiene los inicios de un escaner (analizador léxico) que reconoce espacios, nuevas líneas,los tokens COMA, PARA y ENTERO, en cada caso ajustando la cuenta de la posición del apuntador en el archivo. (Esto lo usaremos posteriormente para notificar errores). 
Este es el archivo que se debe completar para reconocer los
tokens correspondientes al lenguaje descrito para este curso.

driver.c       : Contiene la función main() que se encarga de probar el escáner sobre un archivo de prueba dado. También se debe modificar este archivo para tomar en cuenta los casos de tokens agregados a mc.l

errormsg.c     : Contiene funciones de manejo de errores, manejo del archivo de entrada y manejo de nueva línea.

util.c         : Contiene las funciones de utilería para construir cadenas y listas genéricas. 

ytab.h          : Contiene las definiciones de tokens que usaremos. Ten en cuenta que este archivo será generado 
automáticamente en la etapa de análisis sintáctico.

Más todos los otros archivos .h de inclusión.
                
lexyy.c es el archivo que contiene la función de análisis léxico yylex() y es generado al ejecutar flex sobre mc.l

6. El programa ej1.mc ejemplifica algunas de las características del lenguaje y puedes probar sobre él tu analizador léxico resultante. 

