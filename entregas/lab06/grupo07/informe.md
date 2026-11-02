# Informe — Laboratorio 06 · Enumeración

**Grupo:** 07

**Integrantes:**
- Lorenzo Blanc — @LoloBlanc
- Fernando Cagliero — @Ferca19
- Guadalupe Gómez — @guadagomezgg8
- Lautaro Mariño — @lautaromarino0

**Fecha de operación:** 01/11/2026

## 0. Declaración de uso de IA

**Lorenzo Blanc — Parte A (operador):** se utilizó **Codex (OpenAI)** para preparar y operar el entorno Docker de la cátedra, ejecutar las herramientas de enumeración, organizar sus salidas y redactar la parte práctica, la bitácora y P1. La validación se realiza contra las respuestas HTTP y las salidas reales de las herramientas, con cada flag comprobada mediante `./ctf submit 06` y el estado final mediante `./ctf status 06`. No se obtienen flags leyendo el código del target ni `solucion.md`. Los ejemplos del Lab 05 se atribuyen al reconocimiento de Guadalupe ya documentado por el grupo.

**Coordinación:** Lorenzo realiza la Parte A (operador) y Fernando la Parte C
(inventario de R3, R4 y R5, y P3), según el intercambio acordado por el grupo.
Las partes B y D conservan los responsables del reparto original.

**Fernando Cagliero — Parte C (inventario R3–R5 y P3):** se utilizó **OpenAI Codex**
para analizar las capturas de Lorenzo, redactar las tres filas del inventario
y explicar en P3 el escenario de una webshell subida mediante `PUT`.
Se contrastaron métodos, estado HTTP, cuentas y roles, CMS, versión, build y
ruta del archivo default con los archivos originales de `evidencia/`. Se
consultaron las fuentes primarias de IETF, OWASP y WhatWeb para distinguir
hallazgos observados de riesgos y comprobaciones pendientes. La revisión es
documental: no se repitió la operación del contenedor ni se atribuyen a
Fernando las capturas o las flags de Lorenzo. Las comprobaciones adicionales
de documentos y evidencias se detallan al final de la sección 4.

**Lautaro y Guadalupe:** pendiente de completar sus declaraciones al
incorporar las partes B y D, respectivamente.

## 1. Flags capturadas

Las cinco flags se obtuvieron operando herramientas contra el contenedor `phantomcorp` del Lab 06. El progreso inicial era 0/5; cada flag se extrajo de la respuesta del servicio y fue aceptada por el verificador oficial. Captura textual de `./ctf status 06` (salida completa en [evidencia/17-status-repo.txt](evidencia/17-status-repo.txt)):

```text
PROGRESO · LAB 06
   ✓  R1     Enumeracion de directorios
   ✓  R2     Repositorio Git expuesto
   ✓  R3     Metodos HTTP peligrosos habilitados
   ✓  R4     Enumeracion de usuarios via API
   ✓  R5     Fingerprinting de tecnologia

██████████████████████████████  5/5 (100%)
[ OK ] ¡Lab 06 COMPLETO! Ponete las pilas con la próxima unidad.
```

| Reto | Operación y resultado observado | Flag validada | Evidencia |
|---|---|---|---|
| R1 | `dirb` encontró `/backup` con `CODE:200`; `curl /backup/` devolvió el listado y la flag. `/admin` respondió 403. | `FLAG{dir_enumeration_backup}` | [dirb](evidencia/03-dirb.txt), [respuesta de backup](evidencia/04-backup.txt) |
| R2 | `GET /.git/config` respondió 200, con `url = https://git.internal.phantomcorp/intranet.git` y la flag. | `FLAG{git_repo_exposed}` | [configuración expuesta](evidencia/05-git-config.txt) |
| R3 | `OPTIONS /` respondió 200 con `Allow: GET, POST, PUT, DELETE, OPTIONS`; la flag estaba en `X-Dangerous-Methods`. | `FLAG{http_methods_put_enabled}` | [respuesta OPTIONS](evidencia/06-options.txt) |
| R4 | `GET /api/users` respondió 200 con `admin` (superuser), `jperez` (editor), `mgomez` (viewer), la nota de endpoint interno de RRHH y la flag. | `FLAG{user_enumeration_api}` | [JSON de usuarios](evidencia/07-api-users.txt) |
| R5 | `whatweb` identificó `MetaGenerator[PhantomCMS 3.7]` y `X-Powered-By[PhantomCMS/3.7]`; una wordlist dirigida encontró `/phantomcms/VERSION`, que respondió 200 con versión, build y flag. | `FLAG{tech_fingerprint_phantomcms}` | [whatweb](evidencia/08-whatweb.txt), [enumeración dirigida](evidencia/14-dirb-cms.txt), [VERSION](evidencia/15-cms-version.txt) |

