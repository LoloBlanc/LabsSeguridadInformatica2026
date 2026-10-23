# Informe — Laboratorio 04 · Marcos normativos y gestión

**Grupo:** 07 · **Integrantes:** Lorenzo Blanc — @LoloBlanc · Fernando Cagliero — @Ferca19 · Guadalupe Gómez — @guadagomezgg8 · Lautaro Mariño — @lautaromarino0

## 0. Declaración de uso de IA

Se utilizó el asistente de IA **Claude (Anthropic)**. Siguiendo lo que pide el `CONTRIBUTING.md`:

- **Qué herramienta:** Claude (Anthropic).
- **Qué partes:** Parte A (marco NIST CSF aplicado al escenario).
- **Para qué:** explicación de las funciones del marco y corrección de redacción del análisis.
- **Cómo se verificó:** el grupo revisó las correcciones y sugerencias de la IA, las aceptó y comprendió el mapeo.
- _(Completar cada integrante: usos de IA en la Parte B o el mini-research, si los hubo, y cómo lo verificó.)_

## 1. Parte A — Marco aplicado

### A.1 — Marco elegido y por qué

Para analizar la situación de PhantomCorp, elegimos el **NIST Cybersecurity Framework (CSF) 2.0**, ya que permite identificar las principales debilidades de seguridad de una organización y definir qué aspectos debería mejorar.

Este marco se organiza en seis funciones: **Govern (GV), Identify (ID), Protect (PR), Detect (DE), Respond (RS) y Recover (RC)**. En conjunto, permiten abordar la seguridad desde la gestión de riesgos y la prevención hasta la detección de incidentes y la recuperación. La versión 2.0, publicada en 2024, incorporó la función Govern, que se suma a las cinco funciones que tenía la versión anterior.

En el caso de PhantomCorp, el problema principal es que la organización todavía no cuenta con controles básicos de seguridad ni con un programa de seguridad suficientemente desarrollado. Por eso, el NIST CSF resulta útil para evaluar qué medidas faltan y establecer prioridades sin tener que implementar desde el principio un sistema de gestión completo.

Por otro lado, ISO/IEC 27001 también es una alternativa válida, pero está más orientada a establecer y mantener un sistema de gestión de seguridad de la información (SGSI), que puede incluir la posibilidad de obtener una certificación. Esto implica definir su alcance, documentar los controles aplicables y realizar auditorías, entre otras actividades.

En resumen, mientras que ISO 27001 permite organizar la gestión de la seguridad dentro de la empresa, el NIST CSF ayuda a identificar qué resultados de seguridad se necesitan y cuáles deberían ser las prioridades. Considerando la situación actual de PhantomCorp, nos parece más conveniente comenzar por esta última opción.

### A.2 — Cinco debilidades relacionadas con el marco

A partir del escenario planteado, identificamos cinco debilidades y las relacionamos con las funciones y categorías correspondientes del NIST CSF 2.0.

| N.º | Debilidad identificada | Función o categoría del CSF 2.0 | Medida que se debería implementar |
|---|---|---|---|
| 1 | El acceso remoto y la aplicación web no utilizan MFA. | PR.AA — Gestión de identidades, autenticación y control de acceso. | Incorporar un segundo factor de autenticación para reducir el riesgo de accesos no autorizados. |
| 2 | No existe una política de contraseñas. | PR.AA, PR.AT — Concientización y capacitación, y GV.PO — Política organizacional. | Definir reglas para el uso y almacenamiento de contraseñas, documentarlas y capacitar al personal. |
| 3 | Las copias de seguridad se guardan en un único disco dentro de la oficina. | PR.DS — Seguridad de los datos, y RC.RP — Ejecución del plan de recuperación. | Mantener copias adicionales, almacenar al menos una fuera de las instalaciones y probar periódicamente su restauración. |
| 4 | No hay un plan de respuesta ante incidentes. | RS.MA — Gestión de incidentes, y RC.RP — Ejecución del plan de recuperación. | Establecer un procedimiento de actuación, definir responsables y determinar cómo detectar, contener y resolver incidentes. |
| 5 | Los datos de tarjetas se almacenan en infraestructura propia expuesta a través de un servidor público. | PR.DS — Seguridad de los datos, DE.CM — Monitoreo continuo, y GV.OC — Contexto organizacional. | Proteger y monitorear la información sensible, y evaluar si es necesario mantener esos datos o si conviene delegar su procesamiento. |

