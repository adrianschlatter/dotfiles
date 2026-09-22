---
name: jabref
description: search / load references for Loepfe, clearer, winder, textile ...
---

# JabRef Skill

Use when you need company- (=Loepfe-) relevant context. Keywords are: "Loepfe",
"Uster", "Winder", "Yarn", "Clearer", "Textile", "Winder", "PRISMA", "ZENIT",
"YarnMaster".

## Preflight check

Before running any search/load command, verify CLI shape:

```bash
ai --help
ai query --help
ai load --help
```

If command signatures differ from this skill, follow CLI help output and update
this file.

## CLI contract (authoritative usage)

### Search references

```bash
  ai query "<search terms>"
```

Returns: JSON array. Possible outputs:

• Non-empty array of objects with  bibkey ,  title ,  score , optional metadata.
•  []  when no matches are found.

### Load evidence snippets

```bash
  ai load <bibkey> "<question>" --top-k <n> --top-sections <n>
```

Returns: JSON object. Expected keys:  bibkey ,  title ,  status , and either snippet payload or
failure message.

## Known-good examples

```bash
  ai query "Loepfe YarnMaster PRISMA"
  ai load loepfe2012a "What is this product used for?" --top-k 5 --top-sections 3
```

## Output handling and next actions

* If `ai query` returns  [] : broaden terms, try synonyms (Loepfe, Uster,
YarnMaster, ZENIT, PRISMA).
* If  `ai load`  returns  "status":"unavailable"  or  "No accessible local or
  remote document" : pick another  bibkey  from query results.

* If multiple relevant bibkeys exist: prioritize entries with product manuals,
  risk assessments, or requirement docs.
* Always cite the  bibkey  used in the final response.

## Recommended flow

1. Run preflight checks.
2. Run  ai query  with topic keywords.
3. Select the highest-relevance  bibkey .
4. Run  ai load  with a specific question.
5. If unavailable/noisy, iterate bibkey and question wording.
6. Summarize findings and explicitly list unavailable sources attempted.lable in `PATH`.
