#!/usr/bin/env ruby
require_relative 'comment.rb'
require_relative 'post.rb'

url = ARGV[0]

unless ARGV.length == 1
  puts 'Wrong number of arguments!'
  puts 'Usage: hackernews [url]'
  exit
end
begin
post = Post.new url

post.to_s

rescue StandardError
  puts "Invalid Url"
end
