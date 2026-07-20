# Creep Literature Knowledge Graph (CreepLitKG)

**Version 1.0.0**

CreepLitKG is an LLM+Ontology-driven pipeline and knowledge graph, developed within the [NFDI-MatWerk](https://nfdi-matwerk.de/) project, that converts creep test metadata extracted from scientific literature into ontology-grounded RDF. It makes experimental creep data reported in publications — material identity, chemical composition, heat treatment history, microstructural features, test conditions, and creep results — findable, machine-readable, and queryable through a public SPARQL endpoint, and federates it into the MatWerk Knowledge Graph (MSE-KG).

![CreepLitKG pipeline overview](assets/pipeline.png)

## Live resources

| Resource | Link |
|---|---|
| RDF dataset (MaterialDigital Dataportal) | [dataportal.material-digital.de/dataset/literature-extracted-creep-data](https://dataportal.material-digital.de/dataset/literature-extracted-creep-data) |
| SPARQL endpoint | `https://dataportal.material-digital.de/dataset/8895723b-3ff0-4906-84ce-872d66b40a6e/fuseki/$/sparql` |
| Guided query UI (Sparklis) | [Open Sparklis on the endpoint](https://dataportal.material-digital.de/sparklis/?title=literature-extracted-creep-data&endpoint=https%3A//dataportal.material-digital.de/dataset/8895723b-3ff0-4906-84ce-872d66b40a6e/fuseki/%24/sparql&entity_lexicon_select=http%3A//www.w3.org/2000/01/rdf-schema%23label&concept_lexicons_select=http%3A//www.w3.org/2000/01/rdf-schema%23label) |
| Source code | [github.com/HosseinBeygiNasrabadi/Creep_Literature_Knowledge_Graph](https://github.com/HosseinBeygiNasrabadi/Creep_Literature_Knowledge_Graph) |

## What is in the graph?

The knowledge graph contains **creep datasets extracted from literature**. Each dataset describes one creep test reported in a publication and covers:

- the **source publication** (DOI),
- the **material** (name, chemical composition, sample identifier),
- the **processing and heat treatment history** (manufacturing method, solutionizing, aging),
- **microstructural features** (grain size, precipitate fractions and sizes),
- the **test conditions** (testing standard, temperature, initial stress),
- and the **creep results** (stress rupture time, percentage elongation after creep fracture, steady-state creep rate, stress exponent, activation energy, and further ISO 204 extension parameters).

All entities are typed with classes from the **Creep Testing Ontology (CTO)** and the ontologies it reuses (BFO, RO, IAO, OBI, PMDco, NFDIcore, MWO), with measurement units from **QUDT**. The terminology follows *ISO 204:2018 — Metallic materials — Uniaxial creep testing in tension*. See [Data Model & Ontologies](ontology.md) for details.

Instance IRIs are minted in the namespace:

```
https://nfdi.fiz-karlsruhe.de/matwerk/msekg/
```

## How is it built?

A fully automated, reproducible four-step pipeline transforms spreadsheet-collected literature metadata into validated RDF:

```
creep paper → (LLM4CreepLitKG / human) → spreadsheet → JSON → YARRRML/RML → RDF → SHACL → SPARQL endpoint
```

See the [Pipeline](pipeline.md) page for the full architecture, and [SPARQL Access](sparql.md) for ready-to-run competency question queries.

## Quick start: ask the graph a question

Paste this into the [Sparklis/YASGUI UI](https://dataportal.material-digital.de/sparklis/?title=literature-extracted-creep-data&endpoint=https%3A//dataportal.material-digital.de/dataset/8895723b-3ff0-4906-84ce-872d66b40a6e/fuseki/%24/sparql&entity_lexicon_select=http%3A//www.w3.org/2000/01/rdf-schema%23label&concept_lexicons_select=http%3A//www.w3.org/2000/01/rdf-schema%23label) or POST it to the endpoint:

```sparql
PREFIX mwo: <http://purls.helmholtz-metadaten.de/mwo/>
PREFIX co:  <https://w3id.org/pmd/co/>

# Which materials have been creep tested?
SELECT DISTINCT ?material WHERE {
  ?id a mwo:MWO_0001099 ;        # material identifier
      co:PMD_0000006 ?material .  # has value
}
```

## Contact

**Dr. Hossein Beygi Nasrabadi**
FIZ Karlsruhe – Leibniz Institute for Information Infrastructure GmbH
[Hossein.Beygi_Nasrabadi@fiz-Karlsruhe.de](mailto:Hossein.Beygi_Nasrabadi@fiz-Karlsruhe.de)

How to cite this work is described on the [About & Citation](about.md) page.
