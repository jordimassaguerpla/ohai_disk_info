require "ohai"
require "json"

Ohai::Config[:plugin_path] << File.join(File.dirname(__FILE__), "plugins")
o = Ohai::System.new
o.all_plugins
data = JSON::parse(o.attributes_print("disk_stats"))
puts data.inspect
data = JSON::parse(o.attributes_print("disk_info"))
puts data.inspect
