# DAAD-Builder-Kit
Shell Script para la compilación automatizada desde macOS o Linux de aventuras conversacionales para Amstrad CPC (desde línea de comandos).

CONFIGURACIÓN
-------------

Créate un directorio para el desarrollo de tus aventuras conversacionales. La estructura ejemplo mía es:

  AVENTURAS: Carpeta raíz de trabajo para todas nuestras aventuras
    - 00_PROYECTOS: Carpeta de proyectos para distintas aventuras
      - RUTA: Aventura en desarrollo
    - 01_DAAD: Descarga el contenido de la última versión del DAAD (DAAD v2 R2 2019). El archivo LIB debéis ponerlo dentro de este directorio también.
    - 02_RECURSOS: Archivos base que servirán como plantillas o ayuda a las compilaciones (está explicado en el SH).
    - DosBox-X: Utilizo DosBox-X por si mejor gestión de nombre LFN. Se utilizará para los ejecutables de PC de 1991.
    - Triz2SCE: Herramienta en Python para convertir los mapas de Trizbort a SCE (https://pypi.org/project/triz2sce/). Debes instalar también Python en tu máquina desde https://www.python.org.


USO
---
Descarga el archivo "DAAD Builder Kit.sh" en la carpeta de tu proyecto de aventura dentro de 00_PROYECTOS. En mi caso, lo tengo dentro del directorio RUTA contenido en el anterior.
Lanza el script con "sh DAAD\ Builder\ Kit.sh".

Las opciones son:

  1 Convertir de Trizbort a SCE

  2 [PC] Compilar SCE a DDB y lanzar Interprete

  3 [AMSTRAD] Compilar SCE a DDB

  4 [AMSTRAD] Compilar DDB a BIN

  5 [AMSTRAD] Crea la versión en DSK

  0 SALIR

Basado en la versión para Windows de @cperezgrin y su curso de DAAD disponible en su canal de YouTube: https://www.youtube.com/user/cperezprg.
¡Esta versión está aún en desarrollo y pruebas, cualquier sugerencia o mejora será bienvenida!

Programado por @pedroaznar
