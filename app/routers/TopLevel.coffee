class TopLevel extends BaseRouter
  
  routes:
    'home': 'index'
    
  index: -> new (require 'views/Viewport/Main')
    

module.exports = TopLevel