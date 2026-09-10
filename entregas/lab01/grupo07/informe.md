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
| **Caso asignado (Parte A)** | 1 — **Stuxnet** (2010), por `7 mod 6 = 1` |
| **Tema del mini-research** | 2 — La cadena de suministro de software como superficie de ataque (SolarWinds/SUNBURST y Log4Shell) |
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

**Caso:** 1 — **Stuxnet** (2010). Asignado por la regla del enunciado:
`número_de_grupo mod 6` → `7 mod 6 = 1`.

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
$ python src/integridad.py avalancha --a "transferencia: $1000" --b "transferencia: $1001"

mensaje A: "transferencia: $1000"
  SHA-256: 341511c4c817d55f30c81e212d0e82b0b16dd5a58d49fe5e45c9d5c998ab794a
mensaje B: "transferencia: $1001"
  SHA-256: 5fb87fd7adf8a226f61c666a3ed140b147501b8a1b8e1822e57fc4b3925323d9

Distancia de Hamming: 139 de 256 bits (54.30 %)
Efecto avalancha: para entradas distintas se espera un valor cercano al 50 %.
```

**Distancia obtenida:** 139 bits de 256 (54.30 %)

El resultado coincide con lo esperado: al cambiar un solo carácter se modificó
aproximadamente la mitad de los bits del digest, en este caso un 54.30 %.

### HMAC

```
$ python src/integridad.py mac --clave "secreto" --mensaje "transferir 1000"

mensaje:      "transferir 1000"
HMAC-SHA256:  96bc66546d55627136aeaaefbcead75520a57e19539834d03e74d705b70ff9fe
```

```
$ python src/integridad.py mac --clave "secreto" --mensaje "transferir 1000" --verificar 96bc66546d55627136aeaaefbcead75520a57e19539834d03e74d705b70ff9fe
mensaje:      "transferir 1000"
HMAC-SHA256:  96bc66546d55627136aeaaefbcead75520a57e19539834d03e74d705b70ff9fe
tag recibido: 96bc66546d55627136aeaaefbcead75520a57e19539834d03e74d705b70ff9fe

TAG VÁLIDO — el mensaje es auténtico e íntegro.

$ echo "código de salida: $?"
código de salida: 0

$ python src/integridad.py mac --clave "secreto" --mensaje "transferir 1000" --verificar 0000000000
mensaje:      "transferir 1000"
HMAC-SHA256:  96bc66546d55627136aeaaefbcead75520a57e19539834d03e74d705b70ff9fe
tag recibido: 0000000000

TAG INVÁLIDO — el mensaje fue alterado o la clave no es la correcta.

$ echo "código de salida: $?"
código de salida: 1

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

El manifiesto por sí solo no establece una raíz de confianza. Si un atacante
puede escribir tanto los archivos protegidos como `manifest.sha256`, puede
modificar un archivo, calcular su nuevo SHA-256 y reemplazar el manifiesto.
La verificación volvería a informar `OK`, pero solo porque el atacante cambió
la referencia junto con el archivo.

El esquema debe guardar la referencia en un lugar que el atacante no pueda
modificar, por ejemplo un repositorio o servidor separado con permisos de solo
lectura, o protegerla criptográficamente. Una alternativa es calcular un
HMAC del manifiesto con una clave almacenada fuera del directorio controlado;
una opción más adecuada cuando se necesita verificar el origen y conservar una
prueba independiente es firmarlo digitalmente con una clave privada y validar
la firma con la clave pública. En ambos casos, el atacante puede modificar el
archivo, pero no puede generar una referencia válida sin el secreto o la clave
privada.

---

### 2. Qué agrega HMAC y qué no

*¿Qué propiedad de seguridad aporta HMAC que un hash simple no aporta? Y la
parte importante: ¿qué **no** resuelve HMAC? Pensá en el no repudio y en
quién conoce la clave.*

**Respuesta:**

HMAC agrega autenticidad del origen además de integridad frente a quien no
conoce la clave secreta. Un hash simple permite detectar cambios solo si el
atacante no puede modificar también el hash, porque cualquiera que conozca el
mensaje puede recalcular su digest. En cambio, un tag HMAC válido solo puede
producirse con la clave compartida, por lo que el receptor puede comprobar que
el mensaje no fue alterado por alguien externo al grupo que conoce la clave.

HMAC no cifra el mensaje ni protege su confidencialidad, y tampoco garantiza
disponibilidad o que el mensaje sea reciente: para evitar repeticiones habría
que incorporar un nonce, contador o marca temporal y validarlo. Además, no
proporciona no repudio, porque tanto quien genera como quien verifica conocen
la misma clave y cualquiera de ellos podría crear un tag válido. Si la clave
se filtra, el atacante puede falsificar mensajes y manifiestos; para una
atribución pública e independiente se necesita una firma digital con clave
privada y clave pública de verificación.

---

### 3. MD5 y SHA-1

*Ambos siguen apareciendo en software en producción. ¿Qué propiedad
criptográfica se les rompió, exactamente? ¿Hay algún uso en el que todavía
sean aceptables, o ninguno? Fundamentá con al menos una fuente.*

**Respuesta:**

La propiedad criptográfica que se rompió es la resistencia a colisiones: ya no
es computacionalmente inviable encontrar dos entradas diferentes que produzcan
el mismo digest. En MD5 se demostraron colisiones prácticas desde 2004, y en
SHA-1 se consiguió una colisión pública en 2017. Esto no significa que se haya
recuperado cualquier mensaje a partir de su hash ni que se haya roto de la misma
forma la resistencia a preimagen; el problema central es que un atacante puede
fabricar dos contenidos distintos con la misma huella y aprovecharlo, por
ejemplo, en una firma o certificado.

