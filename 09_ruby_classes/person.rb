class Person
  attr_reader :firstname, :lastname

  def initialize(personal_identity_number:, firstname:, lastname:)
    @personal_identity_number = personal_identity_number
    @firstname = firstname
    @lastname = lastname
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  def birthdate
    Date.strptime(date_str, "%y%m%d")
  rescue ArgumentError
    fail "Wrong date error"
  end

  private
  
  attr_reader :personal_identity_number

  def date_str
    personal_identity_number[/\A(?<date>\d{8})-\d{6}\z/, :date]
  end
end