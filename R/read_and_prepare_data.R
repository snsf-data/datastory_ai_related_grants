ai_related_grants <- read_csv("data/ai_related_grants.csv") |>
  mutate(
    research_domain_en_short = fct(
      research_domain_en_short,
      levels = c("SSH", "MINT", "LS", "Multi-domain")
    ),
    research_domain_de_short = fct(
      research_domain_de_short,
      levels = c("GSW", "MINT", "LW", "bereichsübergreifend")
    ),
    research_domain_fr_short = fct(
      research_domain_fr_short,
      levels = c("SHS", "MINT", "SV", "Multi-domaines")
    )
  )

stemmed_key_term <- c(
  "artificial intellig",
  "expert system",
  "generative adversarial net",
  "intelligent machine",
  "kernel machine",
  "multilayer perceptron",
  "neural net",
  "transformer net"
)

ai_key_terms_counts <- read_csv("data/ai_key_terms_counts.csv") |>
  mutate(
    key_term = if_else(
      key_term %in% stemmed_key_term,
      paste0(key_term, "*"),
      key_term
    )
  )
