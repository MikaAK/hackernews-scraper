require 'colorize'
class Comment
  attr_accessor :user, :text

  def initialize(user, text)
    @user = user
    @text = text
  end

  def to_s
    "#{@user}".light_red + "\n#{@text}\n".red
  end
end
