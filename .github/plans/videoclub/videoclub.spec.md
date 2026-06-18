# videoclub — Technical Specification

**Version:** 1.0  
**Date:** 2026-06-18  
**Complexity:** HIGH  
**Status:** Draft  

## 1. Overview

### Business Context
La extensión gestiona la operativa de un videoclub en Business Central: catálogo de películas, géneros, actores, reparto, disponibilidad de copias físicas, alquileres, devoluciones e importación bajo demanda de metadatos desde TMDB.

### Scope
Incluye el blueprint técnico para objetos AL, modelo de datos, páginas, codeunits, eventos propios, permisos, estrategia de pruebas y handoff TDD. Excluye implementación real en `/src`, descarga de símbolos, compilación, publicación, conexión a entornos Business Central y consumo real de TMDB.

### Architecture Reference
Implementa la arquitectura aprobada en `.github/plans/architecture.md`: películas como `Item` extendido, stock funcional propio, documentos propios de alquiler, integración TMDB por capas, eventos `IntegrationEvent`, permisos por rol y pruebas AL orientadas a TDD. No se usa `.github/plans/videoclub/videoclub.architecture.md` como referencia.

### Framework Grounding
Esta especificación aplica las micro-reglas de `.github/instructions/al-naming-conventions.instructions.md`, `.github/instructions/al-code-style.instructions.md`, `.github/instructions/al-events.instructions.md`, `.github/instructions/al-performance.instructions.md` y `.github/instructions/al-testing.instructions.md`: PascalCase, nombres de objeto de máximo 30 caracteres, organización por feature, `DataClassification` por campo, lógica fuera de páginas, eventos `OnBefore/OnAfter`, sin `Commit` en subscribers, filtros antes de lecturas y pruebas Given/When/Then. Se han usado además los patrones de `skill-events`, `skill-pages`, `skill-permissions` y `skill-testing` como referencia de diseño.

---

## 2. AL Object Inventory

> **Rango de IDs:** no existe `app.json` en el repositorio en la fecha de esta especificación; por tanto, los IDs `50100..50149` son una propuesta provisional típica para extensiones per-tenant y deben validarse contra el `app.json` definitivo antes de implementar. La búsqueda textual no encontró objetos AL existentes, por lo que no hay colisiones locales conocidas.

| Object Type | Object ID | Name | Extends / Source | Purpose |
|-------------|-----------|------|------------------|---------|
| TableExtension | 50100 | VC Item Ext | Item | Campos de película, disponibilidad funcional y referencia TMDB. |
| Table | 50101 | VC Genre | — | Maestro de géneros cinematográficos. |
| Table | 50102 | VC Actor | — | Maestro de actores. |
| Table | 50103 | VC Movie Cast | — | Relación película-actor-personaje. |
| Table | 50104 | VC Rental Header | — | Cabecera del documento de alquiler/devolución. |
| Table | 50105 | VC Rental Line | — | Líneas de películas alquiladas y devueltas. |
| Table | 50106 | VC TMDB Setup | — | Configuración de integración TMDB. |
| Table | 50107 | VC TMDB Import Log | — | Auditoría técnica/funcional de operaciones TMDB. |
| Enum | 50108 | VC Rental Status | — | Estado de cabecera de alquiler. |
| Enum | 50109 | VC Rental Line Status | — | Estado de línea de alquiler. |
| Enum | 50110 | VC TMDB Operation | — | Tipo de operación TMDB. |
| Enum | 50111 | VC Integration Status | — | Resultado de operación de integración. |
| Page | 50112 | VC Genre List | VC Genre | Mantenimiento de géneros. |
| Page | 50113 | VC Actor List | VC Actor | Lista de actores. |
| Page | 50114 | VC Actor Card | VC Actor | Ficha de actor. |
| Page | 50115 | VC Movie Cast Part | VC Movie Cast | Subpágina de reparto en película. |
| Page | 50116 | VC Movie List | Item | Lista filtrada de películas. |
| Page | 50117 | VC Movie Card | Item | Ficha de película. |
| Page | 50118 | VC Actor Films Part | VC Movie Cast | Filmografía del actor. |
| Page | 50119 | VC Rental List | VC Rental Header | Consulta general de alquileres. |
| Page | 50120 | VC Rental Document | VC Rental Header | Documento cabecera/líneas para alquileres y devoluciones. |
| Page | 50121 | VC Rental Lines Part | VC Rental Line | Subpágina de líneas de alquiler. |
| Page | 50122 | VC Open Rentals | VC Rental Header | Alquileres abiertos o parcialmente devueltos. |
| Page | 50123 | VC Overdue Rentals | VC Rental Header | Alquileres vencidos. |
| Page | 50124 | VC TMDB Setup Card | VC TMDB Setup | Configuración TMDB. |
| Page | 50125 | VC TMDB Import Log | VC TMDB Import Log | Consulta de logs TMDB. |
| PageExtension | 50126 | VC Item Card Ext | Item Card | FastTab Videoclub y acciones de película/TMDB. |
| PageExtension | 50127 | VC Item List Ext | Item List | Indicador y navegación de películas. |
| PageExtension | 50128 | VC Customer Card Ext | Customer Card | Navegación a alquileres del cliente. |
| PageExtension | 50129 | VC Customer List Ext | Customer List | Histórico de alquileres por cliente. |
| PageExtension | 50130 | VC Role Center Ext | Role Center pendiente | Cues/listas de alquileres; página base pendiente de validación. |
| Codeunit | 50131 | VC Movie Mgt | — | Utilidades y validaciones de película. |
| Codeunit | 50132 | VC Availability Mgt | — | Cálculo y validación de disponibilidad. |
| Codeunit | 50133 | VC Rental Validation | — | Validaciones de alquiler/devolución. |
| Codeunit | 50134 | VC Rental Status Mgt | — | Recalcula estados de cabecera/línea. |
| Codeunit | 50135 | VC Rental Mgt | — | Orquesta registro de alquileres y devoluciones. |
| Codeunit | 50136 | VC No Series Mgt | — | Inicialización y asignación de números. |
| Codeunit | 50137 | VC TMDB Mgt | — | Fachada de búsqueda/importación/refresco TMDB. |
| Codeunit | 50138 | VC TMDB HTTP Client | — | Encapsula HttpClient y errores técnicos. |
| Codeunit | 50139 | VC TMDB Mapper | — | Normaliza JSON TMDB a buffers/registros temporales. |
| Codeunit | 50140 | VC TMDB Movie Import | — | Aplica datos TMDB a Item, géneros, actores y reparto. |
| Codeunit | 50141 | VC TMDB Error Handler | — | Mensajes de error y log TMDB. |
| Codeunit | 50142 | Library - VC Videoclub | — | Helpers de test para datos de videoclub. |
| Codeunit | 50143 | VC Rental Tests | — | Tests de alquiler/disponibilidad/estados. |
| Codeunit | 50144 | VC TMDB Tests | — | Tests con cliente fake o payloads controlados. |
| PermissionSet | 50145 | VC VIDEOCLUB BASE | — | Capa no asignable común. |
| PermissionSet | 50146 | VC VIDEOCLUB READ | — | Consulta. |
| PermissionSet | 50147 | VC VIDEOCLUB USER | — | Operación diaria. |
| PermissionSet | 50148 | VC VIDEOCLUB ADMIN | — | Administración y configuración. |

