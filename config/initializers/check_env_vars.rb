if Rails.env.development? || Rails.env.test?
  raise 'MY_ACCOUNT_ID is not set' unless ENV['MY_ACCOUNT_ID']
  raise 'MY_PRIVATE_KEY is not set' unless ENV['MY_PRIVATE_KEY']
end
