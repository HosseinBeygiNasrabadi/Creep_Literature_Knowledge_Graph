# Creep Literature Knowledge Graph (CreepLitKG)

**Version 1.0.0**

CreepLitKG is an LLM+Ontology-driven pipeline and knowledge graph, that converts creep test metadata extracted from scientific literature into ontology-grounded RDF. It makes experimental creep data reported in publications — material identity, chemical composition, heat treatment history, microstructural features, test conditions, and creep results — findable, machine-readable, and queryable through a public SPARQL endpoint, and federates it into the MatWerk Knowledge Graph (MSE-KG).


## Live resources

| Resource | Link |
|---|---|
| RDF dataset (MaterialDigital Dataportal) | [https://dataportal.material-digital.de/dataset/creep_literature_knowledge_graph](https://dataportal.material-digital.de/dataset/creep_literature_knowledge_graph) |
| SPARQL endpoint | `https://dataportal.material-digital.de/dataset/a5b4edc4-43ef-44ff-a386-5d1f6fbbc439/fuseki/$/sparql` |
| Guided query UI (Sparklis) | [Open Sparklis on the endpoint](https://dataportal.material-digital.de/sparklis/?title=creep_literature_knowledge_graph&endpoint=https%3A//dataportal.material-digital.de/dataset/a5b4edc4-43ef-44ff-a386-5d1f6fbbc439/fuseki/%24/sparql&entity_lexicon_select=http%3A//www.w3.org/2000/01/rdf-schema%23label&concept_lexicons_select=http%3A//www.w3.org/2000/01/rdf-schema%23label) |
| Source code | [github.com/HosseinBeygiNasrabadi/Creep_Literature_Knowledge_Graph](https://github.com/HosseinBeygiNasrabadi/Creep_Literature_Knowledge_Graph) |

## What is in the graph?

The knowledge graph contains **creep datasets extracted from literature**. Each dataset describes one creep test reported in a publication and covers:

- the **source publication** (DOI),
- the **material** (name, chemical composition, sample identifier),
- the **processing and heat treatment history** (manufacturing method, solutionizing, aging),
- **microstructural features** (grain size, precipitate fractions and sizes),
- the **test conditions** (testing standard, temperature, initial stress),
- and the **creep results** (stress rupture time, percentage elongation after creep fracture, steady-state creep rate, stress exponent, activation energy, and further ISO 204 extension parameters).


