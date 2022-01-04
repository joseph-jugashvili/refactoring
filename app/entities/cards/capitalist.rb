class Capitalist < Card
  BALANCE = 100
  PART_WITHDRAW_TAX = 0.04
  PUT_TAX = 10
  SEND_TAX = 0.1

  def withdraw_tax(amount)
    amount * PART_WITHDRAW_TAX
  end
end
