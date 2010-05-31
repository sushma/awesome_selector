namespace :awesome_selector do

  desc 'Setup invitable plugin.'
  task :setup do
    target = "#{Rails.root}/public/"
    source = Dir["vendor/plugins/awesome_selector/assets/*"]
    FileUtils.mkdir_p(target) unless File.directory?(target)
    FileUtils.cp_r source, target
  end

  desc "Uninstall awesome_selector plugin" 
  task :uninstall => :environment do
    images_path = "#{Rails.root}/public/images/awesome_selector"
    javascripts_path = "#{Rails.root}/public/javascripts/awesome_selector"
    stylesheets_path = "#{Rails.root}/public/stylesheets/awesome_selector"
    FileUtils.rm_r images_path if File.directory?(images_path)
    FileUtils.rm_r javascripts_path if File.directory?(javascripts_path)
    FileUtils.rm_r stylesheets_path if File.directory?(stylesheets_path)
  end

end
