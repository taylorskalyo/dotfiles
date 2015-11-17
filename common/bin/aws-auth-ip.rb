#!/usr/bin/env ruby

require 'rubygems'
require 'aws-sdk'
require 'open-uri'
require 'optparse'
require 'ostruct'

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red; colorize(31) end
  def green; colorize(32) end
  def yellow; colorize(33) end
end

def program_name
  File.basename($PROGRAM_NAME, File.extname($PROGRAM_NAME))
end

def current_ip
  open('http://whatismyip.akamai.com').read
end

def perform_action(action, security_groups, protocol, port, ip_range)
  case action
  when :revoke
    puts "Revoking #{ip_range} #{port} #{protocol} ..."
    command, success_msg = [:revoke_ingress, :revoked]
  else
    puts "Authorizing #{ip_range} #{port} #{protocol} ..."
    command, success_msg = [:authorize_ingress, :authorized]
  end

  security_groups.each do |sg|
    begin
      sg.send(command, protocol, port, ip_range)
      msg = success_msg.to_s.capitalize.green
    rescue AWS::EC2::Errors::InvalidPermission::Duplicate, AWS::EC2::Errors::InvalidPermission::NotFound => e
      msg = "No action taken".yellow
      warn = e.message
      next
    rescue => e
      msg = "Failed".red
      error = [e.class, e.message].join(" - ")
      next
    ensure
      puts [sg.group_id, msg].join " - "
      if @verbose
        puts "\twarning: " + warn if warn
        puts "\terror:   " + error if error
        puts "\tsg-name: " + sg.name
        puts "\tsg-desc: " + sg.description
      end
    end
  end
end

def remember(file, protocol, port, ip_range, ignore_list=[])
  lines = File.open(file, 'r').readlines
  new_entry = [protocol, port, ip_range].join(",")
  if ignore?(ignore_list, ip_range)
    puts "Not remembering #{ip_range}" if @verbose
  else
    lines << new_entry
  end
  File.open(file, 'w') do |f|
    Set.new(lines).each do |line|
      if ignore?(ignore_list, line) and @verbose
        puts "Forgetting: #{line}"
      else
        f.puts line
        puts "Remembering: #{line}" if @verbose
      end
    end
  end
end

def forget_all(file)
  if @verbose
    File.open(file, 'r').each do |line|
      puts "Forgetting: #{line}"
    end
  end
  File.truncate(file, 0)
end

def ignore?(ignore_list, ip_range)
  ignore_list.find {|ignore| ip_range =~ /#{ignore}/}
end

def revoke_all(file, security_groups, ignore_list)
  File.open(file, 'r').each do |line|
    protocol, port, ip_range = line.strip.split(',')
    unless ignore?(ignore_list, ip_range)
      perform_action(:revoke, security_groups, protocol, port, ip_range)
    end
  end
  forget_all(file)
end

if __FILE__ == $PROGRAM_NAME
  # Defaults
  security_group_names = []
  security_group_ids = []
  ip_ranges = []
  protocol = 'tcp'
  port = 22
  action = nil
  remember = false
  mem_file = "~/.#{program_name}.hist"
  revoke_all = false
  forget_all = false
  ignore_list = []
  @verbose = false

  OptionParser.new do |opts|
    opts.banner = "Usage: #{program_name} [options]"

    opts.on('-n', '--security-group-names NAMES', Array, "Security group names") { |names| security_group_names = names }
    opts.on('-d', '--security-group-ids IDS', Array, "Security group IDs") { |ids| security_group_ids = ids }
    opts.on('-i', '--ip-ranges IP-RANGES', Array, "IP ranges to authenticate (defaults to current IP)") { |ips| ip_ranges = ips }
    opts.on('-P', '--protocol PROTOCOL', "Protocol (default is #{protocol}") { |p| protocol = p }
    opts.on('-p', '--port PORT', Integer, "Port (default is #{port}") { |p| port = p }
    opts.on('-r', '--revoke', "Revoke access") { action = :revoke }
    opts.on('-a', '--authorize', "Authorize access") { action = :auth }
    opts.on('-m', '--remember', "Remember the IP address being authorized (useful for revoking later)") { remember = true }
    opts.on('-f', '--file FILE', "File to use for remembering IP addresses (default is #{mem_file})") { |file| remember_file = file }
    opts.on('-R', '--revoke-all', "Revoke and forget all remembered IP addresses") { revoke_all = true }
    opts.on('-F', '--forget-all', "Forget all remembered IP addresses") { forget_all = true }
    opts.on('-I', '--ignore-ip-ranges IP-RANGES', Array, "Forget about these IP addresses and do not remember them if they are currently being authorized") { |ips| ignore_list = ips }
    opts.on('-v', '--verbose', "Output extra information") { @verbose = true }
    opts.on('-h', '--help', "Print this help and exit") { puts opts; exit }

  end.parse!

  mem_file = File.expand_path(mem_file)
  ip_ranges << "#{current_ip}/32" if ip_ranges.size <= 0
  ec2 = AWS::EC2.new
  security_groups =
    if security_group_ids.size > 0
      ec2.security_groups.filter('group-id', security_group_ids)
    elsif security_group_names.size > 0
      ec2.security_groups.filter('group-name', security_group_names)
    else
      ec2.security_groups
    end

  if revoke_all
    # Do not revoke any IP addresses that we're about to authorize
    authorizing = (action == :auth) ? ip_ranges : []
    revoke_all(mem_file, security_groups, authorizing)
  end
  if action
    ip_ranges.each do |ip_range|
      perform_action(action, security_groups, protocol, port, ip_range)
    end
  end
  if forget_all
    forget_all(mem_file)
  end
  if remember and action == :auth
    ip_ranges.each do |ip_range|
      remember(mem_file, protocol, port, ip_range, ignore_list)
    end
  end

end
