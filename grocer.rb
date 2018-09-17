def consolidate_cart(cart)
  new_cart = cart.reduce(&:merge)
  new_cart.each do |k, v|
    v[:count] = cart.count { |i| i == { k => v } }
  end
end

# @param cart [Array]
# @param coupons [Hash]
def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name = coupon[:item]
    cart_item = cart[item_name]
    next unless cart_item

    next if cart_item[:count] < coupon[:num]

    cart_item[:count] -= coupon[:num]
    cart.delete(cart_item) if cart_item[:count] <= 0

    # the output format doesn't really acount for multiple coupons for the
    # same item with different values
    coupon_item = (cart["#{item_name} W/COUPON"] ||= {
      price: coupon[:cost],
      clearance: cart_item[:clearance],
      count: 0
    })
    coupon_item[:count] += 1
  end
  cart
end

def apply_clearance(cart)
  cart.each do |_, v|
    v[:price] = (v[:price] * 0.8).round 2 if v[:clearance]
  end
end

def checkout(cart, coupons)
  cart = consolidate_cart cart
  puts "2 #{cart}"
  apply_coupons cart, coupons
  puts "3 #{cart}"
  apply_clearance cart
  puts "4 #{cart}"
  total = 0
  cart.each { |k, v| total += v[:price] * v[:count] }
  total = (total * 0.9).round 2 if total > 100
  total
end

checkout [{"BEETS"=>{:price=>2.5, :clearance=>false, :count=>1}}],[]
