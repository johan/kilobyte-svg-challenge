Kilobyte SVG Challenge
======================

Make an accurate SVG of a logo, in 1024 bytes or less!

## Rationale

The purpose of the Kilobyte SVG Challenge is sixfold:

* marketing SVG use on the web
* teaching SVG, "view source" style
* marketing and improving SVG tools
* collecting great, fast, and tiny SVG logos
* learning, and having lots of geeky fun doing it!

## Rules

* Viewed in a web browser,
  your SVG must scale to the window size
  and maintain its aspect ratio. [How?](#how)
* Quality trumps size
  – while 1k is a goal,
  don't sacrifice looks!
* You are encouraged to improve
  on already submitted logos!
* No raster data, `data:` urls or multi-file svgs.
  * Exception: As Firefox does not
    (and will not) support SVG fonts,
    do link external web fonts – for text. [How?](#how)
* Indent elements to show nesting depth.
* Generally stick to one element per line.
* Create a pull request:
  * Name it `Logo Name: <nnnn> bytes`
  * List `original: <url>`
    on the first line of your comment,
    linking a version of the logo on the web.

### Best practices

* Since one goal is teaching, think of your commits as a step by step guide:
* When optimizing, make separate commits for different operations you do.
* Write good commit messages about what you did, that others can learn from.
* When using tools, you are encouraged to name them in your commit messages.
* If it's a command-line tool, better still:
  paste your command line args further down in the message!

## How?

* To make an SVG scale,
  make sure your `<svg>` element
  has a `viewBox` attribute,
  and no `width`, `height` or
  [`preserveAspectRatio`](https://developer.mozilla.org/en-US/docs/SVG/Attribute/preserveAspectRatio)
  attributes (`xMidYMid meet`
  is already the default).
* If you want to link an external
  WOFF font from Google, for instance,
  [this way conserves size](https://github.com/johan/kilobyte-svg-challenge/commit/e6f68780dbc49dc2c48fdf73e2f2bb4f31e8365b).

## Tools

### Drawing

* [InkScape](http://inkscape.org/): a popular open source SVG editor
* [SVG Edit](http://svg-edit.googlecode.com/svn/trunk/editor/svg-editor.html): a free web browser based SVG editor
* [Illustrator](http://www.adobe.com/products/illustrator.html): a commercial vector graphics package from Adobe

### Optimizers

* [Scour](http://www.codedread.com/scour/) [[launchpad](https://launchpad.net/scour)]: a python module / script by Jeff Schiller to shrink SVG file sizes
* [SVG Cleaner](http://libregraphicsworld.org/blog/entry/introducing-svg-cleaner): a similar perl script with a graphical UI wrapper
* [SVG-Cleaner](https://npmjs.org/package/svg-cleaner) [[github](https://github.com/preciousforever/SVG-Cleaner)]: a javascript npm port of (parts of) Scour
* [svgtidy](http://intertwingly.net/code/svgtidy/svgtidy.rb): a ruby script by Sam Ruby
* [CleanSVG](http://cleansvg.codeplex.com/): a .NET windows tool by Microsoft
* [SVG Optimizer](https://github.com/svg/svgo#readme):  a Nodejs-based tool by Kir Belevich
* Your favourite text editor! - Emacs, vim, Textmate, et cetera all work great

## Legal

All logos, copyrights,
trademarks and other legal rights
to the images in this repository
belong to their respective owners,
not the people submitting
vectorized versions thereof.

If you find your logo represented here
and would rather have people use whatever
inferior non-scalable, slow-loading,
pixellated raster graphics version
they find when talking about you on the web,
just submit an [issue](https://github.com/johan/kilobyte-svg-challenge/issues) mentioning "takedown"
in its title, list the url to the logo in question,
and it will of course be removed from here.
