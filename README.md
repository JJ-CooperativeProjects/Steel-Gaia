![Fondo1](https://user-images.githubusercontent.com/93017270/218015565-76ee7efa-6897-4339-ad89-103ced0d8335.png)
# HISTORIAL DE CAMBIOS OFICIALES

_*Envio no. 10*_
  - NPC DINO BOSS:
    -Se implementa el daño por piezas del cuerpo.
    -Se configuran algunos efectos visuales de prototipo.
    -Se le pone los Assets de DinoRoto
    
   - CORRECCION DE BUGS:
    - Se corrige un bug en el ataque de puños del Jugador, que en ocasiones no se desactiva el area de colisión y sigue haciendo daño aunque no ataque.

_*Envio no. 9:*_
  - NOVEDADES:
    - Se trabaja en el sistema para la lluvia y los truenos. (en progreso. falta el efecto de los relampagos)
      - Se introdujo cuetro tipos de lluvias basadas en intensidad: poca, ligera, moderada y fuerte
      - Se implementó la opción de elegir si truena o no.
  
  - SOBRE EL PERSONAJE:
    - Se trabaja en introducir los efectos sonoros.
      - Se le puso sonido a los pasos
      - Se le puso sonido a los ataques con puños.
      - Se le puso sonido al saltar, tanto al despegar como al caer en el suelo.
  
  - CORRECCION DE BUGS:
    - Se corrige un bug al disparar con la habilidad de escopeta, que se podía interrumpir con el salto. (error en la MEF)


_*Envio no 8:*_
  - NOVEDADES:
    - Se está trabajando en conseguir:
      - Un sistema de iluminación.(no conseguido aún)
      - Un sistema de SpawnPoint para generar enemigos. (no terminado)

  - CORRECCION DE BUGS:
    - Se corrige un bug en las habilidades de Escalera y Malla, al cargar partida.


_*Envio no 7:*_
  11/02/2023
  - DISEÑO DEL JUGADOR:
    - Se continúa trabajando: añadido los assets de escalar mallas y subir escaleras.
  
  - TRAMPA DE NANOBOTS:
    - Se trabaja en mejorar el rendimiento ya que presenta ciertos lags debido a la carga gráfica.
  
  - DISEÑO DE NIVELES:
    - Se convirtieron las escenas de Fremy de simples copias a escenas heredadas.
  

----------------------------------------------------------------------------
_*Envio no 6:*_
  - DISEÑO DEL DINOBOSS:
    - Se mejoraron los efectos de fuego para la habilidad de "llamas en el suelo".
    
  - DISEÑO DEL JUGADOR:
    - Se comenzó a configurar los Assets del player.

--------------------------------------------------------------------------
*Envio no 5:*_

22/01/2023
SOBRE LAS TRAMPAS:
  - Lanzallamas sólo hace daño una vez. OK

- MINA NEUTRAL:
 - Se corrigó la configuración de estados Activa y no activa
 - Se configuró para que funcione con el Disparador
--------------------------------------------------------------------------

23/01/2023
- NPC1:
 - Se corrigió un bug, que al chocar con una pared y se giraba para atacar al jugador, no lo hacía bien (causa: un timer se disparaba e interrupía la animación de ataque)

 - Se cambió el sistema de colisión del escudo de KinematicBody2D a StaticBody2D (pendiente a debug)
 - Se sincronizó la colisión del escudo con los fotogramas de la animación
 - Se cambión la forma de colisión del escudo de Rectángulo a Càpsula.

CAMBIOS EN EL SISTEMA:
- Se independizó el concepto de Malla sujetadora y Escalera. 
	- Se implementaron mediante Habilidades modulares.
	- Se entiende ahora por Malla: un espacio donde el jugador se puede agarrar y moverse entodas direcciones.
	- Se entiende por escalera: un espacio donde el jugador puede subir o bajar.

MEJORAS Y CORRECCION DE BUGS EN EL JUGADOR:
- Se corrigieron bugs de incoherencia en el nuevo sistema modular de HABILIDADES.
- Se configuró la habilidad de doble salto de manera modular (pendiente debug)

---------------------------------------------------------------------------------
_*Envio no 4:*_

  - Se le añaden efectos especiales al NPC1
  
  - Se añaden los Assets de la pantalla del menú principal

  - Se configuraron algunos efectos sonoros a modo de prueba (botones de menú)

  - Se corrigieron bugs:
	- Se deshabilitaba la pausa cuando cambiabas de pantallas, como Cargar u Opciones.
	- Cuando un enemigo NPC1 hacía contacto con una plataforma, saltaba un error.
	- Otros bugs menores se corrigieron.

-----------------------------------------------------------------------------------
_*Envio no 3:*_

  - Implementación del NPC 2 Robot con cohetes, ya disponible para su uso en el nivel.
  
  - Corrección en el Sistema de Archivos.
  
  - Corrección de Bugs.
