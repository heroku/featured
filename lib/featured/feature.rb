require "fog"

module Featured
  class Feature

    attr_accessor :item

    def self.db
      @db ||= Fog::AWS::DynamoDB.new(aws_access_key_id: ENV['AWS_ACCESS_KEY'], aws_secret_access_key: ENV['AWS_SECRET_KEY'])
    end

    def self.schema(attrs)
      attrs.each do |attr, type|
        class_eval "def #{attr}; @item['#{attr}']['#{type}'] if @item.key? '#{attr}' end", __FILE__, __LINE__
        class_eval "def #{attr}= value; @item['#{attr}'] = {'#{type}' => value} end", __FILE__, __LINE__
      end
    end

    schema entity: :S, name: :S, created_at: :N

    def self.set(item)
      entry = new
      entry.item = item
      entry
    end

    def self.init(entity, name)
      entry = new
      entry.item = {}
      entry.entity = entity
      entry.name = name
      entry.created_at = Time.now.to_i.to_s
      entry
    end

    def self.get(entity, name)
      response = db.get_item(:features, {HashKeyElement: {S: entity}, RangeKeyElement: {S: name}})
      if item = response.body['Item']
        set(item)
      end
    rescue
      nil
    end

    def self.gets(entity)
      response = db.query(:features, {S: entity})
      if items = response.body['Items']
        items.map do |item|
          set(item)
        end
      end
    rescue
      []
    end

    def self.put(entity, name)
      entry = init(entity, name)
      response = db.put_item(:features, entry.item, Expected: {entity: {Exists: false}, name: {Exists: false}})
    end
  end
end