---

## 3. Data Model

### 3.1 TableExtension 50100 `VC Item Ext` extends `Item`

```al
tableextension 50100 "VC Item Ext" extends Item
{
  fields
  {
    field(50100; "VC Is Movie"; Boolean) { DataClassification = CustomerContent; }
    field(50101; "VC Release Year"; Integer) { DataClassification = CustomerContent; MinValue = 1888; }
    field(50102; "VC Director"; Text[100]) { DataClassification = CustomerContent; }
    field(50103; "VC Duration Minutes"; Integer) { DataClassification = CustomerContent; MinValue = 0; }
    field(50104; "VC Primary Genre Code"; Code[20]) { TableRelation = "VC Genre".Code; DataClassification = CustomerContent; }
    field(50105; "VC Secondary Genre Code"; Code[20]) { TableRelation = "VC Genre".Code; DataClassification = CustomerContent; }
    field(50106; "VC Synopsis"; Text[2048]) { DataClassification = CustomerContent; }
    field(50107; "VC Age Rating"; Code[20]) { DataClassification = CustomerContent; }
    field(50108; "VC Original Language"; Code[10]) { DataClassification = CustomerContent; }
    field(50109; "VC Poster URL"; Text[250]) { DataClassification = CustomerContent; ExtendedDatatype = URL; }
    field(50110; "VC TMDB ID"; Integer) { DataClassification = CustomerContent; }
    field(50111; "VC Rental Copies"; Decimal) { DataClassification = CustomerContent; MinValue = 0; DecimalPlaces = 0 : 0; }
    field(50112; "VC Rented Quantity"; Decimal) { FieldClass = FlowField; CalcFormula = sum("VC Rental Line"."Outstanding Qty." where("Movie Item No." = field("No."))); }
    field(50113; "VC Available Quantity"; Decimal) { FieldClass = FlowField; CalcFormula = min("VC Rental Line"."Outstanding Qty." where("Movie Item No." = field("No."))); } // Placeholder only; see note below.
    field(50114; "VC Rentable"; Boolean) { DataClassification = CustomerContent; InitValue = true; }
  }
}
```

> Nota: `VC Available Quantity` no debe implementarse con el placeholder anterior; Business Central no soporta un FlowField aritmético directo `Rental Copies - Rented Quantity`. El implementador debe calcular la disponibilidad vía `VC Availability Mgt.GetAvailableQuantity()` y decidir si se elimina este campo FlowField, se convierte en campo normal actualizado o se sustituye por una page variable. Esta decisión queda explicitada para evitar inventar una fórmula compilable no validada.

### 3.2 Table 50101 `VC Genre`

| Field No. | Field Name | Type | Length | Required | Relation | Description |
|-----------|------------|------|--------|----------|----------|-------------|
| 1 | Code | Code | 20 | Yes | PK | Código de género. |
| 2 | Description | Text | 100 | Yes | — | Descripción visible. |
| 3 | Blocked | Boolean | — | No | — | Bloquea selección en nuevas películas. |
| 4 | TMDB Genre ID | Integer | — | No | — | Identificador externo TMDB. |
| 5 | SystemCreatedAt/SystemModifiedAt | System | — | Auto | — | Auditoría estándar. |

