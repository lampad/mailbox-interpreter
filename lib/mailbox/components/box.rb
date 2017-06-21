require 'mailbox/components/rule'

module Mailbox
  module Components
    class Box

      attr_reader :id,:rules,:messages

      def initialize(id)
        @id=id
        @rules={}
        @messages=[]
      end

      def add_rule(rule,name)
        if !rule.class==Rule
          raise ArgumentError,"rule must be of type Rule"
        end
        if !name.class==String
          raise ArgumentError,"name must be of type String"
        end
        @rules[name]=rule
      end

      def has_rule?(rule)
        if @rules[rule]==nil
          return false
        else
          return true
        end
      end

      def get_rule(name)
        return @rules[name]
      end

      def add_message(message)
        if !message.class==String
          raise ArgumentError,"message must be of type String"
        end
        @messages.push message
      end

      def execute(rule,boxes)
        boxes,rprocess=@rules[rule].execute(boxes,"")
        return boxes,rprocess
      end

    end
  end
end
