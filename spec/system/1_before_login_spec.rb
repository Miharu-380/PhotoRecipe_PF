# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザログイン前のテスト' do
  describe 'index画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit index_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/index'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit index_path
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'Signupを押すと、新規登録画面に遷移する' do
        click_link 'Signup', match: :first
        is_expected.to eq '/users/sign_up'
      end
      it 'Guest Loginを押すと、ログイン画面に遷移する' do
        click_link 'Guest Login', match: :first
        is_expected.to eq '/index'
      end
      it 'Loginを押すと、ログイン画面に遷移する' do
        find('.login-test').click
        is_expected.to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「Signup」と表示される' do
        expect(page).to have_content 'Signup'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'usernameフォームが表示される' do
        expect(page).to have_field 'user[username]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'Sign upボタンが表示される' do
        expect(page).to have_button 'sign up'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[username]', with: Faker::Alphanumeric.alpha(number: 15)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button 'sign up!' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できたユーザの詳細画面になっている' do
        click_button 'sign up'
        expect(current_path).to eq '/index'
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「Log in」と表示される' do
        expect(page).to have_content 'Log in'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'log inボタンが表示される' do
        expect(page).to have_button 'log in'
      end
      it 'nameフォームは表示されない' do
        expect(page).not_to have_field 'user[name]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'log in!'
      end

      it 'ログイン後のリダイレクト先が、ログインしたユーザの詳細画面になっている' do
        expect(current_path).to eq '/index'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'log in'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'log in'
    end

    context 'ヘッダーの表示を確認' do
      it '投稿リンクが表示される: 左から1番目のリンクが「Make a Recipe!」である' do
        post_link = find_all('a')[0].native.inner_text
        expect(post_link).to match("Make a Recipe!")
      end
      it 'Mypageリンクが表示される: 左から4番目のリンクが「Mypage」である' do
        user_link = find_all('a')[3].native.inner_text
        expect(user_link).to match("Mypage")
      end
      it 'Logoutリンクが表示される: 左から5番目のリンクが「Logout」である' do
        logout_link = find_all('a')[4].native.inner_text
        expect(logout_link).to match("Logout")
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'log in'
      logout_link = find_all('a')[4].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link, match: :first
    end

    context 'ログアウト機能のテスト' do
      it 'ログアウト後のリダイレクト先が、トップ(index画面)になっている' do
        expect(current_path).to eq '/index'
      end
    end
  end
end