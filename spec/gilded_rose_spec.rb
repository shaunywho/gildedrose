
require 'gilded_rose'

describe GildedRose do

  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    it "changes the sell_in field by 1 with every call" do
      item = Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20)
      items = [item]
      item_sell_in_day0 = items[0].sell_in
      gilded_rose = GildedRose.new(items)
      gilded_rose.update_quality()
      item_sell_in_day1 = items[0].sell_in
      gilded_rose.update_quality()
      item_sell_in_day2 = items[0].sell_in
      gilded_rose.update_quality()
      item_sell_in_day3 = items[0].sell_in
      expect(item_sell_in_day1).to eq item_sell_in_day0-1
      expect(item_sell_in_day2).to eq item_sell_in_day0-2
      expect(item_sell_in_day3).to eq item_sell_in_day0-3
    end 


    context "when the object is not Aged Brie or Sulfuras or Backstage pass" do
      context "for singular items lists" do
        it "decreases the quality of objects by 1 before the sell by date" do
          item = Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20)
          item_quality_day0 = item.quality
          items = [item]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq item_quality_day0 -1

        end 

        it "decreases the quality of objects by 2 after the sell by date" do
          item = Item.new(name="+5 Dexterity Vest", sell_in=0, quality=20)
          item_quality_day0 = item.quality
          items = [item]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq item_quality_day0 -2

        end 
      end
      context "for multiple items lists" do
        it "decreases the quality of objects by 1 before the sell by date" do
          item1 = Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20)
          item2 = Item.new(name="Elixir of the Mongoose", sell_in=5, quality=7)
          item1_quality_day0 = item1.quality
          item2_quality_day0 = item2.quality
          items = [item1, item2]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq item1_quality_day0 -1
          expect(items[1].quality).to eq item2_quality_day0 -1

        end 

        it "decreases the quality of objects by 2 after the sell by date" do
          item1 = Item.new(name="+5 Dexterity Vest", sell_in=0, quality=20)
          item2 = Item.new(name="Elixir of the Mongoose", sell_in=0, quality=7)
          item1_quality_day0 = item1.quality
          item2_quality_day0 = item2.quality
          items = [item1, item2]
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq item1_quality_day0 -2
          expect(items[1].quality).to eq item2_quality_day0 -2

        end 
      end
    end

    context "when the object is an Aged Brie" do
      it "increases in quality by 1 before the sell by date" do
        brie = Item.new(name="Aged Brie", sell_in=2, quality=0)
        items = [brie]
        brie_quality_day0 = brie.quality
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq brie_quality_day0 +1

      end 

      it "increases in quality by 2 after the sell by date" do
        brie = Item.new(name="Aged Brie", sell_in=0, quality=0)
        items = [brie]
        brie_quality_day0 = brie.quality
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq brie_quality_day0 +2

      end 

      context "does not increase in quality after it has hit 50" do
        it "starting from a quality of 48" do
          brie = Item.new(name="Aged Brie", sell_in=0, quality=48)
          items = [brie]
          brie_quality_day0 = brie.quality
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq brie_quality_day0 +2

        end 
        it "starting from a quality of 49" do
          brie = Item.new(name="Aged Brie", sell_in=0, quality=49)
          items = [brie]
          brie_quality_day0 = brie.quality
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq brie_quality_day0 +1

        end 

      end 


    end 

    context "when the object is a Sulfuras" do
      it "it does not increase in quality before the sell by date" do
        sulfuras = Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=2, quality=0)
        items = [sulfuras]
        sulfuras_quality_day0 = sulfuras.quality
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq sulfuras_quality_day0

      end 

      it "it does not increase in quality after the sell by date" do
        sulfuras = Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=0)
        items = [sulfuras]
        sulfuras_quality_day0 = sulfuras.quality
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq sulfuras_quality_day0

      end 

    end 

    context "when the object is a Backstage pass" do
      it "it increases in quality by 1 when the sell by date is 10 days or more" do
        backstage_pass = Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=20, quality=0)
        items = [backstage_pass]
        backstage_pass_quality_day0 = backstage_pass.quality
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq backstage_pass_quality_day0 +1

      end 

      it "it increases in quality by 2 when the sell by date is 10 days or less" do
        backstage_pass = Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=0)
        items = [backstage_pass]
        backstage_pass_quality_day0 = backstage_pass.quality
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq backstage_pass_quality_day0 +2

      end

      it "it increases in quality by 2 when the sell by date is between 6-10 days" do
        backstage_pass = Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=0)
        items = [backstage_pass]
        backstage_pass_quality_day0 = backstage_pass.quality
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq backstage_pass_quality_day0 +2

      end

      it "it increases in quality by 3 when the sell by date is between 1-5 days" do
        backstage_pass = Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=0)
        items = [backstage_pass]
        backstage_pass_quality_day0 = backstage_pass.quality
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq backstage_pass_quality_day0 +3

      end

      it "it drops in quality to 0 when the sell by date 0 or less" do
        backstage_pass = Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=0, quality=48)
        items = [backstage_pass]
        backstage_pass_quality_day0 = backstage_pass.quality
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0

      end

      it "its quality does not exceed 50" do
        backstage_pass = Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=3, quality=49)
        items = [backstage_pass]
        backstage_pass_quality_day0 = backstage_pass.quality
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 50

      end

    end 

    context "For a conjured objects: " do

      context "when the object is a Sulfuras" do
        it "it does not increase in quality before the sell by date" do
          sulfuras = Item.new(name="Conjured Sulfuras, Hand of Ragnaros", sell_in=2, quality=0)
          items = [sulfuras]
          sulfuras_quality_day0 = sulfuras.quality
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq sulfuras_quality_day0
  
        end 
  
        it "it does not increase in quality after the sell by date" do
          sulfuras = Item.new(name="Conjured Sulfuras, Hand of Ragnaros", sell_in=-1, quality=0)
          items = [sulfuras]
          sulfuras_quality_day0 = sulfuras.quality
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq sulfuras_quality_day0
  
        end 
  
      end 
      context "when the object is a Backstage pass" do
        it "it increases in quality by 2 when the sell by date is 10 days or more" do
          backstage_pass = Item.new(name="Conjured Backstage passes to a TAFKAL80ETC concert", sell_in=20, quality=0)
          items = [backstage_pass]
          backstage_pass_quality_day0 = backstage_pass.quality
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq backstage_pass_quality_day0 +2
  
        end 
  
  
        it "it increases in quality by 4 when the sell by date is between 6-10 days" do
          backstage_pass = Item.new(name="Conjured Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=0)
          items = [backstage_pass]
          backstage_pass_quality_day0 = backstage_pass.quality
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq backstage_pass_quality_day0 +4
  
        end
  
        it "it increases in quality by 6 when the sell by date is between 1-5 days" do
          backstage_pass = Item.new(name="Conjured Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=0)
          items = [backstage_pass]
          backstage_pass_quality_day0 = backstage_pass.quality
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq backstage_pass_quality_day0 +6
  
        end
  
        it "it drops in quality to 0 when the sell by date 0 or less" do
          backstage_pass = Item.new(name="Conjured Backstage passes to a TAFKAL80ETC concert", sell_in=0, quality=48)
          items = [backstage_pass]
          backstage_pass_quality_day0 = backstage_pass.quality
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 0
  
        end
  
        it "its quality does not exceed 50" do
          backstage_pass = Item.new(name="Conjured Backstage passes to a TAFKAL80ETC concert", sell_in=3, quality=49)
          items = [backstage_pass]
          backstage_pass_quality_day0 = backstage_pass.quality
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq 50
  
        end
  
      end 

      context "when the object is an Aged Brie" do
        it "increases in quality by 2 before the sell by date" do
          brie = Item.new(name="Conjured Aged Brie", sell_in=2, quality=0)
          items = [brie]
          brie_quality_day0 = brie.quality
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq brie_quality_day0 +2
  
        end 
  
        it "increases in quality by 4 after the sell by date" do
          brie = Item.new(name="Conjured Aged Brie", sell_in=0, quality=0)
          items = [brie]
          brie_quality_day0 = brie.quality
          GildedRose.new(items).update_quality()
          expect(items[0].quality).to eq brie_quality_day0 +4
  
        end 
      end


    end 


  end

end
