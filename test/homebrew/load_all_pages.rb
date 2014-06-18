#!/usr/bin/env ruby

(1..20).each do |num|
  system "open https://www.builtbyswift.com/products/#{num}"
  sleep(1)
  system "open https://www.builtbyswift.com/products/#{num}/order"
  sleep(1)
end
