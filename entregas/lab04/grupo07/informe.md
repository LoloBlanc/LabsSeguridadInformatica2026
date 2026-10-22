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

> ⚠️ **PENDIENTE (Partes 2 y 3 del reparto).**

## 3. Anexo — `riesgos.json`

> ⚠️ **PENDIENTE (Parte 2 del reparto).**
