require 'nokogiri'
require 'open-uri'
require 'colorize'
require 'pry'
require './comment'
require './scraper'
class Post
  attr_accessor :title, :doc, :points, :comments
  include Scraper

  def initialize(url, points, comment_title)
    @doc = Nokogiri::HTML(open(url).read)
    @comments = []
    @points = points
    @title = comment_title
    extract
  end

  def to_s
    string = ''

    string << "#{@title}\n".yellow << "#{'=' * ((@title.length) - (@points.length + 1))} ".green
    string << "#{@points}\n".light_green
    @comments.each do |post|
      string << post.to_s
    end
    puts string
  end

  def extract
    @points = scrape_points[0].to_s
    @title = scrape_title[0].to_s
    combine_users_comments.each_slice(2) do |user, comment|
      @comments << Comment.new(user.to_s, comment.to_s)
    end
  end

  def combine_users_comments
    users = scrape_users
    comments = scrape_comments
    users.zip(comments).flatten.compact
  end
end
