# Laboratorio 01 — Informe

> **Instrucciones de uso de esta plantilla**
>
> 1. Copiala a `entregas/lab01/grupoXX/informe.md`.
> 2. Completá **todas** las secciones. Borrá estas instrucciones y todos los
>    textos en *cursiva*, que son consignas, no contenido.
> 3. No borres los encabezados ni cambies el orden: la corrección los sigue.
> 4. Si una sección no aplica, escribí por qué no aplica. **No la borres.**

---

## Identificación

| | |
|---|---|
| **Grupo** | 07 |
| **Caso asignado (Parte A)** | *(a completar por Lautaro)* |
| **Tema del mini-research** | *(a completar por Fernando)* |
| **Fecha de entrega** | *(antes del inicio de la Clase 2)* |

### Integrantes

| Nombre y apellido | Legajo | Usuario de GitHub |
|---|---|---|
| Lorenzo Blanc | 15034 | @LoloBlanc |
| Fernando Cagliero | 15136 | @Ferca19 |
| Guadalupe Gómez | 15397 | @guadagomezgg8 |
| Lautaro Mariño | 15163 | @lautaromarino0 |

---

# PARTE A — Análisis del incidente bajo la lente CIA

## A.1 — Cronología

*Máximo 10 líneas. Qué pasó, cuándo, en qué orden. **Cada afirmación con su
fuente.** Si no encontrás una fuente que lo respalde, no lo escribas.*

| Fecha | Hecho | Fuente |
|---|---|---|
| | | |
| | | |
| | | |

---

## A.2 — Activo afectado

*¿Qué se estaba protegiendo? Concreto: no «los datos», sino qué datos, de
quién, en qué sistema. Si hubo más de un activo, priorizá y justificá el
orden.*

**Activo principal:**

**Por qué es el principal:**

**Otros activos afectados:**

---

## A.3 — Matriz CIA

*Una fila por propiedad. La columna «Evidencia» tiene que citar un hecho
concreto del incidente, no una generalidad.*

> **Advertencia.** «No» es una respuesta válida y muchas veces la correcta.
> El error típico es marcar las tres propiedades en «Sí» porque el incidente
> fue grave. La gravedad no es una propiedad de la tríada. Si marcás que se
> violó la integridad, tenés que mostrar **qué dato específico fue alterado**.
> Si no podés mostrarlo, la respuesta es «No».

| Propiedad | ¿Se violó? | Evidencia concreta |
|---|---|---|
| **Confidencialidad** | Sí / No / Parcial | |
| **Integridad** | Sí / No / Parcial | |
| **Disponibilidad** | Sí / No / Parcial | |

**Justificación ampliada de la propiedad más discutible:**

*De las tres, ¿cuál fue la más difícil de determinar y por qué? Desarrollá.*

---

## A.4 — Encadenamiento amenaza → vulnerabilidad → impacto

*Redacción en prosa, no viñetas. Usá los términos con precisión: una amenaza
no es una vulnerabilidad, un exploit no es una vulnerabilidad, y el impacto
no es el ataque.*

```
amenaza  →  explota  →  vulnerabilidad  →  sobre  →  activo  →  produce  →  impacto
```

| Elemento | En este caso |
|---|---|
| **Amenaza** *(quién / qué, con qué motivación)* | |
| **Vulnerabilidad** *(la debilidad concreta que se explotó)* | |
| **Activo** *(sobre qué recayó)* | |
| **Impacto** *(consecuencia sobre el negocio o las personas)* | |

**Redacción:**

*Un párrafo que encadene los cuatro elementos anteriores.*

---

## A.5 — Dos controles mitigantes

*Controles que, de haber estado implementados, habrían evitado o reducido el
incidente. Específicos y justificados contra **este** caso. «Tener antivirus»
o «capacitar a los usuarios» no califica.*

### Control 1

| | |
|---|---|
| **Qué es** | |
| **Propiedad de la tríada que protege** | |
| **Por qué habría funcionado en este caso concreto** | |

### Control 2

| | |
|---|---|
| **Qué es** | |
| **Propiedad de la tríada que protege** | |
| **Por qué habría funcionado en este caso concreto** | |

---

## A.6 — Fuentes consultadas (Parte A)

*Formato APA. Indicá para cada una si es primaria (informe oficial, documento
del fabricante, resolución judicial, paper) o secundaria (nota periodística,
entrada de blog).*

1.
2.
3.

---

# PARTE B — Integridad con funciones de hash

## B.1 — Evidencia de ejecución

### Generación del manifiesto

```
$ python src/integridad.py generar --dir data/muestra --salida manifest.sha256
Manifiesto generado: manifest.sha256
Directorio base:     data\muestra
Archivos indexados:  4

$ cat manifest.sha256
{
  "app.bin": "a1f259d4365ed4320c377ce26f5c8c56dcdc9a89e7b641bfd8eabfbbeac86654",
  "logs/acceso.log": "479bb8382eca943570ac69b7189e4feb62d152436f77cafcf551c52ea00c5cd4",
  "politica_seguridad.md": "4f27c493a553b185aebdea570d0cc4aa5763425de0fc91d51a32eb71a4c46393",
  "transferencia.txt": "4394e0a7006eecb79b32dbfa7471fd7121893239fb94e1a7a3269c31b5262334"
}
```

