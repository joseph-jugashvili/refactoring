class Usual < Card
  BALANCE = 50
  PART_WITHDRAW_TAX = 0.05
  PUT_TAX = 0.02
  SEND_TAX = 20

  def withdraw_tax(amount)
    amount * PART_WITHDRAW_TAX
  end

  def put_tax(amount)
    amount * PUT_TAX
  end
end
