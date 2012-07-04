jQuery(document).ready ($) ->  
  class ApplicationRouter extends Backbone.Router
    routes:
      ''          : 'test'

    test: ->
      console.log
      appview = new Atndr.Views.TestView({ collection: new Atndr.Collections.Tests() })
      #appview.render()    

  # initialize the controller and history
  Atndr.router = new ApplicationRouter()
  Backbone.history.start pushState: true