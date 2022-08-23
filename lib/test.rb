require_relative "./gilded_rose_refactored"



sulfuras = Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=2, quality=0)

items = [sulfuras]
sulfuras_quality_day0 = sulfuras.quality
GildedRose.new(items).update_quality()
p sulfuras.quality