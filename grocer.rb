def consolidate_cart(cart)
  new_cart = cart.reduce(&:merge)              # => {"TEMPEH"=>{:price=>3.0, :clearance=>true}, "PEANUTBUTTER"=>{:price=>3.0, :clearance=>true}, "ALMONDS"=>{:price=>9.0, :clearance=>false}}, {"AVOCADO"=>{:price=>3.0, :clearance=>true}, "KALE"=>{:price=>3.0, :clearance=>false}}
  new_cart.each do |k, v|                      # => {"TEMPEH"=>{:price=>3.0, :clearance=>true}, "PEANUTBUTTER"=>{:price=>3.0, :clearance=>true}, "ALMONDS"=>{:price=>9.0, :clearance=>false}}, {"AVOCADO"=>{:price=>3.0, :clearance=>true}, "KALE"=>{:price=>3.0, :clearance=>false}}
    v[:count] = cart.count {|i| i == {k => v}}  # => 1, 1, 1, 2, 1
  end
end

# @param cart [Array]
# @param coupons [Hash]
def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name = coupon[:item]
    cart_item = cart[item_name]
    next unless cart_item
    cart_item[:count] -= coupon[:num]
    if cart_item[:count] <= 0
      cart.delete(cart_item)
    end

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
  # code here
end

def checkout(cart, coupons)
  # code here
end
