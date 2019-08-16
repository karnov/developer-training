class Person
  attr_reader :firstname, :lastname
  def initialize(cpr_number, firstname, lastname, phonenumber)
    @cpr_number = cpr_number
    @firstname = firstname
    @lastname = lastname
    @phonenumber = phonenumber
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  CPR_REGEX = /()/
  def birthdate
    
    Date.new(year, month, day)
  end

  private
  
  attr_reader :cpr_number

  def cpr_date_str
    cpr_number[/\A(?<date>\d{8})-\d{6}\z/, :date]
  end

  def cpr_date
    Date.strptime(cpr_date_str, "")
  rescue ArgumentError
    fail "Wrong date error"
  end
end