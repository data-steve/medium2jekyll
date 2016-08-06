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


#' Runs Full Process of Porting Medium Blog
#'
#' Assists in Migrating from a Medium Blog to a Jekyll-based Blog, e.g., Github.io.
#'
#' @param url   The Medium url or Medium @handle to port
#' @param where_to  Folder location for ported content
#' @export
#' @examples
#' \dontrun{
#' medium2jekyll("@@fun_times")
#' }

medium2jekyll <- function(url, where_to = "~/Desktop/blog_transfer"){
  # set up folders
  dir.create(where_to)
  dir.create(paste0(where_to,"/images"))
  dir.create(paste0(where_to,"/_posts"))

  # do the extraction
  for (i in get_article_links(url)){
    get_articles(i, where = where_to)
  }
}



# create a new post -- either in _posts folder for live or _backlog for later



#' Creates a New Post in Jekyll-based Markdown
#'
#' Creates a New Post in Jekyll-based Markdown
#'
#' @param title       Title of new post
#' @param subfolder   where file is saved
#' @param date        Date, default is Sys.Date
#' @export
#' @examples
#' \dontrun{
#' new_post("the end of the year", date = "2016-12-31")
#' }
new_post <- function(title, subfolder = "./_posts/", date = as.character(Sys.Date())){
  # check wkdir
  if(!grepl("github.",getwd())) stop("You need to change wkdir to github.io folder")

  # this requires the safety that I separately move files
  # from _backlog into _posts

  # front matter
  yml <-  c("---","layout: post"
            , paste0("title: ", tools::toTitleCase(title)
            , "tags: [ ]", "---")

  # build file name to work with Jekyll format
  file_name <- paste0(paste0(c(date,   # set date always 1 day into future
                               gsub(" ", "-",
                                    gsub("\\s+"," ",
                                         gsub("-"," ",  # handle hypthens in the title
                                              tolower(trimws(title)))
                                    )) ), collapse="-") ,".md")

  # create file
  writeLines(yml,
             con= file.path(paste0(subfolder,file_name)))

  # open file for editing
  file.edit(file.path(paste0(subfolder,file_name)))
}
