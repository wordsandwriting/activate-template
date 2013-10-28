# Defines our constants
PADRINO_ENV  = ENV['PADRINO_ENV'] ||= ENV['RACK_ENV'] ||= 'development'  unless defined?(PADRINO_ENV)
PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

# Load our dependencies
require 'rubygems' unless defined?(Gem)
require 'bundler/setup'
require 'pp'
require 'csv'
require 'backtrace_shortener'
BacktraceShortener.monkey_patch_the_exception_class!
BacktraceShortener.filters.unshift(Proc.new do |backtrace|
    backtrace.reject { |line| line.include?(Gem.dir) }
  end)
Bundler.require(:default, PADRINO_ENV)

String.send(:define_method, :html_safe?){ true }

Padrino.before_load do    
  SimpleNavigation::config_file_paths << "#{Padrino.root}/lib"
  require 'will_paginate/view_helpers/sinatra'
  require 'will_paginate/mongoid'  
end

Padrino.after_load do
end

Padrino.load!

Mongoid.load!("#{PADRINO_ROOT}/config/mongoid.yml")
Mongoid.raise_not_found_error = false