**Keys:** `PK(Code)`, `TMDBGenreID(TMDB Genre ID)` no clustered.  
**DataClassification:** campos de negocio `CustomerContent`; campos sistema `SystemMetadata`.

### 3.3 Table 50102 `VC Actor`

| Field No. | Field Name | Type | Length | Required | Relation | Description |
|-----------|------------|------|--------|----------|----------|-------------|
| 1 | No. | Code | 20 | Yes | PK/No. Series | Identificador actor. |
| 2 | Name | Text | 100 | Yes | — | Nombre artístico o legal. |
| 3 | Birth Date | Date | — | No | — | Fecha de nacimiento. |
| 4 | Nationality | Text | 50 | No | — | Nacionalidad. |
| 5 | Biography | Text | 2048 | No | — | Biografía resumida. |
| 6 | TMDB Person ID | Integer | — | No | — | Identificador TMDB. |
| 7 | Blocked | Boolean | — | No | — | Bloquea selección. |

**Keys:** `PK(No.)`, `Name(Name)`, `TMDBPersonID(TMDB Person ID)` no clustered.

### 3.4 Table 50103 `VC Movie Cast`

| Field No. | Field Name | Type | Length | Required | Relation | Description |
|-----------|------------|------|--------|----------|----------|-------------|
| 1 | Movie Item No. | Code | 20 | Yes | Item.No. where VC Is Movie | Película. |
| 2 | Line No. | Integer | — | Yes | PK | Línea. |
| 3 | Actor No. | Code | 20 | Yes | VC Actor.No. | Actor. |
| 4 | Character Name | Text | 100 | No | — | Papel interpretado. |
| 5 | Cast Order | Integer | — | No | — | Orden de reparto. |
| 6 | TMDB Credit ID | Text | 50 | No | — | Identificador crédito TMDB. |

**Keys:** `PK(Movie Item No., Line No.)`, `ActorMovie(Actor No., Movie Item No.)`, `CastOrder(Movie Item No., Cast Order)`.

### 3.5 Table 50104 `VC Rental Header`

| Field No. | Field Name | Type | Length | Required | Relation | Description |
|-----------|------------|------|--------|----------|----------|-------------|
| 1 | No. | Code | 20 | Yes | PK/No. Series | Documento de alquiler. |
| 2 | Customer No. | Code | 20 | Yes | Customer.No. | Cliente. |
| 3 | Customer Name | Text | 100 | Auto | Customer.Name | Nombre copiado para lectura histórica. |
| 4 | Rental Date | Date | Yes | — | Fecha entrega. |
| 5 | Due Date | Date | Yes | — | Fecha prevista devolución. |
| 6 | Return Date | Date | No | — | Fecha devolución completa. |
| 7 | Status | Enum | VC Rental Status | Yes | — | Estado cabecera. |
| 8 | No. Series | Code | 20 | No | No. Series | Serie usada. |
| 9 | External Reference | Text | 50 | No | — | Referencia opcional. |
| 10 | Comment | Text | 250 | No | — | Comentario operativo. |

**Keys:** `PK(No.)`, `CustomerStatus(Customer No., Status)`, `DueStatus(Due Date, Status)`.

### 3.6 Table 50105 `VC Rental Line`

| Field No. | Field Name | Type | Length | Required | Relation | Description |
|-----------|------------|------|--------|----------|----------|-------------|
| 1 | Document No. | Code | 20 | Yes | VC Rental Header.No. | Cabecera. |
| 2 | Line No. | Integer | — | Yes | PK | Línea. |
| 3 | Movie Item No. | Code | 20 | Yes | Item.No. where VC Is Movie | Película alquilada. |
| 4 | Description | Text | 100 | Auto | Item.Description | Título copiado. |
| 5 | Quantity | Decimal | — | Yes | — | Cantidad alquilada. Decimal con `DecimalPlaces = 0:0`. |
| 6 | Returned Quantity | Decimal | — | Yes | — | Cantidad devuelta. |
| 7 | Outstanding Qty. | Decimal | — | Auto | — | Pendiente = Quantity - Returned Quantity. |
| 8 | Rental Date | Date | Auto | Header | Fecha entrega copiada o FlowField. |
| 9 | Due Date | Date | Auto | Header | Vencimiento copiado o FlowField. |
| 10 | Last Return Date | Date | No | — | Última devolución. |
| 11 | Status | Enum | VC Rental Line Status | Yes | — | Estado línea. |

**Keys:** `PK(Document No., Line No.)`, `MovieOutstanding(Movie Item No., Status)`, `DueStatus(Due Date, Status)`.  
**SIFT:** evaluar `SumIndexFields = Outstanding Qty.` en `MovieOutstanding` para permitir `CalcSums`.

### 3.7 Table 50106 `VC TMDB Setup`

