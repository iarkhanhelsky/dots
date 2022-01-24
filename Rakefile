require 'pathname'

require_relative 'lib/dots'

# Path to home dir
HOME = ENV['HOME']
puts "Your home @ #{HOME}"

# Path to zsh custom pieces
ZSH_CUSTOM_DIR = File.join(HOME, '.zsh.custom.d')
# List of third party ZSH plugins
ZSH_PLUGINS = {
  'oh-my-zsh-hg-prompt/mercurial-prompt' => 'mercurial-prompt'
}.freeze
ZSH_PLUGINS_HOME = 'zsh-plugins'.freeze

task :default => [:link, :configure]

task :link => [:link_rc, :link_zsh_plugins]

task :link_rc do
  rc_folders = Dots.select_folders('rc')
  puts " :: Using #{rc_folders.size} rc folders:"
  puts "   - " + rc_folders.join("\n   - ")

  Dots.link_all(rc_folders, home: HOME)
end

task :link_zsh_plugins do
  plugins = File.expand_path(File.join(ZSH_CUSTOM_DIR, 'plugins'))
  mkdir_p(plugins)
  ZSH_PLUGINS.each do |src, dst|
    ln_s(File.expand_path(File.join(ZSH_PLUGINS_HOME, src)), File.join(plugins, dst), force: true)
  end
end

task :configure do 
  configure_folders = Dots.select_folders('configure')
  puts " :: Using #{configure_folders.size} configure folders:"
  puts "   - " + configure_folders.join("\n   - ")

  configure_folders.each do |folder|
    Dir["#{folder}/*.sh"].each do |sh|
      puts "Apply #{sh}"
      puts `#{sh}`
    end
  end
end