Estas relaciones permiten ver qué aspectos de la seguridad están más comprometidos en PhantomCorp. Las primeras dos debilidades se relacionan principalmente con la protección de las identidades y los accesos. La tercera afecta tanto a la protección de la información como a la posibilidad de recuperarla si ocurre una falla.

La falta de un plan de respuesta también es importante, porque la empresa no tiene definido cómo actuar frente a un incidente. Finalmente, el almacenamiento de datos de tarjetas requiere una atención especial: además de implementar medidas técnicas, es necesario evaluar las responsabilidades y los requisitos de seguridad asociados a ese tipo de información.

De esta manera, el NIST CSF permite relacionar los problemas detectados con medidas concretas y organizar las mejoras según las necesidades de la organización.

### A.3 — Respuesta al riesgo para cada debilidad

Una vez identificados los problemas, se puede definir cómo actuar frente a cada uno de ellos. Las respuestas posibles incluyen mitigar, evitar, transferir o aceptar el riesgo, según las características de cada situación.

**1. Falta de MFA — Mitigar.**

La ausencia de un segundo factor de autenticación aumenta el riesgo de que una persona acceda al sistema utilizando credenciales robadas. Para reducirlo, proponemos implementar MFA mediante una aplicación de autenticación con TOTP, como la utilizada en el Laboratorio 03. Es una medida relativamente sencilla de incorporar y agrega una barrera adicional frente al acceso no autorizado.

**2. Falta de una política de contraseñas — Mitigar.**

En este caso, proponemos establecer una política que defina cómo deben gestionarse las contraseñas, junto con mecanismos seguros para almacenar sus hashes. Se puede utilizar PBKDF2, como se trabajó en el Laboratorio 03, y complementar la implementación con capacitación para los empleados. De esta manera, se reducen los riesgos asociados tanto a las contraseñas débiles como a su almacenamiento incorrecto.

**3. Copias de seguridad en un único disco — Mitigar.**

Guardar todas las copias de seguridad en un solo disco dentro de la oficina representa un riesgo importante. Si el disco falla, es robado o se ve afectado por un ransomware, la empresa podría perder la posibilidad de recuperar su información.

Para evitar esta situación, proponemos implementar la estrategia de respaldo **3-2-1**: mantener tres copias de los datos, utilizar dos tipos de medios de almacenamiento y conservar al menos una copia fuera de las instalaciones. También sería conveniente contar con una copia inmutable y realizar pruebas de restauración periódicas.

Además, el riesgo residual asociado a una pérdida física total de las instalaciones podría transferirse parcialmente mediante un seguro, aunque esto no reemplaza la necesidad de contar con copias de seguridad adecuadas.

**4. Ausencia de un plan de respuesta a incidentes — Mitigar.**

La falta de un procedimiento definido puede hacer que la empresa tarde más en responder ante un ataque y que sus consecuencias sean mayores. Por eso, proponemos elaborar un plan que establezca las acciones que se deben seguir, los responsables de cada tarea y los mecanismos de comunicación.

No alcanza con redactarlo: también es necesario realizar pruebas o simulaciones para comprobar que el personal sepa cómo actuar. Esto permitiría mejorar la capacidad de respuesta y reducir el impacto de posibles incidentes.

**5. Almacenamiento de datos de tarjetas en infraestructura propia — Evitar.**

