#! /usr/bin/env coffee

JSDOM = require('jsdom')
HTTPS = require('https')
URL   = require('url')
FS    = require('fs')
Q     = require('q')

HOST   = 'https://api.github.com'
CLOSED = '/repos/johan/kilobyte-svg-challenge/pulls?state=closed'

JSDOM.defaultDocumentFeatures =
  FetchExternalResources: false   # ['script'] also img|css|frame|iframe|link
  ProcessExternalResources: false # ['script']

readFile = Q.nfbind FS.readFile
saveFile = Q.nfbind FS.writeFile

getJSON = (url) ->
  deferred = Q.defer()
  HTTPS.get URL.parse(url), (res) ->
    #console.log "Got https resonse!"
    res.setEncoding 'utf8'
    raw = ''
    res.on 'data', (piece) -> raw += piece
    res.on 'end', ->
      try
        deferred.resolve JSON.parse raw
      catch e
        deferred.reject e
  #console.log "json request for #{url}"
  deferred.promise

# HTTPS.get url.parse(pc), (res) -> res.setEncoding('utf8');res.on('data', show)

pluck = (what) -> (obj) -> obj[what]

# great for filtering away falsities
I = (i) -> i

uniq = (arr, props) ->
  seen = {}
  left = []
  arr.forEach (i) ->
    key = props.map((p) -> i[p]).join '\0'
    return seen[key]++  if seen.hasOwnProperty key
    seen[key] = 1
    left.push i
  left

# get all closed pull requests
Q.when(getJSON("#{HOST}#{CLOSED}")).then (closed) ->
  unless closed.length
    console.error "Eep! #{JSON.stringify closed}"

  # single out all merged pull requests, get their title and file size
  merged = closed.filter((pull) -> pull.merged_at).map (pull, i) ->
    #console.log(JSON.stringify pull)

    desc = pull.title
    info = Q.defer() # gather all the rest of the metadata asynchronously:

    # url: 'https://api.github.com/repos/johan/kilobyte-svg-challenge/pulls/25'
    Q.when(getJSON("#{pull.url}/files")).then (changed) ->
      svgs = changed.filter (file_info) -> /\.svg$/.test file_info.filename
      unless svgs.length
        info.resolve null # a pull request that fixed some docs or tools, say
      else
        path = svgs[0].filename # e g: 'logos/pirate-party-sweden.svg'
        img  = "<img src='#{path}'/>"
        #console.log "path: #{path}"
        Q.when(readFile(path, 'utf8')).then (file) ->
          #console.log "read: #{file and file.length}"
          img = file  if /@import/.test(file) # inlines images w/ external fonts
          info.resolve path: path, size: file.length, desc: desc, img: img
      info.promise # return the promise to collate in the "merged" array

  li = (svg) ->
    path = svg.path
    desc = svg.desc.replace(/^Corrected |:[^:]*$/gi, '')
    what = "#{desc}: #{svg.size} bytes".replace /\x27/g, '&apos;'
    is_1k = if svg.size <= 1024 then 'onek' else 'more'
    "<li class='#{is_1k}'><a title='#{what}' href='#{path}'>#{svg.img}</a></li>"

  Q.when(Q.all(merged)).then (svgs) ->
    recent = uniq(svgs.filter(I), ['path']).slice(0,12).map(li).join('\n  ')
    Q.when(readFile('index.html', 'utf8')).then (html) ->
      doc = JSDOM.jsdom(html)
      ul  = doc.querySelector('ul.svgs')
      ul.innerHTML = "\n  #{recent}\n"
    # html = (new XMLSerializer).serializeToString doc
      html = "<!DOCTYPE html>\n#{doc.documentElement.outerHTML}\n"
      Q.when(saveFile('index.html', html, 'utf8')).then process.exit
