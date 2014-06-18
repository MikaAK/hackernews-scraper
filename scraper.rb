require 'nokogiri'

module Scraper
  def scrape_points
    @doc.search('.subtext > span:first-child').map { |span| span.inner_text}
  end

  def scrape_title
    @doc.search('.title > a:first-child').map { |link| link.inner_text}
  end

  def scrape_comments
    @doc.search('.comment > font:first-child').map { |font| font.inner_text}
  end

  def scrape_users
    @doc.search('.comhead > a:first-child').map { |element| element.inner_text }
  end

  def scrape_main_titles
    @doc.search('.title').map { |text| text.inner_text }
  end

  def scrape_main_comments_number
    @doc.search('.subtext :last-child').map { |text| text.inner_text }
  end

  def scrape_main_comments_url
    @doc.search('.subtext :last-child').map { |text| "https://news.ycombinator.com/" << text.attributes['href'].value }
  end
end