Exclusión del propio manifiesto. Dos corridas seguidas escribiendo la salida
dentro del directorio recorrido: en la segunda el archivo ya existe y aun así
queda fuera del índice.

```
$ python src/integridad.py generar --dir data/muestra --salida data/muestra/manifest.sha256
Manifiesto generado: data\muestra\manifest.sha256
Directorio base:     data\muestra
Archivos indexados:  4

$ python src/integridad.py generar --dir data/muestra --salida data/muestra/manifest.sha256
Manifiesto generado: data\muestra\manifest.sha256
Directorio base:     data\muestra
Archivos indexados:  4
```

Directorio vacío.

```
$ mkdir data/vacio
$ python src/integridad.py generar --dir data/vacio --salida prueba_vacio.json
Manifiesto generado: prueba_vacio.json
Directorio base:     data\vacio
Archivos indexados:  0

$ cat prueba_vacio.json
{}
```

### Verificación sobre un directorio íntegro

```
$ python src/integridad.py verificar --dir data/muestra --manifiesto manifest.sha256
Directorio:  data\muestra
Manifiesto:  manifest.sha256

  OK             4
  MODIFICADO     0
  FALTANTE       0
  NUEVO          0

INTEGRIDAD VERIFICADA — sin diferencias contra el manifiesto.

$ echo "código de salida: $?"
código de salida: 0
```

### Detección de la modificación de un byte

```
$ printf 'X' >> data/muestra/transferencia.txt
$ python src/integridad.py verificar --dir data/muestra --manifiesto manifest.sha256
Directorio:  data\muestra
Manifiesto:  manifest.sha256

  OK             3
  MODIFICADO     1
  FALTANTE       0
  NUEVO          0

Hallazgos:
  [MODIFICADO] transferencia.txt

INTEGRIDAD COMPROMETIDA — 1 hallazgo(s).

$ echo "código de salida: $?"
código de salida: 1
```

### Detección de archivo faltante y de archivo nuevo

```
$ rm data/muestra/politica_seguridad.md
$ echo "backdoor" > data/muestra/backdoor.sh
$ python src/integridad.py verificar --dir data/muestra --manifiesto manifest.sha256
Directorio:  data\muestra
Manifiesto:  manifest.sha256

  OK             2
  MODIFICADO     1
  FALTANTE       1
  NUEVO          1

Hallazgos:
  [MODIFICADO] transferencia.txt
  [FALTANTE] politica_seguridad.md
  [NUEVO] backdoor.sh

INTEGRIDAD COMPROMETIDA — 3 hallazgo(s).

$ echo "código de salida: $?"
código de salida: 1
```

### Efecto avalancha

```
$ python3 src/integridad.py avalancha --a "transferencia: $1000" --b "transferencia: $1001"

(pegar salida)
```

**Distancia obtenida:** ____ bits de 256 (____ %)

*¿Coincide con lo esperado? ¿Qué esperaban antes de correrlo?*

### HMAC

```
$ python3 src/integridad.py mac --clave "secreto" --mensaje "transferir 1000"

(pegar salida)
```

```
$ python3 src/integridad.py mac --clave "secreto" --mensaje "transferir 1000" --verificar <tag válido>
$ python3 src/integridad.py mac --clave "secreto" --mensaje "transferir 1000" --verificar <tag alterado>

(pegar ambas salidas)
```

---

## B.2 — Decisiones de implementación

*Qué decisiones tuvieron que tomar que el enunciado no resolvía por ustedes.
Ejemplos: cómo trataron los enlaces simbólicos, qué hicieron con los archivos
vacíos, cómo excluyeron el manifiesto del recorrido, qué pasa si el directorio
está vacío. Una o dos oraciones por decisión.*

| Decisión | Qué hicimos | Por qué |
|---|---|---|
| Recorrido de directorios | Usamos `rglob("*")` para recorrer el directorio de forma recursiva y procesamos únicamente los elementos que son archivos mediante `is_file()`. | Para incluir los archivos que se encuentran dentro de subdirectorios y evitar intentar calcular hashes sobre directorios. |
| Exclusión del manifiesto | Comparamos cada archivo recorrido con la ruta de salida del manifiesto usando `resolve()`, y si coinciden lo excluimos. `resolve()` normaliza ambas rutas a una forma absoluta para compararlas de manera confiable, ya que una proviene del argumento de la CLI y la otra es construida por `rglob()`. | El manifiesto no debe incluirse a sí mismo porque al escribirlo su contenido cambia y, por lo tanto, también cambiaría su propio hash. |
| Representación de las rutas | Usamos `relative_to(directorio)` para guardar rutas relativas y `as_posix()` para utilizar siempre `/` como separador. | Sin `as_posix()`, en Windows una ruta podía quedar como `logs\acceso.log`, y esa clave con barra invertida no sería compatible al verificar el manifiesto en Linux. |
| Orden de las entradas | Ordenamos alfabéticamente las claves del manifiesto y las listas obtenidas durante la verificación. | Para que los resultados sean deterministas y evitar diferencias de orden innecesarias al comparar ejecuciones o manifiestos. |
| Clasificación durante la verificación | Comparamos los archivos presentes en disco con los registrados en el manifiesto y, cuando una ruta está en ambos, comparamos sus hashes para clasificarlos como OK o MODIFICADO. Las diferencias de conjuntos permiten detectar los FALTANTE y NUEVO. | De esta forma la verificación detecta no solo archivos modificados, sino también archivos eliminados o agregados. |
| | | |
| | | |

