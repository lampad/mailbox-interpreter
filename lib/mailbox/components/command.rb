module Mailbox
  module Components
    class Command

      attr_reader :type,:args

      def initialize(type,*args)
        @type=type
        @args=args
      end

      def execute(boxes,message)
        rprocess=false
        case @type
        when "send"
          rprocess=true
          boxes[args[1].to_i].add_message(args[0])
        end
        return boxes,rprocess
      end

    end
  end
end
