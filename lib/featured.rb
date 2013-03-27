require "featured/dynamo_helper"
require "featured/feature"

class Featured

  def initialize(*args)
    @db = DynamoHelper.new(*args)
  end

  def on(id, name)
    Feature.new.tap do |feature|
      feature.item = {}
      feature.id = id
      feature.name = name
      @db.put(feature.item)
    end
  end

  def off(id, name)
    @db.delete(id, name)
  end

  def get(id)
    items = @db.query(id)
    items.map do |item|
      item.name
    end
  end
end
