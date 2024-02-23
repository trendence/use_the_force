class Activeforce::Base
  class Relation
    def initialize(client, target:)
      @client = client
      @filters = {}
      @target = target
      @soql = ""
    end

    def to_restforce_collection
      collection
    end

    def where(**other_filters)
      @filters.merge!(other_filters) unless other_filters.empty?

      conditions =
        @filters.map do |attr, value|
          if value.is_a?(String)
            "#{attr} = '#{value}'"
          elsif value.is_a?(Float)
            "#{attr} = #{value}"
          elsif [true, false].include?(value)
            "#{attr} = #{value}"
          else
            "#{attr} = '#{value}'"
          end
        end.join(" AND ")

      where_clause =
        if conditions.empty?
          ""
        else
          conditions.prepend(" WHERE ")
        end

      @collection = nil
      @soql = "SELECT #{@target.read_fields.join(", ")} FROM #{@target.read_table_name} #{where_clause}"
      collection # Right before "self" at the end of the `where` method
      self
    end


    def find(table, id)
      client.find(table.to_s, id.to_s)
    end

    def collection
      @collection ||= @client.query(@soql)
    end

    def method_missing(meth, *, &block)
      collection.send(meth, *, &block)
    end

    def respond_to_missing?(method_name, include_private = false)
      collection.respond_to?(method_name, include_private)
    end
  end

  class << self
    def all
      Relation.new(client, target: self).where
    end

    def where(**)
      Relation.new(client, target: self).where(**)
    end

    def find(table, id)
      Relation.new(client, target: self).find(table, id)
    end
    
    def find_by(**)
      where(**)&.first
    end

    def find_by!(**)
      unless (record = where(**)&.first)
        raise Activeforce::RecordNotFound
      end
      record
    end

    def fields(*list)
      @@fields = list
    end

    def table_name(name)
      @@table_name = name.to_s
    end

    def read_fields
      @@fields
    end

    def read_table_name
      @@table_name
    end

    protected

    def configuration
      {
        username: Activeforce.username,
        password: Activeforce.pw,
        api_version: Activeforce.api_version,
        client_id: Activeforce.client_id,
        client_secret: Activeforce.client_secret,
        security_token: Activeforce.security_token,
        instance_url: Activeforce.instance_url
      }
    end

    def client
      @@client ||= Restforce.new(**configuration)
    end
  end

  def initialize
    raise NotImplementedError
  end
end
