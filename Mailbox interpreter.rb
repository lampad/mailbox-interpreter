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
pprog=[]
crule=""
prog=<<-END
box 0
(once)
send "outputHello, world!" to 0
(contains "output")
output without "output"
END
prog=prog.split("\n")
cbox=nil
lno=0
boxes=[]
while true
  line=prog[lno].split(" ")
  if line[0]=="box"
    cbox=line[1].to_i
    puts "Now in box #{cbox}"
  elsif line[0].include? "("
    line=line.join(" ").tr("()","")
    puts "RULE: #{line}"
    crule=line
    if !boxes[cbox]
      boxes[cbox]=Box.new(cbox)
    end
    boxes[cbox].add_rule(Rule.new,line)
  else
    if line[0]=="send"
      puts "SEND:#{line}"
      string=""
      istring=false
      line.each do |part|
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
      cmd=Command.new("send",string,bnum)
    end
    if line[0]=="output"
      puts "OUTPUT:#{line}"
      if line[1]=="without"
        cmd==Command.new("output without",line[2])
      else
        cmd==Command.new("output")
      end
    end
    boxes[cbox].get_rule(crule).add_cmd(cmd)
  end
  if lno==prog.length-1
    break
  end
  lno+=1
end
cbox=nil
boxes.each do |box|
  if box.has_rule? "once"
    boxes,_=box.execute("once",boxes)
  end
end
while true do
  puts "New loop"
  rprocess=false
  nboxes=boxes
  boxes.each do |box|
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
            nboxes,brprocess=rule.execute(boxes,message)
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