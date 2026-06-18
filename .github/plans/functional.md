# Documento funcional — Gestión de videoclub en Business Central

## 1. Introducción

### 1.1. Objetivo

El presente documento define los requisitos funcionales para la implantación en Microsoft Dynamics 365 Business Central de una solución orientada a la gestión operativa de un videoclub.

La solución permitirá gestionar el catálogo de películas, controlar la disponibilidad de copias físicas, registrar alquileres y devoluciones, y enriquecer la información de las películas mediante la importación de datos desde The Movie Database (TMDB).

Este documento está enfocado exclusivamente en procesos de negocio, comportamiento funcional, datos necesarios para la operación y responsabilidades de los usuarios.

### 1.2. Alcance funcional

La solución contempla los siguientes ámbitos:

- Gestión del catálogo de películas.
- Gestión de géneros cinematográficos.
- Gestión de actores y reparto asociado a cada película.
- Control de copias disponibles para alquiler.
- Registro de alquileres a clientes.
- Registro de devoluciones.
- Actualización automática de la información de películas desde TMDB.
- Definición de perfiles funcionales de usuario.
- Validación funcional de los procesos principales.

### 1.3. Fuera de alcance

Quedan fuera del alcance de este documento:

- Diseño técnico de objetos.
- Identificadores internos de tablas, páginas, extensiones o componentes.
- Detalles de programación.
- Implementación en AL.
- Definición técnica de llamadas HTTP.
- Estructuras internas de almacenamiento.
- Pruebas técnicas sobre código.
- Detalles de seguridad técnica o almacenamiento de credenciales.

---

## 2. Catálogo de películas

### 2.1. Descripción funcional

El sistema debe permitir mantener un catálogo de películas disponibles en el videoclub. Cada película se gestionará como un producto del catálogo de Business Central, identificado funcionalmente como película.

El catálogo debe permitir consultar y mantener la información necesaria para que el personal del videoclub pueda identificar correctamente cada título, conocer sus características principales y gestionar su alquiler.

### 2.2. Información funcional de la película

Para cada película se deberá poder registrar, consultar y mantener la siguiente información:

| Información | Descripción funcional |
|---|---|
| Título | Nombre comercial de la película. |
| Año de lanzamiento | Año de estreno de la película. |
| Director | Persona responsable de la dirección de la película. |
| Duración | Duración aproximada de la película en minutos. |
| Género principal | Género cinematográfico principal. |
| Género secundario | Género adicional, cuando aplique. |
| Sinopsis | Resumen argumental de la película. |
| Calificación por edad | Clasificación orientativa para el público. |
| Idioma original | Idioma original de la película. |
| Póster | Imagen o referencia visual asociada a la película. |
| Identificador externo TMDB | Referencia que permite relacionar la película con TMDB. |
| Reparto | Actores asociados a la película y papel interpretado. |

### 2.3. Géneros cinematográficos

El sistema debe permitir mantener una lista de géneros cinematográficos que puedan ser asociados a las películas.

Cada género tendrá un código o identificador funcional y una descripción comprensible para el usuario.

Ejemplos de géneros:

- Acción.
- Comedia.
- Drama.
- Terror.
- Ciencia ficción.
- Animación.
- Documental.

### 2.4. Actores

El sistema debe permitir mantener un maestro de actores con la información necesaria para identificar a las personas que forman parte del reparto de una película.

Para cada actor se deberá poder registrar:

| Información | Descripción funcional |
|---|---|
| Nombre | Nombre completo del actor o actriz. |
| Fecha de nacimiento | Fecha de nacimiento, cuando esté disponible. |
| Nacionalidad | País o nacionalidad principal. |

### 2.5. Reparto de una película

El sistema debe permitir asociar uno o varios actores a una película.

Para cada actor asociado a una película se deberá poder indicar:

| Información | Descripción funcional |
|---|---|
| Actor | Persona que participa en la película. |
| Papel | Personaje o rol interpretado. |
| Protagonista | Indicación de si forma parte del reparto principal. |

Una película podrá tener varios actores asociados, y un mismo actor podrá participar en varias películas.

---

## 3. Gestión de alquileres

### 3.1. Descripción funcional

El sistema debe permitir registrar el alquiler de una o varias películas a un cliente.

El proceso de alquiler debe reflejar que las copias entregadas dejan de estar disponibles temporalmente en el videoclub. Cuando el cliente devuelve las películas, el sistema debe volver a considerarlas disponibles.

### 3.2. Documento de alquiler

