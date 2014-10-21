Ohai.plugin(:DiskStats) do
  provides 'disk_stats'
  collect_data(:default) do
    disk_stats "test"
  end
end
