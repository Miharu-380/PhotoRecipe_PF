require 'rails_helper'

describe 'ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  image_path = Rails.root.join('spec/fixtures/photo_sample.jpg')
  image2_path = Rails.root.join('spec/fixtures/iPhone_coffee.jpg')

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'log in'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済' do
      subject { current_path }

      it 'Mypageを押すと、自分のユーザ詳細画面に遷移する' do
        mypage_link = find_all('a')[3].native.inner_text
        mypage_link = mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link mypage_link, match: :first
        is_expected.to eq '/users/' + user.id.to_s
      end
      it 'Rankingを押すと、いいねランキング画面に遷移する' do
        ranking_link = find_all('a')[2].native.inner_text
        ranking_link = ranking_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link ranking_link, match: :first
        is_expected.to eq '/posts/weekly_rank'
      end
      it 'Timelineを押すと、タイムライン画面に遷移する' do
        timeline_link = find_all('a')[1].native.inner_text
        timeline_link = timeline_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link timeline_link, match: :first
        is_expected.to eq '/users/' + user.id.to_s + '/timeline'
      end
      it 'Make a Recipe!を押すと投稿画面に遷移する' do
        post_link = find_all('a')[0].native.inner_text
        post_link = post_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link post_link, match: :first
        is_expected.to eq '/posts/new'
      end
    end
  end

  describe '投稿一覧のテスト' do
    before do
      visit index_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/index'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: post_path(post)
        expect(page).to have_link '', href: post_path(other_post)
      end
    end
  end

  describe 'Mypageのテスト' do
    before do
      visit user_path(user)
    end

    context 'Mypageの確認' do
      it '自分の名前と紹介文が表示される' do
        expect(page).to have_content user.username
        expect(page).to have_content user.introduction
      end
      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
    end
  end

  describe '投稿ページのテスト' do
    before do
      visit new_post_path
    end

    context '投稿' do
      it '画像投稿フォームが表示される' do
        expect(page).to have_field 'post[image]'
      end
      it 'titleフォームが表示される' do
        expect(page).to have_field 'post[title]'
      end
      it 'titleフォームに値が入っていない' do
        expect(find_field('post[title]').text).to be_blank
      end
      it 'bodyフォームが表示される' do
        expect(page).to have_field 'post[body]'
      end
      it 'bodyフォームに値が入っていない' do
        expect(find_field('post[body]').text).to be_blank
      end
      it 'Make a Recipe!ボタンが表示される' do
        expect(page).to have_button 'Make a Recipe!'
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'post[title]', with: Faker::JapaneseMedia::StudioGhibli.movie
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
        attach_file('post[image]', image_path, make_visible: true)
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button 'Make a Recipe!' }.to change(user.posts, :count).by(1)
      end
      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button 'Make a Recipe!'
        expect(current_path).to eq '/index'
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it 'ユーザ画像・名前のリンク先が正しい' do
        expect(page).to have_link post.user.username, href: user_path(post.user)
      end
      it '投稿画像が表示される' do
        expect(page).to have_selector("img[src$='photo_sample.jpg']")
      end
      it '投稿のtitleが表示される' do
        expect(page).to have_content post.title
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link '', href: edit_post_path(post)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '', href: post_path(post)
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        find('.edit-post').click
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        find('.delete-post').click
      end

      it '正しく削除される' do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/index'
      end
    end
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
      it 'title編集フォームが表示される' do
        expect(page).to have_field 'post[title]', with: post.title
      end
      it 'body編集フォームが表示される' do
        expect(page).to have_field 'post[body]', with: post.body
      end
      it 'Re: Make a Recipe!ボタンが表示される' do
        expect(page).to have_button 'Re: Make a Recipe!'
      end
    end

    context '編集成功のテスト' do
      before do
        @post_old_image = post.image
        @post_old_title = post.title
        @post_old_body = post.body
        attach_file('post[image]', image2_path, make_visible: true)
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 4)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 19)
        click_button 'Re: Make a Recipe!'
      end

      it '画像が正しく更新される' do
        expect(post.reload.image).not_to eq @post_old_image
      end
      it 'titleが正しく更新される' do
        expect(post.reload.title).not_to eq @post_old_title
      end
      it 'bodyが正しく更新される' do
        expect(post.reload.body).not_to eq @post_old_body
      end
      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
    end
  end

  describe 'Mypageのテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '投稿一覧に自分の投稿imageが表示され、リンクが正しい' do
        expect(page).to have_selector("img[src$='photo_sample.jpg']"), href: post_path(post)
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_post.image
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '名前編集フォームに自分のユーザーネームが表示される' do
        expect(page).to have_field 'user[username]', with: user.username
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it '編集内容を保存ボタンが表示される' do
        expect(page).to have_button '編集内容を保存'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_username = user.username
        @user_old_intrpduction = user.introduction
        fill_in 'user[name]', with: Faker::Name.first_name
        fill_in 'user[username]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[introduction]', with: Faker::JapaneseMedia::StudioGhibli.quote
        click_button '編集内容を保存'
      end

      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end
