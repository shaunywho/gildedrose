class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      c_factor = item.name.include?("Conjured") ? 2 : 1 # conjure factor ages changes the qualities twice as fast
      if item.name.include?("Sulfuras, Hand of Ragnaros")
        self.sulfuras_quality_updater(item, c_factor)
      elsif item.name.include?("Aged Brie")
        self.aged_brie_quality_updater(item, c_factor)   
      elsif item.name.include?("Backstage passes to a TAFKAL80ETC concert")
        self.backstage_pass_quality_updater(item, c_factor)
      else
        self.normal_item_quality_updater(item, c_factor)
      end

    end 
  end

  def normal_item_quality_updater(item, c_factor)
    item.sell_in>0 ? item.quality-= c_factor*1 : item.quality-= c_factor*2
    item.quality = item.quality.clamp(0,50)
    item.sell_in-=1
  end

  def sulfuras_quality_updater(item, c_factor)
  end

  def aged_brie_quality_updater(item, c_factor)
    item.sell_in>0 ? item.quality+= c_factor*1 : item.quality+= c_factor*2
    item.quality = item.quality.clamp(0,50)
    item.sell_in-=1
  end 
  
  def backstage_pass_quality_updater(item, c_factor)
    if item.sell_in>10
      item.quality+= c_factor*1
    elsif item.sell_in <= 10 && item.sell_in >5
      item.quality+= c_factor*2
    else
      item.sell_in>0 ? item.quality+=  c_factor*3 : item.quality=0
    end 
    item.quality = item.quality.clamp(0,50)
    item.sell_in-= c_factor*1
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end



