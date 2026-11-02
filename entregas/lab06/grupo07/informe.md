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

**Coordinación:** Lorenzo realiza la Parte A indicada para este aporte. El reparto original la asignaba a Fernando; las demás partes quedan pendientes de sus responsables y de la coordinación del grupo.

**Resto de integrantes:** pendiente de completar su declaración al incorporar sus aportes.

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

Pendiente de las partes B y C. La evidencia de la Parte A se adjunta en `evidencia/` para completar las filas sin inventar hallazgos.

| Hallazgo | Ruta/Método | Técnica | Evidencia | Riesgo | ¿Qué habilita para el Lab 07? |
|---|---|---|---|---|---|
| R1 — Directorios | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| R2 — Repositorio Git | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| R3 — Métodos HTTP | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| R4 — API de usuarios | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |
| R5 — Fingerprinting | Pendiente | Pendiente | Pendiente | Pendiente | Pendiente |

## 3. Preguntas de análisis

**P1 — Enumeración vs. recon.**

El **reconocimiento** construye un panorama amplio: qué puertos y servicios hay y qué versiones anuncian. La **enumeración** profundiza en un servicio identificado para descubrir rutas, archivos, métodos y datos que no aparecen en su página principal.

Dos ejemplos concretos del **Lab 05**, operado por Guadalupe y documentado por el grupo, son el barrido `nmap -Pn -p- phantomcorp`, que encontró el puerto 31337, y el banner grabbing `ncat -w3 phantomcorp 21 </dev/null`, que identificó `ProFTPD 1.3.5`. Ambas acciones aportaron al mapa de servicios; Lorenzo utilizó esa evidencia sin atribuirse su captura.

En el **Lab 06**, operado para este aporte, `dirb` probó 4612 rutas y encontró `/backup` (200) y `/admin` (403); después se confirmó el contenido público de `/backup/` con `curl`. Como segundo ejemplo, `curl -sS -i http://phantomcorp/api/users` reveló tres cuentas válidas y sus roles. Ya no se trata de saber que existe HTTP: se identificaron recursos y datos concretos dentro de ese servicio, como muestran las evidencias de R1 y R4.

Las etapas se complementan y sus técnicas pueden superponerse: el fingerprinting aporta identificación tanto al recon como a la enumeración. En este lab, conocer `PhantomCMS 3.7` permitió dirigir la búsqueda hasta `/phantomcms/VERSION`. Los resultados alimentan la planificación del Lab 07; no equivalen a haber explotado los riesgos potenciales.

**P2 — El `.git` expuesto.**

Pendiente — Parte B.

**P3 — El método `PUT`.**

Pendiente — Parte C.

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