Cada alquiler se gestionará mediante un documento funcional compuesto por una cabecera y una o varias líneas.

### 3.3. Información de cabecera del alquiler

La cabecera del alquiler deberá contener la información general del préstamo:

| Información | Descripción funcional |
|---|---|
| Número de alquiler | Identificador único del alquiler. |
| Cliente | Cliente que realiza el alquiler. |
| Fecha de alquiler | Fecha en la que se entregan las películas al cliente. |

### 3.4. Información de líneas del alquiler

Cada línea representará una película alquilada.

| Información | Descripción funcional |
|---|---|
| Película | Película alquilada. |
| Cantidad | Número de copias alquiladas. |
| Fecha de devolución prevista | Fecha estimada en la que el cliente debe devolver la película. |
| Fecha de devolución real | Fecha en la que el cliente devuelve efectivamente la película. |

### 3.5. Registro del alquiler

El usuario debe poder registrar un alquiler cuando se entregan las películas al cliente.

Al registrar el alquiler:

- El sistema debe validar que el cliente esté informado.
- El sistema debe validar que exista al menos una película en el alquiler.
- El sistema debe validar que las películas indicadas sean alquilables.
- El sistema debe validar que exista disponibilidad suficiente.
- Las copias alquiladas deben dejar de estar disponibles para nuevos alquileres.
- El alquiler debe quedar identificado como registrado o entregado.
- El usuario debe poder consultar posteriormente qué películas están pendientes de devolución.

### 3.6. Registro de la devolución

El usuario debe poder registrar la devolución de una o varias películas alquiladas.

Al registrar la devolución:

- El sistema debe actualizar la fecha real de devolución.
- Las copias devueltas deben volver a estar disponibles para nuevos alquileres.
- El sistema debe permitir identificar si la devolución se ha producido en plazo o con retraso.
- Cuando todas las líneas estén devueltas, el alquiler debe considerarse finalizado.
- No debe permitirse devolver más unidades de las alquiladas.
- No debe permitirse devolver una película que ya conste como completamente devuelta.

### 3.7. Estados funcionales del alquiler

A efectos funcionales, los alquileres podrán encontrarse en los siguientes estados:

| Estado | Descripción |
|---|---|
| Borrador | El alquiler se está preparando y todavía no se han entregado las películas. |
| Registrado | El alquiler ha sido confirmado y las películas han sido entregadas al cliente. |
| Parcialmente devuelto | El cliente ha devuelto parte de las películas alquiladas. |
| Devuelto | Todas las películas han sido devueltas. |
| Vencido | Existen películas cuya fecha prevista de devolución ha sido superada. |

### 3.8. Control de disponibilidad

El sistema debe permitir conocer la disponibilidad de cada película para evitar alquilar más copias de las existentes.

La disponibilidad funcional deberá tener en cuenta:

- Copias existentes.
- Copias actualmente alquiladas.
- Copias disponibles para nuevos alquileres.
- Copias pendientes de devolución.

---

## 4. Experiencia de usuario

### 4.1. Gestión del catálogo

El usuario deberá poder acceder a una vista de películas desde la que pueda:

- Buscar películas por título.
- Filtrar películas por género.
- Consultar información detallada de una película.
- Consultar el reparto asociado.
- Identificar si una película está disponible para alquiler.
- Acceder a la importación de datos desde TMDB.

### 4.2. Gestión de actores

El usuario deberá poder:

- Consultar el listado de actores.
- Crear nuevos actores.
- Modificar información de actores existentes.
- Consultar en qué películas participa un actor, cuando esta información esté disponible.

### 4.3. Gestión de géneros

El usuario deberá poder:

- Consultar los géneros existentes.
- Crear nuevos géneros.
- Modificar descripciones de géneros.
- Asociar géneros a películas.

### 4.4. Gestión de alquileres

El usuario deberá poder:

- Crear un nuevo alquiler para un cliente.
- Añadir una o varias películas al alquiler.
- Indicar cantidades y fechas previstas de devolución.
- Registrar la entrega de películas.
- Registrar devoluciones.
- Consultar alquileres abiertos.
- Consultar alquileres vencidos.
- Consultar el histórico de alquileres de un cliente.

---

## 5. Integración con TMDB

### 5.1. Descripción funcional

La solución debe permitir importar información de películas desde The Movie Database, con el objetivo de reducir la carga manual de datos y mejorar la calidad del catálogo.

La importación se realizará a petición del usuario desde la ficha funcional de la película.

### 5.2. Proceso funcional de importación