| Field No. | Field Name | Type | Length | Required | Relation | Description |
|-----------|------------|------|--------|----------|----------|-------------|
| 1 | Primary Key | Code | 10 | Yes | PK | Valor fijo, por ejemplo `SETUP`. |
| 2 | API Base URL | Text | 250 | Yes | — | URL base TMDB. |
| 3 | API Key / Token Ref. | Text | 250 | Yes | — | Referencia segura al secreto, no mostrar en claro. |
| 4 | Default Language | Code | 10 | No | — | Idioma búsqueda/importación. |
| 5 | Include Adult | Boolean | No | — | Candidatos adultos. |
| 6 | Enabled | Boolean | Yes | — | Activa integración. |
| 7 | Last Test DateTime | DateTime | No | — | Última prueba de conexión. |

**Open security note:** el mecanismo exacto para secretos debe validarse contra la versión BC objetivo.

### 3.8 Table 50107 `VC TMDB Import Log`

| Field No. | Field Name | Type | Length | Required | Relation | Description |
|-----------|------------|------|--------|----------|----------|-------------|
| 1 | Entry No. | Integer | Yes | PK/AutoIncrement | Secuencia log. |
| 2 | Operation | Enum | VC TMDB Operation | Yes | — | Search/Import/Refresh. |
| 3 | Status | Enum | VC Integration Status | Yes | — | Success/Warning/Error. |
| 4 | Movie Item No. | Code | 20 | No | Item.No. | Película afectada. |
| 5 | TMDB ID | Integer | No | — | ID externo. |
| 6 | Message | Text | 250 | No | — | Mensaje resumido. |
| 7 | Details | Text | 2048 | No | — | Detalle técnico controlado. |
| 8 | Created DateTime | DateTime | Yes | — | Fecha/hora. |
| 9 | User ID | Code | 50 | Yes | User | Usuario. |

### 3.9 Enums

```al
enum 50108 "VC Rental Status" { value(0; Draft) { } value(1; Registered) { } value(2; "Partially Returned") { } value(3; Returned) { } value(4; Overdue) { } }
enum 50109 "VC Rental Line Status" { value(0; Draft) { } value(1; Outstanding) { } value(2; "Partially Returned") { } value(3; Returned) { } value(4; Overdue) { } }
enum 50110 "VC TMDB Operation" { value(0; Search) { } value(1; Import) { } value(2; Refresh) { } }
enum 50111 "VC Integration Status" { value(0; Success) { } value(1; Warning) { } value(2; Error) { } }
```

---

## 4. Business Logic — Codeunit Procedures

### 4.1 Codeunit 50131 `VC Movie Mgt`

```al
procedure EnsureMovieItem(var Item: Record Item)
procedure ValidateMovieIsRentable(MovieItemNo: Code[20])
procedure SetMovieDefaults(var Item: Record Item)
procedure IsMovie(MovieItemNo: Code[20]): Boolean
procedure GetMovieTitle(MovieItemNo: Code[20]): Text[100]
```

Responsibilities: activar `VC Is Movie`, validar género principal si se requiere, impedir alquiler de ítems no película o no rentables, centralizar mensajes funcionales.

### 4.2 Codeunit 50132 `VC Availability Mgt`

```al
procedure GetRentedQuantity(MovieItemNo: Code[20]): Decimal
procedure GetAvailableQuantity(MovieItemNo: Code[20]): Decimal
procedure AssertAvailable(MovieItemNo: Code[20]; Quantity: Decimal; ExcludeDocumentNo: Code[20])
procedure RecalculateMovieAvailability(MovieItemNo: Code[20])
```

Implementation sketch: usar `SetRange` sobre `VC Rental Line`, filtrar estados abiertos, usar `CalcSums("Outstanding Qty.")` cuando la clave/SIFT esté disponible, y publicar eventos propios antes/después del cálculo.

### 4.3 Codeunit 50133 `VC Rental Validation`

```al
procedure ValidateCanRegister(var RentalHeader: Record "VC Rental Header")
procedure ValidateCanReturn(var RentalLine: Record "VC Rental Line"; ReturnQty: Decimal; ReturnDate: Date)
procedure ValidateHeaderDates(var RentalHeader: Record "VC Rental Header")
procedure ValidateLineQuantity(var RentalLine: Record "VC Rental Line")
procedure ValidateCustomer(CustomerNo: Code[20])
```

Rules: cliente obligatorio, fechas coherentes, al menos una línea, películas rentables, cantidad entera positiva, disponibilidad suficiente y no devolución superior al pendiente.

### 4.4 Codeunit 50134 `VC Rental Status Mgt`

```al
procedure UpdateHeaderStatus(var RentalHeader: Record "VC Rental Header")
procedure UpdateLineStatus(var RentalLine: Record "VC Rental Line")
procedure MarkOverdueRentals(ReferenceDate: Date)
procedure IsHeaderOverdue(RentalHeader: Record "VC Rental Header"; ReferenceDate: Date): Boolean
procedure IsLineOverdue(RentalLine: Record "VC Rental Line"; ReferenceDate: Date): Boolean
```

Note: la arquitectura deja pendiente si `Overdue` se persiste o se calcula dinámicamente; `MarkOverdueRentals` queda como blueprint si se aprueba persistencia/job queue.

### 4.5 Codeunit 50135 `VC Rental Mgt`

