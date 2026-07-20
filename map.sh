#!/bin/bash
# Usage:
#   ./map.sh                                     -> maps creep_literature_spreadsheet.xlsm
#   ./map.sh my_sheet.xlsm                       -> maps the given spreadsheet
#
# Requires: creep_literature_mapping.yaml + xlsm2json.py + shapes/ in the same
#           directory, python3 with openpyxl and pyshacl, docker.
#
# Pipeline (one run for the WHOLE spreadsheet, any number of rows):
#   1. xlsm2json.py  : all spreadsheet rows -> creep_literature_metadata.JSON
#   2. yarrrml-parser: creep_literature_mapping.yaml -> temp.rml.ttl
#   3. rmlmapper     : JSON + RML rules -> creep_literature_rdf.ttl
#   4. pyshacl       : validate the TTL against every shapes/shape*.ttl
#
# The script exits non-zero if any SHACL shape reports violations, so a
# defective graph is never mistaken for a successful run.
#
# Re-running after new rows are added is safe and idempotent: all IRIs are
# minted from the 'ID' column, so existing rows regenerate identical triples.

set -e

XLSM_FILE=${1:-creep_literature_spreadsheet.xlsm}
YARRRML_FILE=creep_literature_mapping.yaml
RML_FILE=temp.rml.ttl
JSON_FILE=creep_literature_metadata.JSON
OUTPUT_FILE=creep_literature_rdf.ttl
SHAPES_DIR=shapes

echo "step 1/4: ${XLSM_FILE} -> ${JSON_FILE}"
python3 xlsm2json.py "${XLSM_FILE}" ${JSON_FILE}

echo "step 2/4: ${YARRRML_FILE} -> ${RML_FILE}"
docker run --rm -v "$(pwd)":/data rmlio/yarrrml-parser:1.10.0 -i /data/${YARRRML_FILE} -o /data/${RML_FILE}

echo "step 3/4: ${JSON_FILE} -> ${OUTPUT_FILE}"
docker run --rm -v "$(pwd)":/data rmlio/rmlmapper-java:v7.3.3 -m /data/${RML_FILE} -o /data/${OUTPUT_FILE} -s turtle

echo "step 4/4: SHACL validation of ${OUTPUT_FILE}"
FAILED=0
for f in ${SHAPES_DIR}/shape*.ttl; do
  echo "=== $f ==="
  pyshacl -s "$f" -f human ${OUTPUT_FILE} || FAILED=1
done
if [ "$FAILED" -ne 0 ]; then
  echo "!!! SHACL violations found -- do NOT load ${OUTPUT_FILE} into the triple store"
  exit 1
fi

echo "done: ${XLSM_FILE} -> ${OUTPUT_FILE} (all shapes conform)"
