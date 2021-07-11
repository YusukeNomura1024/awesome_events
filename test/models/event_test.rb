require "test_helper"

class EventTest < ActiveSupport::TestCase
  test '＃created_by? owner_id と 引数の＃idが同じときmock使って' do
    event = FactoryBot.create(:event)
    user = MiniTest::Mock.new.expect(:id, event.owner_id)
    assert_equal(true, event.created_by?(user))
    user.verify
  end

  test '＃created_by? owner_id と 引数の＃idが同じときstub使って' do
    event = FactoryBot.create(:event)
    user = User.new
    user.stub(:id,event.owner_id) do
      assert_equal(true,event.created_by?(user))
    end
  end

  test '＃created_by? owner_idと引数の＃idが同じとき' do
    event = FactoryBot.create(:event)
    assert_equal(true,event.created_by?(event.owner))
    #created_by?の引数としてevent.ownerを渡していますので、当然turueですよね
  end

  test 'created_by owner_idと引数のidが異なるとき' do
    event = FactoryBot.create(:event)
    another_user = FactoryBot.create(:user)
    assert_equal(false,event.created_by?(another_user))
    #ここでは別のユーザーをcreated_by?の引数にしているからfalseになるはずです
  end

  test 'created_by? 引数がnilなとき' do
    event = FactoryBot.create(:event)
    assert_equal(false,event.created_by?(nil))
    #ここではnilを渡しているのでfalseになるはずです。nilをテストするのは何らかの手違いによりnilを引数にした場合に間違って通らないように確認をしている。
  end

  test 'start_at_should_be_before_end_at validtion OK' do
    start_at = rand(1..30).days.from_now
    end_at = start_at + rand(1..30).hours
    event = FactoryBot.build(:event,start_at: start_at, end_at: end_at)
    event.valid?
    assert_empty(event.errors[:start_at])
  end

  test 'start_at_should_be_before_end_at validtion error' do
    start_at = rand(1..30).days.from_now
    end_at = start_at - rand(1..30).hours
    event = FactoryBot.build(:event,start_at: start_at, end_at: end_at)
    event.valid?
    assert_not_empty(event.errors[:start_at])
  end


end
