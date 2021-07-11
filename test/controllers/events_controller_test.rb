require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  test "自分が作ったイベントは削除できる" do
    event_owner = FactoryBot.create(:user) #FactoryBot.createでUserオブジェクトを作りそれをevent_ownerに代入する
    event = FactoryBot.create(:event, owner: event_owner) #FactoryBot.createでEventオブジェクト（owner:情報は上記で作成したevent_owner、つまり、Userオブジェクトとなる）をeventに代入
    sign_in_as event_owner #イベントオーナというのは上記で生成したUserオブジェクトである。このUserとしてログインする
    assert_difference("Event.count",-1) do #これは変化の差を検証するもので、ブロック処理を実行前のEvent.countと実行後のEvent.countの変化が-１かどうか
      delete event_url(event) #上記で生成したページを削除する(event_url(event)ということはevent/:idのページを作成するということ）
    end
  end

  test "他の人が作ったイベントは削除できない" do
    event_owner = FactoryBot.create(:user)
    #まずはevent_owner に　作成したUserオブジェクトを代入します。
    event = FactoryBot.create(:event, owner: event_owner)
    #そして、eventに作成したイベントを代入してイベントownerは生成したUserとしています

    sign_in_user = FactoryBot.create(:user)
    #ここで、ログインするのはまた無関係の新しユーザーです。
    #新しいユーザーをsign_in_userに代入します。

    sign_in_as sign_in_user
    #ここで上記で生成した新しいユーザーでログインをします。
    assert_difference("Event.count",0) do
      #今回は削除できない（つまり、別のユーザーは削除できない）ということが正しいので、変化は０になります

      assert_raises(ActiveRecord::RecordNotFound) do
        #ブロック内のエラーがActiveRecord::RecordNotFoundであればOkというテストです。
        #これはエラーが出ることが正しいという検証なので、エラーが出てもエラーにはならないのです
        delete event_url(event)
        #デリートしますがエラーとなりActiveRecord::RecordNotFoundというエラーがでます。
      end
    end
  end
  
end
