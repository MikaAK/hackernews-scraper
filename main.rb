require 'open-uri'
require './scraper'
require './post'
require 'pry'
require 'nokogiri'

class MainPage
  include Scraper
  attr_accessor :doc, :titles

  class << self
    attr_accessor :posts
  end
  @posts = []

  def initialize
    @doc = Nokogiri::HTML(open("https://news.ycombinator.com/").read)
    @titles = []
    extract
    generate_titles
  end

  def to_s
    string = ""
    count = 0
    MainPage.posts.each do |post|
      string << "#{count}: "
      string << "#{post.title}\n".yellow
      count += 1
    end
    string
  end

  def generate_titles
    @titles[0].each do |number, comments_info|
      MainPage.posts << Post.new(comments_info[2], comments_info[1], comments_info[0])
    end
  end

  def extract
    @titles << get_titles
    urls = get_url
    comment_nums = get_comment_number
    comments = comment_nums.zip(urls).flatten
    @titles.each do |post|
      merge_comments_and_url post, comments
    end
  end

  def merge_comments_and_url(post, comments)
    count = 0
    comments.each_slice(2) do |number, url|
      post.values[count] << number
      post.values[count] << url
      count += 1
    end
  end

  def get_titles
    hash = {}
    scrape_main_titles.each_slice(2) do |number, title|
      hash[number.to_sym] = [title] unless !title
    end
    hash
  end

  def get_url
    scrape_main_comments_url
  end

  def get_comment_number
    var = scrape_main_comments_number
    var.map! do |string|
      if string =~ /discuss/
        string = '0'
      else
        string = string[/\d+/]
      end
    end
    var
  end
end
