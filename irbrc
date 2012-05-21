$LOAD_PATH << File.expand_path('~/.ruby')

require 'irb/completion'
require 'irb/ext/save-history'
require 'logger'

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"
IRB.conf[:PROMPT_MODE] = :SIMPLE

if ENV.include?('RAILS_ENV')&& !Object.const_defined?('RAILS_DEFAULT_LOGGER')
   Object.const_set('RAILS_DEFAULT_LOGGER', Logger.new(STDOUT))
elsif defined?(ActiveRecord)
   ActiveRecord::Base.logger = Logger.new(STDOUT)
   ActiveSupport::Cache::Store.logger = Logger.new(STDOUT)
end

# Easily print methods local to an object's class
class Object
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
end

def copy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
end

def copy_history
  history = Readline::HISTORY.entries
  index = history.rindex("exit") || -1
  content = history[(index+1)..-2].join("\n")
  puts content
  copy content
end

def paste
  `pbpaste`
end