make_figure_1 <- function(height = NULL) {
  if (interactive()) {
    suppressWarnings(camcorder::gg_record(width = 7, height = height))
  }

  plot <- ai_related_grants |>
    summarise(
      prop = mean(key_terms_count > 0),
      .by = c(year)
    ) |>
    arrange(year) |>
    mutate(
      tooltip = paste0(
        switch(
          params$lang,
          en = "Year: ",
          de = "Jahr: ",
          fr = "Année : "
        ),
        year,
        switch(
          params$lang,
          en = "\nShare: ",
          de = "\nAnteil: ",
          fr = "\nPart : "
        ),
        round(100 * prop, 1),
        "%"
      ),
      data_id = row_number()
    ) |>
    ggplot() +
    aes(
      x = year,
      y = prop,
      fill = "",
      color = "",
      tooltip = tooltip,
      data_id = data_id,
      group = ""
    ) +
    scale_y_continuous(limits = c(0, 0.2), labels = scales::percent) +
    scale_x_continuous(n.breaks = 8) +
    geom_area(alpha = 0.35) +
    geom_line(linewidth = 0.8) +
    geom_point_interactive(size = 2) +
    scale_fill_datastory_1() +
    scale_color_datastory_1() +
    get_datastory_theme(
      title_axis = "",
      legend_position = "right"
    ) +
    theme(
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10)
    )

  return(plot)
}

make_figure_2 <- function(height = NULL) {
  if (interactive()) {
    suppressWarnings(camcorder::gg_record(width = 7, height = height))
  }

  domain_var <- paste0("research_domain_", params$lang, "_short")

  plot <- ai_related_grants |>
    rename(research_domain := {{ domain_var }}) |>
    summarise(
      prop = mean(key_terms_count > 0),
      .by = c(year, research_domain)
    ) |>
    arrange(year) |>
    mutate(data_id = row_number()) |>
    mutate(
      tooltip = paste0(
        switch(
          params$lang,
          en = "Year: ",
          de = "Jahr: ",
          fr = "Année : "
        ),
        year,
        switch(
          params$lang,
          en = "\nResearch domain: ",
          de = "\nForschungsbereich: ",
          fr = "\nDomaine de recherche : "
        ),
        research_domain,
        switch(
          params$lang,
          en = "\nShare: ",
          de = "\nAnteil: ",
          fr = "\nPart : "
        ),
        round(100 * prop, 1),
        "%"
      ),
      .by = research_domain
    ) |>
    ggplot() +
    aes(
      x = year,
      y = prop,
      color = research_domain,
      tooltip = tooltip,
      data_id = data_id,
      group = research_domain
    ) +
    scale_y_continuous(limits = c(0, 0.3), labels = scales::percent) +
    scale_x_continuous(n.breaks = 8) +
    geom_line(linewidth = 0.8) +
    geom_point_interactive(size = 2) +
    scale_color_datastory() +
    get_datastory_theme(
      title_axis = "",
      legend_position = "right"
    ) +
    theme(
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10)
    )

  return(plot)
}

make_figure_3 <- function(height = NULL) {
  if (interactive()) {
    suppressWarnings(camcorder::gg_record(width = 7, height = height))
  }

  prep_dat <- ai_key_terms_counts |>
    filter(research_domain_en_short == "SSH") |>
    prepare_key_term_evol_dat(span = 3, n = 10)

  n <- unique(prep_dat[["n_val"]])

  plot <- prep_dat |>
    mutate(
      data_id = row_number(),
      tooltip = paste0(
        switch(
          params$lang,
          en = "Key term: ",
          de = "Schlüsselbegriff: ",
          fr = "Terme clé : "
        ),
        key_term,
        switch(
          params$lang,
          en = "\nPeriod: ",
          de = "\nZeitraum: ",
          fr = "\nPériode : "
        ),
        period,
        switch(
          params$lang,
          en = "\nRank: ",
          de = "\nRang: ",
          fr = "\nRang : "
        ),
        rank,
        switch(
          params$lang,
          en = "\nNumber of projects with the key term: ",
          de = "\nAnzahl Projekte mit dem Schlüsselbegriff: ",
          fr = "\nNombre de projets contenant le terme clé : "
        ),
        count
      )
    ) |>
    ggplot() +
    aes(
      x = period,
      y = rank,
      color = key_term,
      group = key_term,
      data_id = data_id,
      tooltip = tooltip
    ) +
    geom_bump(smooth = 15, linewidth = 1.5, alpha = 0.2) +
    geom_bump(
      data = \(x) filter(x, rank <= n),
      aes(period, rank, group = group, color = key_term),
      smooth = 15,
      linewidth = 1.5,
      inherit.aes = F,
      na.rm = TRUE
    ) +
    geom_segment(
      data = \(x) filter(x, is_first_top | is_last_top),
      aes(
        x = as.numeric(as.factor(period)),
        xend = as.numeric(as.factor(period)) + .2,
        y = rank,
        yend = rank
      ),
      linewidth = 1.5,
      lineend = "round"
    ) +
    geom_point_interactive(
      data = \(x) filter(x, is_first_top),
      aes(x = as.numeric(as.factor(period))),
      size = 3.5
    ) +
    geom_segment_interactive(
      data = \(x) filter(x, rank <= n),
      aes(
        x = if_else(
          is_first_top,
          as.numeric(as.factor(period)),
          as.numeric(as.factor(period)) - .2
        ),
        xend = as.numeric(as.factor(period)) + .2,
        y = rank,
        yend = rank,
        color = NULL
      ),
      color = "transparent",
      linewidth = 1.5,
      lineend = "round"
    ) +
    geom_text(
      data = \(x) filter(x, is_first_top),
      aes(
        y = rank - 0.4,
        label = str_to_sentence(key_term),
        x = as.numeric(as.factor(period))
      ),
      color = "black",
      size = 2.25,
      hjust = 0
    ) +
    scale_y_reverse(breaks = c(1:(n + 1)), labels = c(1:n, "")) +
    scale_x_discrete(expand = expansion(mult = c(0.05, 0.18))) +
    scale_color_datastory() +
    get_datastory_theme(legend_position = "") +
    theme(
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10)
    )

  return(plot)
}

