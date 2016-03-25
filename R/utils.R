

grep_down <- function(pattern,x){
  x[grep(pattern,x)]
}

# handle whatever url person uses
url_handler <- function(medium){
  if (grepl(medium,"http")){
    url
  } else {
    medium_handle <- strsplit(strsplit(medium,"@")[[1]][2],"/")[[1]][1]
    if (is.na(medium_handle)){
      paste0("https://medium.com/@",
             medium)
    } else {
      paste0("https://medium.com/@",
             medium_handle)
    }
  }
}
# url_handler("data_steve")

title_handler <- function(h){
  grep_down("title:", h)
}

description_handler <- function(h){
  grep_down("description:", h)
}


# "<div class=\"aspectRatioPlaceholder is-locked\""  \
# "style=\"max-width: 700px; max-height: 741px;\">"                                                                           ""
# "<div class=\"aspectRatioPlaceholder-fill\""                                                                                "style=\"padding-bottom: 105.89999999999999%;\">"                                                                           ""                                                                                                                          "</div>"                                                                                                                    ""                                                                                                                          "![](https://cdn-images-1.medium.com/max/800/1*RRdFssPzyISTYaupK8u2cQ.png)"                                                 ""                                                                                                                          "</div>"







# date
date_handler <- function(h){
  date <- strsplit(strsplit(h[grep('class=\"postMetaInline postMetaInline--supplemental\"',h)], ">")[[1]][2],"<")[[1]][1]
  date <- strsplit(date," ")[[1]]
  paste(date[3],which(month.abb == date[1]),gsub(",","",date[2]), sep="-")
}

body_handler <- function(h) {
  gsub("\\{#.+?\"\\}","",  # removes Medium's sub-section hyperlinking
       h[(                                                                  # subset out meta-data
         grep("<div class=\"section-inner layoutSingleColumn\">", h) + 3    # find begin of body
       ):(
         grep("<div class=\"postActionsFooter container u-size740\">", h)   # find end of body
         -5)   # trim trailing </div> to close body divs
       ]
  )
}

tag_handler <- function(h){
  r <- grep("https://medium.com/tag/",h)
  r <- strsplit(h[r],"\\(https://medium.com/tag/.+?\\)" )[[1]]
  if (length(r)!=0){
    paste0("tags: [",paste0(toupper(gsub("\\[|\\]","",r)), collapse=", "),"]")
  }
}

# remove div tags around img, Jekyll will handle it
img_div_drop <- function(h){

  #   # where img is
  #   b <- grep("!\\[\\]", h)
  #   #/div before
  #   h[(b-2)] <- ""
  #   #/div after
  #   h[(b+2)] <- ""

  d <- grep("<div class=\"aspectRatioPlaceholder ", h)
  for (i in d){
    # print(i)
    # browser()
    od <- grep("<div class=\"aspectRatioPlaceholder", h[i:(i+10)]) + (i-1)
    s  <- grep("style=\"max", h[i:(i+10)]) + (i-1)
    cd <- grep("</div>", h[i:(i+10)]) + (i-1)


    for (j in c(od,cd)){
      h[j] <- "" #paste("<!--","div removed","-->")
    }


    if (!(s %in% c(od,cd))){
      # h[mg] <- paste(h[mg],"{",gsub("style=\"|max-|\">","",h[s]),"}")
      h[s] <- paste("<!--",gsub("style=\"|\">","",h[s]),"-->")
    }
  }

  h
}

# yml builder
yml_handler <- function(title, titlecase=TRUE, tags=""){
  c("---","layout: post"
    , paste0("title: ", ifelse(titlecase, tools::toTitleCase(title), title))
    , "tags: [ ]", "---")
}

# download images and re-write markdown code for it
image_handler <- function(h){
  # "![](https://cdn-images-1.medium.com/max/800/1*z2iYrZI9xUMoBuIKVO_wQg.png)"
  ind <- grep("!\\[\\]\\(", h)
  if (length(ind)!=0){
    for (x in ind){
      # link <- "![](https://cdn-images-1.medium.com/max/800/1*z2iYrZI9xUMoBuIKVO_wQg.png)"

      link <- gsub("\\)","",gsub("!\\[\\]\\(","",h[x]))


      flnm <- gsub("\\)","",
                   strsplit( gsub("https://cdn-images-1.medium.com/max/","",h[x])
                             , "/" )[[1]][2])

      #re-write image path in md
      #mgi <- length((x-10):x) - grep("<!-- max-",h[(x-10):x])
      #mg <- gsub("<!--|max-|-->","",h[(x-mgi)])
      # h[mg] <- paste(h[x],"{",mg,"}")
      # h[x] <- paste(paste0("![](/images/",flnm,")"),"{",mg,"}")
      h[x] <- paste0("![](/images/",flnm,")")


      #download images
      download.file(link,file.path(paste0("~/Desktop/blog_transfer/images/",flnm)), quiet = TRUE)
    }
  }
  h
}
