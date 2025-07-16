# Function to prepare the data for plotting the evolution of  key terms absolute
# ranking over time. `span` is the period covered by each point on the x-axis
# and `n` is the number of ranks to display in the figure.
# This code is inspired by examples provided by David Sjoberg on how to use
# `ggbump`. See: https://github.com/davidsjoberg/ggbump/wiki/My-year-on-Spotify
prepare_key_term_evol_dat <- function(dat, span, n = Inf) {
  
  # Define the period covered, the span-group and corresponding labels
  years <- min(dat[["year"]]):max(dat[["year"]])
  years_group <- (seq_along(years) + (span - 1)) %/% span
  years_label <- map_chr(
    years_group,
    \(x) paste0(range(years[which(years_group == x)]), collapse = "-")
  )
  
  # If the number of unique  key term is lower than `n` or the default is used,
  # `n` is set to the number of distinct key terms.
  if (n_distinct(dat$key_term) < n || n == Inf) n <- n_distinct(dat$key_term)
  
  
  dat |>
    # Create a period factor corresponding to the span-group
    mutate(
      period = fct(years_label[match(year, years)], levels = unique(years_label))
    ) |>
    # Count key terms per period
    summarise(
      count = sum(count),
      .by = c(key_term, period)
    ) |>
    # For each period, add the position (rank) of the key term
    mutate(
      rank = rank(count, ties.method = "first"),
      rank = (max(rank) - rank) + 1, # Rank is recoded so highest count is first
      .by = period
    ) |>
    # Only keep the key terms that appeared at least once in the top `n` (as
    # defined in the function).
    filter(
      min(rank) <= n,
      .by = key_term
    ) |>
    # By filtering key terms that appeared at least once in the top `n`, we can
    # have ranks that are higher than `n`, but also counts being 0. We need to
    # recode the rank of these cases as `n + 1`.
    mutate(rank = if_else(rank > n | count == 0, n + 1, rank)) |>
    arrange(key_term, period) |>
    # Define when the key term entered first and last in the `n` ranking
    mutate(
      is_first_top = first(period[rank <= n]) == period,
      is_last_top = last(period[rank <= n]) == period,
      order = as.numeric(period),
      .by = key_term
    ) |>
    # For each key terms, keep only the data within the first and last entry in
    # the top `n` ranking.
    filter(
      order >= order[is_first_top],
      order <= order[is_last_top],
      .by = key_term
    ) |>
    # Create groups for the active key terms. This is needed to suppress
    # geom_bump to draw lines more than to the next period
    mutate(
      lag_zero = if_else(
        dplyr::lag(rank) %in% c(n + 1, NA) & rank <= n, 1, 0, 0
      ),
      total_count = sum(count),
      .by = key_term
    ) |>
    mutate(
      group = cumsum(lag_zero),
      key_term = fct_reorder(key_term, total_count, .desc = TRUE),
      n_val = n
    )
  
}