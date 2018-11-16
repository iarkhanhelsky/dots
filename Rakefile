include FileUtils::Verbose

# Path to home dir
HOME = ENV['HOME']
# Path to zsh custom pieces
ZSH_CUSTOM_DIR = File.join(HOME, '.zsh.custom.d')

# This files goes HOME with . prefix
# Although it possible to do just Dir['rc/*'] manual file listing gives more
# control. I think.
DOTS = %w(rc/nanorc
          rc/profile
          rc/xinitrc
          rc/Xresources
          rc/xsession
          rc/zshrc

          rc/nanorc.d
          ).freeze

# Folders from ~/.config
CONFIG = %w(rc/config/rofi)

# List of third party ZSH plugins
ZSH_PLUGINS = {
  'oh-my-zsh-hg-prompt/mercurial-prompt' => 'mercurial-prompt'
}.freeze
ZSH_PLUGINS_HOME = 'zsh-plugins'.freeze

puts "Your home @ #{HOME}"

task :default => :link

task :link => %i(link_rc link_config link_zsh_plugins)

task :link_rc do
  DOTS.each do |file|
    dst = File.join(HOME, '.' + File.basename(file))
    src = File.expand_path(file)
    ln_s(src, dst, force: true)
  end
end

task :link_config do
  CONFIG.each do |file|
    dst = File.join(HOME, '.config', File.basename(file))
    src = File.expand_path(file)
    ln_s(src, dst, force: true)
  end
end

task :link_zsh_plugins do
  plugins = File.expand_path(File.join(ZSH_CUSTOM_DIR, 'plugins'))
  mkdir_p(plugins)
  ZSH_PLUGINS.each do |src, dst|
    ln_s(File.expand_path(File.join(ZSH_PLUGINS_HOME, src)), File.join(plugins, dst), force: true)
  end
end
