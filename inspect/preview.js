$(document).ready(init);

var $path, $view, $svg, $sliders, viewbox;

var js, svg, path, paper, new_set, line;

function init() {
  $sliders = $('#sliders');
  $path = $('#path-editor').on('change', updateView);
  $view = $('#svg-preview');

  $.ajax(
  { type: 'GET'
  , url: $path.data('load')
  , dataType: "xml"
  , success: populateView
  });
}

function populateView(xml) {
  $path.val((new XMLSerializer).serializeToString(xml));
  parse(xml);
}

function parse(xml) {
  svg = xml.documentElement;
  $view.empty();
  viewbox = svg.attributes.getNamedItem('viewBox').value.trim()
              .split(/\s+/).map(Number);
  paper   = Raphael.apply(this, ['svg-preview'].concat(viewbox.slice(2)));
  new_set = paper.importSVG(xml);
  $svg = $view.find('svg:first').removeAttr('width').removeAttr('height');
  (svg = $svg[0]).setAttribute('viewBox', viewbox.join(' '));

  $sliders.empty();
  var total = 0, lengths = [];
  paper.forEach(function addSlider(path) {
    var i = path.id
      , b = path.getBBox() // for the path.realPath initialization side effect
      , n = lengths[lengths.length] = path.realPath.length
      , $range = $('<input type="range" id="p'+ i +'" min="0" max="'+ n +'"'+
                   ' value="0" />')
      ;
    $range.appendTo($sliders);
    $range.on('change', preview);
    total += n;
  });
  $sliders.find('input[type="range"]').each(function width(i) {
    $(this).css('width', (100 * lengths[i] / total) + '%');
  });
}


function updateView() {
  parse((new DOMParser).parseFromString($path.val(), 'text/xml'));
}

function preview(e) {
  var $r = $(this)
    , at = +$r.val()
    , id = +this.id.slice(1)
    , me = paper.getById(id)
    , ln = this.line
    ;
  path = path || me;
  if (ln) ln.remove();
  this.line = paper.path(me.realPath.slice(0, at));
  $r.attr('title', at +'/'+ me.realPath.length);
}

function node() {
  var js = { type: this.nodeName };
  for (var i = 0, A = this.attributes, n, a; a = A[i]; i++) {
    n = a.nodeName;
    if (n === 'd') n = 'path';
    js[n] = a.nodeValue;
  }
  return js;
}