En este caso, consideramos que una alternativa conveniente es dejar de almacenar los datos completos de las tarjetas en la infraestructura de PhantomCorp y delegar el procesamiento de los pagos a un proveedor especializado, como Mercado Pago o Stripe, según las condiciones del servicio.

Esta decisión permite reducir la cantidad de información sensible que la empresa necesita proteger y puede disminuir el alcance de las obligaciones relacionadas con PCI DSS. Sin embargo, no significa que desaparezcan todas las responsabilidades de seguridad o de cumplimiento: estas dependerán de cómo se integre el servicio y de las actividades que PhantomCorp continúe realizando.

Por eso, antes de implementar esta alternativa, sería necesario revisar el flujo de pagos y asegurarse de que los datos de las tarjetas no queden almacenados en los sistemas propios.

### Cierre

A partir del análisis, podemos observar que la mayoría de los problemas de PhantomCorp se deben a la falta de controles básicos de seguridad. Por este motivo, en los primeros cuatro casos proponemos mitigar los riesgos mediante medidas concretas, como incorporar MFA, definir una política de contraseñas, mejorar las copias de seguridad y establecer un plan de respuesta a incidentes.

En el caso de los datos de tarjetas, en cambio, consideramos que conviene evaluar si realmente es necesario que la empresa los almacene. Delegar el procesamiento de los pagos permitiría reducir la exposición a este tipo de información y simplificar parte de las obligaciones asociadas a su protección.

Por último, la aceptación del riesgo también puede ser una respuesta válida cuando el nivel de riesgo residual es conocido y la organización considera que puede asumirlo. Sin embargo, esa decisión debería estar justificada y no utilizarse simplemente porque implementar una medida de seguridad tiene un costo. Este criterio se puede profundizar en el análisis de riesgos de la Parte B.3.

### Fuentes consultadas

1. National Institute of Standards and Technology (NIST). *The NIST Cybersecurity Framework (CSF) 2.0*, NIST CSWP 29, 2024. Disponible en: https://www.nist.gov/cyberframework

2. PCI Security Standards Council. *Payment Card Industry Data Security Standard (PCI DSS)*. Disponible en: https://www.pcisecuritystandards.org

## 2. Parte B — Riesgo cuantitativo (ranking por ALE; ROI del control #1; un riesgo a aceptar/transferir)

### Implementación (`src/riesgo.py`)

| Función | Implementación |
|---|---|
| `ale(sle, aro)` | `sle * aro` |
| `roi_control(ale_antes, ale_despues, costo_anual)` | `(ale_antes - ale_despues - costo_anual) / costo_anual`; rechaza un costo ≤ 0 con `ValueError` |
| `priorizar(riesgos)` | Agrega el `ale` a una copia de cada riesgo y los ordena por `ale` descendente. No modifica la lista original. |

```text
$ python3 src/verificar.py
== Lab 04 · Riesgo cuantitativo ==
  ✓ ale()
  ✓ roi_control()
  ✓ priorizar() ordena por ALE

3 OK · 0 a revisar · 0 sin implementar

$ python3 src/riesgo.py ale --sle 50000 --aro 0.4
20000.00
$ python3 src/riesgo.py roi --antes 20000 --despues 5000 --costo 8000
0.875
```

El ROI que calcula `roi_control` es el **ROSI** (*Return on Security Investment*) descripto por ENISA: la reducción de la pérdida esperada (ALE sin el control − ALE con el control) menos el costo de la solución, dividido por ese costo [6]. Si el resultado es mayor a 0, el control se paga solo.

### Supuestos y origen de las cifras

Las cifras son **estimaciones del grupo apoyadas en fuentes públicas**. El mismo documento de ENISA advierte que el cálculo del ROSI "es el resultado de muchas aproximaciones" y que sus resultados deben tomarse con cuidado [6]. Por eso indicamos de dónde sale cada número y marcamos como **supuesto** lo que no proviene directamente de una fuente. Cifras verificadas el 22/10/2026.

