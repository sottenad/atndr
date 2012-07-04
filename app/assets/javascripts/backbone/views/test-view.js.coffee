class Atndr.Views.MapView extends Backbone.View
  el : '#container'

  initialize : ->
    _.bindAll(this, 'render')
    this.collection.fetch()
    this.collection.bind('reset', this.render)
    
  render : ->
    console.log('rendering')
    div = $('#container').empty()
    this.collection.each (item) ->
      $('<li>').text(item.get('bands') + ': ' + item.get('location')).appendTo(div)
    return this