```al
procedure RegisterRental(var RentalHeader: Record "VC Rental Header")
procedure RegisterReturn(var RentalHeader: Record "VC Rental Header"; ReturnDate: Date)
procedure RegisterLineReturn(var RentalLine: Record "VC Rental Line"; ReturnQty: Decimal; ReturnDate: Date)
procedure ReopenDraft(var RentalHeader: Record "VC Rental Header")
```

Key flow for `RegisterRental`: publish `OnBeforeRegisterRental`, validate, set header status `Registered`, set each line status `Outstanding`, modify records once each, publish `OnAfterRegisterRental`. No `Commit`.

Key flow for `RegisterLineReturn`: publish `OnBeforeRegisterReturn`, validate qty/date, increment `Returned Quantity`, set `Last Return Date`, update line/header statuses, publish `OnAfterRegisterReturn`.

### 4.6 Codeunit 50136 `VC No Series Mgt`

```al
procedure InitRentalNo(var RentalHeader: Record "VC Rental Header")
procedure AssistEditRentalNo(var RentalHeader: Record "VC Rental Header"): Boolean
procedure GetRentalNoSeriesCode(): Code[20]
```

Open note: depende del patrón exacto de No. Series disponible en la versión BC objetivo.

### 4.7 Codeunit 50137 `VC TMDB Mgt`

```al
procedure SearchMovies(SearchText: Text; var TempTMDBResult: Record "VC TMDB Import Log" temporary): Integer
procedure ImportMovieData(var Item: Record Item; TMDBMovieID: Integer)
procedure RefreshMovieData(var Item: Record Item)
procedure TestConnection(): Boolean
procedure IsEnabled(): Boolean
```

The temporary result table can be replaced by a dedicated temporary buffer if approved; no API page is exposed in v1.

### 4.8 Codeunit 50138 `VC TMDB HTTP Client`

```al
procedure GetMovieSearch(SearchText: Text; LanguageCode: Code[10]): Text
procedure GetMovieDetails(TMDBMovieID: Integer; LanguageCode: Code[10]): Text
procedure GetMovieCredits(TMDBMovieID: Integer; LanguageCode: Code[10]): Text
procedure TestConnection(): Boolean
```

No UI or persistence logic. Must centralize timeout, status-code handling and auth header construction.

### 4.9 Codeunit 50139 `VC TMDB Mapper`

```al
procedure MapMovieDetails(JsonPayload: Text; var TempMovieBuffer: Record "VC TMDB Import Log" temporary)
procedure MapSearchResults(JsonPayload: Text; var TempResultBuffer: Record "VC TMDB Import Log" temporary): Integer
procedure MapCredits(JsonPayload: Text; MovieItemNo: Code[20]; var TempCast: Record "VC Movie Cast" temporary): Integer
procedure GetTextValue(JsonPayload: Text; JsonPath: Text): Text
```

Open note: a dedicated buffer table is cleaner than reusing log for temp results; kept as pending because no object inventory for buffer was approved in architecture.

### 4.10 Codeunit 50140 `VC TMDB Movie Import`

```al
procedure ApplyMovieDetails(var Item: Record Item; TMDBMovieID: Integer; MovieDetailsJson: Text; CreditsJson: Text)
procedure ApplyGenres(var Item: Record Item; MovieDetailsJson: Text)
procedure ApplyCast(MovieItemNo: Code[20]; CreditsJson: Text)
procedure CreateOrUpdateActor(TMDBPersonID: Integer; ActorName: Text[100]): Code[20]
```

### 4.11 Codeunit 50141 `VC TMDB Error Handler`

```al
procedure LogOperation(Operation: Enum "VC TMDB Operation"; Status: Enum "VC Integration Status"; MovieItemNo: Code[20]; TMDBID: Integer; MessageText: Text; DetailsText: Text)
procedure RaiseUserError(MessageText: Text)
procedure NormalizeHttpError(StatusCode: Integer; ResponseText: Text): Text
```

---

## 5. Event Integration

### 5.1 Publishers (new events this feature exposes)

All publishers are `IntegrationEvent(false, false)` and live in the corresponding management codeunit. OnBefore events include `var IsHandled: Boolean` where the default flow can be replaced.

| Codeunit | Event | Parameters (blueprint) | Purpose |
|----------|-------|-------------------------|---------|
| VC Rental Mgt | OnBeforeRegisterRental | `var RentalHeader`, `var IsHandled` | Replace/block rental registration. |
| VC Rental Mgt | OnAfterRegisterRental | `RentalHeader` | React after rental registration. |
| VC Rental Mgt | OnBeforeRegisterReturn | `var RentalLine`, `ReturnQty`, `ReturnDate`, `var IsHandled` | Replace/block line return. |
| VC Rental Mgt | OnAfterRegisterReturn | `RentalLine` | React after line return. |
| VC Availability Mgt | OnBeforeCalculateAvailability | `MovieItemNo`, `var AvailableQty`, `var IsHandled` | Override availability calculation. |
| VC Availability Mgt | OnAfterCalculateAvailability | `MovieItemNo`, `AvailableQty` | Observability/extensibility. |
| VC Rental Status Mgt | OnAfterUpdateRentalStatus | `RentalHeader` | React to status recalculation. |
| VC TMDB Mgt | OnBeforeSearchTMDB | `SearchText`, `var IsHandled` | Replace/cache search. |
| VC TMDB Mgt | OnAfterSearchTMDB | `SearchText`, `ResultCount` | Logging/telemetry. |
| VC TMDB Movie Import | OnBeforeApplyTMDBMovie | `var Item`, `TMDBMovieID`, `var IsHandled` | Adjust/block TMDB application. |
| VC TMDB Movie Import | OnAfterApplyTMDBMovie | `Item`, `TMDBMovieID` | React after TMDB application. |
| VC TMDB Error Handler | OnTMDBRequestFailed | `Operation`, `MessageText` | Custom error handling/logging. |

