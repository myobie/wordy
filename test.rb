require_relative 'server'

dictionary = Dictionary.new

print "Amount of words chosen: "
puts dictionary.random_words.length

require 'benchmark/ips'

puts "Benchmarking"

Benchmark.ips do |x|
  x.report("not-lazy") do
    dictionary.random_words
  end

  x.report("lazy") do
    dictionary.random_words_lazy
  end
end
