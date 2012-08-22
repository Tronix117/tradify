# This is base model class that provides special methods useful for templates
class BaseModel extends Backbone.Model
  
  # This is for compatibility with .eco templates
  escape: (attrOrData) =>
    if @attributes[attrOrData]? then super else _.escape attrOrData + ''

module.exports = BaseModel