PERSONAL_IDENITY_REGEX = %r{\A(?<date>\d{6})-\d{4}}

date_str = "811228-9874"[PERSONAL_IDENITY_REGEX, :date]

Date.strptime(date_str, "%d%m%y")