Las respuestas prueban exposición y enumeración. No se intentó subir una webshell ni reconstruir el repositorio: anunciar `PUT` no demuestra por sí solo escritura efectiva, y obtener `.git/config` no prueba que todos los objetos Git sean descargables.

## 2. Inventario de enumeración

Parte B pendiente. Las filas R3, R4 y R5 de la Parte C se completaron a partir
de las capturas originales de Lorenzo adjuntas en `evidencia/`.

| Hallazgo | Ruta/Método | Técnica | Evidencia | Riesgo | ¿Qué habilita para el Lab 07? |
|---|---|---|---|---|---|
| R1 — Directorios | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| R2 — Repositorio Git | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| R3 — Métodos HTTP anunciados | `OPTIONS /` sobre HTTP/80; `PUT` y `DELETE` en `Allow`. | `curl -sS -X OPTIONS -i http://phantomcorp/`, ejecutado por Lorenzo. | [06-options.txt](evidencia/06-options.txt): `HTTP/1.0 200 OK` y `Allow: GET, POST, PUT, DELETE, OPTIONS`. | Posible creación, modificación o borrado no autorizado si esos métodos se aceptan sin controles adecuados. Una webshell requeriría además escritura en una ruta ejecutable; el anuncio de métodos no demuestra esas condiciones. | Dirigir la validación de autorización y escritura a las rutas pertinentes, inicialmente con un archivo inerte y recuperando su contenido. Evaluar ejecución solo si se demuestra que la ubicación procesa código; no se probó en este lab. |
| R4 — API interna que divulga cuentas y roles | `GET /api/users` sobre HTTP/80. | Consulta con `curl -sS -i http://phantomcorp/api/users`, sin credenciales en el comando registrado. | [07-api-users.txt](evidencia/07-api-users.txt): HTTP 200, JSON con `admin`/`superuser`, `jperez`/`editor` y `mgomez`/`viewer`; nota `endpoint interno de RRHH - no exponer`. | Divulgación de cuentas válidas y privilegios declarados, útil para seleccionar objetivos. La respuesta no muestra contraseñas ni demuestra acceso como esos usuarios. | Preparar pruebas de autenticación dirigidas a usuarios existentes, incluida la cuenta administrativa, y evaluar controles frente a fuerza bruta o credential stuffing. La enumeración no demuestra que esas técnicas tengan éxito. |
| R5 — Identificación del CMS y archivo default público | `GET /` y `GET /phantomcms/VERSION` sobre HTTP/80. | `whatweb`, contraste con el HTML y enumeración dirigida mediante `dirb`; confirmación con `curl`. | [08-whatweb.txt](evidencia/08-whatweb.txt): `MetaGenerator[PhantomCMS 3.7]`, `X-Powered-By[PhantomCMS/3.7]`; [14-dirb-cms.txt](evidencia/14-dirb-cms.txt) encontró la ruta, y [15-cms-version.txt](evidencia/15-cms-version.txt) devolvió HTTP 200 con `PhantomCMS 3.7 (build 2024-11)`. | Fuga de producto, versión y build, y confirmación de un archivo default accesible que permite afinar la enumeración. Identificar el CMS no prueba una vulnerabilidad explotable. | Orientar la búsqueda de archivos y configuraciones del producto identificado y verificar su aplicabilidad. PhantomCMS es ficticio en el lab: no se le atribuye un CVE real; una coincidencia de versión, por sí sola, no autoriza a afirmar explotación. |

