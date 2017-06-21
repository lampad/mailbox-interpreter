require 'mailbox/components/box'
require 'mailbox/components/rule'
require 'mailbox/components/command'

module Mailbox
  module Interpreter

    @@boxes = []

    def self.parse_program(program)
      raise "Unknown program type: #{program.inspect}" unless program.is_a?(String)

      current_box = nil
      current_rule = nil
      program.each_line do |line|
        line_parts = line.split(" ")
        if line_parts.first == "box"
          current_box = Components::Box.new(line_parts.last.to_i)
          puts "Created box #{current_box.id}"
          @@boxes << current_box
        elsif line_parts.first.include?("(")
          line = line_parts.join(" ").tr("()", "")
          puts "Creating rule: #{line}"
          current_rule = current_box.add_rule(Components::Rule.new,line) if current_box
        else
          if line_parts.first == "send"
            puts "SEND:#{line_parts}"
            string=""
            istring=false
            line_parts.each do |part|
              if part.include? "\"" and istring
                string+=part.tr("\"","")
                break
              elsif part.include? "\"" and !istring
                string+=part.tr("\"","")
                istring=true
              elsif istring
                string+=part
              end
            end
            bnum=line[line.length-1]
            cmd = Components::Command.new("send",string,bnum)
          end
          if line_parts.first == "output"
            puts "OUTPUT:#{line_parts}"
            if line_parts[1]=="without"
              cmd = Components::Command.new("output without",line_parts[2])
            else
              cmd = Components::Command.new("output")
            end
          end
          current_rule.add_cmd(cmd)
        end
      end
    end

    def self.run!
      raise "No boxes! Was the program parsed?" if @@boxes.empty?
      while true do
        puts "New loop"
        rprocess=false
        nboxes=@@boxes
        @@boxes.each do |box|
          puts "Handling box #{box}"
          puts "Now iterating through #{box.messages}"
          box.messages.each do |message|
            puts "Proccessing messsage #{message}"
            box.rules.each do |condition,rule|
              puts "Checking rule #{condition}"
              condition=condition.split(" ")
              if condition[0]=="contains"
                if message.include? condition[1].tr("\"","")
                  puts "Match for rule #{condition}"
                  nboxes,brprocess=rule.execute(@@boxes,message)
                  rprocess=true if rprocess==false && brprocess==true
                end
              end
            end
            puts "Done checking rules"
          end
          puts "Done processing messages"
        end
        puts "Done processing boxes"
        puts "rprocces:#{rprocess}"
        if !rprocess
          break
        end
      end
    end

  end
end