El proceso funcional será el siguiente:

1. El usuario accede a la película que desea completar o actualizar.
2. El usuario solicita importar información desde TMDB.
3. El sistema solicita un título de búsqueda.
4. El sistema muestra una lista de posibles coincidencias.
5. El usuario selecciona la película correcta.
6. El sistema recupera la información disponible.
7. El usuario puede revisar los datos importados.
8. El sistema actualiza la información de la película.

### 5.3. Datos importables

La integración deberá permitir importar, cuando estén disponibles, los siguientes datos:

| Información | Uso funcional |
|---|---|
| Año de lanzamiento | Completar los datos básicos de la película. |
| Director | Identificar la dirección de la película. |
| Duración | Informar la duración aproximada. |
| Sinopsis | Completar la descripción comercial. |
| Géneros | Clasificar la película. |
| Calificación por edad | Ayudar al usuario a informar restricciones orientativas. |
| Póster | Añadir referencia visual. |
| Reparto | Crear o actualizar actores asociados a la película. |
| Identificador TMDB | Mantener la relación con la fuente externa. |

### 5.4. Reglas funcionales de importación

La importación deberá cumplir las siguientes reglas:

- La importación siempre será iniciada manualmente por un usuario.
- El usuario deberá seleccionar la película correcta cuando existan varias coincidencias.
- El sistema no deberá sobrescribir información existente sin una lógica clara de confirmación o actualización.
- Si un actor importado ya existe en el sistema, deberá reutilizarse en lugar de duplicarse.
- Si un género importado ya existe, deberá reutilizarse.
- Si un género o actor no existe, el sistema podrá proponer su creación.
- Si TMDB no devuelve algún dato, el sistema deberá dejar el campo correspondiente sin modificar o pendiente de completar.
- El sistema deberá informar al usuario cuando la importación no pueda completarse.

### 5.5. Idioma de los datos

La información importada deberá obtenerse preferentemente en español, siempre que TMDB disponga de dichos datos.

Cuando no exista información en español, el sistema podrá informar al usuario o utilizar el dato disponible según el criterio funcional definido por el negocio.

---

## 6. Roles y permisos funcionales

### 6.1. Administrador del videoclub

El perfil administrador debe poder realizar todas las operaciones funcionales de la solución.

Responsabilidades principales:

- Mantener el catálogo de películas.
- Mantener géneros.
- Mantener actores.
- Corregir datos importados.
- Gestionar alquileres y devoluciones.
- Consultar información histórica.
- Configurar parámetros funcionales necesarios para la operación.

### 6.2. Empleado de mostrador

El perfil empleado de mostrador debe estar orientado a la operativa diaria.

Responsabilidades principales:

- Consultar el catálogo de películas.
- Consultar disponibilidad.
- Crear alquileres.
- Registrar entregas.
- Registrar devoluciones.
- Consultar alquileres pendientes o vencidos.
- Consultar información básica de clientes.

### 6.3. Restricciones funcionales

El sistema debe garantizar que:

- Solo los usuarios autorizados puedan modificar datos maestros.
- Los empleados de mostrador puedan operar alquileres sin necesidad de acceder a configuración avanzada.
- Los datos sensibles de configuración no sean visibles para usuarios operativos.
- Las operaciones críticas queden restringidas a perfiles autorizados.

---

## 7. Reglas de negocio

### 7.1. Reglas sobre películas

- Solo las películas marcadas como alquilables podrán incluirse en un alquiler.
- Una película deberá tener un título informado.
- El género principal será recomendable para facilitar filtros y búsquedas.
- La calificación por edad deberá utilizar valores homogéneos definidos por el negocio.
- El identificador TMDB deberá ser único cuando esté informado.

### 7.2. Reglas sobre alquileres

- Un alquiler debe estar asociado a un cliente.
- Un alquiler debe contener al menos una película.
- No se debe permitir registrar un alquiler sin disponibilidad suficiente.
- La fecha prevista de devolución no debe ser anterior a la fecha de alquiler.
- La devolución real no debe ser anterior a la fecha de alquiler.
- Un alquiler completamente devuelto debe quedar cerrado funcionalmente.
- Los alquileres con fecha prevista vencida y sin devolución completa deben poder identificarse fácilmente.

### 7.3. Reglas sobre clientes

- El cliente debe existir antes de registrar un alquiler.
- El sistema debe permitir consultar los alquileres activos de un cliente.
- El sistema debe permitir consultar el histórico de alquileres de un cliente.

### 7.4. Reglas sobre actores y géneros