make_figure_4 <- function(height = NULL) {
  if (interactive()) {
    suppressWarnings(camcorder::gg_record(width = 7, height = height))
  }

  prep_dat <- ai_key_terms_counts |>
    filter(research_domain_en_short == "MINT") |>
    prepare_key_term_evol_dat(span = 3, n = 10)

  n <- unique(prep_dat[["n_val"]])

  plot <- prep_dat |>
    mutate(
      data_id = row_number(),
      tooltip = paste0(
        switch(
          params$lang,
          en = "Key term: ",
          de = "Schlüsselbegriff: ",
          fr = "Terme clé : "
        ),
        key_term,
        switch(
          params$lang,
          en = "\nPeriod: ",
          de = "\nZeitraum: ",
          fr = "\nPériode : "
        ),
        period,
        switch(
          params$lang,
          en = "\nRank: ",
          de = "\nRang: ",
          fr = "\nRang : "
        ),
        rank,
        switch(
          params$lang,
          en = "\nNumber of projects with the key term: ",
          de = "\nAnzahl Projekte mit dem Schlüsselbegriff: ",
          fr = "\nNombre de projets contenant le terme clé : "
        ),
        count
      )
    ) |>
    ggplot() +
    aes(
      x = period,
      y = rank,
      color = key_term,
      group = key_term,
      data_id = data_id,
      tooltip = tooltip
    ) +
    geom_bump(smooth = 15, linewidth = 1.5, alpha = 0.2) +
    geom_bump(
      data = \(x) filter(x, rank <= n),
      aes(period, rank, group = group, color = key_term),
      smooth = 15,
      linewidth = 1.5,
      inherit.aes = F,
      na.rm = TRUE
    ) +
    geom_segment(
      data = \(x) filter(x, is_first_top | is_last_top),
      aes(
        x = as.numeric(as.factor(period)),
        xend = as.numeric(as.factor(period)) + .2,
        y = rank,
        yend = rank
      ),
      linewidth = 1.5,
      lineend = "round"
    ) +
    geom_point_interactive(
      data = \(x) filter(x, is_first_top),
      aes(x = as.numeric(as.factor(period))),
      size = 3.5
    ) +
    geom_segment_interactive(
      data = \(x) filter(x, rank <= n),
      aes(
        x = if_else(
          is_first_top,
          as.numeric(as.factor(period)),
          as.numeric(as.factor(period)) - .2
        ),
        xend = as.numeric(as.factor(period)) + .2,
        y = rank,
        yend = rank,
        color = NULL
      ),
      color = "transparent",
      linewidth = 1.5,
      lineend = "round"
    ) +
    geom_text(
      data = \(x) filter(x, is_first_top),
      aes(
        y = rank - 0.4,
        label = str_to_sentence(key_term),
        x = as.numeric(as.factor(period))
      ),
      color = "black",
      size = 2.25,
      hjust = 0
    ) +
    scale_y_reverse(breaks = c(1:(n + 1)), labels = c(1:n, "")) +
    scale_x_discrete(expand = expansion(mult = c(0.05, 0.15))) +
    scale_color_datastory() +
    get_datastory_theme(legend_position = "") +
    theme(
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10)
    )

  return(plot)
}