```al
[IntegrationEvent(false, false)]
local procedure OnBeforeRegisterRental(var RentalHeader: Record "VC Rental Header"; var IsHandled: Boolean)
begin
end;
```

### 5.2 Subscribers to base-app events

No base-app event subscriber is specified as fact because symbols were not downloaded and no `.alpackages/` verification was performed, per repository constraints. Potential subscribers, such as reacting to Item deletion/rename or Customer deletion, are deferred to Open Questions until symbol and signature validation is available.

---

## 6. Pages and UI

### 6.1 New Pages

| Page | Type | SourceTable | Key Layout/Actions |
|------|------|-------------|--------------------|
| VC Genre List | List | VC Genre | Code, Description, Blocked, TMDB Genre ID. |
| VC Actor List | List | VC Actor | No., Name, Nationality, Blocked; opens Actor Card. |
| VC Actor Card | Card | VC Actor | General/Biography/TMDB groups; part `VC Actor Films Part`. |
| VC Movie Cast Part | ListPart | VC Movie Cast | Actor No., actor name FlowField if added, Character Name, Cast Order. |
| VC Movie List | List | Item | SourceTableView `VC Is Movie = true`; availability fields; actions New Movie, Import TMDB. |
| VC Movie Card | Card | Item | General, Videoclub, TMDB, Synopsis FastTabs; cast part; actions Search/Import/Refresh TMDB. |
| VC Rental List | List | VC Rental Header | No., Customer, Rental Date, Due Date, Status; opens document. |
| VC Rental Document | Document | VC Rental Header | Header fields + `VC Rental Lines Part`; actions Register Rental, Register Return. |
| VC Rental Lines Part | ListPart | VC Rental Line | Movie Item No., Description, Quantity, Returned, Outstanding, Status. |
| VC Open Rentals | List | VC Rental Header | Filter Status Registered/Partially Returned. |
| VC Overdue Rentals | List | VC Rental Header | Filter Status Overdue or Due Date < Today if dynamic. |
| VC TMDB Setup Card | Card | VC TMDB Setup | Setup with secret field masked/handled securely; Test Connection action. |
| VC TMDB Import Log | List | VC TMDB Import Log | Entries read-only, latest first. |

### 6.2 Page Extensions

```al
pageextension 50126 "VC Item Card Ext" extends "Item Card"
{
  layout
  {
    addlast(Content)
    {
      group("VC Videoclub")
      {
        Caption = 'Videoclub';
        field("VC Is Movie"; Rec."VC Is Movie") { ApplicationArea = All; ToolTip = 'Specifies that the item is managed as a movie.'; }
        field("VC Rental Copies"; Rec."VC Rental Copies") { ApplicationArea = All; ToolTip = 'Specifies the number of physical rental copies.'; }
      }
    }
  }
  actions
  {
    addlast(Processing)
    {
      action("VC Open Movie Card") { ApplicationArea = All; Caption = 'Open Movie Card'; Image = Video; }
      action("VC Refresh TMDB") { ApplicationArea = All; Caption = 'Refresh from TMDB'; Image = Refresh; }
    }
  }
}
```

Other extensions:
- `VC Item List Ext`: show `VC Is Movie`, `VC Available Quantity` if implemented safely; action to open `VC Movie List`.
- `VC Customer Card Ext`: actions `VC Rentals` and `VC Open Rentals` filtered by `Customer No.`.
- `VC Customer List Ext`: navigation to rental history filtered by selected customer.
- `VC Role Center Ext`: proposed cues for available movies/open rentals/overdue rentals; exact base Role Center pending validation.

UI rules: pages call management codeunits; no critical business rules in page triggers. Use `ApplicationArea = All`, meaningful `ToolTip`, promoted processing actions where appropriate, and list pages read-only unless maintenance is intended.

---

## 7. Tests (Given/When/Then)

### 7.1 Test Objects

```al
codeunit 50142 "Library - VC Videoclub"
codeunit 50143 "VC Rental Tests" { Subtype = Test; TestPermissions = Disabled; }
codeunit 50144 "VC TMDB Tests" { Subtype = Test; TestPermissions = Disabled; }
```

### 7.2 Test Scenarios

