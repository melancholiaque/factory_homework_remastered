require 'json'
require_relative 'data_layout'

class Lib
  def initialize(store = nil)
    @store = store || {}
    @params = LAYOUT
    LAYOUT.keys.each { |k| @store[k] = [] } unless store
  end

  def add(type, *args)
    ret = Hash[@params[type].zip args]
    @store[type].push(ret)
    ret
  end

  def [](type, **kwargs)
    @store[type].find { |o| kwargs <= o }
  end

  def to_file(path)
    File.open(path, 'w') { |fp| fp.write(@store.to_json) }
  end

  def self.from_file(name)
    new JSON.parse(File.read(name), symbolize_names: true)
  end

  def who_often_take(the_book)
    t = @store[:Order].select do |o|
      (the_book.is_a?(Hash) ? o[:Book] : o[:Book][:title]) == the_book
    end
    q = t.group_by { |o| o[:Reader] }
    q.max_by { |_, v| v.count }&.first
  end

  def most_popular
    t = @store[:Order].group_by { |o| o[:Book] }
    t.max_by { |_, v| v.count }&.first
  end

  def how_many_ordered
    p = @store[:Order].group_by { |o| o[:Book] }
    top = p.sort_by { |_, v| -v.count }[0..2]
    top.map { |_, p2| p2 }.flatten.group_by { |o| o[:Reader] }.count
  end
end
