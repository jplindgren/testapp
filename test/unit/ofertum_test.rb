require 'test_helper'

#check for migrations + load schema
#rake db:test:prepare

#run db:test:prepare + run all tests
#rake test

#to run individual test file
#ruby -Itest test/unit/ofertum_test.rb

#to run individual tests
#ruby -Itest test/unit/ofertum_test.rb -n test_the_truth

class OfertumTest < ActiveSupport::TestCase

   test "the truth" do
     assert true
   end

   test "valid with all attributes" do
   	oferta = oferta(:mba1)
   	assert oferta.valid?, "Oferta is not valid"
   end

   test "invalid description gives error message" do
   	oferta = oferta(:mba1)
   	oferta.description = nil
   	oferta.valid?
   	assert_match /can't be blank/, oferta.errors[:description].join, "Presence error not found on oferta"
   end

   def test_invalid_wihtout_description
   	oferta = Ofertum.new
   	assert !oferta.valid?, "Description is not being validated"
   end
end
