# In child class, we can choose if navigate is allowed or canceled by
# overloading @canOpen(newFragment, routeMatched, next, cancel), inside, if 
# next() is called, the page will change, if cancel() is called, then 
# navigation action will be canceled.
# @currentFragment can be usefull to know on which page we are right now.

class BaseRouter extends Backbone.Router

module.exports = BaseRouter