---

## B.3 — Preguntas de análisis

> **Se responden con fundamento técnico, no con opinión.** Dos o tres párrafos
> cada una. Las respuestas de una línea no suman puntos.

### 1. El manifiesto por sí solo no alcanza

*Un atacante con acceso de escritura al directorio también puede escribir
`manifest.sha256`. ¿Qué le impide modificar un archivo y regenerar el
manifiesto para que todo dé `OK`? ¿Qué habría que cambiar en el esquema para
que ese ataque no funcione?*

**Respuesta:**

---

### 2. Qué agrega HMAC y qué no

*¿Qué propiedad de seguridad aporta HMAC que un hash simple no aporta? Y la
parte importante: ¿qué **no** resuelve HMAC? Pensá en el no repudio y en
quién conoce la clave.*

**Respuesta:**

---

### 3. MD5 y SHA-1

*Ambos siguen apareciendo en software en producción. ¿Qué propiedad
criptográfica se les rompió, exactamente? ¿Hay algún uso en el que todavía
sean aceptables, o ninguno? Fundamentá con al menos una fuente.*

**Respuesta:**

**Fuente:**

---

### 4. Comparación en tiempo constante

*¿Por qué comparar un tag de autenticación con `==` puede filtrar información
al atacante, y cómo lo evita `hmac.compare_digest()`? Describí el ataque
concreto que esto previene.*

**Respuesta:**

---

### 5. SHA-256 para contraseñas: mala idea

*SHA-256 es una función de hash criptográfica sólida. ¿Por qué, entonces, es
una mala elección para almacenar contraseñas? ¿Qué se usa en su lugar y qué
propiedad tienen esas funciones que SHA-256 no tiene?*

**Respuesta:**

---

# Cierre

## Dificultades encontradas

*Qué les costó, dónde se trabaron, qué decidieron y por qué. Esta sección se
lee y suma. No es relleno: es donde se ve si entendieron el problema.*

---

## Distribución del trabajo

*Quién hizo qué. Tiene que ser consistente con el historial de commits.*

| Integrante | Aportes |
|---|---|
| Guadalupe Gómez | Estructura inicial del directorio del grupo. Implementación de `generar_manifiesto()` y `verificar_manifiesto()` (TODO 1 y 2). Pruebas de ejecución y evidencia de la sección B.1. Sección B.2. `INTEGRANTES.md`. |
| | |
| | |
| | |
| | |

---

## Declaración de uso de asistentes de IA

> **Obligatoria.** No está prohibido usar asistentes de IA. Lo que se evalúa es
> que entiendan lo que entregan. La omisión de esta declaración es **causal de
> rechazo automático** de la entrega. Una declaración honesta no baja la nota.

**¿El grupo usó asistentes de IA en este trabajo?**  Sí 

*Si la respuesta es No, firmen igual la sección y pasen al final.*

| Herramienta | Para qué se usó | Qué partes del entregable afectó | Cómo se verificó que lo devuelto era correcto |
|---|---|---|---|
| Claude (Anthropic) | Explicación de funciones de `pathlib` (`rglob`, `is_file`, `relative_to`, `as_posix`, `resolve`) y guía para implementar los TODO 1 y 2. Formateo de las salidas de terminal para la sección B.1. | `src/integridad.py`: funciones `generar_manifiesto()` y `verificar_manifiesto()`. Sección B.1 del informe. | El código se escribió y se probó de forma incremental: cada paso se ejecutó en la terminal antes de agregar el siguiente. Se verificaron los casos de directorio íntegro, modificación de un byte, archivo faltante, archivo nuevo, directorio vacío y manifiesto dentro del directorio recorrido. Las salidas pegadas en B.1 son reales. |
| | | | |

**Declaración:**

*El grupo declara que comprende el contenido íntegro de lo entregado y que
puede explicar y defender oralmente cualquier parte del código y del análisis,
independientemente de la asistencia recibida.*

---

## Fuentes consultadas (general)

*Todas las fuentes del trabajo, en formato APA. Las de la Parte A pueden
repetirse acá o referenciarse a la sección A.6.*

1.
2.
3.