make_figure_5 <- function(height = NULL) {
  if (interactive()) {
    suppressWarnings(camcorder::gg_record(width = 7, height = height))
  }

  prep_dat <- ai_key_terms_counts |>
    filter(research_domain_en_short == "LS") |>
    prepare_key_term_evol_dat(span = 3, n = 10)

  n <- unique(prep_dat[["n_val"]])

  plot <- prep_dat |>
    mutate(
      y_shift = if_else(key_term == "natural language processing", 0.125, 0),
      x_shift = if_else(key_term == "natural language processing", 0.05, 0),
      key_term = fct_relabel(
        key_term,
        \(x) str_to_sentence(x) |> str_replace("age pro", "age\npro")
      )
    ) |>
    mutate(
      data_id = row_number(),
      tooltip = paste0(
        switch(
          params$lang,
          en = "Key term: ",
          de = "Schlüsselbegriff: ",
          fr = "Terme clé : "
        ),
        key_term,
        switch(
          params$lang,
          en = "\nPeriod: ",
          de = "\nZeitraum: ",
          fr = "\nPériode : "
        ),
        period,
        switch(
          params$lang,
          en = "\nRank: ",
          de = "\nRang: ",
          fr = "\nRang : "
        ),
        rank,
        switch(
          params$lang,
          en = "\nNumber of projects with the key term: ",
          de = "\nAnzahl Projekte mit dem Schlüsselbegriff: ",
          fr = "\nNombre de projets contenant le terme clé : "
        ),
        count
      )
    ) |>
    ggplot() +
    aes(
      x = period,
      y = rank,
      color = key_term,
      group = key_term,
      data_id = data_id,
      tooltip = tooltip
    ) +
    geom_bump(smooth = 15, linewidth = 1.5, alpha = 0.2) +
    geom_bump(
      data = \(x) filter(x, rank <= n),
      aes(period, rank, group = group, color = key_term),
      smooth = 15,
      linewidth = 1.5,
      inherit.aes = F,
      na.rm = TRUE
    ) +
    geom_segment(
      data = \(x) filter(x, is_first_top | is_last_top),
      aes(
        x = as.numeric(as.factor(period)),
        xend = as.numeric(as.factor(period)) + .2,
        y = rank,
        yend = rank
      ),
      linewidth = 1.5,
      lineend = "round"
    ) +
    geom_point_interactive(
      data = \(x) filter(x, is_first_top),
      aes(x = as.numeric(as.factor(period))),
      size = 3.5
    ) +
    geom_segment_interactive(
      data = \(x) filter(x, rank <= n),
      aes(
        x = if_else(
          is_first_top,
          as.numeric(as.factor(period)),
          as.numeric(as.factor(period)) - .2
        ),
        xend = as.numeric(as.factor(period)) + .2,
        y = rank,
        yend = rank,
        color = NULL
      ),
      color = "transparent",
      linewidth = 1.5,
      lineend = "round"
    ) +
    geom_text(
      data = \(x) filter(x, is_first_top),
      aes(
        y = rank - 0.4 - y_shift,
        label = key_term,
        x = as.numeric(as.factor(period)) + x_shift
      ),
      color = "black",
      size = 2.25,
      hjust = 0
    ) +
    scale_y_reverse(breaks = c(1:(n + 1)), labels = c(1:n, "")) +
    scale_x_discrete(expand = expansion(mult = c(0.05, 0.15))) +
    scale_color_datastory() +
    get_datastory_theme(legend_position = "") +
    theme(
      axis.text.x = element_text(size = 10),
      axis.text.y = element_text(size = 10)
    )
  return(plot)
}

make_ggiraph <- function(
    x, # ggplot object
    h = 4, # height of the svg generated
    sw = 2, # width of the stroke
    fcolor = "#f6685e", # color (fill)
    color = NA, # color
    scolor = "#f6685e"
) {
  # color of the stroke

  girafe(
    ggobj = x,
    height_svg = h,
    options = list(
      opts_toolbar(saveaspng = FALSE),
      opts_hover(
        css = girafe_css(
          css = glue(
            "fill:{fcolor};color:{color};stroke:{scolor};stroke-width:{sw};"
          ),
          text = "stroke:none; color:blue;"
        )
      ),
      opts_tooltip(
        css = get_ggiraph_tooltip_css(family = font),
        opacity = 0.8,
        delay_mouseover = 0,
        delay_mouseout = 0
      )
    )
  )
}

make_desktop_figure_1 <- function(height = 3) {
  plot <- make_figure_1(height)
  camcorder::gg_stop_recording()
  make_ggiraph(plot, h = height)
}

make_mobile_figure_1 <- function() {
  make_figure_1()
}

make_desktop_figure_2 <- function(height = 3) {
  plot <- make_figure_2(height)
  camcorder::gg_stop_recording()
  make_ggiraph(plot, h = height)
}

make_mobile_figure_2 <- function() {
  make_figure_2()
}

make_desktop_figure_3 <- function(height = 3.5) {
  plot <- make_figure_3(height)
  camcorder::gg_stop_recording()
  make_ggiraph(plot, h = height, sw = 3.5)
}

make_mobile_figure_3 <- function() {
  make_figure_3()
}

make_desktop_figure_4 <- function(height = 3.5) {
  plot <- make_figure_4(height)
  camcorder::gg_stop_recording()
  make_ggiraph(plot, h = height, sw = 3.5)
}

make_mobile_figure_4 <- function() {
  make_figure_4()
}

make_desktop_figure_5 <- function(height = 3.5) {
  plot <- make_figure_5(height)
  camcorder::gg_stop_recording()
  make_ggiraph(plot, h = height, sw = 3.5)
}

make_mobile_figure_5 <- function() {
  make_figure_5()
}
