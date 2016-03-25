
[![Build
Status](https://travis-ci.org/data-steve/medium2jekyll.svg?branch=master)](https://travis-ci.org/data-steve/medium2jekyll)
[![Coverage
Status](https://coveralls.io/repos/data-steve/medium2jekyll/badge.svg?branch=master)](https://coveralls.io/r/data-steve/medium2jekyll?branch=master)

<a href="https://img.shields.io/badge/Version-0.0.1-orange.svg"><img src="https://img.shields.io/badge/Version-0.0.1-orange.svg" alt="Version"/></a>
</p>
**medium2jekyll** assists  in migrating from a Medium blog to a jekyll-based blog, notably one hosted on github.io. Specifically, it helps with 
- text scraping/formatting html to markdown
- image downloading from posts
- markdown cleaning for post content extraction

Installation
============

To download the development version of **medium2jekyll**:

Download the [zip
ball](https://github.com/data-steve/medium2jekyll/zipball/master) or
[tar ball](https://github.com/data-steve/medium2jekyll/tarball/master),
decompress and run `R CMD INSTALL` on it, or use the **pacman** package
to install the development version:

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load_gh("data-steve/medium2jekyll")

Contact
=======

You are welcome to: 
- submit suggestions and bug-reports at: <https://github.com/data-steve/medium2jekyll/issues> 
- send a pull request on: <https://github.com/data-steve/medium2jekyll/> 
- compose a friendly e-mail to: <steven.troy.simpson@gmail.com>