**Perfil supuesto de PhantomCorp:** pyme de unos 40 empleados (todos con acceso remoto), unos 20.000 clientes con nombre, DNI y tarjeta guardados, y una facturación de ≈ USD 2,5 M/año (≈ USD 10.000 por día hábil). Todos los valores están en dólares estadounidenses.

| Riesgo | SLE (USD) | Cómo se estimó el SLE | ARO | Cómo se estimó el ARO |
|---|---:|---|---:|---|
| **R1** — Intrusión por el acceso remoto sin MFA (credenciales robadas) y robo de la base de clientes | 250.000 | Costo promedio de un incidente en pymes (empresas con menos de USD 2.000 M de facturación): **USD 246.000** según NetDiligence 2025 [3], redondeado. Es un valor conservador: IBM informa un promedio de USD 4,99 M a nivel global (2026) y de USD 2,51 M en Latinoamérica (2025) [4][5], pero esos promedios corresponden a organizaciones más grandes. | 0,3 | El abuso de credenciales es el vector de acceso inicial más frecuente (**22 %**) [1], y en pymes el uso de credenciales robadas es la variante de *hacking* más común (**33 %**) [2]. PhantomCorp no tiene MFA ni política de contraseñas, y la MFA reduce el riesgo de compromiso en un **99,22 %** [7]. **Supuesto:** un incidente cada 3 o 4 años. |
| **R2** — *Ransomware* que cifra los servidores y el único backup (disco en la oficina) | 180.000 | **Supuesto** construido por componentes: 10 días hábiles sin operar (100.000) + respuesta al incidente y reinstalación (50.000) + reconstrucción de datos (30.000), porque el disco de backup está en la misma red y también se cifra. No incluye el pago de un rescate (mediana pagada: **USD 115.000** [1]). | 0,2 | El *ransomware* aparece en el **44 %** de las brechas [1] y en el **88 %** de las brechas de pymes [2]. **Supuesto:** un incidente cada 5 años. |
| **R3** — Explotación de una vulnerabilidad del servidor web público (filtración parcial) | 150.000 | **Supuesto:** filtración de parte de la base + caída del sitio + aplicación de parches y análisis forense. Es menor que R1 porque el atacante obtiene lo que expone la aplicación, no un acceso completo a la red interna. | 0,1 | La explotación de vulnerabilidades representa el **20 %** de los accesos iniciales y sigue en aumento [1]. El escenario no indica que el servidor esté sin parches, por eso el ARO es menor que el de R1. **Supuesto:** un incidente cada 10 años. |
| **R4** — Siniestro físico en la oficina (incendio, inundación o robo) que destruye a la vez el servidor y el backup | 400.000 | **Supuesto:** reposición de equipos (40.000) + 20 días sin operar, porque se pierden juntos el servidor y el backup (200.000) + reconstrucción de datos y pérdida de clientes (160.000). | 0,01 | En EE. UU. se registran **3.340 incendios por año** en oficinas (promedio 2007–2011) [9] sobre unos **970.000** edificios de oficinas [10]. Esto da ≈ 0,34 % anual solo por incendio (orden de magnitud). Si sumamos inundación y robo, lo redondeamos a 1 % anual. |
| **R5** — Falla de hardware del disco de backup (sin redundancia) | 2.000 | **Supuesto:** disco nuevo + unas 20 h técnicas para rehacer los respaldos completos + días sin backup. | 0,0136 | Tasa anual de fallas (AFR) de discos en 2025: **1,36 %** (Backblaze) [8]. |

### B.1 — Ranking por ALE

```text
$ python3 src/riesgo.py priorizar --archivo riesgos.json
      75000.00  R1 - Intrusion por acceso remoto sin MFA (credenciales robadas) y robo de la base de clientes
      36000.00  R2 - Ransomware que cifra servidores y el unico backup (disco en la oficina)
      15000.00  R3 - Explotacion de una vulnerabilidad del servidor web publico (filtracion parcial)
       4000.00  R4 - Siniestro fisico en la oficina (incendio/inundacion/robo) que destruye servidor y backup
         27.20  R5 - Falla de hardware del disco de backup (sin redundancia)
```