- No deberán generarse duplicados innecesarios de actores.
- No deberán generarse duplicados innecesarios de géneros.
- Una película podrá tener varios actores asociados.
- Un actor podrá estar asociado a varias películas.

---

## 8. Validaciones funcionales

### 8.1. Validaciones del catálogo

Se deberán validar los siguientes escenarios:

| Escenario | Resultado esperado |
|---|---|
| Alta de película con datos mínimos | La película queda disponible para completar su información. |
| Asociación de género principal | La película queda correctamente clasificada. |
| Asociación de actores | El reparto queda vinculado a la película. |
| Importación desde TMDB con coincidencia válida | La película se actualiza con los datos seleccionados. |
| Importación sin resultados | El usuario recibe un aviso comprensible. |

### 8.2. Validaciones del alquiler

Se deberán validar los siguientes escenarios:

| Escenario | Resultado esperado |
|---|---|
| Alquiler con disponibilidad suficiente | El alquiler se registra correctamente. |
| Alquiler sin cliente | El sistema impide el registro. |
| Alquiler sin líneas | El sistema impide el registro. |
| Alquiler sin stock disponible | El sistema impide el registro. |
| Devolución completa | El alquiler queda finalizado. |
| Devolución parcial | El alquiler queda parcialmente devuelto. |
| Devolución fuera de plazo | El alquiler queda identificable como vencido o devuelto con retraso. |

### 8.3. Validaciones de permisos funcionales

Se deberán validar los siguientes escenarios:

| Escenario | Resultado esperado |
|---|---|
| Administrador modifica datos maestros | La operación está permitida. |
| Empleado registra alquiler | La operación está permitida. |
| Empleado registra devolución | La operación está permitida. |
| Empleado modifica configuración funcional | La operación está restringida. |

---

## 9. Requisitos funcionales

| Requisito | Título | Descripción |
|---|---|---|
| RF-001 | Catálogo de películas | El sistema debe permitir mantener películas con información cinematográfica y datos de disponibilidad. |
| RF-002 | Gestión de géneros | El sistema debe permitir mantener y asociar géneros cinematográficos. |
| RF-003 | Gestión de actores | El sistema debe permitir mantener actores y asociarlos al reparto de películas. |
| RF-004 | Gestión de alquileres | El sistema debe permitir registrar alquileres de películas a clientes. |
| RF-005 | Gestión de devoluciones | El sistema debe permitir registrar devoluciones y actualizar la disponibilidad. |
| RF-006 | Control de disponibilidad | El sistema debe impedir alquileres sin copias disponibles. |
| RF-007 | Integración TMDB | El sistema debe permitir importar datos de películas desde TMDB mediante una acción iniciada por el usuario. |
| RF-008 | Roles funcionales | El sistema debe diferenciar responsabilidades entre administrador y empleado de mostrador. |
| RF-009 | Consulta operativa | El sistema debe permitir consultar alquileres abiertos, vencidos e históricos. |
| RF-010 | Validaciones funcionales | El sistema debe contemplar validaciones de negocio para catálogo, alquileres, devoluciones e importación. |

---

## 10. Criterios de aceptación

### 10.1. Catálogo

- El usuario puede crear y consultar películas.
- El usuario puede clasificar películas por género.
- El usuario puede asociar actores a películas.
- El usuario puede consultar el reparto de una película.
- El usuario puede identificar la disponibilidad de una película.

### 10.2. Alquileres

- El usuario puede crear un alquiler para un cliente.
- El usuario puede añadir una o varias películas al alquiler.
- El sistema impide alquilar películas sin disponibilidad suficiente.
- El sistema reduce funcionalmente la disponibilidad al registrar el alquiler.
- El sistema permite registrar devoluciones parciales y completas.
- El sistema incrementa funcionalmente la disponibilidad al registrar la devolución.
- El sistema permite identificar alquileres pendientes y vencidos.

### 10.3. Integración TMDB

- El usuario puede buscar una película en TMDB por título.
- El usuario puede seleccionar una coincidencia de una lista de resultados.
- El sistema importa los datos disponibles de la película seleccionada.
- El usuario recibe avisos claros cuando no existan resultados o se produzca un error.
- El sistema evita duplicidades funcionales de actores y géneros cuando sea posible.

### 10.4. Seguridad funcional

- El administrador puede gestionar todos los datos funcionales.
- El empleado de mostrador puede realizar la operativa diaria.
- Los usuarios sin permisos adecuados no pueden modificar configuración ni datos maestros restringidos.