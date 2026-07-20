# SPARQL Access

## Endpoint

The knowledge graph is hosted on the [MaterialDigital Dataportal](https://dataportal.material-digital.de/dataset/creep_literature_knowledge_graph) with a **public Fuseki SPARQL endpoint** (anonymous read access):

```
https://dataportal.material-digital.de/dataset/a5b4edc4-43ef-44ff-a386-5d1f6fbbc439/fuseki/$/sparql
```

The endpoint supports SPARQL 1.1 querying and reasoning over the SHACL-validated graph.

## Query interfaces

| Interface | Notes |
|---|---|
| [**Sparklis** (guided query builder)](https://dataportal.material-digital.de/sparklis/?title=creep_literature_knowledge_graph&endpoint=https%3A//dataportal.material-digital.de/dataset/a5b4edc4-43ef-44ff-a386-5d1f6fbbc439/fuseki/%24/sparql&entity_lexicon_select=http%3A//www.w3.org/2000/01/rdf-schema%23label&concept_lexicons_select=http%3A//www.w3.org/2000/01/rdf-schema%23label) | Build queries in natural language, pre-configured for this endpoint with `rdfs:label` lexicons |
| PMD Dataportal Query UI | Built-in YASGUI-style editor on the dataset page |
| Programmatic access | HTTP `POST` (Form URL Encoded, `query=` key) works from any client, e.g. `curl`, Python `SPARQLWrapper`, or [ReqBin](https://reqbin.com) |

!!! tip "CORS note"
    External browser-based editors (e.g. a self-hosted YASGUI) may fail against the endpoint due to browser CORS restrictions. The portal's own Query UI, Sparklis, and server-side POST requests all work.

```bash
# programmatic example
curl -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode 'query=SELECT * WHERE { ?s ?p ?o } LIMIT 10' \
  'https://dataportal.material-digital.de/dataset/8895723b-3ff0-4906-84ce-872d66b40a6e/fuseki/$/sparql'
```


## Example Competency Questions

### CQ1 — From which literature sources (publications) does the creep data originate?

```sparql
SELECT DISTINCT ?doi WHERE {
  ?d a nfdi:NFDI_0001037 ;   # digital object identifier
     co:PMD_0000006 ?doi .   # has value
}
```

### CQ2 — Which materials have been creep tested?

```sparql
SELECT DISTINCT ?material WHERE {
  ?id a mwo:MWO_0001099 ;        # material identifier
      co:PMD_0000006 ?material .
}
```

### CQ3 — Which testing standards have been used for creep testing Inconel materials?

```sparql
SELECT DISTINCT ?material ?standard WHERE {
  ?mid a mwo:MWO_0001099 ;
       obo:IAO_0000219 ?piece ;        # denotes creep test piece
       co:PMD_0000006 ?material .
  ?piece obo:RO_0000056 ?process .     # participates in
  ?process obo:COB_0000081 ?plan .     # intended to realize
  ?std a nfdi:NFDI_0000206 ;           # standard
       obo:RO_0000058 ?plan ;          # is concretized as
       co:PMD_0000006 ?standard .
  FILTER(CONTAINS(?material, "Inconel"))
}
```

### CQ4 — At what temperature and applied stress was each creep test performed?

```sparql
SELECT ?process ?temperature ?tempUnit ?stress ?stressUnit WHERE {
  ?process a co:PMD_0000589 ;          # creep testing process
           co:PMD_0025013 ?tq .        # changes quality (temperature)
  ?tSpec obo:RO_0000058 ?tq ;
         obo:OBI_0001937 ?temperature ;
         obo:IAO_0000039 ?tempUnit .
  ?sq a cto:CTO_1000304 ;              # mechanical stress
      obo:BFO_0000054 ?process .       # realized in
  ?sSpec obo:RO_0000058 ?sq ;
         obo:OBI_0001937 ?stress ;
         obo:IAO_0000039 ?stressUnit .
}
```

### CQ5 — What heat treatment steps (solutionizing, aging) were applied to a test piece before creep testing?

```sparql
SELECT ?process ?step ?condition WHERE {
  ?ht obo:BFO_0000062 ?process .       # heat treatment preceded by creep test
  ?desc obo:IAO_0000219 ?ht ;          # description denotes the treatment
        co:PMD_0000006 ?condition .
  OPTIONAL { ?desc rdfs:label ?step }  # "Solutionizing" / "Aging"
}
ORDER BY ?process ?step
```

### CQ6 — What is the grain size of the material for each heat treatment condition?

```sparql
SELECT ?piece ?grainSize ?unit ?agingCondition WHERE {
  ?gs a co:PMD_0020243 ;               # grain size
      obo:RO_0000080 ?cryst .          # quality of crystallite
  ?spec obo:OBI_0001927 ?gs ;
        obo:OBI_0001937 ?grainSize ;
        obo:IAO_0000039 ?unit .
  ?cryst obo:RO_0002350 ?micro .       # member of microstructure
  ?micro obo:BFO_0000050 ?piece .      # part of test piece
  ?piece obo:RO_0000056 ?process .
  ?aging obo:BFO_0000062 ?process ;
         rdfs:label "aging process" .
  ?desc obo:IAO_0000219 ?aging ;
        co:PMD_0000006 ?agingCondition .
}
```

### CQ7 — What percentage elongation after creep fracture was observed for each test?

```sparql
SELECT ?process ?elongation WHERE {
  ?q a cto:CTO_0000005 ;               # % elongation after creep fracture
     obo:BFO_0000054 ?process .
  ?spec obo:OBI_0001927 ?q ;
        obo:OBI_0002135 ?elongation .  # text value incl. uncertainty
}
```

### CQ8 — What are the stress rupture time and steady-state creep rate measured for Inconel 718?

```sparql
SELECT ?sample ?ruptureTime ?creepRate WHERE {
  ?mid a mwo:MWO_0001099 ;
       obo:IAO_0000219 ?piece ;
       co:PMD_0000006 "Inconel 718" .
  ?oid a mwo:MWO_0001015 ;             # sample identifier
       obo:IAO_0000219 ?piece ;
       co:PMD_0000006 ?sample .
  ?piece obo:RO_0000056 ?process .

  ?load a cto:CTO_0000011 ;            # loading process
        obo:BFO_0000050 ?process ;
        obo:BFO_0000199 ?rt .          # occupies temporal region
  ?rtSpec obo:OBI_0001927 ?rt ;
          obo:OBI_0002135 ?ruptureTime .

  ?cr a cto:CTO_1000035 ;              # creep rate
      co:PMD_0025006 ?process .        # process attribute of
  ?crSpec obo:OBI_0001927 ?cr ;
          obo:OBI_0002135 ?creepRate .
}
```