## 3. Preguntas de análisis

**P1 — Enumeración vs. recon.**

El **reconocimiento** construye un panorama amplio: qué puertos y servicios hay y qué versiones anuncian. La **enumeración** profundiza en un servicio identificado para descubrir rutas, archivos, métodos y datos que no aparecen en su página principal.

Dos ejemplos concretos del **Lab 05**, operado por Guadalupe y documentado por el grupo, son el barrido `nmap -Pn -p- phantomcorp`, que encontró el puerto 31337, y el banner grabbing `ncat -w3 phantomcorp 21 </dev/null`, que identificó `ProFTPD 1.3.5`. Ambas acciones aportaron al mapa de servicios; Lorenzo utilizó esa evidencia sin atribuirse su captura.

En el **Lab 06**, operado para este aporte, `dirb` probó 4612 rutas y encontró `/backup` (200) y `/admin` (403); después se confirmó el contenido público de `/backup/` con `curl`. Como segundo ejemplo, `curl -sS -i http://phantomcorp/api/users` reveló tres cuentas válidas y sus roles. Ya no se trata de saber que existe HTTP: se identificaron recursos y datos concretos dentro de ese servicio, como muestran las evidencias de R1 y R4.

Las etapas se complementan y sus técnicas pueden superponerse: el fingerprinting aporta identificación tanto al recon como a la enumeración. En este lab, conocer `PhantomCMS 3.7` permitió dirigir la búsqueda hasta `/phantomcms/VERSION`. Los resultados alimentan la planificación del Lab 07; no equivalen a haber explotado los riesgos potenciales.

**P2 — El `.git` expuesto.**

Pendiente — Parte B.

**P3 — El método `PUT`.**

En R3, [06-options.txt](evidencia/06-options.txt) registra `OPTIONS /` con
`Allow: GET, POST, PUT, DELETE, OPTIONS`. Según RFC 9110, `Allow` anuncia los
métodos asociados al recurso y `PUT` solicita crear o reemplazar su estado;
no define que ese estado deba ser un archivo en disco. Por eso, que aparezca
`PUT` no prueba una subida sin autenticación ni es una vulnerabilidad por sí
solo: puede ser legítimo en una API con autorización adecuada [C1].

**Ataque concreto posible, no ejecutado en este lab:** supongamos una
configuración que acepta escritura sin autorización en una ruta pública y
que ejecuta PHP en ella. Ruta e intérprete son supuestos del ejemplo, no
hallazgos del fingerprint de PhantomCMS.

1. El atacante envía `PUT /uploads/diagnostico.php` con una **webshell** como
   contenido: un script que recibe instrucciones y las ejecuta en el servidor.
2. El servidor acepta la petición y guarda ese contenido en una ubicación
   que el atacante puede solicitar por HTTP. Para afirmar una escritura real
   habría que comprobar el resultado, no solo un código de respuesta exitoso.
3. El atacante solicita `GET /uploads/diagnostico.php`. **Si** esa ubicación
   procesa PHP en lugar de servirlo como texto, el intérprete ejecuta la
   webshell con los permisos del proceso web. Podría acceder a datos de la
   aplicación o modificar recursos dentro de esos permisos; no implica
   automáticamente acceso de administrador [C2].

OWASP recomienda contrastar los métodos anunciados con su comportamiento y
verificar la recuperación del recurso escrito. Para el Lab 07, el primer paso
sería una comprobación autorizada con un archivo inerte y su recuperación,
antes de evaluar las condiciones de ejecución. En la evidencia actual solo
hay `OPTIONS`: no se probó escritura, la ruta del ejemplo ni ejecución.
Si se permitiera escritura arbitraria pero no ejecución, aún podría haber
alteración de contenido; el impacto debe ajustarse a lo que se demuestre [C2].

**Fuentes de la Parte C:**

