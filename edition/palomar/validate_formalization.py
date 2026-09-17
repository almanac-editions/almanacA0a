#!/usr/bin/env python3
"""Validate palomar/formalization.yaml against the Mathlib Initiative schema, OFFLINE.

The schema files in palomar/schema/ were downloaded from
https://github.com/mathlib-initiative/formalization.yaml and are validated against locally,
so this check works inside an unzipped almanac with no network.

NEEDS two packages that are NOT in a stock python3:  pyyaml  jsonschema
    python3 -m venv .venv && .venv/bin/pip install pyyaml jsonschema
    .venv/bin/python palomar/validate_formalization.py

EXIT: 0 valid · 1 invalid · 4 cannot check (missing dependency — NOT a pass).
"""
import json, os, sys, warnings
warnings.filterwarnings('ignore', category=DeprecationWarning)

ED = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SCHEMA_DIR = os.path.join(ED, "palomar", "schema")
TARGET = os.path.join(ED, "palomar", "formalization.yaml")

try:
    import yaml
    from jsonschema import Draft7Validator, RefResolver
except ImportError as e:
    print(f"CANNOT CHECK: {e}. This is NOT a pass — install pyyaml and jsonschema.")
    sys.exit(4)

doc = yaml.safe_load(open(TARGET, encoding="utf-8"))
version = doc.get("version") or "v0.4"
schema_path = os.path.join(SCHEMA_DIR, f"{version}.schema.json")
if not os.path.exists(schema_path):
    print(f"CANNOT CHECK: no local schema for version {version!r} in palomar/schema/")
    sys.exit(4)

schema = json.load(open(schema_path))
resolver = RefResolver(base_uri="file://" + SCHEMA_DIR + "/", referrer=schema)
errors = sorted(Draft7Validator(schema, resolver=resolver).iter_errors(doc), key=lambda e: list(e.path))

print(f"target: palomar/formalization.yaml")
print(f"schema: palomar/schema/{version}.schema.json (local copy of the published schema)")
print(f"top-level keys present: {sorted(doc)}")
print()
if not errors:
    print("VALID — the document satisfies the schema.")
    sys.exit(0)

print(f"INVALID — {len(errors)} error(s):")
for e in errors:
    loc = "/".join(str(p) for p in e.path) or "(root)"
    print(f"  at {loc}: {e.message}")
sys.exit(1)
