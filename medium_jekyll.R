
# https://medium.com/@DataScience_CampusLabs/nlp-on-commencement-addresses-using-r-and-python-336964670804
#
# medium.com/@data_steve


#  paste0('pandoc -sr html "/Users/ssimpson/Desktop/Editing R and Python Choices.html" -o  "/Users/ssimpson/Desktop/r-python.txt"')


# pandoc_drive <-
# pandoc the html file into md file
pandoc_url <- function(url, to_file = FALSE, file=NA){

  if (!to_file) {

    # for reading into R
        system(paste0('pandoc -sr html  '
                      , url
                      ,' -t markdown')
               , intern = TRUE, ignore.stderr = TRUE)

  } else {

    # for downloading
    if(is.na(file)) stop(message("file must not be NA"))
    system(paste0( 'pandoc -sr html  '
                   , url
                   ,' -o ',
                   file ))
  }


  # - s stand alone
  # - r read
  # - t to f from
  # - intern = true is store as R vector
  # - ignore.stderr
  # -o - output to file
}


# get url links
get_article_links <- function(url, to_file = FALSE, file=NA) {

  # download main page
  out <- pandoc_url(
    paste0(url_handler(url),"/latest")
    , to_file = FALSE, file=NA)

  # extract line with links to articles
  links <- grep_down(paste0("more.+?\\]\\(",url_handler(url)),
                     out)

  # extract links from lines
  unlist(lapply(links, function(x) {
    strsplit(gsub("more.+?\\]\\(", "",x),"\\?source=latest",)[[1]][1]
  }))

}

#  out <- readLines("~/Desktop/r-python.txt")

#  get_articles("https://medium.com/@DataScience_CampusLabs/r-and-python-choices-a4315df97874")
# GET html doc and build md doc
get_articles <- function(url, where) {

  # pull down file
  out <- pandoc_url(url)

  # build Jekyll components
  title <- title_handler(out)
  desc <- description_handler(out)
  tags <- tag_handler(out)
  dts <- date_handler(out)
#   browser()
  body <- body_handler(out)
#   body <- gsub('class=\"aspectRatioPlaceholder( is-locked)\"', "",
#                gsub('class=\"aspectRatioPlaceholder(-fill)\"', "", body))

  # re-do <img> html
  body <- suppressWarnings(img_div_drop(body))
  body <- suppressWarnings(image_handler(body))


  file_title <- strsplit(gsub(paste0(url_handler(url),"/"),"",url),"-")[[1]]
  file_name <- paste0(paste0(c(dts,
                      file_title[1:length(file_title)-1]), collapse="-")
                      ,".md")
  cat(file_name,"\n")
  yml <- c("---","layout: post"
           ,title
           , tags, "---")
  writeLines(append(yml, body),
             con= file.path(paste0(where,"/_posts/",file_name)))

}

# ttt <- get_article_links("data_steve")
# out <- pandoc_it("https://medium.com/@data_steve/porting-medium-to-jekyll-on-github-3ac5f12c1836")
# # plyr::l_ply(get_article_links("data_steve"), get_articles)

# do whole set
medium_to_jekyll <- function(url, where_to = "~/Desktop/blog_transfer"){
  # set up folders
#   dir.create(where_to)
#   dir.create(where_to)
#   dir.create(where_to)

  # do the extraction
  for (i in get_article_links(url)){
    get_articles(i, where = where_to)
  }
}

# medium_to_jekyll("https://medium.com/@DataScience_CampusLabs/latest")


