# HISTORIAL DE CAMBIOS OFICIALES

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
