require 'bundler'
Bundler.setup

require 'json'
require 'sinatra'
require 'delegate'

class Range
  def random
    rand(self.end - self.begin) + self.begin
  end

  def self.random_between(b, e)
    new(*(2.times.map { (b..e).random }.sort))
  end
end

class Dictionary < SimpleDelegator
  WORDS = File.expand_path("../words/Words/en.txt", __FILE__).freeze
  TOTAL = 274907

  def initialize
    super(File.open(WORDS))
  end

  def all_words
    each_line.to_a
  end

  def random_range
    Range.random_between(0, 235886)
  end

  def random_words
    range = random_range
    each_with_index.select { |_, index| range.cover?(index) }.map { |line, _| line.chomp }
  end

  def random_words_lazy
    range = random_range
    lazy.each_with_index.select { |_, index| range.cover?(index) }.map { |line, _| line.chomp }.force
  end
end

class Server < Sinatra::Base
  get "/words" do
    content_type "application/json"
    body JSON.generate(Dictionary.new.random_words)
  end
end