Por ese motivo no deben usarse MD5 ni SHA-1 para generar nuevas firmas,
certificados o controles de integridad frente a un atacante. MD5 puede seguir
apareciendo como checksum no criptográfico o para detectar errores accidentales
cuando no existe un adversario, pero ese uso no brinda seguridad. SHA-1 conserva
algunos usos de compatibilidad, como verificar firmas antiguas ya existentes o
ciertos usos aprobados de legado, pero no debe generar nueva protección
criptográfica; para desarrollos nuevos corresponde migrar a SHA-256 o SHA-3.

**Fuente:**

NIST. (2006). *Cryptographic hash standards: Where do we go from here?*
https://www.nist.gov/publications/cryptographic-hash-standards-where-do-we-go-here

NIST. (2017). *Research results on SHA-1 collisions*.
https://csrc.nist.gov/News/2017/Research-Results-on-SHA-1-Collisions

NIST. (2022). *NIST transitioning away from SHA-1 for all applications*.
https://csrc.nist.gov/News/2022/nist-transitioning-away-from-sha-1-for-all-apps

---

### 4. Comparación en tiempo constante

*¿Por qué comparar un tag de autenticación con `==` puede filtrar información
al atacante, y cómo lo evita `hmac.compare_digest()`? Describí el ataque
concreto que esto previene.*

**Respuesta:**

Una comparación ingenua con `==` puede detenerse en el primer carácter que no
coincide. Por eso, si el tag enviado comparte un prefijo más largo con el tag
correcto, la ejecución puede tardar ligeramente más. Un atacante que pueda
repetir consultas y medir esos tiempos puede probar candidatos y aprender qué
prefijo es correcto, recuperando el tag byte por byte o carácter por carácter.

`hmac.compare_digest()` está diseñada para comparar secretos sin ese retorno
temprano dependiente de la posición de la primera diferencia, reduciendo la
información temporal disponible para ese ataque. Así se evita que un endpoint
que verifica HMAC funcione como un oráculo de tiempo; aun así, deben cuidarse
también otros canales laterales y limitarse los intentos de consulta.

---

### 5. SHA-256 para contraseñas: mala idea

*SHA-256 es una función de hash criptográfica sólida. ¿Por qué, entonces, es
una mala elección para almacenar contraseñas? ¿Qué se usa en su lugar y qué
propiedad tienen esas funciones que SHA-256 no tiene?*

**Respuesta:**

SHA-256 es sólida como función de hash general, pero justamente es demasiado
rápida para almacenar contraseñas. Si un atacante obtiene la base de datos,
puede probar enormes cantidades de candidatos por segundo en forma offline y
comparar cada SHA-256 con el valor guardado. Además, SHA-256 no incorpora por sí
misma una sal única ni un costo configurable; reutilizarla directamente permite
precomputación y hace visibles las contraseñas repetidas entre usuarios.

Para contraseñas se usan funciones diseñadas para ser lentas y costosas, como
Argon2id, scrypt o bcrypt. Deben emplear una sal aleatoria y diferente por
contraseña, y ajustar un factor de trabajo que haga cada intento más caro. Las
funciones modernas agregan además resistencia al paralelismo mediante consumo de
memoria configurable, algo que SHA-256 no ofrece. OWASP recomienda preferir
Argon2id, usar scrypt cuando no esté disponible y reservar bcrypt principalmente
para sistemas heredados. Así, una filtración sigue siendo grave, pero el costo
de probar millones de candidatos aumenta considerablemente.

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
| Lorenzo Blanc | Implementación de `distancia_hamming_bits()` y `calcular_mac()` (TODO 3 y 4). Pruebas de distancia de Hamming y HMAC. Evidencia de ejecución de avalancha y HMAC. Respuestas P1, P2 y P4. |
| Fernando Cagliero | Elección del tema y redacción del mini-research sobre cadena de suministro: SolarWinds/SUNBURST, Log4Shell, SBOM y SLSA. Respuestas P3 y P5. Verificación de fuentes y revisión de la declaración de uso de IA. |
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
| OpenAI Codex | Explicación conceptual, implementación y depuración de los TODO 3 y 4; revisión de respuestas de análisis; apoyo para P3 y P5. | `src/integridad.py`: `distancia_hamming_bits()` y `calcular_mac()`; evidencia B.1; respuestas P1, P2, P3, P4 y P5. | Se verificó con pruebas directas de casos idénticos, bits opuestos, longitudes inválidas, HMAC válido e inválido, ejecución de la CLI, consulta de fuentes originales, `py_compile` y `git diff --check`. |

**Declaración:**

*El grupo declara que comprende el contenido íntegro de lo entregado y que
puede explicar y defender oralmente cualquier parte del código y del análisis,
independientemente de la asistencia recibida.*

---

## Fuentes consultadas (general)

*Todas las fuentes del trabajo, en formato APA. Las de la Parte A pueden
repetirse acá o referenciarse a la sección A.6.*

1. NIST. (2006). *Cryptographic hash standards: Where do we go from here?*
   https://www.nist.gov/publications/cryptographic-hash-standards-where-do-we-go-here
2. NIST. (2017). *Research results on SHA-1 collisions*.
   https://csrc.nist.gov/News/2017/Research-Results-on-SHA-1-Collisions
3. OWASP Foundation. (s. f.). *Password storage cheat sheet*.
   https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
