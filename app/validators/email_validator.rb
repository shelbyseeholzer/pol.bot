class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value =~ URI::MailTo::EMAIL_REGEXP

    record.errors.add(attribute, (options[:message] || 'is not a valid email'))
  end
end
#
# class Email < ApplicationRecord
# end

# class EmailValidator < ActiveModel::EachValidator
#   def validate_each(record, attribute, value)
#     return if value =~ URI::MailTo::EMAIL_REGEXP

#     record.errors.add(attribute, (options[:message] || 'is not an email'))

#     validates :email, format: { with: /\A(.+)@(.+)\z/, message: 'Email invalid' },
#                       uniqueness: { case_sensitive: false },
#                       length: { minimum: 4, maximum: 254 }
#   end
# end

# EMAIL_REGEX: /\A(.+)@(.+)\z/

# def valid_email?(email)
#   email =~ EMAIL_REGEX
# end

# puts valid_email?("john.doe@domain.com") ? "Valid Email" ∶ "Invalid Email"