| Test Name | Given | When | Then |
|-----------|-------|------|------|
| GivenMovieWithCopies_WhenGetAvailableQty_ThenReturnsCopies | Película rentable con 3 copias y sin líneas abiertas. | Se llama `GetAvailableQuantity`. | Devuelve 3. |
| GivenRegisteredRental_WhenGetAvailableQty_ThenSubtractsOutstanding | Película con 3 copias y alquiler registrado de 2. | Se calcula disponibilidad. | Devuelve 1. |
| GivenNoCustomer_WhenRegisterRental_ThenError | Cabecera draft sin cliente. | Se llama `RegisterRental`. | Error de cliente obligatorio. |
| GivenNoLines_WhenRegisterRental_ThenError | Cabecera con cliente sin líneas. | Se registra. | Error de líneas obligatorias. |
| GivenNotRentableMovie_WhenRegisterRental_ThenError | Línea con película `VC Rentable = false`. | Se registra. | Error de película no alquilable. |
| GivenInsufficientCopies_WhenRegisterRental_ThenError | 1 copia disponible y línea cantidad 2. | Se registra. | Error de disponibilidad. |
| GivenValidDraft_WhenRegisterRental_ThenStatusesOutstanding | Cabecera y líneas válidas. | Se registra alquiler. | Cabecera Registered y líneas Outstanding. |
| GivenOutstandingLine_WhenPartialReturn_ThenPartiallyReturned | Línea cantidad 2 pendiente. | Se devuelve 1. | Línea y cabecera parcialmente devueltas. |
| GivenOutstandingLine_WhenFullReturn_ThenReturned | Línea cantidad 1 pendiente. | Se devuelve 1. | Línea Returned y cabecera Returned si no quedan pendientes. |
| GivenReturnQtyExceedsOutstanding_WhenReturn_ThenError | Línea pendiente 1. | Se devuelve 2. | Error por exceso. |
| GivenDueDatePast_WhenUpdateStatus_ThenOverdue | Alquiler registrado con vencimiento pasado. | Se recalcula estado. | Estado Overdue si se aprueba persistencia. |
| GivenTMDBDisabled_WhenSearch_ThenError | Setup TMDB deshabilitado. | Se busca película. | Error controlado y log Warning/Error. |
| GivenTMDBPayload_WhenMapMovie_ThenFieldsMapped | JSON representativo local. | Se mapea. | Título, año, idioma, géneros y reparto normalizados. |
| GivenTMDBImport_WhenApply_ThenMovieUpdated | Película existente y payload fake. | Se aplica importación. | Campos VC y reparto actualizados. |
| GivenReadPermission_WhenModifySetup_ThenDenied | Usuario con permiso READ. | Intenta modificar setup. | Permiso denegado en prueba restrictiva si entorno lo permite. |

### 7.3 Test Blueprint

```al
[Test]
procedure GivenValidDraft_WhenRegisterRental_ThenStatusesOutstanding()
var
  RentalHeader: Record "VC Rental Header";
  RentalMgt: Codeunit "VC Rental Mgt";
begin
  // [GIVEN] A rentable movie with enough copies and a draft rental with one line
  LibraryVC.CreateMovieWithCopies(MovieItem, 2);
  LibraryVC.CreateDraftRental(RentalHeader, CustomerNo, MovieItem."No.", 1);

  // [WHEN] The rental is registered
  RentalMgt.RegisterRental(RentalHeader);

  // [THEN] Header and line statuses show an outstanding registered rental
  RentalHeader.Get(RentalHeader."No.");
  Assert.AreEqual(RentalHeader.Status::Registered, RentalHeader.Status, 'Rental should be registered.');
end;
```

---

## 8. Permission Sets

> HITL note from `skill-permissions`: this is a proposed security matrix for review before implementation. PermissionSet objects may be generated only after human approval of least privilege.

### 8.1 Proposed permission sets

```al
permissionset 50145 "VC VIDEOCLUB BASE"
{
  Assignable = false;
  Permissions =
    tabledata "VC Genre" = R,
    tabledata "VC Actor" = R,
    tabledata "VC Movie Cast" = R,
    tabledata "VC Rental Header" = R,
    tabledata "VC Rental Line" = R,
    tabledata "VC TMDB Import Log" = R;
}
```

| Object/Data | READ | USER | ADMIN | Rationale |
|-------------|------|------|-------|-----------|
| Item VC fields | R | RM | RIMD | Users maintain movie catalog; admins may delete only under policy. |
| VC Genre | R | R | RIMD | Genre maintenance is admin-controlled. |
| VC Actor | R | RIM | RIMD | Operators can add actors; admin can delete/clean. |
| VC Movie Cast | R | RIM | RIMD | Operators maintain cast. |
| VC Rental Header | R | RIM | RIMD limited | Operators create/register; deletion of registered docs should be blocked in logic. |
| VC Rental Line | R | RIM | RIMD limited | Same as header. |
| VC TMDB Setup | — | R | RIMD | Secrets/config admin-only. |
| VC TMDB Import Log | R | RI | RIMD | Users create logs indirectly; admin can clean if approved. |
| Business codeunits | — | X | X | Operate workflows. |
| TMDB codeunits | —/X search | X | X | Depends on whether regular users may import. |
| Pages | R | R/X | R/X | Access aligned with table/codeunit permissions. |

