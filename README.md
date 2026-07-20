# Creep Literature Knowledge Graph (CreepLitKG)

**Version 1.0.0**

CreepLitKG is an LLM+Ontology-driven pipeline and knowledge graph that converts creep test metadata extracted from scientific literature into ontology-grounded RDF. It makes experimental creep data reported in publications — material identity, chemical composition, heat treatment history, microstructural features, test conditions, and creep results — findable, machine-readable, and queryable through a public SPARQL endpoint, and federates it into the MatWerk Knowledge Graph (MSE-KG).
All entities are typed with classes from the **[Creep Testing Ontology (CTO)](https://github.com/HosseinBeygiNasrabadi/creep-testing-ontology)** — derived from *ISO 204:2018 — Metallic materials — Uniaxial creep testing in tension* — and the ontologies it reuses (BFO, RO, IAO, OBI, PMDco, NFDIcore, MWO), with measurement units from QUDT. 

## Live resources

**[Live Deployment](https://hosseinbeyginasrabadi.github.io/Creep_Literature_Knowledge_Graph/)**
**[RDF dataset (MaterialDigital Dataportal)])(https://dataportal.material-digital.de/dataset/creep_literature_knowledge_graph)**
**[Guided query UI (Sparklis)](https://dataportal.material-digital.de/sparklis/?title=creep_literature_knowledge_graph&endpoint=https%3A//dataportal.material-digital.de/dataset/a5b4edc4-43ef-44ff-a386-5d1f6fbbc439/fuseki/%24/sparql&entity_lexicon_select=http%3A//www.w3.org/2000/01/rdf-schema%23label&concept_lexicons_select=http%3A//www.w3.org/2000/01/rdf-schema%23label)**
**[Creep Testing Ontology (CTO)] (https://github.com/HosseinBeygiNasrabadi/creep-testing-ontology)**

## Overview

Each dataset in the graph describes one creep test reported in a publication and covers the source publication (DOI), the material (name, chemical composition, sample identifier), the processing and heat treatment history (manufacturing method, solutionizing, aging), microstructural features (grain size, precipitate fractions and sizes), the test conditions (testing standard, temperature, initial stress), and the creep results (stress rupture time, percentage elongation after creep fracture, steady-state creep rate, stress exponent, activation energy, and further ISO 204 extension parameters).


## Pipeline

```
new creep paper
   → LLM4CreepLitKG (LLM extraction, under development) / human extraction
   → data checked by a human and added to creep_literature_spreadsheet.xlsm
   → ./map.sh  (4-step pipeline)
   → creep_literature_rdf.ttl
   → MaterialDigital Dataportal
   → public SPARQL endpoint
   → harvested into MatWerk-KG
```
![CreepLitKG pipeline overview](docs/assets/pipeline.png)

The `./map.sh` script runs four steps in one command:

1. **`xlsm2json.py`** — spreadsheet rows → one JSON array (purely syntactic, no ontology knowledge)
2. **`yarrrml-parser`** — YARRRML mapping (`creep_literature_mapping.yaml`, all semantics) → RML rules
3. **`rmlmapper`** — JSON + RML → `creep_literature_rdf.ttl`, with deterministic ID-derived IRIs (idempotent re-runs)
4. **`pySHACL`** — validation against all shapes in `shapes/`; the script exits non-zero on any violation


## Repository structure

```
├── creep_literature_spreadsheet.xlsm   # extracted metadata (single header-row template)
├── xlsm2json.py                        # spreadsheet → JSON converter (no ontology logic)
├── creep_literature_metadata.JSON      # intermediate JSON array (one object per row)
├── creep_literature_mapping.yaml       # YARRRML mapping (all semantics live here)
├── temp_rml.ttl                        # generated RML rules (intermediate)
├── creep_literature_rdf.ttl            # final RDF output
├── cto.ttl                             # Creep Testing Ontology (authoritative IRI source)
├── map.sh                              # end-to-end pipeline runner
├── shapes/                             # SHACL shapes (shape*.ttl)
├── LLM4CreepLitKG/                     # LLM-based metadata extraction tool (in progress)
└── docs/                               # documentation site sources (MkDocs)
```

## Quick start

**Requirements:** `python3` with `openpyxl` and `pyshacl`, and Docker.

```bash
./map.sh                    # default spreadsheet
./map.sh my_sheet.xlsm      # or a specific spreadsheet following the same template
```

## How to cite

```bibtex
@software{CreepLitKG,
  author  = {Beygi Nasrabadi, Hossein},
  title   = {Creep Literature Knowledge Graph (CreepLitKG)},
  url     = {https://github.com/HosseinBeygiNasrabadi/Creep_Literature_Knowledge_Graph},
  version = {1.0.0},
  date    = {2026-07-20},
}
```

## Contact

**Hossein Beygi Nasrabadi**
FIZ Karlsruhe – Leibniz Institute for Information Infrastructure GmbH
[Hossein.Beygi_Nasrabadi@fiz-Karlsruhe.de](mailto:Hossein.Beygi_Nasrabadi@fiz-Karlsruhe.de)
