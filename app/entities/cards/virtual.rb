class Virtual < Card
  BALANCE = 150
  PART_WITHDRAW_TAX = 0.88
  PUT_TAX = 1
  SEND_TAX = 1

  def withdraw_tax(amount)
    amount * PART_WITHDRAW_TAX
  end

  def put_tax(_amount)
    PUT_TAX
  end

  def send_tax
    SEND_TAX
  end
end
