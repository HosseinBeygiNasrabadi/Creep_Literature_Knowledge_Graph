# Data Model & Ontologies

## Ontological foundation

The semantic backbone of CreepLitKG is the **[Creep Testing Ontology (CTO)](https://github.com/HosseinBeygiNasrabadi/creep-testing-ontology)**, whose terminology is derived from *ISO 204:2018 — Metallic materials — Uniaxial creep testing in tension*. CTO reuses and extends:

| Ontology | Role in CreepLitKG |
|---|---|
| **BFO** (Basic Formal Ontology) | Top-level categories: processes, qualities, temporal regions |
| **RO** (Relation Ontology) | Core relations: `participates in`, `quality of`, `preceded by`, `member of` |
| **IAO** (Information Artifact Ontology) | Publications, identifiers, `denotes`, `is about`, measurement unit labels |
| **OBI** (Ontology for Biomedical Investigations) | Plans, scalar value specifications, specified outputs |
| **PMDco** (Platform MaterialDigital core ontology) | Materials-science entities: creep testing process, microstructure, grain size, temperature |
| **NFDIcore** | DOIs, textual descriptions, standards |
| **MWO** (MatWerk Ontology) | Material and object identifiers |
| **QUDT** | Measurement unit IRIs (`unit:MegaPA`, `unit:DEG_C`, `unit:MicroM`, …) |
