# Data Model & Ontologies

## Ontological foundation

The semantic backbone of CreepLitKG is the **Creep Testing Ontology (CTO)**, whose terminology is derived from *ISO 204:2018 — Metallic materials — Uniaxial creep testing in tension*. CTO reuses and extends:

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

All classes and properties used in the generated RDF are sourced exclusively from `cto.ttl`, which serves as the authoritative IRI reference. Instance IRIs are minted in the `msekg:` namespace:

```
msekg: https://nfdi.fiz-karlsruhe.de/matwerk/msekg/
```

## Key namespaces

```turtle
@prefix msekg: <https://nfdi.fiz-karlsruhe.de/matwerk/msekg/> .
@prefix cto:   <https://w3id.org/pmd/cto/> .
@prefix tto:   <https://w3id.org/pmd/tto/> .
@prefix co:    <https://w3id.org/pmd/co/> .
@prefix obo:   <http://purl.obolibrary.org/obo/> .
@prefix nfdi:  <https://nfdi.fiz-karlsruhe.de/ontology/> .
@prefix mwo:   <http://purls.helmholtz-metadaten.de/mwo/> .
```

## Core classes

| Concept | Class IRI |
|---|---|
| Creep reference dataset | `cto:CTO_0000009` |
| Creep testing process | `co:PMD_0000589` |
| Creep test piece | `cto:CTO_0000008` |
| Loading process | `cto:CTO_0000011` |
| Solutionizing heat treatment | `cto:CTO_0000012` |
| Microstructure | `co:PMD_0000857` |
| Crystallite | `co:PMD_0000663` |
| Grain size | `co:PMD_0020243` |
| Temperature | `co:PMD_0000967` |
| Mechanical stress | `cto:CTO_1000304` |
| Stress rupture time | `cto:CTO_0000013` |
| Percentage elongation after creep fracture | `cto:CTO_0000005` |
| Creep rate | `cto:CTO_1000035` |
| Stress exponent | `cto:CTO_0000014` |
| Activation energy | `co:PMD_0020162` |
| Publication | `obo:IAO_0000311` |
| Digital object identifier | `nfdi:NFDI_0001037` |
| Material identifier | `mwo:MWO_0001099` |
| Object (sample) identifier | `mwo:MWO_0001015` |
| Standard | `nfdi:NFDI_0000206` |
| Scalar value specification | `obo:OBI_0001931` |
| Plan | `obo:OBI_0000260` |

!!! warning "Provisional typing"
    Two classes — *manufacturing process* and *aging process* — have no dedicated class in `cto.ttl`/PMDco yet. They are provisionally typed as the generic BFO `process` (`obo:BFO_0000015`) with `rdfs:label`s, and will be re-typed once dedicated CTO classes exist.

## Modeling patterns

### Datasets and processes

Each spreadsheet row becomes a `creep reference dataset` that `has part` (`obo:BFO_0000051`) all its identifiers, descriptions, and value specifications, and is the `specified output of` (`obo:OBI_0000312`) a `creep testing process`.

### Measured quantities (numeric)

Cleanly parseable quantities follow the OBI value-specification pattern: a quality is linked to a `scalar value specification` carrying `has specified numeric value` (`obo:OBI_0001937`, typed `xsd:double`) and `has measurement unit label` (`obo:IAO_0000039`, a QUDT unit IRI).

```turtle
msekg:quality_grain_size_<id> a co:PMD_0020243 ;          # grain size
    obo:RO_0000080 msekg:crystallite_<id> .               # quality of

msekg:value_specification_grain_size_<id> a obo:OBI_0001931 ;
    obo:OBI_0001927 msekg:quality_grain_size_<id> ;       # specifies value of
    obo:OBI_0001937 1.7E2 ;                               # 170
    obo:IAO_0000039 <http://qudt.org/vocab/unit/MicroM> . # µm
```

### Measured quantities (uncertain / qualified)

Values with uncertainty, bounds, or exotic notation (`159.74 ±19.18 h`, `< 0.02`, `0.96 ×10⁻⁴ ±5.16×10⁻⁶`) are preserved verbatim as text via `has specified value` (`obo:OBI_0002135`) instead of a numeric value — no lossy coercion.

### Heat treatment history

Solutionizing and aging processes are linked to the creep testing process via `preceded by` (`obo:BFO_0000062`); their conditions are attached as `textual description`s (`nfdi:NFDI_0001018`) that `denote` (`obo:IAO_0000219`) the process and carry the reported condition string via `has value` (`co:PMD_0000006`).

```turtle
msekg:solutionizing_process_<id> a cto:CTO_0000012 ;
    obo:BFO_0000062 msekg:creep_testing_process_<id> .    # preceded by

msekg:textual_description_solutionizing_<id> a nfdi:NFDI_0001018 ;
    obo:IAO_0000219 msekg:solutionizing_process_<id> ;    # denotes
    rdfs:label "Solutionizing" ;
    co:PMD_0000006 "1095 C, 1 h/AC" .
```

### Provenance

Each dataset carries a DOI entity (`nfdi:NFDI_0001037`) that `denotes` a `publication` (`obo:IAO_0000311`), which in turn `is about` (`obo:IAO_0000136`) the creep testing process — so every triple in the graph is traceable to its literature source.

### Further relational patterns

The mapping additionally uses: `is concretized as` (`obo:RO_0000058`) for standards→plans and specifications→qualities, `intended to realize` (`obo:COB_0000081`) for process→plan, `realized in` (`obo:BFO_0000054`) for result qualities, `changes quality` (`co:PMD_0025013`) for the test temperature, `occupies temporal region` (`obo:BFO_0000199`) for the stress rupture time, `process attribute of` (`co:PMD_0025006`) for the creep rate, and `member of` / `part of` for the microstructure hierarchy (crystallite → microstructure → test piece).
