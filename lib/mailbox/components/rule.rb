require 'mailbox/components/command'

module Mailbox
  module Components
    class Rule

      attr_reader :cmds

      def initialize()
        @cmds=[]
      end

      def add_cmd(cmd)
        if !cmd.class==Command
          raise ArgumentError,"cmd must be of type Command"
        end
        @cmds.push cmd

      end

      def execute(boxes,message)
        rprocess=false
        @cmds.each do |cmd|
          boxes,crprocess=cmd.execute(boxes,message)
          rprocess=true if rprocess==false && crprocess==true
        end
        return boxes,rprocess
      end

    end
  end
end
