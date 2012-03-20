module FormErrorHelper

  def flash_error_for(attr)
    errors[attr].first
  end

  def has_error_on?(attr)
    !errors[attr].empty? ? 'error' : ''
  end

end

module PhoneNumberFormater

  def convert_phone_format
    phone.gsub!(/\s/,'')
    phone.gsub!(/\A\+421/,'')
    phone.gsub!(/\D/,'')
    phone.gsub!(/\A00421/,'')
    phone.gsub!(/\A0/,'')
    phone.insert(0,'+421')
  end

end