- **[C1]** IETF. [RFC 9110, §9.3.4 — PUT](https://www.rfc-editor.org/rfc/rfc9110.html#name-put)
  y [§10.2.1 — Allow](https://www.rfc-editor.org/rfc/rfc9110.html#name-allow).
- **[C2]** OWASP WSTG v4.2. [Test HTTP Methods](https://wstg.owasp.org/v4.2/4-Web_Application_Security_Testing/02-Configuration_and_Deployment_Management_Testing/06-Test_HTTP_Methods/).
  Enumeración de métodos, comprobación de escritura e impacto potencial.
- **[C3]** OWASP WSTG v4.2. [Testing for Account Enumeration and Guessable User Account](https://wstg.owasp.org/v4.2/4-Web_Application_Security_Testing/03-Identity_Management_Testing/04-Testing_for_Account_Enumeration_and_Guessable_User_Account/).
  Utilidad de las cuentas válidas para dirigir pruebas de autenticación (R4).
- **[C4]** WhatWeb. [Documentación oficial](https://github.com/urbanadventurer/WhatWeb/blob/master/README.md).
  Identificación de tecnologías y versiones a partir de indicios de las respuestas (R5).

**P4 — Enumeración de usuarios.**

Pendiente — Parte D.

**P5 — Rol defensor (3 mitigaciones).**

Pendiente — Parte D.

## 4. Bitácora de comandos

### Preparación y alcance

- Rama existente `lab06-grupo07`, obtenida de `origin` y actualizada con `upstream/main` antes de operar. Identidad de commits: Lorenzo Blanc. No se realizó push.
- Docker Desktop estaba detenido y se inició con `docker desktop start`. Se construyeron las imágenes oficiales del atacante y del target, sin modificar sus fuentes. El target no publica puertos hacia el host.
- Toda la enumeración se hizo desde `cyberlab-attacker` contra `phantomcorp`, resuelto como `172.20.0.2` en esta ejecución. No se consultó el host de Git interno revelado por R2 ni ningún tercero.
- Fecha local: **01/11/2026**, aproximadamente 21:29–21:30 (UTC−3). Las respuestas y las herramientas del contenedor registran **02/11/2026 00:29–00:30 UTC**: es la misma ejecución.

Desde PowerShell, en la raíz del repositorio:

```powershell
git fetch origin
git fetch upstream
git switch --track origin/lab06-grupo07
git merge --no-edit upstream/main
docker desktop start
docker compose -p cyberlab --project-directory . -f entorno/docker-compose.yml -f labs/lab06-enumeracion-de-servicios/entorno/target.compose.yml up -d --build
docker exec -it cyberlab-attacker bash
```

Dentro del atacante, las salidas se guardaron en `/loot/lab06/`. El script [operar.sh](evidencia/operar.sh) registra la primera secuencia:

```bash
mkdir -p /loot/lab06
date -Is | tee /loot/lab06/01-fecha-contenedor.txt
ping -c1 phantomcorp | tee /loot/lab06/02-conectividad.txt
dirb http://phantomcorp/ /usr/share/dirb/wordlists/common.txt -r -S -o /loot/lab06/03-dirb.txt
curl -sS -i http://phantomcorp/backup/ | tee /loot/lab06/04-backup.txt
curl -sS -i http://phantomcorp/.git/config | tee /loot/lab06/05-git-config.txt
curl -sS -X OPTIONS -i http://phantomcorp/ | tee /loot/lab06/06-options.txt
curl -sS -i http://phantomcorp/api/users | tee /loot/lab06/07-api-users.txt
whatweb --color=never http://phantomcorp | tee /loot/lab06/08-whatweb.txt
curl -sS -i http://phantomcorp/ | tee /loot/lab06/09-index.txt
```

Para R5 se probó primero `/readme.html` (404) y luego otros nombres habituales de README, CHANGELOG y VERSION; las respuestas negativas se conservan en los archivos `10`, `11` y `13`. Una segunda ejecución de `dirb` con la wordlist común y extensiones `.txt,.html` realizó 9224 peticiones sin hallazgos (`12-dirb-archivos.txt`). Finalmente se armó una wordlist propia con nombres de archivos habituales y prefijos del CMS identificado; está adjunta completa como [cms-wordlist.txt](evidencia/cms-wordlist.txt). No deriva del código del target.

```bash
dirb http://phantomcorp/ /usr/share/dirb/wordlists/common.txt -X .txt,.html -r -S -o /loot/lab06/12-dirb-archivos.txt
# Copiar evidencia/cms-wordlist.txt a /loot/lab06/cms-wordlist.txt para repetir:
dirb http://phantomcorp/ /loot/lab06/cms-wordlist.txt -r -S -o /loot/lab06/14-dirb-cms.txt
curl -sS -i http://phantomcorp/phantomcms/VERSION | tee /loot/lab06/15-cms-version.txt
```

`-r` evita recursión y `-S` reduce el ruido de la salida; no cambian la wordlist. La búsqueda dirigida generó 819 candidatos y encontró un recurso con 200: `/phantomcms/VERSION`.

### Validación de flags y compatibilidad Windows

El primer envío desde PowerShell/Git Bash fue rechazado: la traza mostró que el argumento había llegado sin las llaves de `FLAG{...}`. Además, `git ls-files --eol` confirmó archivos del motor y manifiesto con LF en Git y CRLF en el checkout de Windows. Para evitar ambos problemas, se exportaron **sin modificar su contenido** `ctf`, `bin/lib/{ui,banner,check}.sh` y el manifiesto del Lab 06 desde `HEAD` a `.loot/lab06/validador/`, con LF. No se editaron fuentes versionadas ni hashes esperados.

El script [validar.sh](evidencia/validar.sh) se ejecutó dentro del atacante: extrajo cada flag de su respuesta HTTP capturada y ejecutó el `./ctf submit 06` oficial sobre esa copia del motor. Los cinco envíos fueron aceptados; se adjuntan los archivos `submit-R1.txt` a `submit-R5.txt` y `16-status-final.txt`. El archivo de progreso generado por el verificador se copió a `.progreso/06.done` del repositorio; después se ejecutó también `./ctf status 06` desde Git Bash en la raíz original, que confirmó 5/5 (`17-status-repo.txt`).

Para repetir los envíos en un checkout Unix con el motor oficial disponible, desde la raíz:

```bash
./ctf submit 06 R1 'FLAG{dir_enumeration_backup}'
./ctf submit 06 R2 'FLAG{git_repo_exposed}'
./ctf submit 06 R3 'FLAG{http_methods_put_enabled}'
./ctf submit 06 R4 'FLAG{user_enumeration_api}'
./ctf submit 06 R5 'FLAG{tech_fingerprint_phantomcms}'
./ctf status 06
```

La copia del motor, `.loot/` y `.progreso/` quedan locales y no se versionan. Las salidas relevantes se copiaron a `evidencia/`, dentro del directorio del grupo, para que el inventario pueda verificarse desde el repositorio.

### Revisión de la Parte C — Fernando, 02/11/2026

Se revisaron los archivos originales `06-options.txt`, `07-api-users.txt`,
`08-whatweb.txt`, `09-index.txt`, `14-dirb-cms.txt` y `15-cms-version.txt`.
Se contrastaron el header `Allow`, los tres usuarios y roles del JSON,
los indicios de WhatWeb y la versión/build del archivo default. Se conservaron
los bytes de todas las evidencias, las flags, P1 y la bitácora del operador.

Se comprobó la estructura Markdown, las seis columnas de cada fila del
inventario, la existencia de los enlaces locales y las fuentes oficiales.
La sintaxis de los bloques bash se revisó con `bash -n`, sin ejecutarlos.
Desde la raíz del repositorio se ejecutaron `git diff --check` y
`bash bin/validar-repo.sh`; los resultados de la validación corresponden a
compilación, sintaxis, manifiestos y documentación, no a nuevas operaciones
de enumeración o explotación. Ambos comandos finalizaron sin errores; la
validación general informó `VALIDACIÓN: todo OK`.

Entorno de revisión: Python 3.12.2 y Git Bash en Windows, solo biblioteca
estándar. Para la validación general se usó una función `python3` que delega
en el Python instalado, con la caché dirigida a una carpeta temporal externa
al repositorio.
