require 'nokogiri'
require 'open-uri'
require 'colorize'
require 'pry'
require './comment'
class Post
  attr_accessor :title, :doc, :points

  class << self
    attr_accessor :comments
  end

  @comments = []

  def initialize(url)
    @doc = Nokogiri::HTML(open(url.to_s).read)
    extract
    puts self.to_s
  end

  def to_s
    string = ''

    string << "#{@title}\n".yellow << "#{'=' * ((@title.length) - (@points.length + 1))} ".green
    string << "#{@points}\n".light_green
    Post.comments.each do |post|
      string << post.to_s
    end
    puts string
  end

  def extract
    @points = scrape_points[0].to_s
    @title = scrape_title[0].to_s
    combine_users_comments.each_slice(2) do |user, comment|
      Post.comments << Comment.new(user.to_s, comment.to_s)
    end
  end

  def combine_users_comments
    users = scrape_users
    comments = scrape_comments
    users.zip(comments).flatten.compact
  end

  def scrape_points
    @doc.search('.subtext > span:first-child').map { |span| span.inner_text}
  end

  def scrape_title
    @doc.search('.title > a:first-child').map { |link| link.inner_text}
  end

  def scrape_link
    @doc.search('.title > a:first-child').map { |link| link['href']}
  end

  def scrape_comments
    @doc.search('.comment > font:first-child').map { |font| font.inner_text}
  end

  def scrape_users
    @doc.search('.comhead > a:first-child').map { |element| element.inner_text }
  end
end
