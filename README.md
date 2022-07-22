# install_frame_webkit_kiosk.sh 

Script para desplegar la interfaz gráfica de un quiosco interactivo  utilizando el paquete snap [**wpe-webkit-mir-kiosk**](https://gitlab.com/glancr/wpe-webkit-snap) mediante [**Ubuntu-Frame**](https://mir-server.io/ubuntu-frame) en un servidor [**Ubuntu Server LTS**](https://ubuntu.com/download/server) (probado en Ubuntu Server LTS 22.04 sin entorno gráfico).

- [**Ubuntu-Frame**](https://mir-server.io/ubuntu-frame) [**(snapcraft)**](https://snapcraft.io/ubuntu-frame) es una shell para implementar aplicaciones gráficas para kioskos interactivos, soluciones de señalización digital, etc. La shell proporciona comunicaciones seguras cliente-servidor utilizando el protocolo ```Wayland``` y las aplicaciones solo pueden comunicarse a través de un socket seguro lo cual reduce los vectores de ataque para el código malicioso (Ubuntu-Frame está soportado durante 10 años)

- [**wpe-webkit-mir-kiosk**](https://gitlab.com/glancr/wpe-webkit-snap) es un fork de [**WPE WebKit**](https://wpewebkit.org/) en un paquete snap para usar en quioscos a pantalla completa.

# Instalación

Pasos a realizar para desplegar el quiosco en un equipo con ***Ubuntu Server LTS*** instalado.

| Descripción | Acción |
| --- | ---- |
| Clonar repositorio | ```git clone https://github.com/fmbrieva/frame-webkit-kiosk.git```|
| Ejecutar script de instalación | ```frame-webkit-kiosk/install_frame_webkit_kiosk.sh```|

Después de ejecutar el script de instalación se reiniciará el sistema y podrá configurar el quiosco

<img src="images/frame-webkit-kiosk_01.png" >
  
Para facilitar el despiegle/prueba de quioscos con **wpe-webkit-mir-kiosk** se proporciona un quiosco configurado en dos formatos

- Imagen para desplegar un quiosco en modo persistente desde un **pendrive**
- Imagen ISO para instalar un servidor Ubuntu Server LTS 22.04 y automatizar la instalación del quiosco

## Imagen autoarrancable persistente 

Imagen para desplegar el quiosco en modo persistente en Ubuntu Server (22.04 LTS - Jammy Jellyfish) en formato IMG

- [**frame-webkit-kiosk v00r34_persistente.img**](https://drive.google.com/file/d/1jdU6VU5s2qzEto4L5-AjsCOtCc9z-Y48/view?usp=sharing) (10/07/2022) 

Para preparar el pendrive con la imagen puede utilizar la aplicación Rufus (https://rufus.ie/). 

Si el sistema no arranca en equipos con el ```firmware UEFI``` puede ser debido a que en la BIOS está activada la opción **Secure Boot**.

## Imagen para instalar Ubuntu Server LTS con el quiosco

Imagen ISO para instalar un servidor Ubuntu Server LTS 22.04 y automatizar la instalación del quiosco

- [**frame-webkit-kiosk-v00r34-server_22.04-amd64.iso**](https://drive.google.com/file/d/1G_a9wdiKLcE7agOzZ3lMZqzDmKWt34qj/view?usp=sharing) (10/07/2022)
- [**frame-webkit-kiosk-v00r34-server_22.04-amd64.md5**](https://drive.google.com/file/d/1YSXAL1DroPNZzh8S83QQ3niTfj1g5JSt/view?usp=sharing) (10/07/2022) - Código Hash MD5 para verificar imagen ISO 

Pasos para realizar la instalación de Ubuntu Server con el quiosco:

| Paso | Descripcion |
| --- | ---- |
| 1 | Instalar Ubuntu Server LTS 22.04 (Al finalizar la instalación debe pulsar ENTER para reiniciar el sistema) |
| 2 | En el primer reinicio del sistema, si lo desea, puede realizar ajustes en el sistema |
| 3 | En el segundo reinicio se inicia de forma automática la instalación y configuración del quiosco |

```mermaid
graph TD;
    Server(Instalar Ubuntu Server LTS sin entorno gráfico)-->1_Reinicio(Primer reinicio del sistema);
    1_Reinicio-->2_Reinicio(Segundo Reinicio);
    2_Reinicio-->Wpe-webkit(Comienza instalación automática de wpe-webkit-mir-kiosk y configuración del quiosco);
    1_Reinicio(Primer Reinicio)-->Opcional_1_Reinicio(Opcional: Realizar ajustes en Ubuntu Server);
```

# Pantallas

  <img src="images/frame-webkit-kiosk_02.png" >
    
  <img src="images/frame-webkit-kiosk_04.png" >
  
  <img src="images/frame-webkit-kiosk_05.png" >

  <img src="images/frame-webkit-kiosk_06.png" >
