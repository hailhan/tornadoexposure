#' Retrieve ZCTA geometries from Tigris
#'
#' Takes a list of US ZCTA codes and a year, and returns a simple features
#' geometry object for those ZCTA boundaries in the given year
#'
#' @param zcta_list Vector of ZCTAs (or ZCTA prefixes)
#' @note ZCTAs/prefixes can be passed in as characters or integers
#' @note ZCTAs/prefixes can be 1-5 characters
#' @param year Census year for requested geometries
#'
#' @return An sf object containing ZCTA boundary geometries
#'
#' @keywords internal
get_geometry <- function(zcta_list, year){
  # default to closest year in tigris
  valid_years <- c(2000, 2010, 2020)
  year <- max(valid_years[valid_years <= year])

  boundary <- tigris::zctas(
    starts_with = as.character(zcta_list),
    year = year,
    cb = TRUE)
}

#' Generate basemap for ZCTA boundaries
#'
#' Takes a list of US ZCTA codes and a year, and returns a plot of the requested
#' ZCTA boundaries
#'
#' @param zcta_list Vector of ZCTAs (or ZCTA prefixes)
#' @note ZCTAs/prefixes can be passed in as characters or integers
#' @note ZCTAs/prefixes can be 1-5 characters
#' @param year Census year for requested geometries
#'
#' @return A mapping of boundaries for requested ZCTAs
#'
#' @keywords internal
get_basemap <- function(zcta_list, year){
  boundary_geom <- get_geometry(zcta_list, year)
  ggplot2::ggplot(data = boundary_geom) +
    ggplot2::geom_sf(fill = NA, color = "black") +
    ggplot2::theme_void()
}

#' Create a choropleth map for variable of interest across selected ZCTAs
#'
#' Takes a list of US ZCTA codes, a year, and a feature, and returns a plot of
#' the requested ZCTA boundaries with a choropleth fill to represent the spatial
#' distribution of the feature
#'
#' @param zcta_list Vector of ZCTAs (or ZCTA prefixes)
#' @note ZCTAs/prefixes can be passed in as characters or integers
#' @note ZCTAs/prefixes can be 1-5 characters
#' @param year Census year for requested geometries
#' @param feature Name of feature to be visualized
#' @note Feature name should align with column name in dataset
#'
#' @return A map of the distribution of feature of interest across selected ZCTAs
#'
#' @export
create_choropleth <- function(zcta_list, year, feature){
  basemap <- get_basemap(zcta_list, year)
  basemap +
    ggplot2::aes(fill = .data[[feature]], color = "black") +
  ggplot2::scale_fill_viridis_c()
}
