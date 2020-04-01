require 'date'

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

  class NotADateError < StandardError; end

  def birthdate
    Date.strptime(date_str)
  rescue ArgumentError
    raise NotADateError, "Wrong date in #{date_str}"
  end

  private

  attr_reader :personal_identity_number

  def date_str
    personal_identity_number[/\A(?<date>\d{6})-\d{4}\z/, :date]
  end
end