### 8.2 Codeunit indirect permissions
`VC Rental Mgt`, `VC Rental Status Mgt` and TMDB codeunits may require `Permissions = tabledata ... = rimd` for indirect writes to log/status tables if users should execute workflows without direct table maintenance rights. Exact indirect permissions must be validated during implementation.

---

## 9. API Endpoints

No API pages are part of v1. The architecture describes pull bajo demanda desde UI and no external API exposure from the extension. If future integrations require API access, create a separate approved spec addendum.

---

## 10. AL-Go / CI Considerations

- [ ] Create `app.json` before implementation and reserve `idRanges` covering the final object IDs.
- [ ] Register all object IDs in the final range; replace provisional `50100..50149` if needed.
- [ ] Keep source organized by feature, e.g. `src/Videoclub/Catalog`, `src/Videoclub/Rental`, `src/Videoclub/TMDB`, and tests in a separate `Test` project.
- [ ] Add captions/tooltips and generate XLF translations.
- [ ] Run CodeCop/AppSourceCop/PerTenantExtensionCop according to target deployment.
- [ ] Do not introduce BC version-specific APIs (secrets/No. Series/TMDB HTTP) without confirming target runtime.
- [ ] Do not compile, publish or connect to BC in this spec phase.

---

## 11. Acceptance Criteria

### Functional
- [ ] Users can maintain movie genres and actors.
- [ ] Users can mark Items as movies and maintain movie metadata.
- [ ] Users can maintain cast entries per movie.
- [ ] Users can create a rental document for an existing customer.
- [ ] Registration blocks invalid customer, no lines, non-rentable movies and insufficient copies.
- [ ] Users can register partial and total returns.
- [ ] Availability reflects outstanding rental quantities.
- [ ] Open and overdue rental views support operational follow-up.
- [ ] Authorized users can configure TMDB and import/refresh metadata under controlled errors.

### Technical
- [ ] Final object IDs are inside `app.json` `idRanges`.
- [ ] All fields have `DataClassification` or valid `FieldClass`.
- [ ] Business logic is in codeunits, not page triggers.
- [ ] Events are published as `IntegrationEvent(false, false)` with `OnBefore/OnAfter` patterns.
- [ ] No base-app subscriber is implemented until symbol-verified.
- [ ] Availability uses filtered reads and `CalcSums` where possible.
- [ ] No `Commit` in rental registration, return or event subscriber flows.
- [ ] Permission sets implement least privilege after human approval.

### Quality
- [ ] Given/When/Then tests cover catalog, availability, rental, return, status and TMDB mapping/error paths.
- [ ] Tests do not call real TMDB; they use payloads/fakes.
- [ ] Captions/tooltips are translatable.
- [ ] Registered rental documents have deletion protections defined before implementation.
- [ ] Code review validates naming length and feature-based folder structure.

---

## 12. Open Questions

| # | Question | Owner | Status |
|---|----------|-------|--------|
| 1 | What is the final `app.json` ID range and app publisher/name? | Human | Open |
| 2 | Which Business Central runtime/version is the target? | Human | Open |
| 3 | Which secure secret mechanism must store TMDB credentials? | Human/Architect | Open |
| 4 | Should overdue status be persisted or calculated dynamically? | Human/Architect | Open |
| 5 | Should poster be URL only, Media, or Blob? | Human | Open |
| 6 | Is Decimal with zero decimals acceptable for rental copies, or must it be Integer? | Human | Open |
| 7 | Which Role Center page should `VC Role Center Ext` extend? | Human/Implementer | Open |
| 8 | Are Delete permissions allowed for registered rental documents? | Human | Open |
| 9 | Should a dedicated temporary TMDB result/buffer table be added? | Architect | Open |
| 10 | Which base-app events, if any, should be subscribed after symbol verification? | Implementer | Pending symbols |

---

## 13. Handoff Recommended for TDD Implementation

| Complexity | Handoff to | Purpose |
|------------|------------|---------|
| HIGH | `@AL Development Conductor` | TDD-orchestrated implementation: plan slices, RED tests, GREEN implementation, review and refactor. |

Recommended TDD sequence:
1. Confirm `app.json`, runtime, ID range and permission matrix.
2. Implement catalog masters and `VC Item Ext` with unit tests for movie validation.
3. Implement rental tables/enums and library test helpers.
4. RED/GREEN availability calculations with edge cases.
5. RED/GREEN rental registration and return workflows.
6. Implement UI pages/actions after business code is covered.
7. Implement TMDB setup, mapper and fake-client tests before real HTTP client wiring.
8. Add permissions and restrictive permission tests where environment supports them.
9. Run full build/test/review pipeline.

## 14. Validations Performed in Spec Phase

- Read `.github/prompts/al-spec.create.prompt.md` as generation contract, not as native agent.
- Read `.github/plans/memory.md`, `.github/plans/functional.md` and `.github/plans/architecture.md`.
- Confirmed `.github/plans/videoclub/videoclub.spec.md` did not exist before creation.
- Created `.github/plans/videoclub/` because it was absent.
- Searched repository for `app.json`; none found, so IDs are provisional and marked pending validation.
- Did not create/modify `/src` AL objects.
- Did not download symbols, compile, publish or connect to Business Central.
- Did not claim any base-app event verification; unresolved event subscriptions are in Open Questions.
