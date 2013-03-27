require "fog"

class Featured
  class DynamoHelper

    def initialize(aws_access_key, aws_secret_key, table_name, region = "us-east-1")
      @aws_access_key = aws_access_key
      @aws_secret_key = aws_secret_key
      @table_name     = table_name
      @region         = region
    end

    def db
      @db ||= Fog::AWS::DynamoDB.new(:aws_access_key_id => @aws_access_key, :aws_secret_access_key => @aws_secret_key, :region => @region)
    end

    def put(item)
      db.put_item(@table_name, item)
    end

    def query(id)
      response = db.query(@table_name, {:S => id})
      response.body['Items']
    end

    def inspect
      "#<Featured::DynamoHelper>"
    end

    alias to_s inspect
  end
end
