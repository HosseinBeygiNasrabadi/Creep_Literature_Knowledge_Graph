# About & Citation

## Project context

CreepLitKG is developed at **FIZ Karlsruhe – Leibniz Institute for Information Infrastructure** within the [NFDI-MatWerk](https://nfdi-matwerk.de/) consortium of the German National Research Data Infrastructure (NFDI). It is part of the semantic knowledge graph infrastructure for materials science and engineering built around the **MSE Knowledge Graph (MSE-KG)** and follows the reusable pipeline method of the *RDFConvertors for MatWerk-KG* converter family.

The public SPARQL endpoint is being integrated into the MSE-KG federation, so literature-extracted creep data becomes queryable alongside the other NFDI-MatWerk resources.

## Version

**Current release: v1.0.0** (2026-07-20)

- Full four-step pipeline (`xlsm2json.py` → YARRRML → RML mapping → SHACL validation) operational
- Dataset published on the MaterialDigital Dataportal with public Fuseki SPARQL endpoint (anonymous access)
- Five SHACL shapes, all conforming
- Initial content: Inconel 718 creep datasets extracted from literature

## Roadmap

- **LLM4CreepLitKG** — LLM-based metadata extraction from new creep papers into the spreadsheet template, with human-in-the-loop validation (under progress)
- Confirmation of dedicated CTO class IRIs for *manufacturing process* and *aging process* (currently provisionally typed as `obo:BFO_0000015`)
- Completion of the MSE-KG federation integration of the SPARQL endpoint
- Continuous population with further creep literature datasets and materials

## How to cite

If you use CreepLitKG in your research, please cite:

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

**Dr. Hossein Beygi Nasrabadi**
FIZ Karlsruhe – Leibniz Institute for Information Infrastructure GmbH
:material-email: [Hossein.Beygi_Nasrabadi@fiz-Karlsruhe.de](mailto:Hossein.Beygi_Nasrabadi@fiz-Karlsruhe.de)
:material-github: [github.com/HosseinBeygiNasrabadi/Creep_Literature_Knowledge_Graph](https://github.com/HosseinBeygiNasrabadi/Creep_Literature_Knowledge_Graph)

## Acknowledgements

This work is funded within **NFDI-MatWerk** as part of the German National Research Data Infrastructure (NFDI). It builds on the Platform MaterialDigital (PMD) ontologies and infrastructure, the OBO Foundry ontologies (BFO, RO, IAO, OBI), NFDIcore, the MatWerk Ontology (MWO), and QUDT.
