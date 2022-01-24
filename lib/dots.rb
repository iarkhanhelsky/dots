require 'fileutils'

module Dots
    class << self
      include FileUtils::Verbose

      def link_all(folders, home: )
        commands = folders.flat_map { |f| link(Pathname.new(f), home: home) }
        check_uniq_dst(commands)
  
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

      def select_folders(prefix)
        folders = [prefix]
        folders << "#{prefix}-darwin" if /darwin/ =~ RUBY_PLATFORM
        folders << "#{prefix}-linux" if /linux/ =~ RUBY_PLATFORM
        folders << "#{prefix}-#{ENV['HOSTNAME']}" if File.exist?("#{prefix}-#{ENV['HOSTNAME']}")

        folders
      end
    end
  end
  