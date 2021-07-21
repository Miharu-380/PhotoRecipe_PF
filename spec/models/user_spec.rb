# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Userモデルのテスト', type: :model do

  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '20文字以下であること: 21文字は×' do
        user.name = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
    end

    context 'usernameカラム' do
      it '空欄でないこと' do
        user.username = ''
        is_expected.to eq false
      end
      it '15文字以下であること: 16文字は×' do
        user.username = Faker::Alphanumeric.alpha(number: 16)
        is_expected.to eq false
      end
      it '一意性があること' do
        user.username = other_user.username
        is_expected.to eq false
      end
    end

    context 'emailカラム' do
      it '空欄でないこと' do
        user.email = ''
        is_expected.to eq false
      end
      it 'emailに@が含まれていない場合登録できない' do
        user.email = 'hogehoge.com'
        is_expected.to eq false
      end
      it '一意性があること' do
        user.email = other_user.email
        is_expected.to eq false
      end
    end

    context 'passwordカラム' do
      it '空欄でないこと' do
        user.password = ''
        is_expected.to eq false
      end
      it '6文字以上であること: 5文字は×' do
        user.password = Faker::Lorem.characters(number: 5)
        is_expected.to eq false
      end
      it '6文字以上であること: 6文字は○' do
        user.password = Faker::Lorem.characters(number: 6)
        is_expected.to eq true
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Postモデルとの関係' do
      it '1:Nとなっている' do
        expect(User.reflect_on_association(:posts).macro).to eq :has_many
      end
    end
  end
end
