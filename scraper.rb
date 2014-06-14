require './comment'
require './post'

url = ARGV[0]

unless ARGV.length == 1
  puts 'Wrong number of arguments!'
  puts 'Usage: hackernews [url]'
  exit
end

post = Post.new url

post.to_s
