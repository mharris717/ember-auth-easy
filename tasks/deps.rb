task :overapp_dep do
  ec "bundle update overapp"
  ec "git add Gemfile.lock"
  ec "git commit -m 'overapp dep'"
  ec "git push origin travis:travis"
end