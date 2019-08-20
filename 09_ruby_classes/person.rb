class Person
  attr_reader :firstname, :lastname

  def initialize(cpr_number, firstname, lastname)
    @cpr_number = cpr_number
    @firstname = firstname
    @lastname = lastname
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  def birthdate
    Date.strptime(cpr_date_str, "%d%m%Y")
  rescue ArgumentError
    fail "Wrong date error"
  end

  private
  
  attr_reader :cpr_number

  def cpr_date_str
    cpr_number[/\A(?<date>\d{8})-\d{6}\z/, :date]
  end
end