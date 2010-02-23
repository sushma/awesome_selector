namespace :awesome_selector do

  desc 'Setup invitable plugin.'
  task :setup do
    target = "#{Rails.root}/public/"
    source = Dir["vendor/plugins/awesome_selector/assets/*"]
    FileUtils.mkdir_p(target) unless File.directory?(target)
    FileUtils.cp_r source, target
  end

end
