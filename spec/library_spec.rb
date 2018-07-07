# coding: utf-8

require_relative '../library'

# ugly utility functions ¯\_(ツ)_/¯
def initialize_vars(lib)
  a = lib.add(:Author, 'asd', 'dsa')
  vars = {}
  vars[:b1] = lib.add(:Book, 'b1', a)
  vars[:b2] = lib.add(:Book, 'b2', a)
  vars[:b3] = lib.add(:Book, 'b3', a)
  vars[:b4] = lib.add(:Book, 'b4', a)
  vars[:b5] = lib.add(:Book, 'b5', a)
  vars[:r1] = lib.add(:Reader, '1', '1', '1', '1', '1')
  vars[:r2] = lib.add(:Reader, '2', '2', '2', '2', '3')
  vars[:r3] = lib.add(:Reader, '3', '3', '3', '3', '3')
  vars[:r4] = lib.add(:Reader, '4', '4', '4', '4', '4')
  vars
end

def fill_lib(lib, vars)
  [
    %i[b1 r1],
    %i[b1 r1],
    %i[b2 r2],
    %i[b2 r2],
    %i[b3 r3],
    %i[b3 r3],
    %i[b4 r4],
    %i[b4 r4],
    %i[b5 r4],
    %i[b5 r1],
    %i[b5 r2],
    %i[b5 r3]
  ].map { |b, r| lib.add(:Order, vars[b], vars[r]) }
  lib
end

RSpec.describe Lib do
  lib1 = Lib.new
  vars = initialize_vars(lib1)
  vars.map { |k, v| let(k) { v } }
  let(:lib) { fill_lib(lib1, vars) }

  it 'properly calculates most eager reader of certain book' do
    [b1, b2, b3, b4].zip([r1, r2, r3, r4]).map do |b, r|
      expect(lib.who_often_take(b) == r).to be_truthy
    end
  end

  it 'finds how many reader have taken three most popular books' do
    expect(lib.how_many_ordered).to eq(4)
  end

  it 'knows most popular book' do
    expect(lib.most_popular).to eq(b5)
  end

  context 'empty' do
    let(:lib) { Lib.new }

    it 'shows 0 on #how_many_ordered call for empty library' do
      expect(lib.how_many_ordered).to eq(0)
    end

    it 'no most popular book' do
      expect(lib.most_popular).to be_nil
    end
  end

  context 'books only' do
    lib2 = Lib.new
    filtered1 = vars.select { |k, _| k.to_s.match(/^b/) }
    filtered1.map { |k, v| let(k) { v } }
    let(:lib2) { lib2 }

    it 'knows there are no readers to take a any book' do
      [b1, b2, b3, b4].map do |b|
        expect(lib2.who_often_take(b)).to be_nil
      end
    end

    it 'knows there are no reades to form #how_many_ordered' do
      expect(lib2.how_many_ordered).to eq(0)
    end

    it 'knows there are no readers to make any book most popular' do
      expect(lib2.most_popular).to be_nil
    end
  end

  context 'readers only' do
    lib3 = Lib.new
    filtered2 = vars.select { |k, _| k.to_s.match(/^r/) }
    filtered2.map { |k, v| let(k) { v } }
    let(:lib3) { lib3 }

    it 'knows there are no books to form #how_many_ordered' do
      expect(lib3.how_many_ordered).to eq(0)
    end

    it 'knows there are no books to be most popular' do
      expect(lib3.most_popular).to be_nil
    end
  end
end
