Ohai.plugin(:DiskInfo) do
  provides 'disk_info'
  collect_data(:linux) do
    disk_info Mash.new
    so = shell_out("sudo /usr/sbin/hwinfo --disk")
    id = nil
    so.stdout.lines do |line|
      next if line == "\n"
      case line
      when /^(\d+:.+)$/
        # example:
        # "21: IDE 00.0: 10600 Disk"
        id = $1
        disk_info[id] = {}
      when /^  (\S+.+):\s*(.+)$/
        # example:
        # "  Unique ID: 3OOL.XY5J+TDTJB3"
        key = $1
        value = $2
        disk_info[id][key] = value if id && disk_info[id]
      else
        $stderr.puts "WARNING: ignoring this line #{line}"
      end
    end
  end
end
