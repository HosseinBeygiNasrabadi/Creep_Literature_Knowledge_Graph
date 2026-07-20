# Literature-Extracted Creep Data → RDF

Converts the literature creep spreadsheet (`creep_literature_spreadsheet.xlsm`) into RDF Turtle (`creep_literature_rdf.ttl`) using YARRRML/RML with CTO/PMDco semantics.

## Files

| File | Role |
|---|---|
| `creep_literature_spreadsheet.xlsm` | data — one row per dataset (sheet `new template`) |
| `xlsm2json.py` | spreadsheet → `creep_literature_metadata.JSON` (no ontology knowledge) |
| `creep_literature_mapping.yaml` | all mapping semantics (CTO / PMDco / OBO classes and axioms) |
| `map.sh` | runs the whole pipeline |
| `creep_literature_metadata.JSON` | generated — intermediate JSON (one object per row) |
| `creep_literature_rdf.ttl` | generated — the knowledge graph |

## Requirements

Docker, Python 3 with `openpyxl` (`pip install openpyxl`).

## Add data

Open `creep_literature_spreadsheet.xlsm`, sheet **new template**, and add one row per dataset:

- **ID** (required, unique): `<DOI with / replaced by _>_<sample>`, e.g. `10.1016_j.msea.2008.04.097_HT1`
- **Quantities**: `number unit` in one cell — `625 MPa`, `650 °C`, `170 µm`, `78.7 h`, `28 %`, `9.6E-5 1/s`
- **Uncertainty**: `159.74 ±19.18 h` (stored as text, not queryable as a number)
- **Unknown**: leave the cell **empty** (no `N/A`) — empty cells produce no triples
- **Text columns** (material name, processing, solutionizing, aging, standard…): free text

## Convert

```bash
./map.sh
```

Output: `creep_literature_rdf.ttl` — the whole spreadsheet as RDF. Re-running after adding rows is safe: IRIs are minted from the ID column, so existing rows regenerate identical triples. Load the TTL into the triple store by replacing the named graph.

## Add a new parameter

Add a column in the spreadsheet + one mapping block pair (value specification + quality) with its class IRI in `creep_literature_mapping.yaml`. `xlsm2json.py` never changes.
