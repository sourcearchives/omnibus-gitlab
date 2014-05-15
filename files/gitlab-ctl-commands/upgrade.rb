add_command('upgrade', 'Upgrade the current GitLab (service will be interrupted).') do
  status = run_command("chef-solo -c #{base_path}/embedded/cookbooks/solo.rb -j #{base_path}/embedded/cookbooks/upgrade.json")
  if status.success?
    log "#{display_name} Upgraded!"
    exit! 0
  else
    exit! 1
  end
end
