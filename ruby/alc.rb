#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "nokogiri"
require "open-uri"
require "optparse"

class AlcResults
  attr_accessor :all

  def initialize(search_term, limit = nil)
    uri = "http://eow.alc.co.jp/#{URI.escape(search_term)}/UTF-8"
    page = Nokogiri::HTML(open(uri, "User-Agent" => "Ruby/#{RUBY_VERSION}"))
    lis = page.css("div#resultsList > ul > li")
    lis = lis[0...limit] if limit

    # Remove some stuff we don't care about
    lis.each{|li| li.css("span.kana, span.exp").each(&:remove) }

    # Store translations as a hash of "from language" => "to language" pairs
    @all = []
    lis.each{|li| @all << [li.css(".midashi").text, translation(li)] }
  end

  def to_s
    @all.map{|k,v| "#{k}\n#{v}"}.join("\n")
  end

  private
    #Returns a formatted string representation of a single Alc translation
    def translation(li)
      if li.at(".wordclass")
        #Translation is one or more .wordclass elements, each one followed by one or more <ol> elements
        li.css("div").children.map do |el|
          if el["class"] == "wordclass"
            el.text + "\n"
          elsif el.name == "ol"
            format_ol(el)
          end
        end.join
      elsif li.at("ul")
        #Single <ul> element
        format_ul(li)
      elsif li.at("ol")
        #One or more <ol> elements
        format_ol(li)
      elsif li.at("div")
        #Just a single text node
        format_entry(li.css("div"))
      end
    end

    # Unordered list: Convert to a list of bullet points
    def format_ul(ancestor_el)
      ancestor_el.css("li").map{|li| format_entry(li)}.join
    end

    # Ordered list: Convert to a numbered list
    # Exception: If there's just one entry (just a text node, no <li> elements) convert to a single bullet point
    def format_ol(ancestor_el)
      ancestor_el.at("li") ? ancestor_el.css("li").each_with_index.map{|li,i| "    #{i+1}. #{li.text}\n"}.join : format_entry(ancestor_el)
    end

    # Convert the text of an element into indented bullet point(s)
    def format_entry(el)
      str = "    - #{el.text}\n"

      # If the entry contains an Alc label, split that into a bullet point
      ["【表現パターン】"].each{|label| str = str.gsub(label, "\n    - " + label)}
      str
    end
end


limit = nil
OptionParser.new do |opt|
  opt.on("-n N", Integer){|n| limit = n}
  opt.parse!(ARGV)
end

exit if ARGV.empty?

puts AlcResults.new(ARGV.join(" "), limit).to_s

