require "gilded_rose"
require "gilded_rose_old"
require "deep_clone"


describe "Comparing the refactored GildedRose with the old one" do



  items_name_arr = ["+5 Dexterity Vest","Aged Brie","Elixir of the Mongoose","Sulfuras, Hand of Ragnaros","Backstage passes to a TAFKAL80ETC concert", "Mana Cake"]
  sell_in_arr = Array(-20..20)
  num_of_items_arr = Array(1..100)
  num_of_updates_arr = Array(1..100)
  quality_arr = Array(0..50)
  num_of_tests_arr = Array(1..1000)
  num_of_tests_arr.each do |test|
    num_of_updates = num_of_updates_arr.sample()
    num_of_items = num_of_items_arr.sample()

    it "Test #{test}: the item objects match when updated #{num_of_updates} when using #{num_of_items} items, " do
      items_init = []
      (1..num_of_items).each{|i| items_init.append(Item.new(name = items_name_arr.sample(), sell_in = sell_in_arr.sample(), quality = quality_arr.sample()))}
      items1 = DeepClone.clone(items_init)
      items2 = DeepClone.clone(items_init)
      gilded_rose = GildedRose.new(items1)
      gilded_rose_old = GildedRoseOld.new(items2)
      (1..num_of_updates).each do |i| gilded_rose_old.update_quality()
        gilded_rose.update_quality()
      end 
      items_init.zip(items1,items2).each do |items|
        expect(items[1]).to have_attributes(:name => items[2].name, :sell_in => items[2].sell_in, :quality => items[2].quality)
        expect(items[0]).not_to eq(items[1])
        expect(items[0]).not_to eq(items[2])
      end 

  end 
   




  end 
end 