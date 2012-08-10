document.onload = function(e) {
  var links = document.links;
  for (i = 0; i < links.length; i++) {
    var link = links[i];
    if (link.hasAttribute('rel') && link.getAttribute('rel') == 'external') {
      link.setAttribute('target', '_blank');
    }
  }
  var codeBlocks = document.getElementsByTagName('pre');
  for (i = 0; i < codeBlocks.length; i++) {
    var block = codeBlocks[i];
    block.addEventListener('mouseover', function() { this.style.overflow = 'visible'; });
    block.addEventListener('mouseout', function() { this.style.overflow = 'hidden'; });
  }
};
