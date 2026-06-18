# ALDC Governance v1.1 (Founder-led)

## Roles

- Founder & Lead Maintainer: Javier Armesto
- Maintainers de Core: por invitación (opcional)
- Maintainers de Extensions: por paquete/extensión (opcional)
- Contributors: cualquiera vía PR

## Principios de gobernanza

- Core es pequeño, estable y contractual.
- Skills son el espacio de extensibilidad principal.
- Extensions son el espacio para innovación (agentes/workflows adicionales).
- Cambios que afecten contratos Core requieren RFC.
- Backwards compatibility es prioritaria en Core (salvo bump major).
- `memory.md` es global y acumulativo: nunca se borra, solo se actualiza.
- Templates son inmutables: solo el maintainer los modifica vía RFC.

## RFC Process (obligatorio para Core)

Un RFC es obligatorio para cambios que:
- Alteren `.github/plans/*` o su contrato
- Añadan/eliminen agentes/workflows/skills Core
- Cambien el flujo obligatorio o gates HITL
- Cambien campos del schema `aldc.schema.json`
- Alteren convención `{req_name}.*` en `.github/plans/`
- Modifiquen estructura o contrato de `memory.md`
- Modifiquen plantillas en `docs/templates/`
- Cambien la clasificación de skill (requerido ↔ recomendado)

Flujo:

1. Crear `rfcs/NNNN-titulo.md`
2. Incluir: contexto, propuesta, impacto, migración, riesgos, criterios de aceptación
3. PR en estado "Draft"
4. Revisión comunitaria (comentarios)
5. Decisión del maintainer
6. Merge + implementación + changelog

## Skills governance

- Añadir skills **recomendados**: PR normal (sin RFC)
- Añadir skills **requeridos**: RFC obligatorio
- Modificar skills Core existentes: RFC si cambia el contrato/interfaz, PR normal si es contenido
- Nuevos skills **MUST** seguir `docs/templates/skill-template.md`
- Skills **MUST NOT** duplicar contenido de instructions (las instructions son pasivas, los skills son activos bajo demanda)

## Versionado

- Core: SemVer independiente (v1.0.0 → v1.1.0, …)
- Collection/tooling: SemVer propio

Reglas:
- Cambios breaking en Core ⇒ bump major
- Cambios compatibles ⇒ bump minor/patch
- `aldc.yaml` declara `core.version`

## Límites a contribución

- PRs a skills recomendados: permitidos sin RFC
- PRs a skills requeridos o Core: RFC obligatorio
- Se rechazan cambios que:
  - Debiliten gates HITL
  - Promuevan modificaciones de objetos base
  - Introduzcan ambigüedad contractual
  - Rompan compatibilidad sin bump major
  - Borren o sobrescriban contenido de `memory.md`
  - Modifiquen templates sin RFC