| # | Riesgo | SLE (USD) | ARO | ALE (USD/año) | Debilidad de la Parte A |
|---:|---|---:|---:|---:|---|
| 1 | R1 — Acceso remoto sin MFA → robo de la base | 250.000 | 0,3 | **75.000** | 1 y 2 (sin MFA ni política de contraseñas) |
| 2 | R2 — *Ransomware* + backup único | 180.000 | 0,2 | **36.000** | 3 y 4 (backup único, sin plan de respuesta) |
| 3 | R3 — Explotación del servidor web | 150.000 | 0,1 | **15.000** | 5 (datos sensibles detrás de un servidor público) |
| 4 | R4 — Siniestro físico en la oficina | 400.000 | 0,01 | **4.000** | 3 (backup dentro de la misma oficina) |
| 5 | R5 — Falla del disco de backup | 2.000 | 0,0136 | **27,20** | 3 |

**¿Coincide con nuestra intuición?** En parte. Estos son los puntos donde coincide y donde no:

- **Coincide en el primer puesto.** El acceso remoto sin MFA es la vía más barata para un atacante: no necesita explotar ninguna falla, le alcanza con una contraseña filtrada o fácil de adivinar. R1 representa por sí solo el **58 %** del ALE total (75.000 de 130.027 USD/año).
- **No coincide en el *ransomware* (2.º).** Esperábamos que encabezara la lista, porque es la amenaza más mencionada. Queda segundo porque tanto su SLE como su ARO son menores que los de R1. Además, R1 y R2 **no son independientes**: una de las formas típicas en que entra un *ransomware* es justamente el acceso remoto con credenciales robadas. Como el ranking evalúa cada riesgo por separado, **subestima el beneficio de cerrar R1**. Para que el *ransomware* pasara al primer lugar, la relación ARO(R1)/ARO(R2) tendría que bajar de 1,5 a menos de 0,72. Es decir, tendríamos que haber sobrestimado el ARO de R1 en más del doble.
- **No coincide en el servidor web (3.º).** Intuitivamente, lo más visible (el sitio público) parece lo más peligroso. Sin embargo, para atacarlo hace falta que exista una vulnerabilidad explotable. En cambio, el acceso remoto sin MFA solo requiere una contraseña válida. El ALE da más peso a lo que es fácil y frecuente que a lo que más preocupa.
- **La mayor diferencia aparece en el siniestro físico (4.º).** Tiene el **SLE más alto de la tabla** (400.000, ≈ 16 % de la facturación anual), pero un ALE de solo 4.000 porque su ARO es de 0,01. Esto muestra una limitación del ALE: como es un promedio, trata igual una pérdida de 400.000 cada 100 años que una de 4.000 todos los años. Para una pyme, la primera puede significar el cierre. Por eso, el ALE sirve para **ordenar** los riesgos, pero no alcanza para **decidir** sobre los de baja probabilidad y alto impacto.
- **Coincide en que R5 queda último.** Una falla de disco no parece grave, y los números lo confirman (27 USD/año). Su peligro real aparece si se combina con otro evento: que el disco falle justo cuando hay que restaurar. La regla 3-2-1 propuesta en la Parte A elimina ese escenario.

**¿Qué tan firme es el ranking?** Los ARO son estimaciones, así que los valores absolutos son aproximados. Aun así, los **órdenes de magnitud** se mantienen: R1 a R3 están entre 15.000 y 75.000 USD/año, R4 está en el orden de los miles y R5 en el de las decenas. Para que R4 superara a R3, el ARO del siniestro físico tendría que ser casi 4 veces mayor (0,0375 en lugar de 0,01).

