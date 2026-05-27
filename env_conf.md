# Configuración de entorno de desarrollo (Windows - WSL)
Windows Subsystem for Linux (WSL) es un subsistema que permite instalar una distribución de Linux a la par con Windows (Sistema Operativo Host). Esto permite utilizar aplicaciones de linea de comandos de Bash en Windows de manera directa.

## 1. Instalar la distribución WSL
[Instalación de Linux en Windows con WSL](https://learn.microsoft.com/es-es/windows/wsl/install) \
[Comandos Básicos](https://learn.microsoft.com/es-es/windows/wsl/basic-commands)

Yo lo que hice fue seguir las instrucciones de la página de Microsoft y ejecutar esto en Power Shell como administrador

```powershell
wsl --list --online   # Distros que se pueden instalar
wsl --list --verbose  # Vemos lo que hay instalado
wsl --install Debian  # Debian es la distribución más ligera
wsl --list --verbose  # Debería aparecer la nueva distro de Linux

# Para mayor simpleza, establecemos lo siguiente como predeterminado
wsl --set-default Debian # La distribución Debian
wsl --manage Debian --set-default-user <mi_nuevo_usuario> # El usuario que recién creamos
```

Y luego para ejecutar Debian...
```powershell
wsl # Así de simple
```

>[!CAUTION]
> *Cuando queramos desinstalar el entorno WSL:*
> ```powershell
> wsl --list --verbose # Ver qué hay instalado
> wsl --unregister <DistributionName> # DESTRUIR la distribución de WSL
> ```

## 2. Instalando FLEX (Scanner generator) y BISON (Parser Generator)
Lo más sencillo dentro de Linux es instalar las herramientas desde Advanced Package Tool (APT):
```bash
sudo apt update
sudo apt upgrade # Si hay paquetes actualizables
sudo apt install flex bison build-essential

# Probamos que se instaló cada herramienta
flex --help  # Debe mostrar comandos
bison --help # Debe mostrar comandos
```

## 3. Mover la distribución a otro HDD (Opcional)
El directorio que quiero utilizar es el siguiente: \
`D:\...\Lenguaje_Patito\Scanner-Parser`

Y Windows Subsystem for Linux (WSL) monta las carpetas de Windows así: \
`/mnt/c/...` \
`/mnt/d/...` \
`/mnt/e/...` \
(Según la letra de la unidad de Disco)

Windows Subsystem for Linux almacena todos los datos relacionados a una distribución en un archivo `.vhdx` (Imagen de Disco Duro) ubicado en `%LOCALAPPDATA%\wsl\{Globally-Unique-Identifier}` dentro de Windows. Similar a una Máquina Virtual. Pero ese directorio está en `C:\` y mi espacio de trabajo está en  `D:\`.

Entonces hay que **mover** la distribución Debian (WSL) a una ubicación localizada dentro del mismo disco que el espacio de trabajo (Esto es ***opcional***, pero yo lo hago para una mejor distribución de las operaciones de lectura y mejor rendimiento).

Para *mover* la distribución WSL de Debian hay que:
1. exportar
2. desregistrar
3. importar en nueva ruta

Entonces en PowerShell con privilegios de administrador:
```powershell
wsl --list --verbose # Buscamos la distro objetivo (Debian)
mkdir "D:\WSL-distros\Debian" # Creamos carpeta de destino
wsl --export Debian "D:\WSL-distros\Debian\compilerWorkshop_bison+flex.tar" # Exportamos
wsl --unregister Debian # Damos de baja Debian de WSL (wsl --list --verbose ya no debe mostrarlo)

# Importamos "D:\Ubicacion\Nueva" "D:\Ubicacion\Nueva\backup.tar"
wsl --import Debian "D:\WSL-distros\Debian" "D:\WSL-distros\Debian\compilerWorkshop_bison+flex.tar"
wsl --status # Vemos qué está establecido por defecto
wsl --list --verbose # Revisamos que se importó correctamente
wsl --set-default Debian # Si no está establecida, establecemos como distribución por defecto
wsl # Entramos a Debian

whoami # [Debian] Hacemos whoami
exit   # [Debian] Si es root, salimos

# Si es root el usuario al que entramos en Debian, reestablecemos el usuario por defecto
wsl --manage Debian --set-default-user <mi_nuevo_usuario>
# Por último, deberíamos de poder entrar a Debian con el usuario solo con escribir lo siguiente en la consola (de Windows) con privilegios de administrador
wsl
```

>[!IMPORTANT]
> Al final de todo lo anterior, ya no debería aparecer el archivo `.vhdx` (Imagen de Disco Duro de la distribución WSL) en el directorio de Windows: `%LOCALAPPDATA%\wsl`

## 4. Trabajando en FLEX + BISON
Si ejecutamos el comando:
```bash
touch "/mnt/d/.../Lenguaje_Patito/Scanner-Parser/test.txt"
```

Debería aparecer un archivo `test.txt` en nuestra carpeta de trabajo dentro del explorador de archivos de Windows.

A partir de aquí, ya puedo compilar mis archivos fuente dentro de mi carpeta de trabajo en Windows para las herramientas de generación de analizadores de léxico (Scanners) y de sintaxis (Parsers) que instalé en la distribución de **Debian WSL**.

<!-- [Instrucciones para montar FLEX desde código fuente](https://github.com/westes/flex/blob/master/INSTALL.md) -->

> [FLEX Repo Deepwiki](https://deepwiki.com/search/how-to-install-flex-on-windows_aa4d878f-0928-4427-ab7d-cb53ae53b3e)

>[!TIP]
> [Yet Another Flex + Bison tutorial](https://www.cse.scu.edu/~m1wang/compiler/TutorialFlexBison.pdf)