#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2026 Fernando Boiero — CyberLab UTN FRVM
# validar-repo.sh — chequeos de salud del repositorio.
# Lo corre el CI en cada PR/push y lo podés correr a mano:  ./bin/validar-repo.sh
set -uo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."
errores=0
fail() { echo "  ✗ $1"; errores=$((errores+1)); }
ok()   { echo "  ✓ $1"; }

echo "== 1. Python compila =="
while IFS= read -r f; do
  python3 -m py_compile "$f" 2>/dev/null || fail "no compila: $f"
done < <(find labs docs bin -name "*.py" 2>/dev/null)
[ "$errores" -eq 0 ] && ok "todos los .py compilan"

echo "== 2. Shell con sintaxis válida =="
antes=$errores
for f in ctf bin/nueva-flag.sh bin/lib/*.sh labs/*/start.sh; do
  [ -f "$f" ] && { bash -n "$f" 2>/dev/null || fail "sintaxis rota: $f"; }
done
[ "$errores" -eq "$antes" ] && ok "todos los scripts shell OK"

echo "== 3. Manifiestos de retos bien formados =="
antes=$errores
for m in labs/lab*/retos.manifest; do
  [ -f "$m" ] || continue
  # cada línea de reto: R<num>|<título>|<64 hex>
  while IFS= read -r linea; do
    case "$linea" in ''|\#*) continue;; esac
    echo "$linea" | grep -qE '^R[0-9]+\|[^|]+\|[0-9a-f]{64}$' \
      || fail "$m: línea mal formada: ${linea:0:40}..."
  done < "$m"
done
[ "$errores" -eq "$antes" ] && ok "todos los retos.manifest OK"

echo "== 4. Sin soluciones en el repo (H1) =="
encontradas="$(find labs -name 'solucion.md' 2>/dev/null)"
if [ -n "$encontradas" ]; then
  fail "solucion.md versionado (va solo en tu copia local .soluciones-docente/): $encontradas"
else
  ok "no hay solucion.md versionados"
fi

echo "== 5. Sin flags en claro fuera del entorno ofuscado =="
# Las flags viven base64 en los targets. En claro solo pueden aparecer en
# evidencia de labs forenses (caso/) ni en docs públicos.
antes=$errores
while IFS= read -r f; do
  fail "flag en claro en doc público: $f"
done < <(grep -rlE 'FLAG\{[a-z0-9_]{6,}\}' docs README.md CONTRIBUTING.md labs/*/README.md labs/*/docs 2>/dev/null | grep -v entregable || true)
[ "$errores" -eq "$antes" ] && ok "ninguna flag en claro en documentación pública"

echo "== 6. Links internos entre .md =="
antes=$errores
while IFS= read -r f; do
  fail "link interno roto: $f"
done < <(python3 - <<'PY'
import re, pathlib
for md in pathlib.Path('.').rglob('*.md'):
    if '.git' in md.parts: continue
    for m in re.finditer(r'\[[^\]]*\]\(([^)#\s]+)(#[^)]*)?\)', md.read_text(errors='ignore')):
        url = m.group(1)
        if url.startswith(('http://','https://','mailto:')): continue
        if not (md.parent / url).resolve().exists():
            print(f"{md}: {url}")
PY
)
[ "$errores" -eq "$antes" ] && ok "links internos OK"

echo
if [ "$errores" -gt 0 ]; then
  echo "VALIDACIÓN: $errores problema(s) encontrados."
  exit 1
fi
echo "VALIDACIÓN: todo OK."
