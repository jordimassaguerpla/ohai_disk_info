Ohai.plugin(:DiskStats) do
  provides 'disk_stats'
  collect_data(:linux) do
    disk_stats Mash.new
    so = shell_out("iostat -d -k")
    parsing_dev = false
    so.stdout.lines do |line|
      next if line == "\n"
      if line =~ /Device:.*/
        if line !~ /^Device:\s+tps\s+kB_read\/s\s+kB_wrtn\/s\s+kB_read\s+kB_wrtn\s*$/
          $stderr.puts "ERROR: iostat output format is not what I would expect. I was expecting to match the following regular expression"
          $stderr.puts "        /^Device:\s+tps\s+kB_read\/s\s+kB_wrtn\/s\s+kB_read\s+kB_wrtn\s*$/"
          disk_stats Mash.new
          break
        end
        parsing_dev = true
        next
      end
      next unless parsing_dev
      stats = line.split(" ")
      if !stats || stats.length != 6
        $stderr.puts "ERROR: iostat output format is not what I would expect. I was expecting 6 columns separated by spaces and I have: \n#{line}"
        disk_stats Mash.new
        break
      end
      disk_stats[stats.first] = {
                                 :tps => stats[1],
                                 :kB_read_s => stats[2],
                                 :kB_wrtn_s => stats[3],
                                 :kB_read => stats[4],
                                 :kB_wrtn => stats[5]
                                }
    end
  end
end
