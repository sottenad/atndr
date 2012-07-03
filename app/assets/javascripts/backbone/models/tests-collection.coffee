
class Test extends Backbone.Model
  console.log('Test model')
  defaults:
    bands: 'Boshi'
    time: '12'
    location: 'SF'
    lat: null
    long: null

    
    
class Tests extends Backbone.Collection
  console.log('Tests collection')
  model : Test
  url : '/events.json'


class testView extends Backbone.View
  el : '#container'

  initialize : ->
    console.log('testView init')
    this.render()
    _.bindAll(this, 'render')
    this.collection.bind('reset', this.render)

  render : ->
    div = $('#container').empty()
    this.collection.fetch()

    this.collection.each (item) ->
      $('<li>').text(item.get('bands') + ': ' + item.get('location')).appendTo(div)
    return this

jQuery(document).ready ($) ->
  
  App =
    Models: {}
    Collections: {}
    Routers: {}
    Views: {}

  
  class ApplicationRouter extends Backbone.Router
    routes:
      ''          : 'test'
    
    test: ->
      appview = new testView({ collection: new Tests() })     
    
      
      
  # initialize the controller and history
  theRouter = new ApplicationRouter()
  Backbone.history.start pushState: true