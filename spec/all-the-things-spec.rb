require 'spec_helper'
require 'all-the-things-2'

describe Thing do
  let(:jane) {Thing.new('Jane')}

  describe 'jane = Thing.new("Jane")' do
    describe 'jane.name' do
      it 'should be "Jane"' do
        expect(jane.name).to eq('Jane')
      end
    end
  end

  describe '#is_a' do
    describe 'is_a.woman (dynamic key)' do
      before { jane.is_a.woman }
      it 'jane.woman? should return true' do
        expect(jane.woman?).to eq(true)
      end
    end
  end

  describe '#is_not_a' do
    describe 'is_not_a.man (dynamic key)' do
      before { jane.is_not_a.man }
      it 'jane.man? should return false' do
        expect(jane.man?).to eq(false)
      end
    end
  end

  describe '#has' do
    describe 'jane.has(2).arms' do
      before do
        jane.has(2).arms
      end

      it 'should define an arms method that is an array' do
        expect(jane.arms.is_a?(Array)).to eq(true)
      end

      it 'should populate 2 new Thing instances within the array' do
        expect(jane.arms.size).to eq(2)
        expect(jane.arms.all? {|v| v.is_a? Thing}).to eq(true)
      end

      it 'should call each thing by its singular form (aka "arm")' do
        expect(jane.arms.first.name).to eq("arm")
      end

      it 'should have arm? == true for each arm instance' do
        expect(jane.arms.first.arm?).to eq(true)
      end

    describe 'jane.having(2).arms (alias)' do
      it 'should populate 2 new Thing instances within the array' do
        jane = Thing.new('Jane')
        jane.having(2).arms
        expect(jane.arms.size).to eq(2)
        expect(jane.arms.all? {|v| v.is_a? Thing}).to eq(true)
      end
    end

    describe 'jane.has(1).head' do
      before do
        jane.has(1).head
      end

      it 'should define head method that is a reference to a new Thing' do
        expect(jane.head.is_a?(Thing)).to eq(true)
      end

      it 'should name the head thing "head"' do
        expect(jane.head.name).to eq("head")
      end
    end

    describe 'jane.has(1).head.having(2).eyes' do
      before do
        jane.has(1).head.having(2).eyes
      end

      it 'should create 2 new things on the head' do
        expect(jane.head.eyes.size).to eq( 2)
        expect(jane.head.eyes.first.is_a?(Thing)).to eq(true)
      end

      it 'should name the eye things "eye"' do
        expect(jane.head.eyes.first.name).to eq('eye')
      end
    end
  end

  describe '#each' do
    describe 'jane.has(2).arms.each { having(5).fingers }' do
      before do
        jane.has(2).arms.each { having(5).fingers }
      end

      it 'should cause 2 arms to be created each with 5 fingers', :focus => true do
        binding.pry
        expect(jane.arms.first.fingers.size).to eq(5)
        expect(jane.arms.last.fingers.size).to eq(5)
      end
    end
  end

  describe '#is_the' do
    describe 'jane.is_the.parent_of.joe' do
      before do
        jane = Thing.new('Jane')
        jane.is_the.parent_of.joe
      end

      it 'should set jane.parent_of == "joe"' do
        expect(jane.parent_of).to eq('joe')
      end
    end

    describe 'ensure dynamic usages' do
      it 'should set any name and value (jane.is_the.???.????)' do
        jane.is_the.mother_of.kate
        expect(jane.mother_of).to eq('kate')

        jane.is_the.master_of.karate
        expect(jane.master_of).to eq('karate')
      end
    end
  end
end

  # describe '#being_the' do
  #     describe 'jane.has(1).head.having(2).eyes.each { being_the.color.blue }' do
  #       it "jane's eyes should both be blue" do
  #         jane.has(1).head.having(2).eyes.each { being_the.color.blue }
  #         expect(jane.head.eyes.all? {|e| e.color == 'blue'}).to eq(true)
  #       end
  #     end

  #   describe 'jane.has(2).eyes.each { being_the.color.blue.and_the.shape.round }' do
  #     it 'should allow chaining via the and_the method' do
  #       jane.has(2).eyes.each { being_the.color.blue.and_the.shape.round }
  #       expect(jane.eyes.first.color).to eq('blue')
  #       expect(jane.eyes.first.shape).to eq('round')
  #     end
  #   end

  #   describe 'jane.has(2).eyes.each { being_the.color.green.having(1).pupil.being_the.color.black }' do
  #     it 'should allow nesting by using having' do
  #       jane.has(2).eyes.each { being_the.color.green.having(1).pupil.being_the.color.black }
  #       expect(jane.eyes.first.color).to eq('green')
  #       expect(jane.eyes.first.pupil.color).to eq('black')
  #     end
  #   end
  # end

#   describe '#can' do
#     describe 'jane.can.speak {|phrase| "#{name} says: #{phrase}"}' do
#       before do
#         jane = Thing.new('Jane')
#         jane.can.speak do |phrase|
#           "#{name} says: #{phrase}"
#         end
#       end

#       it 'should create a speak method on the instance' do
#         expect(jane.speak('hi')).to eq("Jane says: hi")
#       end

#     end
#     describe 'jane.can.speak("spoke") {|phrase| "#{name} says: #{phrase}"}' do
#       before do
#         jane = Thing.new('Jane')
#         jane.can.speak('spoke') do |phrase|
#           "#{name} says: #{phrase}"
#         end

#         jane.speak('hi')
#       end

#       it 'should add a "spoke" attribute that tracks all speak call results' do
#         expect(jane.spoke).to eq(["Jane says: hi"])
#         jane.speak('goodbye')
#         expect(jane.spoke).to eq(["Jane says: hi", "Jane says: goodbye"])
#       end
#     end
#   end
end
