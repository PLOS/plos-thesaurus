# plos-thesaurus
Welcome to the repository for the PLOS Thesaurus. 

PLOS aims to update the thesaurus and re-index all articles several times each year. Download current and previous versions of the thesaurus files [here](https://github.com/PLOS/plos-thesaurus/releases).

## Subject Area terms
The Subject Areas panel on each PLOS article displays eight terms selected from over 10,000 available. Subsequently, clicking on a Subject Area term in an article returns a list of all articles related to that term. Each article’s XML download provides the eight Subject Area terms listed on the article page and includes broader terms from all the paths leading back to these eight.

Subject Area terms relate to each other with a system of broader/narrower term relationships that form a polyhierarchy. For example the term “White blood cells” has two broader terms “Blood cells” and “Immune cells”. All terms track back to one or more of the top-tier terms, such as “Biology and life sciences” or “Social sciences.”

Subject Area searches on the journal websites using the Subject field will return articles where the given Subject Area ranks highly enough to be included in the top eight retrieved terms. By contrast, performing an All fields search will return every article that contains even a single match to the term. The hierarchical nature of the thesaurus allows search to retrieve all articles indexed with a specific Subject Area term and retrieve articles indexed with any term that sits deeper in the hierarchy. For example, queries for “Blood cells” will return all articles indexed with the narrower term “White blood cells”.

## How the thesaurus works
Machine Aided Indexing (MAI) is used to identify text strings in PLOS articles and match them to Subject Area terms from the PLOS thesaurus. The output ranks the matches by the number of times that terms appear in the text and selects the top eight terms for display. 

The MAI process uses a Rulebase to guide term selection, disambiguating  words and phrases based on context. For example, while identifying a phrase such as “Retinitis pigmentosa” is relatively straightforward for MAI software, words like “Sodium” are more complex – the relevant Subject Area term might be “Voltage-gated sodium channels”, any of several sodium compounds, or even just “Sodium” the element. As a result, the rules for terms like this include conditional statements to distinguish these different contexts.
