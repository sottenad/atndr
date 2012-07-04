jQuery(document).ready ($) ->  
  class ApplicationRouter extends Backbone.Router
    routes:
      ''          : 'test'

    test: ->
      appview = new Atndr.Views.TestView({ collection: new Atndr.Collections.Tests() })    

  # initialize the controller and history
  Atndr.router = new ApplicationRouter()
  Backbone.history.start pushState: true