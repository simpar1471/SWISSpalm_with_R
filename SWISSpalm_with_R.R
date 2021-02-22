# Accesses https://swisspalm.org/. Citation for SWISSpalm DB: SwissPalm: Protein Palmitoylation database. Mathieu Blanc*, Fabrice P.A. David*,
# Laurence Abrami, Daniel Migliozzi, Florence Armand, Jérôme Burgi and F. Gisou van der Goot. F1000Research.

# Load required packages

library(RSelenium)
library(glue)

# The generatePath() function ----

generatePath <- function(path)
{
  wd <- getwd()
  newpath <- path
  newpath <- glue("{wd}/{newpath}")
  newpath <- gsub("/", "\\", newpath, fixed = TRUE)
  print(newpath)
  return(newpath)
}

# The getSWISSpalmData function ----

getSWISSpalmData <- function(input.path, output.directory, dataset.value = 1, species.value = 1, output.type = "download_text")
{
  input_path <- generatePath(input.path)
  download_dir <- generatePath(output.directory)

  eCaps <- list(chromeOptions = list(prefs = list("download.prompt_for_download" = FALSE,
                                                  "download.default_directory" = download_dir),
                                     args = list("--headless", "--window-size=1920x1080")))
  # Start RSelenium driver
  rsdriver <- RSelenium::rsDriver(browser = "chrome",
                                  chromever = "latest",
                                  extraCapabilities = eCaps)
  SWISSpalm_driver <- rsdriver[["client"]]
  SWISSpalm_driver$navigate("https://swisspalm.org/proteins?batch_search=1")

  Sys.sleep(time = 3)
  # Send the file we want to upload #
  file_input <- SWISSpalm_driver$findElement(using = "id", value = "file")
  file_input$sendKeysToElement(list(input_path))
  # Set the dataset we want to use #
  dataset_value <- toString(dataset.value)
  dataset <- SWISSpalm_driver$findElement(using = 'xpath', glue('//*/option[@value = "{dataset_value}"]'))
  dataset$clickElement()
  # Set the species we want to use #
  species_value <- toString(species.value) # IDs can be found by inspecting SWISSpalm.org/proteins HTML
  species <- SWISSpalm_driver$findElement(using = 'xpath', glue('//*/option[@value = "{species_value}"]'))
  species$clickElement()
  # Click the search button to generate results #
  search_button <- SWISSpalm_driver$findElement(using = "id", value = "batch_search_btn")
  search_button$clickElement()

  Sys.sleep(time = 10) # Wait for results to load

  # Extract list of symbols not found in database IF PRESENT #
  nf_in_db <- SWISSpalm_driver$findElements(using = "id", value = "btn-list_not_found_at_all")
  if(length(nf_in_db))
  {
    print("Retrieving symbols not in database")
    SWISSpalm_driver$findElement(using = "id", value = "btn-list_not_found_at_all")$clickElement()
    Sys.sleep(time = 0.5)
    elem_nf_in_db <- SWISSpalm_driver$findElement(using = "id", value = "list_not_found_at_all")
    not_found_in_database <- elem_nf_in_db$getElementText()[[1]]
    Sys.sleep(time = 0.05)
    SWISSpalm_driver$findElement(using = "id", value = "btn-list_not_found_at_all")$clickElement()
  }

  # Extract list of symbols not identified in dataset IF PRESENT #
  nf_in_ds <- SWISSpalm_driver$findElements(using = "id", value = "btn-list_not_found")
  if(length(nf_in_ds))
  {
    print("Retrieving symbols not in dataset")
    SWISSpalm_driver$findElement(using = "id", value = "btn-list_not_found")$clickElement()
    Sys.sleep(time = 0.5)
    elem_nf_in_ds <- SWISSpalm_driver$findElement(using = "id", value = "list_not_found")
    not_found_in_dataset <- elem_nf_in_ds$getElementText()[[1]]
    Sys.sleep(time = 0.05)
    SWISSpalm_driver$findElement(using = "id", value = "btn-list_not_found")$clickElement()
  }

  Sys.sleep(time = 5) # Give the server a break

  # Download output file  #
  output_type <- output.type
  download_button <- SWISSpalm_driver$findElement(using = "id", value = output_type)
  download_button$clickElement()
  Sys.sleep(time = 10) # Give time for the download

  # Kill Selenium and Java objects #
  SWISSpalm_driver$close()
  rm(SWISSpalm_driver)
  rsdriver$server$stop()
  rm(rsdriver)
  system("taskkill /im java.exe /f", intern = FALSE, ignore.stdout = FALSE)

  if(length(nf_in_db))
  {
    nf_in_db_path <- gsub("/", "\\", glue("{download_dir}/not_found_in_db.txt"), fixed = TRUE)
    print(nf_in_db_path)
    write(not_found_in_database, nf_in_db_path)
  }
  if(length(nf_in_ds))
  {
    nf_in_ds_path <- gsub("/", "\\", glue("{download_dir}/not_found_in_ds.txt"), fixed = TRUE)
    print(nf_in_ds_path)
    write(not_found_in_dataset, nf_in_ds_path)
  }
}
