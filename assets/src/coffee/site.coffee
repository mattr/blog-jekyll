document.onload = (e) ->
  for link in document.links
    if link.hasAttribute('re') and link.getAttribute('rel') == 'external'
      link.setAttribute('target', '_blank')
  
  for codeblock in document.getElementsByTagName('pre')
    block.addEventListener('mouseover', showOverflow, false)
    block.addEventListener('mouseout', hideOverflow, false)
    
showOverflow = ->
  this.setAttribute('class','showall')

hideOverflow = ->
  this.setAttribute('class', '')
