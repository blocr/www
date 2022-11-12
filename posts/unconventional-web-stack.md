---
title: Your unconventional static web stack
date: November 12, 2022
abstract: 
---

A static site generator (SSG) takes raw text data and templates, and through the magic of a templating engine, transforms them into a set of web documents or a static website.

While Hugo, Jekyll, Hexo ... etc are the conventional mainstream options for doing what has been described, in an unfortunately complex and inflexible manner, it is worth noting that some document conversion tools can achieve the same thing with some caveats.

## Markdown
[pandoc](https://pandoc.org) is a general purpose document conversion tool. It can be used to generate html or html5 documents from a given markdown one. It also has a rich [templating language](https://pandoc.org/MANUAL.html#template-syntax), which allows for great output customizability.
```
$ pandoc document.md -o document.html
```

Although pandoc is great tool for markdown conversion, it's actually a relatively fat binary. The statically linked pandoc is around **~50 MB** in size.

The good news is that it is not a strict requirement on this system. Any markdown to html converter including the reference implementation of [CommonMark](https://github.com/commonmark/cmark) can be used.

## Make
[make](https://www.gnu.org/software/make/) can be used to automate the process
```
%.html: %.md
	$(MD)$ $< -o $@
```

## The caveats
Usually a static website needs an index page, to serve as a catalog for what's available in the site, and because this is out of the scope of document conversion tools, it's not immediately clear how to make such pages.

One of the hacky ways to do this is to use a bash script to iterate through all the pages and build the index.

As of the time of writing this, this [website](https://github.com/blocr/www) uses a yaml index file to be used both for building the index web page and the atom feed.
