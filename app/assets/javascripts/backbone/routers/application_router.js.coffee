jQuery(document).ready ($) ->  
  class ApplicationRouter extends Backbone.Router
    routes:
      ''          : 'index'

    index: ->
      console.log
      appview = new Atndr.Views.MapView({ collection: new Atndr.Collections.Events() })

  # initialize the controller and history
  Atndr.router = new ApplicationRouter()
  Backbone.history.start pushState: true