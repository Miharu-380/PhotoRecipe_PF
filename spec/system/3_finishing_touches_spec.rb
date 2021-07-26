require 'rails_helper'

describe '仕上げのテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  describe 'サクセスメッセージのテスト' do
    subject { page }

    it 'ユーザ新規登録成功時' do
      visit new_user_registration_path
      fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
      fill_in 'user[username]', with: Faker::Lorem.characters(number: 7)
      fill_in 'user[email]', with: 'a' + user.email # 確実にuser, other_userと違う文字列にするため
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button 'sign up!'
      is_expected.to have_content 'アカウント登録が完了しました。'
    end
    it 'ユーザログイン成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'log in!'
      is_expected.to have_content 'ログインしました。'
    end
    it 'ユーザログアウト成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'log in!'
      find('.logout-test').click
      is_expected.to have_content 'ログアウトしました。'
    end
    it 'ユーザのプロフィール情報更新成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'log in!'
      visit edit_user_path(user)
      click_button '編集内容を保存'
      is_expected.to have_content 'ユーザー情報を更新しました。'
    end
    it '投稿データの更新成功時' do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'log in!'
      visit edit_post_path(post)
      click_button 'Re: Make a Recipe!'
      is_expected.to have_content '投稿を更新しました'
    end
  end

  describe '処理失敗時のテスト' do
    context 'ユーザ新規登録失敗: nameを21文字にする' do
      before do
        visit new_user_registration_path
        @name = Faker::Lorem.characters(number: 21)
        @username = Faker::Lorem.characters(number: 10)
        @email = 'a' + user.email # 確実にuser, other_userと違う文字列にする
        fill_in 'user[name]', with: @name
        fill_in 'user[username]', with: @username
        fill_in 'user[email]', with: @email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '新規登録されない' do
        expect { click_button 'sign up!' }.not_to change(User.all, :count)
      end
      it '新規登録画面を表示しており、フォームの内容が正しい' do
        click_button 'sign up!'
        expect(page).to have_content 'Sign up'
        expect(page).to have_field 'user[name]', with: @name
        expect(page).to have_field 'user[username]', with: @username
        expect(page).to have_field 'user[email]', with: @email
      end
      it 'バリデーションエラーが表示される' do
        click_button 'sign up!'
        expect(page).to have_content "お名前は20文字以内で入力してください"
      end
    end

    context 'ユーザのプロフィール情報編集失敗: nameを21文字にする' do
      before do
        @name = Faker::Lorem.characters(number: 21)
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'log in!'
        visit edit_user_path(user)
        fill_in 'user[name]', with: @name
        click_button '編集内容を保存'
      end

      it '更新されない' do
        expect(user.reload.name).to have_content user.name
      end
      it 'ユーザ編集画面を表示しており、フォームの内容が正しい' do
        expect(page).to have_field 'user[name]', with: @name
      end
      it 'バリデーションエラーが表示される' do
        expect(page).to have_content "お名前は20文字以内で入力してください"
      end
    end
  end

  describe 'ログインしていない場合のアクセス制限のテスト: アクセスできず、ログイン画面に遷移する' do
    subject { current_path }

    it 'ユーザ詳細画面' do
      visit user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it 'ユーザ情報編集画面' do
      visit edit_user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it '投稿詳細画面' do
      visit post_path(post)
      is_expected.to eq '/users/sign_in'
    end
    it '投稿編集画面' do
      visit edit_post_path(post)
      is_expected.to eq '/users/sign_in'
    end
  end

  describe '他人の画面のテスト' do
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'log in!'
    end

    describe '他人の投稿詳細画面のテスト' do
      before do
        visit post_path(other_post)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/posts/' + other_post.id.to_s
        end
        it 'ユーザ画像・名前のリンク先が正しい' do
          expect(page).to have_link other_post.user.username, href: user_path(other_post.user)
        end
        it '投稿のtitleが表示される' do
          expect(page).to have_content other_post.title
        end
        it '投稿のbodyが表示される' do
          expect(page).to have_content other_post.body
        end
        it '投稿の編集リンクが表示されない' do
          expect(page).not_to have_selector('.edit-post')
        end
        it '投稿の削除リンクが表示されない' do
          expect(page).not_to have_selector('.delete-post')
        end
      end
    end

    context '他人の投稿編集画面' do
      it '遷移できず、投稿一覧画面にリダイレクトされる' do
        visit edit_post_path(other_post)
        expect(current_path).to eq '/index'
      end
    end

    describe '他人のユーザ詳細画面のテスト' do
      before do
        visit user_path(other_user)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/users/' + other_user.id.to_s
        end
        it '自分の投稿は表示されない' do
          expect(page).not_to have_content post.image
        end
      end
    end

    context '他人のユーザ情報編集画面' do
      it '遷移できず、index画面にリダイレクトされる' do
        visit edit_user_path(other_user)
        expect(current_path).to eq '/index'
      end
    end
  end
end