### B.2 — Control para el riesgo n.º 1 y ROI

> ⚠️ **PENDIENTE**.

### B.3 — Un riesgo a aceptar o transferir

> ⚠️ **PENDIENTE** (a cargo de otro integrante).

### Fuentes de la Parte B

1. Verizon. *2025 Data Breach Investigations Report* (comunicado del 23/04/2025): abuso de credenciales 22 %, explotación de vulnerabilidades 20 %, *ransomware* en el 44 % de las brechas, mediana del rescate pagado USD 115.000. https://www.verizon.com/about/news/2025-data-breach-investigations-report
2. Verizon. *2025 DBIR — SMB Snapshot*: *ransomware* en el 88 % de las brechas de pymes; uso de credenciales robadas, 33 %. https://www.verizon.com/business/resources/infographics/2025-dbir-smb-snapshot.pdf
3. NetDiligence. *Cyber Claims Study 2025* (vía Mondaq): costo promedio por incidente en pymes de USD 246.000 (período 2020–2024). https://www.mondaq.com/canada/security/1686464/netdiligence-releases-2025-cyber-claims-study-report
4. IBM. *Cost of a Data Breach Report 2026* (resumen de eSecurity Planet): costo promedio global de USD 4,99 M. https://www.esecurityplanet.com/cybersecurity/ibm-2026-cost-of-a-data-breach-report-key-findings/
5. IBM. *Cost of a Data Breach Report 2025*, datos de Latinoamérica (vía ComputerWeekly en español): USD 2,51 M. https://www.computerweekly.com/es/noticias/366633372/Uso-de-IA-y-automatizacion-reduce-el-costo-de-brechas-de-datos-en-LATAM
6. ENISA. *Introduction to Return on Security Investment*, diciembre de 2012. https://www.enisa.europa.eu/sites/default/files/publications/Return%20On%20Security%20Investment.pdf
7. Meyer, L. A. *et al.* *How effective is multifactor authentication at deterring cyberattacks?* Microsoft Research, mayo de 2023. https://www.microsoft.com/research/publication/how-effective-is-multifactor-authentication-at-deterring-cyberattacks/
8. Backblaze. *Backblaze Drive Stats for 2025* (12/02/2026): AFR 2025 de 1,36 %. https://www.backblaze.com/blog/backblaze-drive-stats-for-2025/
9. NFPA Journal, septiembre/octubre de 2013: 3.340 incendios por año en oficinas (promedio 2007–2011). https://nxtbook.com/nxtbooks/nfpa/journal_20130910/index.php?startid=72
10. U.S. EIA. *Commercial Buildings Energy Consumption Survey (CBECS) 2018*, tabla B4: 970.000 edificios de oficinas. https://www.eia.gov/consumption/commercial/data/2018/bc/html/b4.php

## 3. Anexo — `riesgos.json`

Archivo: [`riesgos.json`](riesgos.json). Los nombres van sin tildes a propósito: `riesgo.py` lo abre con `open()` sin indicar el *encoding*, y en Windows eso usa cp1252, por lo que los caracteres acentuados en UTF-8 saldrían mal.

```json
[
  {"nombre": "R1 - Intrusion por acceso remoto sin MFA (credenciales robadas) y robo de la base de clientes", "sle": 250000, "aro": 0.3},
  {"nombre": "R2 - Ransomware que cifra servidores y el unico backup (disco en la oficina)", "sle": 180000, "aro": 0.2},
  {"nombre": "R3 - Explotacion de una vulnerabilidad del servidor web publico (filtracion parcial)", "sle": 150000, "aro": 0.1},
  {"nombre": "R4 - Siniestro fisico en la oficina (incendio/inundacion/robo) que destruye servidor y backup", "sle": 400000, "aro": 0.01},
  {"nombre": "R5 - Falla de hardware del disco de backup (sin redundancia)", "sle": 2000, "aro": 0.0136}
]
```
