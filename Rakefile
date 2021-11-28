require 'pathname'
include FileUtils::Verbose

module Dots
  class << self
    def link_all(folders, home: )
      commands = folders.flat_map { |f| link(Pathname.new(f), home: home) }
      check_uniq_dst(commands)

      # commands.each { |c| puts "#{c[:dst]}: #{c[:cmd]}" }
      commands.each { |c| c[:cmd].call() }
    end

    def link(rc_path, home:)
      commands = []
      rc_path.children.each { |ch| link_entry(ch, rc_path, commands, home: home) }
      commands 
    end

    def link_entry(entry_path, rc_path, commands, home:)
      rel_path = entry_path.relative_path_from(rc_path)
      # Add '.' at the beginning
      home_path = Pathname.new(home) + ".#{rel_path}"
      if entry_path.file?
        return if entry_path.basename.to_s.start_with?('.')

        if home_path.exist?
          cmd = -> () { rm(home_path) }
          commands << { cmd: cmd, dst: nil, src: nil }
        end
        cmd = -> () { ln_s(File.join(Dir.pwd, entry_path.to_s), home_path) }
        commands << { cmd: cmd, dst: home_path, src: entry_path }
      else
        cmd = ->() { mkdir_p(home_path) }
        commands << { cmd: cmd, dst: nil, src: nil }
        entry_path.children.each { |ch| link_entry(ch, rc_path, commands, home: home) }
      end
    end

    def check_uniq_dst(commands)
      index = {}
      commands.each do |c|
        dst = c[:dst]

        next if dst.nil?

        raise(conflict(index[dst], c)) if index.key?(dst)
      end
    end

    def conflict(this, that)
      "Both #{this[:src]} and #{that[:src]} result #{this[:dst]}"
    end
  end
end

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

RC_FOLDERS = ['rc']
RC_FOLDERS << 'rc-darwin' if /darwin/ =~ RUBY_PLATFORM
RC_FOLDERS << 'rc-linux' if /linux/ =~ RUBY_PLATFORM
puts "Using #{RC_FOLDERS.size} rc folders:"
puts " - " + RC_FOLDERS.join("\n - ")

task :default => :link

task :link => %i(link_rc link_zsh_plugins)

task :link_rc do
  Dots.link_all(RC_FOLDERS, home: HOME)
end

task :link_zsh_plugins do
  plugins = File.expand_path(File.join(ZSH_CUSTOM_DIR, 'plugins'))
  mkdir_p(plugins)
  ZSH_PLUGINS.each do |src, dst|
    ln_s(File.expand_path(File.join(ZSH_PLUGINS_HOME, src)), File.join(plugins, dst), force: true)
  end
end
