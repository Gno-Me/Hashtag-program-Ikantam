# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    username "MyString"
    description "MyText"
    api_user_id 1
    api_post_id 1
    posted_at "2014-07-02"
  end
end
